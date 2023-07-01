-- {"id":6118,"ver":"2.0.9","libVer":"1.0.0","author":"TechnoJo4","dep":["url>=1.0.0"]}

local baseURL = "https://www.readlightnovel.me"
local qs = Require("url").querystring
 
local function shrinkURL(url)
	return url:gsub(".-readlightnovel%.me", "")
end

local function expandURL(url)
	return baseURL .. url
end

local text = function(v) return v:text() end

local function parseTop(doc)
	return map(doc:select("div.top-novel-block"), function(v)
		local e = v:selectFirst("a")
		return Novel {
			title = text(e),
			link = shrinkURL(e:attr("href")),
			imageURL = v:selectFirst("img"):attr("src")
		}
	end)
end


local searchFilters = {
	TextFilter(5, "RANDOM STRING INPUT"),
	SwitchFilter(6, "RANDOM SWITCH INPUT"),
	CheckboxFilter(7, "RANDOM CHECKBOX INPUT"),
	TriStateFilter(8, "RANDOM TRISTATE CHECKBOX INPUT"),
	RadioGroupFilter(9, "RANDOM RGROUP INPUT", { "A", "B", "C" }),
	DropdownFilter(10, "RANDOM DDOWN INPUT", { "A", "B", "C" })
}



--- Internal settings store.
---
--- Completely optional.
---  But required if you want to save results from [updateSetting].
---
--- Notice, each key is surrounded by "[]" and the value is on the right side.
local settings = {
	[1] = "api-key",
}

--- Settings model for Shosetsu to render.
---
--- Optional, Default is empty.
---
local settingsModel = {
	TextFilter(1, "API Key"),
}


--- Called when a user changes a setting and when the extension is being initialized.
---
--- Optional, But required if [settingsModel] is not empty.
---
local function updateSetting(id, value)
	settings[id] = value
end



-- utils to make the code more linearly
-- TODO: move these to kotlin-lib luaFuncs
local function identity(...)
	return ...
end
local function pipeline(obj)
    return function(f, ...)
        if not f then
            return obj
        else
            return pipeline(f(obj, ...))
        end
    end
end

return {
	id = 6118,
	name = "ReadLightNovel",
	baseURL = baseURL,
	imageURL = "https://github.com/shosetsuorg/extensions/raw/dev/icons/ReadLightNovel.png",
	chapterType = ChapterType.HTML,

	shrinkURL = shrinkURL,
	expandURL = expandURL,

	listings = {
		Listing("Top Novels", true, function(data)
			return parseTop(GETDocument(expandURL("/top-novels/top-rated/" .. data[PAGE])))
		end)
	},

	getPassage = function(chapterURL)
		local htmlElement = GETDocument(expandURL(chapterURL)):selectFirst("div.content2")
		local title = htmlElement:selectFirst("div.block-title"):text()
		htmlElement = htmlElement:selectFirst("div#chapterhidden")

		-- Remove/modify unwanted HTML elements to get a clean webpage.
		htmlElement:select("br"):remove() -- Between each <p> is a <br>.

		local elementString = tostring(htmlElement)
		local apiKey = settings[1]
		local translatedText = RequestDocument(POST("http://165.22.242.237/translator", nil, RequestBody(qs({ text=elementString, api_key=apiKey }), MediaType("application/x-www-form-urlencoded")))):selectFirst("div.text")
		translatedText:child(0):before("<h1>" .. title .. "</h1>");
                return pageOfElem(translatedText)
	end,

	parseNovel = function(novelURL, loadChapters)
		local doc = GETDocument(expandURL(novelURL))

		local novel = doc:selectFirst("div.novel")
		local left = novel:selectFirst(".novel-left")
		local details = novel:selectFirst(".novel-right .novel-details")
		local leftdetails = left:selectFirst(".novel-details"):children()

		local info = NovelInfo {
			title = doc:selectFirst(".block-title h1"):text(),
			imageURL = left:selectFirst(".novel-cover img"):attr("src"),
			description = table.concat(map(details:selectFirst(".novel-detail-body"):select("p"), text), "\n"),
			status = ({
				Ongoing = NovelStatus.PUBLISHING,
				Completed = NovelStatus.COMPLETED,
			})[leftdetails:get(leftdetails:size()-1):selectFirst("li"):text()],
			genres = map(leftdetails:get(1):select("a"), text),
			language = leftdetails:get(3):selectFirst("li"):text(),
			authors = map(leftdetails:get(4):select("a"), text),
			artists = map(leftdetails:get(5):select("a"), text)
		}
		if details:selectFirst(".novel-detail-item.color-gray") ~= nil then
			info:setAlternativeTitles(map(details:selectFirst(".novel-detail-item.color-gray"):select("li a"), text))
		end

		if loadChapters then
			local i = 0
			local dedup = {} -- table for deduplication, dedup[url] will be true if chapter already exists

			-- mapping with identity function is a workaround,
			-- TODO: flatten should support java arrays to avoid this
			info:setChapters(
					pipeline(doc:select("#accordion .panel-body .tab-content"))
						(map, function(v)
							return map(v:select(".tab-pane ul"), identity)
						end)(flatten)
						(map, function(v)
							return map(v:select("li a"), identity)
						end)(flatten)
						(map, function(v)
							i = i + 1
							return NovelChapter {
								order = i,
								title = v:text(),
								link = shrinkURL(v:attr("href")),
							}
						end)
						(filter, function(chap)
							local duplicate = dedup[chap:getLink()]
							dedup[chap:getLink()] = true
							return not duplicate
						end)(AsList)())
		end

		return info
	end,
	settings = settingsModel,
	search = function(data)
		return parseTop(RequestDocument(
			POST(expandURL("/detailed-search-210922"), nil,
				RequestBody(qs({ keyword=data[QUERY], search=1 }), MediaType("application/x-www-form-urlencoded")))
			))
	end,
	setSettings = function(s)
		settings = s
	end,
	updateSetting = updateSetting,
}

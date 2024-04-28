-- {"id":92834729,"ver":"1.0.0","libVer":"1.0.0","author":"pxkazuki"}
local baseURL = "https://booktoki.com"

local json = Require("dkjson")

local function shrinkURL(url)
    return url:gsub(baseURL, "")
end

local function expandURL(url)
    return baseURL .. url
end

return {
    id = 14054904,
    name = "BookToki",
    baseURL = baseURL,
    imageURL = "https://booktoki324.com/img/book/favicon-32x32.png",
    hasSearch = true,
    listings = {
        Listing("Latest", true, function(data)
            local d = GETDocument(baseURL)

            return map(d:select(".miso-post-gallery .post-row .post-list"), function(v)
                return Novel {
                    title = v:select(".in-subject.ellipsis.trans-bg-black"):text(),
                    imageURL = v:select("img"):attr("src"),
                    link = shrinkURL(v:select("a"):attr("href"))
                }
            end)
        end) },
    parseNovel = function(novelURL, loadChapters)
        local document = GETDocument(expandURL(novelURL)):selectFirst(".content")
        local novelInfo = NovelInfo()
        novelInfo:setTitle(document:select(".col-sm-8 > div:nth-child(1)"):text())
        novelInfo:setImageURL(document:select("div.view-content1 img"):attr("src"))
        novelInfo:setDescription(table.concat(map(document:select("div.view-content:nth-child(3)"), function(v)
            return v:text()
        end), "\n"))

        if loadChapters then
            local listOfChapters = document:select(".list-body li.list-item")
            local count = listOfChapters:size()
            local chapterList = AsList(map(listOfChapters, function(v)
                local c = NovelChapter()
                local title = v:select("div.wr-subject a.item-subject")
                title:select("span"):remove()
                c:setLink(shrinkURL(v:select("div.wr-subject a.item-subject"):attr("href")))
                c:setTitle(title:text())
                c:setOrder(count)
                count = count - 1
                return c
            end))
            Reverse(chapterList)
            novelInfo:setChapters(chapterList)
        end
        return novelInfo
    end,
    getPassage = function(chapterURL)
        local document = GETDocument(expandURL(chapterURL))
        local chapter = document:selectFirst("article div#novel_content")

        local elementString = tostring(chapter)
        local res = RequestDocument(POST("https://api.xgorn.me/translate/html", nil,
            FormBodyBuilder()
            :add("lang", "Indonesian")
            :add("tags", "p")
            :add("html_text", elementString):build()
        ))
        local raw_html = json.decode(res:toString():sub(33, -18))
        local translatedText = Document(raw_html.html_text)
        return pageOfElem(translatedText)
    end,
    search = function(data)
        local d = GETDocument(baseURL .. "/novel?stx=" .. data[QUERY])
        return map(d:select("div#webtoon-list div.img-item"), function(v)
            return Novel {
                title = v:selectFirst("a span"):text(),
                imageURL = v:selectFirst("img"):attr("src"),
                link = "/novel/" .. v:selectFirst("div:nth-child(2)"):attr("rel")
            }
        end)
    end,

    shrinkURL = shrinkURL,
    expandURL = expandURL

}

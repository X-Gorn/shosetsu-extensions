-- {"id":04054904,"ver":"1.0.0","libVer":"1.0.0","author":"pxkazuki"}
local baseURL = "https://genesistls.com"

local json = Require("dkjson")

local function shrinkURL(url)
    return url:gsub(baseURL, "")
end

local function expandURL(url)
    return baseURL .. url
end

return {
    id = 14054904,
    name = "GenesisTLS",
    baseURL = baseURL,
    imageURL = "https://genesistls.com/wp-content/uploads/2022/04/logo.png",
    hasSearch = true,
    listings = {
        Listing("Latest", true, function(data)
            local d = GETDocument(baseURL .. "/series/?order=update")

            return map(d:select("div.listupd article.bs"), function(v)
                return Novel {
                    title = v:select("a"):attr("title"),
                    imageURL = v:select("img"):attr("src"),
                    link = shrinkURL(v:select("a"):attr("href"))
                }
            end)
        end) },
    parseNovel = function(novelURL, loadChapters)
        local document = GETDocument(expandURL(novelURL)):selectFirst("article")
        local novelInfo = NovelInfo()
        novelInfo:setTitle(document:select("h1"):text())
        novelInfo:setImageURL(document:select("div.thumb img"):attr("src"))
        novelInfo:setDescription(table.concat(map(document:select("div.entry-content"), function(v)
            return v:text()
        end), "\n"))

        local sta = document:selectFirst("div.info-content span:nth-child(1)"):text()
        local t = sta:gsub("Status: ", "")
        novelInfo:setStatus(NovelStatus(t == "Completed" and 1 or t == "Hiatus" and 2 or t == "Ongoing" and 0 or 3))

        novelInfo:setAuthors(map(document:select("div.info-content span:nth-child(2) a"), function(v)
            return v:text()
        end))

        novelInfo:setGenres(map(document:select("div.genxed a"), function(v)
            return v:text()
        end))

        if loadChapters then
            local listOfChapters = document:select("div.bixbox.bxcl.epcheck div ul a")
            if listOfChapters:select('div.epl-price').text == 'Free' then
                local count = listOfChapters:size()
                local chapterList = AsList(map(listOfChapters, function(v)
                    local c = NovelChapter()
                    c:setLink(shrinkURL(v:attr("href")))
                    c:setTitle(v:select("div.epl-title"):text())
                    c:setOrder(count)
                    count = count - 1
                    return c
                end))
                Reverse(chapterList)
                novelInfo:setChapters(chapterList)
            end
        end
        return novelInfo
    end,
    getPassage = function(chapterURL)
        local document = GETDocument(expandURL(chapterURL))
        local chapter = document:selectFirst("div.epcontent")

        local elementString = tostring(chapter)
        local res = RequestDocument(POST("https://api.xgorn.pp.ua/translate/html", nil,
            FormBodyBuilder()
            :add("lang", "Indonesian")
            :add("html_text", elementString):build()
        ))
        local raw_html = json.decode(res:toString():sub(33, -18))
        local translatedText = Document(raw_html.html_text)
        return pageOfElem(translatedText)
    end,
    search = function(data)
        local d = GETDocument(baseURL .. "/?s=" .. data[QUERY])
        return map(d:select("div.listupd > article"), function(v)
            return Novel {
                title = v:selectFirst("span.ntitle"):text(),
                imageURL = v:selectFirst("img"):attr("src"),
                link = shrinkURL(v:selectFirst("a"):attr("href"))
            }
        end)
    end,

    shrinkURL = shrinkURL,
    expandURL = expandURL

}

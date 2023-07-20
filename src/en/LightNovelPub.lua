-- {"id":31,"ver":"1.0.0","libVer":"1.0.0","author":"Gta-Cool"}

local qs = Require("url").querystring
local json = Require("dkjson")

--- Identification number of the extension.
--- Should be unique. Should be consistent in all references.
---
--- Required.
---
--- @type int
local id = 31

--- Name of extension to display to the user.
--- Should match index.
---
--- Required.
---
--- @type string
local name = "Light Novel Pub"

--- Base URL of the extension. Used to open web view in Shosetsu.
---
--- Required.
---
--- @type string
local baseURL = "https://www.lightnovelpub.com/"

--- URL of the logo.
---
--- Optional, Default is empty.
---
--- @type string
local imageURL = "https://gitlab.com/shosetsuorg/extensions/-/raw/dev/icons/LightNovelPub.png"

--- Shosetsu tries to handle cloudflare protection if this is set to true.
---
--- Optional, Default is false.
---
--- @type boolean
local hasCloudFlare = true

--- If the website has search.
---
--- Optional, Default is true.
---
--- @type boolean
local hasSearch = true

--- If the websites search increments or not.
---
--- Optional, Default is true.
---
--- @type boolean
local isSearchIncrementing = true

local GENRE_VALUES = {
    [0] = "genre-all",
    [1] = "genre-action",
    [2] = "genre-adventure",
    [3] = "genre-drama",
    [4] = "genre-fantasy",
    [5] = "genre-harem",
    [6] = "genre-martial-arts",
    [7] = "genre-mature",
    [8] = "genre-romance",
    [9] = "genre-tragedy",
    [10] = "genre-xuanhuan",
    [11] = "genre-ecchi",
    [12] = "genre-comedy",
    [13] = "genre-slice-of-life",
    [14] = "genre-mystery",
    [15] = "genre-supernatural",
    [16] = "genre-psychological",
    [17] = "genre-sci-fi",
    [18] = "genre-xianxia",
    [19] = "genre-school-life",
    [20] = "genre-josei",
    [21] = "genre-wuxia",
    [22] = "genre-shounen",
    [23] = "genre-horror",
    [24] = "genre-mecha",
    [25] = "genre-historical",
    [26] = "genre-shoujo",
    [27] = "genre-adult",
    [28] = "genre-seinen",
    [29] = "genre-sports",
    [30] = "genre-lolicon",
    [31] = "genre-gender-bender",
    [32] = "genre-shounen-ai",
    [33] = "genre-yaoi",
    [34] = "genre-video-games",
    [35] = "genre-smut",
    [36] = "genre-magical-realism",
    [37] = "genre-eastern-fantasy",
    [38] = "genre-contemporary-romance",
    [39] = "genre-fantasy-romance",
    [40] = "genre-shoujo-ai",
    [41] = "genre-yuri"
}
local GENRE_KEY = 11

local ORDER_VALUES = {
    [0] = "order-new",
    [1] = "order-popular",
    [2] = "order-updated"
}
local ORDER_KEY = 12

local STATUS_VALUES = {
    [0] = "status-all",
    [1] = "status-completed",
    [2] = "status-ongoing"
}
local STATUS_KEY = 13

--- Filters to display via the filter fab in Shosetsu.
---
--- Optional, Default is none.
---
--- @type Filter[] | Array
local searchFilters = {
    DropdownFilter(GENRE_KEY, "Genre / Category", {
        "All",
        "Action",
        "Adventure",
        "Drama",
        "Fantasy",
        "Harem",
        "Martial Arts",
        "Mature",
        "Romance",
        "Tragedy",
        "Xuanhuan",
        "Ecchi",
        "Comedy",
        "Slice of Life",
        "Mystery",
        "Supernatural",
        "Psychological",
        "Sci-fi",
        "Xianxia",
        "School Life",
        "Josei",
        "Wuxia",
        "Shounen",
        "Horror",
        "Mecha",
        "Historical",
        "Shoujo",
        "Adult",
        "Seinen",
        "Sports",
        "Lolicon",
        "Gender Bender",
        "Shounen Ai",
        "Yaoi",
        "Video Games",
        "Smut",
        "Magical Realism",
        "Eastern Fantasy",
        "Contemporary Romance",
        "Fantasy Romance",
        "Shoujo Ai",
        "Yuri"
    }),
    DropdownFilter(ORDER_KEY, "Order By", { "New", "Popular", "Updates" }),
    DropdownFilter(STATUS_KEY, "Status", { "All", "Completed", "Ongoing" })
}


local USE_AUTO_TRANSLATE = 889
local LANGUAGES = 900

local settings = {
    [1] = 0,
    [USE_AUTO_TRANSLATE] = true,
    [LANGUAGES] = 'Indonesian'
}

local settingsModel = {
    SwitchFilter(USE_AUTO_TRANSLATE, "Use Auto Translate?"),
    DropdownFilter(LANGUAGES, "Select Language to Translate",
        { 'Afrikaans', 'Albanian', 'Amharic', 'Arabic', 'Armenian', 'Assamese', 'Aymara', 'Azerbaijani',
            'Bambara', 'Basque', 'Belarusian', 'Bengali', 'Bhojpuri', 'Bosnian', 'Bulgarian', 'Catalan', 'Cebuano',
            'Chichewa',
            'Chinese (simplified)', 'Chinese (traditional)', 'Corsican', 'Croatian', 'Czech', 'Danish', 'Dhivehi',
            'Dogri',
            'Dutch', 'English', 'Esperanto', 'Estonian', 'Ewe', 'Filipino', 'Finnish', 'French', 'Frisian', 'Galician',
            'Georgian', 'German', 'Greek', 'Guarani', 'Gujarati', 'Haitian creole', 'Hausa', 'Hawaiian', 'Hebrew',
            'Hindi',
            'Hmong', 'Hungarian', 'Icelandic', 'Igbo', 'Ilocano', 'Indonesian', 'Irish', 'Italian', 'Japanese',
            'Javanese',
            'Kannada', 'Kazakh', 'Khmer', 'Kinyarwanda', 'Konkani', 'Korean', 'Krio', 'Kurdish (kurmanji)',
            'Kurdish (sorani)',
            'Kyrgyz', 'Lao', 'Latin', 'Latvian', 'Lingala', 'Lithuanian', 'Luganda', 'Luxembourgish', 'Macedonian',
            'Maithili',
            'Malagasy', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi', 'Meiteilon (manipuri)', 'Mizo', 'Mongolian',
            'Myanmar', 'Nepali', 'Norwegian', 'Odia (oriya)', 'Oromo', 'Pashto', 'Persian', 'Polish', 'Portuguese',
            'Punjabi',
            'Quechua', 'Romanian', 'Russian', 'Samoan', 'Sanskrit', 'Scots gaelic', 'Sepedi', 'Serbian', 'Sesotho',
            'Shona',
            'Sindhi', 'Sinhala', 'Slovak', 'Slovenian', 'Somali', 'Spanish', 'Sundanese', 'Swahili', 'Swedish', 'Tajik',
            'Tamil',
            'Tatar', 'Telugu', 'Thai', 'Tigrinya', 'Tsonga', 'Turkish', 'Turkmen', 'Twi', 'Ukrainian', 'Urdu', 'Uyghur',
            'Uzbek',
            'Vietnamese', 'Welsh', 'Xhosa', 'Yiddish', 'Yoruba', 'Zulu' })
}


--- ChapterType provided by the extension.
---
--- Optional, Default is STRING. But please do HTML.
---
--- @type ChapterType
local chapterType = ChapterType.HTML

--- Index that pages start with. For example, the first page of search is index 1.
---
--- Optional, Default is 1.
---
--- @type number
local startIndex = 1

--- Shrink the website url down. This is for space saving purposes.
---
--- Required.
---
--- @param url string Full URL to shrink.
--- @param type int Either KEY_CHAPTER_URL or KEY_NOVEL_URL.
--- @return string Shrunk URL.
local function shrinkURL(url, type)
    return url:gsub(".-lightnovelpub%.com/novel/", "")
end

--- Expand a given URL.
---
--- Required.
---
--- @param url string Shrunk URL to expand.
--- @param type int Either KEY_CHAPTER_URL or KEY_NOVEL_URL.
--- @return string Full URL.
local function expandURL(url, type)
    return baseURL .. "novel/" .. url
end

local function getSelective(url)
    local url = 'https://www.lightnovelpub.com/novel/' .. url
    local document = GETDocument(url):selectFirst(".novel-header .glass-background")

    return map(document:select("img"), function(ni)
        local n = Novel()
        n:setTitle(ni:attr("alt"))
        n:setLink(shrinkURL(url, KEY_NOVEL_URL):gsub("%-%d+$", ""))
        n:setImageURL(ni:attr("src"))
        return n
    end)
end

local function getRankingNovels(url)
    local document = GETDocument(url):selectFirst("#ranking .container")

    return map(document:select(".rank-novels .novel-item"), function(ni)
        local n = Novel()
        local te = ni:selectFirst(".item-body .title.text2row a");
        n:setTitle(te:attr("title"))
        n:setLink(shrinkURL(baseURL .. te:attr("href"):sub(2), KEY_NOVEL_URL):gsub("%-%d+$", ""))
        n:setImageURL(ni:selectFirst(".cover img"):attr("data-src"))
        return n
    end)
end

--- Listings that users can navigate in Shosetsu.
---
--- Required, 1 value at minimum.
---
--- @type Listing[] | Array
local listings = {
    Listing("Browse List", true, function(data)
        local document = GETDocument(baseURL .. "browse/" ..
            GENRE_VALUES[data[GENRE_KEY]] .. "/" ..
            ORDER_VALUES[data[ORDER_KEY]] .. "/" ..
            STATUS_VALUES[data[STATUS_KEY]] .. "/" ..
            "?page=" .. data[PAGE]
        ):selectFirst("#explore .container")

        local activePage = document:selectFirst(".pagination .active"):text()
        if activePage == ("" .. data[PAGE]) then
            return map(document:select(".novel-list .novel-item"), function(ni)
                local n = Novel()
                local te = ni:selectFirst(".item-body .novel-title a");
                n:setTitle(te:attr("title"))
                n:setLink(shrinkURL(baseURL .. te:attr("href"):sub(2), KEY_NOVEL_URL):gsub("%-%d+$", ""))
                n:setImageURL(ni:selectFirst(".novel-cover img"):attr("data-src"))
                return n
            end)
        end
        return {}
    end),
    Listing("Selective", false, function(data)
        return getSelective('dimensional-descent')
    end),
    Listing("Novel Ranking", false, function(data)
        return getRankingNovels(baseURL .. "ranking")
    end),
    Listing("Top Rated Novels", false, function(data)
        return getRankingNovels(baseURL .. "ranking/ratings")
    end),
    Listing("Most Read Novels", false, function(data)
        return getRankingNovels(baseURL .. "ranking/mostread")
    end),
    Listing("The novels with the most reviews", false, function(data)
        return getRankingNovels(baseURL .. "ranking/mostreview")
    end),
    Listing("The novels with the most commentary activity", false, function(data)
        return getRankingNovels(baseURL .. "ranking/mostcomment")
    end),
    Listing("The novels most added to the library", false, function(data)
        return getRankingNovels(baseURL .. "ranking/mostlib")
    end)
}

--- Get a chapter passage based on its chapterURL.
---
--- Required.
---
--- @param chapterURL string The chapters shrunken URL.
--- @return string Strings in lua are byte arrays. If you are not outputting strings/html you can return a binary stream.
local function getPassage(chapterURL)
    local url = expandURL(chapterURL, KEY_CHAPTER_URL)

    --- Chapter page, extract info from it.
    local document = GETDocument(url):selectFirst("#chapter-article")
    local title = document:selectFirst("section .titles .chapter-title"):text()
    local chapter = document:selectFirst("#chapter-container")

    -- Remove unwanted HTML elements (ads)
    chapter:select(".adsbygoogle"):parents():remove()

    local elementString = tostring(chapter)
    local translatedText = RequestDocument(POST("https://api-aws.xgorn.pp.ua/translator", nil,
        RequestBody(qs({ text = stringElement }), MediaType("application/x-www-form-urlencoded")))):selectFirst(
        "div.text")
    translatedText:child(0):before("<h1>" .. title .. "</h1>");
    return pageOfElem(translatedText)
end

--- Load info on a novel.
---
--- Required.
---
--- @param novelURL string shrunken novel url.
--- @return NovelInfo
local function parseNovel(novelURL)
    local url = expandURL(novelURL, KEY_NOVEL_URL)

    local ni = NovelInfo()

    local document = GETDocument(url):selectFirst("#novel")
    ni:setTitle(document:selectFirst(".novel-info .novel-title"):text())
    ni:setAlternativeTitles(map(
        document:select(".novel-info .alternative-title"),
        function(nat)
            return nat:text()
        end
    ))
    ni:setImageURL(document:selectFirst(".cover img"):attr("src"))
    ni:setDescription(table.concat(
        map(
            document:select(".summary .content p"),
            function(np)
                return np:text()
            end
        ),
        "\n\n"
    ))
    ni:setGenres(map(
        document:select(".novel-info .categories a"),
        function(ng)
            return ng:text()
        end
    ))
    ni:setAuthors(map(
        document:select(".novel-info .author a span[itemprop=\"author\"]"),
        function(na)
            return na:text()
        end
    ))

    local status = document:selectFirst(".novel-info .header-stats span:nth-child(4) strong"):text()
    ni:setStatus(NovelStatus(status == "Ongoing" and 0 or status == "Completed" and 1 or 3))

    ni:setTags(map(
        document:select(".tags .content a"),
        function(nt)
            return nt:text()
        end
    ))

    local nextLinkNode = nil
    local chaptersTable = {}
    repeat
        local chaptersPageUrl = nextLinkNode ~= nil and (baseURL .. nextLinkNode:attr("href"):sub(2)) or
            (url .. "/chapters/")
        local chaptersDocument = GETDocument(chaptersPageUrl):selectFirst("#chpagedlist")
        nextLinkNode = chaptersDocument:selectFirst(".pagination .PagedList-skipToNext a")
        local pageChaptersTable = map(chaptersDocument:select(".chapter-list a"), function(ni)
            local nc = NovelChapter()
            local chapterNumber = ni:selectFirst(".chapter-no"):text()
            nc:setTitle(chapterNumber .. " - " .. ni:selectFirst(".chapter-title"):text())
            nc:setLink(shrinkURL(baseURL .. ni:attr("href"):sub(2), KEY_CHAPTER_URL))
            nc:setOrder(chapterNumber)
            nc:setRelease(ni:selectFirst(".chapter-update"):text())
            return nc
        end)
        for _, nc in ipairs(pageChaptersTable) do
            table.insert(chaptersTable, nc)
        end
    until (nextLinkNode == nil)

    ni:setChapters(chaptersTable)

    return ni
end

--- Called to search for novels off a website.
---
--- Optional, But required if [hasSearch] is true.
---
--- @param data table @of applied filter values [QUERY] is the search query, may be empty.
--- @return Novel[] | Array
local function search(data)
    --- Not required if search is not incrementing.
    --- @type int
    local page = data[PAGE]

    -- There is always only one page for the search results
    if page > 1 then
        return {}
    end

    --- Get the user text query to pass through.
    --- @type string
    local query = data[QUERY]
    local lowerCaseQuery = query:lower()
    local replacedQuery = lowerCaseQuery:gsub("%s", "-")

    return getSelective(replacedQuery)
end

--- Called when a user changes a setting and when the extension is being initialized.
---
--- Optional, But required if [settingsModel] is not empty.
---
--- @param id int Setting key as stated in [settingsModel].
--- @param value any Value pertaining to the type of setting. Int/Boolean/String.
--- @return void
local function updateSetting(id, value)
    settings[id] = value
end

-- Return all properties in a lua table.
return {
    -- Required
    id = id,
    name = name,
    baseURL = baseURL,
    listings = listings, -- Must have at least one listing
    getPassage = getPassage,
    parseNovel = parseNovel,
    shrinkURL = shrinkURL,
    expandURL = expandURL,

    -- Optional values to change
    imageURL = imageURL,
    hasCloudFlare = hasCloudFlare,
    hasSearch = hasSearch,
    isSearchIncrementing = isSearchIncrementing,
    searchFilters = searchFilters,
    settings = settingsModel,
    chapterType = chapterType,
    startIndex = startIndex,

    -- Required if [hasSearch] is true.
    search = search,

    -- Required if [settings] is not empty
    updateSetting = updateSetting,
}

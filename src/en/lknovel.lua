-- {"id":75,"ver":"1.0.6","libVer":"1.0.0","author":"Doomsdayrs, AbhiTheModder","dep":["Madara>=2.2.0"]}

local API_KEY = 201
local RANDOM_SWITCH_INPUT = 202

--- Internal settings store.
---
--- Completely optional.
---  But required if you want to save results from [updateSetting].
---
--- Notice, each key is surrounded by "[]" and the value is on the right side.
local settings = {
	[API_KEY] = "test",
        [RANDOM_SWITCH_INPUT] = false,
}

--- Settings model for Shosetsu to render.
---
--- Optional, Default is empty.
---
local settingsModel = {
	TextFilter(API_KEY, "API Key"),
        SwitchFilter(RANDOM_SWITCH_INPUT), "RANDOM SWITCH INPUT",
}


--- Called when a user changes a setting and when the extension is being initialized.
---
--- Optional, But required if [settingsModel] is not empty.
---
local function updateSetting(id, value)
	settings[id] = value
end


return Require("Madara")("https://lknovel.com", {
    id = 325,
    name = "Lknovel",
    latestNovelSel = "div.col-6.col-md-3.badge-pos-1",
    imageURL = "https://lknovel.com/wp-content/uploads/2017/10/lknovelljljl.png",
    chaptersScriptLoaded = true,
    hasSearch = true,
    settings = settingsModel,
    updateSetting = updateSetting,
    genres = {
        "Action",
        "Adventure",
        "Comedy",
        "Drama",
        "Ecchi",
        "Fantasy",
        "Gender Bender",
        "Harem",
        "Historical",
        "Horror",
        "Josei",
        "Martial Arts",
        "Mature",
        "Mecha",
        "Mystery",
        "Psychological",
        "Romance",
        "School Life",
        "Sci-fi",
        "Seinen",
        "Shoujo",
        "Shounen",
        "Slice of Life",
        "Smut",
        "Sports",
        "Supernatural",
        "Tragedy",
        "Wuxia",
        "Xianxia",
        "Xuanhuan",
        "Yaoi"
    }
})

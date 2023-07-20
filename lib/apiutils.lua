local function langs()
    local Languages = { 'Afrikaans', 'Albanian', 'Amharic', 'Arabic', 'Armenian', 'Assamese', 'Aymara', 'Azerbaijani',
        'Bambara', 'Basque', 'Belarusian', 'Bengali', 'Bhojpuri', 'Bosnian', 'Bulgarian', 'Catalan', 'Cebuano',
        'Chichewa',
        'Chinese (simplified)', 'Chinese (traditional)', 'Corsican', 'Croatian', 'Czech', 'Danish', 'Dhivehi', 'Dogri',
        'Dutch', 'English', 'Esperanto', 'Estonian', 'Ewe', 'Filipino', 'Finnish', 'French', 'Frisian', 'Galician',
        'Georgian', 'German', 'Greek', 'Guarani', 'Gujarati', 'Haitian creole', 'Hausa', 'Hawaiian', 'Hebrew', 'Hindi',
        'Hmong', 'Hungarian', 'Icelandic', 'Igbo', 'Ilocano', 'Indonesian', 'Irish', 'Italian', 'Japanese', 'Javanese',
        'Kannada', 'Kazakh', 'Khmer', 'Kinyarwanda', 'Konkani', 'Korean', 'Krio', 'Kurdish (kurmanji)',
        'Kurdish (sorani)',
        'Kyrgyz', 'Lao', 'Latin', 'Latvian', 'Lingala', 'Lithuanian', 'Luganda', 'Luxembourgish', 'Macedonian',
        'Maithili',
        'Malagasy', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi', 'Meiteilon (manipuri)', 'Mizo', 'Mongolian',
        'Myanmar', 'Nepali', 'Norwegian', 'Odia (oriya)', 'Oromo', 'Pashto', 'Persian', 'Polish', 'Portuguese',
        'Punjabi',
        'Quechua', 'Romanian', 'Russian', 'Samoan', 'Sanskrit', 'Scots gaelic', 'Sepedi', 'Serbian', 'Sesotho', 'Shona',
        'Sindhi', 'Sinhala', 'Slovak', 'Slovenian', 'Somali', 'Spanish', 'Sundanese', 'Swahili', 'Swedish', 'Tajik',
        'Tamil',
        'Tatar', 'Telugu', 'Thai', 'Tigrinya', 'Tsonga', 'Turkish', 'Turkmen', 'Twi', 'Ukrainian', 'Urdu', 'Uyghur',
        'Uzbek',
        'Vietnamese', 'Welsh', 'Xhosa', 'Yiddish', 'Yoruba', 'Zulu' }
    return Languages
end

local function translate_novel(settings, htmlElement, title)
    local isUsingTL = settings[889]
    if isUsingTL then
        local endpoint = API_BASE_URL() .. "/translate/shosetsu"
        local elementString = tostring(htmlElement)
        local translatedText = RequestDocument(POST(endpoint, nil,
                RequestBody(qs({ lang = settings[900], text = elementString, api_key = API_KEY() }),
                    MediaType("application/x-www-form-urlencoded"))))
            :selectFirst("div.text")
        translatedText:child(0):before("<h1>" .. title .. "</h1>");
        return pageOfElem(translatedText)
    end
    htmlElement:child(0):before("<h1>" .. title .. "</h1>");
    return pageOfElem(htmlElement)
end

return { language = langs(), translator = translate_novel }

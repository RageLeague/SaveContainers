local filepath = require "util/filepath"

local function OnLoad( mod )
    rawset(_G, "CURRENT_MOD_ID", mod.id)
    require "SAVE_CONTAINERS:strings"
    require "SAVE_CONTAINERS:api"

    for k, filepath in ipairs( filepath.list_files( "SAVE_CONTAINERS:ui/", "*.lua", true )) do
        local name = filepath:match( "(.+)[.]lua$" )
        -- print(name)
        if name then
            require(name)
        end
    end

end

local function OnPreLoad()
    for k, filepath in ipairs( filepath.list_files( "SAVE_CONTAINERS:loc", "*.po", true )) do
        local name = filepath:match( "(.+)[.]po$" )
        local lang_id = name:match("([_%w]+)$")
        lang_id = lang_id:gsub("_", "-")
        -- require(name)
        print(lang_id)
        for id, data in pairs(Content.GetLocalizations()) do
            if data.default_languages and table.arraycontains(data.default_languages, lang_id) then
                Content.AddPOFileToLocalization(id, filepath)
            end
        end
    end
end

return {
    version = "0.2.0",
    alias = "SAVE_CONTAINERS",

    OnPreLoad = OnPreLoad,
    OnLoad = OnLoad,

    title = "Save Containers",
    description = "Allows you to create multiple profiles.",
    previewImagePath = "preview.png",
}

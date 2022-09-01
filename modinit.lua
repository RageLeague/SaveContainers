local filepath = require "util/filepath"

local function OnLoad( mod )
    rawset(_G, "CURRENT_MOD_ID", mod.id)
    require "SAVECONTAINERS:strings"
    require "SAVECONTAINERS:api"

    for k, filepath in ipairs( filepath.list_files( "SAVECONTAINERS:ui/", "*.lua", true )) do
        local name = filepath:match( "(.+)[.]lua$" )
        -- print(name)
        if name then
            require(name)
        end
    end

end

local function OnPreLoad()
    for k, filepath in ipairs( filepath.list_files( "SAVECONTAINERS:loc", "*.po", true )) do
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
    version = "0.2.1",
    alias = "SAVECONTAINERS",

    OnPreLoad = OnPreLoad,
    OnLoad = OnLoad,

    title = "Save Containers",
    description = "Allows you to create multiple profiles.",
    previewImagePath = "preview.png",
}

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

return {
    version = "0.0.1",
    alias = "SAVE_CONTAINERS",

    OnPreLoad = OnPreLoad,
    OnLoad = OnLoad,

    title = "Save Containers",
    description = "Allows you to create multiple profiles. Call \"Containers.Help()\" in the console for how to use it.",
}

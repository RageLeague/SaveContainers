
local filepath = require "util/filepath"
function Containers.ListProfiles()
    local paths = {}
    local constructed_path = string.format('%s%s/', Containers.path, Containers.folder)
    for k, filename in ipairs( filepath.list_files( constructed_path, "info.lua", true )) do
        local name = filename:match( "([^/]+)/info[.]lua$" )
        print(name)
        table.insert(paths, name)
    end
    return paths
end

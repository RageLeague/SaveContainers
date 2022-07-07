
local filepath = require "util/filepath"
function Containers.ListProfiles()
    local paths = {}
    local constructed_path = string.format('%s%s/', Containers.path, Containers.folder)
    for k, filename in ipairs( filepath.list_files( constructed_path, "info.lua", true )) do
        local id = filename:match( "([^/]+)/info[.]lua$" )
        local name = filename:match( "(.+)[.]lua$" )
        package.loaded[ name ] = nil
        local ok, result = xpcall( require, generic_error, name )
        print(name)
        -- table.insert(paths, name)
        if ok then
            paths[id] = result
        else
            print(result)
        end
    end
    return paths
end

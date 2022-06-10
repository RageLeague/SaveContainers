local filepath = require "util/filepath"

local Containers = class("Containers")

Containers.settings = engine.settings
Containers.path = "SETTINGS:"
Containers.folder = "save_containers"

Containers.manual = {}

function Containers.Help(fn)
    if not fn then
        print("List of all commands:")
        for i, id, data in sorted_pairs(Containers.manual) do
            print(string.format("%s: %s", id, data))
        end
    else
        if Containers.manual[fn] then
        else
            print(string.format("Error: Function \"%s\" does not exist.", fn))
        end
    end
end

function Containers.GetSavableFiles(root)
    root = root or ""
    local files = {
        root .. "input_settings.lua",
        root .. "profile.lua",
        root .. "run_history.lua",
        root .. "stats.lua"
    }

    local function OnListFiles( filenames )
        for k, t in pairs( filenames ) do
            local save_name = t.name
            table.insert(files, root .. "saves/" .. save_name)
        end
    end
    Containers.settings:ListFiles( root .. "saves/*", OnListFiles )
    return files
end

for k, filepath in ipairs( filepath.list_files( "SAVE_CONTAINERS:api/", "*.lua", true )) do
    local name = filepath:match( "(.+)[.]lua$" )
    -- print(name)
    if name then
        require(name)
    end
end

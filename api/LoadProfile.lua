function Containers.LoadProfile(id)
    local exists = false
    local function OnFileExists( result )
        exists = result
    end
    Containers.settings:FileExists( string.format("%s/%s/info.lua", Containers.folder, id), OnFileExists )
    if not exists then
        print("Error: This profile does not exist")
        return false
    end
    Containers.CopyProfile(Containers.folder .. "/" .. id .. "/", "")
    print("Profile successfully loaded")
    return true
end

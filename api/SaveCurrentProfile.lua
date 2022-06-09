function Containers.SaveCurrentProfile(id, forced_save)
    if not id then
        id = engine.inst:NewGUID()
        print(string.format("No ID provided, generate new one (%s)", id))
    end

    local exists = false
    local function OnFileExists( result )
        exists = result
    end
    Containers.settings:FileExists( string.format("%s/%s/info.lua", Containers.folder, id), OnFileExists )
    if exists and not forced_save then
        print("Container already exists. Halt function.")
        return false
    end
    print(string.format("Saving to save (%s)...", id))
    Containers.CopyProfile(Containers.path, Containers.path .. Containers.folder .. "/" .. id .. "/")
    local f = io.open(Containers.path .. Containers.folder .. "/" .. id .. "/info.lua", "w")
    local info = {
        name = "Container",
    }
    local out = "return ".. serpent.block(info, {comment = false})
    f:write(out)
    f:close()
    print(string.format("Successfully saved to (%s)", id))
    return true
end

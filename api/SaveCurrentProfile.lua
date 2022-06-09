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
    local save_paths = Containers.GetSavableFiles()
    for i, path in ipairs(save_paths) do
        local load_path = Containers.path .. path
        local save_path = Containers.path .. Containers.folder .. "/" .. id .. "/" .. path
        local f = io.open( load_path, "r" )
        if f then
            local data = f:read()
            f:close()

            f = io.open(save_path, "w")
            f:write(data)
            f:close()
        end
    end
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

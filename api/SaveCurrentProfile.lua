function Containers.SaveCurrentProfile(id, forced_save, data)
    data = data or {}
    if not id then
        id = engine.inst:NewGUID()
        print(string.format("No ID provided, generate new one (%s)", id))
    end

    local exists = false
    local function OnFileExists( result )
        exists = result
    end
    Containers.settings:FileExists( string.format("%s/%s/info.lua", Containers.folder, id), OnFileExists )
    local info = {}
    if exists and not forced_save then
        print("Container already exists. Halt function.")
        return false
    end
    if exists then
        local ok, result = xpcall( require, generic_error, string.format("%s%s/%s/info", Containers.path, Containers.folder, id) )
        if not ok then
            print(result)
            info = {
                name = data.name or "Container",
            }
        else
            info = result
        end
    else
        info = {
            name = data.name or "Container",
        }
    end
    if not info.time_created then
        info.time_created = os.time()
    end

    print(string.format("Saving to save (%s)...", id))
    Containers.CopyProfile("", Containers.folder .. "/" .. id .. "/")
    local f = io.open(Containers.path .. Containers.folder .. "/" .. id .. "/info.lua", "w")
    info.last_saved = os.time()
    local out = "return ".. serpent.block(info, {comment = false})
    f:write(out)
    f:close()
    print(string.format("Successfully saved to (%s)", id))
    return true
end

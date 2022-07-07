function Containers.UpdateInfo(id, data)
    local exists = false
    local function OnFileExists( result )
        exists = result
    end
    Containers.settings:FileExists( string.format("%s/%s/info.lua", Containers.folder, id), OnFileExists )
    if not exists then
        print("Container does not exist")
        return false
    end
    local info_filepath = string.format("%s%s/%s/info", Containers.path, Containers.folder, id)
    package.loaded[ info_filepath ] = nil
    local ok, result = xpcall( require, generic_error, info_filepath )
    if not ok then
        print(result)
        return false
    end
    for key, val in pairs(data) do
        result[key] = val
    end
    result.last_saved = os.time()

    local f = io.open(Containers.path .. Containers.folder .. "/" .. id .. "/info.lua", "w")
    local out = "return ".. serpent.block(result, {comment = false})
    f:write(out)
    f:close()
    return true
end

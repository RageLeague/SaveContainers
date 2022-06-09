function Containers.CopyProfile(copy_address, target_address)
    local save_paths = Containers.GetSavableFiles()
    for i, path in ipairs(save_paths) do
        local load_path = copy_address .. path
        local save_path = target_address .. path
        local f = io.open( load_path, "r" )
        if f then
            local data = f:read()
            f:close()

            f = io.open(save_path, "w")
            f:write(data)
            f:close()
        end
    end
end

function Containers.CopyProfile(copy_address, target_address)
    Containers.ClearCurrentProfile(target_address)
    local save_paths = Containers.GetSavableFiles(copy_address)
    for i, path in ipairs(save_paths) do
        local load_path = Containers.path .. copy_address .. path
        local save_path = Containers.path .. target_address .. path
        local f = io.open( load_path, "r" )
        if f then
            local data = f:read("*all")
            f:close()

            f = io.open(save_path, "w")
            if f then
                f:write(data)
                f:close()
                print("Copied " .. load_path .. " to " .. save_path)
            end
        end
    end
end

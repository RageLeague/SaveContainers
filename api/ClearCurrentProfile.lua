function Containers.ClearCurrentProfile()
    local save_paths = Containers.GetSavableFiles()
    for i, path in ipairs(save_paths) do
        local load_path = path
        Containers.settings:DeleteFile(load_path, function() print("Deleted " .. load_path) end)
    end
end

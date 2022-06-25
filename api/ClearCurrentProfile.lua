function Containers.ClearCurrentProfile(root)
    root = root or ""
    local save_paths = Containers.GetSavableFiles(root)
    for i, path in ipairs(save_paths) do
        local load_path = root .. path
        Containers.settings:DeleteFile(load_path, function() print("Deleted " .. load_path) end)
    end
end

function Containers.DeleteProfile(id)
    Containers.ClearCurrentProfile(Containers.folder .. "/" .. id .. "/")
    Containers.settings:DeleteFile(Containers.folder .. "/" .. id .. "/info.lua", function() print("Deleted info.lua") end)
    local true_path = engine.inst:ResolveFileName(Containers.path .. Containers.folder .. "/" .. id, false)
    if true_path then
        local command = string.format('rmdir "%s/saves"', true_path)
        print(command)
        -- Dangerous stuff
        local result = os.execute(command)
        command = string.format('rmdir "%s"', true_path)
        print(command)
        -- Dangerous stuff
        local result = os.execute(command)
    end
end

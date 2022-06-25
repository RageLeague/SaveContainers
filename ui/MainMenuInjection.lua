local MainMenu = Screen.MainMenu

local old_init_menu = MainMenu.init

local function ContainerDescFn(id, data)
    local ok, result = pcall( require, Containers.path .. Containers.folder .. "/" .. id .. "/run_history" )
    local run_history, run_count
    if ok then
        run_history = result
        run_count = run_history and run_history.history and #run_history.history
    end
    local tooltip = string.format(LOC"CONTAINERS.SELECT_CONTAINER.TOOLTIP",
        data.time_created and tostring( os.date( "%x %X", data.time_created )) or LOC "CONTAINERS.NA",
        data.last_saved and tostring( os.date( "%x %X", data.last_saved )) or LOC "CONTAINERS.NA",
        run_count or 0)
    return tooltip
end

local function ProfilesMenu( screen )

    local t = {}

    for i, id, data in sorted_pairs(Containers.ListProfiles()) do
        local tooltip = ContainerDescFn(id, data)

        table.insert(t,  {txt = data.name or "", hover_text = tooltip, profile_info = data, fn = function()
            TheGame:FE():PushScreen( ContainerClass.MultiOptPopup(
                data.name or "",
                LOC"CONTAINERS.SELECT_CONTAINER.DESC",
                {
                    LOC"UI.DIALOGS.CANCEL",
                    LOC"CONTAINERS.LOAD.OPT",
                    LOC"CONTAINERS.SAVE.OPT",
                    LOC"CONTAINERS.DELETE.OPT",
                    "Rename"
                } ) )
                :SetFn( function(v)
                    if v == 2 then
                        -- Load
                        TheGame:FE():PushScreen( Screen.YesNoPopup( LOC"CONTAINERS.LOAD.TITLE", LOC"CONTAINERS.LOAD.DESC" ) )
                            :SetFn( function(v)
                                if v == Screen.YesNoPopup.YES then
                                    local result = Containers.LoadProfile(id)
                                    if result then
                                        -- The game will reset anyway, so don't show a popup.
                                        -- TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.SUCCESS", loc.format(LOC"CONTAINERS.CREATE_NEW.SUCCESS_DESC", val) ) )
                                    else
                                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.LOAD.FAILURE_DESC") ) )
                                    end
                                end

                            end )
                    elseif v == 3 then
                        -- Override save
                        TheGame:FE():PushScreen( Screen.YesNoPopup( LOC"CONTAINERS.SAVE.TITLE", LOC"CONTAINERS.SAVE.DESC" ) )
                        :SetFn( function(v)
                            if v == Screen.YesNoPopup.YES then
                                local result = Containers.SaveCurrentProfile(id, true)
                                if result then
                                    TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.SUCCESS", loc.format(LOC"CONTAINERS.SAVE.SUCCESS_DESC") ) )
                                else
                                    TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.SAVE.FAILURE_DESC") ) )
                                end
                            end
                        end )
                    elseif v == 4 then
                        -- Delete
                        TheGame:FE():PushScreen( Screen.YesNoPopup( LOC"CONTAINERS.DELETE.TITLE", LOC"CONTAINERS.DELETE.DESC" ) )
                            :SetFn( function(v)
                                if v == Screen.YesNoPopup.YES then
                                    local result = Containers.DeleteProfile(id)
                                    if result then
                                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.SUCCESS", loc.format(LOC"CONTAINERS.DELETE.SUCCESS_DESC") ) )
                                    else
                                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.DELETE.FAILURE_DESC") ) )
                                    end
                                end
                            end )
                    elseif v == 5 then
                        UIHelpers.EditString(
                            LOC "CONTAINERS.RENAME.TITLE",
                            LOC "CONTAINERS.RENAME.DESC",
                            data.name or "",
                            function( val )
                                if val and val ~= "" and val ~= data.name then
                                    local result = Containers.UpdateInfo(id, { name = val })
                                    if result then
                                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.SUCCESS", loc.format(LOC"CONTAINERS.RENAME.SUCCESS_DESC", val) ) )
                                    else
                                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.RENAME.FAILURE_DESC") ) )
                                    end
                                end
                            end
                        )
                    end

                end )
        end, icon = engine.asset.Texture("UI/ic_mainmenu_history.tex"), buttonclass = ContainerClass.HoverableMenuButton })
    end

    table.sort(t, function(a, b)
        return (a.profile_info and a.profile_info.last_saved or 0) > (b.profile_info and b.profile_info.last_saved or 0)
    end)

    table.insert(t,  {txt = LOC"CONTAINERS.CREATE_NEW.OPT", fn = function()
        UIHelpers.EditString(
            LOC "CONTAINERS.CREATE_NEW.TITLE",
            LOC "CONTAINERS.CREATE_NEW.DESC",
            LOC "CONTAINERS.CREATE_NEW.SAMPLE",
            function( val )
                if val then
                    if val ~= "" then
                        local result = Containers.SaveCurrentProfile(nil, false, {name = val})
                        if result then
                            TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.SUCCESS", loc.format(LOC"CONTAINERS.CREATE_NEW.SUCCESS_DESC", val) ) )
                        else
                            TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.CREATE_NEW.FAILURE_DESC") ) )
                        end
                    else
                        TheGame:FE():PushScreen( Screen.InfoPopup( LOC"CONTAINERS.FAILURE", loc.format(LOC"CONTAINERS.CREATE_NEW.REQ_NAME") ) )
                    end
                    -- screen:PopMenu()
                end
            end
        )
    end, icon = engine.asset.Texture("UI/ic_mainmenu_experimental.tex"), buttonclass = Widget.AdvancedMenuButton })

    table.insert(t,  {txt = LOC"UI.MAINMENU.BACK", fn = function()
        AUDIO:PlayEvent("event:/ui/main/gen/back_general")
        screen:PopMenu()
    end, icon = engine.asset.Texture("UI/ic_mainmenu_back.tex"), buttonclass = Widget.AdvancedMenuButton })

    return t
end


function MainMenu:init(...)
    -- Extremely hacky. Won't recommend it
    local old_link_fn = MainMenu.ShouldSkipExternalLinks
    local did_injection = false
    MainMenu.ShouldSkipExternalLinks = function(self, ...)
        if not did_injection and self.link_buttons then
            self.profiles_link = self.link_buttons:AddChild( Widget.MainMenuButton( engine.asset.Texture("UI/ic_mainmenu_experimental.tex"), LOC"CONTAINERS.MANAGE_CONTAINERS", function()
                if self:GetCurrentMenu() ~= ProfilesMenu then
                    if not self:IsMenuStart() then self:PopMenu() end
                    self:PushMenu( ProfilesMenu )
                end
            end ) )
            did_injection = true
        end
        return old_link_fn(self, ...)
    end
    local result = old_init_menu(self, ...)
    MainMenu.ShouldSkipExternalLinks = old_link_fn
    return result
end

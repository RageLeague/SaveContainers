local MainMenu = Screen.MainMenu

local old_init_menu = MainMenu.init

local function ProfilesMenu( screen )

    local t = {}

    for i, id, data in sorted_pairs(Containers.ListProfiles()) do
        local tooltip = string.format("Created on: %s\n\nUpdated on: %s",
            data.time_created and tostring( os.date( "%x %X", data.time_created )) or LOC "CONTAINERS.NA",
            data.last_saved and tostring( os.date( "%x %X", data.last_saved )) or LOC "CONTAINERS.NA")

        table.insert(t,  {txt = data.name or "", hover_text = tooltip, fn = function()

        end, icon = engine.asset.Texture("UI/ic_mainmenu_history.tex"), buttonclass = ContainerClass.HoverableMenuButton })
    end

    table.insert(t,  {txt = LOC"CONTAINERS.CREATE_NEW.OPT", fn = function()
        UIHelpers.EditString(
            LOC "CONTAINERS.CREATE_NEW.TITLE",
            LOC "CONTAINERS.CREATE_NEW.DESC",
            LOC "CONTAINERS.CREATE_NEW.SAMPLE",
            function( val )
                if val then
                    if val ~= "" then
                        local result = Containers.SaveCurrentProfile(nil, true, {name = val})
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
            self.profiles_link = self.link_buttons:AddChild( Widget.MainMenuButton( engine.asset.Texture("UI/ic_mainmenu_experimental.tex"), "???", function()
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

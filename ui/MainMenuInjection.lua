local MainMenu = Screen.MainMenu

local old_init_menu = MainMenu.init

local function ProfilesMenu( screen )

    local t = {}

    for i, id, data in sorted_pairs(Containers.ListProfiles()) do
        table.insert(t,  {txt = data.name or "", fn = function()

        end, icon = engine.asset.Texture("UI/ic_mainmenu_history.tex"), buttonclass = Widget.AdvancedMenuButton })
    end

    table.insert(t,  {txt = LOC"CONTAINERS.CREATE_NEW", fn = function()

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

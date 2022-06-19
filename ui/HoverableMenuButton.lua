local HoverableMenuButton = class("ContainerClass.HoverableMenuButton", Widget.AdvancedMenuButton)

function HoverableMenuButton:init(txt, fn, opt)
    HoverableMenuButton._base.init( self, txt, fn, opt )
    self:SetToolTip(opt and opt.hover_text or "")
end

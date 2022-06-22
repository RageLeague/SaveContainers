local MultiOptPopup = class("ContainerClass.MultiOptPopup", Screen.InfoPopup)

function MultiOptPopup:init(title, txt, options)
    assert(#options > 0, "Not enough options")
    MultiOptPopup._base.init( self, title, txt, options[1] )
    self.options = options
    self.button_ok:SetFn(function() self:DoRet(1) end)

    for i, opt in ipairs(options) do
        if i ~= 1 then
            self.buttons:AddChild( Widget.IconButton() )
                :SetName("BUTTON_" .. i)
                :SetText( opt )
                :SetFn(function() self:DoRet(i) end)
                :SetIcon( global_images.cancel )
                -- :IncreaseSizeToLabel( SPACING.M1 )
                :LayoutBounds("after","center")
                :Offset(15,0)
        end
    end

    self:Layout()
end

function MultiOptPopup:DoRet(ret)
    self:GetFE():PopScreen(self)
    if self.close_fn then call_delegate( self.close_fn, ret ) end
    return self
end

function MultiOptPopup:SetFn( fn, ... )
    self.close_fn = { fn, ... }
    return self
end

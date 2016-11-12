--[[---------------------------------------------------------
   Name: registration.lua
   Desc: registration & rules GUI
-----------------------------------------------------------]]

surface.CreateFont( "RegisterTitleFont",
    {
    font = "Agency FB",
    size = 50,
    weight = 350
    }
)

surface.CreateFont( "NameFont",
    {
    font = "Agency FB",
    size = 30,
    weight = 600
    }
)

surface.CreateFont( "WelcomeTextFont",
    {
    font = "comic sans ms",
    size = 20,
    weight = 600
    }
)

surface.CreateFont( "ErrorTextFont",
    {
    font = "comic sans ms",
    size = 20,
    weight = 600
    }
)



USERCREATION = {}
local w,h
local FEMALE_MODELS = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_05.mdl",
        "models/player/Group01/Female_06.mdl"
    }
local MALE_MODELS = {
        "models/players/johnny/f_1_01.mdl"
    }
local index = 1

function USERCREATION:Init()
    w,h = ScrW(),ScrH()
    self:SetSize(w,h)
    self:Center()
    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)

    self.modelViewer = vgui.Create("DModelPanel",self)
    self.modelViewer:SetSize(w/3,h/7 * 5)
    self.modelViewer:SetModel(MALE_MODELS[1])
    self.modelViewer:SetPos(w/3,h/3)
    self.modelViewer:SetAnimated(false)
    self.modelViewer.LayoutEntity = function(Entity)
        if ( self.modelViewer.bAnimated ) then -- Make it animate normally
            self.modelViewer:RunAnimation()
        end
    end
    self.modelViewer:SetCamPos( Vector( 25, 0, 60 ) )
    self.modelViewer:SetLookAt( Vector( 0, 0, 60 ) )
    LocalPlayer():SetModel(Model("models/player/Group01/Female_01.mdl"))

    self.femaleButton = vgui.Create("DButton",self)
    self.femaleButton:SetSize(w/3/2,h/12)
    self.femaleButton:SetPos(w/3,h/3)
    self.femaleButton:SetText("Weiblich")
    self.femaleButton:SetTextColor(Color(236, 240, 241))
    self.femaleButton:SetFont("NameFont")
    self.femaleButton.selected = false
    self.femaleButton.colorNormal = Color(52, 152, 219)
    self.femaleButton.OnCursorEntered = function()
        self.femaleButton.colorNormal = Color(44, 62, 80)
    end
    self.femaleButton.OnCursorExited = function()
        self.femaleButton.colorNormal = Color(52, 152, 219)
    end
    self.femaleButton.DoClick = function()
        if self.femaleButton.selected then
            
        else
            self.femaleButton.selected = true
            self.maleButton.selected = false
            self:UpdateModel(1)
        end
        print(self.femaleButton.selected)
    end
    self.femaleButton.Paint = function(panel,w,h)
        if self.femaleButton.selected then
            surface.SetDrawColor(Color(44, 62, 80))
        else
            surface.SetDrawColor(self.femaleButton.colorNormal)
        end
        surface.DrawRect(0,0,w,h)
    end

    self.maleButton = vgui.Create("DButton",self)
    self.maleButton:SetSize(w/3/2,h/12)
    self.maleButton:SetPos(w/3 + w/3/2,h/3)
    self.maleButton:SetText("Männlich")
    self.maleButton:SetTextColor(Color(236, 240, 241))
    self.maleButton:SetFont("NameFont")
    self.maleButton.selected = true
    self.maleButton.colorNormal = Color(52, 152, 219)
    self.maleButton.OnCursorEntered = function()
        self.maleButton.colorNormal = Color(44, 62, 80)
    end
    self.maleButton.OnCursorExited = function()
        self.maleButton.colorNormal = Color(52, 152, 219)
    end
    self.maleButton.DoClick = function()
        if self.maleButton.selected then
            
        else
            self.maleButton.selected = true
            self.femaleButton.selected = false
            self:UpdateModel(1)
        end
        print(self.maleButton.selected)
    end
    self.maleButton.Paint = function(panel,w,h)
        if self.maleButton.selected then
            surface.SetDrawColor(Color(44, 62, 80))
        else
            surface.SetDrawColor(self.maleButton.colorNormal)
        end
        surface.DrawRect(0,0,w,h)
    end

    self.leftArrow = vgui.Create("DImageButton",self)
    self.leftArrow:SetImage("vgui/arrow_left.png")
    self.leftArrow:SizeToContents()
    self.leftArrow:SetPos(w/4 - self.leftArrow:GetWide()/2,h/3*2)
    self.leftArrow.DoClick = function()
        self:UpdateModel(index - 1)
    end


    self.rightArrow = vgui.Create("DImageButton",self)
    self.rightArrow:SetImage("vgui/arrow_right.png")
    self.rightArrow:SizeToContents()
    self.rightArrow:SetPos(w/4*3 - self.rightArrow:GetWide()/2,h/3*2)
    self.rightArrow.DoClick = function()
        self:UpdateModel(index + 1)
    end



    self:UpdateModel(1)
    self:ParentToHUD()
    self:MakePopup()
end

function USERCREATION:UpdateModel(indexNew)
    if self.maleButton.selected then
        if(indexNew > #MALE_MODELS) then
            self.modelViewer:SetModel(MALE_MODELS[1])
            index = 1
            print("indexNew > #MALE_MODELS")
        elseif(indexNew < 1) then
            self.modelViewer:SetModel(MALE_MODELS[#MALE_MODELS])
            index = #MALE_MODELS
            print("indexNew < 1")
        else
            self.modelViewer:SetModel(MALE_MODELS[indexNew])
            index = indexNew
            print("else")
        end
    else 
         if(indexNew > #FEMALE_MODELS) then
            self.modelViewer:SetModel(FEMALE_MODELS[1])
            index = 1
        elseif(indexNew < 1) then
            self.modelViewer:SetModel(FEMALE_MODELS[#FEMALE_MODELS])
            index = #FEMALE_MODELS
        else
            self.modelViewer:SetModel(FEMALE_MODELS[indexNew])
            index = indexNew
        end
    end
    print(index,#MALE_MODELS)
end

function USERCREATION:SetModel()

end

function USERCREATION:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 250)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(52, 152, 219)
    surface.DrawRect(0,ScrH()/25,w,h/10)

    draw.SimpleText("Charakter Erstellung","RegisterTitleFont",ScrW()/2,ScrH()/17,Color(0,0,0),TEXT_ALIGN_CENTER)
end

function USERCREATION:OnMousePressed(mc)
    if(mc == MOUSE_RIGHT) then
        self:Remove();
    end
end

function USERCREATION:Think()
end

function USERCREATION:OnClick()

end

function USERCREATION:PerformLayout()
end

vgui.Register("UserCreation", USERCREATION, "EditablePanel")

----------------------------------------------

net.Receive("SCShowRules", function(length, _)
        --ShowRulesConfirmation()
        //gui.EnableScreenClicker(true)
        //vgui.Create("RulesBrowser")
   end)

-- Read the list of player models
net.Receive("SCPlayerModels", function(length, _)
        PlayerModels = net.ReadTable()
   end)

concommand.Add("registerPanel",function()
    vgui.Create("UserCreation")


end)
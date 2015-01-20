-----------------------------------------------------------------------------------------------
-- Client Lua Script for OneClickBank
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"

-----------------------------------------------------------------------------------------------
-- OneClickBank Module Definition
-----------------------------------------------------------------------------------------------
OneClickBank = {}
	OneClickBank.bank = {}
		OneClickBank.bank.addon = nil
		OneClickBank.bank.wnd = nil
	OneClickBank.log = nil

  
-----------------------------------------------------------------------------------------------
-- misc
-----------------------------------------------------------------------------------------------
function DBG_CHECK(check)
		if check == nil then
			OneClickBank.log.debug("nil check failed")
		end
end

 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
ANCHOR_LEFT = 1
ANCHOR_TOP = 2
ANCHOR_RIGHT = 3
ANCHOR_BOTTOM = 4
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function OneClickBank:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here

    return o
end


function OneClickBank:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- OneClickBank OnLoad
-----------------------------------------------------------------------------------------------
function OneClickBank:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("OneClickBank.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
	
	self.bank.addon = Apollo.GetAddon("BankViewer")
	
	local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
    self.log = GeminiLogging:GetLogger({
        level = GeminiLogging.DEBUG,
        pattern = "%d %l @F:%c L:%n: %m",
        appender = "GeminiConsole"
    })

	self.log.debug("OneClickBank:OnLoad");

	 -- Event thrown by opening the a Bank window   
	Apollo.RegisterEventHandler("ShowBank", "AOnBankWindowOpened", self)
    -- Event thrown by closing the a Bank window
    Apollo.RegisterEventHandler("HideBank", "OnBankWindowClosed", self)

end

-----------------------------------------------------------------------------------------------
-- OneClickBank OnDocLoaded
-----------------------------------------------------------------------------------------------
function OneClickBank:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
		self.wndForm = Apollo.LoadForm(self.xmlDoc, "OCBForm", nil, self)
		self.wndForm:Show(false)
		GameLib.GetPlayerUnit()
		
		self.wndMyButton = Apollo.LoadForm(self.xmlDoc, "myButton", nil, self)
		if self.wndMyButton == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		self.wndMyButton:Show(false)
		
		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)
		Apollo.RegisterSlashCommand("ocb", "OnOneClickBankOn", self)


		-- Do additional Addon initialization here
	end
end

-----------------------------------------------------------------------------------------------
-- OneClickBank Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/ocb"
function OneClickBank:OnOneClickBankOn()
	local anchor = {self.wndMyButton:GetAnchorOffsets()}
	self.log:debug("HFDDH")
	Print("lalalalalalalallalalalallalalalaal")
end

-- bank window opened event handler
function OneClickBank:AOnBankWindowOpened()
	self.log:debug("Bank opened.")

	--DBG_CHECK(self.bank.addon)
	--local i = 0
	--while self.bank.wnd == nil do
	--	self.bank.wnd = self.bank.addon.wndMain
	--	DBG_PRINT(i)
	--	i = i+1
	--end	
	

	--DBG_CHECK(self.bank.wnd)
		
	--local anchor = {wndBank:GetAnchorOffsets()}
	--DBG_PRINT(anchor[ANCHOR_LEFT])
	--DBG_PRINT(anchor[ANCHOR_TOP])
	--DBG_PRINT(anchor[ANCHOR_RIGHT])
	--DBG_PRINT(anchor[ANCHOR_BOTTOM])
	self.wndMyButton:Show(true)
	self.wndForm:Show(true)
	self.log:debug("Test")
end

-- bank window closed event handler
function OneClickBank:OnBankWindowClosed()
	self.log:debug("Bank closed.")
	self.wndMyButton:Close()
	self.wndForm:Close()
end

-----------------------------------------------------------------------------------------------
-- myButton Functions
-----------------------------------------------------------------------------------------------
-- bank window closed event handler
function OneClickBank:OnButtonClick()
	self.log:debug("Button Click.")
	self.bank.addon.wndMain:Close()
end


-----------------------------------------------------------------------------------------------
-- OCBForm Functions
-----------------------------------------------------------------------------------------------
function OneClickBank:OnDepositButtonClicked()
	self.log:debug("OnDepositButtonClicked")
end

function OneClickBank:OnWithdrawButtonClicked()
	self.log:debug("OnWithdrawButtonClicked")
end
-----------------------------------------------------------------------------------------------
-- OneClickBank Instance
-----------------------------------------------------------------------------------------------
local OneClickBankInst = OneClickBank:new()
OneClickBankInst:Init()

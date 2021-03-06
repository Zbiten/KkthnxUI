local K, C, L = unpack(select(2, ...))
if C["Unitframe"].Enable ~= true then
	return
end
local Module = K:GetModule("Unitframes")

local oUF = oUF or K.oUF

if not oUF then
	K.Print("Could not find a vaild instance of oUF. Stopping Unitframes.lua code!")
	return
end

local _G = _G

local CreateFrame = _G.CreateFrame
local UnitFrame_OnEnter = _G.UnitFrame_OnEnter
local UnitFrame_OnLeave = _G.UnitFrame_OnLeave

function Module:CreateTargetOfTarget()
	local UnitframeFont = K.GetFont(C["Unitframe"].Font)
	local UnitframeTexture = K.GetTexture(C["Unitframe"].Texture)

	self:RegisterForClicks("AnyUp")
	self:HookScript("OnEnter", UnitFrame_OnEnter)
	self:HookScript("OnLeave", UnitFrame_OnLeave)

	self.Health = CreateFrame("StatusBar", "$parent.Healthbar", self)
	self.Health:SetSize(74, 12)
	self.Health:SetPoint("CENTER", self, "CENTER", -15, 7)
	self.Health:SetStatusBarTexture(UnitframeTexture)

	self.Health.Background = self.Health:CreateTexture(nil, "BACKGROUND", -1)
	self.Health.Background:SetAllPoints()
	self.Health.Background:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])

	K.CreateBorder(self.Health)

	self.Health.Smooth = C["Unitframe"].Smooth
	self.Health.SmoothSpeed = C["Unitframe"].SmoothSpeed * 10
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = false
	self.Health.colorClass = true
	self.Health.colorReaction = true
	self.Health.frequentUpdates = false

	self.Health.Value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.Value:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
	self.Health.Value:SetFontObject(UnitframeFont)
	self.Health.Value:SetFont(select(1, self.Health.Value:GetFont()), 10, select(3, self.Health.Value:GetFont()))
	self:Tag(self.Health.Value, "[KkthnxUI:HealthPercent]")

	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetSize(74, 8)
	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -6)
	self.Power:SetStatusBarTexture(UnitframeTexture)

	self.Power.Background = self.Power:CreateTexture(nil, "BACKGROUND", -1)
	self.Power.Background:SetAllPoints()
	self.Power.Background:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])

	K.CreateBorder(self.Power)

	self.Power.Smooth = C["Unitframe"].Smooth
	self.Power.SmoothSpeed = C["Unitframe"].SmoothSpeed * 10
	self.Power.colorPower = true
	self.Power.frequentUpdates = false

	if (C["Unitframe"].PortraitStyle.Value == "ThreeDPortraits") then
		self.Portrait = CreateFrame("PlayerModel", nil, self)
		self.Portrait:SetSize(26, 26)
		self.Portrait:SetPoint("RIGHT", self, -4, 0)

		self.Portrait.Background = self.Portrait:CreateTexture(nil, "BACKGROUND", -1)
		self.Portrait.Background:SetAllPoints()
		self.Portrait.Background:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])

		self.Portrait.Borders = CreateFrame("Frame", nil, self.Portrait)
		self.Portrait.Borders:SetAllPoints(self.Portrait)
		K.CreateBorder(self.Portrait.Borders)
	elseif (C["Unitframe"].PortraitStyle.Value ~= "ThreeDPortraits") then
		self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND", nil, 1)
		self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
		self.Portrait:SetSize(26, 26)
		self.Portrait:SetPoint("RIGHT", self, -4, 0)

		self.Portrait.Background = self:CreateTexture(nil, "BACKGROUND", -1)
		self.Portrait.Background:SetPoint("RIGHT", self, -4, 0)
		self.Portrait.Background:SetSize(26, 26)
		self.Portrait.Background:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])

		self.Portrait.Borders = CreateFrame("Frame", nil, self)
		self.Portrait.Borders:SetPoint("RIGHT", self, -4, 0)
		self.Portrait.Borders:SetSize(26, 26)
		K.CreateBorder(self.Portrait.Borders)

		if (C["Unitframe"].PortraitStyle.Value == "ClassPortraits" or C["Unitframe"].PortraitStyle.Value == "NewClassPortraits") then
			self.Portrait.PostUpdate = Module.UpdateClassPortraits
		end
	end

	self.Name = K.SetFontString(self, C["Media"].Font, 12, C["Unitframe"].Outline and "OUTLINE" or "", "CENTER")
	self.Name:SetShadowOffset(C["Unitframe"].Outline and 0 or 1.25, C["Unitframe"].Outline and -0 or -1.25)
	self.Name:SetPoint("BOTTOM", self.Power, "BOTTOM", 0, -16)
	self:Tag(self.Name, "[KkthnxUI:GetNameColor][KkthnxUI:NameShort]")

	Module.CreateAuras(self, "targettarget")
	Module.CreateRaidTargetIndicator(self)
	Module.CreateThreatIndicator(self)

	self.Threat = {
		Hide = K.Noop, -- oUF stahp
		IsObjectType = K.Noop,
		Override = Module.CreateThreatIndicator,
	}

	self.Range = Module.CreateRange(self)
end
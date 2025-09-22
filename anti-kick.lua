local cloneref = cloneref or function(...) return ... end
local clonefunction = clonefunction or function(f) return f end

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local StarterGui = cloneref(game:GetService("StarterGui"))
local SetCore = clonefunction(StarterGui.SetCore)
local FindFirstChild = clonefunction(game.FindFirstChild)
for _, v in pairs(((getinstances or getnilinstances or function() return game:GetDescendants() end)() or {})) do
	pcall(function()
		if tostring(getscriptbytecode(v)):lower():find("adonis") then
			for _, con in pairs(getconnections(v.Changed)) do
				pcall(con.Disconnect, con)
			end
			pcall(v.Destroy, v)
		end
	end)
end
for _, v in pairs((getgc or getgarbagecollector)(true) or {}) do
	local ok, index = pcall(function() return rawget(v, "indexInstance") end)
	if ok and type(index) == "table" and index[1] == "kick" then
		setreadonly(v, false)
		v.tvk = {
			"kick",
			function() return game:GetService("Workspace"):WaitForChild("") end
		}
	end
end
for _, v in pairs((getreg or getregistry)() or {}) do
	if type(v) == "table" then
		local ok, index = pcall(function() return rawget(v, "indexInstance") end)
		if ok and type(index) == "table" and index[1] == "kick" then
			setreadonly(v, false)
			v.tvk = {
				"kick",
				function() return game:GetService("Workspace"):WaitForChild("") end
			}
		end
	end
end
for _, v in pairs(((getnilinstances or function() return {} end)() or {})) do
	pcall(function()
		if v:IsA("BaseScript") or v:IsA("ModuleScript") then
			for _, con in pairs(getconnections(v.Changed)) do
				pcall(con.Disconnect, con)
			end
			pcall(v.Destroy, v)
		end
	end)
end
if getgenv().AntiKick then return end
getgenv().AntiKick = {
	Enabled = true,
	SendNotifications = true,
	CheckCaller = true
}

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method:lower() == "kick" and self == LocalPlayer and getgenv().AntiKick.Enabled then
		if getgenv().AntiKick.SendNotifications then
			pcall(function()
				SetCore(StarterGui, "SendNotification", {
					Title = "Anti-Kick",
					Text = "Successfully intercepted an attempted kick.",
					Icon = "rbxassetid://6238540373",
					Duration = 2
				})
			end)
		end
		return
	end
	return OldNamecall(self, ...)
end))

local OldKick = hookfunction(LocalPlayer.Kick, function(...)
	if getgenv().AntiKick.Enabled then
		if getgenv().AntiKick.SendNotifications then
			pcall(function()
				SetCore(StarterGui, "SendNotification", {
					Title = "Anti-Kick",
					Text = "Successfully intercepted an attempted kick.",
					Icon = "rbxassetid://6238540373",
					Duration = 2
				})
			end)
		end
		return
	end
	return OldKick(...)
end)

if getgenv().AntiKick.SendNotifications then
	pcall(function()
		SetCore(StarterGui, "SendNotification", {
			Title = "Anti-Kick",
			Text = "Anti-Kick script loaded!",
			Icon = "rbxassetid://6238537240",
			Duration = 3
		})
	end)
end

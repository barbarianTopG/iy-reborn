for i, v in pairs(((getinstances or getnilinstances or function() return game:GetDescendants())() or {})) do
	pcall(function()
		if tostring(getscriptbytecode(v)):lower():find("adonis") then
			for i, v in pairs(getconnections(v.Changed)) do
				pcall(v.Disconnect, v)
			end
			pcall(v.Destroy, v)
		end
	end)
end
for k, v in pairs(((getgc or getgarbagecollector)(true) or {})) do
	if pcall(function()
		return rawget(v, "indexInstance")
	end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
		setreadonly(v, false)
		v.tvk = {
			"kick",
			function()
				return game:GetService("Workspace"):WaitForChild("")
			end
		}
	end
end
for k, v in pairs(((getreg or getregistry)() or {})) do
	if type(v) == "table" then
		local success, index = pcall(function() return rawget(v, "indexInstance") end)
		if success and type(index) == "table" and index[1] == "kick" then
			setreadonly(v, false)
			v.tvk = {
				"kick",
				function()
					return game:GetService("Workspace"):WaitForChild("")
				end
			}
		end
	end
end
for i, v in pairs(((getnilinstances)() or {})) do
	pcall(function()
		if v:IsA("BaseScript") or v:IsA("ModuleScript") then
			for i, v in pairs(getconnections(v.Changed)) do
				pcall(v.Disconnect, v)
			end
			pcall(v.Destroy, v)
		end
	end)
end
local getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, lower, gsub, match = getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, string.lower, string.gsub, string.match
if getgenv().AntiKick then
	return
end
local cloneref = cloneref or function(...) 
	return (...)
end
local clonefunction = clonefunction or function(afunction, ...)
    local clone = afunction
	return clone
end
local Players, LocalPlayer, StarterGui = cloneref(game:GetService("Players")), cloneref(game:GetService("Players").LocalPlayer), cloneref(game:GetService("StarterGui"))
local SetCore = clonefunction(StarterGui.SetCore)
local FindFirstChild = clonefunction(game.FindFirstChild)
local CompareInstances = (CompareInstances and function(Instance1, Instance2)
		if typeof(Instance1) == "Instance" and typeof(Instance2) == "Instance" then
			return CompareInstances(Instance1, Instance2)
		end
	end)
or
function(Instance1, Instance2)
	return (typeof(Instance1) == "Instance" and typeof(Instance2) == "Instance")-- and GetDebugId(Instance1) == GetDebugId(Instance2)
end
local CanCastToSTDString = function(...)
	return pcall(FindFirstChild, game, ...)
end
getgenv().AntiKick = {
	Enabled = true,
	SendNotifications = true,
	CheckCaller = true
}
local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
	local self, message = ...
	local method = getnamecallmethod()
	if ((getgenv().AntiKick.CheckCaller and not checkcaller()) or true) and CompareInstances(self, LocalPlayer) and gsub(method, "^%l", string.upper) == "Kick" and AntiKick.Enabled then
		if CanCastToSTDString(message) then
			if getgenv().AntiKick.SendNotifications then
				SetCore(StarterGui, "SendNotification", {
					Title = "Exunys Developer - Anti-Kick",
					Text = "Successfully intercepted an attempted kick.",
					Icon = "rbxassetid://6238540373",
					Duration = 2
				})
			end
			return
		end
	end
	return OldNamecall(...)
end))
local OldFunction; OldFunction = hookfunction(LocalPlayer.Kick, function(...)
	local self, Message = (...)
	if ((AntiKick.CheckCaller and not checkcaller()) or true) and CompareInstances(self, LocalPlayer) and AntiKick.Enabled then
		if CanCastToSTDString(Message) then
			if AntiKick.SendNotifications then
				SetCore(StarterGui, "SendNotification", {
					Title = "Anti-Kick",
					Text = "Successfully intercepted an attempted kick.",
					Icon = "rbxassetid://6238540373",
					Duration = 2
				})
			end
			return
		end
	end
end)

if getgenv().AntiKick.SendNotifications then
	StarterGui:SetCore("SendNotification", {
		Title = "Anti-Kick",
		Text = "Anti-Kick script loaded!",
		Icon = "rbxassetid://6238537240",
		Duration = 3
	})
end

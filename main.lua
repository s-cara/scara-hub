--// Services
local playerService = game:GetService('Players')
local userInputService = game:GetService('UserInputService')

--// Constants
local player = playerService.LocalPlayer

--// Functions
-- Exploit functions
local exploits = {
	['Click Teleport'] = {
		settings = {
			inTool = 'boolean',
			starterGear = 'boolean'
		},
		
		func = function(settings: {inTool: boolean, starterGear: boolean})
			local mouse = player:GetMouse()
			
			local function tp()
				local pos = mouse.Hit
				pos = CFrame.new(pos.X, pos.Y + 2.5, pos.Z)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
			end
			
			if settings.inTool then
				local function getTool()
					local tool = Instance.new("Tool", player.Backpack)
					tool.RequiresHandle = false
					tool.Name = "Click Teleport"

					tool.Activated:Connect(tp)
				end
				
				getTool()
				
				if settings.starterGear then
					player.CharacterAdded:Connect(getTool)
				end
				
			else
				userInputService.InputBegan:Connect(function(input, alreadyProcessed)
					if (input.UserInputType == Enum.UserInputType.MouseButton1) and not alreadyProcessed then
						tp()
					end
				end)
			end
		end
	}
}

local function init()
	local gui = Instance.new('ScreenGui')
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	
	local background = Instance.new('Frame', gui)
	background.AnchorPoint = Vector2.new(0.5, 0.5)
	background.Position = UDim2.new(0.5, 0, 0.5, 0)
	background.Size = UDim2.new(0, 250, 0, 350)
	background.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	background.BorderSizePixel = 0
		
	local top = Instance.new('TextButton', background)
	top.Size = UDim2.new(1, 0, 0, 50)
	top.Position = UDim2.new()
	top.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	top.BorderSizePixel = 0
	top.Text = '<b>SCARA HUB</b>'
	top.Font = Enum.Font.Gotham
	top.TextSize = 30
	top.RichText = true
	top.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	local buttons = 0
	local openPage: Frame
	
	local main = Instance.new('Frame', background)
	main.Size = UDim2.new(1, 0, 1, -50)
	main.Position = UDim2.new(0, 0, 0, 50)
	main.BackgroundTransparency = 1
	
	top.Activated:Connect(function()
		if openPage then
			openPage.Visible = false
			main.Visible = true
		end
	end)
	
	local function newButton(title: string, info: {settings: {any: any}, func: (any) -> nil}): TextButton
		local settings = {}
		
		local button = Instance.new('TextButton', main)
		
		button.Size = UDim2.new(1, -10, 0, 25)
		button.Position = UDim2.new(0, 5, 0, 5 + (buttons * 30))
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		
		button.Text = title
		button.Font = Enum.Font.GothamSemibold 
		button.TextSize = 15
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		
		Instance.new('UICorner', button).CornerRadius = UDim.new(0, 5)
		
		buttons += 1
		
		local page = Instance.new('Frame', background)
		page.Visible = false
		page.Size = UDim2.new(1, 0, 1, -50)
		page.Position = UDim2.new(0, 0, 0, 50)
		page.BackgroundTransparency = 1
		
		local execute = Instance.new('TextButton', page)
		execute.Size = UDim2.new(1, -10, 0, 25)
		execute.Position = UDim2.new(0, 5, 0, 5)
		execute.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

		execute.Text = 'Execute'
		execute.Font = Enum.Font.GothamSemibold
		execute.TextSize = 15
		execute.TextColor3 = Color3.fromRGB(255, 255, 255)
		
		Instance.new('UICorner', execute).CornerRadius = UDim.new(0, 5)
		
		execute.Activated:Connect(function()
			print(settings)
			info.func(settings)
		end)
		
		local pageButtons = 1
		for setting: string, settingType: string in info.settings do
			if settingType == 'boolean' then
				settings[setting] = false
			else
				continue
			end
			
			local settingTab = Instance.new('TextButton', page)
			settingTab.Size = UDim2.new(1, -10, 0, 25)
			settingTab.Position = UDim2.new(0, 5, 0, 5 + (pageButtons * 30))
			settingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

			settingTab.Text = ' '..setting
			settingTab.Font = Enum.Font.GothamSemibold
			settingTab.TextSize = 15
			settingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
			
			settingTab.TextXAlignment = Enum.TextXAlignment.Left
			
			Instance.new('UICorner', settingTab).CornerRadius = UDim.new(0, 5)
			
			local enabled = Instance.new('Frame', settingTab)
			enabled.AnchorPoint = Vector2.new(1, 0.5)
			enabled.Position = UDim2.new(1, -10, 0.5, 0)
			enabled.Size = UDim2.new(0, 10, 0, 10)
			
			enabled.BackgroundColor3 = Color3.new(255, 0, 0)
			
			Instance.new('UICorner', enabled).CornerRadius = UDim.new(0, 10)
			
			settingTab.Activated:Connect(function()
				settings[setting] = not settings[setting]
				
				enabled.BackgroundColor3 = if settings[setting] then Color3.new(0, 255, 0) else Color3.new(255, 0, 0)
			end)
			
			pageButtons += 1
		end
		
		button.Activated:Connect(function()
			main.Visible = false
			page.Visible = true
			
			openPage = page
		end)
		
		return button
	end
	
	for title: string, exploit: (any) -> nil in exploits do
		newButton(title, exploit)
	end
	
	gui.Parent = player.PlayerGui
end

init()

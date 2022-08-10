--// Services
local playerService = game:GetService('Players')
local userInputService = game:GetService('UserInputService')

--// Constants
local player = playerService.LocalPlayer
local font = Enum.Font.SourceSansSemibold
local fontSize = 18

--// Functions
-- Exploit functions
local exploits = {
	['Click Teleport'] = {
		settings = {
			starterGear = 'boolean'
		},
		
		func = function(settings: {starterGear: boolean})
			local mouse = player:GetMouse()
			
			local function getTool()
				local tool = Instance.new("Tool", player.Backpack)
				tool.RequiresHandle = false
				tool.Name = "Click Teleport"

				tool.Activated:Connect(function ()
					local pos = mouse.Hit
					pos = CFrame.new(pos.X, pos.Y + 2.5, pos.Z)
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
				end)
			end
				
			getTool()
				
			if settings.starterGear then
				player.CharacterAdded:Connect(getTool)
			end
		end
	},
	
	['Humanoid'] = {
		settings = {
			walkSpeed = 'number',
			jumpHeight = 'number'
		},
		
		func = function(settings: {walkSpeed: number, jumpHeight: number})
			local humanoid = player.Character:FindFirstChildWhichIsA('Humanoid')
			
			if settings.walkSpeed ~= 0 then
				humanoid.WalkSpeed = settings.walkSpeed
			end
			
			if settings.jumpHeight ~= 9 then
				humanoid.UseJumpPower = false
				humanoid.JumpHeight = settings.jumpHeight
			end
		end,
	},
	
	['Teleport To Player'] = {
		settings = {
			playerName = 'string'
		},
		
		func = function(settings: {playerName: string})
			player.Character.PrimaryPart.CFrame = game.Players[settings.playerName].Character.PrimaryPart.CFrame
		end,
	}
}

local function init()
	local gui = Instance.new('ScreenGui')
	gui.ResetOnSpawn = false
	
	local background = Instance.new('Frame', gui)
	background.Position = UDim2.new(0.5, 0, 0.5, 0)
	background.Size = UDim2.new(0, 250, 0, 350)
	background.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	background.BorderSizePixel = 0
		
	local top = Instance.new('TextLabel', background)
	top.Size = UDim2.new(1, 0, 0, 50)
	top.Position = UDim2.new()
	top.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	top.BorderSizePixel = 0
	top.Text = '<b>Porn<font color="rgb(255,163,26)">Hub</font></b>'
	top.Font = Enum.Font.Gotham
	top.TextSize = 30
	top.RichText = true
	top.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	local mouse = player:GetMouse()
	
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			background.AnchorPoint = Vector2.new((mouse.X - background.AbsolutePosition.X) / 250, (mouse.Y - background.AbsolutePosition.Y) / 350)
			
			repeat
				task.wait()
				background.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
				
			until input.UserInputState == Enum.UserInputState.End
		end
	end)
	
	userInputService.InputBegan:Connect(function(input, alreadyProcessed)
		if not alreadyProcessed and (input.KeyCode == Enum.KeyCode.RightShift) then
			background.Visible = not background.Visible
		end
	end)
	
	local back = Instance.new('TextButton', background)
	back.AnchorPoint = Vector2.new(0, 1)
	back.Size = UDim2.new(1, 0, 0, 25)
	back.Position = UDim2.new(0, 0, 1, 0)
	back.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	back.BorderSizePixel = 0
	back.Text = '<b>Return to main</b>'
	back.Font = font
	back.TextSize = fontSize
	back.RichText = true
	back.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	local buttons = 0
	local openPage: Frame
	
	local main = Instance.new('Frame', background)
	main.Size = UDim2.new(1, 0, 1, -75)
	main.Position = UDim2.new(0, 0, 0, 50)
	main.BackgroundTransparency = 1
	
	back.Activated:Connect(function()
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
		button.Font = font
		button.TextSize = fontSize
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
		execute.Font = font
		execute.TextSize = fontSize
		execute.TextColor3 = Color3.fromRGB(255, 255, 255)
		
		Instance.new('UICorner', execute).CornerRadius = UDim.new(0, 5)
		
		execute.Activated:Connect(function()
			info.func(settings)
		end)
		
		local pageButtons = 1
		for setting: string, settingType: string in info.settings do
			if settingType == 'boolean' then
				settings[setting] = false
				
			elseif settingType == 'string' then
				settings[setting] = ''
				
			elseif settingType == 'number' then
				settings[setting] = 0
			
			else
				continue
			end
			
			if settingType == 'boolean' then
				local settingTab = Instance.new('TextButton', page)
				settingTab.Size = UDim2.new(1, -10, 0, 25)
				settingTab.Position = UDim2.new(0, 5, 0, 5 + (pageButtons * 30))
				settingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

				settingTab.Text = setting
				settingTab.Font = font
				settingTab.TextSize = fontSize
				settingTab.TextColor3 = Color3.fromRGB(255, 255, 255)

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
				
			elseif (settingType == 'string') or (settingType == 'number') then
				local settingTab = Instance.new('TextBox', page)
				settingTab.Size = UDim2.new(1, -10, 0, 25)
				settingTab.Position = UDim2.new(0, 5, 0, 5 + (pageButtons * 30))
				settingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

				settingTab.PlaceholderText = ('%s: %s'):format(setting, settingType)
				settingTab.Text = ''
				settingTab.Font = font
				settingTab.TextSize = fontSize
				settingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
				settingTab.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)

				Instance.new('UICorner', settingTab).CornerRadius = UDim.new(0, 5)
				
				settingTab.FocusLost:Connect(function()
					settings[setting] = if settingType == 'number' then tonumber(settingTab.Text) else settingTab.Text
				end)
			end
			
			pageButtons += 1
		end
		
		button.Activated:Connect(function()
			main.Visible = false
			page.Visible = true
			
			openPage = page
		end)
		
		return button
	end
	
	for title: string, exploit: {any} in exploits do
		if exploit['settings'] then
			newButton(title, exploit)
		else
			exploit.func()
		end
	end
	
	gui.Parent = player.PlayerGui
end

init()

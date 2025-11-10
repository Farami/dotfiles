local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local keyboard = sbar.add("item", "widgets.keyboard", {
	position = "right",
	update_freq = 1,
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 14.0,
		},
		string = "", -- We'll use the flag as the icon
		color = colors.grey,
	},
	label = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 12.0,
		},
		string = "???",
		color = colors.white,
	},
})

-- Background around the keyboard item
sbar.add("bracket", "widgets.keyboard.bracket", { keyboard.name }, {
	background = { color = colors.bg1 },
})

-- Add padding after the bracket
sbar.add("item", "widgets.keyboard.padding", {
	position = "right",
	width = settings.group_paddings,
})

-- Set up input source change monitoring
sbar.exec([[
  # Kill any existing monitor
  pkill -f "fswatch.*HIToolbox"

  # Start monitoring HIToolbox.plist for changes
  (fswatch -0 ~/Library/Preferences/com.apple.HIToolbox.plist | while read -d "" event; do
    sketchybar --trigger input_change
  done) &
]])

-- Function to update the input language display
local function update_input_language()
	sbar.exec(
		[[
      defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources |
        awk -F'"' '/"Input Mode"|"KeyboardLayout Name"|"Bundle ID"/ {print $4}' |
        grep -v EmojiFunctionRowItem
    ]],
		function(result)
			if result and result ~= "" then
				-- Try to extract the layout name or input mode
				local display = "???"
				local flag = icons.keyboard.globe

				-- Check for Japanese input
				if result:match("com.apple.inputmethod.Kotoeri") then
					display = "JP"
					flag = icons.keyboard.languages.JP
				else
					display = result

					-- Try to find a matching flag for the layout
					for code, emoji in pairs(icons.keyboard.layouts) do
						if display:match(code) then
							flag = emoji
							break
						end
					end
					-- If no layout match found, try language match
					if flag == icons.keyboard.globe then
						for code, emoji in pairs(icons.keyboard.languages) do
							if display:match(code) then
								flag = emoji
								break
							end
						end
					end
				end

				keyboard:set({
					icon = { string = flag },
					label = { string = display },
				})
			end
		end
	)
end

-- Function to cycle to the next input source
local function cycle_input_source()
	sbar.exec([[
    osascript -e 'tell application "System Events" to keystroke space using {control down}'
  ]])
	-- Quick update after cycling
	sbar.delay(0.5, update_input_language)
end

-- Subscribe to click events to cycle input sources
keyboard:subscribe("mouse.clicked", cycle_input_source)

-- Subscribe to input source changes and system events
keyboard:subscribe({ "routine", "input_change", "system_woke" }, update_input_language)

-- Initial update
update_input_language()

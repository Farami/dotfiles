local settings = require("settings")

local icons = {
	sf_symbols = {
		plus = "􀅼",
		loading = "􀖇",
		apple = "􀣺",
		gear = "􀍟",
		cpu = "􀫥",
		clipboard = "􀉄",
		list = "󱃔",

		switch = {
			on = "􁏮",
			off = "􁏯",
		},
		volume = {
			_100 = "􀊩",
			_66 = "􀊧",
			_33 = "􀊥",
			_10 = "􀊡",
			_0 = "􀊣",
		},
		battery = {
			_100 = "􀛨",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},
		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			router = "􁓤",
		},
		media = {
			back = "􀊊",
			forward = "􀊌",
			play_pause = "􀊈",
		},
		keyboard = {
			globe = "🌐",
			layouts = {
				-- Common layouts
				ABC = "🇺🇸", -- US layout
				EurKEY = "🇪🇺", -- European layout
				QWERTY = "🇺🇸", -- US QWERTY
				AZERTY = "🇫🇷", -- French
				QWERTZ = "🇩🇪", -- German
			},
			languages = {
				JP = "🇯🇵", -- Japanese
				RU = "🇷🇺", -- Russian
				UA = "🇺🇦", -- Ukrainian
				GB = "🇬🇧", -- British
				FR = "🇫🇷", -- French
				DE = "🇩🇪", -- German
				IT = "🇮🇹", -- Italian
				ES = "🇪🇸", -- Spanish
				PT = "🇵🇹", -- Portuguese
				CN = "🇨🇳", -- Chinese
				KR = "🇰🇷", -- Korean
				VN = "🇻🇳", -- Vietnamese
			},
		},
	},

	-- Alternative NerdFont icons
	nerdfont = {
		plus = "",
		loading = "",
		apple = "",
		gear = "",
		cpu = "",
		clipboard = "Missing Icon",

		switch = {
			on = "󱨥",
			off = "󱨦",
		},
		volume = {
			_100 = "",
			_66 = "",
			_33 = "",
			_10 = "",
			_0 = "",
		},
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "Missing Icon",
		},
		media = {
			back = "",
			forward = "",
			play_pause = "",
		},
		keyboard = {
			globe = "󰌌",
			layouts = {
				-- Common layouts
				ABC = "", -- US layout
				EurKEY = "", -- European layout
				QWERTY = "", -- US QWERTY
				AZERTY = "", -- French
				QWERTZ = "", -- German
			},
			languages = {
				JP = "", -- Japanese
				RU = "", -- Russian
				UA = "", -- Ukrainian
				GB = "", -- British
				FR = "", -- French
				DE = "", -- German
				IT = "", -- Italian
				ES = "", -- Spanish
				PT = "", -- Portuguese
				CN = "", -- Chinese
				KR = "", -- Korean
				VN = "", -- Vietnamese
			},
		},
	},
}

if not (settings.icons == "NerdFont") then
	return icons.sf_symbols
else
	return icons.nerdfont
end

local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local timewarrior = sbar.add("item", "widgets.timewarrior", {
  position = "right",
  icon = {
    string = icons.list,
  },
  label = { font = { family = settings.font.numbers }, drawing = true },
  update_freq = 15,
  popup = { align = "center" }
})

local week_summary = sbar.add("item", {
  position = "popup." .. timewarrior.name,
  label = {
    string = "???",
    align = "left",
    font = { size = 12 },
    padding_left = 10,
    padding_right = 10,
    width = 400,
    max_lines = 50,
    scroll = true
  },
})

local function update_timewarrior()
  sbar.exec("timew get dom.active", function(is_active)
    if is_active == 0 then
      timewarrior:set({
        drawing = true,
        label = {
          string = "tw off",
        }
      })
      return
    end

    sbar.exec("timew get dom.active.duration", function(duration)
      -- Extract hours, minutes, and seconds from PT2H1M37S format
      local hours = duration:match("(%d+)H") or "0"
      local minutes = duration:match("(%d+)M") or "0"

      -- Format as HH:MM
      local formatted_duration = string.format("%s:%02d", hours, tonumber(minutes))

      timewarrior:set({
        drawing = true,
        label = {
          string = formatted_duration,
          drawing = true,
        }
      })
    end)
  end)
end

timewarrior:subscribe({ "routine", "system_woke" }, update_timewarrior)

timewarrior:subscribe("mouse.clicked", function(env)
  local drawing = timewarrior:query().popup.drawing
  timewarrior:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("timew summary 7days", function(summary)
      week_summary:set({
        label = {
          string = summary,
          drawing = true
        }
      })
    end)
  end
end)

sbar.add("bracket", "widgets.timewarrior.bracket", { timewarrior.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.timewarrior.padding", {
  position = "right",
  width = settings.group_paddings
})

update_timewarrior()

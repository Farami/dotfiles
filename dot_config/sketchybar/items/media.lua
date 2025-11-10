local icons = require("icons")
local colors = require("colors")

local whitelist = {
  ["spotify"] = true,
  ["music"] = true
};

local media_cover = sbar.add("item", {
  name = "media.cover",
  position = "right",
  background = {
    image = {
      scale = 0.05,
    },
    color = colors.transparent,
  },
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  updates = true,
  update_freq = 2,
  popup = {
    align = "center",
    horizontal = true,
  }
})

local media_artist = sbar.add("item", {
  name = "media.artist",
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    width = "dynamic",
    font = { size = 9 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 18,
    y_offset = 6,
  },
})

local media_title = sbar.add("item", {
  name = "media.title",
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,

  icon = { drawing = false },
  label = {
    font = { size = 11 },
    width = "dynamic",
    max_chars = 16,
    y_offset = -5,
  },
})

sbar.add("item", {
  name = "media.previous",
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.back },
  label = { drawing = false },
  click_script = "media-control previous-track",
})
sbar.add("item", {
  name = "media.play_pause",
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  click_script = "media-control toggle-play-pause",
})
sbar.add("item", {
  name = "media.next",
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  click_script = "media-control next-track",
})

-- Function to update media info using media-control
local function update_media()
  sbar.exec("media-control get", function(result)
    if result and result.bundleIdentifier then
      local app = result.bundleIdentifier
      local title = result.title
      local artist = result.artist
      local playing = result.playing
      local artwork = result.artworkData

      -- Normalize app bundleIdentifier for whitelist check
      local normalizedApp = app
      if app == "com.spotify.client" then
        normalizedApp = "spotify"
      elseif app == "com.apple.Music" then
        normalizedApp = "music"
      end

      if normalizedApp and whitelist[normalizedApp] and playing and title then
        -- Save artwork to temporary file if available
        if artwork and artwork ~= "" then
          local temp_path = "/tmp/sketchybar_media_artwork.jpg"
          -- Save base64 artwork data to file
          sbar.exec("echo '" .. artwork .. "' | base64 -d > " .. temp_path, function()
            media_cover:set({
              drawing = true,
              background = {
                image = {
                  string = temp_path,
                },
                drawing = true
              }
            })
          end)
        else
          -- No artwork available, show placeholder or hide image
          media_cover:set({
            drawing = true,
            background = {
              image = { drawing = false },
              drawing = true
            }
          })
        end

        media_artist:set({
          drawing = true,
          label = { string = artist or "Unknown Artist" }
        })
        media_title:set({
          drawing = true,
          label = { string = title }
        })
      else
        media_artist:set({ drawing = false })
        media_title:set({ drawing = false })
        media_cover:set({ drawing = false })
      end
    else
      media_artist:set({ drawing = false })
      media_title:set({ drawing = false })
      media_cover:set({ drawing = false })
    end
  end)
end

-- Subscribe to media_change event (keep for compatibility)
media_cover:subscribe("media_change", function(env)
  if env.INFO and env.INFO.app and whitelist[env.INFO.app] then
    local drawing = (env.INFO.state == "playing")
    media_artist:set({
      drawing = drawing,
      label = env.INFO.artist or ""
    })
    media_title:set({
      drawing = drawing,
      label = env.INFO.title or ""
    })
    media_cover:set({ drawing = drawing })
  else
    -- Fallback to media-control
    update_media()
  end
end)

-- Custom event for media-control updates
media_cover:subscribe("media_update", function(env)
  update_media()
end)

media_cover:subscribe("mouse.clicked", function(env)
  media_cover:set({ popup = { drawing = "toggle" } })
end)

media_title:subscribe("mouse.exited.global", function(env)
  media_cover:set({ popup = { drawing = false } })
end)

sbar.add("item", {
  name = "media.refresh",
  updates = true,
  update_freq = 3,
  position = "popup." .. media_cover.name,
  script = "sketchybar --trigger media_update",
})

-- Initial update
update_media()

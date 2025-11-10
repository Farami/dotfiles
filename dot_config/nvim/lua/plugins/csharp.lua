return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "uncrustify" },
      },
      formatters = {
        uncrustify = {
          command = "uncrustify",
          args = function(_, ctx)
            local args = { "-q", "-l", vim.bo[ctx.buf].filetype:upper() }

            -- Find uncrustify.cfg in the project if it exists
            local cfg_path = vim.fs.find("uncrustify.cfg", { upward = true, path = ctx.dirname })[1]

            -- If not found, use global config
            if not cfg_path then
              cfg_path = vim.fn.expand("~/.config/uncrustify/uncrustify.cfg")
            end

            table.insert(args, "-c")
            table.insert(args, cfg_path)

            return args
          end,
        },
      },
    },
  },
}

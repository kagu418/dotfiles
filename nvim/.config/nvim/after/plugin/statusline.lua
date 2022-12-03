local ok = pcall(require, "lualine")
if not ok then
  return
end

require("lualine").setup({
  sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
        shorting_target = 40,
      },
    },
    lualine_x = {
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "unix",
          dos = "dos",
          mac = "mac",
        },
      },
      {
        "filetype",
        colored = false,
        icon = { align = "left" },
      },
    },
  },
})

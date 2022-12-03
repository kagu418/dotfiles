local ok = pcall(require, "fidget")
if not ok then
  return
end

require("fidget").setup({
  text = {
    spinner = "moon",
  },
  align = {
    bottom = true,
  },
  window = {
    relative = "editor",
  },
})

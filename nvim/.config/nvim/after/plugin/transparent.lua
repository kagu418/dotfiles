if not pcall(require, "transparent") then
  return
end

require("transparent").setup({
  enable = false,
  groups = {
    "Normal",
    "NonText",
    "LineNr",
    "CursorLineNr",
    "SpecialKey",
    "Folded",
    "EndOfBuffer",
    "SignColumn",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
  },
})

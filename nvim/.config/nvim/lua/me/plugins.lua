local path = string.format("%s/site/pack/packer/start/packer.nvim", vim.fn.stdpath("data"))
local packer_bootstrap = vim.fn.empty(vim.fn.glob(path)) > 0

if packer_bootstrap then
  vim.fn.system(string.format("git clone --depth 1 https://github.com/wbthomason/packer.nvim %s", path))
  vim.cmd("packadd packer.nvim")
end

local function setup(plugin_name)
  if not pcall(require, plugin_name) then
    return
  end
  require(plugin_name).setup({})
end

require("packer").startup({
  function(use)
    -- package manager
    use({ "wbthomason/packer.nvim" })

    -- utils
    use({ "nvim-lua/plenary.nvim" })

    -- colorscheme
    use({ "arcticicestudio/nord-vim" })
    use({ "rose-pine/neovim", as = "rose-pine" })

    -- telescope
    use({
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope-ui-select.nvim" })

    -- treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update({
          with_sync = true,
        })
        ts_update()
      end,
    })
    use({
      "nvim-treesitter/playground",
      requires = { "nvim-treesitter/nvim-treesitter" },
      cmd = "TSPlaygroundToggle",
    })

    -- language server protocol
    use({ "neovim/nvim-lspconfig" })
    use({ "hrsh7th/nvim-cmp" })
    use({ "hrsh7th/cmp-buffer" })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-path" })
    use({ "jay-babu/mason-null-ls.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "jose-elias-alvarez/typescript.nvim" })
    use({ "folke/neodev.nvim" })
    use({ "onsails/lspkind-nvim" })
    use({ "L3MON4D3/LuaSnip" })
    use({ "rafamadriz/friendly-snippets" })
    use({ "saadparwaiz1/cmp_luasnip" })
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    use({ "ray-x/lsp_signature.nvim" })
    use({
      "folke/trouble.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = setup("trouble"),
    })

    -- statusline
    use({
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
    })

    -- git
    use({ "lewis6991/gitsigns.nvim" })
    use({ "rhysd/committia.vim" })
    use({ "tpope/vim-fugitive" })
    use({ "tpope/vim-rhubarb" })
    use({
      "sindrets/diffview.nvim",
      cmd = "DiffviewOpen",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-web-devicons" },
      },
    })

    use({ "j-hui/fidget.nvim" })
    use({ "jeffkreeftmeijer/vim-numbertoggle" })
    use({ "kyazdani42/nvim-web-devicons" })
    use({ "lewis6991/impatient.nvim" })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "mbbill/undotree", cmd = "UndotreeToggle" })
    use({
      "numToStr/Comment.nvim",
      config = setup("Comment"),
    })
    use({ "tpope/vim-dispatch", cmd = { "Dispatch", "Focus", "Make", "Start" } })
    use({ "tpope/vim-repeat" })
    use({ "tpope/vim-surround" })
    use({
      "windwp/nvim-autopairs",
      config = setup("nvim-autopairs"),
    })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})

local packer_sync_on_save = vim.api.nvim_create_augroup("PackerSyncOnSave", {})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = packer_sync_on_save,
  pattern = "plugins.lua",
  command = "source <afile> | PackerSync",
})

{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    gcc

    nixd
    nixpkgs-fmt

    nodejs_23

    ripgrep
    fd
  ];


  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set number
      set relativenumber
      set mouse=a
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab


      nnoremap o v
      nnoremap O V

      nnoremap K :t.<CR>
      nnoremap I m`O<Esc>``

      inoremap jk <Esc>

      nnoremap j h
      nnoremap k j
      nnoremap i k
      nnoremap u a
      nnoremap a i
      nnoremap J 0
      nnoremap L $

      vnoremap j h
      vnoremap k j
      vnoremap i k
      vnoremap u a
      vnoremap a i
      vnoremap J 0
      vnoremap L $

      vnoremap o <Esc>



      " Undo/Redo
      nnoremap <leader>h u
      nnoremap <leader>y <C-r>

      " === Text Objects ===
      nnoremap dhw diw
      nnoremap dhe di[
      nnoremap dhr di{
      nnoremap dhd di'
      nnoremap dhf di"
      nnoremap dhc di<
      nnoremap dhv di(
      nnoremap dht dit

      nnoremap duw daw
      nnoremap due da[
      nnoremap dur da{
      nnoremap dud da'
      nnoremap duf da"
      nnoremap duc da<
      nnoremap duv da(

      nnoremap chw ciw
      nnoremap che ci[
      nnoremap chr ci{
      nnoremap chd ci'
      nnoremap chf ci"
      nnoremap chc ci<
      nnoremap chv ci(
      nnoremap cht cit

      nnoremap cuw caw
      nnoremap cue ca[
      nnoremap cur ca{
      nnoremap cud ca'
      nnoremap cuf ca"
      nnoremap cuc ca<
      nnoremap cuv ca(

      nnoremap vhw yiw
      nnoremap vhe yi[
      nnoremap vhr yi{
      nnoremap vhd yi'
      nnoremap vhf yi"
      nnoremap vhc yi<
      nnoremap vhv yi(
      nnoremap vht yit

      nnoremap vuw yaw
      nnoremap vue ya[
      nnoremap vur ya{
      nnoremap vud ya'
      nnoremap vuf ya"
      nnoremap vuc ya<
      nnoremap vuv ya(

      vnoremap hw iw
      vnoremap he i[
      vnoremap hr i{
      vnoremap hd i'
      vnoremap hf i"
      vnoremap hc i<
      vnoremap hv i(
      vnoremap ht it

      vnoremap uw aw
      vnoremap ue a[
      vnoremap ur a{
      vnoremap ud a'
      vnoremap uf a"
      vnoremap uc a<
      vnoremap uv a(
      vnoremap ut at

      vnoremap <C-X> "+x
      nnoremap <C-X> "+dd

      vnoremap <C-C> "+y
      vnoremap Y "+y
      nnoremap <C-C> "+yy

      inoremap <C-V> <C-R>+
      vnoremap <C-V> "+p
      vnoremap P "+p
      nnoremap <C-V> "+p
      nnoremap P "+p

      nnoremap <C-Z> u
      inoremap <C-Z> <C-O>u

      nnoremap <C-Y> <C-R>
      inoremap <C-Y> <C-O><C-R>
      nnoremap <C-S-Z> <C-R>
      inoremap <C-S-Z> <C-O><C-R>

    '';

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      lualine-nvim
      catppuccin-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      neo-tree-nvim
      nvim-web-devicons
      plenary-nvim
      none-ls-nvim
      rust-tools-nvim
      cmp-nvim-lsp
      nvim-cmp
      luasnip
      cmp_luasnip
      friendly-snippets
      telescope-fzf-native-nvim
      trouble-nvim
      comment-nvim
      which-key-nvim
      gitsigns-nvim

      nvim-autopairs # Auto close brackets and quotes
      nvim-surround # Surround text objects
    ];

    extraLuaConfig = ''
      local builtin = require("telescope.builtin")


      require('nvim-treesitter.configs').setup({
         highlight = {enable = true},
          indent = {enable = true},
      })

      require('lualine').setup({
          options = {
              theme = 'dracula'
          }
      })

      require("catppuccin").setup({
          flavour = "mocha",  -- Dark mode (change to "latte" for light)
          integrations = {
              treesitter = true,  -- Better syntax highlighting
              cmp = true,         -- Better completions (if using nvim-cmp)
              telescope = true,
              gitsigns = true,
              which_key = true,
              mason = true,
          }
      })

      require("neo-tree").setup({
          close_if_last_window = true,  -- Close if no other windows
          enable_git_status = true,
          enable_diagnostics = true,
          filesystem = {
            filtered_items = {
              visible = true,  -- Show hidden files by default
              hide_dotfiles = false,
            },
          },

          window = {
              mappings = {
                  ["i"] = "none",
              },
          },
      })

      -- Better autopairs
      require("nvim-autopairs").setup {}

      -- Surround text objects
      require("nvim-surround").setup {}

      -- Set up completion
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- LSP setup
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Nix LSP
      require("lspconfig").nixd.setup({
          capabilities = capabilities,
          settings = {
            nixd = {
              formatting = { command = { "nixpkgs-fmt" } },
              flake = { autoEvalInputs = true },
            },
          },
      })

      -- Rust setup with rust-tools
      local rt = require("rust-tools")
      rt.setup({
        server = {
          capabilities = capabilities,
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy"
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true
              },
            }
          }
        },
      })

      local null_ls = require("null-ls")
      null_ls.setup({
          sources = {
              null_ls.builtins.formatting.alejandra,
          }
      })

      -- Set up trouble for better diagnostics view
      require("trouble").setup {
        icons = true,
        signs = {
            error = "E",
            warning = "W",
            hint = "H",
            information = "I",
            other = "O"
        },
      }

      -- Comment.nvim setup
      require('Comment').setup()

      -- Which-key for keybinding help
      require('which-key').setup()

      -- Git integration
      require('gitsigns').setup()

      -- Global keymappings
      vim.keymap.set('n', '<C-e>', ':Neotree toggle<CR>', { desc = "Toggle Neo-tree" })
      vim.keymap.set('n', "<C-f>", vim.lsp.buf.format, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = "Find References" })
      vim.keymap.set('n', 'H', vim.lsp.buf.hover, { desc = "Hover Documentation" })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show Diagnostic" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostic List" })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Actions" })
      vim.keymap.set('n', '<leader>x', ':TroubleToggle<CR>', { desc = "Toggle Trouble" })
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })

      vim.cmd.colorscheme("catppuccin")
      vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12"
 vim.opt.termguicolors = true
      
      -- Set transparency options
      -- For Neovide GUI
      vim.g.neovide_transparency = 0.8
      
      -- For terminal transparency
      vim.api.nvim_command('highlight Normal guibg=NONE ctermbg=NONE')
      vim.api.nvim_command('highlight NonText guibg=NONE ctermbg=NONE')
      vim.api.nvim_command('highlight LineNr guibg=NONE ctermbg=NONE')
      vim.api.nvim_command('highlight SignColumn guibg=NONE ctermbg=NONE')
      vim.api.nvim_command('highlight EndOfBuffer guibg=NONE ctermbg=NONE')     
    '';
  };
}

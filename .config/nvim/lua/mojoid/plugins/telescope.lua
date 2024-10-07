return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end

      telescope.setup {
        -- Basic Configuration
        defaults = {
          prompt_prefix = " > ",
          selection_caret = "> ",
          entry_prefix = "  ",
          initial_mode = "normal",
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.80,
            height = 0.55,
            prompt_position = "top",
            horizontal = {
              mirror = true,
              preview_width = 0.65,
            },
            vertical = {
              mirror = false,
              -- preview_width = 0.2,
            },
          },
          file_ignore_patterns = { 'node_modules', '.git' }, -- Hapus '__pycache__' dari daftar
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          path_display = { "shorten" },
          mappings = {
            i = {
              --["<esc>"] = actions.close,
              ["<M-n>"] = require('telescope.actions').cycle_history_next,
              ["<M-p>"] = require('telescope.actions').cycle_history_prev,
              ["<M-j>"] = require('telescope.actions').move_selection_next,
              ["<M-k>"] = require('telescope.actions').move_selection_previous,
            },
          },
          file_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        pickers = {
          find_files = {
            hidden = true, -- Aktifkan opsi untuk menampilkan file tersembunyi'rg',
          },
        },
        extensions = {
          extensions = {
            fzf = {
              fuzzy = true,                   -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true,    -- override the file sorter
              case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
              -- the default case_mode is "smart_case"
            },
          }
        }
      }

      -- Key Mappings
      local map = vim.keymap.set
      local builtin = require('telescope.builtin')

      map('n', '<leader>ff', builtin.find_files, { desc = "telescope find_files", noremap = true, silent = true })
      map('n', '<leader>fh', builtin.oldfiles, { desc = "telescope oldfiles", noremap = true, silent = true })
      map('n', '<leader>fg', builtin.live_grep, { desc = "telescope live_grep", noremap = true, silent = true })
      map('n', '<leader>fb', builtin.buffers, { desc = "telescope buffer / tab", noremap = true, silent = true })
      map('n', '<leader>f?', builtin.help_tags, { desc = "telescope help_tags", noremap = true, silent = true })
      map('n', '<leader>ft', builtin.treesitter, { desc = "telescope treesitter", noremap = true, silent = true })
      map('n', '<leader>fc', builtin.commands, { desc = "telescope commands", noremap = true, silent = true })
      map('n', '<leader>fd', builtin.colorscheme, { desc = "telescope colorscheme", noremap = true, silent = true })
      map('n', '<leader>fi', builtin.lsp_document_symbols,
        { desc = "telescope lsp_document_symbols", noremap = true, silent = true })
      map('n', '<leader>fs', builtin.grep_string, { desc = "telescope grep_string", noremap = true, silent = true })
      map('n', '<leader>fk', builtin.keymaps, { desc = "telescope keymaps", noremap = true, silent = true })

      -- Enable fzy native extension
      require('telescope').load_extension('fzf')
    end
  }
}

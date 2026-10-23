return {
	-- fish
	'khaveesh/vim-fish-syntax',
	-- circom syntax (works alongside circom-lsp)
	{
		'iden3/vim-circom-syntax',
		ft = { "circom" },
	},
	-- markdown
	{
		'plasticboy/vim-markdown',
		ft = { "markdown" },
		dependencies = {
			'godlygeek/tabular',
		},
		config = function()
			-- never ever fold!
			vim.g.vim_markdown_folding_disabled = 1
			-- support front-matter in .md files
			vim.g.vim_markdown_frontmatter = 1
			-- 'o' on a list item should insert at same level
			vim.g.vim_markdown_new_list_item_indent = 0
			-- don't add bullets when wrapping:
			-- https://github.com/preservim/vim-markdown/issues/232
			vim.g.vim_markdown_auto_insert_bullets = 0
		end
	},
	-- toml
	'cespare/vim-toml',
	-- yaml
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- jsonnet treesitter parser
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "terraform", "terraform-vars", "hcl" },
				callback = function(ev)
					pcall(vim.treesitter.start, ev.buf, "hcl")
				end,
			})
			vim.api.nvim_create_autocmd("VimEnter", {
				once = true,
				callback = function()
					vim.schedule(function()
						if vim.fn.exists(":TSInstall") == 2 then
							local required = { "jsonnet", "markdown", "markdown_inline", "nix", "rust", "lua", "vimdoc",
								"query", "hcl" }
							local missing = {}

							for _, parser in ipairs(required) do
								if not pcall(vim.treesitter.language.add, parser) then
									table.insert(missing, parser)
								end
							end

							if #missing > 0 then
								vim.cmd("silent! TSInstall " .. table.concat(missing, " "))
							end
						end
					end)
				end,
			})
		end,
		opts = function(_, opts)
			opts = opts or {}
			opts.ensure_installed = opts.ensure_installed or {}
			opts.auto_install = true
			opts.sync_install = false

			for _, parser in ipairs({ "jsonnet", "markdown", "markdown_inline", "nix", "rust", "lua", "vimdoc", "query", "hcl" }) do
				if not vim.tbl_contains(opts.ensure_installed, parser) then
					table.insert(opts.ensure_installed, parser)
				end
			end
		end,
	},

}

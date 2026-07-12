return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_create_augroup("myaugroup", { clear = true })
			local function format_on_save(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = "myaugroup", buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = "myaugroup",
						buffer = bufnr,
						callback = function() vim.lsp.buf.format() end,
					})
				end
			end

			vim.lsp.config['luals'] = {
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force",
						client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									"${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						})
				end,
				on_attach = format_on_save,

				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
						}
					},
					diagnostics = {
						globals = { 'vim' },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},

				cmd = { 'lua-language-server' },
				filetypes = { 'lua' },
			}

			vim.lsp.config('rust_analyzer', {
				cmd = { "rustup", "run", "stable", "rust-analyzer" },
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allTargets = false,
						},
						checkOnSave = {
							enable = true,
						},
						check = {
							allTargets = false,
							command = "clippy",
						},
						imports = {
							group = {
								enable = false,
							},
						},
						completion = {
							postfix = {
								enable = false,
							},
						},
					}
				}
			})
			vim.lsp.enable('rust_analyzer')

			vim.lsp.config['jsonnet_ls'] = {
				cmd = { 'jsonnet-language-server', '--lint' },
				filetypes = { 'jsonnet', 'libsonnet' },
			}
			vim.lsp.enable('jsonnet_ls')

			vim.lsp.config['circom_lsp'] = {
				cmd = { 'circom-lsp' },
				filetypes = { 'circom' },
				root_markers = { '.git', 'package.json' },
			}
			vim.lsp.enable('circom_lsp')

			vim.lsp.config['nixd'] = {
				cmd = { 'nixd' },
				filetypes = { 'nix' },
				root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
				settings = {
					nixd = {
						formatting = {
							command = { 'nixfmt' },
						},
					},
				},
			}
			vim.lsp.enable('nixd')

			vim.lsp.enable('luals')
			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					local function use_current_theme_for_hover(win)
						local bufnr = vim.api.nvim_win_get_buf(win)
						local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
						local float_border = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })

						float_border.bg = normal.bg
						vim.api.nvim_set_hl(0, 'LspHoverBorder', float_border)
						vim.wo[win].winhighlight = 'NormalFloat:Normal,FloatBorder:LspHoverBorder'

						vim.bo[bufnr].filetype = 'markdown'
						vim.bo[bufnr].syntax = 'markdown'
						pcall(vim.treesitter.start, bufnr, 'markdown')
					end

					local function lsp_hover()
						vim.api.nvim_create_autocmd('WinNew', {
							once = true,
							callback = function()
								vim.schedule(function()
									local hover_win = vim.b[ev.buf].lsp_floating_preview
									if hover_win and vim.api.nvim_win_is_valid(hover_win) then
										use_current_theme_for_hover(hover_win)
									end
								end)
							end,
						})

						vim.lsp.buf.hover({
							border = 'rounded',
							close_events = { 'CursorMoved', 'CursorMovedI', 'InsertCharPre' },
							focusable = true,
							max_height = math.min(math.floor(vim.o.lines * 0.35), 20),
							max_width = math.min(math.floor(vim.o.columns * 0.8), 100),
							wrap = true,
						})
					end

					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
					vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.name == 'nixd' and client:supports_method('textDocument/formatting') then
						vim.api.nvim_clear_autocmds({ group = 'myaugroup', buffer = ev.buf })
						vim.api.nvim_create_autocmd('BufWritePre', {
							group = 'myaugroup',
							buffer = ev.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
							end,
						})
					end

					if client and client:supports_method('textDocument/completion') then
						if client.name == 'rust_analyzer' then
							local trigger_chars = client.server_capabilities.completionProvider.triggerCharacters or {}

							for char in ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'):gmatch('.') do
								if not vim.tbl_contains(trigger_chars, char) then
									table.insert(trigger_chars, char)
								end
							end

							client.server_capabilities.completionProvider.triggerCharacters = trigger_chars
						end

						vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
					end

					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', lsp_hover, opts)
					vim.keymap.set('n', '<D-k>', lsp_hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)

					-- if client.server_capabilities.inlayHintProvider then
					-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					-- end

					-- Keep semantic tokens disabled by default, but allow them for Circom.
					if client and vim.bo[ev.buf].filetype ~= 'circom' then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})
		end,
	},
}

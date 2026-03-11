return {
	{
		"google/vim-jsonnet",
		ft = { "jsonnet", "libsonnet" },
		config = function()
			local function jsonnet_eval(file)
				local output = vim.fn.systemlist('jsonnet ' .. vim.fn.shellescape(file))
				if vim.v.shell_error ~= 0 then
					vim.notify(table.concat(output, '\n'), vim.log.levels.ERROR)
					return nil
				end
				return output
			end

			local function refresh_preview(src_buf, preview_buf)
				local file = vim.api.nvim_buf_get_name(src_buf)
				local output = jsonnet_eval(file)
				if output then
					vim.bo[preview_buf].modifiable = true
					vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, output)
					vim.bo[preview_buf].modifiable = false
				end
			end

			vim.api.nvim_create_user_command('JsonnetPreview', function()
				local src_buf = vim.api.nvim_get_current_buf()
				local file = vim.fn.expand('%:p')
				local output = jsonnet_eval(file)
				if not output then return end

				local preview_buf = vim.api.nvim_create_buf(false, true)
				vim.bo[preview_buf].filetype = 'json'
				vim.bo[preview_buf].modifiable = true
				vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, output)
				vim.bo[preview_buf].modifiable = false

				vim.cmd('vsplit')
				vim.api.nvim_win_set_buf(0, preview_buf)

				vim.api.nvim_create_autocmd('BufWritePost', {
					buffer = src_buf,
					callback = function()
						if vim.api.nvim_buf_is_valid(preview_buf) then
							refresh_preview(src_buf, preview_buf)
						else
							return true -- delete the autocmd if preview was closed
						end
					end,
				})
			end, {})
		end,
	},
}

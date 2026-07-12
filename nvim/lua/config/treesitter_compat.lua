local M = {}

function M.setup()
	local get_node_text = vim.treesitter.get_node_text

	-- nvim-treesitter predicates on older commits may pass quantified capture
	-- lists into get_node_text(), while Neovim 0.12 expects a TSNode.
	vim.treesitter.get_node_text = function(node, source, opts)
		if type(node) == "table" and node.range == nil then
			node = node[1]
		end

		if node == nil then
			return ""
		end

		return get_node_text(node, source, opts)
	end
end

return M

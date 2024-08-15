return {
	'windwp/nvim-autopairs',
	event = 'InsertEnter',
	config = function()
		require('nvim-autopairs').setup({
			-- FIXME: having this enabled breaks inserting newlines with enter
			-- fast_wrap = {
			-- 	map = '<C-m>',
			-- 	chars = { '{', '[', '(', '"', "'" },
			-- 	pattern = [=[[%'%"%>%]%)%}%,]]=],
			-- 	end_key = '$',
			-- 	before_key = 'h',
			-- 	after_key = 'l',
			-- 	cursor_pos_before = true,
			-- 	keys = 'qwertyuiopzxcvbnmasdfghjkl',
			-- 	manual_position = true,
			-- 	highlight = 'Search',
			-- 	highlight_grey = 'Comment'
			-- }
		})
	end
}

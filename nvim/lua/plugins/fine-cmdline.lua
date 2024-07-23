return {
	'VonHeikemen/fine-cmdline.nvim',
	depedencies = {
		{ 'MunifTanjim/nui.nvim' }
	},
	opts = {
		cmdline = {
			enable_keymaps = true,
			smart_history = true,
			prompt = ': '
		},
		popup = {
			position = {
				row = '30%',
				col = '50%',
			},
			size = {
				width = '60',
			},
			border = {
				style = 'rounded',
			},
			win_options = {
				winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
			},
		},
	}
}

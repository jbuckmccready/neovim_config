return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = function(ctx)
			-- delay if visual mode ('x') since usually don't want it
			return ctx.mode == 'x' and 500 or 0
		end
	},
}

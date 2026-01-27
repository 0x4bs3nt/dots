return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },

	version = "1.*",

	opts = {
		keymap = { preset = "enter" },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		completion = { documentation = { auto_show = true, auto_show_delay_ms = 10 } },

		signature = { enabled = true },

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}

return {
  -- GitHub Copilot: inline AI completions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_word = "<C-Right>",
          accept_line = "<C-End>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },

  -- CopilotChat: AI chat sidebar (requires GitHub Copilot subscription)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    opts = {
      model = "claude-sonnet-4",
      window = {
        layout = "vertical",
        width = 0.3,
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain selection" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Review selection" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix selection" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", mode = "v", desc = "Optimize selection" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Generate tests" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "Generate docs" },
    },
  },

  -- Avante: AI-powered code assistant (supports Claude, GPT, Copilot)
  -- To switch to direct Claude API: set provider = "claude" and add
  -- ANTHROPIC_API_KEY to ~/.config/secrets (see claude.claude.model below)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "copilot",
      -- claude = { model = "claude-sonnet-4-5-20251001", max_tokens = 8096 },
    },
    keys = {
      { "<leader>av", "<cmd>AvanteToggle<cr>", desc = "Toggle Avante" },
    },
  },

  -- Claude Code: open CLI in a terminal buffer
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ac",
        function() Snacks.terminal("claude") end,
        desc = "Open Claude Code",
      },
    },
  },
}

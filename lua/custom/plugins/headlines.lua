return {
  'lukas-reineke/headlines.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local headlines = require 'headlines'

    -- Markdown 和 Org 公共配置模板
    local function make_opts()
      return {
        headline_highlights = {
          'Headline1',
          'Headline2',
          'Headline3',
          'Headline4',
          'Headline5',
          'Headline6',
        },
        -- bullets = { '󰧞', '◉', '○', '✿', '•', '∙' },
        fat_headlines = false,
        -- fat_headline_upper_string = '█',
        -- fat_headline_lower_string = '█',
        codeblock_highlight = 'CodeBlock',
        dash_highlight = 'Dash',
        quote_highlight = 'Quote',
      }
    end

    headlines.setup {
      markdown = make_opts(),
      org = make_opts(),
    }

    -- 高亮
    local hl = vim.api.nvim_set_hl
    hl(0, 'Headline1', { bg = '#313244', fg = '#b4befe', bold = true })
    hl(0, 'Headline2', { bg = '#45475a', fg = '#89b4fa', bold = true })
    hl(0, 'Headline3', { bg = '#585b70', fg = '#74c7ec', bold = true })
    hl(0, 'Headline4', { bg = '#585b70', fg = '#94e2d5', bold = true })
    hl(0, 'Headline5', { bg = '#585b70', fg = '#a6e3a1', bold = true })
    hl(0, 'Headline6', { bg = '#585b70', fg = '#fab387', bold = true })

    hl(0, 'CodeBlock', { bg = '#1e1e2e', fg = '#cdd6f4', italic = true })
    hl(0, 'Dash', { fg = '#f9e2af', bold = true })
    hl(0, 'Quote', { fg = '#a6e3a1', italic = true })

    require('custom.headlines_mode_toggle').setup()
  end,
}

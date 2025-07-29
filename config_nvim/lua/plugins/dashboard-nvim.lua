return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        header = {
          'Welcome to Neovim!',
          '                  ',
        },
        week_header = {
          enable = true,
        },
        shortcut = {
          { 
            icon = '🔄 ',
            icon_hl = '@property',
            desc = 'Update', 
            group = '@property', 
            action = 'Lazy update', 
            key = 'u' 
          },
          {
            icon = '📁 ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'FzfLua files',
            key = 'f',
          },
          {
            icon = '🕒 ',
            icon_hl = 'DiagnosticHint',
            desc = 'Recent',
            group = 'DiagnosticHint',
            action = 'FzfLua oldfiles',
            key = 'r',
          },
          {
            icon = '⚙️  ',
            icon_hl = 'Number',
            desc = 'Config',
            group = 'Number',
            action = 'FzfLua files cwd=~/.config/nvim',
            key = 'c',
          },
        },
        project = {
          enable = true,
          limit = 8,
          icon = '📂 ',
          label = ' Recent Projects:',
          action = 'FzfLua files cwd=',
        },
        mru = {
          limit = 10,
          icon = '📝 ',
          label = ' Most Recent Files:',
        },
        footer = function()
          return { '🚀 Have a great coding session!' }
        end,
      },
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}

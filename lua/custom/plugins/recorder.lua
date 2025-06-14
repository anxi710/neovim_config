return {
  'chrisgrieser/nvim-recorder',
  -- dependencies = 'rcarriga/nvim-notify', -- optional
  opts = {
    -- default values

    -- Named registers where macros are saved (single lowercase letters only).
    -- The first register is the default register used as macro-slot after
    -- startup.
    slots = { 'a', 'b' },

    -- specify one of options:
    -- [static]   -> use static slots, this is default behaviour
    -- [rotate]   -> rotates through letters specified in slots[]
    dynamicSlots = 'static',

    mapping = {
      startStopRecording = '<leader>r',
      playMacro = '<leader>R',
      switchSlot = '<leader><C-r>',
      editMacro = '<leader>cr',
      deleteAllMacros = '<leader>dr',
      yankMacro = '<leader>yr',
      -- ⚠️ this should be a string you don't use in insert mode during a macro
      addBreakPoint = '##',
    },

    -- Clears all macros-slots on startup.
    clear = false,

    -- Log level used for non-critical notifications; mostly relevant for nvim-notify.
    -- (Note that by default, nvim-notify does not show the levels `trace` & `debug`.)
    logLevel = vim.log.levels.INFO, -- :help vim.log.levels

    -- If enabled, only essential notifications are sent.
    -- If you do not use a plugin like nvim-notify, set this to `true`
    -- to remove otherwise annoying messages.
    lessNotifications = false,

    -- Use nerdfont icons in the status bar components and keymap descriptions
    useNerdfontIcons = true,

    -- Performance optimizations for macros with high count. When `playMacro` is
    -- triggered with a count higher than the threshold, nvim-recorder
    -- temporarily changes changes some settings for the duration of the macro.
    performanceOpts = {
      countThreshold = 100,
      lazyredraw = true, -- enable lazyredraw (see `:h lazyredraw`)
      noSystemClipboard = true, -- remove `+`/`*` from clipboard option
      autocmdEventsIgnore = { -- temporarily ignore these autocmd events
        'TextChangedI',
        'TextChanged',
        'InsertLeave',
        'InsertEnter',
        'InsertCharPre',
      },
    },

    -- [experimental] partially share keymaps with nvim-dap.
    -- (See README for further explanations.)
    dapSharedKeymaps = false,
  },
}

" load all lua config
lua require('init')

" TODO figure out why vim.fn.sign_define in lsp.lua doesn't work
sign define LspDiagnosticsSignError text=✗ texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=ⓘ texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=✓ texthl=LspDiagnosticsSignHint linehl= numhl=


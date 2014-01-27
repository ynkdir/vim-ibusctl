if !exists('&imstatusfunc') || !has('gui_running')
  finish
endif

" Initialize after fork and GUI focus gained to get current input context.
autocmd FocusGained * call ibusctl#init()

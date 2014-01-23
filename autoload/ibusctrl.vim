let s:libpath = expand('<sfile>:p:h') . '/ibusctrl.so'
let s:init = 0

function ibusctrl#init()
  if s:init
    return
  endif
  call libcallnr(s:libpath, 'im_init', s:libpath)
  set imstatusfunc=ibusctrl#statusfunc
  set imactivatefunc=ibusctrl#activatefunc
  let s:init = 1
endfunction

function ibusctrl#statusfunc()
  return libcallnr(s:libpath, 'im_is_enabled', 0)
endfunction

function ibusctrl#activatefunc(active)
  if a:active
    call libcallnr(s:libpath, 'im_enable', 0)
  else
    call libcallnr(s:libpath, 'im_disable', 0)
  endif
endfunction


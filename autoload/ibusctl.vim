let s:libpath = expand('<sfile>:p:h') . '/ibusctl.so'
let s:init = 0

function ibusctl#init()
  if s:init
    return
  endif
  try
    let r = libcallnr(s:libpath, 'im_init', s:libpath)
  catch
    let r = -1
  endtry
  if r == 0
    set imstatusfunc=ibusctl#statusfunc
    set imactivatefunc=ibusctl#activatefunc
  endif
  let s:init = 1
endfunction

function ibusctl#statusfunc()
  return libcallnr(s:libpath, 'im_is_enabled', 0)
endfunction

function ibusctl#activatefunc(active)
  if a:active
    call libcallnr(s:libpath, 'im_enable', 0)
  else
    call libcallnr(s:libpath, 'im_disable', 0)
  endif
endfunction


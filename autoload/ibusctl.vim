let s:libpath = expand('<sfile>:p:h') . '/ibusctl.so'
let s:init = 0

function ibusctl#init() abort
  if s:init
    return
  endif
  let s:init = 1
  if libcallnr(s:libpath, 'im_init', s:libpath) != 0
    throw 'Error: im_init() failed'
  endif
  set imstatusfunc=ibusctl#statusfunc
  set imactivatefunc=ibusctl#activatefunc
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


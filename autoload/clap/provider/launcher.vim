let s:config_file = get(g:, 'clap_launcher_file', '~/.clap-launcher')

function! s:source() abort
  let file = fnamemodify(expand(s:config_file), ':p')
  let s:list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0]!~"^#"') : []
  let s:list += [["--edit-menu--", printf("split %s", s:config_file)]]
  return map(copy(s:list), 'v:val[0]')
endfunc

function! s:sink(str) abort
  let lines = filter(copy(s:list), 'v:val[0] == a:str')
  if len(lines) > 0 && len(lines[0]) > 1
    let cmd = lines[0][1]
    if cmd =~ '^!'
      silent exe cmd
    else
      exe cmd
    endif
  endif
endfunction

let s:launcher = {}
let s:launcher.sink = function('s:sink')
let s:launcher.source = function('s:source')

let g:clap#provider#launcher# = s:launcher


" function s:Puku(dir) abort
"     if findfile('.plzconfig', a:dir . ';') == ''
"         return
"     endif
"     let l:handlers = {}
"     function handlers.on_event(_, data, event) abort
"         if a:event == 'stderr'
"             echohl Error
"             defer execute('echohl None')
"         endif
"         for line in a:data[:-2]
"             echomsg 'puku: ' . line
"         endfor
"     endfunction
"     call jobstart(['puku', 'fmt', '...'], {
"         \ 'cwd': a:dir,
"         \ 'on_stdout': l:handlers.on_event,
"         \ 'on_stderr': l:handlers.on_event,
"         \ 'stdout_buffered': v:true,
"         \ 'stderr_buffered': v:true,
"     \ })
" endfunction
"
" augroup go
"     autocmd!
"     autocmd BufWritePost *.go call <SID>Puku(expand('<afile>:p:h'))
" augroup END

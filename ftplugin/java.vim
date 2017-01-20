" Java specific settings

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

" Function to handle job-exit
function! ExitHandler(job, exit_status) abort
    execute 'lgetfile ' . g:async_outfile | lwindow
    if a:exit_status == 0
	echo "No errors!"
    endif
    unlet g:async_outfile
endfunction

" Function to run jobs asynchronously (Vim 8 only)
function! RunAsync(command) abort
    if !filereadable(expand("build.xml"))
	echo "Buildfile: build.xml does not exist!"
    else
	let g:async_outfile = tempname()
	call job_start(a:command, {'exit_cb': 'ExitHandler', 'out_io': 'file', 'out_name': g:async_outfile})
    endif
endfunction

" Set <leader>\ to run 'ant'
nnoremap <buffer> <silent> <leader>\ :call RunAsync('ant')<CR>


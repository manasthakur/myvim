" Java specific settings

" Echo name of current method (works only for well-structured programs)
nnoremap <leader>f [m:echom getline('.')<CR><C-O>:1messages<CR>

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

" Function to handle job-exit
function! ExitHandler(job, exit_status) abort
    execute 'cgetfile ' . g:async_outfile
    echo ""
    if a:exit_status == 0
	echo "No errors!"
    endif
    unlet g:async_outfile
endfunction

" Function to run 'ant' asynchronously (Vim 8 only)
function! RunAsync(command) abort
    if !filereadable(expand("build.xml"))
	echo "Buildfile: build.xml does not exist!"
    else
	echo "Compiling..."
	let g:async_outfile = tempname()
	call job_start(a:command, {'exit_cb': 'ExitHandler', 'out_io': 'file', 'out_name': g:async_outfile})
    endif
endfunction

" Set <leader>\ to compile using 'ant'
if v:version >= 800
    nnoremap <buffer> <silent> <leader>\ :call RunAsync('ant')<CR>
else
    nnoremap <buffer> <leader>\ :silent cmake! \| cwindow \| redraw!<CR>
endif


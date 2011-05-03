" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software
" Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
"
" Copyright (C) Anderson Custódio de Oliveira (@acustodioo) 2011

func! EnterIndent()
	let EnterIndentActive = [
	\ {'left' : '[\{\[\(]','right' : '[\)\]\}]'},
	\ {'left' : '<[^>]*>', 'right' : '</[^>]*>'},
	\ {'left' : '<?\(php\)\?', 'right' : '?>'},
	\ {'left' : '<%', 'right' : '%>'},
	\ {'left' : '\[[^\]]*\]', 'right' : '\[/[^\]]*\]'},
	\ {'left' : '<!--', 'right' : '-->'},
	\ {'left' : '\(#\)\?{[^\}]*\}', 'right' : '\(#\)\?{/[^\}]*\}'},
	\ ]

	let GetLine = getline('.')
	let LeftGetLine = strpart(GetLine, 0, col('.') - 1)
	let RightGetLine = strpart(GetLine, col('.') - 1, col('$'))
	let RightGetLine = substitute(RightGetLine, '^[ ]*', '', '')

	if RightGetLine == "" | call feedkeys("\<CR>", 'n') | return '' | endif

	let LeftGetLine = substitute(LeftGetLine, '[ ]*$', '', '')

	for value in EnterIndentActive
		if matchstr(RightGetLine, '^' . value.right) != ""
			if matchstr(LeftGetLine, value.left . '$') != ""
				let EnterIndentRun = 1
			endif
			break
		endif
	endfor

	if !exists('EnterIndentRun') | call feedkeys("\<CR>", 'n') | return '' | endif

	let LineNow = line('.')
	let Indent = substitute(LeftGetLine, '^\([ |\t]*\).*$', '\1', '')
	call setline(LineNow, LeftGetLine)
	call append(LineNow, Indent . RightGetLine)
	call append(LineNow, Indent)
	call feedkeys("\<Down>\<End>\<Tab>", 'n')

	return ''
endf

inoremap <silent> <cr> <c-r>=EnterIndent()<cr>

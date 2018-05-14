bind '"\er": redraw-current-line'

fzf-bind () {
	local keyseq="$1"
	local cmd="$2"

	bind "'$keyseq': '\$($cmd)\e\C-e\er'"
}

fzf-bind '\C-g\C-f' fzf-gf
fzf-bind '\C-g\C-t' fzf-gt
fzf-bind '\C-g\C-b' fzf-gb
fzf-bind '\C-g\C-h' fzf-gh
fzf-bind '\C-g\C-r' fzf-gr

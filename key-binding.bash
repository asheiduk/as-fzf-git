fzf-bind-helper () {
	local line
	local -a lines
	while read line
	do
		lines+=("$line")
	done <<< "$*"

	local result="${lines[*]}"
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$result${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=$((READLINE_POINT + ${#result} ))
}

fzf-bind () {
	local keyseq="$1"
	local cmd="$2"

	# define custom wrapper function per key binding
	local widget_name="$cmd-widget"
	eval "$widget_name () { fzf-bind-helper \"\$($cmd)\"; }"

	bind -x "\"$keyseq\": $widget_name"
}

fzf-bind '\C-g\C-f' fzf-gf
fzf-bind '\C-g\C-t' fzf-gt
fzf-bind '\C-g\C-b' fzf-gb
fzf-bind '\C-g\C-h' fzf-gh
fzf-bind '\C-g\C-r' fzf-gr
fzf-bind '\C-g\C-l' fzf-gl
fzf-bind '\C-g\C-o' fzf-git-list-others
fzf-bind '\C-g\C-e' fzf-git-refs

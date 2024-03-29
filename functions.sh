# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

fzf-gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  sed 's/^...//; s/.* -> //'
}

fzf-gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\b' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --color=always --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} ) | head -'$LINES |
  sed 's/^..//; s#^remotes/##'
}

fzf-gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

fzf-gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

fzf-gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

fzf-gl() {
  is_in_git_repo || return
  git ls-files |
  fzf-down --multi
}

fzf-git-list-others() {
  is_in_git_repo || return
  git ls-files --others |
  fzf-down --multi
}

fzf-git-refs () {
  is_in_git_repo || return
  git for-each-ref --sort version:refname --format="%(objectname:short) %(align:6)%(objecttype)%(end) %(refname)" |
  (
    local_color=$(git config --get-color color.branch.local green)	# or color.decorate.branch
    remote_color=$(git config --get-color color.branch.remote red)	# or color.decorate.remoteBranch
    tag_color=$(git config --get-color color.decorate.tag yellow)
    stash_color=$(git config --get-color color.decorate.stash magenta)
    no_color=$(git config --get-color "" reset)
    sed -r \
      -e "s#( refs/heads/)(.*)#\1$local_color\2$no_color#" \
      -e "s#( refs/remotes/)(.*)#\1$remote_color\2$no_color#" \
      -e "s#( refs/tags/)(.*)#\1$tag_color\2$no_color#" \
      -e "s#( refs/)(stash.*)#\1$stash_color\2$no_color#" \
  ) |
  fzf-down --multi --ansi --preview 'git show --color=always {1}' |
  awk '{print $3}'
}

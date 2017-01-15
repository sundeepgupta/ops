# Aliases
# Personal
alias site5='ssh enhancet@209.15.238.85'

# Git
alias grh='git reset --hard'
alias grs='git reset --soft'
alias grs1='git reset --soft HEAD^'
alias gd='git diff'
alias gs='git status'
alias gl='git log --oneline'
alias stree='open -a SourceTree'
alias g='git'
alias gco='git checkout'
alias gc='git commit'

# Bash
alias bp='atom ~/code/ops/bash_profile'
alias sbp='. ~/.bash_profile'

# Heroku
alias h='heroku'

# DOSE
alias md='mongo deedevelopment'
alias ms='mongo mongodb://heroku_g4jvr5bz:p47fsiatkj29d2at1tb5f52t0h@ds019054.mlab.com:19054/heroku_g4jvr5bz'
alias mp='mongo mongodb://heroku_lx9qq94m:enr2s55i02snmlesrr3nca6pks@ds161315.mlab.com:61315/heroku_lx9qq94m'
alias ng='ngrok http 3000'
alias lc='loopback-console'
alias hls='heroku logs --tail -r staging'
alias hlp='heroku logs --tail -r production'
alias gpsd='g push -f staging dev:master'

# Node
alias ni='node-inspector --no-preload --save-live-edit'
alias nm='nodemon .'
alias nmi='nodemon --inspect .'
alias av='NODE_ENV=test ava -vw'

# npm
alias npme='PATH=$(npm bin):$PATH' #http://stackoverflow.com/questions/9679932/how-to-use-package-installed-locally-in-node-modules


# Prompt
# https://gist.github.com/31967
# The various escape codes that we can use to color our prompt.
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
PURPLE="\[\033[0;35m\]"
COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working tree clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^(# )?On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[2]}
  fi

  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable.
  PS1="
${BLUE}\w${COLOR_NONE} ${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

#add colours locally
export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced  #these colours don't work with white background.



#auto complete
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# git auto complete
# http://apple.stackexchange.com/questions/55875/git-auto-complete-for-branches-at-the-command-line
test -f ~/.git-completion.bash && . $_


# Ignore dupes in history: http://askubuntu.com/questions/15926/how-to-avoid-duplicate-entries-in-bash-history
export HISTCONTROL=ignoreboth:erasedups


if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi

autoload -U colors && colors

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:~/.local/share/bob/nvim-bin:/home/mthanuj/.cargo/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gallifrey"

CASE_SENSITIVE="false"

HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto

zstyle ':omz:update' frequency 5

DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="false"

plugins=(git npm yarn docker bun)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

HISTSIZE=10000
SAVEHIST=10000
source <(fzf --zsh)


# pnpm
export PNPM_HOME="/home/mthanuj/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(zoxide init zsh --cmd cd)"


export PATH=$PATH:/home/mthanuj/.spicetify

export PATH="$PATH:$(go env GOPATH)/bin"

# bun completions
[ -s "/home/mthanuj/.bun/_bun" ] && source "/home/mthanuj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(leetcode completions)"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

if [[ -n "$TMUX" ]]; then
  PANE_IDENTIFIER=$(tmux display-message -p '#{window_index}_#{pane_index}')
  TMUX_HISTORY_DIR=~/.zsh_history_tmux
  mkdir -p "$TMUX_HISTORY_DIR"
  export HISTFILE="${TMUX_HISTORY_DIR}/pane_${PANE_IDENTIFIER}"
fi

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

alias ls='eza --icons -1 --group-directories-first'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
bindkey '^H' backward-kill-word

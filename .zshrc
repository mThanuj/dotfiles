autoload -U colors && colors


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gallifrey"


CASE_SENSITIVE="false"

HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto

zstyle ':omz:update' frequency 5

DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="false"

plugins=(git npm yarn docker bun mvn)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:~/.local/share/bob/nvim-bin:$HOME/.cargo/bin:$PATH
export PATH=$HOME/scripts:$PATH
export JDTLS_JVM_ARGS="-javaagent:$HOME/dotfiles/lombok.jar -Xbootclasspath/a:$HOME/dotfiles/lombok.jar"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

source <(fzf --zsh)


# pnpm
export PNPM_HOME="/home/mthanuj/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



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
alias vi='nvim'
alias ta='tmux attach'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

bindkey '^H' backward-kill-word


#compdef kubectl
compdef _kubectl kubectl

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#compdef kubectl
compdef _kubectl kubectl

# zsh completion for kubectl                              -*- shell-script -*-

__kubectl_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_kubectl()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __kubectl_debug "\n========= starting completion logic =========="
    __kubectl_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __kubectl_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __kubectl_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., kubectl -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __kubectl_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __kubectl_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __kubectl_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __kubectl_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __kubectl_debug "No directive found.  Setting do default"
        directive=0
    fi

    __kubectl_debug "directive: ${directive}"
    __kubectl_debug "completions: ${out}"
    __kubectl_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __kubectl_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __kubectl_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __kubectl_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __kubectl_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __kubectl_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __kubectl_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __kubectl_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __kubectl_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __kubectl_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __kubectl_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __kubectl_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __kubectl_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __kubectl_debug "_describe did not find completions."
            __kubectl_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __kubectl_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __kubectl_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_kubectl" ]; then
    _kubectl
fi

if command -v minikube >/dev/null 2>&1; then
  source <(minikube completion zsh)
fi


autoload -U compinit
compinit


# Load Angular CLI autocompletion.
source <(ng completion script)
export AVANTE_GEMINI_API_KEY=AIzaSyALCmRpEiF6LzrIkQqL98wligg41P9eKwg

export DOTNET_ROOT=/usr/bin/dotnet
export PATH=$PATH:$DOTNET_ROOT
export PATH=$PATH:$DOTNET_ROOT/tools

export PATH="$PATH:/home/mthanuj/.dotnet/tools"

alias spot=spotify_player

#compdef spotify_player

autoload -U is-at-least

_spotify_player() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'-t+[Application theme]:THEME:_default' \
'--theme=[Application theme]:THEME:_default' \
'-c+[Path to the application'\''s config folder]:FOLDER:_default' \
'--config-folder=[Path to the application'\''s config folder]:FOLDER:_default' \
'-C+[Path to the application'\''s cache folder]:FOLDER:_default' \
'--cache-folder=[Path to the application'\''s cache folder]:FOLDER:_default' \
'-d[Running the application as a daemon]' \
'--daemon[Running the application as a daemon]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_spotify_player_commands" \
"*::: :->spotify_player" \
&& ret=0
    case $state in
    (spotify_player)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-command-$line[1]:"
        case $line[1] in
            (get)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
":: :_spotify_player__get_commands" \
"*::: :->get" \
&& ret=0

    case $state in
    (get)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-get-command-$line[1]:"
        case $line[1] in
            (key)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
':key:(playback devices user-playlists user-liked-tracks user-saved-albums user-followed-artists user-top-tracks queue)' \
&& ret=0
;;
(item)
_arguments "${_arguments_options[@]}" : \
'-i+[]: :_default' \
'--id=[]: :_default' \
'-n+[]: :_default' \
'--name=[]: :_default' \
'-h[Print help]' \
'--help[Print help]' \
':item_type:(playlist album artist track)' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__get__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-get-help-command-$line[1]:"
        case $line[1] in
            (key)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(item)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(playback)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
":: :_spotify_player__playback_commands" \
"*::: :->playback" \
&& ret=0

    case $state in
    (playback)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playback-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
":: :_spotify_player__playback__start_commands" \
"*::: :->start" \
&& ret=0

    case $state in
    (start)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playback-start-command-$line[1]:"
        case $line[1] in
            (context)
_arguments "${_arguments_options[@]}" : \
'-i+[]: :_default' \
'--id=[]: :_default' \
'-n+[]: :_default' \
'--name=[]: :_default' \
'-s[Shuffle tracks within the launched playback]' \
'--shuffle[Shuffle tracks within the launched playback]' \
'-h[Print help]' \
'--help[Print help]' \
':context_type:(playlist album artist)' \
&& ret=0
;;
(track)
_arguments "${_arguments_options[@]}" : \
'-i+[]: :_default' \
'--id=[]: :_default' \
'-n+[]: :_default' \
'--name=[]: :_default' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(liked)
_arguments "${_arguments_options[@]}" : \
'-l+[The limit for number of tracks to play]: :_default' \
'--limit=[The limit for number of tracks to play]: :_default' \
'-r[Randomly pick the tracks instead of picking tracks from the beginning]' \
'--random[Randomly pick the tracks instead of picking tracks from the beginning]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(radio)
_arguments "${_arguments_options[@]}" : \
'-i+[]: :_default' \
'--id=[]: :_default' \
'-n+[]: :_default' \
'--name=[]: :_default' \
'-h[Print help]' \
'--help[Print help]' \
'::item_type:(playlist album artist track)' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__playback__start__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playback-start-help-command-$line[1]:"
        case $line[1] in
            (context)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(track)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(liked)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(radio)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(play-pause)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(play)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(pause)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(next)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(previous)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(shuffle)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(repeat)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(volume)
_arguments "${_arguments_options[@]}" : \
'--offset[Increase the volume percent by an offset]' \
'-h[Print help]' \
'--help[Print help]' \
':percent:_default' \
&& ret=0
;;
(seek)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
':position_offset_ms:_default' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__playback__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playback-help-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__playback__help__start_commands" \
"*::: :->start" \
&& ret=0

    case $state in
    (start)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playback-help-start-command-$line[1]:"
        case $line[1] in
            (context)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(track)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(liked)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(radio)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
(play-pause)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(play)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(pause)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(next)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(previous)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(shuffle)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(repeat)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(volume)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(seek)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(connect)
_arguments "${_arguments_options[@]}" : \
'-i+[]: :_default' \
'--id=[]: :_default' \
'-n+[]: :_default' \
'--name=[]: :_default' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(like)
_arguments "${_arguments_options[@]}" : \
'-u[Unlike the currently playing track]' \
'--unlike[Unlike the currently playing track]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(authenticate)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(playlist)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
":: :_spotify_player__playlist_commands" \
"*::: :->playlist" \
&& ret=0

    case $state in
    (playlist)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playlist-command-$line[1]:"
        case $line[1] in
            (new)
_arguments "${_arguments_options[@]}" : \
'-p[Sets the playlist to public]' \
'--public[Sets the playlist to public]' \
'-c[Sets the playlist to collaborative]' \
'--collab[Sets the playlist to collaborative]' \
'-h[Print help]' \
'--help[Print help]' \
'::name:_default' \
'::description:_default' \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
'::id:_default' \
&& ret=0
;;
(import)
_arguments "${_arguments_options[@]}" : \
'-d[Deletes any previously imported tracks that are no longer in the imported playlist since last import.]' \
'--delete[Deletes any previously imported tracks that are no longer in the imported playlist since last import.]' \
'-h[Print help]' \
'--help[Print help]' \
'::from:_default' \
'::to:_default' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(fork)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
'::id:_default' \
&& ret=0
;;
(sync)
_arguments "${_arguments_options[@]}" : \
'-d[Deletes any previously imported tracks that are no longer in an imported playlist since last import.]' \
'--delete[Deletes any previously imported tracks that are no longer in an imported playlist since last import.]' \
'-h[Print help]' \
'--help[Print help]' \
'::id:_default' \
&& ret=0
;;
(edit)
_arguments "${_arguments_options[@]}" : \
'-t+[Track ID to add or remove]: :_default' \
'--track-id=[Track ID to add or remove]: :_default' \
'-a+[Album ID to add or remove]: :_default' \
'--album-id=[Album ID to add or remove]: :_default' \
'-h[Print help]' \
'--help[Print help]' \
':action -- Action to perform:(add delete)' \
':playlist_id -- Playlist ID:_default' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__playlist__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-playlist-help-command-$line[1]:"
        case $line[1] in
            (new)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(import)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(fork)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(sync)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(edit)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(generate)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
':shell:(bash elvish fish powershell zsh)' \
&& ret=0
;;
(search)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
':query -- Search query:_default' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-help-command-$line[1]:"
        case $line[1] in
            (get)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__help__get_commands" \
"*::: :->get" \
&& ret=0

    case $state in
    (get)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-help-get-command-$line[1]:"
        case $line[1] in
            (key)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(item)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
(playback)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__help__playback_commands" \
"*::: :->playback" \
&& ret=0

    case $state in
    (playback)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-help-playback-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__help__playback__start_commands" \
"*::: :->start" \
&& ret=0

    case $state in
    (start)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-help-playback-start-command-$line[1]:"
        case $line[1] in
            (context)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(track)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(liked)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(radio)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
(play-pause)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(play)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(pause)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(next)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(previous)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(shuffle)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(repeat)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(volume)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(seek)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
(connect)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(like)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(authenticate)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(playlist)
_arguments "${_arguments_options[@]}" : \
":: :_spotify_player__help__playlist_commands" \
"*::: :->playlist" \
&& ret=0

    case $state in
    (playlist)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:spotify_player-help-playlist-command-$line[1]:"
        case $line[1] in
            (new)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(import)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(fork)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(sync)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(edit)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
(generate)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(search)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_spotify_player_commands] )) ||
_spotify_player_commands() {
    local commands; commands=(
'get:Get Spotify data' \
'playback:Interact with the playback' \
'connect:Connect to a Spotify device' \
'like:Like currently playing track' \
'authenticate:Authenticate the application' \
'playlist:Playlist editing' \
'generate:Generate shell completion for the application CLI' \
'search:Search spotify' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player commands' commands "$@"
}
(( $+functions[_spotify_player__authenticate_commands] )) ||
_spotify_player__authenticate_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player authenticate commands' commands "$@"
}
(( $+functions[_spotify_player__connect_commands] )) ||
_spotify_player__connect_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player connect commands' commands "$@"
}
(( $+functions[_spotify_player__generate_commands] )) ||
_spotify_player__generate_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player generate commands' commands "$@"
}
(( $+functions[_spotify_player__get_commands] )) ||
_spotify_player__get_commands() {
    local commands; commands=(
'key:Get data by key' \
'item:Get a Spotify item'\''s data' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player get commands' commands "$@"
}
(( $+functions[_spotify_player__get__help_commands] )) ||
_spotify_player__get__help_commands() {
    local commands; commands=(
'key:Get data by key' \
'item:Get a Spotify item'\''s data' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player get help commands' commands "$@"
}
(( $+functions[_spotify_player__get__help__help_commands] )) ||
_spotify_player__get__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player get help help commands' commands "$@"
}
(( $+functions[_spotify_player__get__help__item_commands] )) ||
_spotify_player__get__help__item_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player get help item commands' commands "$@"
}
(( $+functions[_spotify_player__get__help__key_commands] )) ||
_spotify_player__get__help__key_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player get help key commands' commands "$@"
}
(( $+functions[_spotify_player__get__item_commands] )) ||
_spotify_player__get__item_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player get item commands' commands "$@"
}
(( $+functions[_spotify_player__get__key_commands] )) ||
_spotify_player__get__key_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player get key commands' commands "$@"
}
(( $+functions[_spotify_player__help_commands] )) ||
_spotify_player__help_commands() {
    local commands; commands=(
'get:Get Spotify data' \
'playback:Interact with the playback' \
'connect:Connect to a Spotify device' \
'like:Like currently playing track' \
'authenticate:Authenticate the application' \
'playlist:Playlist editing' \
'generate:Generate shell completion for the application CLI' \
'search:Search spotify' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player help commands' commands "$@"
}
(( $+functions[_spotify_player__help__authenticate_commands] )) ||
_spotify_player__help__authenticate_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help authenticate commands' commands "$@"
}
(( $+functions[_spotify_player__help__connect_commands] )) ||
_spotify_player__help__connect_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help connect commands' commands "$@"
}
(( $+functions[_spotify_player__help__generate_commands] )) ||
_spotify_player__help__generate_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help generate commands' commands "$@"
}
(( $+functions[_spotify_player__help__get_commands] )) ||
_spotify_player__help__get_commands() {
    local commands; commands=(
'key:Get data by key' \
'item:Get a Spotify item'\''s data' \
    )
    _describe -t commands 'spotify_player help get commands' commands "$@"
}
(( $+functions[_spotify_player__help__get__item_commands] )) ||
_spotify_player__help__get__item_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help get item commands' commands "$@"
}
(( $+functions[_spotify_player__help__get__key_commands] )) ||
_spotify_player__help__get__key_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help get key commands' commands "$@"
}
(( $+functions[_spotify_player__help__help_commands] )) ||
_spotify_player__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help help commands' commands "$@"
}
(( $+functions[_spotify_player__help__like_commands] )) ||
_spotify_player__help__like_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help like commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback_commands] )) ||
_spotify_player__help__playback_commands() {
    local commands; commands=(
'start:Start a new playback' \
'play-pause:Toggle between play and pause' \
'play:Resume the current playback if stopped' \
'pause:Pause the current playback if playing' \
'next:Skip to the next track' \
'previous:Skip to the previous track' \
'shuffle:Toggle the shuffle mode' \
'repeat:Cycle the repeat mode' \
'volume:Set the volume percentage' \
'seek:Seek by an offset milliseconds' \
    )
    _describe -t commands 'spotify_player help playback commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__next_commands] )) ||
_spotify_player__help__playback__next_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback next commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__pause_commands] )) ||
_spotify_player__help__playback__pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback pause commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__play_commands] )) ||
_spotify_player__help__playback__play_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback play commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__play-pause_commands] )) ||
_spotify_player__help__playback__play-pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback play-pause commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__previous_commands] )) ||
_spotify_player__help__playback__previous_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback previous commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__repeat_commands] )) ||
_spotify_player__help__playback__repeat_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback repeat commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__seek_commands] )) ||
_spotify_player__help__playback__seek_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback seek commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__shuffle_commands] )) ||
_spotify_player__help__playback__shuffle_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback shuffle commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__start_commands] )) ||
_spotify_player__help__playback__start_commands() {
    local commands; commands=(
'context:Start a context playback' \
'track:Start playback for a track' \
'liked:Start a liked tracks playback' \
'radio:Start a radio playback' \
    )
    _describe -t commands 'spotify_player help playback start commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__start__context_commands] )) ||
_spotify_player__help__playback__start__context_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback start context commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__start__liked_commands] )) ||
_spotify_player__help__playback__start__liked_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback start liked commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__start__radio_commands] )) ||
_spotify_player__help__playback__start__radio_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback start radio commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__start__track_commands] )) ||
_spotify_player__help__playback__start__track_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback start track commands' commands "$@"
}
(( $+functions[_spotify_player__help__playback__volume_commands] )) ||
_spotify_player__help__playback__volume_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playback volume commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist_commands] )) ||
_spotify_player__help__playlist_commands() {
    local commands; commands=(
'new:Create a new playlist' \
'delete:Delete a playlist' \
'import:Imports all songs from a playlist into another playlist.' \
'list:Lists all user playlists.' \
'fork:Creates a copy of a playlist and imports it.' \
'sync:Syncs imports for all playlists or a single playlist.' \
'edit:Add or remove tracks or albums from a playlist.' \
    )
    _describe -t commands 'spotify_player help playlist commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__delete_commands] )) ||
_spotify_player__help__playlist__delete_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist delete commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__edit_commands] )) ||
_spotify_player__help__playlist__edit_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist edit commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__fork_commands] )) ||
_spotify_player__help__playlist__fork_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist fork commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__import_commands] )) ||
_spotify_player__help__playlist__import_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist import commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__list_commands] )) ||
_spotify_player__help__playlist__list_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist list commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__new_commands] )) ||
_spotify_player__help__playlist__new_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist new commands' commands "$@"
}
(( $+functions[_spotify_player__help__playlist__sync_commands] )) ||
_spotify_player__help__playlist__sync_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help playlist sync commands' commands "$@"
}
(( $+functions[_spotify_player__help__search_commands] )) ||
_spotify_player__help__search_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player help search commands' commands "$@"
}
(( $+functions[_spotify_player__like_commands] )) ||
_spotify_player__like_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player like commands' commands "$@"
}
(( $+functions[_spotify_player__playback_commands] )) ||
_spotify_player__playback_commands() {
    local commands; commands=(
'start:Start a new playback' \
'play-pause:Toggle between play and pause' \
'play:Resume the current playback if stopped' \
'pause:Pause the current playback if playing' \
'next:Skip to the next track' \
'previous:Skip to the previous track' \
'shuffle:Toggle the shuffle mode' \
'repeat:Cycle the repeat mode' \
'volume:Set the volume percentage' \
'seek:Seek by an offset milliseconds' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playback commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help_commands] )) ||
_spotify_player__playback__help_commands() {
    local commands; commands=(
'start:Start a new playback' \
'play-pause:Toggle between play and pause' \
'play:Resume the current playback if stopped' \
'pause:Pause the current playback if playing' \
'next:Skip to the next track' \
'previous:Skip to the previous track' \
'shuffle:Toggle the shuffle mode' \
'repeat:Cycle the repeat mode' \
'volume:Set the volume percentage' \
'seek:Seek by an offset milliseconds' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playback help commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__help_commands] )) ||
_spotify_player__playback__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help help commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__next_commands] )) ||
_spotify_player__playback__help__next_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help next commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__pause_commands] )) ||
_spotify_player__playback__help__pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help pause commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__play_commands] )) ||
_spotify_player__playback__help__play_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help play commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__play-pause_commands] )) ||
_spotify_player__playback__help__play-pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help play-pause commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__previous_commands] )) ||
_spotify_player__playback__help__previous_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help previous commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__repeat_commands] )) ||
_spotify_player__playback__help__repeat_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help repeat commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__seek_commands] )) ||
_spotify_player__playback__help__seek_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help seek commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__shuffle_commands] )) ||
_spotify_player__playback__help__shuffle_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help shuffle commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__start_commands] )) ||
_spotify_player__playback__help__start_commands() {
    local commands; commands=(
'context:Start a context playback' \
'track:Start playback for a track' \
'liked:Start a liked tracks playback' \
'radio:Start a radio playback' \
    )
    _describe -t commands 'spotify_player playback help start commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__start__context_commands] )) ||
_spotify_player__playback__help__start__context_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help start context commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__start__liked_commands] )) ||
_spotify_player__playback__help__start__liked_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help start liked commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__start__radio_commands] )) ||
_spotify_player__playback__help__start__radio_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help start radio commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__start__track_commands] )) ||
_spotify_player__playback__help__start__track_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help start track commands' commands "$@"
}
(( $+functions[_spotify_player__playback__help__volume_commands] )) ||
_spotify_player__playback__help__volume_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback help volume commands' commands "$@"
}
(( $+functions[_spotify_player__playback__next_commands] )) ||
_spotify_player__playback__next_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback next commands' commands "$@"
}
(( $+functions[_spotify_player__playback__pause_commands] )) ||
_spotify_player__playback__pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback pause commands' commands "$@"
}
(( $+functions[_spotify_player__playback__play_commands] )) ||
_spotify_player__playback__play_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback play commands' commands "$@"
}
(( $+functions[_spotify_player__playback__play-pause_commands] )) ||
_spotify_player__playback__play-pause_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback play-pause commands' commands "$@"
}
(( $+functions[_spotify_player__playback__previous_commands] )) ||
_spotify_player__playback__previous_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback previous commands' commands "$@"
}
(( $+functions[_spotify_player__playback__repeat_commands] )) ||
_spotify_player__playback__repeat_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback repeat commands' commands "$@"
}
(( $+functions[_spotify_player__playback__seek_commands] )) ||
_spotify_player__playback__seek_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback seek commands' commands "$@"
}
(( $+functions[_spotify_player__playback__shuffle_commands] )) ||
_spotify_player__playback__shuffle_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback shuffle commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start_commands] )) ||
_spotify_player__playback__start_commands() {
    local commands; commands=(
'context:Start a context playback' \
'track:Start playback for a track' \
'liked:Start a liked tracks playback' \
'radio:Start a radio playback' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playback start commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__context_commands] )) ||
_spotify_player__playback__start__context_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start context commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help_commands] )) ||
_spotify_player__playback__start__help_commands() {
    local commands; commands=(
'context:Start a context playback' \
'track:Start playback for a track' \
'liked:Start a liked tracks playback' \
'radio:Start a radio playback' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playback start help commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help__context_commands] )) ||
_spotify_player__playback__start__help__context_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start help context commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help__help_commands] )) ||
_spotify_player__playback__start__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start help help commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help__liked_commands] )) ||
_spotify_player__playback__start__help__liked_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start help liked commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help__radio_commands] )) ||
_spotify_player__playback__start__help__radio_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start help radio commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__help__track_commands] )) ||
_spotify_player__playback__start__help__track_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start help track commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__liked_commands] )) ||
_spotify_player__playback__start__liked_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start liked commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__radio_commands] )) ||
_spotify_player__playback__start__radio_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start radio commands' commands "$@"
}
(( $+functions[_spotify_player__playback__start__track_commands] )) ||
_spotify_player__playback__start__track_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback start track commands' commands "$@"
}
(( $+functions[_spotify_player__playback__volume_commands] )) ||
_spotify_player__playback__volume_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playback volume commands' commands "$@"
}
(( $+functions[_spotify_player__playlist_commands] )) ||
_spotify_player__playlist_commands() {
    local commands; commands=(
'new:Create a new playlist' \
'delete:Delete a playlist' \
'import:Imports all songs from a playlist into another playlist.' \
'list:Lists all user playlists.' \
'fork:Creates a copy of a playlist and imports it.' \
'sync:Syncs imports for all playlists or a single playlist.' \
'edit:Add or remove tracks or albums from a playlist.' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playlist commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__delete_commands] )) ||
_spotify_player__playlist__delete_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist delete commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__edit_commands] )) ||
_spotify_player__playlist__edit_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist edit commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__fork_commands] )) ||
_spotify_player__playlist__fork_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist fork commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help_commands] )) ||
_spotify_player__playlist__help_commands() {
    local commands; commands=(
'new:Create a new playlist' \
'delete:Delete a playlist' \
'import:Imports all songs from a playlist into another playlist.' \
'list:Lists all user playlists.' \
'fork:Creates a copy of a playlist and imports it.' \
'sync:Syncs imports for all playlists or a single playlist.' \
'edit:Add or remove tracks or albums from a playlist.' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'spotify_player playlist help commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__delete_commands] )) ||
_spotify_player__playlist__help__delete_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help delete commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__edit_commands] )) ||
_spotify_player__playlist__help__edit_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help edit commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__fork_commands] )) ||
_spotify_player__playlist__help__fork_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help fork commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__help_commands] )) ||
_spotify_player__playlist__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help help commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__import_commands] )) ||
_spotify_player__playlist__help__import_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help import commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__list_commands] )) ||
_spotify_player__playlist__help__list_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help list commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__new_commands] )) ||
_spotify_player__playlist__help__new_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help new commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__help__sync_commands] )) ||
_spotify_player__playlist__help__sync_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist help sync commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__import_commands] )) ||
_spotify_player__playlist__import_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist import commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__list_commands] )) ||
_spotify_player__playlist__list_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist list commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__new_commands] )) ||
_spotify_player__playlist__new_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist new commands' commands "$@"
}
(( $+functions[_spotify_player__playlist__sync_commands] )) ||
_spotify_player__playlist__sync_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player playlist sync commands' commands "$@"
}
(( $+functions[_spotify_player__search_commands] )) ||
_spotify_player__search_commands() {
    local commands; commands=()
    _describe -t commands 'spotify_player search commands' commands "$@"
}

if [ "$funcstack[1]" = "_spotify_player" ]; then
    _spotify_player "$@"
else
    compdef _spotify_player spotify_player
fi

export PRETTIERD_DEFAULT_CONFIG="$HOME/dotfiles/.config/prettier.json"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval "$(zoxide init zsh --cmd cd)"

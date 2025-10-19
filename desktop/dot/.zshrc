#############################################
#GLOBALS
#############################################
export STARTUP_TIMER="true"
export EDITOR=micro

if [ -f ~/.functions ]; then
    source ~/.functions
fi
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
if [ -f ~/.profile ]; then
    source ~/.profile
fi
if [ -f ~/.inputrc ]; then
    source ~/.inputrc
fi
if [ -f ~/usr/share/doc/pkgfile/command-not-found.zsh ]; then
source ~/usr/share/doc/pkgfile/command-not-found.zsh
fi
export TERM=xterm-256color
export LOCAL_IP=$(ip route get 1 | awk '{print $7}')
export PATH="$HOME/bin:$HOME/.local/bin:/sbin:/usr/sbin:/opt/android-studio/bin:/usr/local/sbin:$HOME/.local/bin:$HOME/.atuin/bin:$PATH"
# Check for 'moar' first; if not found, check for 'less'; if neither, default to 'more'
if command -v moar &> /dev/null; then
    alias moar="moar -colors auto -wrap -mousemode auto"
    alias more='moar'
    alias less='moar'
    export PAGER=moar
elif command -v less &> /dev/null; then
    export PAGER=less
elif command -v more &> /dev/null; then
    export PAGER=more
fi
setopt CORRECT
#############################################
# Plugins
#############################################

# Load autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Configure autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  # Adjust this number for visibility

# Load fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Configure highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

#############################################
#EXPORTS
#############################################
if [[ "$STARTUP_TIMER" == "true" ]]; then
    START_TIME=$(date +%s%N)
fi
export HISTSIZE=10000  # Optional, for in-session buffer
export SAVEHIST=10000  # Optional, for in-session buffer

if [ -f ~/bin/nnn_opener.sh ]; then
export NNN_OPENER=~/bin/nnn_opener.sh
fi
#/home/anon/.config/nnn/plugins/nuke
export NNN_PAGER="$PAGER"
export NNN_PLUG="p:preview-tui;f:fzcd"
export NNN_FCOLORS='c1e2B32e006033f7c6d6abc4'
export NNN_BATTHEME='Nord'
export NNN_BATSTYLE='plain'
export NNN_TERMINAL=kitty
#export NNN_ICONLOOKUP=1

# Define LS_COLORS if not already set
if [ -z "$LS_COLORS" ]; then
    # Modified LS_COLORS definitions
    # di=directory, ow=other-writable
    LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;31:ex=1;32:bd=1;34;46:cd=1;34;46:su=0;41:sg=0;46:tw=0;34:ow=1;34:'
    export LS_COLORS
fi

# Colors
user_color="%F{green}"
location_color="%F{cyan}"
hostname_color="%F{blue}"
# Construct the prompt with dynamic hostname coloring
PROMPT="${user_color}%n%f@${hostname_color}%m ${location_color}%~%f -> "

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#########################################
#AUTOCOMPLETE MAGIC
#########################################

autoload -Uz compinit
compinit

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/$HOST

# Ignored patterns
zstyle ':completion:*:functions' ignored-patterns '_*'
# Simplify ignored users - you probably don't need to ignore *all* of these
zstyle ':completion:*:*:users' ignored-patterns root
# Less restrictive ignored patterns for editors
zstyle ':completion:*:*:(vim|nvim|nano|emacs|vi):*' ignored-patterns '*/.#*'

# Ordering and matching
zstyle ':completion:*' completer _expand _complete _ignored _approximate _prefix
zstyle ':completion:*' group-order dirs files
# More robust matching (add to existing matcher-list)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z}={A-Z} m:{A-Z}={a-z}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*' \
  'l:|=* r:|=* l:|=* r:|=*'
  # Consider adding these for even more flexible matching:
  # 'b:=* B:=*'  # Allow inserting characters at the beginning
  # 'm:{[:lower:]}={[:upper:]} m:{[:upper:]}={[:lower:]} r:|[._-]=* r:|=* l:|=* r:|=*' # Case-insensitive + other matchers

# Remove duplicates (these settings are good)
zstyle ':completion:*' ignored-patterns '*[[:blank:]][[:blank:]]*'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' unique true

# Formatting (these are good)
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%F{cyan}%B%d%b%f'
zstyle ':completion:*:messages' format '%F{blue}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# Grouping Files and Directories (these are good)
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:files' menu yes select
zstyle ':completion:*' file-sort 'case-insensitive'

if [[ -z "$NOMENU" ]] ; then
zstyle ':completion:*' menu select=2
else
  setopt no_auto_menu # don't use any menus at all
fi

# display the part of the suggestion that comes after the prefix you have already typed
# zstyle ':completion:*' prefix-hidden true  # Commented out - can interfere with predictions

# Colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Hostname completion - simplified
zstyle ':completion:*' hosts $(hostname -f 2>/dev/null; hostname -s 2>/dev/null)

# Offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Process completion for all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# Add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# SSH/SCP completion
zstyle ':completion:*:scp:*' tag-order \
  files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
  files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
  users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
  hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

#############################################
#Individual program initialization
#############################################
# Ensure zoxide and atuin are initialized unconditionally
if [[ -x "$(command -v zoxide)" ]]; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi
eval "$(atuin init zsh)"  # Atuin initialization - made unconditional
[[ -x "$(command -v oh-my-posh)" ]] && eval "$(oh-my-posh init zsh --config ~/.config/omp.json)"


#############################################
#RAN EVERY REFRESH
#############################################

fastfetch

if [[ "$STARTUP_TIMER" == "true" ]]; then
    # End measuring time
    END_TIME=$(date +%s%N)
    STARTUP_TIME_NS=$((END_TIME - START_TIME))
    STARTUP_TIME_S=$((STARTUP_TIME_NS / 1000000000))
    STARTUP_TIME_MS=$(( (STARTUP_TIME_NS / 1000000) % 1000 ))
    # Display startup time
    if [ $STARTUP_TIME_S -eq 0 ]; then
        echo "Shell startup time: ${STARTUP_TIME_MS} milliseconds"
    else
        echo "Shell startup time: ${STARTUP_TIME_S} seconds and ${STARTUP_TIME_MS} milliseconds"
    fi
fi

# nnn file manager configuration
# Added by setup-nnn.sh

# nnn environment variables
if [ -f ~/bin/nnn_opener.sh ]; then
    export NNN_OPENER=~/bin/nnn_opener.sh
fi
export NNN_PAGER="${PAGER:-less}"
export NNN_PLUG="p:preview-tui;f:fzf"
export NNN_FCOLORS='c1e2B32e006033f7c6d6abc4'
export NNN_BATTHEME='Nord'
export NNN_BATSTYLE='plain'

# nnn function with advanced features
nn(){
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }
    if [ -z "$EDITOR" ]; then
        EDITOR=nano
    fi

    NNN_FIFO="$(mktemp --suffix=-nnn -u)"
    export NNN_FIFO
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    (umask 077; mkfifo "$NNN_FIFO")
    command nnn -dHEPp "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

# nnn minimal function
n(){
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }
    if [ -z "$EDITOR" ]; then
        EDITOR=nano
    fi

    NNN_FIFO="$(mktemp --suffix=-nnn -u)"
    export NNN_FIFO
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    (umask 077; mkfifo "$NNN_FIFO")
    command nnn -E "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

. "$HOME/.local/share/../bin/env"

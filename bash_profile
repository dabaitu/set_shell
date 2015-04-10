# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Bookmark
function bm() {
    USAGE="Usage: bm [-c|-g|-d|-l] [bookmark]" ;
    if  [ ! -e ~/.cd_bookmarks ] ; then
        mkdir ~/.cd_bookmarks
    fi

    case $1 in
        # create bookmark
        -c) shift
            if [ ! -f ~/.cd_bookmarks/$1 ] ; then
                echo "cd `pwd`" > ~/.cd_bookmarks/"$1" ;
            else
                echo "Try again! Looks like there is already a bookmark '$1'"
            fi
            ;;
        # goto bookmark
        -g) shift
            if [ -f ~/.cd_bookmarks/$1 ] ; then 
                source ~/.cd_bookmarks/"$1"
            else
                echo "Mmm...looks like your bookmark has spontaneously combusted. What I mean to say is that your bookmark does not exist." ;
            fi
            ;;
        # delete bookmark
        -d) shift
            if [ -f ~/.cd_bookmarks/$1 ] ; then 
                rm ~/.cd_bookmarks/"$1" ;
            else
                echo "Oops, forgot to specify the bookmark" ;
            fi    
            ;;
        # list bookmarks
        -l) shift
            ls -l ~/.cd_bookmarks/ ;
            ;;
         *) echo "$USAGE" ;
            ;;
    esac
}

alias gt="bm -g"

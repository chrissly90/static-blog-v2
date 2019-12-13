# In this Post I am showing you how to manage Dotfiles with git:

1. First we create a Bare Repository:
```bash
$ git init --bare $HOME/.cfg
```

2. Then we create an alias:
```bash
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
```

3. Then we execute the following command exactly ONCE:
```bash
$ config config --local status.showUntrackedFiles no
```

else "config status" would show all files of your Homedirs as untracked
Now you can use the command "config" like you would use git command.
config status / commit / pull / push ... merge, rebase, reset...

I've created in my .zshrc (it should work also) 
using the following functions und aliases:

```bash
# config command
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# I'm lazy, so just commit with some machine info
function dotfiles_autoupdate {
    config add -u && \
    config commit -m "Update $(date +"%Y-%m-%d %H:%M") $(uname -s)/$(uname -m)" && \
    config push
}

# please give me my dotfiles...
function dotfiles_init {
    git --no-replace-objects clone --bare \
        https://git.tinfoil-hat.net/aluhut/dotfiles $HOME/.cfg
    config config --local status.showUntrackedFiles no
    config checkout -f
}
```

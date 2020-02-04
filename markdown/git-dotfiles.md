### Author: [https://codevoid.de/](https://codevoid.de/)

He does his configuration Management sice years with git and without Symlinks.
His Solution is more than simple:

1) you create an empy bare git repo like this:

```bash
git init --bare $HOME/.cfg
```
whith this Step you hace a repo inside your home directory ```$HOME/.cfg ```. Inside there are laying your git management files.

2) then you create an alias:
```bash
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
```

3) then you should execute ONCE the following:
```bash
config config --local status.showUntrackedFiles no
```
if you execute it more than once, all your Home Files would be marked always as untracked. If you execute config status.

Now you can use the command ```config``` as you would do with git.

```bash
config status / commit / pull / push ... merge, rebase, reset...
```

4) If you have now a file or a folder which you want to add to your dotfiles, then simply add it:

```bash

config add .vim
config commit -m "My new VIM config"
config push
```
5) you can of course set an upstream URLto Github / Gitlab / Gitea etc. and push it

```bash
git clone --bare https://...../dotfiles.git $HOME/.cfg
```

6) codevoid has created the following ksh aliases (should also work for bash)

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
        git@codevoid.de:dotfiles.git $HOME/.cfg
    config config --local status.showUntrackedFiles no
    config checkout -f
}
```

you can fint this and more in his dotfiles: [https://codevoid.de/?q=/1/git/dotfiles/files.gph](https://codevoid.de/?q=/1/git/dotfiles/files.gph)

7) Attention: Do not commit passwords!!! This sounds logical but is sometimes not so simple. Many programs / config folder can possibly contain cached passwords (vim) and you should also consider to create sample files like ```.configfile.sample``` containing only "******************" instead the real password. But that's only one example.

8) learn to commit with: ```--rebase, stash```

9) sometimes you change something on a not up-to-date branch. Because of that he advises in general:

```bash
config pull --rebase # instad with config pull
```

10) if there are some uncommitted changes in your git repo, you could do the following:

```bash
config stash
config pull --rebase
config stash apply
```

*Guide by codeviod on uugrn(at)mailman.uugrn.org, translated into english by me (tinfoil-hat)*``

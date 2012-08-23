This is a collection of various init scripts, config files, and utility
scripts that I use on multiple *nix systems.  I store them on github to
make it easy to distribute new versions to multiple systems.

To install this collection into your account on a computer:

    * clone this repo into a directory called "dotfiles" in your home directory on that computer
    * cd ~/dotfiles
    * perl install

This will create symlinks in your home directory pointing to all the
files in the dotfiles directory.  If you already have files in your
home directory with the same name as any of the files here, the
"install" script will create a subdirectory called "backups" of the
"dotfiles" directory, and will save your original files in it.

To update an existing dotfiles installation with the latest changes
from the github repo:

    * cd ~/dotfiles
    * git pull
    * ./install

#! /bin/zsh

# remove today directory if it exists
rm -rf ~/Desktop/today 
# create today and done subdirectory
mkdir -p ~/Desktop/today/done

# run kindle.scpt script
open ~/bin/kindle.scpt; exit

#!/bin/bash
if [ -x /Applications/ALPIndex.app/Contents/MacOS/ALPIndex ];then
  echo "ALPIndex is already installed."
  bash <(https://raw.githubusercontent.com/jacobsalmela/re-index-garageband-loops/master/re-index-garageband-loops.sh)
  exit 1
else
	curl -0 ~/Downloads/ALPIndex.zip https://dl.dropboxusercontent.com/u/16366947/Apps/ALPIndex.zip
	unzip ~/Downloads/ALPIndex.zip
	rm ~/Downloads/ALPIndex.zip
	mv ALPIndex.app /Applications
	chflags hidden /Applications/ALPIndex.app
	bash <(https://raw.githubusercontent.com/jacobsalmela/re-index-garageband-loops/master/re-index-garageband-loops.sh)
fi


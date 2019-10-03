## How to generate signal samples, gridpacks, and all that jazz.

The safest way for this code to work is to `git clone https://github.com/rosedj1/genproductions.git`, because there may lots of dependent files. 

However, if you don't want all the unncessary stuff, you may be able to do:
```bash
git init MadGraph5_aMCatNLO
cd MadGraph5_aMCatNLO
git remote add -f origin https://github.com/rosedj1/genproductions.git
git config core.sparseCheckout true
echo "MadGraph5_aMCatNLO" >> .git/info/sparse-checkout
git pull origin master
``` 

The main script is *createAndSubmitGridpacks.sh*.

There are various "switches" inside the script that you need to turn on (`1`) and off (`0`). For example,

```bash
makeCards=1
makeWorkspace=0
```

In this case, new MadGraph5 cards **will be generated**, but **not** a new workspace. 

### Now you need to prepare a couple of directories:

You need:
* createAndSubmitGridpacks.sh
* MadGraph_cards_template
  * 

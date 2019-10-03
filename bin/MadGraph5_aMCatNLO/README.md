## How to generate gridpacks

The main script is *createAndSubmitGridpacks.sh*.

There are various "switches" inside the script that you need to turn on (`1`) and off (`0`). For example,

```bash
makeCards=1
makeWorkspace=0
```

In this case, new MadGraph5 cards **will be generated**, but **not** a new workspace. 

### Make sure you have the following directories in the correct spots:
You need:

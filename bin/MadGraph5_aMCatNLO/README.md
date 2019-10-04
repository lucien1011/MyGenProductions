## How to generate signal samples, gridpacks, submit CRAB jobs, and all that jazz.
<!--- The safest way for this code to work is to `git clone https://github.com/rosedj1/genproductions.git`, because there are lots of dependent files. However, you may just be able to do:--->
```bash
git init MadGraph5_aMCatNLO
cd MadGraph5_aMCatNLO
git remote add -f origin https://github.com/rosedj1/genproductions.git
git config core.sparseCheckout true
echo "bin/MadGraph5_aMCatNLO/" >> .git/info/sparse-checkout
git pull origin master
``` 

The main script is *createAndSubmitGridpacks.sh*. There are various **switches** inside the script that you need to turn on (`1`) and off (`0`). For example,

```bash
makeCards=1
makeWorkspace=0
```
In this case, new **MadGraph5 cards will be generated**, but a new workspace will **not**. 

Possible switches:
```bash
makeCards=1         # New MadGraph cards.                                                     
makeWorkspace=1     # Run this to apply new User-specific Parameters below or make new CRAB cards
makeTarball=1       # MUST HAVE clean CMSSW environment, i.e. must not have cmsenv'ed!           
makeLHEfile=1       # Unpacks tarball and does: ./runcmsgrid.sh   
overWrite=0         # 1 = overwrite any files and directories without prompting
```

## Now you need to prepare a couple of directories:
<!-- * createAndSubmitGridpacks.sh -->
* `MadGraph_cards_template/`
   * Make 
* workDir_template/

### The most important parameters in *createAndSubmitGridpacks.sh*:
* `modelName="ALP"`                       # MG5 model name: "HAHM_variablesw_v3", "ALP", etc.
* `analysis="acc_study_hTOzzTO4mu"`       # Used for auto naming directories and files.
   * 
* `process='p p > h > z z , z > mu+ mu-'` # Will be put directly into the MG cards.
* `zdmasslist="5 10 15"`                  # The mass points (GeV) to be run over. 
<!-- * `modelName="HAHM_variablesw_v3"`, the exact model name must match the tarball name like: `HAHM_variablesw_v3_UFO.tar.gz`
* `process='p p > h > z z , z > mu+ mu-`, the exact MadGraph5 process (MG5) to be inserted into your MG5 card.
-->

* MG_Dir="FullPath/to/this/dir"   # No trailing '/'! , Path to gridpack_generation.sh and MG_cards_template
   * This path must also contain `gridpack_generation.sh` and `MG_cards_template/`
* `MG_cards_template_dir="MG_cards_ALP_template"`   # No trailing '/'!                                   

All other parameters are mostly for naming purposes:
* `epsilon`
* `kappa`
* `lhapdf`
* `numjets`
* etc.

## Use ZZD_lhe.C to skim the newly-produced LHE files:
Point ZZD_lhe.C ...
TO BE CONTINUED

## Use LHE_Analyzer to plot stuff.
TO BE CONTINUED

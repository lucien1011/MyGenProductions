## How to generate signal samples, gridpacks, submit CRAB jobs, and all that jazz.
<!--- The safest way for this code to work is to `git clone https://github.com/rosedj1/genproductions.git`, because there are lots of dependent files. However, you may just be able to do:--->

Pull down the code:
```bash
git init Generate_Samples
cd Generate_Samples
git remote add -f origin https://github.com/rosedj1/genproductions.git
git config core.sparseCheckout true
echo "bin/MadGraph5_aMCatNLO/" >> .git/info/sparse-checkout
git pull origin master
``` 

Now check in the following directories and make sure that each file is suited for your work:
<!--Now you need to prepare a couple of directories:
* createAndSubmitGridpacks.sh -->
* `MadGraph_cards_<MODEL>_template/`, where <MODEL> matches the model you are using (like "ALP").
* `workDir_template/`
    * Any capitalized words will be substituted out by _createAndSubmitGridpacks.sh_.

The main script is *createAndSubmitGridpacks.sh*. There are various **switches** inside the script that you need to turn on (`1`) and off (`0`). Possible switches:
```bash
makeCards=1         # New MadGraph cards.                                                     
makeWorkspace=1     # Run this to apply new User-specific Parameters below or make new CRAB cards
makeTarball=0       # MUST HAVE clean CMSSW environment, i.e. must not have cmsenv'ed!           
makeLHEfile=0       # Unpacks tarball and does: ./runcmsgrid.sh   
overWrite=0         # 1 = overwrite any files and directories without prompting
```

### The most important parameters in *createAndSubmitGridpacks.sh*
NOTE: Wherever you see <MODEL>, replace it with the exact model name of your tarball: `<MODEL>.tar.gz`
* For example, my <MODEL> is `HAHM_variablesw_v3` which comes from `HAHM_variablesw_v3_UFO.tar.gz`.
* You can find the list of CMS tarballs here: https://cms-project-generators.web.cern.ch/cms-project-generators/

#### Process Parameters:
* `modelName="ALP"`                       # MG5 model name: "HAHM_variablesw_v3", "ALP", etc.
* `analysis="acc_study_hTOzzTO4mu"`       # Used for auto naming directories and files.
* `process='p p > h > z z , z > mu+ mu-'` # Will be put directly into the MG cards.
* `zdmasslist="5 10 15"`                  # The mass points (GeV) to be run over. 

#### Navigation Parameters:
* `MG_Dir="FullPath/to/this/dir"`   # No trailing `/`!
   * This path must also lead to `gridpack_generation.sh` and `MG_cards_template/`
* `MG_cards_template_dir="MG_cards_<MODEL>_template"`   # No trailing `/`! Replace <MODEL> with your model name.
* `workDirBASE="FullPath/to/workDir_template"` # No trailing `/`!
* `freshCMSSWpath="/home/rosedj1/CMSSW_9_4_2/src/"` # Tarball creation complains unless you are in a clean CMSSW environment.
<!-- * 
* `process='p p > h > z z , z > mu+ mu-`, the exact MadGraph5 process (MG5) to be inserted into your MG5 card.
-->

#### All other parameters are mostly for naming purposes:
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

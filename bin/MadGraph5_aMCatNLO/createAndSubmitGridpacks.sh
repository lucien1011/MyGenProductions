#!/bin/bash
######################################################################################
## PURPOSE: For each Zd mass point for the H-->Z(d)Z(d)-->4l, quickly and easily:
##              - make MadGraph cards for any HZZ4lep process
##              - prepare a workdir (crab_cfg.py, stepX files)
##              - generate a new gridpack (tarball)
##              - submit any CRAB process (e.g., GEN-SIM, PUMix, AOD, MiniAOD)
## SYNTAX:  ./<scriptname.sh>
## NOTES:   User needs to do: 
##          - 'source /cvmfs/cms.cern.ch/crab3/crab.sh' before running this script.
## AUTHOR:  Jake Rosenzweig
## DATE:    2019-02-09
## UPDATED: 2019-03-18
######################################################################################

#_____________________________________________________________________________________
# User chooses which processes to run: 1 = run, 0 = don't run
makeCards=0         # New MadGraph cards
makeWorkspace=0     # run this each time you change parameters below
makeTarball=0       # MUST HAVE clean CMSSW environment, i.e. mustn't have cmsenv'ed!
submitGENSIM=1      # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitPUMix=0       # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitAOD=0         # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitMiniAOD=0     # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 

overWrite=1 # 1 = overwrite any files and directories without prompting
#zdmasslist="4 5 6 7 8 9 10 15 20 25 30 35 40 45 50 55 60"
zdmasslist="4 15 30"
#_____________________________________________________________________________________
# User-specific Parameters
# If you change parameters here, you have to rerun makeWorkspace=1 for them to take effect
epsilon="1e-2"    ## epsilon can't yet contain  a decimal, e.g. 1.5e-2
kappa="1e-9"
numjets=0
tarballName="HAHM_variablesw_v3_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz"
nevents=1000
njobs=100
#lhapdf=306000       # official pdf for 2017, NNPDF31_nnlo_hessian_pdfas
lhapdf=10042        # cteq61l
analysis="ppToZZd"  # used only for naming directories and files
process='p p > Z Zp , Z > l+ l- , Zp > l+ l-' # will be put into the MG cards

MG_Dir="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration/genproductions/bin/MadGraph5_aMCatNLO"   # No trailing '/'! , Path to mkgridpack.sh and MG_cards_template 
workDirBASE="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration" # No trailing '/'! , Path to all work dirs
freshCMSSWpath="/home/rosedj1/CleanCMSSWenvironments/CMSSW_9_4_2/src/"
storageSiteGEN='/store/user/drosenzw/HToZZd/ppToZZd_GEN-SIM/'
storageSitePUMix='/store/user/drosenzw/HToZZd/ppToZZd_PUMix/'
storageSiteAOD='/store/user/drosenzw/HToZZd/ppToZZd_AODSIM/'
storageSiteMiniAOD='/store/user/drosenzw/HToZZd/ppToZZd_MINIAODSIM/'

#_____________________________________________________________________________________
# Automatic variables
startDir=`pwd`
maxjobs=$(( 5 * $njobs ))               # so that CRAB doesn't kill the jobs early

#_____________________________________________________________________________________
# Create new MadGraph cards 
if [ ${makeCards} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        cd ${MG_Dir}
        cardsDir=${analysis}_cards_eps${epsilon}_MZD${zdmass}

        ## Ugly regex so that epsilon has correct format for HAHM_variablesw_v3_customizecards.dat
        temp_eps=$( echo $epsilon | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )
        temp_kappa=$( echo $kappa | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )

        echo "Making MadGraph5 cards for mZd${zdmass} GeV in ${MG_Dir}/${cardsDir}"

        function createNewCards { 
            cp -rT MG_cards_template/ ${cardsDir}
            cd ${cardsDir}
            sed -i "s|ZDMASS|${zdmass}|g"       HAHM_variablesw_v3_customizecards.dat
            sed -i "s|EPSILON|${temp_eps}|g"    HAHM_variablesw_v3_customizecards.dat
            sed -i "s|KAPPA|${temp_kappa}|g"    HAHM_variablesw_v3_customizecards.dat
            sed -i "s|PROCESS|${process}|g"     HAHM_variablesw_v3_proc_card.dat
            sed -i "s|LHAPDF|${lhapdf}|g"       HAHM_variablesw_v3_run_card.dat
            cd ..
        }

        if [ -d ${cardsDir} ] && [ ${overWrite} = 0 ]; then
            echo "Directory ${cardsDir} already exists. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                createNewCards
            else
                echo "Not creating new cards for mZd${zdmass}."
                continue
            fi
        else 
            createNewCards
        fi

    done
    cd ${startDir}
fi

#_____________________________________________________________________________________
# Create new workspace for each mass point - prepares crab_cfg, and stepX files.
if [ ${makeWorkspace} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        cd ${workDirBASE}
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}

        echo "Making workspace: ${workDirBASE}/${workDir}"

        function createNewWorkspace {
            cp -rT workDir_template/ ${workDir}
            cd ${workDir}
            ## Replace values with correct Zd mass, file paths, etc. in each file.
            for file in \
                crab_GEN-SIM.py \
                crab_PUMix.py \
                crab_AODSIM.py \
                crab_MINIAODSIM.py \
                step1_GEN-SIM_cfg.py \
                step2_PUMix_cfg.py \
                step3_AODSIM_cfg.py \
                step4_MINIAODSIM_cfg.py \
                lhe_gen-sim_steps.sh \
                externalLHEProducer_and_PYTHIA8_Hadronizer_cff.py; do
                sed -i "s|ANALYSIS|${analysis}|g"                       ${file}
                sed -i "s|ZDMASS|${zdmass}|g"                           ${file}
                sed -i "s|NUMJETS|${numjets}|g"                         ${file}
                sed -i "s|EPSILON|${epsilon}|g"                         ${file}
                sed -i "s|NUMEVENTS|${nevents}|g"                       ${file}
                sed -i "s|NUMJOBS|${njobs}|g"                           ${file}
                sed -i "s|MAXJOBS|${maxjobs}|g"                         ${file}
                sed -i "s|TARBALLNAME|${tarballName}|g"                 ${file}
                sed -i "s|STORAGESITEGEN|${storageSiteGEN}|g"           ${file}
                sed -i "s|STORAGESITEPUMIX|${storageSitePUMix}|g"       ${file}
                sed -i "s|STORAGESITEAOD|${storageSiteAOD}|g"           ${file}
                sed -i "s|STORAGESITEMINIAOD|${storageSiteMiniAOD}|g"   ${file}
            done
        }

        ## Check to see if dir already exists
        if [ -d ${workDir} ] && [ ${overWrite} = 0 ]; then
            echo "Directory ${workDirBASE}/${workDir} already exists. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                createNewWorkspace
            else
                echo "Not creating ${workDir} workspace."
                continue
            fi

        else 
            ## Dir doesn't exist or user overwrites all. Create workDir.
            createNewWorkspace
        fi

    done
    cd ${startDir}
fi

#_____________________________________________________________________________________
# Generate new tarball (gridpack) for each mass point
if [ ${makeTarball} = 1 ]; then
    #echo "Running scram b clean... cleaning"
    #scram b clean
    for zdmass in ${zdmasslist}; do

        cd ${MG_Dir}
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cardsDir=${analysis}_cards_eps${epsilon}_MZD${zdmass}

        echo "Generating gridpack ${tarballName} for mZd${zdmass} GeV for process ${analysis}" 

        function createNewTarball {

            if [ -d HAHM_variablesw_v3/ ];              then rm -rf HAHM_variablesw_v3/; fi
            if [ -d ${cardsDir}/HAHM_variablesw_v3/ ];  then rm -rf ${cardsDir}/HAHM_variablesw_v3/; fi

            cp mkgridpack.sh DELETE_mkgridpack.sh
            cp gridpack_generation.sh DELETE_gridpack_generation.sh
            sed -i "s|gridpack|DELETE_gridpack|g"        DELETE_mkgridpack.sh
            sed -i "s|MODELPATH|${MG_Dir}/${cardsDir}|g" DELETE_gridpack_generation.sh
            ./DELETE_mkgridpack.sh HAHM_variablesw_v3 ${cardsDir}/
            rm DELETE_mkgridpack.sh DELETE_gridpack_generation.sh

            echo "Moving log files with MadGraph cards into: ${MG_Dir}/${cardsDir}"
            mv HAHM_variablesw_v3/ HAHM_variablesw_v3.log ${cardsDir}/
            ## Move tarball into workspace
            echo "Moving gridpack ${tarballName} into workspace: ${workDirBASE}/${workDir}"
            mv ${tarballName} ${workDirBASE}/${workDir}
            echo
        }

        ## Check to see if tarball already exists in workspace 
        if [ -e ${MG_Dir}/${tarballName} ] && [ ${overWrite} = 0 ]; then
            echo "The gridpack ${tarballName} already exists in ${workDir}. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                createNewTarball
            else
                echo "Not creating new tarball for mZd${zdmass}."
                continue
            fi

        ## Tarball doesn't exist or user overwrites all. Create tarball
        else
            createNewTarball
        fi

    done
    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit GEN-SIM CRAB job
if [ ${submitGENSIM} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_LHE-GEN-SIM_*
        echo "Submitting mZd${zdmass} GeV for CRAB GEN-SIM processing."
        crab submit -c crab_GEN-SIM.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit PUMix CRAB job
if [ ${submitPUMix} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_PUMix_*
        # Find the dataset path from the CRAB GEN-SIM log file 
        echo "Finding dataset path to CRAB GEN-SIM files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_LHE-GEN-SIM_*/crab*/ | grep -E */ZD.*LHE-GEN-SIM_RAWSIM* | cut -f 4 )

        for file in crab_PUMix.py step2_PUMix_cfg.py; do
            sed -i "s|GENSIMDATASET|${datasetDir}|g" ${file}
        done

        echo "Submitting mZd${zdmass} GeV for CRAB PUMix processing."
        crab submit -c crab_PUMix.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit AODSIM CRAB job
if [ ${submitAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_AODSIM_*
        # Find the dataset path from the CRAB PUMix log file 
        echo "Finding dataset path to CRAB PUMix files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_PUMix_*/crab*/ | grep -E */ZD.*PUMix* | cut -f 4 )
        sed -i "s|PUMIXDATASET|${datasetDir}|g" crab_AODSIM.py

        echo "Submitting mZd${zdmass} GeV for CRAB AODSIM processing."
        crab submit -c crab_AODSIM.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit MiniAODSIM CRAB job
if [ ${submitMiniAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_MINIAODSIM_* 
        # Find the dataset path from the CRAB AODSIM log file 
        echo "Finding dataset path to CRAB AODSIM files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_AODSIM*/crab*/ | grep -E */ZD.*AOD* | cut -f 4 )
        sed -i "s|AODDATASET|${datasetDir}|g" crab_MINIAODSIM.py

        echo "Submitting mZd${zdmass} GeV for CRAB MiniAODSIM processing."
        crab submit -c crab_MINIAODSIM.py
    done

    cd ${startDir}
fi

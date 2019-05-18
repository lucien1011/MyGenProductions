#!/bin/bash
#####################################################################################################
## PURPOSE: For each Zd mass point for the H-->Z(d)Z(d)-->4l, quickly and easily:
##              - make MadGraph cards for any HZZ4lep process
##              - prepare a workdir (crab_cfg.py, stepX files)
##              - generate a new gridpack (tarball)
##              - submit any CRAB process (e.g., GEN-SIM, PUMix, AOD, MiniAOD)
## SYNTAX:  ./<scriptname.sh>
## NOTES:   User needs to do: 
##          - 'source /cvmfs/cms.cern.ch/crab3/crab.sh' before running this script.
##          - Review MG_cards_template dir and make sure run_card.dat and proc_card.dat are correct.
##          - REVIEW EACH LINE IN 'Parameters' SECTION VERY CAREFULLY!
## AUTHOR:  Jake Rosenzweig
## DATE:    2019-02-09
## UPDATED: 2019-05-17
#####################################################################################################

#_____________________________________________________________________________________
# User chooses which processes to run: 1 = run, 0 = don't run
makeCards=1         # New MadGraph cards
makeWorkspace=1     # run this to apply new User-specific Parameters below or make new CRAB cards
makeTarball=1       # MUST HAVE clean CMSSW environment, i.e. mustn't have cmsenv'ed!
submitGENSIM=0      # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitPUMix=0       # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitAOD=0         # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitMiniAOD=0     # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 

# @@@@@ STILL UNDER CONSTRUCTION @@@@@ Unpack tarball and do: ./runcmsgrid.sh
makeLHEfile=0       
# @@@@@ STILL UNDER CONSTRUCTION @@@@@

overWrite=1 # 1 = overwrite any files and directories without prompting
zdmasslist="20"
#_____________________________________________________________________________________
# User-specific Parameters
# If you change parameters here, you have to rerun makeWorkspace=1 for them to take effect
epsilon="5e-2"    ## epsilon can't yet contain a decimal, e.g. 1.5e-2
kappa="1e-9"
numjets=0
tarballName="HAHM_variablesw_v3_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz"
nevents=1000
njobs=10
lhapdf=306000       # 10042=cteq61l, 306000=NNPDF31_nnlo_hessian_pdfas (official pdf for 2017)
analysis="ppTOzzp_possibleHiggs"  # used for naming directories and files
#analysis="ppTOzzp_nohh2"  # used for naming directories and files
process='p p > z zp , z > l+ l- , zp > l+ l-' # will be put into the MG cards
MG_Dir="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration/genproductions/bin/MadGraph5_aMCatNLO"   # No trailing '/'! , Path to mkgridpack.sh and MG_cards_template 

# Outputs:
workDirBASE="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration" # No trailing '/'! , Path to all work dirs and workDir_template
freshCMSSWpath="/home/rosedj1/CleanCMSSWenvironments/CMSSW_9_4_2/src/"
storageSiteGEN="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_GEN-SIM/"
storageSitePUMix="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_PUMix/"
storageSiteAOD="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_AODSIM/"
storageSiteMiniAOD="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_MINIAODSIM/"

#_____________________________________________________________________________________
# Automatic variables
startDir=`pwd`
maxjobs=$(( 5 * $njobs ))               # so that CRAB doesn't kill the jobs early
maxevents=$(( $nevents * $njobs ))
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
            cp -rT MG_cards_template/ ${cardsDir} # Will only overwrite files that share same name in source dir!
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
        echo "Making workspace: ${workDirBASE}/${workDir}/"

        function createNewWorkspace {
            if [ -d workDir_template/ ]; then
                cp -rT workDir_template/ ${workDir}
            else
                echo "Directory workDir_template doesn't exist. Not creating workspace ${workDirBASE}/${workDir}."
                return
            fi
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
            cd ..
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

        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cardsDir=${analysis}_cards_eps${epsilon}_MZD${zdmass}
        echo "Generating gridpack ${tarballName} for mZd${zdmass} GeV for process ${analysis}" 

        function createNewTarball {
            
            cd ${MG_Dir}

            #- Remove old files
            if [ -d HAHM_variablesw_v3/ ];     then rm -rf HAHM_variablesw_v3/; fi
            if [ -e HAHM_variablesw_v3.log ];  then rm     HAHM_variablesw_v3.log; fi
            if [ -e ${tarballName} ];          then rm     ${tarballName}; fi
            if [ -d ${workDirBASE}/${workDir}/HAHM_variablesw_v3/ ];    then rm -rf ${workDirBASE}/${workDir}/HAHM_variablesw_v3/; fi
            if [ -e ${workDirBASE}/${workDir}/HAHM_variablesw_v3.log ]; then rm     ${workDirBASE}/${workDir}/HAHM_variablesw_v3.log; fi
            if [ -e ${workDirBASE}/${workDir}/${tarballName} ];         then rm     ${workDirBASE}/${workDir}/${tarballName}; fi

            cp mkgridpack.sh DELETE_mkgridpack.sh
            cp gridpack_generation.sh DELETE_gridpack_generation.sh
            sed -i "s|gridpack|DELETE_gridpack|g"        DELETE_mkgridpack.sh
            sed -i "s|MODELPATH|${MG_Dir}/${cardsDir}|g" DELETE_gridpack_generation.sh
            ./DELETE_mkgridpack.sh HAHM_variablesw_v3 ${cardsDir}/
            rm DELETE_mkgridpack.sh DELETE_gridpack_generation.sh

            echo "Moving tarball and log files into: ${workDirBASE}/${workDir}/"
            mv HAHM_variablesw_v3/ HAHM_variablesw_v3.log ${tarballName} ${workDirBASE}/${workDir}
            echo
        }

        ## Check to see if tarball already exists in workspace 
        if [ -e ${workDirBASE}/${workDir}/${tarballName} ] && [ ${overWrite} = 0 ]; then
            echo "The gridpack ${tarballName} already exists in ${workDirBASE}/${workDir}. Overwrite it? [y/n] "
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
# Unpack tarball and make LHE file
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@ WARNING @@@@@@@@@@@@@@@@@@@@@@@
#@@@@@ This code is still under construction!!! @@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ ${makeLHEfile} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        unpackedTarDir="UnpackedTarball"
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        #cardsDir=${analysis}_cards_eps${epsilon}_MZD${zdmass}

        if [ ! -e ${workDirBASE}/${workDir}/${}]
        echo "Unpacking tarball in ${workDir} Generating gridpack ${tarballName} for mZd${zdmass} GeV for process ${analysis}" 
        cd ${workdir}
        
        # See if tarball is already unpacked
        if [ -d ${} ]; then
            echo "WARNING! Tarball has already been unpacked in ${}"
        else
            mkdir ${unpackedTarDir}
            cd ${unpackedTarDir}
            mv ../${tarballName} .
            tar -xf ${tarballName}
            # Move tarball back to where it was
            mv ${tarballName} ..

        ### Create LHE file
        # Get a random 4 digit number for seed
        randnum=$(( 1000 + RANDOM % 9000 ))
        ./runcmsgrid.sh ${maxevents} ${randnum}

#### The code below is used only as a template! Delete it when ready.
        cd ${startDir} 

        function createNewTarball {
            
            cd ${MG_Dir}

            #- Remove old files
            if [ -d HAHM_variablesw_v3/ ];     then rm -rf HAHM_variablesw_v3/; fi
            if [ -e HAHM_variablesw_v3.log ];  then rm     HAHM_variablesw_v3.log; fi
            if [ -e ${tarballName} ];          then rm     ${tarballName}; fi
            if [ -d ${workDirBASE}/${workDir}/HAHM_variablesw_v3/ ];    then rm -rf ${workDirBASE}/${workDir}/HAHM_variablesw_v3/; fi
            if [ -e ${workDirBASE}/${workDir}/HAHM_variablesw_v3.log ]; then rm     ${workDirBASE}/${workDir}/HAHM_variablesw_v3.log; fi
            if [ -e ${workDirBASE}/${workDir}/${tarballName} ];         then rm     ${workDirBASE}/${workDir}/${tarballName}; fi

            cp mkgridpack.sh DELETE_mkgridpack.sh
            cp gridpack_generation.sh DELETE_gridpack_generation.sh
            sed -i "s|gridpack|DELETE_gridpack|g"        DELETE_mkgridpack.sh
            sed -i "s|MODELPATH|${MG_Dir}/${cardsDir}|g" DELETE_gridpack_generation.sh
            ./DELETE_mkgridpack.sh HAHM_variablesw_v3 ${cardsDir}/
            rm DELETE_mkgridpack.sh DELETE_gridpack_generation.sh

            echo "Moving tarball and log files into: ${workDirBASE}/${workDir}/"
            mv HAHM_variablesw_v3/ HAHM_variablesw_v3.log ${tarballName} ${workDirBASE}/${workDir}
            echo
        }

        ## Check to see if tarball already exists in workspace 
        if [ -e ${workDirBASE}/${workDir}/${tarballName} ] && [ ${overWrite} = 0 ]; then
            echo "The gridpack ${tarballName} already exists in ${workDirBASE}/${workDir}. Overwrite it? [y/n] "
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
        echo
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit PUMix CRAB job
if [ ${submitPUMix} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_PUMix_*
        # Find the dataset path from the CRAB GEN-SIM log file 
        echo "Finding dataset path to CRAB GEN-SIM files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_LHE-GEN-SIM_*/crab*/ | grep -E "\b/.*GEN-SIM_RAWSIMoutput.*USER$" | cut -f 4 )

        if [[ "$datasetDir" == '' ]]; then 
            echo "WARNING!!! Unable to retrieve GEN-SIM dataset DirPath for mZd${zdmass} GeV for PUMix crab_cfg.py file."
            echo "NOT submitting mZd${zdmass} GeV for GEN-SIM processing."
            echo
        else
            for file in crab_PUMix.py step2_PUMix_cfg.py; do
                sed -i "s|GENSIMDATASET|${datasetDir}|g" ${file}
            done

            echo "Submitting mZd${zdmass} GeV for CRAB PUMix processing."
            crab submit -c crab_PUMix.py
            echo
        fi

    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit AODSIM CRAB job
if [ ${submitAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_AODSIM_*
        # Find the dataset path from the CRAB PUMix log file 
        echo "Finding dataset path to CRAB PUMix files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_PUMix_*/crab*/ | grep -E "\b/.*PUMix.*USER$" | cut -f 4 )

        if [[ "$datasetDir" == '' ]]; then 
            echo "WARNING!!! Unable to retrieve PUMix dataset DirPath for mZd${zdmass} GeV for AODSIM crab_cfg.py file."
            echo "NOT submitting mZd${zdmass} GeV for AODSIM processing."
            echo
        else
            sed -i "s|PUMIXDATASET|${datasetDir}|g" crab_AODSIM.py

            echo "Submitting mZd${zdmass} GeV for CRAB AODSIM processing."
            crab submit -c crab_AODSIM.py
            echo
        fi
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit MiniAODSIM CRAB job
if [ ${submitMiniAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_${analysis}_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*${analysis}*_MINIAODSIM_* 
        # Find the dataset path from the CRAB AODSIM log file 
        echo "Finding dataset path to CRAB AODSIM files for mZd${zdmass} GeV..."
        datasetDir=$( crab status -d crab_*MZD${zdmass}*_AODSIM*/crab*/ | grep -E "\b/.*AODSIM.*USER$" | cut -f 4 )

        if [[ "$datasetDir" == '' ]]; then 
            echo "WARNING!!! Unable to retrieve AODSIM dataset DirPath for mZd${zdmass} GeV for MINIAODSIM crab_cfg.py file."
            echo "NOT submitting mZd${zdmass} GeV for MINIAODSIM processing."
            echo
        else
            sed -i "s|AODDATASET|${datasetDir}|g" crab_MINIAODSIM.py

            echo "Submitting mZd${zdmass} GeV for CRAB MiniAODSIM processing."
            crab submit -c crab_MINIAODSIM.py
            echo
        fi
    done

    cd ${startDir}
fi

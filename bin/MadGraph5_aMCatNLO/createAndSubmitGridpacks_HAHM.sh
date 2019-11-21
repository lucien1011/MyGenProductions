#!/bin/bash
#####################################################################################################
## PURPOSE: For each ????? quickly and easily:
##              - make MadGraph cards for any HZZ4lep process
##              - prepare a workdir (crab_cfg.py, stepX files)
##              - generate a new gridpack (tarball)
##              - submit any CRAB process (e.g., GEN-SIM, PUMix, AOD, MiniAOD)
## SYNTAX:  ./<script.sh>  
## NOTES:   User needs to do: 
##          - 'source /cvmfs/cms.cern.ch/crab3/crab.sh' before running this script.
##          - Check all cards in MG_cards_template/
##          - REVIEW EACH LINE IN 'User-specific Parameters' SECTION VERY CAREFULLY!
##          - FIXME!!! Submitted CRAB jobs don't have their Dataset stored, for some reason.
##            This means that the user must manually tell CRAB which files to grab!!!
## AUTHOR:  Jake Rosenzweig
## DATE:    2019-02-09
## UPDATED: 2019-07-17
#####################################################################################################

#_____________________________________________________________________________________
# User chooses which processes to run: 1 = run, 0 = don't run
makeCards=1         # New MadGraph cards
makeWorkspace=1     # Run this to apply new User-specific Parameters below or make new CRAB cards
makeTarball=1       # MUST HAVE clean CMSSW environment, i.e. must not have cmsenv'ed!
makeLHEfile=1       # Unpacks tarball and does: ./runcmsgrid.sh
submitGENSIM=0      # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitPUMix=0       # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitAOD=0         # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitMiniAOD=0     # first do: source /cvmfs/cms.cern.ch/crab3/crab.sh 

overWrite=1 # 1 = overwrite any files and directories without prompting
zdmasslist="4 7 10 20 25"
#zdmasslist="5 15 30"
#_____________________________________________________________________________________
# User-specific Parameters
# If you change parameters here, you have to rerun makeWorkspace=1 for them to take effect
epsilon="2e-2"      # epsilon can't yet contain a decimal, e.g. 1.5e-2
kappa="1e-9"
numjets=0
modelName="HAHM_variablesw_v3"     # MG5 model name: "HAHM_variablesw_v3", "ALP", etc.
nevents=10000
njobs=1
lhapdf=306000       # 10042=cteq61l, 306000=NNPDF31_nnlo_hessian_pdfas (official pdf for 2017)
analysis="acc_study_hTOzpzpTO4mu"  # used for naming directories and files
process='p p > h > zp zp , zp > mu+ mu-' # will be put into the MG cards
#process='p p > h > alp alp , alp > mu+ mu-' # will be put into the MG cards
MG_Dir="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration/genproductions/bin/MadGraph5_aMCatNLO"   # No trailing '/'! , Path to gridpack_generation.sh and MG_cards_template 
MG_cards_template_dir="MG_cards_HAHM_variablesw_v3_template"   # No trailing '/'!

# Outputs:
workDirBASE="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration" # No trailing '/'! , Path to all work dirs and workDir_template
freshCMSSWpath="/home/rosedj1/CleanCMSSWenvironments/CMSSW_9_4_2/src/"
#/store/[user|group|local]/<dir>[/<subdirs>]/<primary-dataset>/<publication-name>/<time-stamp>/<counter>[/log]/<file-name>
# /store/[user|group|local]/<dir>[/<subdirs>] = config.Data.outLFNDirBase
# <primary-dataset>   = config.Data.outputPrimaryDataset
# <publication-name> = config.Data.outputDatasetTag 
storageSiteGEN="/store/user/klo/ALPgg_GEN-SIM/"
storageSitePUMix="/store/user/klo/ALPgg_PUMix/"
storageSiteAOD="/store/user/klo/ALPgg_AODSIM/"
storageSiteMiniAOD="/store/user/klo/ALPgg_MINIAODSIM/"
#storageSiteGEN="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_GEN-SIM/"
#storageSitePUMix="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_PUMix/"
#storageSiteAOD="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_AODSIM/"
#storageSiteMiniAOD="/store/user/drosenzw/ppZZd/${analysis}/${analysis}_MINIAODSIM/"

#_____________________________________________________________________________________
# Automatic variables
startDir=`pwd`
maxjobs=$(( 5 * $njobs ))               # so that CRAB doesn't kill the jobs early
maxevents=$(( $nevents * $njobs ))
globaltag="93X_mc2017_realistic_v3"     # Perhaps change this for MC in other years.
oldtarballName=${modelName}_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz   # Default
function gettimestamp { date +"%y%m%d_%H%M%S"; }
#_____________________________________________________________________________________
# Create new MadGraph cards 
if [ ${makeCards} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        cd ${MG_Dir}
        cardsDir=${analysis}_cards_eps${epsilon}_MZD${zdmass}

        ## Ugly regex so that epsilon has correct format for HAHM_variablesw_v3_customizecards.dat
        temp_eps=$( echo $epsilon | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )
        temp_kappa=$( echo $kappa | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )

        echo "Making MadGraph5 cards for mZd${zdmass} GeV in ${MG_Dir}/${cardsDir}:"

        function createNewCards { 
            cp -rT ${MG_cards_template_dir}/ ./${cardsDir} # Will only overwrite files that share same name in source dir!
            cd ${cardsDir}
            sed -i "s|ZDMASS|${zdmass}|g"       ${modelName}_customizecards.dat
            sed -i "s|EPSILON|${temp_eps}|g"    ${modelName}_customizecards.dat
            sed -i "s|KAPPA|${temp_kappa}|g"    ${modelName}_customizecards.dat
            sed -i "s|PROCESS|${process}|g"     ${modelName}_proc_card.dat
            sed -i "s|LHAPDF|${lhapdf}|g"       ${modelName}_run_card.dat
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
        newtarballName=${analysis}_mZd${zdmass}_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz
        echo "Making workspace: ${workDirBASE}/${workDir}/"

        function createNewWorkspace {
            if [ -d workDir_template/ ]; then
                cp -rT workDir_template/ ${workDir}
            else
                echo "Directory workDir_template doesn't exist. Not creating workspace ${workDirBASE}/${workDir}."
                return
            fi
            cd ${workDir}
            # Replace values with correct Zd mass, file paths, etc. in each file.
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
                sed -i "s|GLOBALTAG|${globaltag}|g"                     ${file}
                sed -i "s|NUMEVENTS|${nevents}|g"                       ${file}
                sed -i "s|NUMJOBS|${njobs}|g"                           ${file}
                sed -i "s|MAXJOBS|${maxjobs}|g"                         ${file}
                sed -i "s|TARBALLNAME|${newtarballName}|g"              ${file}
                sed -i "s|STORAGESITEGEN|${storageSiteGEN}|g"           ${file}
                sed -i "s|STORAGESITEPUMIX|${storageSitePUMix}|g"       ${file}
                sed -i "s|STORAGESITEAOD|${storageSiteAOD}|g"           ${file}
                sed -i "s|STORAGESITEMINIAOD|${storageSiteMiniAOD}|g"   ${file}
            done
            cd ..
        }

        # Check to see if dir already exists
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
            # Dir doesn't exist or user overwrites all. Create workDir.
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
        newtarballName=${analysis}_mZd${zdmass}_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz
        echo "Generating gridpack ${newtarballName} for mZd${zdmass} GeV for process ${analysis}" 

        function createNewTarball {
            
            cd ${MG_Dir}
            echo "Creating new tarball at: `pwd`"

            #- Remove old files
            if [ -d ${modelName}/ ];       then rm -rf ${modelName}/; fi
            if [ -e ${modelName}_v3.log ]; then rm     ${modelName}_v3.log; fi
            if [ -e ${oldtarballName} ];        then rm     ${oldtarballName}; fi
            if [ -e ${newtarballName} ];        then rm     ${newtarballName}; fi
            if [ -d ${workDirBASE}/${workDir}/${modelName}/ ];    then rm -rf ${workDirBASE}/${workDir}/${modelName}/; fi
            if [ -e ${workDirBASE}/${workDir}/${modelName}.log ]; then rm     ${workDirBASE}/${workDir}/${modelName}.log; fi
            if [ -e ${workDirBASE}/${workDir}/${oldtarballName} ];         then rm     ${workDirBASE}/${workDir}/${oldtarballName}; fi
            if [ -e ${workDirBASE}/${workDir}/${newtarballName} ];         then rm     ${workDirBASE}/${workDir}/${newtarballName}; fi

            timestamp=`gettimestamp`
            tempscript="DELETE_gridpack_generation_${timestamp}.sh"
            #cp mkgridpack.sh DELETE_mkgridpack.sh
            #sed -i "s|gridpack|DELETE_gridpack|g"        DELETE_mkgridpack.sh
            cp gridpack_generation.sh ${tempscript}
            sed -i "s|MODELPATH|${MG_Dir}/${cardsDir}|g" ${tempscript}
            ./${tempscript} ${modelName} ${cardsDir}/
            rm ${tempscript}

            echo "Renaming tarball to: ${newtarballName}"
            ls; pwd #FIXME
            mv ${oldtarballName} ${newtarballName}
            echo "Moving tarball and log files into: ${workDirBASE}/${workDir}/"
            ls; pwd #FIXME
            mv ${modelName}/ ${modelName}.log ${newtarballName} ${workDirBASE}/${workDir}
            echo
        }

        ## Check to see if tarball already exists in workspace 
        if [ -e ${workDirBASE}/${workDir}/${oldtarballName} ] && [ ${overWrite} = 0 ] || \
           [ -e ${workDirBASE}/${workDir}/${newtarballName} ] && [ ${overWrite} = 0 ]; then
            echo "Either gridpack ${oldtarballName} or ${newtarballName} already exists in ${workDirBASE}/${workDir}. Overwrite it? [y/n] "
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

if [ ${makeLHEfile} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        unpackedTarDir="UnpackTarball"
        workDir="workDir_${analysis}_eps${epsilon}_mZd${zdmass}"
        newtarballName=${analysis}_mZd${zdmass}_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz

        function createLHEfile {
            
            cd ${workDirBASE}/${workDir}
            if [ ! -d ${unpackedTarDir} ]; then mkdir ${unpackedTarDir}; fi
            cd ${unpackedTarDir}
            mv ../${newtarballName} .
            echo "Untarring ${newtarballName} in ${workDirBASE}/${workDir}/${unpackedTarDir}"
            tar -xf ${newtarballName}

            # Create LHE file
            # Get a random 4 digit number for seed
            randnum=$(( 1000 + RANDOM % 9000 ))
            time ./runcmsgrid.sh ${maxevents} ${randnum} 1 > "runcmsgrid_${workDir}_output.txt"
            echo "LHE file for mZd${zdmass} GeV mass point made."
            echo
            }

        # Check to see if dir already exists
        if [ -e ${workDirBASE}/${workDir}/${unpackedTarDir}/gridpack_generation.log ] && [ ${overWrite} = 0 ]; then
            echo "Directory ${workDirBASE}/${workDir}/${unpackedTarDir} already exists. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                createLHEfile
            else
                echo "Not creating LHE file for mZd${zdmass} GeV mass point."
                continue
            fi

        else 
            # Dir doesn't exist or user overwrites all. Create LHE file.
            echo "Creating LHE file for mZd${zdmass} GeV mass point."
            createLHEfile
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
            for file in crab_AODSIM.py step3_AODSIM_cfg.py; do
                sed -i "s|PUMIXDATASET|${datasetDir}|g" ${file}
            done

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
            for file in crab_MINIAODSIM.py step4_MINIAODSIM_cfg.py; do
                sed -i "s|AODDATASET|${datasetDir}|g" ${file}
            done

            echo "Submitting mZd${zdmass} GeV for CRAB MiniAODSIM processing."
            crab submit -c crab_MINIAODSIM.py
            echo
        fi
    done

    cd ${startDir}
fi

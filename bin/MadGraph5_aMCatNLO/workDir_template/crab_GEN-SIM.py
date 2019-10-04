# For info on all these parameters, check out:
# https://twiki.cern.ch/twiki/bin/view/CMSPublic/CRAB3ConfigurationFile
import datetime, time, sys
from WMCore.Configuration import Configuration
#____________________________________________________________||
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = 'ZDMASS' 
number_of_jets = 'NUMJETS'
epsilon = 'EPSILON'
custom_string_for_dataset = ''
step = 'LHE-GEN-SIM'
#version = 'v4'
job_label = 'ANALYSIS'+'_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass
outputFileName = 'ANALYSIS'+'_zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root'

#____________________________________________________________||
config = Configuration()

#____________________________________________________________||
config.section_("General")
config.General.requestName     = job_label+"_"+step      # CRAB creates a job name: crab_<requestName>
config.General.workArea        = 'crab_'+config.General.requestName  # CRAB creates a project directory
config.General.transferOutputs = True # transfer output and log files to storage site
config.General.transferLogs    = True

#____________________________________________________________||
config.section_("JobType")
config.JobType.pluginName                       = 'PrivateMC' # MC event generation: 'PrivateMC'; Existing dataset: 'Analysis'
config.JobType.psetName                         = 'step1_GEN-SIM_cfg.py' # parameter-set cfg file that is run by cmsRun; default is pset.py
config.JobType.inputFiles                       = ['externalLHEProducer_and_PYTHIA8_Hadronizer_cff.py','TARBALLNAME'] # inputFiles can't exceed 100 MB. Files placed in working dir where cmsRun is launched
config.JobType.disableAutomaticOutputCollection = True # If True, user must specify where output files will go
#config.JobType.maxMemoryMB                      = 4000
config.JobType.maxJobRuntimeMin                 = 1440 # minutes
config.JobType.numCores                         = 8
config.JobType.scriptExe                        = 'lhe_gen-sim_steps.sh' # User-written script to be run IN PLACE OF cmsRun
config.JobType.outputFiles                      = [outputFileName, outputFileName.replace('.root','_inLHE.root')] # Must exactly match outputFileName in step1_GEN-SIM_cfg.py

#____________________________________________________________||
config.section_("Data")
config.Data.outputPrimaryDataset    = job_label.upper() # Primary Dataset name in the LFN of published dataset name
config.Data.inputDBS                = 'global' # https://cmsweb.cern.ch/dbs/prod/<instance>/DBSReader, where instance = global, phys01, phys02 or phys03
config.Data.splitting               = 'EventBased'
config.Data.unitsPerJob             = NUMEVENTS # the number of events here must match the number of events in the externalLHEProducer
config.Data.totalUnits              = config.Data.unitsPerJob * NUMJOBS # How many events will be generated in total
config.Data.outLFNDirBase           = 'STORAGESITEGEN' # Store area for output files. Default is /store/user/<username>.
config.Data.publication             = True # Publication only happens if the output files are successfully transferred.
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        = 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step # Used in the LFN of output files and publication dataset name

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'

#____________________________________________________________||
# TESTING

# Worst case scenario, you have root files numbered _XXX.root.
# There may be an error caused by having LFNs longer than 255 chars.
# Make sure this isn't the case:
completeLFN = config.Data.outputPrimaryDataset+'/'+config.Data.outputDatasetTag+'/YYMMDD_hhmmss/0000'+'/'+outputFileName.replace('.root','_100.root')
print "Example file name:\n%s" % completeLFN
if len(completeLFN) > 255:
    print """WARNING: LFN of output files will be longer than 255 chars"
    Not submitting CRAB job.
    """ % completeLFN
    sys.exit()

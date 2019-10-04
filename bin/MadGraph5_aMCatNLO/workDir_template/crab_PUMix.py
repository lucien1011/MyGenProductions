# For info on all these parameters, check out the GEN-SIM cfg file or:
# https://twiki.cern.ch/twiki/bin/view/CMSPublic/CRAB3ConfigurationFile
import datetime, time
from WMCore.Configuration import Configuration
#___________________________________________________________________________
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = 'ZDMASS'
number_of_jets = 'NUMJETS'
epsilon = 'EPSILON'
custom_string_for_dataset = ''
step = 'PUMix'
#version = 'v4'
job_label = 'ANALYSIS'+'_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass
outputFileName = 'ANALYSIS'+'_zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root'

#____________________________________________________________||
config = Configuration()

#____________________________________________________________||
config.section_("General")
config.General.requestName     = job_label+"_"+step
config.General.workArea        = 'crab_'+config.General.requestName
config.General.transferOutputs = True
config.General.transferLogs    = True

#____________________________________________________________||
config.section_("JobType")
config.JobType.pluginName                       = 'Analysis'
config.JobType.psetName                         = 'step2_PUMix_cfg.py'
#config.JobType.maxJobRuntimeMin                 = 1440 # minutes
config.JobType.numCores                         = 8
config.JobType.outputFiles                      = [outputFileName]
config.JobType.maxMemoryMB                      = 4000 

#____________________________________________________________||
config.section_("Data")
config.Data.inputDBS                = 'phys03'
config.Data.userInputFiles          = open('/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration/possHiggszzp4l_privatesamples_zd0j_mzd7_LHE-GEN-SIM_rootfiles_20190702.txt').readlines()
#config.Data.inputDataset            = 'GENSIMDATASET'
config.Data.splitting               = 'FileBased'
config.Data.unitsPerJob             = 1 # the number of events here must match the number of events in the externalLHEProducer
NJOBS                               = MAXJOBS
config.Data.totalUnits              = config.Data.unitsPerJob * NJOBS
config.Data.publication             = True
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outLFNDirBase           = 'STORAGESITEPUMIX'
config.Data.outputDatasetTag        = 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step
config.Data.outputPrimaryDataset    = job_label.upper() # Primary Dataset name in the LFN of published dataset name

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'
config.Site.whitelist   = ['T2_US_Florida']

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
step = 'AODSIM'
version = 'v4'
job_label = 'ANALYSIS'+'_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass
outputFileName = 'ANALYSIS'+'_zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root'

#____________________________________________________________||
config = Configuration()

#____________________________________________________________||
config.section_("General")
config.General.requestName     = job_label+"_"+step+"_"+version
config.General.workArea        = 'crab_'+job_label+"_"+step+"_"+version 
config.General.transferOutputs = True
config.General.transferLogs    = True

#____________________________________________________________||
config.section_("JobType")
config.JobType.pluginName                       = 'Analysis'
config.JobType.psetName                         = 'step3_AODSIM_cfg.py'
config.JobType.outputFiles                      = ['ANALYSIS'+'_zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root']
config.JobType.maxMemoryMB                      = 4000 

#____________________________________________________________||
config.section_("Data")
config.Data.inputDBS                = 'phys03'
config.Data.inputDataset            = 'PUMIXDATASET'
config.Data.splitting               = 'FileBased'
config.Data.unitsPerJob             = 1 
NJOBS                               = MAXJOBS # The number of files to be run, need to be larger than the total number of the input dataset to run the whole dataset
config.Data.totalUnits              = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase           = 'STORAGESITEAOD'+version+'/'
config.Data.publication             = True
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        = job_label+'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'

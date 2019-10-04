# Auto generated configuration file
# using: 
# Revision: 1.19 
# Source: /local/reps/CMSSW/CMSSW/Configuration/Applications/python/ConfigBuilder.py,v 
# with command line options: Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_LHE_pythia8_cff.py --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 94X_mc2017_realistic_v10 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW,HLT:2e34v40 --datamix PreMix --era Run2_2017 --python_filename test_RunIIFall17DRPremix_GEN-SIM-RAW_step2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 10 --pileup_input dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-MC_v2_94X_mc2017_realistic_v9-v1/GEN-SIM-DIGI-RAW
import FWCore.ParameterSet.Config as cms

from Configuration.StandardSequences.Eras import eras

process = cms.Process('HLT',eras.Run2_2017)

# import of standard configurations
process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.load('Configuration.EventContent.EventContent_cff')
process.load('SimGeneral.MixingModule.mixNoPU_cfi')
process.load('Configuration.StandardSequences.GeometryRecoDB_cff')
process.load('Configuration.StandardSequences.MagneticField_cff')
process.load('Configuration.StandardSequences.DigiDMPreMix_cff')
process.load('SimGeneral.MixingModule.digi_MixPreMix_cfi')
process.load('Configuration.StandardSequences.DataMixerPreMix_cff')
process.load('Configuration.StandardSequences.SimL1EmulatorDM_cff')
process.load('Configuration.StandardSequences.DigiToRawDM_cff')
process.load('HLTrigger.Configuration.HLT_2e34v40_cff')
process.load('Configuration.StandardSequences.EndOfProcess_cff')
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')

process.maxEvents = cms.untracked.PSet(
    #input = cms.untracked.int32(10)
    input = cms.untracked.int32(-1)
)

# Input source
process.source = cms.Source("PoolSource",
        #fileNames = cms.untracked.vstring('root://cmsio5.rc.ufl.edu//store/user/klo/DarkPhoton_Moriond17_GEN-SIM/v4/ZD_UpTo0j_MZD15_Eps1e-2/PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-LHE-GEN-SIM/180615_090339/0000/zd0j_mzd15_LHE-GEN-SIM_36.root'),
        fileNames = cms.untracked.vstring('GENSIMDATASET'),
        secondaryFileNames = cms.untracked.vstring()
)

process.options = cms.untracked.PSet( numberOfThreads = cms.untracked.uint32(8),
)

# Production Info
process.configurationMetadata = cms.untracked.PSet(
    annotation = cms.untracked.string('Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_LHE_pythia8_cff.py nevts:10'),
    name = cms.untracked.string('Applications'),
    version = cms.untracked.string('$Revision: 1.19 $')
)

# Output definition

process.PREMIXRAWoutput = cms.OutputModule("PoolOutputModule",
    dataset = cms.untracked.PSet(
        dataTier = cms.untracked.string('GEN-SIM-RAW'),
        filterName = cms.untracked.string('')
    ),
    fileName = cms.untracked.string('ANALYSIS_zdNUMJETSj_mzdZDMASS_PUMix.root'),
    outputCommands = process.PREMIXRAWEventContent.outputCommands,
    splitLevel = cms.untracked.int32(0)
)

# Additional output definition

# Other statements
process.mix.digitizers = cms.PSet(process.theDigitizersMixPreMix)
process.mixData.input.fileNames = cms.untracked.vstring([
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20006/F4955DDE-6CCA-E711-AA28-FA163EC43B69.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20016/C4F91294-34CD-E711-B4FA-FA163E89B9A2.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20017/5AE175F6-FACD-E711-81F2-FA163EE8669D.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20020/224ED09F-B7C9-E711-9631-FA163E1D615B.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20022/10848AFB-13CA-E711-8C2D-FA163E00E05C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20027/5A100287-62CA-E711-BEBE-FA163E1AF257.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/46214B7A-E9CD-E711-AA7F-FA163ECDCEFD.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/84D0CFAF-E7CD-E711-B72A-FA163E9AD52A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/AC739231-ECCD-E711-8FE5-02163E0139F7.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/C0A85DD7-F0CD-E711-8FD7-FA163E2F363E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/C0DB4DE8-F8CD-E711-94AC-FA163E75F8CE.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/CC049BB9-EBCD-E711-B459-FA163E492FB1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20038/FC4377D6-F1CD-E711-BE3E-FA163EB99635.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20040/8C9A06F6-D9CD-E711-8C86-FA163E9B4C1A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/2CA86B1B-F2CD-E711-8E8D-02163E00CE12.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/5ACB803F-EFCD-E711-83DB-FA163E83B4BF.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/80FC4B96-EECD-E711-AF8F-FA163E67DEC6.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/86328C22-F0CD-E711-A0FE-FA163EE54262.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/88451143-F9CD-E711-951D-FA163E8A2E19.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/9C8CB724-EECD-E711-8B8B-FA163ED9B1E1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/BE83C30E-EECD-E711-AEDA-FA163EDEBDDB.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/EAD0D460-EECD-E711-8080-FA163E2319BF.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20043/F4A54D22-EECD-E711-AA88-FA163E291653.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/10BB1B6C-FACD-E711-8533-FA163E636F09.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/38A7F8B5-F6CD-E711-A906-02163E0176E1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/5817E994-F6CD-E711-898A-FA163E468596.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/5C895814-F6CD-E711-A09D-FA163E592FDA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/626F825F-F9CD-E711-8C1E-FA163EAEA068.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/682B5C3B-FACD-E711-888B-FA163E1A09F8.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/6A4A31E1-F9CD-E711-A2C8-FA163E20F796.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/764A4269-FACD-E711-B08A-FA163E0C86FE.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/A44A2058-FACD-E711-9544-FA163EC8FD4C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/C85A5968-FACD-E711-B0A4-FA163E69F861.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/C8EAC60A-F6CD-E711-AFCC-FA163E38DE85.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/D256ED7E-F9CD-E711-89E6-FA163E564EBD.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/D61465BD-F4CD-E711-B945-FA163EF69451.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/D6A25C28-F5CD-E711-8768-FA163E9C96F1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/DCC9B6F7-F3CD-E711-A735-FA163EE0AD35.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/EC415F13-F3CD-E711-8D40-FA163EDEBC91.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/FA4BFFBD-F9CD-E711-85FE-FA163E86CFF9.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20044/FA813845-F4CD-E711-9CF0-FA163E15618D.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20045/280927A4-00CE-E711-B233-FA163ED080FD.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20045/30B080B7-02CE-E711-9A05-FA163EFF8B96.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20045/5486B584-01CE-E711-B70D-FA163ECC21BC.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20045/FA908FB8-FCCD-E711-99B4-02163E017611.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20055/3C966BA4-24CE-E711-A107-FA163E8B8207.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/20065/3CA37901-EACC-E711-88DC-FA163E7540C3.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30000/0012E563-A6D3-E711-B543-001E67E6F8CD.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30000/8CFFD53A-DFCC-E711-AD17-0CC47A7AB7A0.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30000/B83EBC4D-A6D3-E711-A424-001E67E6F4A9.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30000/BC2F3F07-ACD3-E711-BCC2-001E67792872.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30000/EED74ED4-9AD3-E711-9CB0-001E67E71E20.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30009/782A9D05-0DC9-E711-8269-FA163E3D07CB.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30021/405B1DFC-D3C9-E711-9A05-FA163E3A44C4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30027/529BE2C5-1ACA-E711-9463-02163E00F75C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30029/808AE658-11CA-E711-AE5F-FA163E88298C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30034/188F079A-8CCD-E711-8C5E-0025905A609E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30036/8A257186-8DCD-E711-B2AF-0025905B858E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30039/F6DC9E06-EDD3-E711-AED7-001E6779254E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/00B98BDC-EED3-E711-94EB-A4BF0112BE12.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/04E48CDA-EDD3-E711-BDA8-A4BF0112BC6A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/1E4A0C8E-EFD3-E711-AFBB-001E6739811A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/449E365D-E1CD-E711-9F9D-02163E00C3B0.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/A0EE0963-DECD-E711-8D5C-02163E01769D.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30040/FEB7FA2B-E4CD-E711-9306-02163E00C4D6.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30041/5441B054-EED3-E711-A430-002590A88806.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30041/96C95837-EED3-E711-B4DB-001E67E6F5EE.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30041/D6FA398B-EDD3-E711-BD9D-001E67E71BC8.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/34ECAEC6-EECD-E711-9A5A-02163E01764A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/64252196-EDD3-E711-BEB5-002590A88800.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/782DFE65-EDD3-E711-AC1B-001E673969FF.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/8EC6E218-EDD3-E711-BEC5-A4BF01125620.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/BC1EFA79-EED3-E711-8893-A4BF011253C0.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/C849424C-EDD3-E711-A63D-001E67E6F922.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30042/E2693628-EDD3-E711-93DF-A4BF0112BDEA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/5879C7D2-FACD-E711-8A2A-FA163EA76FEF.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/8A77F26C-F6CD-E711-A92A-02163E013DF9.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/8A81A5FD-EDD3-E711-BA88-001E6779264E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/9AF16226-F7CD-E711-9897-FA163E63F3DC.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/9AFB0E68-F0CD-E711-8045-FA163EDCFAA7.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/AA60A1BC-F8CD-E711-A410-02163E012D01.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/30043/D0685AF4-34CD-E711-B055-02163E014D4F.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40002/D650A5C6-C3C9-E711-9794-FA163E4E5E29.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40007/981893B2-CCCB-E711-B9E1-02163E0176BA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40016/3E578C89-D0CC-E711-B4B9-FA163E1A7AEA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40016/DE94AD8B-CFCC-E711-B419-002590D9D8AA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40018/267642CC-2ACD-E711-AE27-0CC47A57D164.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40018/3A5BAB8A-28CD-E711-B709-0CC47AA53D6A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40018/72BFE07B-29CD-E711-B33E-0025907E343C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40018/941FD81C-EBCD-E711-8F23-FA163ECD7A90.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40018/BADB67D0-2ACD-E711-8E95-0025907859B4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40019/00DBFECA-08CD-E711-86E7-00259019A43E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40020/D64581FF-65CD-E711-9D8F-0CC47A0AD3BC.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40021/0072356A-4BCD-E711-B649-0025907859C4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40021/8C8AF9C9-4BCD-E711-9510-0CC47A57D164.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40022/409D469E-7CCD-E711-BE3B-00259048A860.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40024/26C5D493-E0CD-E711-AB6C-02163E012F5F.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40032/04230B18-C7CD-E711-BA52-0025902BD8CE.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40034/0A51C0E5-ECCD-E711-B9A1-FA163E2C9C0C.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40034/14383BB5-EDCD-E711-A9B7-FA163EC8ACD4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40035/9AA1E755-CFCD-E711-9814-002590FD5A52.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40036/42678BEB-D7CD-E711-9FF7-FA163EDB62F4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40036/701B4027-E2CD-E711-B127-FA163E9031AA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40036/BA2F2DA2-DACD-E711-8371-FA163EF96DF1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40036/C6388504-E3CD-E711-92D4-FA163EE2B5D1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/10ACCA65-F2CD-E711-B46D-02163E00B4C8.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/2633180E-FBCD-E711-A4AD-FA163E10ADDA.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/2CC8982E-F1CD-E711-B40A-02163E00F6E5.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/54ADEB64-F6CD-E711-A6C6-FA163EECE4B2.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/5C78C4F9-F1CD-E711-9A4D-FA163E587BBB.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/7A779DE0-FBCD-E711-BA67-FA163EAEFBE1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/8010D243-FCCD-E711-AE2B-FA163EB0B5FD.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/A6CB11B5-F1CD-E711-9D70-02163E014B52.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/C225E394-F2CD-E711-A4FD-FA163EA09EAB.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/C2E30947-F2CD-E711-922E-FA163E1C22E2.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/D63C3EDD-FBCD-E711-9165-FA163E9DB474.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40037/FA4A7072-EECD-E711-AE86-FA163E1EECEE.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40038/D051B0DE-FBCD-E711-A3FE-FA163E87F0C1.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40043/7C891206-B4CB-E711-A98F-FA163E2DDEC4.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40044/A4F41B14-B9CB-E711-A371-FA163E6509E5.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40044/B018714E-BDCB-E711-A1CB-FA163E688D1A.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40044/C43C2385-BACB-E711-95C7-FA163EA4CB6E.root',
    '/store/mc/RunIISummer17PrePremix/Neutrino_E-10_gun/GEN-SIM-DIGI-RAW/MC_v2_94X_mc2017_realistic_v9-v1/40045/EA443D84-C8CB-E711-AADD-FA163E874178.root',
    ])
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, 'GLOBALTAG', '')

# Path and EndPath definitions
process.digitisation_step = cms.Path(process.pdigi)
process.datamixing_step = cms.Path(process.pdatamix)
process.L1simulation_step = cms.Path(process.SimL1Emulator)
process.digi2raw_step = cms.Path(process.DigiToRaw)
process.endjob_step = cms.EndPath(process.endOfProcess)
process.PREMIXRAWoutput_step = cms.EndPath(process.PREMIXRAWoutput)

# Schedule definition
process.schedule = cms.Schedule(process.digitisation_step,process.digi2raw_step,process.datamixing_step,process.L1simulation_step)
process.schedule.extend(process.HLTSchedule)
process.schedule.extend([process.endjob_step,process.PREMIXRAWoutput_step])
from PhysicsTools.PatAlgos.tools.helpers import associatePatAlgosToolsTask
associatePatAlgosToolsTask(process)

# customisation of the process.

# Automatic addition of the customisation function from Configuration.DataProcessing.Utils
from Configuration.DataProcessing.Utils import addMonitoring 

#call to customisation function addMonitoring imported from Configuration.DataProcessing.Utils
process = addMonitoring(process)

# Automatic addition of the customisation function from HLTrigger.Configuration.customizeHLTforMC
from HLTrigger.Configuration.customizeHLTforMC import customizeHLTforMC 

#call to customisation function customizeHLTforMC imported from HLTrigger.Configuration.customizeHLTforMC
process = customizeHLTforMC(process)

# End of customisation functions

# Customisation from command line

# Add early deletion of temporary data products to reduce peak memory need
from Configuration.StandardSequences.earlyDeleteSettings_cff import customiseEarlyDelete
process = customiseEarlyDelete(process)
# End adding early deletion

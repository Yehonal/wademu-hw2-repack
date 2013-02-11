# StartTCL: n
# 
# ==========================================
# The Training Lesson ( Bl!zzlike Pet Training System and AI )
# ==========================================
#

namespace eval ::PetScripts { }

namespace eval ::WarlockPets { }

proc ::WarlockPets::ClearFirebolt { player } {            
    ::ClearQFlag $player "Firebolt1"
    ::ClearQFlag $player "Firebolt2"
    ::ClearQFlag $player "Firebolt3"
    ::ClearQFlag $player "Firebolt4"
    ::ClearQFlag $player "Firebolt5"
    ::ClearQFlag $player "Firebolt6"
    return 0          
}

proc ::WarlockPets::ClearBloodPact { player } {            
    ::ClearQFlag $player "BloodPact1"
    ::ClearQFlag $player "BloodPact2"
    ::ClearQFlag $player "BloodPact3"
    ::ClearQFlag $player "BloodPact4"
    return 0          
}

proc ::WarlockPets::ClearFireShield { player } {            
    ::ClearQFlag $player "FireShield1"
    ::ClearQFlag $player "FireShield2"
    ::ClearQFlag $player "FireShield3"
    ::ClearQFlag $player "FireShield4"
    return 0          
}

proc ::WarlockPets::ClearTorment { player } {            
    ::ClearQFlag $player "Torment1"
    ::ClearQFlag $player "Torment2"
    ::ClearQFlag $player "Torment3"
    ::ClearQFlag $player "Torment4"
    ::ClearQFlag $player "Torment5"
    return 0          
}

proc ::WarlockPets::ClearSacrifice { player } {            
    ::ClearQFlag $player "Sacrifice1"
    ::ClearQFlag $player "Sacrifice2"
    ::ClearQFlag $player "Sacrifice3"
    ::ClearQFlag $player "Sacrifice4"
    ::ClearQFlag $player "Sacrifice5"
    return 0          
}

proc ::WarlockPets::ClearConsumeShadows { player } {            
    ::ClearQFlag $player "ConsumeShadows1"
    ::ClearQFlag $player "ConsumeShadows2"
    ::ClearQFlag $player "ConsumeShadows3"
    ::ClearQFlag $player "ConsumeShadows4"
    ::ClearQFlag $player "ConsumeShadows5"
    return 0          
}

proc ::WarlockPets::ClearSuffering { player } {            
    ::ClearQFlag $player "Suffering1"
    ::ClearQFlag $player "Suffering2"
    ::ClearQFlag $player "Suffering3"
    return 0          
}

proc ::WarlockPets::ClearLashOfPain { player } {            
    ::ClearQFlag $player "LashOfPain1"
    ::ClearQFlag $player "LashOfPain2"
    ::ClearQFlag $player "LashOfPain3"
    ::ClearQFlag $player "LashOfPain4"
    ::ClearQFlag $player "LashOfPain5"
    return 0          
}

proc ::WarlockPets::ClearSoothingKiss { player } {            
    ::ClearQFlag $player "SoothingKiss1"
    ::ClearQFlag $player "SoothingKiss2"
    ::ClearQFlag $player "SoothingKiss3"
    return 0          
}

proc ::WarlockPets::ClearDevourMagic { player } {            
    ::ClearQFlag $player "DevourMagic1"
    ::ClearQFlag $player "DevourMagic2"
    ::ClearQFlag $player "DevourMagic3"
    return 0          
}

proc ::WarlockPets::ClearTaintedBlood { player } {            
    ::ClearQFlag $player "TaintedBlood1"
    ::ClearQFlag $player "TaintedBlood2"
    ::ClearQFlag $player "TaintedBlood3"
    return 0          
}

proc ::WarlockPets::ClearSpellLock { player } {            
    ::ClearQFlag $player "SpellLock1"
    return 0          
}


proc ::PetScripts::Init { } {

        ::Custom::AddLegacySpellScript {
        
                  20270 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt2"
                    }
                    
                  20312 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt3"
                    }
                    
                  20313 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt4"
                    }
                    
                  20314 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt5"
                    }
                    
                  20315 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt6"
                    }
                    
                  20316 { WarlockPets::ClearFirebolt $from
                          ::SetQFlag $from "Firebolt7"
                    }    

                  20397 { WarlockPets::ClearBloodPact $from
                          ::SetQFlag $from "BloodPact1"
                    }
                    
                  20318 { WarlockPets::ClearBloodPact $from
                          ::SetQFlag $from "BloodPact2"
                    }
                    
                  20319 { WarlockPets::ClearBloodPact $from
                          ::SetQFlag $from "BloodPact3"
                    }
                    
                  20320 { WarlockPets::ClearBloodPact $from
                          ::SetQFlag $from "BloodPact4"
                    }
                    
                  20321 { WarlockPets::ClearBloodPact $from
                          ::SetQFlag $from "BloodPact5"
                    }    

                  20322 { WarlockPets::ClearFireShield $from
                          ::SetQFlag $from "FireShield1"
                    }
                    
                  20323 { WarlockPets::ClearFireShield $from
                          ::SetQFlag $from "FireShield2"
                    }
                    
                  20324 { WarlockPets::ClearFireShield $from
                          ::SetQFlag $from "FireShield3"
                    }
                    
                  20326 { WarlockPets::ClearFireShield $from
                          ::SetQFlag $from "FireShield4"
                    }
                    
                  20327 { WarlockPets::ClearFireShield $from
                          ::SetQFlag $from "FireShield5"
                    }    
                    
                  20329 {
                           ::SetQFlag $from "PhaseShift"
                    }    
                    
                  20317 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment2"
                    }
                    
                  20377 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment3"
                    }
                    
                  20378 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment4"
                    }
                    
                  20379 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment5"
                    }
                    
                  20380 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment6"
                    }
                    
                  20381 { WarlockPets::ClearTorment $from
                          ::SetQFlag $from "Torment7"
                    }        
                    
                  20381 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice1"
                    }                        

                  20382 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice2"
                    }
                    
                  20383 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice3"
                    }
                    
                  20384 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice4"
                    }
                    
                  20385 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice5"
                    }
                    
                  20386 { WarlockPets::ClearSacrifice $from
                          ::SetQFlag $from "Sacrifice6"
                    }        

                  20387 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows1"
                    }                        

                  20388 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows2"
                    }
                    
                  20389 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows3"
                    }
                    
                  20390 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows4"
                    }
                    
                  20391 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows5"
                    }
                    
                  20392 { WarlockPets::ClearConsumeShadows $from
                          ::SetQFlag $from "ConsumeShadows6"
                    }    

                  20393 { WarlockPets::ClearSuffering $from
                          ::SetQFlag $from "Suffering1"
                    }                        

                  20394 { WarlockPets::ClearSuffering $from
                          ::SetQFlag $from "Suffering2"
                    }
                    
                  20395 { WarlockPets::ClearSuffering $from
                          ::SetQFlag $from "Suffering3"
                    }
                    
                  20396 { WarlockPets::ClearSuffering $from
                          ::SetQFlag $from "Suffering4"
                    }        

                  20398 { WarlockPets::ClearLashOfPain $from
                          ::SetQFlag $from "LashOfPain2"
                    }
                    
                  20399 { WarlockPets::ClearLashOfPain $from
                          ::SetQFlag $from "LashOfPain3"
                    }
                    
                  20400 { WarlockPets::ClearLashOfPain $from
                          ::SetQFlag $from "LashOfPain4"
                    }
                    
                  20401 { WarlockPets::ClearLashOfPain $from
                          ::SetQFlag $from "LashOfPain5"
                    }
                    
                  20402 { WarlockPets::ClearLashOfPain $from
                          ::SetQFlag $from "LashOfPain6"
                    }            

                  20403 { WarlockPets::ClearSoothingKiss $from
                          ::SetQFlag $from "SoothingKiss1"
                    }
                    
                  20404 { WarlockPets::ClearSoothingKiss $from
                          ::SetQFlag $from "SoothingKiss2"
                    }
                    
                  20405 { WarlockPets::ClearSoothingKiss $from
                          ::SetQFlag $from "SoothingKiss3"
                    }
                    
                  20406 { WarlockPets::ClearSoothingKiss $from
                          ::SetQFlag $from "SoothingKiss4"
                    }    

                  20407 { 
                          ::SetQFlag $from "Seduction"
                    }                        
                    
                  20408 { 
                          ::SetQFlag $from "LesserInvisibility"
                    }    

                  20426 { WarlockPets::ClearDevourMagic $from
                          ::SetQFlag $from "DevourMagic2"
                    }
                    
                  20427 { WarlockPets::ClearDevourMagic $from
                          ::SetQFlag $from "DevourMagic3"
                    }
                    
                  20428 { WarlockPets::ClearDevourMagic $from
                          ::SetQFlag $from "DevourMagic4"
                    }        
                    
                  20429 { WarlockPets::ClearTaintedBlood $from
                          ::SetQFlag $from "TaintedBlood1"
                    }                    

                  20430 { WarlockPets::ClearTaintedBlood $from
                          ::SetQFlag $from "TaintedBlood2"
                    }
                    
                  20431 { WarlockPets::ClearTaintedBlood $from
                          ::SetQFlag $from "TaintedBlood3"
                    }
                    
                  20432 { WarlockPets::ClearTaintedBlood $from
                          ::SetQFlag $from "TaintedBlood4"
                    }            

                  20429 { WarlockPets::ClearSpellLock $from
                          ::SetQFlag $from "SpellLock1"
                    }                    

                  20430 { WarlockPets::ClearSpellLock $from
                          ::SetQFlag $from "SpellLock2"
                    }                    
        }
}

::PetScripts::Init

--[[
Credits: 
	Lucas: Figuring out the token system
	Proddy: Lua optimisations and class system
]]
MFKLexer = {
	ErrorOnUnknown = true
}

local KnownFunctions = {
	["ActivateTrigger"] = { MinArgs = 1, MaxArgs = 1 },
	["ActivateVehicle"] = { MinArgs = 3, MaxArgs = 4 },
	["AddAmbientCharacter"] = { MinArgs = 2, MaxArgs = 3 },
	["AddAmbientNPCWaypoint"] = { MinArgs = 2, MaxArgs = 2 },
	["AddAmbientNpcAnimation"] = { MinArgs = 1, MaxArgs = 2 },
	["AddAmbientPcAnimation"] = { MinArgs = 1, MaxArgs = 2 },
	["AddBehaviour"] = { MinArgs = 2, MaxArgs = 7 },
	["AddBonusMission"] = { MinArgs = 1, MaxArgs = 1 },
	["AddBonusMissionNPCWaypoint"] = { MinArgs = 2, MaxArgs = 2 },
	["AddBonusObjective"] = { MinArgs = 1, MaxArgs = 2 },
	["AddCharacter"] = { MinArgs = 2, MaxArgs = 2 },
	["AddCollectible"] = { MinArgs = 1, MaxArgs = 4 },
	["AddCollectibleStateProp"] = { MinArgs = 3, MaxArgs = 3 },
	["AddCondition"] = { MinArgs = 1, MaxArgs = 2 },
	["AddDriver"] = { MinArgs = 2, MaxArgs = 2 },
	["AddFlyingActor"] = { MinArgs = 5, MaxArgs = 5 },
	["AddFlyingActorByLocator"] = { MinArgs = 3, MaxArgs = 4 },
	["AddGagBinding"] = { MinArgs = 5, MaxArgs = 5 },
	["AddGlobalProp"] = { MinArgs = 1, MaxArgs = 1 },
	["AddMission"] = { MinArgs = 1, MaxArgs = 1 },
	["AddNPC"] = { MinArgs = 2, MaxArgs = 3 },
	["AddNPCCharacterBonusMission"] = { MinArgs = 7, MaxArgs = 8 },
	["AddObjective"] = { MinArgs = 1, MaxArgs = 3 },
	["AddObjectiveNPCWaypoint"] = { MinArgs = 2, MaxArgs = 2 },
	["AddPed"] = { MinArgs = 2, MaxArgs = 2 },
	["AddPurchaseCarNPCWaypoint"] = { MinArgs = 2, MaxArgs = 2 },
	["AddPurchaseCarReward"] = { MinArgs = 5, MaxArgs = 6 },
	["AddSafeZone"] = { MinArgs = 2, MaxArgs = 2 },
	["AddShield"] = { MinArgs = 2, MaxArgs = 2 },
	["AddSpawnPoint"] = { MinArgs = 8, MaxArgs = 8 },
	["AddSpawnPointByLocatorScript"] = { MinArgs = 6, MaxArgs = 6 },
	["AddStage"] = { MinArgs = 0, MaxArgs = 7 },
	["AddStageCharacter"] = { MinArgs = 3, MaxArgs = 5 },
	["AddStageMusicChange"] = { MinArgs = 0, MaxArgs = 0 },
	["AddStageTime"] = { MinArgs = 1, MaxArgs = 1 },
	["AddStageVehicle"] = { MinArgs = 3, MaxArgs = 5 },
	["AddStageWaypoint"] = { MinArgs = 1, MaxArgs = 1 },
	["AddTeleportDest"] = { MinArgs = 3, MaxArgs = 5 },
	["AddToCountdownSequence"] = { MinArgs = 1, MaxArgs = 2 },
	["AddTrafficModel"] = { MinArgs = 2, MaxArgs = 3 },
	["AddVehicleSelectInfo"] = { MinArgs = 3, MaxArgs = 3 },
	["AllowMissionAbort"] = { MinArgs = 1, MaxArgs = 1 },
	["AllowRockOut"] = { MinArgs = 0, MaxArgs = 0 },
	["AllowUserDump"] = { MinArgs = 0, MaxArgs = 0 },
	["AmbientAnimationRandomize"] = { MinArgs = 2, MaxArgs = 2 },
	["AttachStatePropCollectible"] = { MinArgs = 2, MaxArgs = 2 },
	["BindCollectibleTo"] = { MinArgs = 2, MaxArgs = 2 },
	["BindReward"] = { MinArgs = 5, MaxArgs = 7 },
	["CharacterIsChild"] = { MinArgs = 1, MaxArgs = 1 },
	["ClearAmbientAnimations"] = { MinArgs = 1, MaxArgs = 1 },
	["ClearGagBindings"] = { MinArgs = 0, MaxArgs = 0 },
	["ClearTrafficForStage"] = { MinArgs = 0, MaxArgs = 0 },
	["ClearVehicleSelectInfo"] = { MinArgs = 0, MaxArgs = 0 },
	["CloseCondition"] = { MinArgs = 0, MaxArgs = 0 },
	["CloseMission"] = { MinArgs = 0, MaxArgs = 0 },
	["CloseObjective"] = { MinArgs = 0, MaxArgs = 0 },
	["ClosePedGroup"] = { MinArgs = 0, MaxArgs = 0 },
	["CloseStage"] = { MinArgs = 0, MaxArgs = 0 },
	["CloseTrafficGroup"] = { MinArgs = 0, MaxArgs = 0 },
	["CreateActionEventTrigger"] = { MinArgs = 5, MaxArgs = 5 },
	["CreateAnimPhysObject"] = { MinArgs = 2, MaxArgs = 2 },
	["CreateChaseManager"] = { MinArgs = 3, MaxArgs = 3 },
	["CreatePedGroup"] = { MinArgs = 1, MaxArgs = 1 },
	["CreateTrafficGroup"] = { MinArgs = 1, MaxArgs = 1 },
	["DeactivateTrigger"] = { MinArgs = 1, MaxArgs = 1 },
	["DisableHitAndRun"] = { MinArgs = 0, MaxArgs = 0 },
	["EnableHitAndRun"] = { MinArgs = 0, MaxArgs = 0 },
	["EnableTutorialMode"] = { MinArgs = 1, MaxArgs = 1 },
	["GagBegin"] = { MinArgs = 1, MaxArgs = 1 },
	["GagCheckCollCards"] = { MinArgs = 5, MaxArgs = 5 },
	["GagCheckMovie"] = { MinArgs = 4, MaxArgs = 4 },
	["GagEnd"] = { MinArgs = 0, MaxArgs = 0 },
	["GagPlayFMV"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetAnimCollision"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetCameraShake"] = { MinArgs = 2, MaxArgs = 3 },
	["GagSetCoins"] = { MinArgs = 1, MaxArgs = 2 },
	["GagSetCycle"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetInterior"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetIntro"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetLoadDistances"] = { MinArgs = 2, MaxArgs = 2 },
	["GagSetOutro"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetPersist"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetPosition"] = { MinArgs = 1, MaxArgs = 3 },
	["GagSetRandom"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetSound"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetSoundLoadDistances"] = { MinArgs = 2, MaxArgs = 2 },
	["GagSetSparkle"] = { MinArgs = 1, MaxArgs = 1 },
	["GagSetTrigger"] = { MinArgs = 3, MaxArgs = 5 },
	["GagSetWeight"] = { MinArgs = 1, MaxArgs = 1 },
	["GoToPsScreenWhenDone"] = { MinArgs = 0, MaxArgs = 0 },
	["InitLevelPlayerVehicle"] = { MinArgs = 3, MaxArgs = 4 },
	["KillAllChaseAI"] = { MinArgs = 1, MaxArgs = 1 },
	["LinkActionToObject"] = { MinArgs = 5, MaxArgs = 5 },
	["LinkActionToObjectJoint"] = { MinArgs = 5, MaxArgs = 5 },
	["LoadDisposableCar"] = { MinArgs = 3, MaxArgs = 3 },
	["LoadP3DFile"] = { MinArgs = 1, MaxArgs = 3 },
	["MoveStageVehicle"] = { MinArgs = 3, MaxArgs = 3 },
	["MustActionTrigger"] = { MinArgs = 0, MaxArgs = 0 },
	["NoTrafficForStage"] = { MinArgs = 0, MaxArgs = 0 },
	["PlacePlayerAtLocatorName"] = { MinArgs = 1, MaxArgs = 1 },
	["PlacePlayerCar"] = { MinArgs = 2, MaxArgs = 2 },
	["PreallocateActors"] = { MinArgs = 2, MaxArgs = 2 },
	["PutMFPlayerInCar"] = { MinArgs = 0, MaxArgs = 0 },
	["RESET_TO_HERE"] = { MinArgs = 0, MaxArgs = 0 },
	["RemoveDriver"] = { MinArgs = 1, MaxArgs = 1 },
	["RemoveNPC"] = { MinArgs = 1, MaxArgs = 1 },
	["ResetCharacter"] = { MinArgs = 2, MaxArgs = 2 },
	["ResetHitAndRun"] = { MinArgs = 0, MaxArgs = 0 },
	["SelectMission"] = { MinArgs = 1, MaxArgs = 1 },
	["SetActorRotationSpeed"] = { MinArgs = 2, MaxArgs = 2 },
	["SetAllowSeatSlide"] = { MinArgs = 1, MaxArgs = 1 },
	["SetAnimCamMulticontName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetAnimatedCameraName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetBonusMissionDialoguePos"] = { MinArgs = 3, MaxArgs = 4 },
	["SetBonusMissionStart"] = { MinArgs = 0, MaxArgs = 0 },
	["SetBrakeScale"] = { MinArgs = 1, MaxArgs = 1 },
	["SetBurnoutRange"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCMOffsetX"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCMOffsetY"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCMOffsetZ"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCamBestSide"] = { MinArgs = 1, MaxArgs = 2 },
	["SetCarAttributes"] = { MinArgs = 5, MaxArgs = 5 },
	["SetCarStartCamera"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCharacterPosition"] = { MinArgs = 3, MaxArgs = 3 },
	["SetCharacterScale"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCharacterToHide"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCharactersVisible"] = { MinArgs = 1, MaxArgs = 1 },
	["SetChaseSpawnRate"] = { MinArgs = 2, MaxArgs = 2 },
	["SetCoinDrawable"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCoinFee"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCollectibleEffect"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCollisionAttributes"] = { MinArgs = 4, MaxArgs = 4 },
	["SetCompletionDialog"] = { MinArgs = 1, MaxArgs = 2 },
	["SetCondMinHealth"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCondTargetVehicle"] = { MinArgs = 1, MaxArgs = 1 },
	["SetCondTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetConditionPosition"] = { MinArgs = 1, MaxArgs = 1 },
	["SetConversationCam"] = { MinArgs = 2, MaxArgs = 3 },
	["SetConversationCamDistance"] = { MinArgs = 2, MaxArgs = 2 },
	["SetConversationCamName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetConversationCamNpcName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetConversationCamPcName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDamperC"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDemoLoopTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDestination"] = { MinArgs = 1, MaxArgs = 3 },
	["SetDialogueInfo"] = { MinArgs = 4, MaxArgs = 4 },
	["SetDialoguePositions"] = { MinArgs = 2, MaxArgs = 4 },
	["SetDonutTorque"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDriver"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDurationTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetDynaLoadData"] = { MinArgs = 1, MaxArgs = 2 },
	["SetEBrakeEffect"] = { MinArgs = 1, MaxArgs = 1 },
	["SetFMVInfo"] = { MinArgs = 1, MaxArgs = 2 },
	["SetFadeOut"] = { MinArgs = 1, MaxArgs = 1 },
	["SetFollowDistances"] = { MinArgs = 2, MaxArgs = 2 },
	["SetForcedCar"] = { MinArgs = 0, MaxArgs = 0 },
	["SetGamblingOdds"] = { MinArgs = 1, MaxArgs = 1 },
	["SetGameOver"] = { MinArgs = 0, MaxArgs = 0 },
	["SetGasScale"] = { MinArgs = 1, MaxArgs = 1 },
	["SetGasScaleSpeedThreshold"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHUDIcon"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHasDoors"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHighRoof"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHighSpeedGasScale"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHighSpeedSteeringDrop"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHitAndRunDecay"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHitAndRunDecayInterior"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHitAndRunMeter"] = { MinArgs = 1, MaxArgs = 1 },
	["SetHitNRun"] = { MinArgs = 0, MaxArgs = 0 },
	["SetHitPoints"] = { MinArgs = 1, MaxArgs = 1 },
	["SetInitialWalk"] = { MinArgs = 1, MaxArgs = 1 },
	["SetIrisTransition"] = { MinArgs = 1, MaxArgs = 1 },
	["SetIrisWipe"] = { MinArgs = 1, MaxArgs = 1 },
	["SetLevelOver"] = { MinArgs = 0, MaxArgs = 0 },
	["SetMass"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMaxSpeedBurstTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMaxTraffic"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMaxWheelTurnAngle"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMissionNameIndex"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMissionResetPlayerInCar"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMissionResetPlayerOutCar"] = { MinArgs = 2, MaxArgs = 2 },
	["SetMissionStartCameraName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMissionStartMulticontName"] = { MinArgs = 1, MaxArgs = 1 },
	["SetMusicState"] = { MinArgs = 2, MaxArgs = 2 },
	["SetNormalSteering"] = { MinArgs = 1, MaxArgs = 1 },
	["SetNumChaseCars"] = { MinArgs = 1, MaxArgs = 1 },
	["SetNumValidFailureHints"] = { MinArgs = 1, MaxArgs = 1 },
	["SetObjDistance"] = { MinArgs = 1, MaxArgs = 1 },
	["SetObjTargetBoss"] = { MinArgs = 1, MaxArgs = 1 },
	["SetObjTargetVehicle"] = { MinArgs = 1, MaxArgs = 1 },
	["SetParTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetParticleTexture"] = { MinArgs = 2, MaxArgs = 2 },
	["SetPickupTarget"] = { MinArgs = 1, MaxArgs = 1 },
	["SetPlayerCarName"] = { MinArgs = 2, MaxArgs = 2 },
	["SetPostLevelFMV"] = { MinArgs = 1, MaxArgs = 1 },
	["SetPresentationBitmap"] = { MinArgs = 1, MaxArgs = 1 },
	["SetProjectileStats"] = { MinArgs = 3, MaxArgs = 3 },
	["SetRaceEnteryFee"] = { MinArgs = 1, MaxArgs = 1 },
	["SetRaceLaps"] = { MinArgs = 1, MaxArgs = 1 },
	["SetRespawnRate"] = { MinArgs = 2, MaxArgs = 2 },
	["SetShadowAdjustments"] = { MinArgs = 8, MaxArgs = 8 },
	["SetShininess"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSlipEffectNoEBrake"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSlipGasScale"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSlipSteering"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSlipSteeringNoEBrake"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSpringK"] = { MinArgs = 1, MaxArgs = 1 },
	["SetStageAIEvadeCatchupParams"] = { MinArgs = 3, MaxArgs = 3 },
	["SetStageAIRaceCatchupParams"] = { MinArgs = 5, MaxArgs = 5 },
	["SetStageAITargetCatchupParams"] = { MinArgs = 3, MaxArgs = 3 },
	["SetStageCamera"] = { MinArgs = 3, MaxArgs = 3 },
	["SetStageMessageIndex"] = { MinArgs = 1, MaxArgs = 2 },
	["SetStageMusicAlwaysOn"] = { MinArgs = 0, MaxArgs = 0 },
	["SetStageTime"] = { MinArgs = 1, MaxArgs = 1 },
	["SetStatepropShadow"] = { MinArgs = 2, MaxArgs = 2 },
	["SetSuspensionLimit"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSuspensionYOffset"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSwapDefaultCarLocator"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSwapForcedCarLocator"] = { MinArgs = 1, MaxArgs = 1 },
	["SetSwapPlayerLocator"] = { MinArgs = 1, MaxArgs = 1 },
	["SetTalkToTarget"] = { MinArgs = 1, MaxArgs = 4 },
	["SetTireGrip"] = { MinArgs = 1, MaxArgs = 1 },
	["SetTopSpeedKmh"] = { MinArgs = 1, MaxArgs = 1 },
	["SetTotalGags"] = { MinArgs = 2, MaxArgs = 2 },
	["SetTotalWasps"] = { MinArgs = 2, MaxArgs = 2 },
	["SetVehicleAIParams"] = { MinArgs = 3, MaxArgs = 3 },
	["SetVehicleToLoad"] = { MinArgs = 3, MaxArgs = 3 },
	["SetWeebleOffset"] = { MinArgs = 1, MaxArgs = 1 },
	["SetWheelieOffsetY"] = { MinArgs = 1, MaxArgs = 1 },
	["SetWheelieOffsetZ"] = { MinArgs = 1, MaxArgs = 1 },
	["SetWheelieRange"] = { MinArgs = 1, MaxArgs = 1 },
	["ShowHUD"] = { MinArgs = 1, MaxArgs = 1 },
	["ShowStageComplete"] = { MinArgs = 0, MaxArgs = 0 },
	["StageStartMusicEvent"] = { MinArgs = 1, MaxArgs = 1 },
	["StartCountdown"] = { MinArgs = 1, MaxArgs = 2 },
	["StayInBlack"] = { MinArgs = 0, MaxArgs = 0 },
	["StreetRacePropsLoad"] = { MinArgs = 1, MaxArgs = 1 },
	["StreetRacePropsUnload"] = { MinArgs = 1, MaxArgs = 1 },
	["SuppressDriver"] = { MinArgs = 1, MaxArgs = 1 },
	["SwapInDefaultCar"] = { MinArgs = 0, MaxArgs = 0 },
	["TurnGotoDialogOff"] = { MinArgs = 0, MaxArgs = 0 },
	["UseElapsedTime"] = { MinArgs = 0, MaxArgs = 0 },
	["UsePedGroup"] = { MinArgs = 1, MaxArgs = 1 },
	["msPlacePlayerCarAtLocatorName"] = { MinArgs = 1, MaxArgs = 1 },
	-- Additional Script Functionality
	["AddCondTargetModel"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["AddObjTargetModel"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["AddParkedCar"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["AddStageVehicleCharacter"] = { MinArgs = 2, MaxArgs = 4, Hack = "AdditionalScriptFunctionality" },
	["AddVehicleCharacter"] = { MinArgs = 1, MaxArgs = 3, Hack = "AdditionalScriptFunctionality" },
	["AddVehicleCharacterSuppressionCharacter"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["CHECKPOINT_HERE"] = { MinArgs = 0, MaxArgs = 0, Hack = "AdditionalScriptFunctionality" },
	["DisableTrigger"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["IfCurrentCheckpoint"] = { MinArgs = 0, MaxArgs = 0, Hack = "AdditionalScriptFunctionality", Conditional = true },
	["RemoveStageVehicleCharacter"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["ResetStageHitAndRun"] = { MinArgs = 0, MaxArgs = 0, Hack = "AdditionalScriptFunctionality" },
	["ResetStageVehicleAbductable"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCarChangeHitAndRunChange"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCheckpointDynaLoadData"] = { MinArgs = 1, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetCheckpointPedGroup"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCheckpointResetPlayerInCar"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCheckpointResetPlayerOutCar"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetCheckpointTrafficGroup"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCollectibleSoundEffect"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondDecay"] = { MinArgs = 1, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetCondDelay"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondDisplay"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondMessageIndex"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondSound"] = { MinArgs = 1, MaxArgs = 4, Hack = "AdditionalScriptFunctionality" },
	["SetCondSpeedRangeKMH"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetCondThreshold"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondTotal"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetCondTrigger"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetConditionalParameter"] = { MinArgs = 3, MaxArgs = 5, Hack = "AdditionalScriptFunctionality" },
	["SetHUDMapDrawable"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetHitAndRunDecayHitAndRun"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetHitAndRunFine"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetNoHitAndRunMusicForStage"] = { MinArgs = 0, MaxArgs = 0, Hack = "AdditionalScriptFunctionality" },
	["SetObjCameraName"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjCanSkip"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjDecay"] = { MinArgs = 1, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetObjExplosion"] = { MinArgs = 2, MaxArgs = 3, Hack = "AdditionalScriptFunctionality" },
	["SetObjMessageIndex"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjMulticontName"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjNoLetterbox"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjSound"] = { MinArgs = 1, MaxArgs = 4, Hack = "AdditionalScriptFunctionality" },
	["SetObjSpeedKMH"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjThreshold"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjTotal"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjTrigger"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetObjUseCameraPosition"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetParkedCarsEnabled"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetPedsEnabled"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageAllowMissionCancel"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageCarChangeHitAndRunChange"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageCharacterModel"] = { MinArgs = 1, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetStageHitAndRun"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageHitAndRunDecay"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageHitAndRunDecayHitAndRun"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageHitAndRunDecayInterior"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageHitAndRunFine"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageNumChaseCars"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStagePayout"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleAbductable"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleAllowSeatSlide"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleCharacterAnimation"] = { MinArgs = 3, MaxArgs = 4, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleCharacterJumpOut"] = { MinArgs = 2, MaxArgs = 3, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleCharacterScale"] = { MinArgs = 3, MaxArgs = 3, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleCharacterVisible"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleNoDestroyedJumpOut"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetStageVehicleReset"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetVehicleCharacterAnimation"] = { MinArgs = 2, MaxArgs = 3, Hack = "AdditionalScriptFunctionality" },
	["SetVehicleCharacterJumpOut"] = { MinArgs = 1, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetVehicleCharacterScale"] = { MinArgs = 2, MaxArgs = 2, Hack = "AdditionalScriptFunctionality" },
	["SetVehicleCharacterVisible"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["SetWheelieOffsetX"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	["UseTrafficGroup"] = { MinArgs = 1, MaxArgs = 1, Hack = "AdditionalScriptFunctionality" },
	-- Debug Test
	["DebugBreak"] = { MinArgs = 0, MaxArgs = 0, Hack = "DebugTest" },
	["LucasTest"] = { MinArgs = 0, MaxArgs = 16, Hack = "DebugTest" },
	["Sleep"] = { MinArgs = 1, MaxArgs = 1, Hack = "DebugTest" },
	["TaskMessage"] = { MinArgs = 3, MaxArgs = 4, Hack = "DebugTest" },
}
local LoadedHacks = {}
for i=1,#KnownFunctions do
	local KnownFunction = KnownFunctions[i]
	if KnownFunction and KnownFunction.Hack and LoadedHacks[KnownFunction.Hack] == nil then
		LoadedHacks[KnownFunction.Hack] = IsHackLoaded(KnownFunction.Hack)
	end
end

local Char_Tab = 9
local Char_LF = 10
local Char_CR = 13
local Char_Space = 32
local Char_Quote = 34
local Char_Asterisk = 42
local Char_FWSlash = 47
local Char_Backslash = 92
local WhiteSpaceCharacters = {
	[9] = true, -- Tab
	[10] = true, -- \n
	[13] = true, -- \r
	[32] = true, -- Space
}

local TokenEndCharacters = {
	[9] = true, -- Tab
	[10] = true, -- \n
	[13] = true, -- \r
	[32] = true, --  Space
	[33] = true, -- !
	[34] = true, -- "
	[35] = true, -- #
	[36] = true, -- $
	[37] = true, -- %
	[38] = true, -- &
	[39] = true, -- '
	[40] = true, -- (
	[41] = true, -- )
	[42] = true, -- *
	[43] = true, -- +
	[44] = true, -- ,
	[47] = true, -- /
	[58] = true, -- :
	[59] = true, -- ;
	[60] = true, -- <
	[62] = true, -- >
	[63] = true, -- ?
	[64] = true, -- @
	[91] = true, -- [
	[92] = true, -- \
	[93] = true, -- ]
	[94] = true, -- ^
	[96] = true, -- `
	[123] = true, -- {
	[125] = true, -- }
	[126] = true, -- ~
}

local string_byte = string.byte
local string_format = string.format
local string_lower = string.lower
local string_sub = string.sub
local table_concat = table.concat
local table_remove = table.remove

local assert = assert
local tonumber = tonumber
local tostring = tostring
local type = type

MFKLexer.MFKFunction = {}
function MFKLexer.MFKFunction:New(Name, Arguments, Conditional, Not)
	Arguments = Arguments or {}
	if type(Arguments) ~= "table" then Arguments = {Arguments} end
	local cmd = {}
	cmd.Name, cmd.Arguments, cmd.Conditional, cmd.Not, cmd.Children = Name, Arguments, Conditional, Not, {}
	self.__index = self
	return setmetatable(cmd, self)
end

function MFKLexer.MFKFunction:AddChildFunction(Func)
	assert(self.Conditional, "Cannot add a child function to a not-conditional function.")
	self.Children[#self.Children + 1] = Func
end

function MFKLexer.MFKFunction:SetArg(Index, Value, Condition)
	if Condition == nil or tostring(Condition) == tostring(self.Arguments[Index]) then
		self.Arguments[Index] = Value
		return true
	end
	return false
end

function MFKLexer.MFKFunction:__tostring()
	local FunctionName = self.Name
	local Arguments = self.Arguments
	local ArgumentsN = #Arguments
	
	local KnownFunction = KnownFunctions[FunctionName]
	if KnownFunction then
		assert(KnownFunction.Hack == nil or LoadedHacks[KnownFunction.Hack], string_format("Function %s requires non-loaded hack: %s", FunctionName, KnownFunction.Hack))
		assert(ArgumentsN >= KnownFunction.MinArgs and ArgumentsN <= KnownFunction.MaxArgs, string_format("Function %s requires between %i and %i arguments.", FunctionName, KnownFunction.MinArgs, KnownFunction.MaxArgs))
		assert(not self.Conditional or KnownFunction.Conditional, string_format("Function %s %s a conditional.", FunctionName, KnownFunction.Conditional and "is" or "is not"))
	else
		assert(not MFKLexer.ErrorOnUnknown, string_format("Unknown function: ", FunctionName))
	end
	
	local output = {}
	if self.Not then output[1] = "!" end
	output[#output + 1] = "\"" .. FunctionName .. "\"("
	for i=1,ArgumentsN do
		if i > 1 then output[#output + 1] = "," end
		output[#output + 1] = "\"" .. Arguments[i] .. "\""
	end
	output[#output + 1] = ")"
	if self.Conditional then
		output[#output + 1] = "{"
		for i=1,#self.Children do
			output[#output + 1] = tostring(self.Children[i])
		end
		output[#output + 1] = "}"
	else
		output[#output + 1] = ";"
	end
	return table_concat(output)
end
function MFKLexer.MFKFunction:Output(Clean)
	local FunctionName = self.Name
	local Arguments = self.Arguments
	local ArgumentsN = #Arguments
	
	local KnownFunction = KnownFunctions[FunctionName]
	if KnownFunction then
		assert(KnownFunction.Hack == nil or LoadedHacks[KnownFunction.Hack], string_format("Function %s requires non-loaded hack: %s", FunctionName, KnownFunction.Hack))
		assert(ArgumentsN >= KnownFunction.MinArgs and ArgumentsN <= KnownFunction.MaxArgs, string_format("Function %s requires between %i and %i arguments.", FunctionName, KnownFunction.MinArgs, KnownFunction.MaxArgs))
		assert(not self.Conditional or KnownFunction.Conditional, string_format("Function %s %s a conditional.", FunctionName, KnownFunction.Conditional and "is" or "is not"))
	else
		assert(not MFKLexer.ErrorOnUnknown, string_format("Unknown function: ", FunctionName))
	end
	
	Output("\"" .. FunctionName .. "\"(")
	for i=1,ArgumentsN do
		if i > 1 then Output(",") end
		Output("\"" .. Arguments[i] .. "\"")
	end
	Output(")")
	if self.Conditional then
		Output("{")
		if Clean then Output("\r\n") end
		for i=1,#self.Children do
			self.Children[i]:Output()
		end
		if Clean then Output("\r\n") end
		Output("}")
	else
		Output(";")
	end
	if Clean then
		Output("\r\n")
	end
end


MFKLexer.Lexer = {}
function MFKLexer.Lexer:New()
	local RetVal = {}
	RetVal.Functions = {}
	
	self.__index = self
	return setmetatable(RetVal, self)
end

function MFKLexer.Lexer:Parse(Text)
	local RetVal = {}
	local TextBytes = {string_byte(Text, 1, #Text)}
	local TextOffset = 0
	local Line = 1
	local Character
	
	local function Advance()
		TextOffset = TextOffset + 1
		if TextOffset <= #TextBytes then
			Character = TextBytes[TextOffset]
		else
			Character = 0
		end
		
		if Character == Char_LF then Line = Line + 1 end
	end
	
	Advance()
	
	local function SkipWhiteSpace()
		while Character ~= 0 and WhiteSpaceCharacters[Character] do
			Advance()
		end
	end

	local function SkipComment()
		if Character == Char_FWSlash then
			Advance()
			
			if Character == Char_FWSlash then
				while Character ~= Char_LF and Character ~= Char_CR and Character ~= 0 do
					Advance()
				end
				
				return true
			elseif Character == Char_Asterisk then
				while true do
					Advance()
					
					if Character == Char_Asterisk then
						Advance()
						
						if Character == Char_FWSlash then
							Advance()
							
							break
						end
					elseif Character == 0 then
						break
					end
				end
				
				return true
			end
		end
		
		return false
	end

	local function SkipWhiteSpaceAndComments()
		repeat
			SkipWhiteSpace()
		until not SkipComment()
	end

	local function ReadToTokenEndOrCharacter()
		local StartOffset = TextOffset
		
		while Character ~= 0 and not TokenEndCharacters[Character] do
			Advance()
		end
		
		if TextOffset == StartOffset then
			Advance()
		end
		
		return string_sub(Text, StartOffset, TextOffset - 1)
	end

	local function ReadToQuoteEnd()
		local StartOffset = TextOffset
		local EndOffset = StartOffset
		
		while Character ~= 0 do
			if Character == Char_Backslash then
				Advance()
				
				EndOffset = TextOffset
				
				if Character == Char_Quote then
					Advance()
					
					EndOffset = TextOffset
					
					goto Continue
				end
				
				goto Continue
			end
			
			if Character == Char_Quote then
				Advance()
				
				break
			end
			
			Advance()
			
			EndOffset = TextOffset
			
			::Continue::
		end
		
		return string_sub(Text, StartOffset, EndOffset - 1)
	end

	local function ReadToken()
		SkipWhiteSpaceAndComments()
		
		if Character == 0 then return nil end
		
		if Character == Char_Quote then
			Advance()
			
			return ReadToQuoteEnd()
		end
		
		return ReadToTokenEndOrCharacter()
	end

	local function ReadTokenNotEndOfFile()
		local Result = ReadToken()
		assert(Result, "Result == nil")
		return Result
	end

	local function ExpectToken(Token)
		local Token2 = ReadToken()
		assert(Token == Token2, string_format("Expected token: %s\nGot token: %s", Token, Token2))
	end
	
	local ConditionalLevel = 0
	local ConditionalParents = {}
	RetVal.Functions = {}
	
	while true do
		local FunctionName = ReadToken()
		if FunctionName == nil then break end
		
		if FunctionName == "}" then
			ConditionalLevel = ConditionalLevel - 1
			ConditionalParents[#ConditionalParents] = nil
		else
			local Not = FunctionName == "!"
			if Not then
				FunctionName = ReadTokenNotEndOfFile()
			end
			
			ExpectToken("(")
			
			local Arguments = {}
			local ArgumentsN = 0
			while true do
				local Token = ReadTokenNotEndOfFile()
				if Token == ")" then break end
				
				if ArgumentsN > 0 then
					assert(Token == ",", string_format("Expected token: ,\nGot token: %s", Token))
					Token = ReadTokenNotEndOfFile()
				end
				
				ArgumentsN = ArgumentsN + 1
				Arguments[ArgumentsN] = tonumber(Token) or Token
			end
			
			local Conditional = false
			local Token2 = ReadToken()
			if Token2 == "{" then
				Conditional = true
				ConditionalLevel = ConditionalLevel + 1
			else
				assert(Token2 == ";", string_format("Expected token: ;\nGot token: ", Token2))
			end
			
			if not Conditional then
				assert(not Not, "! but not conditional")
			end
			
			local KnownFunction = KnownFunctions[FunctionName]
			if KnownFunction then
				assert(KnownFunction.Hack == nil or LoadedHacks[KnownFunction.Hack], string_format("Function %s requires non-loaded hack: %s", FunctionName, KnownFunction.Hack))
				assert(ArgumentsN >= KnownFunction.MinArgs and ArgumentsN <= KnownFunction.MaxArgs, string_format("Function %s requires between %i and %i arguments.", FunctionName, KnownFunction.MinArgs, KnownFunction.MaxArgs))
				assert(not self.Conditional or KnownFunction.Conditional, string_format("Function %s %s a conditional.", FunctionName, KnownFunction.Conditional and "is" or "is not"))
			else
				assert(not MFKLexer.ErrorOnUnknown, string_format("Unknown function: ", FunctionName))
			end
			
			local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
			if #ConditionalParents > 0 then
				ConditionalParents[#ConditionalParents]:AddChildFunction(Func)
			else
				RetVal.Functions[#RetVal.Functions + 1] = Func
			end
			if Conditional then
				ConditionalParents[#ConditionalParents + 1] = Func
			end
		end
	end
	
	self.__index = self
	return setmetatable(RetVal, self)
end

function MFKLexer.Lexer:AddFunction(FunctionName, Arguments, Conditional, Not)
	local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
	self.Functions[#self.Functions + 1] = Func
	return Func
end

function MFKLexer.Lexer:InsertFunction(Index, FunctionName, Arguments, Conditional, Not)
	local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
	table.insert(self.Functions, Index, Func)
	return Func
end

function MFKLexer.Lexer:GetFunctions(Name, Backwards)
	if Name then
		assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
		Name = string_lower(Name)
	end
	
	local functions = self.Functions
	local functionsN = #functions
	
	local index, finish, step
	if Backwards then
		index = functionsN
		finish = 0
		step = -1
	else
		index = 1
		finish = functionsN + 1
		step = 1
	end
	
	return function()
		while index ~= finish do
			assert(Backwards or functionsN == #functions, string_format("Function count changed from %d to %d. To add or remove functions whilst iterating, you must iterate backwards", functionsN, #functions))
			local Function = functions[index]
			index = index + step
			if (Name == nil or string_lower(Function.Name) == Name) then
				return Function, index - step
			end
		end
		return nil
	end
end

function MFKLexer.Lexer:GetFunction(Name, Backwards)
	return self:GetFunctions(Name, Backwards)()
end

function MFKLexer.Lexer:RemoveFunction(Index)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number.")
	assert(Index > 0 and Index <= #self.Functions, "Arg #1 (Index) out of bounds.")
	table_remove(self.Functions, Index)
end

local function SetFunctionArgument(FunctionName, Function, Index, Value, Condition)
	local changed = false
	if string_lower(Function.Name) == FunctionName then
		changed = Function:SetArg(Index, Value, Condition)
	end
	if Function.Conditional then
		for i=1,#Function.Children do
			changed = SetFunctionArgument(FunctionName, Function.Children[i], Index, Value, Condition) or changed
		end
	end
	return changed
end
function MFKLexer.Lexer:SetAll(FunctionName, Index, Value, Condition)
	local changed = false
	FunctionName = string_lower(FunctionName)
	for Function in self:GetFunctions() do
		changed = SetFunctionArgument(FunctionName, Function, Index, Value, Condition) or changed
	end
	return changed
end

function MFKLexer.Lexer:__tostring()
	local output = {}
	for i=1,#self.Functions do
		output[i] = tostring(self.Functions[i])
	end
	return table_concat(output)
end
function MFKLexer.Lexer:Output(Clean)
	for i=1,#self.Functions do
		self.Functions[i]:Output(Clean)
	end
end


return MFKLexer
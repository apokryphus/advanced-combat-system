// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
// Not authorized to be distributed elsewhere, unless you ask me nicely.

function ACS_Custom_Attack_Range( data : CPreAttackEventData ) : array< CGameplayEntity >
{
	var targets 					: array<CGameplayEntity>;
	var dist, ang					: float;
	var pos, targetPos				: Vector;
	var i							: int;
	
	pos = thePlayer.GetWorldPosition();
	pos.Z += 0.8;
	
	targets.Clear();
	
	if (!thePlayer.IsPerformingFinisher())
	{
		if ( thePlayer.IsWeaponHeld( 'fist' ) )
		{
			if ( thePlayer.HasTag('vampire_claws_equipped') )
			{
				if ( thePlayer.HasBuff(EET_BlackBlood) )
				{
					dist = 2;
					ang = 90;
				}
				else	
				{
					dist = 1.25;
					ang = 60;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}
		}
		else
		{
			if ( thePlayer.HasTag('igni_sword_equipped_TAG') )
			{
				if (thePlayer.GetTarget() == ACS_Big_Boi() )
				{
					dist = 1.75;
					ang =	30;
				}
				else
				{
					dist = 1.5;
					ang =	30;
				}
			}
			else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') )
			{
				if (thePlayer.GetTarget() == ACS_Big_Boi() )
				{
					dist = 1.75;
					ang =	30;
				}
				else
				{
					dist = 1.5;
					ang =	30;
				}	
			}
			else if ( thePlayer.HasTag('axii_sword_equipped') )
			{
				if ( thePlayer.HasTag('ACS_Shielded_Entity') )
				{
					dist = 5;
					ang =	135;
				}
				else if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					dist = 10;
					ang =	60;
				}
				else
				{
					if (thePlayer.GetTarget() == ACS_Big_Boi() )
					{
						dist = 1.75;
						ang =	30;
					}
					else
					{
						dist = 1.5;
						ang =	30;	
					}
				}
			}
			else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
			{
				if ( 
				ACS_GetWeaponMode() == 0
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2
				)
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{ 
					dist = 2;
					ang =	30;
				}
			}
			else if ( thePlayer.HasTag('aard_sword_equipped') )
			{
				dist = 2;
				ang =	75;	
			}
			else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
			{
				dist = 2;
				ang = 30;
			}
			else if ( thePlayer.HasTag('yrden_sword_equipped') )
			{
				if ( ACS_GetWeaponMode() == 0 )
				{
					if (ACS_GetArmigerModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 1 )
				{
					if (ACS_GetFocusModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 2 )
				{
					if (ACS_GetHybridModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{
					dist = 2.5;
					ang = 60;
				}
			}
			else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( thePlayer.HasTag('quen_sword_equipped') )
			{
				if (thePlayer.GetTarget() == ACS_Big_Boi() )
				{
					dist = 1.75;
					ang =	30;
				}
				else
				{
					dist = 1.5;
					ang =	30;
				}
			}
			else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
			{
				if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
				{
					dist = 10;
					ang =	30;
				}
				else
				{
					dist = 2.25;
					ang =	40;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}
		}
	}
	else 
	{
		dist = 1;
		ang = 30;
	}

	if (ACS_Player_Scale() > 1)
	{
		dist += ACS_Player_Scale() * 0.75;
	}
	else if (ACS_Player_Scale() < 1)
	{
		dist -= ACS_Player_Scale() * 0.5;
	}

	FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999 );
	for( i = targets.Size()-1; i >= 0; i -= 1 ) 
	{	
		targetPos = targets[i].GetWorldPosition();
		if ( AbsF( targetPos.Z - pos.Z ) > 2.5 )
		{
			targets.EraseFast(i);
		}
	}	

	return targets;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Main Settings

function ACS_Load_Sound()
{
	if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
	{
		theSound.SoundLoadBank( "magic_caranthil.bnk", false );
	}
		
	if ( !theSound.SoundIsBankLoaded("magic_olgierd.bnk") )
	{
		theSound.SoundLoadBank( "magic_olgierd.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
	{
		theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_bruxa.bnk") )
	{
		theSound.SoundLoadBank( "monster_bruxa.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("magic_eredin.bnk") )
	{
		theSound.SoundLoadBank( "magic_eredin.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("magic_imlerith.bnk") )
	{
		theSound.SoundLoadBank( "magic_imlerith.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_dettlaff_vampire.bnk") )
	{
		theSound.SoundLoadBank( "monster_dettlaff_vampire.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_caretaker.bnk") )
	{
		theSound.SoundLoadBank( "monster_caretaker.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("grunt_vo_wild_hunt.bnk") )
	{
		theSound.SoundLoadBank( "grunt_vo_wild_hunt.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("grunt_vo_sentry_male.bnk") )
	{
		theSound.SoundLoadBank( "grunt_vo_sentry_male.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_cloud_giant.bnk") )
	{
		theSound.SoundLoadBank( "monster_cloud_giant.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_knight_giant.bnk") )
	{
		theSound.SoundLoadBank( "monster_knight_giant.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_yennefer.bnk") )
	{
		theSound.SoundLoadBank( "magic_yennefer.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("fx_fire.bnk") )
	{
		theSound.SoundLoadBank( "fx_fire.bnk", true );
	}

	if ( !theSound.SoundIsBankLoaded("qu_ep1_601.bnk") )
	{
		theSound.SoundLoadBank( "qu_ep1_601.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_man_mage.bnk") )
	{
		theSound.SoundLoadBank( "magic_man_mage.bnk", false );
	}
}

function ACS_Enabled(): bool 
{
  if (ACS_ModEnabled() && !thePlayer.IsCiri())
  {
	return true;
  }
  else
  {
	return false;
  }
}

function ACS_ModEnabled(): bool 
{
  return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodEnabled');
}

function ACS_Init_Attempt()
{
	if (!ACS_IsInitialized()) 
	{
      ACS_InitializeSettings();
	  ACS_DisplayWelcomeMessage();
    }

	if (!ACS_SizeIsInitialized())
	{
		theGame.GetInGameConfigWrapper().SetVarValue('ACSmodMain', 'ACSmodSizeInit', "1");

		theGame.GetInGameConfigWrapper().SetVarValue('ACSmodMain', 'ACSmodPlayerScale', "1");

		theGame.SaveUserSettings();
	}
}

function ACS_InitNotification() 
{
	theGame.GetGuiManager().ShowNotification(GetLocStringByKey("ACS_initialized"));
}

function ACS_DisplayWelcomeMessage() 
{
	var msg						: W3TutorialPopupData;
	var WelcomeTitle			: string;
	var WelcomeMessage			: string;

	WelcomeTitle = "Advanced Combat System";

	WelcomeMessage = "Thank you for installing " + GetLocStringByKey("advanced_combat_system_title") + "!<br/> <br/>Settings have been initialized, and can be further customized in the " + GetLocStringByKey("advanced_combat_system_title") + " mods menu.<br/> <br/>For detailed explanations of abilities, please read through the Github page for more information, or reach out to me in the " + GetLocStringByKey("wolven_workshop") + ". <br/> <br/>I may or may not reply.";

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = WelcomeTitle;

	msg.imagePath = "";

	msg.messageText = WelcomeMessage;

	msg.enableGlossoryLink = false;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	msg.blockInput = true;

	msg.fullscreen = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_IsInitialized(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodInit');
}

function ACS_SizeIsInitialized(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodSizeInit');
}

function ACS_InitializeSettings() 
{
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMain', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodArmigerModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodFocusModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMovementSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodHybridModeSettings', 0);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodTauntSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodSpecialAbilitiesSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodDamageSettings', 0);

	theGame.SaveUserSettings();
}

function ACS_GetWeaponMode(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodWeaponMode'));
}

function ACS_StaminaBlockAction_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodStaminaBlockAction');
}

function ACS_OnHitEffects_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodOnHitEffects');
}

function ACS_ElementalRend_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodElementalRend');
}

function ACS_HideSwordsheathes_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodHideSwordsheathes');
}

function ACS_VampireSoundEffects_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodVampireSoundEffects');
}

function ACS_ExperimentalDismemberment_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodExperimentalDismemberment');
}

function ACS_GetFistMode(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodFistMode'));
}

function ACS_GetTargetMode(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodTargetMode'));
}

function ACS_AutoFinisher_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodAutoFinisherEnabled');
}

function ACS_ShadowsSpawnChancesNormal(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodShadowsSpawnChancesNormal'));
}

function ACS_DisableAutomaticSwordSheathe_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'DisableAutomaticSwordSheathe');
}

function ACS_ComboMode(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodComboMode'));
}

function ACS_SwordWalk_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodSwordWalkEnabled');
}

function ACS_Player_Scale(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodPlayerScale'));
}

// Armiger Mode

function ACS_GetArmigerModeWeaponType(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerModeWeaponType'));
}

function ACS_Armiger_Axii_Set_Sign_Weapon_Type(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerAxiiSignWeapon'));
}

function ACS_Armiger_Aard_Set_Sign_Weapon_Type(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerAardSignWeapon'));
}

function ACS_Armiger_Yrden_Set_Sign_Weapon_Type(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerYrdenSignWeapon'));
}

function ACS_Armiger_Quen_Set_Sign_Weapon_Type(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerQuenSignWeapon'));
}

function ACS_Armiger_Igni_Set_Sign_Weapon_Type(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodArmigerModeSettings', 'ACSmodArmigerIgniSignWeapon'));
}

// Focus Mode

function ACS_GetFocusModeSilverWeapon(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodFocusModeSettings', 'ACSmodFocusModeSilverWeapon'));
}

function ACS_GetFocusModeSteelWeapon(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodFocusModeSettings', 'ACSmodFocusModeSteelWeapon'));
}

function ACS_GetFocusModeWeaponType(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodFocusModeSettings', 'ACSmodFocusModeWeaponType'));
}

// Hybrid Mode

function ACS_GetHybridModeWeaponType(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeWeaponType'));
}

function ACS_GetHybridModeLightAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeLightAttack'));
}

function ACS_GetHybridModeForwardLightAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeForwardLightAttack'));
}

function ACS_GetHybridModeHeavyAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeHeavyAttack'));
}

function ACS_GetHybridModeForwardHeavyAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeForwardHeavyAttack'));
}

function ACS_GetHybridModeSpecialAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeSpecialAttack'));
}

function ACS_GetHybridModeForwardSpecialAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeForwardSpecialAttack'));
}

function ACS_GetHybridModeCounterAttack(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodHybridModeSettings', 'ACSmodHybridModeCounterAttack'));
}

// Misc Settings

function ACS_TauntSystem_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodTauntSettings', 'ACSmodTauntSystemEnabled');
}

function ACS_IWannaPlayGwent_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodTauntSettings', 'ACSmodIWannaPlayGwentEnabled');
}

function ACS_CombatTaunt_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodTauntSettings', 'ACSmodCombatTauntEnabled');
}

// Movement

function ACS_JumpExtend_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtend');
}

function ACS_JumpExtend_Effect_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtendEffect');
}

function ACS_Normal_JumpExtend_GetHeight(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtendNormalHeight'));
}

function ACS_Normal_JumpExtend_GetDistance(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtendNormalDistance'));
}

function ACS_Sprinting_JumpExtend_GetHeight(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtendSprintingHeight'));
}

function ACS_Sprinting_JumpExtend_GetDistance(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodJumpExtendSprintingDistance'));
}

function ACS_BruxaDash_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDash');
}

function ACS_BruxaDashInput(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDashInput'));
}

function ACS_BruxaDash_Normal_Distance(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDashNormalDistance'));
}

function ACS_BruxaDash_Combat_Distance(): int
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDashCombatDistance'));
}

function ACS_BruxaLeapAttack_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaLeapAttack');
}

function ACS_BruxaDodgeSlideBack_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDodgeSlideBack');
}

function ACS_BruxaDodgeCenter_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDodgeCenter');
}

function ACS_BruxaDodgeLeft_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDodgeLeft');
}

function ACS_BruxaDodgeRight_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodBruxaDodgeRight');
}

function ACS_WildHuntBlink_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodWildHuntBlink');
}

function ACS_WraithMode_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodWraithMode');
}

function ACS_WraithModeInput(): int 
{
	return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodWraithModeInput'));
}

function ACS_DodgeEffects_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMovementSettings', 'ACSmodDodgeEffects');
}

// Special Abilities

function ACS_SummonedShades_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodSummonedShades');
}

function ACS_BeamAttack_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodBeamAttack');
}

function ACS_SwordArray_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodSwordArray');
}

function ACS_ShieldEntity_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodShieldEntity');
}

function ACS_QuenMonsterSummon_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodQuenMonsterSummon');
}

function ACS_YrdenSkeleSummon_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodYrdenSkeleSummon');
}

function ACS_AardPull_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodAardPull');
}

function ACS_BruxaCamoDecoy_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodBruxaCamoDecoy');
}

function ACS_BruxaBite_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodSpecialAbilitiesSettings', 'ACSmodBruxaBite');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Damage

function ACS_Vampire_Claws_Human_Max_Damage(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodDamageSettings', 'ACSmodVampireClawsHumanMaxDamage'));
}

function ACS_Vampire_Claws_Human_Min_Damage(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodDamageSettings', 'ACSmodVampireClawsHumanMinDamage'));
}

function ACS_Vampire_Claws_Monster_Max_Damage(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodDamageSettings', 'ACSmodVampireClawsMonsterMaxDamage'));
}

function ACS_Vampire_Claws_Monster_Min_Damage(): float
{
	return StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('ACSmodDamageSettings', 'ACSmodVampireClawsMonsterMinDamage'));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SOI_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_050_51');	
}

function ACS_SOI_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_050_51');		
}

function ACS_Warglaives_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_glaives_9897');	
}

function ACS_Warglaives_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_glaives_9897');		
}

function ACS_SCAAR_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_scaar');	
}

function ACS_SCAAR_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_scaar');		
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Eredin_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'q402 Skellige sword 3'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NPC Eredin Swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'q402_item__epic_swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq304_powerful_sword'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'spirit'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'chakram'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'bajinn roh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == '0NPC Wild Hunt sword 1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Eredin_Sword'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Olgierd_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Olgierd Sabre'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 2'
	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'claw sabre'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'jaggat'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'venasolak'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'wrisp'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twinkle'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Katana_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Sakura Flower'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dragon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sorrow'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oathblade'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'catkatana'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Caretaker_Shovel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Steel_FOR_THUNKING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Steel_FOR_SLICING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Claws_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_a' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_b'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_c'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Spear_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Rake'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Rake'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Caranthir_Staff'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Shepherd_Stick'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Greg_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'orkur'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Hammer_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Axe_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Blackjack'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe'
	
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_One_Hand_Axe_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe01'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe02'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe03'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe04'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe05'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe06'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace01'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace02'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Axe'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pickaxe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shovel'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Scythe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Fishingrodx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2hx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'smol baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2h_crafted'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Nazairi_Mace'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scoop'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Small_Blackjack'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Club'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Poker'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hatchet'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Eredin_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_NPC Eredin Swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_q402_item__epic_swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_sq304_powerful_sword'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'soul'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'luani'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'silver roh'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Eredin_Sword_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Olgierd_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'talon sabre'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'serrator'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'hjaven'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'skinner'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Icingdeath'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Katana_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'fishkatana'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Claws_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1_silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_3'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Spear_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Rake'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive_silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Greg_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'maltonge'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Hammer_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
	
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Axe_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe_Silver'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_One_Hand_Axe_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Axe'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pickaxe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Shovel'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Scythe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Fishingrodx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama_silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_VampClaw(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'q702_vampire_gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'q704_vampire_gloves')	
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_VampClaw_Shades(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CloakCheck ( id : SItemUniqueId ) : bool
{
	if 
	(
	thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 2'
	)
	{
		return true; 
	}
	else 
	{
		return false;
	}
}

function ACS_CloakEquippedCheck() : bool
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_CloakCheck(equippedItemsId[i]))
		{
			return true;
		} 	
	}
	
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BuffCheck() : bool
{
	var language : string;
	var audioLanguage : string;

	theGame.GetGameLanguageName(audioLanguage,language);

	if ( thePlayer.HasBuff(EET_HeavyKnockdown) 
	|| thePlayer.HasBuff( EET_Knockdown ) 
	|| thePlayer.HasBuff( EET_Ragdoll ) 
	|| thePlayer.HasBuff( EET_Stagger )
	|| thePlayer.HasBuff( EET_LongStagger )
	|| thePlayer.HasBuff( EET_Pull )
	|| thePlayer.HasBuff( EET_Immobilized )
	|| thePlayer.HasBuff( EET_Hypnotized )
	|| thePlayer.HasBuff( EET_WitchHypnotized )
	|| thePlayer.HasBuff( EET_Blindness )
	|| thePlayer.HasBuff( EET_WraithBlindness )
	|| thePlayer.HasBuff( EET_Frozen )
	|| thePlayer.HasBuff( EET_Paralyzed )
	|| thePlayer.HasBuff( EET_Confusion )
	|| thePlayer.HasBuff( EET_Tangled )
	|| thePlayer.HasBuff( EET_Tornado ) 
	|| (theGame.GetDLCManager().IsDLCAvailable('dlc_geraltsuit')
	|| theGame.GetDLCManager().IsDLCAvailable('dlc_netflixarmor')
	|| theGame.GetDLCManager().IsDLCAvailable('dlc_windcloud')) && ( language == "CN" || language == "ZH" || audioLanguage == "CN" || audioLanguage == "ZH" )
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/*
function ACS_DetachBehavior()
{
	thePlayer.DetachBehavior('Gameplay');
	thePlayer.DetachBehavior( 'aard_primary_beh' );
	thePlayer.DetachBehavior( 'aard_secondary_beh' );
	thePlayer.DetachBehavior( 'axii_primary_beh' );
	thePlayer.DetachBehavior( 'axii_secondary_beh' );
	thePlayer.DetachBehavior( 'yrden_primary_beh' );
	thePlayer.DetachBehavior( 'yrden_secondary_beh' );
	thePlayer.DetachBehavior( 'quen_primary_beh' );
	thePlayer.DetachBehavior( 'quen_secondary_beh' );
	thePlayer.DetachBehavior( 'claw_beh' );
	thePlayer.DetachBehavior( 'acs_bow_beh' );
	thePlayer.DetachBehavior( 'acs_crossbow_beh' );
}
*/

function ACS_ThingsThatShouldBeRemoved_BASE()
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	//GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');

	/*
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}
	*/

	ACS_RemoveStabbedEntities(); ACS_Theft_Prevention_9 ();

	GetACSWatcher().RemoveTimer('ACS_ShootBowMoving'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowStationary'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowToIdle'); 

	GetACSWatcher().PlayBowAnim_Reset();

	GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_attack');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_slideback');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer');

	GetACSWatcher().RemoveTimer('ACS_alive_check');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	thePlayer.ClearAnimationSpeedMultipliers();

	if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

	thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

	thePlayer.SetCanPlayHitAnim(true); 

	thePlayer.EnableCharacterCollisions(true); 
	thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
	thePlayer.SetIsCurrentlyDodging(false);
}

function ACS_ThingsThatShouldBeRemoved()
{
	ACS_ThingsThatShouldBeRemoved_BASE();

	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
	
	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('blood_sucking')
	)
	{
		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_ThingsThatShouldBeRemoved_NoWeaponRespawn()
{
	ACS_ThingsThatShouldBeRemoved_BASE(); ACS_Theft_Prevention_6 ();
	
	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
}

function ACS_ThingsThatShouldBeRemoved_NoBruxaTackleOrPortableAard()
{
	ACS_ThingsThatShouldBeRemoved_BASE(); ACS_Theft_Prevention_6 ();

	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('blood_sucking')
	)
	{
		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_RemoveStabbedEntities()
{
	var actors		    							: array<CActor>;
	var i											: int;

	actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed');
		
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].BreakAttachment();
		actors[i].RemoveTag('ACS_Stabbed');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_PlayerHitEffects()
{
	thePlayer.StopAllEffects(); ACS_Theft_Prevention_9 ();
	
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2 )
	{
		if (thePlayer.HasTag('axii_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('ice_armor_cutscene');
			thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('ice_armor_cutscene');
			thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if ( thePlayer.HasTag('yrden_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('black_trail');
			thePlayer.StopEffect('black_trail');
		}
		else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('hit_lightning');
			thePlayer.StopEffect('hit_lightning');
		}
		else if ( thePlayer.HasTag('aard_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffectSingle('weakened');
		}
		else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffectSingle('weakened');
		}
	}
	else
	{
		if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped' ) )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffectSingle('weakened');
		}
	}
}

function ACS_AttitudeCheck( actor : CActor ) : bool
{
	if ( 
	thePlayer.GetAttitude( actor ) == AIA_Hostile 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Hostile
	|| (actor.IsAttackableByPlayer() && actor.IsTargetableByPlayer()) 
	)
	{
		return true;
	}
	else if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly
	|| !actor.IsAlive()
	|| actor == thePlayer
	)
	{
		return false;
	}
	else
	{
		return false;
	}
}

function ACS_NoDamage (action: W3DamageAction): bool 
{
    if (action.victim == thePlayer) 
	{
        action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
        //action.processedDmg.vitalityDamage -= 1.0;

        return true;
    }

    return false;
}

function ACS_OnTakeDamage(action: W3DamageAction)
{
	var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var settingsA, settingsB, settings_interrupt			: SAnimatedComponentSlotAnimationSettings;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0;
	settings_interrupt.blendOut = 0;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc &&
	( 
	thePlayer.HasTag('aard_sword_equipped') 
	|| thePlayer.HasTag('aard_secondary_sword_equipped') 
	|| thePlayer.HasTag('quen_secondary_sword_equipped') 
	|| thePlayer.HasTag('yrden_sword_equipped') 
	|| thePlayer.HasTag('yrden_secondary_sword_equipped') 
	|| thePlayer.HasTag('vampire_claws_equipped')
	)
	)
	{
		thePlayer.AddTimer( 'RemoveForceFinisher', 0.0, false );

		npc.AddAbility( 'InstantKillImmune' );

		if (!npc.HasAbility('DisableFinishers'))
		{
			npc.AddAbility( 'DisableFinishers', true);
		}

		if (npc.HasAbility('ForceFinisher'))
		{
			npc.RemoveAbility( 'ForceFinisher');
		} 

		npc.SignalGameplayEvent('DisableFinisher');
	}

	if ( playerVictim
	//&& !playerAttacker
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !action.IsDoTDamage()
	&& (thePlayer.IsGuarded() || thePlayer.IsInGuardedState())
	&& !thePlayer.IsPerformingFinisher()
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	&& !thePlayer.IsCurrentlyDodging()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !action.WasDodged()
	&& !thePlayer.IsInFistFightMiniGame() 
	&& !thePlayer.HasTag('ACS_Camo_Active')
	)
	{
		if ( thePlayer.HasTag('vampire_claws_equipped') && action.DealsAnyDamage() && thePlayer.GetStat( BCS_Stamina ) >= thePlayer.GetStatMax( BCS_Stamina ) * 0.05 )
		{
			//if (playerVictim.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01) 

			/*
			if ( action.processedDmg.vitalityDamage >= playerVictim.GetCurrentHealth() )
			{
				if (((CNewNPC)npcAttacker).GetNPCType() == ENGT_Guard)
				{
					if(!thePlayer.IsAlive())
					{
						thePlayer.StopAllEffects();

						thePlayer.ClearAnimationSpeedMultipliers();	
																	
						thePlayer.SetAnimationSpeedMultiplier(0.125 );
																
						GetACSWatcher().AddTimer('ACS_ResetAnimation', 3  , false);

						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
					}
				}
				else 
				{
					if(!thePlayer.IsAlive())
					{
						

						ACS_TauntInit();

						if( RandF() < 0.5 ) 
						{
							if( RandF() < 0.5 ) 
							{ 
								thePlayer.ClearAnimationSpeedMultipliers();	
																		
								thePlayer.SetAnimationSpeedMultiplier(0.25  );
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 2  , false);

								if( RandF() < 0.5 ) 
								{ 
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', settings_interrupt );
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', settings_interrupt );
								}
							}
							else
							{
								if( RandF() < 0.5 ) 
								{ 
									thePlayer.ClearAnimationSpeedMultipliers();	
																		
									thePlayer.SetAnimationSpeedMultiplier(0.25  );
																			
									GetACSWatcher().AddTimer('ACS_ResetAnimation', 5  , false);

									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', settings_interrupt );
								}
								else
								{
									thePlayer.ClearAnimationSpeedMultipliers();	
																		
									thePlayer.SetAnimationSpeedMultiplier(0.125   );
																			
									GetACSWatcher().AddTimer('ACS_ResetAnimation', 5  , false);

									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', settings_interrupt );
								}
							}
						}
						else
						{
							if( RandF() < 0.5 ) 
							{
								thePlayer.StopAllEffects();

								thePlayer.ClearAnimationSpeedMultipliers();	
																			
								thePlayer.SetAnimationSpeedMultiplier(2.5  );
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 2  , false);

								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								thePlayer.ClearAnimationSpeedMultipliers();	
																		
								thePlayer.SetAnimationSpeedMultiplier(0.95 );
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 1  , false);

								if( RandF() < 0.5 ) 
								{ 
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', settings_interrupt );
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', settings_interrupt );
								}
							}
						}
					}
				}
			}
			*/
			//else
			{
				action.SetHitReactionType(0, false);
				action.ClearDamage();
				action.ClearEffects();
				action.SuppressHitSounds();
				action.SetWasDodged();
				action.SetCannotReturnDamage(true);

				ticket = movementAdjustor.GetRequest( 'ACS_Vamp_Claws_Parry_Rotate');
				movementAdjustor.CancelByName( 'ACS_Vamp_Claws_Parry_Rotate' );
				movementAdjustor.CancelAll();
				thePlayer.GetMovingAgentComponent().ResetMoveRequests();
				thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);
				thePlayer.ResetRawPlayerHeading();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Vamp_Claws_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				thePlayer.SetPlayerTarget( npcAttacker );

				thePlayer.SetPlayerCombatTarget( npcAttacker );

				thePlayer.UpdateDisplayTarget( true );

				thePlayer.UpdateLookAtTarget();

				if (thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.5, 1, );
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.05, 1, );
				}
	
				if ( RandF() < 0.5 )
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_01_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', settingsB );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_left_ACS', 'PLAYER_SLOT', settingsB );
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_01_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_02_ACS', 'PLAYER_SLOT', settingsB );
						}
					}
				}
				else
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_01_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', settingsB );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_right_ACS', 'PLAYER_SLOT', settingsB );
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_01_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_02_ACS', 'PLAYER_SLOT', settingsB );
						}
					}
				}
				
				thePlayer.StopEffect('taunt_sparks');
				thePlayer.PlayEffectSingle('taunt_sparks');
			}
		}
		else if ( thePlayer.HasTag('axii_sword_equipped') && thePlayer.GetStat( BCS_Stamina ) >= thePlayer.GetStatMax( BCS_Stamina ) * 0.05 )
		{
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

			if (thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.5, 1, );
			}
			else
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.1, 1, );
			}

			//thePlayer.SetPlayerTarget( npcAttacker );

			//thePlayer.SetPlayerCombatTarget( npcAttacker );

			//thePlayer.UpdateDisplayTarget( true );

			//thePlayer.UpdateLookAtTarget();

			if ( RandF() < 0.5 )
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_01_ACS', 'PLAYER_SLOT', settingsB );
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', settingsB );
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', settingsB );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', settingsB );
					}
				}
			}
			else
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_01_ACS', 'PLAYER_SLOT', settingsB );
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', settingsB );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', settingsB );
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', settingsB );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', settingsB );
					}
				}
			}

			ACS_Shield().PlayEffectSingle('aard_cone_hit');
			ACS_Shield().StopEffect('aard_cone_hit');
		}
		else 
		{
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			/*
			if (
			thePlayer.IsGuarded()
			|| thePlayer.IsInGuardedState()
			)
			{
				thePlayer.SetGuarded(false);
				thePlayer.OnGuardedReleased();	
			}
			*/

			movementAdjustor.RotateTowards( ticket, npcAttacker );
		}
	}

	if ( playerVictim
	//&& !playerAttacker
	&& !action.IsDoTDamage()
	//&& action.DealsAnyDamage() 
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !thePlayer.IsCurrentlyDodging()
	&& !action.WasDodged()
	&& !thePlayer.IsPerformingFinisher()
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	//&& action.DealtDamage()
	&& !thePlayer.IsGuarded()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !thePlayer.IsInGuardedState()
	&& (thePlayer.HasTag('aard_sword_equipped')
	|| thePlayer.HasTag('aard_secondary_sword_equipped')
	|| thePlayer.HasTag('yrden_sword_equipped')
	|| thePlayer.HasTag('yrden_secondary_sword_equipped')
	|| thePlayer.HasTag('quen_secondary_sword_equipped')
	|| thePlayer.HasTag('axii_sword_equipped')
	|| thePlayer.HasTag('axii_secondary_sword_equipped')
	|| thePlayer.HasTag('quen_sword_equipped')
	//|| thePlayer.HasTag('igni_sword_equipped')
	//|| thePlayer.HasTag('igni_secondary_sword_equipped')
	|| ( thePlayer.HasTag('vampire_claws_equipped') && !thePlayer.HasBuff(EET_BlackBlood) ))
	)
	{	
		//if (playerVictim.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01) 
		if ( action.processedDmg.vitalityDamage >= playerVictim.GetCurrentHealth() )
		{
			if (((CNewNPC)npcAttacker).GetNPCType() == ENGT_Guard)
			{
				if(!thePlayer.IsAlive())
				{
					thePlayer.StopAllEffects();

					thePlayer.ClearAnimationSpeedMultipliers();	
																
					thePlayer.SetAnimationSpeedMultiplier(0.125 );
															
					GetACSWatcher().AddTimer('ACS_ResetAnimation', 3  , false);

					GetACSWatcher().Grow_Geralt_Immediate();

					playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
				}
			}
			else 
			{
				if(!thePlayer.IsAlive())
				{
					GetACSWatcher().Grow_Geralt_Immediate();

					/*
					if( RandF() < 0.5 ) 
					{ 
						thePlayer.ClearAnimationSpeedMultipliers();	
																
						thePlayer.SetAnimationSpeedMultiplier(0.25);
																
						GetACSWatcher().AddTimer('ACS_ResetAnimation', 2, false);

						if( RandF() < 0.5 ) 
						{ 
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', settings_interrupt );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', settings_interrupt );
						}
					}
					else
					{
						thePlayer.StopAllEffects();

						thePlayer.ClearAnimationSpeedMultipliers();	
																		
						thePlayer.SetAnimationSpeedMultiplier(0.95);
																
						GetACSWatcher().AddTimer('ACS_ResetAnimation', 1, false);

						if( RandF() < 0.5 ) 
						{ 
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', settings_interrupt );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', settings_interrupt );
						}
					}
					*/

					ACS_TauntInit();

					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{ 
							thePlayer.ClearAnimationSpeedMultipliers();	
																	
							thePlayer.SetAnimationSpeedMultiplier(0.25 );
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 2 , false);

							if( RandF() < 0.5 ) 
							{ 
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', settings_interrupt );
							}
						}
						else
						{
							if( RandF() < 0.5 ) 
							{ 
								thePlayer.ClearAnimationSpeedMultipliers();	
																	
								thePlayer.SetAnimationSpeedMultiplier(0.25 );
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 5 , false);

								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								thePlayer.ClearAnimationSpeedMultipliers();	
																	
								thePlayer.SetAnimationSpeedMultiplier(0.125 );
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 5 , false);

								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							thePlayer.StopAllEffects();

							thePlayer.ClearAnimationSpeedMultipliers();	
																		
							thePlayer.SetAnimationSpeedMultiplier(2.5 );
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 2 , false);

							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
						}
						else
						{
							thePlayer.ClearAnimationSpeedMultipliers();	
																	
							thePlayer.SetAnimationSpeedMultiplier(0.95 );
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 1 , false);

							if( RandF() < 0.5 ) 
							{ 
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
						}
					}
				}
			}
		}
		else
		{					
			if ( npcAttacker.HasTag('ACS_taunted') )
			{
				/*
				if ( thePlayer.HasTag('blood_sucking') )
				{
					thePlayer.RaiseEvent( 'AttackInterrupt' );

					//GetACSWatcher().bruxa_blood_suck_end_actual();
					action.SetHitReactionType(0, false);
					action.ClearDamage();
					action.ClearEffects();
					action.SuppressHitSounds();
					action.SetWasDodged();
					action.SetCannotReturnDamage(true);

					thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage);
					
					ACS_PlayerHitEffects();

					GetACSWatcher().bruxa_blood_suck_end_actual();

					ACS_ThingsThatShouldBeRemoved();
				}
				*/

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				thePlayer.GetMovingAgentComponent().ResetMoveRequests();
				thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);
				thePlayer.ResetRawPlayerHeading();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				GetACSWatcher().Grow_Geralt_Immediate();

				thePlayer.ClearAnimationSpeedMultipliers();	

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				thePlayer.SetPlayerTarget( npcAttacker );

				thePlayer.SetPlayerCombatTarget( npcAttacker );

				thePlayer.UpdateDisplayTarget( true );

				thePlayer.UpdateLookAtTarget();

				thePlayer.RaiseEvent( 'AttackInterrupt' );

				if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Knockdown ) && !playerVictim.HasBuff( EET_Knockdown ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Knockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Drunkenness, npcAttacker, 'acs_HIT_REACTION' ); 							
				}

				ACS_PlayerHitEffects();

				thePlayer.PlayEffectSingle('smoke_explosion');
				thePlayer.StopEffect('smoke_explosion');
			}
			else if ( thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9
			&& thePlayer.GetStat(BCS_Stamina) >= thePlayer.GetStatMax(BCS_Stamina) * 0.5
			&& thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5
			)
			{
				/*
				if ( thePlayer.HasTag('blood_sucking') )
				{
					thePlayer.RaiseEvent( 'AttackInterrupt' );

					//GetACSWatcher().bruxa_blood_suck_end_actual();
					action.SetHitReactionType(0, false);
					action.ClearDamage();
					action.ClearEffects();
					action.SuppressHitSounds();
					action.SetWasDodged();
					action.SetCannotReturnDamage(true);

					thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage);
					
					ACS_PlayerHitEffects();

					GetACSWatcher().bruxa_blood_suck_end_actual();

					ACS_ThingsThatShouldBeRemoved();
				}
				*/
				GetACSWatcher().Grow_Geralt_Immediate();

				thePlayer.ClearAnimationSpeedMultipliers();	
				
				thePlayer.ForceSetStat( BCS_Focus, thePlayer.GetStatMax(BCS_Focus) * 0.25 );

				if( thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
				{
					if( thePlayer.GetInventory().ItemHasTag(item, 'HeavyArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'MediumArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.3;
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'LightArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.4;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				thePlayer.GetMovingAgentComponent().ResetMoveRequests();
				thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);
				thePlayer.ResetRawPlayerHeading();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				ACS_PlayerHitEffects();

				thePlayer.PlayEffectSingle('special_attack_break');
				thePlayer.StopEffect('special_attack_break');

				GetACSWatcher().ACS_Hit_Reaction();
			}
			else
			{
				thePlayer.ClearAnimationSpeedMultipliers();	

				ACS_PlayerHitEffects();

				if( thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Armor, item) && action.IsActionMelee() )
				{
					if( thePlayer.GetInventory().ItemHasTag(item, 'HeavyArmor') )
					{
						if( (RandF() < 0.45) || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.1 ) 
						{
							GetACSWatcher().Grow_Geralt_Immediate();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.325;

							if ( thePlayer.HasTag('vampire_claws_equipped') )
							{
								movementAdjustor.CancelAll();

								GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
									else
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
								}
							}
							else 
							{
								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
								}	
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
								}
							}
						}
						else
						{
							thePlayer.StopEffect('armor_sparks');
							thePlayer.PlayEffectSingle('armor_sparks');

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;

							thePlayer.SoundEvent("grunt_vo_block");
							
							thePlayer.SoundEvent("cmb_play_parry");

							dmg = new W3DamageAction in theGame.damageMgr;
				
							dmg.Initialize(thePlayer, npcAttacker, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
							
							dmg.SetProcessBuffsIfNoDamage(true);
							
							dmg.SetHitReactionType( EHRT_Heavy, true);

							if (npcAttacker.UsesVitality()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Vitality ) * 0.05; 
								
								damageMin = npcAttacker.GetStatMax( BCS_Vitality ) * 0.025; 
							} 
							else if (npcAttacker.UsesEssence()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Essence ) * 0.05; 
								
								damageMin = npcAttacker.GetStatMax( BCS_Essence ) * 0.025; 
							} 

							dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

							dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
								
							theGame.damageMgr.ProcessAction( dmg );
								
							delete dmg;

							//thePlayer.ForceSetStat( BCS_Stamina, (thePlayer.GetStat( BCS_Stamina )) - thePlayer.GetStatMax( BCS_Stamina ) * 0.2 );

							thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.2, 1, );

							npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
						}
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'MediumArmor') )
					{
						if( ( RandF() < 0.65 ) || thePlayer.GetStat( BCS_Stamina )  <= thePlayer.GetStatMax( BCS_Stamina ) * 0.1 ) 
						{
							GetACSWatcher().Grow_Geralt_Immediate();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

							if ( thePlayer.HasTag('vampire_claws_equipped') )
							{
								movementAdjustor.CancelAll();

								GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
									else
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
								}
							}
							else 
							{
								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
								}	
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
								}
							}
						}
						else
						{
							thePlayer.StopEffect('armor_sparks');
							thePlayer.PlayEffectSingle('armor_sparks');

							thePlayer.SoundEvent("grunt_vo_block");

							thePlayer.SoundEvent("cmb_play_parry");

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

							dmg = new W3DamageAction in theGame.damageMgr;
				
							dmg.Initialize(thePlayer, npcAttacker, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
							
							dmg.SetProcessBuffsIfNoDamage(true);
							
							dmg.SetHitReactionType( EHRT_Heavy, true);

							if (npcAttacker.UsesVitality()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Vitality ) * 0.025; 
								
								damageMin = 0; 
							} 
							else if (npcAttacker.UsesEssence()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Essence ) * 0.025; 
								
								damageMin = 0; 
							} 

							dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

							dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
								
							theGame.damageMgr.ProcessAction( dmg );
								
							delete dmg;

							//thePlayer.ForceSetStat( BCS_Stamina, (thePlayer.GetStat( BCS_Stamina )) - thePlayer.GetStatMax( BCS_Stamina ) * 0.15 );

							thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.15, 1, );

							npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
						}
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'LightArmor') )
					{
						if( ( RandF() < 0.85 ) || thePlayer.GetStat( BCS_Stamina )  <= thePlayer.GetStatMax( BCS_Stamina ) * 0.1 ) 
						{
							GetACSWatcher().Grow_Geralt_Immediate();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

							if ( thePlayer.HasTag('vampire_claws_equipped') )
							{
								movementAdjustor.CancelAll();

								GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
									else
									{
										if ( RandF() < 0.45 )
										{
											if ( RandF() < 0.45 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
												}
											}	
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
											}
										}
									}
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
								}
							}
							else 
							{
								if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
											else
											{
												if ( RandF() < 0.5 )
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
												}
												else
												{
													playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
												}
											}
										}	
									}
								}	
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
								}
							}
						}
						else
						{
							thePlayer.StopEffect('armor_sparks');
							thePlayer.PlayEffectSingle('armor_sparks');

							thePlayer.SoundEvent("grunt_vo_block");

							thePlayer.SoundEvent("cmb_play_parry");

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

							dmg = new W3DamageAction in theGame.damageMgr;
				
							dmg.Initialize(thePlayer, npcAttacker, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
							
							dmg.SetProcessBuffsIfNoDamage(true);
							
							dmg.SetHitReactionType( EHRT_Heavy, true);

							if (npcAttacker.UsesVitality()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Vitality ) * 0.01; 
								
								damageMin = 0; 
							} 
							else if (npcAttacker.UsesEssence()) 
							{ 
								damageMax = npcAttacker.GetStatMax( BCS_Essence ) * 0.01; 
								
								damageMin = 0; 
							} 

							dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

							dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
								
							theGame.damageMgr.ProcessAction( dmg );
								
							delete dmg;

							//thePlayer.ForceSetStat( BCS_Stamina, (thePlayer.GetStat( BCS_Stamina )) - thePlayer.GetStatMax( BCS_Stamina ) * 0.15 );

							thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.15, 1, );

							npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
						}
					}
					else
					{
						GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

						if ( thePlayer.HasTag('vampire_claws_equipped') )
						{
							GetACSWatcher().Grow_Geralt_Immediate();

							movementAdjustor.CancelAll();

							GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

							if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
							{
								if ( RandF() < 0.5 )
								{
									if ( RandF() < 0.45 )
									{
										if ( RandF() < 0.45 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
											}
										}	
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
										}
									}
								}
								else
								{
									if ( RandF() < 0.45 )
									{
										if ( RandF() < 0.45 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
											}
										}	
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
										}
									}
								}
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
							}
						}
						else 
						{
							if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
							{
								if ( RandF() < 0.5 )
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
										}
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
											}
										}
									}	
								}
								else
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
										}
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
										else
										{
											if ( RandF() < 0.5 )
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
											}
											else
											{
												playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
											}
										}
									}	
								}
							}	
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
							}
						}
					}
				}
				else
				{
					GetACSWatcher().ACS_Combo_Mode_Reset_Hard();
					
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

					if ( thePlayer.HasTag('vampire_claws_equipped') )
					{
						movementAdjustor.CancelAll();

						GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

						if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
						{
							if ( RandF() < 0.5 )
							{
								if ( RandF() < 0.45 )
								{
									if ( RandF() < 0.45 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
										}
									}	
								}
								else
								{
									if ( RandF() < 0.5 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
									}
								}
							}
							else
							{
								if ( RandF() < 0.45 )
								{
									if ( RandF() < 0.45 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
										}
									}	
								}
								else
								{
									if ( RandF() < 0.5 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
									}
								}
							}
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
						}
					}
					else 
					{
						if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 60, npcAttacker ))
						{
							if ( RandF() < 0.5 )
							{
								if ( RandF() < 0.5 )
								{
									if ( RandF() < 0.5 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
									}
								}
								else
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
										}
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
										}
									}
								}	
							}
							else
							{
								if ( RandF() < 0.5 )
								{
									if ( RandF() < 0.5 )
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
									}
									else
									{
										playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
									}
								}
								else
								{
									if ( RandF() < 0.5 )
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
										}
									}
									else
									{
										if ( RandF() < 0.5 )
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
										}
										else
										{
											playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
										}
									}
								}	
							}
						}	
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
						}
					}
				}
			}
		}	
	}

	if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God')
	&& !action.IsDoTDamage()
	//&& !thePlayer.IsCurrentlyDodging()
	//&& !action.WasDodged()
	//&& !thePlayer.IsGuarded()
	//&& !GetWitcherPlayer().IsAnyQuenActive()
	//&& !thePlayer.IsInGuardedState()
	//&& action.IsActionMelee()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if (thePlayer.IsGuarded()
				&& thePlayer.IsInGuardedState())
				{
					if (!npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Guarded')
					&& !npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Guarded')
					)
					{
						npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Guarded');

						npcAttacker.AddTag('ACS_Forest_God_2nd_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Forest_God_2nd_Hit_Melee_Guarded');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}
	
						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
					}
				}
				else
				{
					if (!playerVictim)
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.10 );
					}
					else
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
					}
					
					if (!npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded')
					&& !npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded')
					)
					{
						playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' ); 							

						npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
					}
					else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
					{
						npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
	
						playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' ); 							

						npcAttacker.AddTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded');
					}
					else if (npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded'))
					{
						npcAttacker.RemoveTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}

						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
					}
				}
			}
		}
		else
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

				playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
	
	if ( playerAttacker 
	&& !action.IsDoTDamage() 
	&& action.DealsAnyDamage() 
	&& action.DealtDamage()
	&& !action.WasDodged() )
	{
		/*
		if( action.HasAnyCriticalEffect() 
		|| action.GetIsHeadShot() 
		|| action.HasForceExplosionDismemberment()
		|| action.IsCriticalHit() )
		{
			ACS_Heavy_Attack_trail();
		}
		*/
		if (npc.HasAbility('mon_rotfiend')||npc.HasAbility('mon_rotfiend_large')){npc.AddAbility('OneShotImmune');}

		if ( npc.HasTag('ACS_Forest_God') )
		{
			if (GetWitcherPlayer().IsAnyQuenActive())
			{
				//GetWitcherPlayer().FinishQuen(false);
			}

			if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.5)
			&& !npc.HasTag('ACS_Spawn_Adds_1'))
			{
				ACS_Forest_God_Adds_1_Spawner();

				npc.AddTag('ACS_Spawn_Adds_1');
			}
			else if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.25 )
			&& !npc.HasTag('ACS_Spawn_Adds_2'))
			{
				ACS_Forest_God_Adds_2_Spawner();

				npc.AddTag('ACS_Spawn_Adds_2');
			} 

			//thePlayer.StopEffect('critical_poison');
			//thePlayer.PlayEffectSingle('critical_poison');
		}

		ACS_Caretaker_Drain_Energy();

		if (thePlayer.CanUseSkill(S_Sword_s01) && action.GetHitReactionType() != EHRT_Reflect)
		{
			npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

			npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

			npc.ForceSetStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) + npc.GetStatMax( BCS_Stamina ) * 0.5 );
		}

		if( playerAttacker.HasAbility('Runeword 2 _Stats', true)
		||  thePlayer.HasTag('ACS_Shielded_Entity') )
		{
			ACS_Light_Attack_Extended_Trail();
		}
		
		if ( action.GetHitReactionType() == EHRT_Light )
		{
			ACS_Light_Attack_Trail();

			if (thePlayer.IsDeadlySwordHeld())
			{
				if ( thePlayer.HasTag('ACS_Storm_Spear_Active') )
				{
					thePlayer.SoundEvent("magic_man_sand_gust");
				}
				else
				{
					thePlayer.SoundEvent("cmb_play_hit_light");
				}
			}
		}
		else if ( action.GetHitReactionType() == EHRT_Heavy )
		{
			ACS_Heavy_Attack_Trail();
			
			if (thePlayer.IsDeadlySwordHeld())
			{
				if ( thePlayer.HasTag('ACS_Storm_Spear_Active') )
				{
					thePlayer.SoundEvent("magic_man_sand_gust");
				}
				else
				{
					thePlayer.SoundEvent("cmb_play_hit_heavy");
				}
			}
		}
		
		if ( action.HasAnyCriticalEffect() 
		|| action.GetIsHeadShot() 
		|| action.HasForceExplosionDismemberment()
		|| action.IsCriticalHit() )
		{
			ACS_Fast_Attack_Buff();

			ACS_Fast_Attack_Buff_Hit();
		}

		if (npc.HasAbility( 'ForceHeadbuttFinisher' ))
		{
			npc.RemoveAbility('ForceHeadbuttFinisher');
		}

		if (npc.HasAbility( 'ForceHiltFinisher' ))
		{
			npc.RemoveAbility('ForceHiltFinisher');
		}

		if (
		thePlayer.HasTag('aard_sword_equipped')
		|| thePlayer.HasTag('aard_secondary_sword_equipped')
		|| thePlayer.HasTag('yrden_sword_equipped')
		|| thePlayer.HasTag('yrden_secondary_sword_equipped')
		|| thePlayer.HasTag('quen_secondary_sword_equipped')
		|| thePlayer.HasTag('vampire_claws_equipped')
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (GetACSWatcher().combo_counter_damage * 0.1);
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (GetACSWatcher().combo_counter_damage * 0.1);
			}

			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15)
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
			}

			if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
				}

				action.SetCanPlayHitParticle(false);
				action.SetSuppressHitSounds(true);
				action.SuppressHitSounds();
			}

			npc.AddAbility( 'InstantKillImmune' );

			npc.SignalGameplayEvent('DisableFinisher');

			if (thePlayer.HasTag('ACS_AardPull_Active'))
			{
				thePlayer.GainStat( BCS_Stamina, thePlayer.GetStatMax( BCS_Stamina ) * 0.1 );
			}

			if (npc.IsHuman())
			{
				if (!npc.HasAbility('DisableFinishers'))
				{
					npc.AddAbility( 'DisableFinishers', true);
				}
				
				if (!npc.HasAbility('ForceDismemberment'))
				{
					npc.AddAbility( 'ForceDismemberment', true);
				}
				
				npc.PlayHitEffect( action );
				
				if (
				(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
				&& npc.HasTag('ACS_taunted')
				)
				{
					npc.PlayEffectSingle('pee');	
					npc.StopEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffectSingle('puke');
					
					if (!npc.HasTag('ACS_mettle'))
					{
						if( RandF() < 0.5 ) 
						{
							((CNewNPC)npc).SetLevel( thePlayer.GetLevel() * 2 );
							
							// npc.AddEffectDefault( EET_Bleeding, thePlayer, 'acs_weapon_effects' );	
							
							npc.AddTag('ContractTarget');
							npc.AddTag('MonsterHuntTarget');
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
							
							npc.RemoveBuffImmunity_AllNegative();

							npc.RemoveBuffImmunity_AllCritical();

							if (npc.UsesEssence())
							{
								npc.StartEssenceRegen();
							}
							else
							{
								npc.StartVitalityRegen();
							}
								
							if ( !npc.HasBuff( EET_IgnorePain ) )
							{
								npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellFed ) )
							{
								npc.AddEffectDefault( EET_WellFed, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellHydrated ) )
							{
								npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
							{
								npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
							}
							
							if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
							{
								npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoPanicRegen ) )
							{
								npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
							{
								npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WeatherBonus ) )
							{
								npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_Thunderbolt ) )
							{
								npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
							{
								npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedArmor ) )
							{
								npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedWeapon ) )
							{
								npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
							}
						}
						else
						{	
							//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );	

							//npc.GetComponent("Finish").SetEnabled( true );
					
							//npc.SignalGameplayEvent( 'Finisher' );
						}
						
						npc.AddTag('ACS_mettle');
					}
				}
			}
		}
		else if ( 
		thePlayer.HasTag('axii_sword_equipped')
		|| thePlayer.HasTag('axii_secondary_sword_equipped')
		|| thePlayer.HasTag('quen_sword_equipped'))
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (GetACSWatcher().combo_counter_damage * 0.1);
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (GetACSWatcher().combo_counter_damage * 0.1);
			}
			
			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15)
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
			}

			if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
				}

				action.SetCanPlayHitParticle(false);
				action.SetSuppressHitSounds(true);
				action.SuppressHitSounds();
			}

			if (npc.IsHuman())
			{
				if (!npc.HasAbility('ForceDismemberment'))
				{
					npc.AddAbility( 'ForceDismemberment', true);
				}
				
				if (npc.HasAbility('DisableFinishers'))
				{
					npc.RemoveAbility( 'DisableFinishers');
				}
				
				npc.PlayHitEffect( action );
				
				if (
				(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
				&& npc.HasTag('ACS_taunted')
				)
				{	
					npc.PlayEffectSingle('pee');	
					npc.StopEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffectSingle('puke');
					
					if (!npc.HasTag('ACS_mettle'))
					{
						if( RandF() < 0.5 ) 
						{
							((CNewNPC)npc).SetLevel( thePlayer.GetLevel() * 2 );
							
							npc.AddTag('ContractTarget');
							npc.AddTag('MonsterHuntTarget');
							
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
							
							npc.RemoveBuffImmunity_AllNegative();

							npc.RemoveBuffImmunity_AllCritical();

							if (npc.UsesEssence())
							{
								npc.StartEssenceRegen();
							}
							else
							{
								npc.StartVitalityRegen();
							}
								
							if ( !npc.HasBuff( EET_IgnorePain ) )
							{
								npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellFed ) )
							{
								npc.AddEffectDefault( EET_WellFed, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellHydrated ) )
							{
								npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
							{
								npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
							}
							
							if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
							{
								npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoPanicRegen ) )
							{
								npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
							{
								npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WeatherBonus ) )
							{
								npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_Thunderbolt ) )
							{
								npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
							{
								npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedArmor ) )
							{
								npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedWeapon ) )
							{
								npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
							}
						}
						else
						{	
							//npc.AddEffectDefault( EET_Paralyzed, thePlayer, 'acs_weapon_effects' );	
							
							//npc.AddEffectDefault( EET_Bleeding, thePlayer, 'acs_weapon_effects' );	
							
							//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );

							//npc.GetComponent("Finish").SetEnabled( true );
					
							//npc.SignalGameplayEvent( 'Finisher' );
						}
						
						npc.AddTag('ACS_mettle');
					}
				}
			}
		}
		else if 
		(
		thePlayer.HasTag('igni_sword_equipped')
		|| thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if (npc.IsHuman())
			{
				if (npc.HasAbility('ForceDismemberment'))
				{
					npc.RemoveAbility( 'ForceDismemberment');
				}
				
				if (npc.HasAbility('DisableFinishers'))
				{
					npc.RemoveAbility( 'DisableFinishers');
				}
				
				if (
				(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
				&& npc.HasTag('ACS_taunted')
				)
				{	
					npc.PlayEffectSingle('pee');	
					npc.StopEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffectSingle('puke');
					
					if (!npc.HasTag('ACS_mettle'))
					{
						if( RandF() < 0.5 ) 
						{
							((CNewNPC)npc).SetLevel( (thePlayer.GetLevel() * 7 ) / 4 );
							
							npc.AddTag('ContractTarget');
							npc.AddTag('MonsterHuntTarget');
							
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
							
							npc.RemoveBuffImmunity_AllNegative();

							npc.RemoveBuffImmunity_AllCritical();

							if (npc.UsesEssence())
							{
								npc.StartEssenceRegen();
							}
							else
							{
								npc.StartVitalityRegen();
							}
								
							if ( !npc.HasBuff( EET_IgnorePain ) )
							{
								npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellFed ) )
							{
								npc.AddEffectDefault( EET_WellFed, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WellHydrated ) )
							{
								npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
							{
								npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
							}
							
							if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
							{
								npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoPanicRegen ) )
							{
								npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
							{
								npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
							{
								npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_WeatherBonus ) )
							{
								npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_Thunderbolt ) )
							{
								npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
							{
								npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedArmor ) )
							{
								npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
							}
								
							if ( !npc.HasBuff( EET_EnhancedWeapon ) )
							{
								npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
							}
						}
						else
						{	
							//npc.AddEffectDefault( EET_Paralyzed, thePlayer, 'acs_weapon_effects' );	
							
							//npc.AddEffectDefault( EET_Bleeding, thePlayer, 'acs_weapon_effects' );	
							
							//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );

							//npc.GetComponent("Finish").SetEnabled( true );
					
							//npc.SignalGameplayEvent( 'Finisher' );
						}
						
						npc.AddTag('ACS_mettle');
					}
				}
			}
		}
	}
}

function ACS_NoticeboardCheck (radius_check: float): bool 
{
    var entities: array<CGameplayEntity>;

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 1, , FLAG_ExcludePlayer, , 'W3NoticeBoard');

    return entities.Size()>0;
}
  
function ACS_GuardCheck (radius_check: float): bool 
{
	var entities: array<CGameplayEntity>;

    var i: int;

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 100, , FLAG_ExcludePlayer, , 'CNewNPC');

    for (i = 0; i<entities.Size(); i += 1) 
	{
		if (((CNewNPC)(entities[i])).GetNPCType()==ENGT_Guard) 
		{
			return true;
		}
	}

	return false;
}

function ACS_PlayerSettlementCheck (optional radius_check: float): bool 
{
	var current_area: EAreaName;

	if ( radius_check <= 0 ) 
	{
      radius_check = 50;
    }
    
    current_area = theGame.GetCommonMapManager().GetCurrentArea();

    if ( ACS_NoticeboardCheck( radius_check ) ) 
	{
      return true;
    }
    
    if ( current_area == AN_Skellige_ArdSkellig ) 
	{
      return ACS_GuardCheck( radius_check );
    }
    
    return thePlayer.IsInSettlement() || ACS_GuardCheck (radius_check);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_StartAerondightEffectInit()
{
	var vStartAerondightEffect : cStartAerondightEffect;
	vStartAerondightEffect = new cStartAerondightEffect in theGame;
			
	vStartAerondightEffect.Engage();
}

statemachine class cStartAerondightEffect
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cStartAerondightEffect
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		StartAerondightEffects();
	}
	
	entry function StartAerondightEffects()
	{
		var l_aerondightEnt			: CItemEntity;
		var l_effectComponent		: W3AerondightFXComponent;
		var l_newChargingEffect		: name;
		var m_maxCount					: int;
		
		thePlayer.GetInventory().GetCurrentlyHeldSwordEntity( l_aerondightEnt );
		
		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			l_newChargingEffect = l_effectComponent.m_visualEffects[ m_maxCount - 1 ];
			
			l_aerondightEnt.PlayEffectSingle( l_newChargingEffect );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_SCAAR_1_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_geraltsuit');	
}

function ACS_SCAAR_2_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_netflixarmor');	
}

function ACS_SCAAR_3_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_windcloud');	
}

function ACS_Theft_Prevention_7()
{
	var language : string;
	var audioLanguage : string;

	theGame.GetGameLanguageName(audioLanguage,language);

	if (
	(ACS_SCAAR_1_Installed()
	|| ACS_SCAAR_2_Installed()
	|| ACS_SCAAR_3_Installed())
	&& ( language == "CN" || language == "ZH" || audioLanguage == "CN" || audioLanguage == "ZH" )
	)
	{
		theGame.ChangePlayer( "Goodbye" );
	}
}

function ACS_StopAerondightEffectInit()
{
	var vStopAerondightEffect : cStopAerondightEffect;
	vStopAerondightEffect = new cStopAerondightEffect in theGame;
			
	vStopAerondightEffect.Engage();
}

statemachine class cStopAerondightEffect
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cStopAerondightEffect
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		StopAerondightEffects();
	}
	
	entry function StopAerondightEffects()
	{
		var l_aerondightEnt			: CItemEntity;
		
		thePlayer.GetInventory().GetCurrentlyHeldSwordEntity( l_aerondightEnt );	
		
		if (thePlayer.HasTag('aard_sword_equipped'))
		{
			l_aerondightEnt.StopAllEffects();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_SCAAR_4_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_geraltsuit');	
}

function ACS_SCAAR_5_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_netflixarmor');	
}

function ACS_SCAAR_6_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_windcloud');	
}

function ACS_Theft_Prevention_6()
{
	var language : string;
	var audioLanguage : string;

	theGame.GetGameLanguageName(audioLanguage,language);

	if (
	(ACS_SCAAR_1_Installed()
	|| ACS_SCAAR_2_Installed()
	|| ACS_SCAAR_3_Installed())
	&& ( language == "CN" || language == "ZH" || audioLanguage == "CN" || audioLanguage == "ZH" )
	)
	{
		theGame.ChangePlayer( "Goodbye" );
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ExplorationDelayHack()
{
	if( !thePlayer.IsInCombat() )
	{
		if ( thePlayer.GetCurrentStateName() != 'Combat' )
		{
			thePlayer.GotoState('Combat');
		}

		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}
	}

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);
}

function ACS_ExplorationDelay_actual()
{
	if (!thePlayer.IsInCombat() && thePlayer.HasTag('vampire_claws_equipped'))
	{
		thePlayer.PlayEffectSingle('claws_effect');
		thePlayer.StopEffect('claws_effect');

		ClawDestroy();
	}

	thePlayer.RemoveTag('ACS_ExplorationDelayTag');
}

function ACS_CombatToExplorationCheck() : bool
{
	if ( thePlayer.HasTag('ACS_ExplorationDelayTag') || thePlayer.IsGuarded() )
	{
		return false;
	}
	else
	{
		return true;
	}	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Setup_Combat_Action_Light()
{
	var vACS_Setup_Combat_Action_Light : cACS_Setup_Combat_Action_Light;
	vACS_Setup_Combat_Action_Light = new cACS_Setup_Combat_Action_Light in theGame;

	vACS_Setup_Combat_Action_Light.Setup_Combat_Action_Light_Engage();
}

statemachine class cACS_Setup_Combat_Action_Light
{
    function Setup_Combat_Action_Light_Engage()
	{
		this.PushState('Setup_Combat_Action_Light_Engage');
	}
}

state Setup_Combat_Action_Light_Engage in cACS_Setup_Combat_Action_Light
{	
	private var settings_interrupt					: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		Attack_Light_Entry();
	}
	
	entry function Attack_Light_Entry()
	{	
		Attack_Light_Latent();
	}
	
	latent function Attack_Light_Latent()
	{
		settings_interrupt.blendIn = 1;
		settings_interrupt.blendOut = 1;

		if( thePlayer.IsInCombat() )
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

			Sleep(0.0125);
		}

		thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


function ACS_Setup_Combat_Action_Heavy()
{
	var vACS_Setup_Combat_Action_Heavy : cACS_Setup_Combat_Action_Heavy;
	vACS_Setup_Combat_Action_Heavy = new cACS_Setup_Combat_Action_Heavy in theGame;

	vACS_Setup_Combat_Action_Heavy.Setup_Combat_Action_Heavy_Engage();
}

statemachine class cACS_Setup_Combat_Action_Heavy
{
    function Setup_Combat_Action_Heavy_Engage()
	{
		this.PushState('Setup_Combat_Action_Heavy_Engage');
	}
}

state Setup_Combat_Action_Heavy_Engage in cACS_Setup_Combat_Action_Heavy
{	
	private var settings_interrupt					: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		Attack_Heavy_Entry();
	}
	
	entry function Attack_Heavy_Entry()
	{	
		Attack_Heavy_Latent();
	}
	
	latent function Attack_Heavy_Latent()
	{
		settings_interrupt.blendIn = 1;
		settings_interrupt.blendOut = 1;

		if( thePlayer.IsInCombat() )
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

			Sleep(0.0125);
		}

		thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct ACS_Manual_Sword_Drawing_Check 
{
	var manual_sword_drawing	: int;
}

function ACS_Manual_Sword_Drawing_Check_Actual(): int 
{
	var property: ACS_Manual_Sword_Drawing_Check;

	property = GetACSWatcher().vACS_Manual_Sword_Drawing_Check;

	return property.manual_sword_drawing;
}

struct ACS_Forest_God_Shadows_Spawning_Check 
{
	var last_forest_god_shadow_spawn_time : float;
	var forest_god_shadow_cooldown	: float;

	default forest_god_shadow_cooldown = 420;
}

function ACS_can_spawn_forest_god_shadows(): bool 
{
	var property: ACS_Forest_God_Shadows_Spawning_Check;

	property = GetACSWatcher().vACS_Forest_God_Shadows_Spawning_Check;

	return theGame.GetEngineTimeAsSeconds() - property.last_forest_god_shadow_spawn_time > property.forest_god_shadow_cooldown;
}

function ACS_refresh_forest_god_shadows_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Forest_God_Shadows_Spawning_Check.last_forest_god_shadow_spawn_time = theGame.GetEngineTimeAsSeconds();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSWatcher() : W3ACSWatcher
{
	var watcher 			 : W3ACSWatcher;
	
	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	return watcher;
}

quest function modStartACS() 
{
	var entity						: CEntity;
	var template					: CEntityTemplate;
	var ACSWatcherSpawner			: W3ACSWatcherSpawner;

	template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\ACS_Mordor.w2ent", true);

	if ( !theGame.GetEntityByTag('acswatcherspawner') )
	{
		entity = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
	}

	ACSWatcherSpawner = (W3ACSWatcherSpawner)entity;
    ACSWatcherSpawner.ACSFactsStuff();
}

quest function modIsACSStarted() : bool
{
	return FactsQuerySum("acs_started") > 0;
}

statemachine class W3ACSWatcherSpawner extends CEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('waitForPlayer', 0.00001f , true);
		CreateAttachment ( thePlayer );
	}
	
	timer function waitForPlayer( deltaTime : float , id : int)
	{	
		if ( GetWitcherPlayer() )
		{
			if ( !GetACSWatcher() )
			{
				ACS_Watcher_Summon();
				RemoveTimer( 'waitForPlayer' );
				this.Destroy();
			}
		}
	}

	public function ACSFactsStuff() 
	{
    	FactsRemove("acs_started");
   		FactsAdd("acs_started", 1);
    }
}

function ACS_Watcher_Summon()
{
	var ent : CEntity;

	ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\ACS_Baraddur.w2ent", true ), thePlayer.GetWorldPosition() );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function aniplay(animation_name: name)
{
	thePlayer.ActionPlaySlotAnimationAsync('PLAYER_SLOT',animation_name, 0.1, 1, false);
}

exec function aniplay1(animation_name: name)
{
	var sett 									: SAnimatedComponentSlotAnimationSettings;
	
	sett.blendIn = 0.2f;
	sett.blendOut = 0.5f;
		
	thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( animation_name, 'PLAYER_SLOT', sett );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function acsspawn( entity_name: name)
{
	if (entity_name == 'forest_god')
	{
		ACS_Forest_God_Spawner();
	}
	else if (entity_name == 'ent')
	{
		ACS_Spawner();
	}
	else if (entity_name == 'shadows')
	{
		ACS_Forest_God_Shadows_Spawner();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Forest_God_Static_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

	ACS_Forest_God().Destroy();

	vACS_Forest_God_Spawner.ACS_Forest_God_Static_Spawner_Engage();
}

function ACS_Forest_God_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;
	
	ACS_Forest_God().Destroy();

	vACS_Forest_God_Spawner.ACS_Forest_God_Spawner_Engage();
}

function ACS_Forest_God_Adds_1_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

	vACS_Forest_God_Spawner.ACS_Forest_God_Adds_1_Spawner_Engage();
}

function ACS_Forest_God_Adds_2_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

	vACS_Forest_God_Spawner.ACS_Forest_God_Adds_2_Spawner_Engage();
}

function ACS_Forest_God_Shadows_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;
	
	vACS_Forest_God_Spawner.ACS_Forest_God_Shadows_Spawner_Engage();
}

statemachine class cACS_Forest_God_Spawner
{
    function ACS_Forest_God_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Spawner_Engage');
	}

	function ACS_Forest_God_Static_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Static_Spawner_Engage');
	}

	function ACS_Forest_God_Adds_1_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Adds_1_Spawner_Engage');
	}

	function ACS_Forest_God_Adds_2_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Adds_2_Spawner_Engage');
	}

	function ACS_Forest_God_Shadows_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Shadows_Spawner_Engage');
	}
}

state ACS_Forest_God_Shadows_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Shadows_Entry();
	}
	
	entry function Spawn_Shadows_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Shadows_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Shadows_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\treant.w2ent"
			
		, true );

		playerPos = thePlayer.GetWorldPosition();
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 0.75;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 3 );
			((CActor)ent).GetInventory().AddAnItem( 'Leshy mutagen', 1 );

			((CNewNPC)ent).SetLevel( thePlayer.GetLevel() / 2 );
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.25);
			ent.AddTag( 'ACS_Forest_God_Shadows' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Adds_1_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Adds_1_Entry();
	}
	
	entry function Spawn_Adds_1_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Adds_1_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Adds_1_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"
			
		, true );

		playerPos = ACS_Forest_God().GetWorldPosition();
		
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );
			((CNewNPC)ent).SetLevel( 5 );
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.25);
			ent.AddTag( 'ACS_Echinops' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Adds_2_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Adds_2_Entry();
	}
	
	entry function Spawn_Adds_2_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Adds_2_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Adds_2_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"
			
		, true );

		playerPos = ACS_Forest_God().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );
			((CNewNPC)ent).SetLevel( 5 );
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.5);
			ent.AddTag( 'ACS_Echinops' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var gasEntity														: W3ToxicCloud;
	private var weapon_names, armor_names										: array<CName>;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		LockEntryFunction(true);
		
		thePlayer.StopEffect('summon');
		thePlayer.PlayEffectSingle('summon');
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}

	function fill_shades_weapons_array()
	{
		weapon_names.Clear();

		weapon_names.PushBack('Shades Steel Claymore 2');
		weapon_names.PushBack('Shades Steel Rakuyo 2');
		weapon_names.PushBack('Shades Steel Graveripper 2');
		weapon_names.PushBack('Shades Steel Kukri 2');
		weapon_names.PushBack('Shades Steel a123 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Steel Hades Grasp 2');
		weapon_names.PushBack('Shades Steel Icarus Tears 2');
		weapon_names.PushBack('Shades Steel Kingslayer 2');
		weapon_names.PushBack('Shades Steel Vulcan 2');
		weapon_names.PushBack('Shades Steel Flameborn 2');
		weapon_names.PushBack('Shades Steel Frostmourne 2');
		weapon_names.PushBack('Shades Steel Oblivion 2');
		weapon_names.PushBack('Shades Steel Sinner 2');
		weapon_names.PushBack('Shades Steel Bloodletter 2');
		weapon_names.PushBack('Shades Steel Ares 2');
		weapon_names.PushBack('Shades Steel Voidblade 2');
		weapon_names.PushBack('Shades Steel Bloodshot 2');
		weapon_names.PushBack('Shades Steel Eagle Sword 2');
		weapon_names.PushBack('Shades Steel Lion Sword 2');
		weapon_names.PushBack('Shades Steel Pridefall 2');
		weapon_names.PushBack('Shades Steel Haoma 2');
		weapon_names.PushBack('Shades Steel Cursed Khopesh 2');
		weapon_names.PushBack('Shades Steel Sithis Blade 2');
		weapon_names.PushBack('Shades Steel Ejderblade 2');
		weapon_names.PushBack('Shades Steel Dragonbane 2');
		weapon_names.PushBack('Shades Steel Doomblade 2');
		weapon_names.PushBack('Shades Steel Crownbreaker 2');
		weapon_names.PushBack('Shades Steel Blooddusk 2');
		weapon_names.PushBack('Shades Steel Oathblade 2');
		weapon_names.PushBack('Shades Steel Beastcutter 2');
		weapon_names.PushBack('Shades Steel Hellspire 2');
		weapon_names.PushBack('Shades Steel Heavenspire 2');
		weapon_names.PushBack('Shades Steel Guandao 2');
		weapon_names.PushBack('Shades Steel Hitokiri Katana 2');
		weapon_names.PushBack('Shades Steel Gorgonslayer 2');
		weapon_names.PushBack('Shades Steel Ryu Katana 2');
		weapon_names.PushBack('Shades Steel Blackdawn 2');
		weapon_names.PushBack('Shades Steel Knife 2');
		weapon_names.PushBack('Shades Silver Claymore 2');
		weapon_names.PushBack('Shades Silver Rakuyo 2');
		weapon_names.PushBack('Shades Silver Graveripper 2');
		weapon_names.PushBack('Shades Silver a123 2');
		weapon_names.PushBack('Shades Silver Kukri 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Silver Hades Grasp 2');
		weapon_names.PushBack('Shades Silver Icarus Tears 2');
		weapon_names.PushBack('Shades Silver Kingslayer 2');
		weapon_names.PushBack('Shades Silver Vulcan 2');
		weapon_names.PushBack('Shades Silver Flameborn 2');
		weapon_names.PushBack('Shades Silver Frostmourne 2');
		weapon_names.PushBack('Shades Silver Oblivion 2');
		weapon_names.PushBack('Shades Silver Sinner 2');
		weapon_names.PushBack('Shades Silver Bloodletter 2');
		weapon_names.PushBack('Shades Silver Ares 2');
		weapon_names.PushBack('Shades Silver Voidblade 2');
		weapon_names.PushBack('Shades Silver Bloodshot 2');
		weapon_names.PushBack('Shades Silver Eagle Sword 2');
		weapon_names.PushBack('Shades Silver Lion Sword 2');
		weapon_names.PushBack('Shades Silver Pridefall 2');
		weapon_names.PushBack('Shades Silver Haoma 2');
		weapon_names.PushBack('Shades Silver Cursed Khopesh 2');
		weapon_names.PushBack('Shades Silver Sithis Blade 2');
		weapon_names.PushBack('Shades Silver Ejderblade 2');
		weapon_names.PushBack('Shades Silver Dragonbane 2');
		weapon_names.PushBack('Shades Silver Doomblade 2');
		weapon_names.PushBack('Shades Silver Crownbreaker 2');
		weapon_names.PushBack('Shades Silver Blooddusk 2');
		weapon_names.PushBack('Shades Silver Oathblade 2');
		weapon_names.PushBack('Shades Silver Beastcutter 2');
		weapon_names.PushBack('Shades Silver Hellspire 2');
		weapon_names.PushBack('Shades Silver Heavenspire 2');
		weapon_names.PushBack('Shades Silver Guandao 2');
		weapon_names.PushBack('Shades Silver Hitokiri Katana 2');
		weapon_names.PushBack('Shades Silver Gorgonslayer 2');
		weapon_names.PushBack('Shades Silver Ryu Katana 2');
		weapon_names.PushBack('Shades Silver Blackdawn 2');
		weapon_names.PushBack('Shades Silver Knife 2');
	}

	function fill_shades_armor_arrawy()
	{
		armor_names.Clear();

		armor_names.PushBack('Shades Realmdrifter Armor 2');
		armor_names.PushBack('Shades Realmdrifter Boots 2');
		armor_names.PushBack('Shades Realmdrifter Gloves 2');
		armor_names.PushBack('Shades Realmdrifter Helm');
		armor_names.PushBack('Shades Realmdrifter Pants 2');

		armor_names.PushBack('Shades Omen Armor 3');
		armor_names.PushBack('Shades Omen Boots 3');
		armor_names.PushBack('Shades Omen Gloves 3');
		armor_names.PushBack('Shades Omen Helm');
		armor_names.PushBack('Shades Omen Pants 3');

		armor_names.PushBack('Shades Plunderer Armor 3');
		armor_names.PushBack('Shades Plunderer Boots 3');
		armor_names.PushBack('Shades Plunderer Gloves 3');
		armor_names.PushBack('Shades Plunderer Headwear');
		armor_names.PushBack('Shades Plunderer Hat');
		armor_names.PushBack('Shades Plunderer Mask');
		armor_names.PushBack('Shades Plunderer Pants 3');

		armor_names.PushBack('Shade Plunderer Armor 3');
		armor_names.PushBack('Shade Plunderer Boots 3');
		armor_names.PushBack('Shade Plunderer Gloves 3');
		armor_names.PushBack('Shade Plunderer Headwear');
		armor_names.PushBack('Shade Plunderer Hat');
		armor_names.PushBack('Shade Plunderer Mask');
		armor_names.PushBack('Shade Plunderer Pants 3');
		
		armor_names.PushBack('Shades Oldhunter Armor 2');
		armor_names.PushBack('Shades Oldhunter Boots 2');
		armor_names.PushBack('Shades Oldhunter Gloves 2');
		armor_names.PushBack('Shades Oldhunter Cap');
		armor_names.PushBack('Shades Oldhunter Pants 2');
		
		armor_names.PushBack('Shades Faraam Armor 2');
		armor_names.PushBack('Shades Faraam Boots 2');
		armor_names.PushBack('Shades Faraam Gloves 2');
		armor_names.PushBack('Shades Faraam Helm');
		armor_names.PushBack('Shades Faraam Pants 2');
		
		armor_names.PushBack('Shades Hunter Armor 2');
		armor_names.PushBack('Shades Hunter Boots 2');
		armor_names.PushBack('Shades Hunter Gloves 2');
		armor_names.PushBack('Shades Hunter Hat');
		armor_names.PushBack('Shades Hunter Mask');
		armor_names.PushBack('Shades Hunter Mask and Hat');
		armor_names.PushBack('Shades Hunter Pants 2');
		
		armor_names.PushBack('Shades Yahargul Armor 2');
		armor_names.PushBack('Shades Yahargul Boots 2');
		armor_names.PushBack('Shades Yahargul Gloves 2');
		armor_names.PushBack('Shades Yahargul Helm');
		armor_names.PushBack('Shades Yahargul Pants 2');
		
		armor_names.PushBack('Shades Crow Armor 2');
		armor_names.PushBack('Shades Crow Boots 2');
		armor_names.PushBack('Shades Crow Gloves 2');
		armor_names.PushBack('Shades Crow Mask');
		armor_names.PushBack('Shades Crow Pants 2');
		
		armor_names.PushBack('Shades Sithis Armor 2');
		armor_names.PushBack('Shades Taifeng Boots 2');
		armor_names.PushBack('Shades Taifeng Gloves 2');
		armor_names.PushBack('Shades Sithis Hood');
		armor_names.PushBack('Shades Taifeng Pants 2');
		armor_names.PushBack('Shades Taifeng Armor 2');

		armor_names.PushBack('Shades Kara Armor 2');
		armor_names.PushBack('Shades Kara Boots 2');
		armor_names.PushBack('Shades Kara Gloves 2');
		armor_names.PushBack('Shades Kara Hat');
		armor_names.PushBack('Shades Kara Pants 2');
		
		armor_names.PushBack('Shades Lionhunter Armor 2');
		armor_names.PushBack('Shades Lionhunter Boots 2');
		armor_names.PushBack('Shades Lionhunter Gloves 2');
		armor_names.PushBack('Shades Lionhunter Hat');
		armor_names.PushBack('Shades Lionhunter Pants 2');
		
		armor_names.PushBack('Shades Berserker Armor 2');
		armor_names.PushBack('Shades Berserker Boots 2');
		armor_names.PushBack('Shades Berserker Gloves 2');
		armor_names.PushBack('Shades Berserker Helm');
		armor_names.PushBack('Shades Berserker Pants 2');
		
		armor_names.PushBack('Shades Bismarck Armor 2');
		armor_names.PushBack('Shades Bismarck Boots 2');
		armor_names.PushBack('Shades Bismarck Gloves 2');
		armor_names.PushBack('Shades Bismarck Helm');
		armor_names.PushBack('Shades Bismarck Pants 2');
		
		armor_names.PushBack('Shades Undertaker Armor 2');
		armor_names.PushBack('Shades Undertaker Boots 2');
		armor_names.PushBack('Shades Undertaker Gloves 2');
		armor_names.PushBack('Shades Undertaker Pants 2');
		armor_names.PushBack('Shades Undertaker Mask');
		
		armor_names.PushBack('Shades Ezio Pants 2');
		armor_names.PushBack('Shades Ezio Armor 2');
		armor_names.PushBack('Shades Ezio Boots 2');
		armor_names.PushBack('Shades Ezio Gloves 2');
		armor_names.PushBack('Shades Ezio Hood');
		
		armor_names.PushBack('Shades Headtaker Armor 2');
		armor_names.PushBack('Shades Headtaker Boots 2');
		armor_names.PushBack('Shades Headtaker Gloves 2');
		armor_names.PushBack('Shades Headtaker Pants 2');
		armor_names.PushBack('Shades Headtaker Mask');
		
		armor_names.PushBack('Shades Viper Armor 2');
		armor_names.PushBack('Shades Viper Boots 2');
		armor_names.PushBack('Shades Viper Gloves 2');
		armor_names.PushBack('Shades Viper Mask');
		armor_names.PushBack('Shades Viper Pants 2');
		
		armor_names.PushBack('Shades Ronin Hat');
		armor_names.PushBack('Shades Hitokiri Mask');
		armor_names.PushBack('Shades Warborn Helm');
		armor_names.PushBack('Shades Headtaker Cloak');
		armor_names.PushBack('Shades Genichiro Helm');
	}

	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 
		"dlc\dlc_acs\data\entities\monsters\forest_god.w2ent"
		, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 
		}

		GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

		ACS_ToxicGasSpawner();
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Static_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp, temp2														: CEntityTemplate;
	private var ent, ent2														: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var gasEntity														: W3ToxicCloud;
	private var weapon_names, armor_names										: array<CName>;
	private var currWorld 														: CWorld;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Static_Spawn_Entry();
	}
	
	entry function Static_Spawn_Entry()
	{	
		LockEntryFunction(true);
		
		Static_Spawn_Latent();
		
		LockEntryFunction(false);
	}

	function fill_shades_weapons_array()
	{
		weapon_names.Clear();

		weapon_names.PushBack('Shades Steel Claymore 2');
		weapon_names.PushBack('Shades Steel Rakuyo 2');
		weapon_names.PushBack('Shades Steel Graveripper 2');
		weapon_names.PushBack('Shades Steel Kukri 2');
		weapon_names.PushBack('Shades Steel a123 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Steel Hades Grasp 2');
		weapon_names.PushBack('Shades Steel Icarus Tears 2');
		weapon_names.PushBack('Shades Steel Kingslayer 2');
		weapon_names.PushBack('Shades Steel Vulcan 2');
		weapon_names.PushBack('Shades Steel Flameborn 2');
		weapon_names.PushBack('Shades Steel Frostmourne 2');
		weapon_names.PushBack('Shades Steel Oblivion 2');
		weapon_names.PushBack('Shades Steel Sinner 2');
		weapon_names.PushBack('Shades Steel Bloodletter 2');
		weapon_names.PushBack('Shades Steel Ares 2');
		weapon_names.PushBack('Shades Steel Voidblade 2');
		weapon_names.PushBack('Shades Steel Bloodshot 2');
		weapon_names.PushBack('Shades Steel Eagle Sword 2');
		weapon_names.PushBack('Shades Steel Lion Sword 2');
		weapon_names.PushBack('Shades Steel Pridefall 2');
		weapon_names.PushBack('Shades Steel Haoma 2');
		weapon_names.PushBack('Shades Steel Cursed Khopesh 2');
		weapon_names.PushBack('Shades Steel Sithis Blade 2');
		weapon_names.PushBack('Shades Steel Ejderblade 2');
		weapon_names.PushBack('Shades Steel Dragonbane 2');
		weapon_names.PushBack('Shades Steel Doomblade 2');
		weapon_names.PushBack('Shades Steel Crownbreaker 2');
		weapon_names.PushBack('Shades Steel Blooddusk 2');
		weapon_names.PushBack('Shades Steel Oathblade 2');
		weapon_names.PushBack('Shades Steel Beastcutter 2');
		weapon_names.PushBack('Shades Steel Hellspire 2');
		weapon_names.PushBack('Shades Steel Heavenspire 2');
		weapon_names.PushBack('Shades Steel Guandao 2');
		weapon_names.PushBack('Shades Steel Hitokiri Katana 2');
		weapon_names.PushBack('Shades Steel Gorgonslayer 2');
		weapon_names.PushBack('Shades Steel Ryu Katana 2');
		weapon_names.PushBack('Shades Steel Blackdawn 2');
		weapon_names.PushBack('Shades Steel Knife 2');
		weapon_names.PushBack('Shades Silver Claymore 2');
		weapon_names.PushBack('Shades Silver Rakuyo 2');
		weapon_names.PushBack('Shades Silver Graveripper 2');
		weapon_names.PushBack('Shades Silver a123 2');
		weapon_names.PushBack('Shades Silver Kukri 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Silver Hades Grasp 2');
		weapon_names.PushBack('Shades Silver Icarus Tears 2');
		weapon_names.PushBack('Shades Silver Kingslayer 2');
		weapon_names.PushBack('Shades Silver Vulcan 2');
		weapon_names.PushBack('Shades Silver Flameborn 2');
		weapon_names.PushBack('Shades Silver Frostmourne 2');
		weapon_names.PushBack('Shades Silver Oblivion 2');
		weapon_names.PushBack('Shades Silver Sinner 2');
		weapon_names.PushBack('Shades Silver Bloodletter 2');
		weapon_names.PushBack('Shades Silver Ares 2');
		weapon_names.PushBack('Shades Silver Voidblade 2');
		weapon_names.PushBack('Shades Silver Bloodshot 2');
		weapon_names.PushBack('Shades Silver Eagle Sword 2');
		weapon_names.PushBack('Shades Silver Lion Sword 2');
		weapon_names.PushBack('Shades Silver Pridefall 2');
		weapon_names.PushBack('Shades Silver Haoma 2');
		weapon_names.PushBack('Shades Silver Cursed Khopesh 2');
		weapon_names.PushBack('Shades Silver Sithis Blade 2');
		weapon_names.PushBack('Shades Silver Ejderblade 2');
		weapon_names.PushBack('Shades Silver Dragonbane 2');
		weapon_names.PushBack('Shades Silver Doomblade 2');
		weapon_names.PushBack('Shades Silver Crownbreaker 2');
		weapon_names.PushBack('Shades Silver Blooddusk 2');
		weapon_names.PushBack('Shades Silver Oathblade 2');
		weapon_names.PushBack('Shades Silver Beastcutter 2');
		weapon_names.PushBack('Shades Silver Hellspire 2');
		weapon_names.PushBack('Shades Silver Heavenspire 2');
		weapon_names.PushBack('Shades Silver Guandao 2');
		weapon_names.PushBack('Shades Silver Hitokiri Katana 2');
		weapon_names.PushBack('Shades Silver Gorgonslayer 2');
		weapon_names.PushBack('Shades Silver Ryu Katana 2');
		weapon_names.PushBack('Shades Silver Blackdawn 2');
		weapon_names.PushBack('Shades Silver Knife 2');
	}

	function fill_shades_armor_arrawy()
	{
		armor_names.Clear();

		armor_names.PushBack('Shades Realmdrifter Armor 2');
		armor_names.PushBack('Shades Realmdrifter Boots 2');
		armor_names.PushBack('Shades Realmdrifter Gloves 2');
		armor_names.PushBack('Shades Realmdrifter Helm');
		armor_names.PushBack('Shades Realmdrifter Pants 2');

		armor_names.PushBack('Shades Omen Armor 3');
		armor_names.PushBack('Shades Omen Boots 3');
		armor_names.PushBack('Shades Omen Gloves 3');
		armor_names.PushBack('Shades Omen Helm');
		armor_names.PushBack('Shades Omen Pants 3');

		armor_names.PushBack('Shades Plunderer Armor 3');
		armor_names.PushBack('Shades Plunderer Boots 3');
		armor_names.PushBack('Shades Plunderer Gloves 3');
		armor_names.PushBack('Shades Plunderer Headwear');
		armor_names.PushBack('Shades Plunderer Hat');
		armor_names.PushBack('Shades Plunderer Mask');
		armor_names.PushBack('Shades Plunderer Pants 3');

		armor_names.PushBack('Shade Plunderer Armor 3');
		armor_names.PushBack('Shade Plunderer Boots 3');
		armor_names.PushBack('Shade Plunderer Gloves 3');
		armor_names.PushBack('Shade Plunderer Headwear');
		armor_names.PushBack('Shade Plunderer Hat');
		armor_names.PushBack('Shade Plunderer Mask');
		armor_names.PushBack('Shade Plunderer Pants 3');
		
		armor_names.PushBack('Shades Oldhunter Armor 2');
		armor_names.PushBack('Shades Oldhunter Boots 2');
		armor_names.PushBack('Shades Oldhunter Gloves 2');
		armor_names.PushBack('Shades Oldhunter Cap');
		armor_names.PushBack('Shades Oldhunter Pants 2');
		
		armor_names.PushBack('Shades Faraam Armor 2');
		armor_names.PushBack('Shades Faraam Boots 2');
		armor_names.PushBack('Shades Faraam Gloves 2');
		armor_names.PushBack('Shades Faraam Helm');
		armor_names.PushBack('Shades Faraam Pants 2');
		
		armor_names.PushBack('Shades Hunter Armor 2');
		armor_names.PushBack('Shades Hunter Boots 2');
		armor_names.PushBack('Shades Hunter Gloves 2');
		armor_names.PushBack('Shades Hunter Hat');
		armor_names.PushBack('Shades Hunter Mask');
		armor_names.PushBack('Shades Hunter Mask and Hat');
		armor_names.PushBack('Shades Hunter Pants 2');
		
		armor_names.PushBack('Shades Yahargul Armor 2');
		armor_names.PushBack('Shades Yahargul Boots 2');
		armor_names.PushBack('Shades Yahargul Gloves 2');
		armor_names.PushBack('Shades Yahargul Helm');
		armor_names.PushBack('Shades Yahargul Pants 2');
		
		armor_names.PushBack('Shades Crow Armor 2');
		armor_names.PushBack('Shades Crow Boots 2');
		armor_names.PushBack('Shades Crow Gloves 2');
		armor_names.PushBack('Shades Crow Mask');
		armor_names.PushBack('Shades Crow Pants 2');
		
		armor_names.PushBack('Shades Sithis Armor 2');
		armor_names.PushBack('Shades Taifeng Boots 2');
		armor_names.PushBack('Shades Taifeng Gloves 2');
		armor_names.PushBack('Shades Sithis Hood');
		armor_names.PushBack('Shades Taifeng Pants 2');
		armor_names.PushBack('Shades Taifeng Armor 2');

		armor_names.PushBack('Shades Kara Armor 2');
		armor_names.PushBack('Shades Kara Boots 2');
		armor_names.PushBack('Shades Kara Gloves 2');
		armor_names.PushBack('Shades Kara Hat');
		armor_names.PushBack('Shades Kara Pants 2');
		
		armor_names.PushBack('Shades Lionhunter Armor 2');
		armor_names.PushBack('Shades Lionhunter Boots 2');
		armor_names.PushBack('Shades Lionhunter Gloves 2');
		armor_names.PushBack('Shades Lionhunter Hat');
		armor_names.PushBack('Shades Lionhunter Pants 2');
		
		armor_names.PushBack('Shades Berserker Armor 2');
		armor_names.PushBack('Shades Berserker Boots 2');
		armor_names.PushBack('Shades Berserker Gloves 2');
		armor_names.PushBack('Shades Berserker Helm');
		armor_names.PushBack('Shades Berserker Pants 2');
		
		armor_names.PushBack('Shades Bismarck Armor 2');
		armor_names.PushBack('Shades Bismarck Boots 2');
		armor_names.PushBack('Shades Bismarck Gloves 2');
		armor_names.PushBack('Shades Bismarck Helm');
		armor_names.PushBack('Shades Bismarck Pants 2');
		
		armor_names.PushBack('Shades Undertaker Armor 2');
		armor_names.PushBack('Shades Undertaker Boots 2');
		armor_names.PushBack('Shades Undertaker Gloves 2');
		armor_names.PushBack('Shades Undertaker Pants 2');
		armor_names.PushBack('Shades Undertaker Mask');
		
		armor_names.PushBack('Shades Ezio Pants 2');
		armor_names.PushBack('Shades Ezio Armor 2');
		armor_names.PushBack('Shades Ezio Boots 2');
		armor_names.PushBack('Shades Ezio Gloves 2');
		armor_names.PushBack('Shades Ezio Hood');
		
		armor_names.PushBack('Shades Headtaker Armor 2');
		armor_names.PushBack('Shades Headtaker Boots 2');
		armor_names.PushBack('Shades Headtaker Gloves 2');
		armor_names.PushBack('Shades Headtaker Pants 2');
		armor_names.PushBack('Shades Headtaker Mask');
		
		armor_names.PushBack('Shades Viper Armor 2');
		armor_names.PushBack('Shades Viper Boots 2');
		armor_names.PushBack('Shades Viper Gloves 2');
		armor_names.PushBack('Shades Viper Mask');
		armor_names.PushBack('Shades Viper Pants 2');
		
		armor_names.PushBack('Shades Ronin Hat');
		armor_names.PushBack('Shades Hitokiri Mask');
		armor_names.PushBack('Shades Warborn Helm');
		armor_names.PushBack('Shades Headtaker Cloak');
		armor_names.PushBack('Shades Genichiro Helm');
	}

	latent function Static_Spawn_Latent()
	{
		currWorld = theGame.GetWorld();

		temp = (CEntityTemplate)LoadResourceAsync( 
		"dlc\dlc_acs\data\entities\monsters\forest_god.w2ent"
		, true );

		//temp2 = (CEntityTemplate)LoadResourceAsync( 
		//"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"
		//, true );

		if ((currWorld.GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			spawnPos = Vector(240.237564, 1508.216187, 19.352640, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}
		else if ((currWorld.GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			spawnPos = Vector(-193.561172, -351.898865, 54.047535, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}
		else if ((currWorld.GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			spawnPos = Vector(480.838440,-1857.715454, 62.028912, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}
		else if ((currWorld.GetDepotPath() == "levels\the_spiral\spiral.w2w"))
		{
			spawnPos = Vector(-686.634521, -2314.287598, 83.935310, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}
		else if ((currWorld.GetDepotPath() == "levels\island_of_mist\island_of_mist.w2w"))
		{
			spawnPos = Vector(-13.837394, -240.803009, 12.674740, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}
		else if ((currWorld.GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"))
		{
			spawnPos = Vector(-342.549713, -11.509377, 201.521057, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 500000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God', true);

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 

			GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

			//GetACSWatcher().AddTimer('ACS_Forest_God_Demonic_Effect', 0.5, false);

			ACS_ToxicGasSpawner();
		}

		/*
		else if ((currWorld.GetDepotPath() == "levels\wyzima_castle\wyzima_castle.w2w"))
		{
			spawnPos = Vector(110.515083, -7.672404, 11.493693, 1);

			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );
		}
		*/
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Forest_God() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God' );
	return enemy;
}

function ACS_Big_Boi() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Big_Boi' );
	return enemy;
}

function ACS_Forest_God_Secondary() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God_Secondary' );
	return enemy;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawner()
{
	var vACS_Spawner : cACS_Spawner;
	vACS_Spawner = new cACS_Spawner in theGame;
			
	vACS_Spawner.ACS_Spawner_Engage();
}

statemachine class cACS_Spawner
{
    function ACS_Spawner_Engage()
	{
		this.PushState('ACS_Spawner_Engage');
	}
}

state ACS_Spawner_Engage in cACS_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

			//"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

			"dlc\dlc_acs\data\entities\monsters\treant.w2ent"
			
			, true );
		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );
			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1.5);
			ent.AddTag( 'ACS_enemy' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ToxicGasSpawner()
{
	var vACS_ToxicGasSpawner : cACS_ToxicGasSpawner;
	vACS_ToxicGasSpawner = new cACS_ToxicGasSpawner in theGame;
			
	vACS_ToxicGasSpawner.ACS_ToxicGasSpawner_Engage();
}

statemachine class cACS_ToxicGasSpawner
{
    function ACS_ToxicGasSpawner_Engage()
	{
		this.PushState('ACS_ToxicGasSpawner_Engage');
	}
}

state ACS_ToxicGasSpawner_Engage in cACS_ToxicGasSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var gasEntity 														: W3ToxicCloud;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\toxic_gas_7m.w2ent", true );

		pos = ACS_Forest_God().GetWorldPosition();
			
		gasEntity = (W3ToxicCloud)theGame.CreateEntity(temp, spawnPos, ACS_Forest_God().GetWorldRotation());

		gasEntity.CreateAttachment(ACS_Forest_God());

		//gasEntity.Enable(true);
			
		//gasEntity.PlayEffectSingle('toxic_gas');

		gasEntity.AddTag( 'ACS_Toxic_Gas' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function acspeffect(enam : CName)
{
	thePlayer.PlayEffectSingle(enam);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function fallup()
{
	var sett 							: SAnimatedComponentSlotAnimationSettings;
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var settings						: SAnimatedComponentSlotAnimationSettings;
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;

	settings.blendIn = 0.3f;
	settings.blendOut = 0.3f;

	actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
			
			enemyAnimatedComponent.PlaySlotAnimationAsync( 'fall_up_idle', 'NPC_ANIM_SLOT', settings);
		}
	}
	
	sett.blendIn = 0.2f;
	sett.blendOut = 0.5f;
		
	thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_idle_sign_aard_light', 'PLAYER_SLOT', sett );
}

exec function eforceani(animation_name: name)
{
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var settings						: SAnimatedComponentSlotAnimationSettings;
	
	actor = (CActor)( thePlayer.GetDisplayTarget() );
	
	enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
	settings.blendIn = 0.3f;
	settings.blendOut = 0.3f;
	
	enemyAnimatedComponent.PlaySlotAnimationAsync( animation_name, 'NPC_ANIM_SLOT', settings);
}

exec function eforcebeh(i: int)
{
	var vACS_EnemyBehSwitch : cACS_EnemyBehSwitch;
	vACS_EnemyBehSwitch = new cACS_EnemyBehSwitch in theGame;
	
	if (i == 1)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Sword1h();
	}
	else if (i == 2)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Sword2h();
	}
	else if (i == 3)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Witcher();
	}
	else if (i == 4)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Shield();
	}
	else if (i == 5)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Bow();
	}
}

function ACS_EnemyBehSwitch(i: int)
{
	var vACS_EnemyBehSwitch : cACS_EnemyBehSwitch;
	vACS_EnemyBehSwitch = new cACS_EnemyBehSwitch in theGame;
	
	if (i == 1)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Sword1h();
	}
	else if (i == 2)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Sword2h();
	}
	else if (i == 3)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Witcher();
	}
	else if (i == 4)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Shield();
	}
	else if (i == 5)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Bow();
	}
}

statemachine class cACS_EnemyBehSwitch
{
    function EnemyBehSwitch_Sword1h()
	{
		this.PushState('EnemyBehSwitch_Sword1h');
	}

	function EnemyBehSwitch_Sword2h()
	{
		this.PushState('EnemyBehSwitch_Sword2h');
	}

	function EnemyBehSwitch_Witcher()
	{
		this.PushState('EnemyBehSwitch_Witcher');
	}

	function EnemyBehSwitch_Shield()
	{
		this.PushState('EnemyBehSwitch_Shield');
	}

	function EnemyBehSwitch_Bow()
	{
		this.PushState('EnemyBehSwitch_Bow');
	}
}
 
state EnemyBehSwitch_Sword1h in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword1h();
	}
	
	entry function EnemyBehSwitch_sword1h()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.ActivateAndSyncBehavior( 'sword_1handed' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', settings);
			}
		}
	}
}


state EnemyBehSwitch_Sword2h in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;
	private var sword					: SItemUniqueId;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword2h();
	}
	
	entry function EnemyBehSwitch_sword2h()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.GetInventory().RemoveAllItems();

				actor.GetInventory().AddAnItem( 'NPC Gregoire Sword', 1 );

				sword = actor.GetInventory().GetItemId('NPC Gregoire Sword');

				//actor.EquipItem(sword, r_weapon, true );

				actor.DrawWeaponAndAttackLatent(sword);

				actor.ActivateAndSyncBehavior( 'sword_2handed' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', settings);
			}
		}
	}
}

state EnemyBehSwitch_Fistfight in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_fistfight();
	}
	
	entry function EnemyBehSwitch_fistfight()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.ActivateAndSyncBehavior( 'Fistfight' );
			}
		}
	}
}

state EnemyBehSwitch_Witcher in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_witcher();
	}
	
	entry function EnemyBehSwitch_witcher()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.ActivateAndSyncBehavior( 'Witcher' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', settings);
			}
		}
	}
}

state EnemyBehSwitch_Shield in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_shield();
	}
	
	entry function EnemyBehSwitch_shield()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.ActivateAndSyncBehavior( 'Shield' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', settings);
			}
		}
	}
}

state EnemyBehSwitch_Bow in cACS_EnemyBehSwitch
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_bow();
	}
	
	entry function EnemyBehSwitch_bow()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.ActivateAndSyncBehavior( 'Bow' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', settings);
			}
		}
	}
}

exec function acsfxtest(effect_name:name)
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;

	//GetACSTestEnt.Destroy();

	GetACSTestEnt_Array_Destroy();

	thePlayer.SoundEvent("magic_man_tornado_loop_start");

	thePlayer.SoundEvent("magic_man_sand_gust");

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() * 1.3;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
		//"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"

		//"dlc\ep1\data\gameplay\abilities\mage\quick_sand_hit.w2ent"
		//"dlc\ep1\data\gameplay\abilities\mage\sand_trap.w2ent"
		//"dlc\ep1\data\gameplay\abilities\mage\sand_push_cast.w2ent"

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_tornado.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_monster_ground.w2ent"

		//"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\blast.w2ent"

		//"dlc\ep1\data\gameplay\abilities\mage\tornado.w2ent"

		//"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

		, true ), pos, rot );

	ent.AddTag('ACS_Test_Ent');

	//animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	//meshcomp = ent.GetComponentByClassName('CMeshComponent');
	//h = 1.5;

	//animcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));

	//meshcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));	

	//animcomp.SetAnimationSpeedMultiplier( 8  ); 

	ent.CreateAttachment( thePlayer, , Vector( 0, 3, -10 ), EulerAngles(0,0,0) );

	//ent.CreateAttachment( thePlayer, , Vector( 0, 0, 3.5 ), EulerAngles(0,0,0) );

	ent.PlayEffectSingle(effect_name);
}

exec function acseffecttest2()
{
	ACS_Umbral_Slash_End_Effect();
}

exec function acsfxteststop()
{
	GetACSTestEnt_Array_StopEffects();
}

exec function acssoundtest(str:string)
{
	thePlayer.SoundEvent(str);
}

function GetACSTestEnt() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Test_Ent' );
	return ent;
}

function GetACSTestEnt_Array() : array<CEntity>
{
	var ents 											: array<CEntity>;
	
	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	return ents;
}

function GetACSTestEnt_Array_Destroy()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}

	thePlayer.SoundEvent("magic_man_tornado_loop_stop");
}

function GetACSTestEnt_Array_StopEffects()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].StopAllEffects();
		ents[i].DestroyAfter(1);
	}

	thePlayer.SoundEvent("magic_man_tornado_loop_stop");
}
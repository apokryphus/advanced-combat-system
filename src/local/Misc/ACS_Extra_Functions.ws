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
	
	if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped') )
	{
		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang = 90;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang = 90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang = 90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang = 90;
			}
		}
		else	
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 60;
			}
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_sword_equipped_TAG') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_secondary_sword_equipped_TAG') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_sword_equipped') )
	{
		if (thePlayer.HasTag('ACS_Shielded_Entity'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 5;
				ang =	135;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 5;
				ang =	135;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 5;
				ang =	135;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 5;
				ang =	135;
			}	
		}
		else
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}	
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_secondary_sword_equipped') )
	{
		if ( 
		ACS_GetWeaponMode() == 0
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2
		)
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	30;
			}
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{ 
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_sword_equipped') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.25;
			ang =	90;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.25;
			ang =	90;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.25;
			ang =	90;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.25;
			ang =	90;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_secondary_sword_equipped') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2;
			ang =	30;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2;
			ang =	30;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_sword_equipped') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.5;
			ang = 60;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.5;
			ang = 60;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.5;
			ang = 60;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.5;
			ang = 60;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') )
	{
		if ( 
		ACS_GetWeaponMode() == 0
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2
		)
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 3.5;
				ang =	180;
			}	
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	60;
			}
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_sword_equipped') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.5;
			ang =	30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.5;
			ang =	30;
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
	else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_secondary_sword_equipped') )
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.25;
			ang =	40;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.25;
			ang =	40;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 2.25;
			ang =	40;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 2.25;
			ang =	40;
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
	else 
	{
		if ( thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.25;
			ang = 30;
		}
		else if ( thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.25;
			ang = 30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( true ) )
		{
			dist = 1.25;
			ang = 30;
		}
		else if ( !thePlayer.IsDoingSpecialAttack( false ) )
		{
			dist = 1.25;
			ang = 30;
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

function ACS_InitializeSettings() 
{
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMain', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodArmigerModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodFocusModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMovementSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodHybridModeSettings', 0);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodTauntSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodSpecialAbilitiesSettings', 0);

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

function ACS_VampireSoundEffects_Enabled(): bool 
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ACSmodMain', 'ACSmodVampireSoundEffects');
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

function ACS_DisableAutomaticSwordSheathe_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'DisableAutomaticSwordSheathe');
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

// Taunt System

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
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace'
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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'
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
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'
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
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
	
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
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'
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
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
	
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
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'
	
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
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('ice_armor_cutscene');
			thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('ice_armor_cutscene');
			thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if ( thePlayer.HasTag('yrden_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('black_trail');
			thePlayer.StopEffect('black_trail');
		}
		else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('hit_lightning');
			thePlayer.StopEffect('hit_lightning');
		}
		else if ( thePlayer.HasTag('aard_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffect('weakened');
		}
		else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('third_teleport_indicator');
			thePlayer.StopEffect('third_teleport_indicator');
		}
		else if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('third_teleport_out');
			thePlayer.PlayEffect('third_teleport_out');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffect('weakened');
		}
	}
	else
	{
		if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffect('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped' ) )
		{
			thePlayer.PlayEffect('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.StopEffect('weakened');
			thePlayer.PlayEffect('weakened');
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

function ACS_OnTakeDamage(action: W3DamageAction)
{
	var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var settingsA, settingsB, settings_interrupt			: SAnimatedComponentSlotAnimationSettings;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	
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

	if ( playerVictim
	//&& !playerAttacker
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !action.IsDoTDamage()
	&& (thePlayer.IsGuarded() || thePlayer.IsInGuardedState())
	&& !thePlayer.IsPerformingFinisher()
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
			if ( action.processedDmg.vitalityDamage >= playerVictim.GetCurrentHealth() )
			{
				if (((CNewNPC)npcAttacker).GetNPCType() == ENGT_Guard)
				{
					if(!thePlayer.IsAlive())
					{
						thePlayer.StopAllEffects();

						thePlayer.ClearAnimationSpeedMultipliers();	
																	
						thePlayer.SetAnimationSpeedMultiplier(0.125 / theGame.GetTimeScale());
																
						GetACSWatcher().AddTimer('ACS_ResetAnimation', 3  / theGame.GetTimeScale(), false);

						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
					}
				}
				else 
				{
					if(!thePlayer.IsAlive())
					{
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
																		
								thePlayer.SetAnimationSpeedMultiplier(0.25  / theGame.GetTimeScale());
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 2  / theGame.GetTimeScale(), false);

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
																		
									thePlayer.SetAnimationSpeedMultiplier(0.25  / theGame.GetTimeScale());
																			
									GetACSWatcher().AddTimer('ACS_ResetAnimation', 5  / theGame.GetTimeScale(), false);

									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', settings_interrupt );
								}
								else
								{
									thePlayer.ClearAnimationSpeedMultipliers();	
																		
									thePlayer.SetAnimationSpeedMultiplier(0.125  / theGame.GetTimeScale() );
																			
									GetACSWatcher().AddTimer('ACS_ResetAnimation', 5  / theGame.GetTimeScale(), false);

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
																			
								thePlayer.SetAnimationSpeedMultiplier(2.5  / theGame.GetTimeScale());
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 2  / theGame.GetTimeScale(), false);

								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								thePlayer.ClearAnimationSpeedMultipliers();	
																		
								thePlayer.SetAnimationSpeedMultiplier(0.95 / theGame.GetTimeScale());
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 1  / theGame.GetTimeScale(), false);

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

				thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage);

				thePlayer.DrainStamina(ESAT_LightAttack);

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
				thePlayer.PlayEffect('taunt_sparks');
			}
		}
		else if ( thePlayer.HasTag('axii_sword_equipped') && !action.DealsAnyDamage() )
		{
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

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

			ACS_Shield().PlayEffect('aard_cone_hit');
			ACS_Shield().StopEffect('aard_cone_hit');
		}
		else 
		{
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

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
	|| thePlayer.HasTag('vampire_claws_equipped'))
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
																
					thePlayer.SetAnimationSpeedMultiplier(0.125 / theGame.GetTimeScale());
															
					GetACSWatcher().AddTimer('ACS_ResetAnimation', 3  / theGame.GetTimeScale(), false);

					playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
				}
			}
			else 
			{
				if(!thePlayer.IsAlive())
				{
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
																	
							thePlayer.SetAnimationSpeedMultiplier(0.25 / theGame.GetTimeScale());
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 2 / theGame.GetTimeScale(), false);

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
																	
								thePlayer.SetAnimationSpeedMultiplier(0.25 / theGame.GetTimeScale());
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 5 / theGame.GetTimeScale(), false);

								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', settings_interrupt );
							}
							else
							{
								thePlayer.ClearAnimationSpeedMultipliers();	
																	
								thePlayer.SetAnimationSpeedMultiplier(0.125 / theGame.GetTimeScale());
																		
								GetACSWatcher().AddTimer('ACS_ResetAnimation', 5 / theGame.GetTimeScale(), false);

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
																		
							thePlayer.SetAnimationSpeedMultiplier(2.5 / theGame.GetTimeScale());
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 2 / theGame.GetTimeScale(), false);

							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'death_01_caretaker_ACS', 'PLAYER_SLOT', settings_interrupt );
						}
						else
						{
							thePlayer.ClearAnimationSpeedMultipliers();	
																	
							thePlayer.SetAnimationSpeedMultiplier(0.95 / theGame.GetTimeScale());
																	
							GetACSWatcher().AddTimer('ACS_ResetAnimation', 1 / theGame.GetTimeScale(), false);

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

				thePlayer.PlayEffect('smoke_explosion');
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

				thePlayer.ClearAnimationSpeedMultipliers();	
				
				thePlayer.ForceSetStat( BCS_Focus, thePlayer.GetStatMax(BCS_Focus) * 0.25 );

				if( thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
				{
					if( thePlayer.GetInventory().ItemHasTag(item, 'HeavyArmor') )
					{
						thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage * 0.25 );
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'MediumArmor') )
					{
						thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage * 0.3 );
					}
					else if( thePlayer.GetInventory().ItemHasTag(item, 'LightArmor') )
					{
						thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage * 0.4 );
					}
					else
					{
						thePlayer.GainStat( BCS_Vitality, action.processedDmg.vitalityDamage * 0.5 );
					}
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

				thePlayer.PlayEffect('special_attack_break');
				thePlayer.StopEffect('special_attack_break');

				GetACSWatcher().ACS_Hit_Reaction();
			}
			else
			{
				/*
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

				thePlayer.SetPlayerTarget( npcAttacker );

				thePlayer.SetPlayerCombatTarget( npcAttacker );

				thePlayer.UpdateDisplayTarget( true );

				thePlayer.UpdateLookAtTarget();

				thePlayer.RaiseEvent( 'AttackInterrupt' );

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

				thePlayer.ClearAnimationSpeedMultipliers();	

				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					movementAdjustor.CancelAll();

					GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

					ACS_PlayerHitEffects();

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
					ACS_PlayerHitEffects();

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

		ACS_Caretaker_Drain_Energy();

		if (thePlayer.CanUseSkill(S_Sword_s01))
		{
			npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

			npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

			npc.ForceSetStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) + npc.GetStatMax( BCS_Stamina ) * 0.1 );
		}
		
		if ((npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01 || npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01) ) 
		{
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.StopEffect('blood_effect_claws_test');
				thePlayer.PlayEffect('blood_effect_claws_test');
			}

			if (npc.IsHuman() && npc.HasTag('ACS_caretaker_shade'))
			{
				thePlayer.GainStat( BCS_Vitality, thePlayer.GetStatMax( BCS_Vitality ) * 0.10 );
			}
			else
			{
				//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

				npc.StopAllEffects();
			}
		}

		if( playerAttacker.HasAbility('Runeword 2 _Stats', true)
		||  thePlayer.HasTag('ACS_Shielded_Entity') )
		{
			ACS_Light_Attack_Extended_Trail();
		}

		if ( action.GetHitReactionType() == EHRT_Light )
		{
			ACS_Light_Attack_Trail();
		}
		else if ( action.GetHitReactionType() == EHRT_Heavy )
		{
			ACS_Heavy_Attack_Trail();
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
					npc.StopEffect('pee');
					npc.PlayEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffect('puke');
					
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
							animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );	

							npc.GetComponent("Finish").SetEnabled( true );
					
							npc.SignalGameplayEvent( 'Finisher' );
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
					npc.StopEffect('pee');
					npc.PlayEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffect('puke');
					
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
							
							animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );

							npc.GetComponent("Finish").SetEnabled( true );
					
							npc.SignalGameplayEvent( 'Finisher' );
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
					npc.StopEffect('pee');
					npc.PlayEffect('pee');
						
					npc.StopEffect('puke');
					npc.PlayEffect('puke');
					
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
							
							animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);

							//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settings_interrupt);
						
							npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

							npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
								
							npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );

							npc.GetComponent("Finish").SetEnabled( true );
					
							npc.SignalGameplayEvent( 'Finisher' );
						}
						
						npc.AddTag('ACS_mettle');
					}
				}
			}
		}
	}
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
			
			l_aerondightEnt.PlayEffect( l_newChargingEffect );
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
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 / theGame.GetTimeScale(), false);
}

function ACS_ExplorationDelay_actual()
{
	if (!thePlayer.IsInCombat() && thePlayer.HasTag('vampire_claws_equipped'))
	{
		thePlayer.PlayEffect('claws_effect');
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
		AddTimer('waitForPlayer', 0.00001f / theGame.GetTimeScale(), true);
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

exec function acsspawn()
{
	ACS_Spawner();
}

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
		
		thePlayer.StopEffect('summon');
		thePlayer.PlayEffect('summon');
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( "dlc/dlc_acs/data/entities/monsters/hym.w2ent", true );
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
			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());
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

function ACS_Enemy() : CEntity
{
	var enemy 				 : CEntity;
	
	enemy = (CEntity)theGame.GetEntityByTag( 'ACS_enemy' );
	return enemy;
}

exec function acsenemydestroy()
{
	ACS_Enemy().Destroy();
}

exec function peffect(enam : CName)
{
	thePlayer.PlayEffect(enam);
}

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

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword2h();
	}
	
	entry function EnemyBehSwitch_sword2h()
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
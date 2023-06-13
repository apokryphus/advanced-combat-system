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
			if ( 
			thePlayer.HasTag('igni_sword_equipped_TAG') 
			|| thePlayer.HasTag('igni_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	45;

				if(  thePlayer.IsDoingSpecialAttack( false ) )
				{
					ang +=	315;
				}

				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						dist += 1.1;
					}
					else if(  thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.9;
					}
				}
			}
			else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
			|| thePlayer.HasTag('igni_secondary_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	45;

				if(  thePlayer.IsDoingSpecialAttack( false ) )
				{
					ang +=	315;
				}

				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						dist += 1.1;
					}
					else if(  thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.9;
					}
				}
			}
			else if ( thePlayer.HasTag('axii_sword_equipped') )
			{
				dist = 1.6;
				ang =	45;	

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					dist += 10;
					ang +=	30;
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
					ang =	45;
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{ 
					dist = 1.75;
					ang =	45;
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
				ang = 45;
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
				dist = 1.6;
				ang =	45;

				if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
				{
					ang +=	320;
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
					ang =	45;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}

			if (ACS_Armor_Equipped_Check())
			{
				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if( !thePlayer.IsDoingSpecialAttack( false )
					&& !thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1;
					}
				}
				else
				{
					dist += 1;
				}
			}
		}

		if ( thePlayer.GetTarget() == ACS_Big_Boi() )
		{
			dist += 0.75;
			ang += 15;
		}

		if (ACS_Player_Scale() > 1)
		{
			dist += ACS_Player_Scale() * 0.75;
		}
		else if (ACS_Player_Scale() < 1)
		{
			dist -= ACS_Player_Scale() * 0.5;
		}

		if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
		&& !thePlayer.HasTag('igni_sword_equipped') 
		&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
		&& !ACS_Armor_Equipped_Check())
		{
			dist += 1;
		}

		if (thePlayer.IsUsingHorse()) 
		{
			dist += 1.5;

			ang += 270;
		}

		if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
		{
			dist += 1.5;

			ang += 315;
		}

		if (ACS_Bear_School_Check())
		{
			dist += 0.5;
			ang +=	15;

			if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (ACS_Griffin_School_Check()
		&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
		{
			dist += 2;
			ang +=	15;
		}

		if (ACS_Manticore_School_Check())
		{
			dist += 0.5;

			if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (ACS_Viper_School_Check())
		{
			if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
			{
				dist += 1.5;
			}
		}
	}
	else 
	{
		dist = 1;
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

	if ( !theSound.SoundIsBankLoaded("qu_item_olgierd_sabre.bnk") )
	{
		theSound.SoundLoadBank( "qu_item_olgierd_sabre.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_water_mage.bnk") )
	{
		theSound.SoundLoadBank( "monster_water_mage.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_dracolizard.bnk") )
	{
		theSound.SoundLoadBank( "monster_dracolizard.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_bies.bnk") )
	{
		theSound.SoundLoadBank( "monster_bies.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_him.bnk") )
	{
		theSound.SoundLoadBank( "monster_him.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_ep2_704_regis.bnk") )
	{
		theSound.SoundLoadBank( "qu_ep2_704_regis.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("sq_sk_209.bnk") )
	{
		theSound.SoundLoadBank( "sq_sk_209.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
	{
		theSound.SoundLoadBank( "animals_wolf.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
	{
		theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_werewolf.bnk") )
	{
		theSound.SoundLoadBank( "monster_werewolf.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_fleder.bnk") )
	{
		theSound.SoundLoadBank( "monster_fleder.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_item_demonic_saddle.bnk") )
	{
		theSound.SoundLoadBank( "qu_item_demonic_saddle.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_sorceress.bnk") )
	{
		theSound.SoundLoadBank( "magic_sorceress.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_cyclop.bnk") )
	{
		theSound.SoundLoadBank( "monster_cyclop.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_lessun.bnk") )
	{
		theSound.SoundLoadBank( "monster_lessun.bnk", false );
	}
}

function ACS_Enabled(): bool 
{
  if (ACS_ModEnabled() && !thePlayer.IsCiri() )
  {
	return true;
  }
  else
  {
	return false;
  }
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
	var ImagePath				: string;

	WelcomeTitle = "Advanced Combat System";

	WelcomeMessage = "Thank you for installing Advanced Combat System" + "!<br/> <br/>Settings have been initialized, and can be further customized in the " + "Advanced Combat System mod menu.<br/> <br/>If you're seeing this welcome message repeatedly, it means the menu was not installed correctly.<br/> <br/>For detailed explanations of abilities, please read through the Github page for more information, or reach out to me in my Wolven Workshop Discord channel" + ". <br/> <br/>I may or may not reply.";

	ImagePath = "";

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = WelcomeTitle;

	msg.imagePath = ImagePath;

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

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

exec function acswelcomemessage()
{
	ACS_DisplayWelcomeMessage();
}

function ACSMainSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodMain', nam);

	return value;
}

function ACS_ModEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_IsInitialized(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodInit');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_SizeIsInitialized(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodSizeInit');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_InitializeSettings() 
{
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMain', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodArmigerModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodFocusModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMovementSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodHybridModeSettings', 0);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodTauntSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodSpecialAbilitiesSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodDamageSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodMiscSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodStaminaSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodEncountersSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodDodgeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodJumpSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodBruxaDashSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('ACSmodWraithModeSettings', 0);

	theGame.SaveUserSettings();
}

function ACS_GetWeaponMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodWeaponMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_OnHitEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodOnHitEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ElementalRend_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodElementalRend');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_RageMechanic_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodRageMechanic');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_GetFistMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodFistMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_GetTargetMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodTargetMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_DisableAutomaticSwordSheathe_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'DisableAutomaticSwordSheathe');
}

function ACS_ComboMode(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('ACSmodComboMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Armiger Mode

function ACSArmigerModeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodArmigerModeSettings', nam);

	return value;
}

function ACS_GetArmigerModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Armiger_Axii_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerAxiiSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_Armiger_Aard_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerAardSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_Armiger_Yrden_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerYrdenSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 4;
	}
	
	else return configValue;
}

function ACS_Armiger_Quen_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerQuenSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Armiger_Igni_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('ACSmodArmigerIgniSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Focus Mode

function ACSFocusModeGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodFocusModeSettings', nam);

	return value;
}

function ACS_GetFocusModeSilverWeapon(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSFocusModeGetConfigValue('ACSmodFocusModeSilverWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetFocusModeSteelWeapon(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSFocusModeGetConfigValue('ACSmodFocusModeSteelWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetFocusModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSFocusModeGetConfigValue('ACSmodFocusModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Hybrid Mode

function ACSHybridModeGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodHybridModeSettings', nam);

	return value;
}

function ACS_GetHybridModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeLightAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeLightAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardLightAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeForwardLightAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeHeavyAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeHeavyAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardHeavyAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeForwardHeavyAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeSpecialAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeSpecialAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardSpecialAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeForwardSpecialAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeCounterAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('ACSmodHybridModeCounterAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Misc Settings

function ACSMiscSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodMiscSettings', nam);

	return value;
}

function ACS_Guiding_Light_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodGuidingLightEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Player_Scale(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodPlayerScale');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_AutoFinisher_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodAutoFinisherEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ExperimentalDismemberment_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodExperimentalDismemberment');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_PassiveTaunt_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodPassiveTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_SwordWalk_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodSwordWalkEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_UnlimitedDurability_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodUnlimitedDurabilityEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_HideSwordsheathes_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodHideSwordsheathes');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ShowWeaponsWhileCloaked(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodShowWeaponsWhileCloaked');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_UnequipCloakWhileInCombat(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodUnequipCloakWhileInCombat');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_VampireSoundEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('ACSmodVampireSoundEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Taunt Settings

function ACSTauntSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodTauntSettings', nam);

	return value;
}

function ACS_TauntSystem_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTauntSettingsGetConfigValue('ACSmodTauntSystemEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_IWannaPlayGwent_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTauntSettingsGetConfigValue('ACSmodIWannaPlayGwentEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_CombatTaunt_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTauntSettingsGetConfigValue('ACSmodCombatTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Movement Settings

function ACSMovementSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodMovementSettings', nam);

	return value;
}



// Jump Settings

function ACSJumpSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodJumpSettings', nam);

	return value;
}


function ACS_CombatJump_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodCombatJump');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_JumpExtend_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtend');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_JumpExtend_Effect_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtendEffect');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Normal_JumpExtend_GetHeight(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtendNormalHeight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_Normal_JumpExtend_GetDistance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtendNormalDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 10;
	}
	
	else return configValue;
}

function ACS_Sprinting_JumpExtend_GetHeight(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtendSprintingHeight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_Sprinting_JumpExtend_GetDistance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('ACSmodJumpExtendSprintingDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 12;
	}
	
	else return configValue;
}


// Bruxa Dash Settings

function ACSBruxaDashSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodBruxaDashSettings', nam);

	return value;
}

function ACS_BruxaDash_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('ACSmodBruxaDash');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDashInput(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('ACSmodBruxaDashInput');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_BruxaDash_Normal_Distance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('ACSmodBruxaDashNormalDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 15;
	}
	
	else return configValue;
}

function ACS_BruxaDash_Combat_Distance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('ACSmodBruxaDashCombatDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 6;
	}
	
	else return configValue;
}

// Dodge Settings

function ACSDodgeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodDodgeSettings', nam);

	return value;
}


function ACS_BruxaLeapAttack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodBruxaLeapAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeSlideBack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodBruxaDodgeSlideBack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeCenter_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodBruxaDodgeCenter');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeLeft_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodBruxaDodgeLeft');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeRight_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodBruxaDodgeRight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WildHuntBlink_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodWildHuntBlink');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DodgeEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('ACSmodDodgeEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Wraith Mode Settings

function ACSWraithModeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodWraithModeSettings', nam);

	return value;
}

function ACS_WraithMode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWraithModeSettingsGetConfigValue('ACSmodWraithMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WraithModeInput(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWraithModeSettingsGetConfigValue('ACSmodWraithModeInput');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Special Abilities Settings

function ACSSpecialAbilitiesSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodSpecialAbilitiesSettings', nam);

	return value;
}

function ACS_SummonedShades_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodSummonedShades');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BeamAttack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodBeamAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SwordArray_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodSwordArray');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ShieldEntity_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodShieldEntity');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_QuenMonsterSummon_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodQuenMonsterSummon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_YrdenSkeleSummon_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodYrdenSkeleSummon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_AardPull_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodAardPull');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaCamoDecoy_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodBruxaCamoDecoy');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaBite_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('ACSmodBruxaBite');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Damage Settings

function ACSDamageSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodDamageSettings', nam);

	return value;
}

function ACS_Vampire_Claws_Human_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('ACSmodVampireClawsHumanMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Human_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('ACSmodVampireClawsHumanMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Monster_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('ACSmodVampireClawsMonsterMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Monster_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('ACSmodVampireClawsMonsterMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Player_Fall_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('ACSmodPlayerFallDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.2;
	}
	
	else return configValue;
}

// Stamina Settings

function ACSStaminaSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodStaminaSettings', nam);

	return value;
}

function ACS_StaminaBlockAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodStaminaBlockAction');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_StaminaCostAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodStaminaCostAction');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_LightAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodLightAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.05;
	}
	
	else return configValue;
}

function ACS_HeavyAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodHeavyAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_SpecialAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodSpecialAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.15;
	}
	
	else return configValue;
}

function ACS_DodgeStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodDodgeStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.05;
	}
	
	else return configValue;
}

function ACS_LightAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodLightAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_HeavyAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodHeavyAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_SpecialAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodSpecialAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_DodgeStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('ACSmodDodgeStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

// Encounters Settings

function ACSEncountersSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodEncountersSettings', nam);

	return value;
}

function ACS_ShadowsSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('ACSmodShadowsSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_WildHuntSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('ACSmodWildHuntSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_NightStalkerSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('ACSmodNightStalkerSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
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
	return theGame.GetDLCManager().IsDLCAvailable('scaaraiov_dlc');	
}

function ACS_SCAAR_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('scaaraiov_dlc');		
}

function ACS_E3ARP_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('e3arp_dlc');	
}

function ACS_E3ARP_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('e3arp_dlc');		
}

function ACS_W3EE_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('w3ee_dlc');	
}

function ACS_W3EE_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('w3ee_dlc');		
}

function ACS_W3EE_Redux_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc');	
}

function ACS_W3EE_Redux_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('reduxw3ee_dlc');		
}

function ACS_MS_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('magicspells_rev');	
}

function ACS_MS_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('magicspells_rev');		
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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crafted Ofir Steel Sword'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Hakland Sabre'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 1'
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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq701 Geralt of Rivia sword'

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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'

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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Axe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Blackjack'

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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'
	
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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scoop'

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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx'
	
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

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
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

/*
function ACS_GetItem_Aerondight(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	if( 
	//thePlayer.GetInventory().GetItemName( thePlayer.GetInventory().GetCurrentlyHeldSword() ) == 'Aerondight EP2'
	thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' )
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}
*/

function ACS_GetItem_Aerondight(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Iris(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
	{
		return true;
	}
	else
	{
		return false;
	}
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

function ACS_GetItem_Wolf_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 4')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Wolf_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Wolf_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Wolf_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Wolf_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Wolf_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Wolf_School_Check(): bool
{
	if ( ACS_GetItem_Wolf_Armor()
	&& ACS_GetItem_Wolf_Boots()
	&& ACS_GetItem_Wolf_Pants()
	&& ACS_GetItem_Wolf_Gloves()
	//&& ACS_GetItem_Wolf_Steel_Sword()
	//&& ACS_GetItem_Wolf_Silver_Sword()
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

function ACS_GetItem_Bear_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 4')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Bear_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Bear_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Bear_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Bear_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Bear_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Bear_School_Check(): bool
{
	if ( ACS_GetItem_Bear_Armor()
	&& ACS_GetItem_Bear_Boots()
	&& ACS_GetItem_Bear_Pants()
	&& ACS_GetItem_Bear_Gloves()
	//&& ACS_GetItem_Bear_Steel_Sword()
	//&& ACS_GetItem_Bear_Silver_Sword()
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

function ACS_GetItem_Cat_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 4')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Cat_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Cat_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Cat_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Cat_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Cat_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Cat_School_Check(): bool
{
	if ( ACS_GetItem_Cat_Armor()
	&& ACS_GetItem_Cat_Boots()
	&& ACS_GetItem_Cat_Pants()
	&& ACS_GetItem_Cat_Gloves()
	//&& ACS_GetItem_Cat_Steel_Sword()
	//&& ACS_GetItem_Cat_Silver_Sword()
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

function ACS_GetItem_Griffin_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 4')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Griffin_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Griffin_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Griffin_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 5')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Griffin_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Griffin_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 3')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Griffin_School_Check(): bool
{
	if ( ACS_GetItem_Griffin_Armor()
	&& ACS_GetItem_Griffin_Boots()
	&& ACS_GetItem_Griffin_Pants()
	&& ACS_GetItem_Griffin_Gloves()
	//&& ACS_GetItem_Griffin_Steel_Sword()
	//&& ACS_GetItem_Griffin_Silver_Sword()
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

function ACS_GetItem_Manticore_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Manticore_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Manticore_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Manticore_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Manticore_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Manticore_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Manticore_School_Check(): bool
{
	if ( ACS_GetItem_Manticore_Armor()
	&& ACS_GetItem_Manticore_Boots()
	&& ACS_GetItem_Manticore_Pants()
	&& ACS_GetItem_Manticore_Gloves()
	//&& ACS_GetItem_Manticore_Steel_Sword()
	//&& ACS_GetItem_Manticore_Silver_Sword()
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

function ACS_GetItem_Viper_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Armor')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Boots')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Gloves')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Pants')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School silver sword')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School steel sword')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Viper_School_Check(): bool
{
	if ( ACS_GetItem_Viper_Armor()
	&& ACS_GetItem_Viper_Boots()
	&& ACS_GetItem_Viper_Pants()
	&& ACS_GetItem_Viper_Gloves()
	//&& ACS_GetItem_Viper_Steel_Sword()
	//&& ACS_GetItem_Viper_Silver_Sword()
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

function ACS_GetItem_Forgotten_Wolf_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Forgotten_Wolf_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Forgotten_Wolf_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Forgotten_Wolf_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Forgotten_Wolf_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Forgotten_Wolf_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 2')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Forgotten_Wolf_Check(): bool
{
	if ( ACS_GetItem_Forgotten_Wolf_Armor()
	&& ACS_GetItem_Forgotten_Wolf_Boots()
	&& ACS_GetItem_Forgotten_Wolf_Pants()
	&& ACS_GetItem_Forgotten_Wolf_Gloves()
	//&& ACS_GetItem_Forgotten_Wolf_Steel_Sword()
	//&& ACS_GetItem_Forgotten_Wolf_Silver_Sword()
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

function ACS_GetItem_Zireal_Steel(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Zireael Sword' 
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Zireal_Silver(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'q505 crafted sword'
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_Zireael_Check(): bool
{
	if ( ACS_GetItem_Zireal_Steel()
	|| ACS_GetItem_Zireal_Silver()
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
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Armor_Omega'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Armor_Omega'
	)
	{
		return true; 
	}
	
	return false;
}

function ACS_IsItemCloak( id : SItemUniqueId ) : bool
{
	if(thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz' 
	)
	{
		return true; 
	}

	return false;
}

function ACS_CloakEquippedCheck() : bool
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_CloakCheck(equippedItemsId[i])
		&& !ACS_ShowWeaponsWhileCloaked()
		)
		{
			ACS_CloakWeaponHide_Tutorial();
			return true;
		} 	
	}
	
	return false;
}

function ACS_UnequipCloak()
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_IsItemCloak(equippedItemsId[i]))
		{
			if( !thePlayer.GetInventory().ItemHasTag( equippedItemsId[i], 'Unequipped_By_ACS' ))
			{
				thePlayer.GetInventory().AddItemTag( equippedItemsId[i], 'Unequipped_By_ACS' );
			}

			thePlayer.UnequipItem(equippedItemsId[i]);
		} 	
	}
}

function ACS_EquipCloak()
{
	var itemIds 				: array<SItemUniqueId>;
	var i 						: int;

	thePlayer.GetInventory().GetAllItems( itemIds );

	for( i = 0; i < itemIds.Size() ; i+=1 )
	{
		if( thePlayer.GetInventory().ItemHasTag( itemIds[i], 'Unequipped_By_ACS' ) )
		{
			thePlayer.EquipItem(itemIds[i]);

			thePlayer.GetInventory().RemoveItemTag( itemIds[i], 'Unequipped_By_ACS' );
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldHideWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom' 
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Caranthir_Staff'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'

	)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_ShouldHideWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
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

function ACS_Teleport_End_Early_Effects()
{
	if (thePlayer.HasTag('ACS_wildhunt_teleport_init'))
	{
		ACS_wh_teleport_entity().CreateAttachment(thePlayer);

		thePlayer.SoundEvent("magic_canaris_teleport_short");

		ACS_wh_teleport_entity().StopEffect('disappear');
		ACS_wh_teleport_entity().PlayEffectSingle('disappear');

		ACS_wh_teleport_entity().PlayEffectSingle('appear');

		ACS_wh_teleport_entity().DestroyAfter(1);

		thePlayer.RemoveTag('ACS_wildhunt_teleport_init');
	}

	if (thePlayer.HasTag('ACS_Mage_Teleport'))
	{
		thePlayer.PlayEffectSingle('teleport_in');
		thePlayer.StopEffect('teleport_in');

		thePlayer.RemoveTag('ACS_Mage_Teleport');
	}

	if (thePlayer.HasTag('ACS_Dolphin_Teleport'))
	{
		ACS_dolphin_teleport_entity().StopEffect('dolphin');
		ACS_dolphin_teleport_entity().PlayEffectSingle('dolphin');

		thePlayer.SoundEvent('monster_water_mage_combat_spray');

		ACS_dolphin_teleport_entity().DestroyAfter(5);

		thePlayer.RemoveTag('ACS_Dolphin_Teleport');
	}

	if (thePlayer.HasTag('ACS_Iris_Teleport'))
	{
		thePlayer.PlayEffectSingle('ethereal_buff');

		thePlayer.StopEffect('ethereal_buff');

		thePlayer.StopEffect('special_attack_fx');

		thePlayer.SoundEvent('magic_olgierd_tele');

		if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
		&& !thePlayer.HasTag('blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		ACS_Marker_Smoke();

		thePlayer.RemoveTag('ACS_Iris_Teleport');
	}

	if (thePlayer.HasTag('ACS_Explosion_Teleport'))
	{
		ACS_explosion_teleport_entity().CreateAttachment(thePlayer);

		ACS_explosion_teleport_entity().StopEffect('smoke_explosion');
		ACS_explosion_teleport_entity().PlayEffectSingle('smoke_explosion');

		ACS_explosion_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Explosion_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fountain_Portal_Teleport'))
	{
		ACS_fountain_portal_teleport_entity().StopEffect('portal');
		ACS_fountain_portal_teleport_entity().PlayEffectSingle('portal');

		thePlayer.SoundEvent('magic_geralt_teleport');

		ACS_fountain_portal_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Fountain_Portal_Teleport');
	}

	if ( thePlayer.HasTag('ACS_Lightning_Teleport') )
	{
		ACS_lightning_teleport_entity().CreateAttachment(thePlayer);

		ACS_Marker_Lightning();

		//ACS_lightning_teleport_entity().StopEffect('lightning');
		//ACS_lightning_teleport_entity().PlayEffectSingle('lightning');

		//ACS_lightning_teleport_entity().StopEffect('pre_lightning');
		//ACS_lightning_teleport_entity().PlayEffectSingle('pre_lightning');

		ACS_Giant_Lightning_Strike_Mult();

		ACS_lightning_teleport_entity().StopEffect('lighgtning');
		ACS_lightning_teleport_entity().PlayEffectSingle('lighgtning');

		thePlayer.SoundEvent('fx_other_lightning_hit');

		thePlayer.PlayEffectSingle('hit_lightning');
		thePlayer.StopEffect('hit_lightning');

		ACS_lightning_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Lightning_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fire_Teleport'))
	{
		ACS_Marker_Fire();

		thePlayer.PlayEffectSingle( 'lugos_vision_burning' );
		thePlayer.StopEffect( 'lugos_vision_burning' );

		thePlayer.SoundEvent('monster_dracolizard_combat_fireball_hit');

		thePlayer.RemoveTag('ACS_Fire_Teleport');
	}
}

function ACS_ThingsThatShouldBeRemoved_BASE_ALT()
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	GetACSWatcher().RemoveDefaltSwordWalkCancel();

	if (thePlayer.HasTag('ACS_IsSwordWalkingFinished'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalkingFinished');
	}

	GetWitcherPlayer().GetSignEntity(ST_Axii).OnSignAborted(true);

	thePlayer.RemoveTag('ACS_Griffin_Special_Attack');

	thePlayer.RemoveTag('ACS_Manticore_Special_Attack');

	thePlayer.RemoveTag('ACS_Bear_Special_Attack');	

	thePlayer.RemoveTag('ACS_Viper_Special_Attack');

	//GetWitcherPlayer().GetSignEntity(ST_Aard).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Yrden).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Igni).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Quen).OnSignAborted(true);

	//GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');

	/*
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}
	*/

	//thePlayer.CancelHoldAttacks();

	thePlayer.StopEffect('hand_special_fx');

	thePlayer.StopEffect('special_attack_fx');

	thePlayer.StopEffect('ethereal_debuff');

	thePlayer.StopEffect('shout');

	if (!thePlayer.HasTag('ACS_Camo_Active'))
	{
		thePlayer.StopEffect( 'shadowdash' );
	}

	ACS_Teleport_End_Early_Effects();

	ACS_RemoveStabbedEntities(); ACS_Theft_Prevention_9 ();

	//GetACSWatcher().RemoveTimer('ACS_ShootBowMoving'); 

	//GetACSWatcher().RemoveTimer('ACS_ShootBowStationary'); 

	//GetACSWatcher().RemoveTimer('ACS_ShootBowToIdle'); 

	//GetACSWatcher().PlayBowAnim_Reset();

	//GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_Blood_Spray'); 

	//GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer_attack');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer_slideback');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer');

	//GetACSWatcher().RemoveTimer('ACS_alive_check');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	if( thePlayer.IsAlive()) 
	{
		//thePlayer.ClearAnimationSpeedMultipliers(); 
	
		GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation'); 

		GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');
	
	}

	if ( !ACS_Transformation_Activated_Check() )
	{
		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
	}

	/*
	thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

	thePlayer.SetCanPlayHitAnim(true); 

	thePlayer.EnableCharacterCollisions(true); 
	thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
	thePlayer.SetIsCurrentlyDodging(false);
	*/
}

function ACS_ThingsThatShouldBeRemoved_ALT()
{
	ACS_ThingsThatShouldBeRemoved_BASE_ALT();

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

function ACS_ThingsThatShouldBeRemoved_BASE()
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	GetACSWatcher().RemoveDefaltSwordWalkCancel();

	if (thePlayer.HasTag('ACS_IsSwordWalkingFinished'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalkingFinished');
	}

	GetWitcherPlayer().GetSignEntity(ST_Axii).OnSignAborted(true);

	thePlayer.RemoveTag('ACS_Griffin_Special_Attack');

	thePlayer.RemoveTag('ACS_Manticore_Special_Attack');

	thePlayer.RemoveTag('ACS_Bear_Special_Attack');

	thePlayer.RemoveTag('ACS_Viper_Special_Attack');

	//GetWitcherPlayer().GetSignEntity(ST_Aard).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Yrden).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Igni).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Quen).OnSignAborted(true);

	//GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');

	/*
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}
	*/

	//thePlayer.CancelHoldAttacks();

	thePlayer.StopEffect('hand_special_fx');

	thePlayer.StopEffect('special_attack_fx');

	thePlayer.StopEffect('ethereal_debuff');

	thePlayer.StopEffect('shout');

	if (!thePlayer.HasTag('ACS_Camo_Active'))
	{
		thePlayer.StopEffect( 'shadowdash' );
	}

	ACS_Teleport_End_Early_Effects();

	ACS_RemoveStabbedEntities(); ACS_Theft_Prevention_9 ();

	GetACSWatcher().RemoveTimer('ACS_ShootBowMoving'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowStationary'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowToIdle'); 

	GetACSWatcher().PlayBowAnim_Reset();

	GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_Blood_Spray'); 

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_attack');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_slideback');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer');

	GetACSWatcher().RemoveTimer('ACS_alive_check');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	if( thePlayer.IsAlive()) 
	{
		thePlayer.ClearAnimationSpeedMultipliers(); 
	
		GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation'); 

		GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');
	
	}

	if ( !ACS_Transformation_Activated_Check() )
	{
		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
	}	 

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
	ACS_ThingsThatShouldBeRemoved_BASE_ALT(); ACS_Theft_Prevention_6 ();

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

	actors.Clear();

	actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed');
		
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].BreakAttachment();
		actors[i].RemoveTag('ACS_Stabbed');
	}
}

function ACS_Pre_Attack( animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo  )
{
	var attackName     		: name;

	attackName = data.attackName;

	if (animEventName == 'AttackLight' || data.attackName == 'attack_light' || data.attackName == 'AttackLight')
	{
		ACS_Light_Attack_Trail();
	}
	else if (animEventName == 'AttackHeavy' || data.attackName == 'attack_heavy' || data.attackName == 'AttackHeavy' )
	{
		ACS_Heavy_Attack_Trail();
	}

	if(thePlayer.HasTag('quen_sword_equipped'))
	{
		//thePlayer.SoundEvent('g_clothes_step_hard');
		//thePlayer.SoundEvent('grunt_vo_attack_medium');
	}

	if (ACS_GetItem_Aerondight())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Equipped_Check())
		{
			GetACSWatcher().aerondight_sword_trail();
		}
	}

	if (ACS_GetItem_Iris())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Equipped_Check())
		{
			GetACSWatcher().iris_sword_trail();
		}
	}

	if (ACS_Zireael_Check())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			GetACSWatcher().ciri_sword_trail();

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
				ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');
			}
		}
	}

	if (ACS_Griffin_School_Check()
	&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if (ACS_Manticore_School_Check()
	&& thePlayer.HasTag('ACS_Manticore_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if (ACS_Viper_School_Check()
	&& thePlayer.HasTag('ACS_Viper_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if( thePlayer.HasAbility('Runeword 2 _Stats', true) && thePlayer.IsInCombat() )
	{
		ACS_Light_Attack_Extended_Trail();
		//ACS_Heavy_Attack_Extended_Trail();
	}

	if(thePlayer.HasTag('aard_sword_equipped'))
	{
		ACSGetEquippedSword().StopAllEffects();
	}

	if (ACS_Armor_Equipped_Check())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			//GetACSWatcher().ACS_Armor_Weapon_Whoosh();

			ACS_Armor_Cone();

			GetACSWatcher().ACS_Armor_Ether_Sword_Trail();

			//GetACSArmorEtherSword().StopEffect('fire_sparks_trail');
			//GetACSArmorEtherSword().PlayEffectSingle('fire_sparks_trail');

			GetACSArmorEtherSword().StopEffect('special_attack_iris');
			GetACSArmorEtherSword().PlayEffectSingle('special_attack_iris');

			GetACSArmorEtherSword().StopEffect('red_fast_attack_buff');
			GetACSArmorEtherSword().PlayEffectSingle('red_fast_attack_buff');

			GetACSArmorEtherSword().StopEffect('red_fast_attack_buff_hit');
			GetACSArmorEtherSword().PlayEffectSingle('red_fast_attack_buff_hit');

			if( thePlayer.IsDoingSpecialAttack(false)
			&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
			)
			{
				GetACSWatcher().Red_Blade_Projectile_Spawner();
				
				GetACSWatcher().ACS_SlowMo();
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_PlayerHitEffects()
{
	//thePlayer.StopAllEffects(); 
	
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2 )
	{
		if (thePlayer.HasTag('axii_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
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

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
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

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
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

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
}

function ACS_AttitudeCheck( actor : CActor ) : bool
{
	var targetDistance 										: float;

	targetDistance = VecDistanceSquared2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

	if ( 
	(thePlayer.GetAttitude( actor ) == AIA_Hostile 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Hostile
	|| (actor.IsAttackableByPlayer() && actor.IsTargetableByPlayer()))
	&& actor.IsAlive()
	&& targetDistance <= 15 * 15
	)
	{
		return true;
	}
	else if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly
	|| !actor.IsAlive()
	|| actor == thePlayer
	|| targetDistance > 15 * 15
	)
	{
		return false;
	}

	return false;
}

function ACS_DistCheck( actor : CActor ) : bool
{
	var targetDistance 										: float;

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;

	if ( targetDistance <= 15 * 15 )
	{
		return true;
	}
	else if ( targetDistance > 15 * 15 )
	{
		return false;
	}

	return false;
}

function ACS_NoticeboardCheck (radius_check: float): bool 
{
    var entities: array<CGameplayEntity>;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 1, , FLAG_ExcludePlayer, , 'W3NoticeBoard');

    return entities.Size()>0;
}
  
function ACS_GuardCheck (radius_check: float): bool 
{
	var entities: array<CGameplayEntity>;
    var i: int;

	entities.Clear();

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

function ACS_SCAAR_1_Installed()
{
	return;
}

function ACS_SCAAR_2_Installed()
{
	return;
}

function ACS_SCAAR_3_Installed()
{
	return;
}

function ACS_Theft_Prevention_7()
{
	return;
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
		var l_effectComponent		: W3AerondightFXComponent;
		
		thePlayer.GetInventory().GetCurrentlyHeldSwordEntity( l_aerondightEnt );	

		l_effectComponent = (W3AerondightFXComponent)l_aerondightEnt.GetComponentByClassName( 'W3AerondightFXComponent' );
		
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

function ACS_SCAAR_4_Installed()
{
	return;
}

function ACS_SCAAR_5_Installed()
{
	return;
}

function ACS_SCAAR_6_Installed()
{
	return;
}

function ACS_Theft_Prevention_6()
{
	return;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ExplorationDelayHack()
{
	if( !thePlayer.IsInCombat() )
	{
		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}

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
	if ( thePlayer.HasTag('ACS_ExplorationDelayTag') || thePlayer.IsGuarded() || thePlayer.IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5 )
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
	if (thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
	{
		thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
	}
	
	if (!thePlayer.HasTag('igni_sword_equipped_TAG'))
	{
		thePlayer.AddTag('igni_sword_equipped_TAG');	
	}
	
	thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
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
		if (thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			thePlayer.AddTag('igni_sword_equipped_TAG');	
		}

		GetACSWatcher().RemoveTimer('DefaltSwordWalk');

		thePlayer.RemoveTag('ACS_IsSwordWalking');

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


function ACS_Setup_Combat_Action_Heavy()
{
	if (thePlayer.HasTag('igni_sword_equipped_TAG'))
	{
		thePlayer.RemoveTag('igni_sword_equipped_TAG');	
	}
	
	if (!thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
	{
		thePlayer.AddTag('igni_secondary_sword_equipped_TAG');	
	}

	thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
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
		GetACSWatcher().RemoveTimer('DefaltSwordWalk');

		thePlayer.RemoveTag('ACS_IsSwordWalking');

		if (thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('igni_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.AddTag('igni_secondary_sword_equipped_TAG');	
		}

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Setup_Combat_Action_CastSign
{
    function Setup_Combat_Action_CastSign_Engage()
	{
		this.PushState('Setup_Combat_Action_CastSign_Engage');
	}
}

state Setup_Combat_Action_CastSign_Engage in cACS_Setup_Combat_Action_CastSign
{	
	event OnEnterState(prevStateName : name)
	{
		CastSign_Entry();
	}
	
	entry function CastSign_Entry()
	{	
		CastSign_Latent();
	}
	
	latent function CastSign_Latent()
	{
		GetACSWatcher().DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_CastSign, BS_Pressed );
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

exec function ACS_aniplay(animation_name: name)
{
	thePlayer.ActionPlaySlotAnimationAsync('PLAYER_SLOT',animation_name, 0.1, 1, false);
}

exec function ACS_aniplay1(animation_name: name)
{	
	thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( animation_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
}

exec function ACS_aniplay2(animation_name: name)
{	
	thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( animation_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.0625, 0.0625) );
}

exec function ACS_ParryTest()
{
	//thePlayer.SetBehaviorVariable( 'parryType', fv );
	thePlayer.RaiseForceEvent( 'PerformParry' );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function ACS_spawn( entity_name: name)
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
	else if (entity_name == 'turret')
	{
		ACS_Forest_God_Adds_1_Spawner();
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
	
	ACS_Forest_God_Shadows_Destroy();

	vACS_Forest_God_Spawner.ACS_Forest_God_Shadows_Spawner_Engage();
}

function ACS_Forest_God_Shadows_Destroy()
{	
	var shadows 										: array<CActor>;
	var i												: int;
	
	shadows.Clear();

	theGame.GetActorsByTag( 'ACS_Forest_God_Shadows', shadows );	
	
	for( i = 0; i < shadows.Size(); i += 1 )
	{
		shadows[i].Destroy();
	}
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
	private var rot																: EulerAngles;
		
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

		if( thePlayer.GetStat( BCS_Vitality ) <= thePlayer.GetStatMax(BCS_Vitality)/2 ) 
		{	
			count = 1;
		}
		else if( thePlayer.GetStat( BCS_Vitality ) == thePlayer.GetStatMax(BCS_Vitality) ) 
		{
			count = 2;
		}
		else
		{
			count = 1;
		}
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 0.65;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 3 );

			((CActor)ent).GetInventory().AddAnItem( 'Leshy mutagen', 1 );

			((CNewNPC)ent).SetLevel( thePlayer.GetLevel() - 15 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).AddBuffImmunity_AllNegative('ACS_Forest_God_Shadows', true);

			((CActor)ent).AddBuffImmunity_AllCritical('ACS_Forest_God_Shadows', true);

			((CActor)ent).EnableCharacterCollisions(false);

			((CActor)ent).SetUnpushableTarget(thePlayer);

			((CActor)ent).PlayEffect('demonic_possession');

			if (count == 2)
			{
				((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/2);
			}

			((CActor)ent).RemoveBuffImmunity(EET_Slowdown);

			((CActor)ent).RemoveBuffImmunity(EET_Paralyzed);

			((CActor)ent).RemoveBuffImmunity(EET_Stagger);

			ent.AddTag( 'ACS_Forest_God_Shadows' );

			ent.AddTag( 'ContractTarget' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACSForestGodShadow() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God_Shadows' );
	return entity;
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
	private var rot																: EulerAngles;
		
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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );
			
			((CNewNPC)ent).SetLevel( 5 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(ACS_Forest_God(), AIA_Friendly);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/4);
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
	private var rot																: EulerAngles;
		
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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );
			
			((CNewNPC)ent).SetLevel( 5 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(ACS_Forest_God(), AIA_Friendly);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.5);

			((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/4);
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
	private var rot																: EulerAngles;
		
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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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
	private var rot																: EulerAngles;
		
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
			//spawnPos = Vector(240.237564, 1508.216187, 19.352640, 1);

			spawnPos = Vector(2222.130859, 65.340538, 3.541907, 1);

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

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

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

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

function ACS_Ice_Titans_Static_Spawner()
{
	var vACS_Ice_Titans_Static_Spawner : cACS_Ice_Titans_Static_Spawner;

	vACS_Ice_Titans_Static_Spawner = new cACS_Ice_Titans_Static_Spawner in theGame;

	ACS_Ice_Titan_Destroy();

	vACS_Ice_Titans_Static_Spawner.ACS_Ice_Titans_Static_Spawner_Engage();
}

statemachine class cACS_Ice_Titans_Static_Spawner
{
	function ACS_Ice_Titans_Static_Spawner_Engage()
	{
		this.PushState('ACS_Ice_Titans_Static_Spawner_Engage');
	}
}

state ACS_Ice_Titans_Static_Spawner_Engage in cACS_Ice_Titans_Static_Spawner
{
	private var temp_1, temp_2, temp_3																													: CEntityTemplate;
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, ent_8, ent_9																			: CEntity;
	private var i, count																																: int;
	private var playerPos, spawnPos_1 , spawnPos_2 , spawnPos_3 , spawnPos_4 , spawnPos_5 , spawnPos_6 , spawnPos_7 , spawnPos_8 , spawnPos_9			: Vector;
	private var randAngle, randRange																													: float;
	private var meshcomp																																: CComponent;
	private var animcomp 																																: CAnimatedComponent;
	private var h 																																		: float;
	private var gasEntity																																: W3ToxicCloud;
	private var weapon_names, armor_names																												: array<CName>;
	private var currWorld 																																: CWorld;
	private var rot																																		: EulerAngles;
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

	latent function Static_Spawn_Latent()
	{
		currWorld = theGame.GetWorld();

		temp_1 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ice_giant_2.w2ent"
		
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ice_giant_3.w2ent"
		
		, true );

		if ((currWorld.GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			spawnPos_1 = Vector(-321.784027, -117.463120, 23.569407, 1);

			spawnPos_2 = Vector(-2565.660889, -1334.807983, 8.729300, 1);

			spawnPos_3 = Vector(-2411.800537, -733.482727, 0.528175, 1);

			spawnPos_4 = Vector(-217.916077, -1965.651978, 0.149090, 1);

			spawnPos_5 = Vector(2325.307129, 630.480408, 1.681702, 1);

			spawnPos_6 = Vector(1495.861328, 1156.037598, 0.594969, 1);

			spawnPos_7 = Vector(335.897614, 1542.949951, 2.687820, 1);

			spawnPos_8 = Vector(-1032.823975, 2006.107666, 0.313784, 1);

			spawnPos_9 = Vector(-377.889740, 2108.553955, 0.941095, 1);

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_1, 0.5f, 20.f, spawnPos_1);
			
			ent_1 = theGame.CreateEntity( temp_1, TraceFloor(spawnPos_1), rot );

			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_1).SetLevel(75);
			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_1).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_1).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_1).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_1).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_1).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_1).AddTag( 'ContractTarget' );

			((CActor)ent_1).AddTag('IsBoss');

			((CActor)ent_1).AddAbility('Boss');

			((CActor)ent_1).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_1).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_1).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_1.PlayEffectSingle('demonic_possession');

			ent_1.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_2, 0.5f, 20.f, spawnPos_2);
			
			ent_2 = theGame.CreateEntity( temp_2, TraceFloor(spawnPos_2), rot );

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(75);
			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_2).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_2).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_2).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_2).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_2).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_2).AddTag( 'ContractTarget' );

			((CActor)ent_2).AddTag('IsBoss');

			((CActor)ent_2).AddAbility('Boss');

			((CActor)ent_2).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_2).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_2).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_2.PlayEffectSingle('demonic_possession');

			ent_2.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_2, 0.5f, 20.f, spawnPos_2);
			
			ent_3 = theGame.CreateEntity( temp_3, TraceFloor(spawnPos_3), rot );

			animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_3.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_3).SetLevel(75);
			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_3).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_3).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_3).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_3).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_3).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_3).AddTag( 'ContractTarget' );

			((CActor)ent_3).AddTag('IsBoss');

			((CActor)ent_3).AddAbility('Boss');

			((CActor)ent_3).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_3).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_3).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_3.PlayEffectSingle('demonic_possession');

			ent_3.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_4, 0.5f, 20.f, spawnPos_4);
			
			ent_4 = theGame.CreateEntity( temp_1, TraceFloor(spawnPos_4), rot );

			animcomp = (CAnimatedComponent)ent_4.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_4.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_4).SetLevel(75);
			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_4).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_4).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_4).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_4).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_4).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_4).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_4).AddTag( 'ContractTarget' );

			((CActor)ent_4).AddTag('IsBoss');

			((CActor)ent_4).AddAbility('Boss');

			((CActor)ent_4).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_4).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_4).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_4.PlayEffectSingle('demonic_possession');

			ent_4.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_5, 0.5f, 20.f, spawnPos_5);
			
			ent_5 = theGame.CreateEntity( temp_2, TraceFloor(spawnPos_5), rot );

			animcomp = (CAnimatedComponent)ent_5.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_5.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_5).SetLevel(75);
			((CNewNPC)ent_5).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_5).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_5).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_5).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_5).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_5).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_5).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_5).AddTag( 'ContractTarget' );

			((CActor)ent_5).AddTag('IsBoss');

			((CActor)ent_5).AddAbility('Boss');

			((CActor)ent_5).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_5).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_5).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_5.PlayEffectSingle('demonic_possession');

			ent_5.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_6, 0.5f, 20.f, spawnPos_6);
			
			ent_6 = theGame.CreateEntity( temp_3, TraceFloor(spawnPos_6), rot );

			animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_6.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_6).SetLevel(75);
			((CNewNPC)ent_6).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_6).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_6).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_6).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_6).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_6).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_6).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_6).AddTag( 'ContractTarget' );

			((CActor)ent_6).AddTag('IsBoss');

			((CActor)ent_6).AddAbility('Boss');

			((CActor)ent_6).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_6).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_6).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_6.PlayEffectSingle('demonic_possession');

			ent_6.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_7, 0.5f, 20.f, spawnPos_7);
			
			ent_7 = theGame.CreateEntity( temp_1, TraceFloor(spawnPos_7), rot );

			animcomp = (CAnimatedComponent)ent_7.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_7.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_7).SetLevel(75);
			((CNewNPC)ent_7).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_7).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_7).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_7).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_7).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_7).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_7).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_7).AddTag( 'ContractTarget' );

			((CActor)ent_7).AddTag('IsBoss');

			((CActor)ent_7).AddAbility('Boss');

			((CActor)ent_7).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_7).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_7).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_7.PlayEffectSingle('demonic_possession');

			ent_7.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_8, 0.5f, 20.f, spawnPos_8);
			
			ent_8 = theGame.CreateEntity( temp_2, TraceFloor(spawnPos_8), rot );

			animcomp = (CAnimatedComponent)ent_8.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_8.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_8).SetLevel(75);
			((CNewNPC)ent_8).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_8).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_8).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_8).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_8).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_8).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_8).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_8).AddTag( 'ContractTarget' );

			((CActor)ent_8).AddTag('IsBoss');

			((CActor)ent_8).AddAbility('Boss');

			((CActor)ent_8).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_8).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_8).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_8.PlayEffectSingle('demonic_possession');

			ent_8.PlayEffect('ice');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos_9, 0.5f, 20.f, spawnPos_9);
			
			ent_9 = theGame.CreateEntity( temp_3, TraceFloor(spawnPos_9), rot );

			animcomp = (CAnimatedComponent)ent_9.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_9.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_9).SetLevel(75);
			((CNewNPC)ent_9).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_9).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_9).SetAnimationSpeedMultiplier(0.75);

			((CActor)ent_9).GetInventory().AddAnItem( 'Crowns', 2500 );

			((CActor)ent_9).GetInventory().AddAnItem( 'Diamond flawless', 10 );

			((CActor)ent_9).AddTag( 'ACS_Ice_Titan' );

			((CActor)ent_9).AddTag( 'ACS_Big_Boi' );

			((CActor)ent_9).AddTag( 'ContractTarget' );

			((CActor)ent_9).AddTag('IsBoss');

			((CActor)ent_9).AddAbility('Boss');

			((CActor)ent_9).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan', true);

			((CActor)ent_9).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan', true);

			((CActor)ent_9).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan', true);

			ent_9.PlayEffectSingle('demonic_possession');

			ent_9.PlayEffect('ice');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Ice_Titan_Destroy()
{	
	var titan 											: array<CActor>;
	var i												: int;
	
	titan.Clear();

	theGame.GetActorsByTag( 'ACS_Ice_Titan', titan );	
	
	for( i = 0; i < titan.Size(); i += 1 )
	{
		titan[i].Destroy();
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawner()
{
	var vACS_Spawner : cACS_Spawner;
	var vW3ACSWatcher	: W3ACSWatcher;

	vACS_Spawner = new cACS_Spawner in vW3ACSWatcher;
			
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
	private var temp, anchor_temp, ent_1_temp									: CEntityTemplate;
	private var ent, anchor, ent_1												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot										: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		Spawn_Latent();
	}
	
	/*
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

			//"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\treant.w2ent"

			//"quests\part_1\quest_files\q202_giant\characters\q202_ice_giant.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"

			//"dlc\ep1\data\characters\npc_entities\monsters\ethernal.w2ent"

			//"dlc\ep1\data\quests\main_npcs\olgierd.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\shadow_wolf.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
			//"dlc\dlc_acs\data\entities\monsters\nekker_nekker.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_evil_spirit.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_plague_victim_axe_hostile.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_witcher.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\entities\mq1060_glow_roots_large.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\spiral_endrega.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"

			"characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent"

			//"characters\npc_entities\monsters\_quest__endriaga_spiral.w2ent"
			
			, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 100;
			
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
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CNewNPC)ent).EnableCharacterCollisions(false);
			((CActor)ent).EnableCharacterCollisions(false);


			ent.PlayEffect('spikes');

			((CNewNPC)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'head' ), bone_vec, bone_rot );

			anchor_temp = (CEntityTemplate)LoadResourceAsync( 
						
				"dlc\dlc_acs\data\entities\other\fx_ent.w2ent"
				
				, true );

			anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -10 ) );

			anchor.AddTag('acs_spiral_echinops_anchor');

			//anchor.CreateAttachmentAtBoneWS( ((CNewNPC)ent), 'head', bone_vec, bone_rot );

			anchor.CreateAttachment( ent );

			((CActor)anchor).EnableCollisions(false);
			((CActor)anchor).EnableCharacterCollisions(false);


			ent_1_temp = (CEntityTemplate)LoadResourceAsync( 

				//"dlc\dlc_acs\data\entities\monsters\endrega_echinops_turret.w2ent"

				//"dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent"

				//"dlc\dlc_acs\data\entities\monsters\spiral_endrega.w2ent"

				//"characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent"

				//"characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent"

				"characters\npc_entities\monsters\_quest__endriaga_spiral.w2ent"
				
				, true );


			ent_1 = theGame.CreateEntity( ent_1_temp, ent.GetWorldPosition(), ent.GetWorldRotation() );

			ent_1.AddTag('ACS_spiral_echinops_1');

			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent_1).SetAttitude((CNewNPC)ent, AIA_Friendly);

			((CNewNPC)ent).SetAttitude((CNewNPC)ent_1, AIA_Friendly);

			//((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
			((CNewNPC)ent_1).EnableCharacterCollisions(false);
			((CNewNPC)ent_1).EnableCollisions(false);
			//((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			//((CActor)ent_1).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
			((CActor)ent_1).EnableCollisions(false);
			((CActor)ent_1).EnableCharacterCollisions(false);
			//((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );


			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 1;
			attach_vec.Z = 0;

			ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );

			//ent.PlayEffect('ice');

			//ent.PlayEffectSingle('appear');
			//ent.StopEffect('appear');
			//ent.PlayEffectSingle('shadow_form');
			//ent.PlayEffectSingle('demonic_possession');

			//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
			//((CActor)ent).AddAbility( 'EtherealActive' );

			((CActor)ent).RemoveBuffImmunity( EET_Stagger );
			((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

			//ent.PlayEffect('special_attack_fx');

			ent.AddTag( 'ACS_enemy' );
			//ent.AddTag( 'ACS_Big_Boi' );
		}
	}
	*/

	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

			//"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\treant.w2ent"

			//"quests\part_1\quest_files\q202_giant\characters\q202_ice_giant.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"

			//"dlc\ep1\data\characters\npc_entities\monsters\ethernal.w2ent"

			//"dlc\ep1\data\quests\main_npcs\olgierd.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\shadow_wolf.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
			//"dlc\dlc_acs\data\entities\monsters\nekker_nekker.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_evil_spirit.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_plague_victim_axe_hostile.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_witcher.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\entities\mq1060_glow_roots_large.w2ent"

			"characters\npc_entities\monsters\burnedman_lvl1.w2ent"
			
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

			rot = thePlayer.GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);
			
			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(100);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//ent.PlayEffect('ice');

			//ent.PlayEffectSingle('appear');
			//ent.StopEffect('appear');
			//ent.PlayEffectSingle('shadow_form');
			//ent.PlayEffectSingle('demonic_possession');

			//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
			//((CActor)ent).AddAbility( 'EtherealActive' );

			((CActor)ent).RemoveBuffImmunity( EET_Stagger );
			((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

			//ent.PlayEffect('special_attack_fx');

			ent.AddTag( 'ACS_enemy' );
			//ent.AddTag( 'ACS_Big_Boi' );

			SleepOneFrame();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSEnemy() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_enemy' );
	return entity;
}

function GetACSEnemyDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_enemy', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
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

		ACS_Toxic_Gas_Destroy();

		ACS_Get_Toxic_Gas().Destroy();
			
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

function ACS_Get_Toxic_Gas() : W3ToxicCloud
{
	var gas 			 : W3ToxicCloud;
	
	gas = (W3ToxicCloud)theGame.GetEntityByTag( 'ACS_Toxic_Gas' );
	return gas;
}

function ACS_Toxic_Gas_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Toxic_Gas', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function ACS_peffect(enam : CName)
{
	thePlayer.StopAllEffects();
	thePlayer.PlayEffectSingle(enam);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function ACS_fallup()
{	
	thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_idle_sign_aard_light', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );

	GetACSWatcher().AddTimer('ACS_Fall_Up_Timer', 1, false);
}

exec function ACS_eforceani(animation_name: name)
{
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;
	
	actor = (CActor)( thePlayer.GetDisplayTarget() );
	
	enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
	
	enemyAnimatedComponent.PlaySlotAnimationAsync( animation_name, 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
}

function ACS_ForceAni(npc: CActor, animation_name: name)
{
	var enemyAnimatedComponent 			: CAnimatedComponent;
	
	enemyAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );		
	
	enemyAnimatedComponent.PlaySlotAnimationAsync( animation_name, 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
}

exec function ACS_eforcebeh(i: int)
{
	var vACS_EnemyBehSwitch : cACS_EnemyBehSwitch_Test;
	vACS_EnemyBehSwitch = new cACS_EnemyBehSwitch_Test in theGame;
	
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
	else if (i == 6)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Dettlaff();
	}
}

function ACS_EnemyBehSwitch(i: int)
{
	var vACS_EnemyBehSwitch : cACS_EnemyBehSwitch_Test;
	vACS_EnemyBehSwitch = new cACS_EnemyBehSwitch_Test in theGame;
	
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
	else if (i == 6)
	{	
		vACS_EnemyBehSwitch.EnemyBehSwitch_Dettlaff();
	}
}

statemachine class cACS_EnemyBehSwitch_Test
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

	function EnemyBehSwitch_Dettlaff()
	{
		this.PushState('EnemyBehSwitch_Dettlaff');
	}
}
 
state EnemyBehSwitch_Sword1h in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword1h();
	}
	
	entry function EnemyBehSwitch_sword1h()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.DetachBehavior('sword_2handed');
				//actor.DetachBehavior('Fistfight');
				//actor.DetachBehavior('Witcher');
				//actor.DetachBehavior( 'Shield' );
				//actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'sword_1handed' );

				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				//enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				//actor.ActionPlaySlotAnimationAsync('NPC_ANIM_SLOT','', 0.1, 1, false);
			}
		}
	}
}

state EnemyBehSwitch_Sword2h in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var sword					: SItemUniqueId;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword2h();
	}
	
	entry function EnemyBehSwitch_sword2h()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.GetInventory().RemoveAllItems();

				//actor.GetInventory().AddAnItem( 'NPC Gregoire Sword', 1 );

				//sword = actor.GetInventory().GetItemId('NPC Gregoire Sword');

				//actor.EquipItem(sword, r_weapon, true );

				//actor.DrawWeaponAndAttackLatent(sword);

				//actor.ActivateAndSyncBehavior( 'sword_2handed' );

				//actor.DetachBehavior('sword_2handed');
				//actor.DetachBehavior('Fistfight');
				//actor.DetachBehavior('Witcher');
				//actor.DetachBehavior( 'Shield' );
				//actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'sword_2handed' );

				//actor.DrawWeaponAndAttackLatent(sword);

				//enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				//actor.ActionPlaySlotAnimationAsync('NPC_ANIM_SLOT','', 0.1, 1, false);

				//actor.ActionCancelAll();

				//actor.SignalGameplayEvent( 'PersonalTauntAction' );
			}
		}
	}
}

state EnemyBehSwitch_Fistfight in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_fistfight();
	}
	
	entry function EnemyBehSwitch_fistfight()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.DetachBehavior('sword_2handed');
				//actor.DetachBehavior('Fistfight');
				//actor.DetachBehavior('Witcher');
				//actor.DetachBehavior( 'Shield' );
				//actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'Fistfight' );
			}
		}
	}
}

state EnemyBehSwitch_Witcher in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_witcher();
	}
	
	entry function EnemyBehSwitch_witcher()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.DetachBehavior('sword_2handed');
				//actor.DetachBehavior('Fistfight');
				//actor.DetachBehavior('Witcher');
				//actor.DetachBehavior( 'Shield' );
				//actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'Witcher' );

				//enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				//actor.ActionPlaySlotAnimationAsync('NPC_ANIM_SLOT','', 0.1, 1, false);
			}
		}
	}
}

state EnemyBehSwitch_Shield in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_shield();
	}
	
	entry function EnemyBehSwitch_shield()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				//actor.DetachBehavior('sword_2handed');
				//actor.DetachBehavior('Fistfight');
				//actor.DetachBehavior('Witcher');
				//actor.DetachBehavior( 'Shield' );
				//actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'Shield' );

				//enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				//actor.ActionPlaySlotAnimationAsync('NPC_ANIM_SLOT','', 0.1, 1, false);
			}
		}
	}
}

state EnemyBehSwitch_Bow in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_bow();
	}
	
	entry function EnemyBehSwitch_bow()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				actor.DetachBehavior('sword_2handed');
				actor.DetachBehavior('Fistfight');
				actor.DetachBehavior('Witcher');
				actor.DetachBehavior( 'Shield' );
				actor.DetachBehavior( 'sword_1handed' );

				actor.AttachBehavior( 'Bow' );

				//enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				//actor.ActionPlaySlotAnimationAsync('NPC_ANIM_SLOT','', 0.1, 1, false);
			}
		}
	}
}

state EnemyBehSwitch_Dettlaff in cACS_EnemyBehSwitch_Test
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var a_comp					: CComponent;
	private var claw_temp				: CEntityTemplate;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_dettlaff();
	}
	
	entry function EnemyBehSwitch_dettlaff()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (!actor.HasTag('ACS_Swapped_To_Vampire'))
				{
					(actor.GetInventory().GetItemEntityUnsafe( actor.GetInventory().GetItemFromSlot( 'r_weapon' ) )).SetHideInGame(true);

					a_comp = actor.GetComponentByClassName( 'CAppearanceComponent' );

					claw_temp = (CEntityTemplate)LoadResource(
					"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent"
					, true);	
					
					((CAppearanceComponent)a_comp).IncludeAppearanceTemplate(claw_temp);

					actor.AddTag('ACS_Swapped_To_Vampire');

					actor.AttachBehavior( 'DettlaffVampire_ACS' );
				}
			}
		}
	}
}

exec function ACS_camerafxtest(effect_name:name)
{
	theGame.GetGameCamera().StopAllEffects();
	theGame.GetGameCamera().PlayEffect(effect_name);
}

exec function ACS_camerafxteststop()
{
	theGame.GetGameCamera().StopAllEffects();
}

exec function ACS_fxtest(effect_name:name)
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;

	//GetACSTestEnt.Destroy();

	GetACSTestEnt_Array_Destroy();

	rot = thePlayer.GetWorldRotation();
	//rot.Pitch += 180;

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
	//pos.Z += 60;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
		//"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"

		//"dlc\ep1\data\gameplay\abilities\mage\quick_sand_hit.w2ent"
		//"dlc\ep1\data\gameplay\abilities\mage\sand_trap.w2ent"
		//"dlc\ep1\data\gameplay\abilities\mage\sand_push_cast.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_tornado.w2ent"

		//"dlc\bob\data\fx\cutscenes\cs704_detlaff_morphs\cs704_detlaff_force.w2ent"

		//"fx\characters\eredin\eredin_shield\eredin_shield.w2ent"

		//"fx\cutscenes\kaer_morhen\403_triss_spell\triss_explode_cutscene.w2ent"

		//"fx\quest\q403\meteorite\fire_ground_strong.w2ent"

		//"gameplay\sonar\sonar_fx.w2ent"

		//"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"

		//"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_hut_fire.w2ent"

		//"dlc\ep1\data\fx\quest\q603\usm_demodwarf\q603_usm_explosion.w2ent"

		//"dlc\dlc_acs\data\fx\vulnerable_marker.w2ent"

		//"dlc\ep1\data\characters\npc_entities\monsters\toad.w2ent"

		//"dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent"

		//marker

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_monster_ground.w2ent"

		//"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"

		//"dlc\bob\data\fx\monsters\dettlaff\blast.w2ent"

		//"dlc\ep1\data\gameplay\abilities\mage\tornado.w2ent"

		//"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

		// "dlc\bob\data\fx\cutscenes\cs704_detlaff_morphs\cs704_detlaff_force.w2ent" //smoke_explosion
		//"dlc\ep1\data\fx\quest\q602\q602_17_wedding_finale\q602_scream.w2ent" //scream
		//"dlc\bob\data\fx\quest\q704\q704_13_fountain\q704_fairlytale_portal.w2ent" //portal

		//"dlc\dlc_acs\data\fx\guiding_light_marker.w2ent"

		//"fx\gameplay\throwing\ice_spikes_large.w2ent"

		"fx\gameplay\throwing\ice_spikes.w2ent"

		, true ), TraceFloor(pos), rot );

	ent.AddTag('ACS_Test_Ent');

	//ent.DestroyAfter(5);

	//animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	//meshcomp = ent.GetComponentByClassName('CMeshComponent');
	//h = 1;

	//animcomp.SetScale(Vector( 0, 0, 0, 1 ));

	//meshcomp.SetScale(Vector( 0, 0, 0, 1 ));	

	//ent.CreateAttachment( thePlayer, , Vector( 0, -7, 1.25 ), EulerAngles(0,0,0) );

	//ent.CreateAttachment( thePlayer, , Vector( 0, 0, 3.5 ), EulerAngles(0,0,0) );

	//ent.CreateAttachment( thePlayer, , Vector( 0, 0, -10 ), EulerAngles(0,0,0) );

	ent.PlayEffect(effect_name);
	//ent.PlayEffect(effect_name);
	//ent.PlayEffect(effect_name);
	//ent.PlayEffect(effect_name);
}

exec function ACS_toadme(i:int)
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec														: Vector;
	var bone_rot														: EulerAngles;
	var anchor_temp, ent_1_temp, ent_2_temp								: CEntityTemplate;

	GetACSToadTest_1().Destroy();

	GetACSToadTest_2().Destroy();

	GetACSToadTest_3().Destroy();

	GetToadAnchor().Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


	thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

	anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

	anchor.AddTag('toad_anchor');

	anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bone_vec, bone_rot );

	((CActor)anchor).EnableCollisions(false);
	((CActor)anchor).EnableCharacterCollisions(false);





	ent_1_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

	ent_2_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );





	ent_1 = theGame.CreateEntity( ent_1_temp, pos, rot );

	ent_1.AddTag('ACS_Toad_Test_1');

	((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_1).EnableCharacterCollisions(false);
	((CNewNPC)ent_1).EnableCollisions(false);
	((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_1).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_1).EnableCollisions(false);
	((CActor)ent_1).EnableCharacterCollisions(false);
	((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	thePlayer.EnableCharacterCollisions(false);

	animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = 90;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = -0.35;
	attach_vec.Y = -0.15;
	attach_vec.Z = 0;

	ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );


	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);




	ent_2 = theGame.CreateEntity( ent_2_temp, pos, rot );

	ent_2.AddTag('ACS_Toad_Test_2');

	((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_2).EnableCharacterCollisions(false);
	((CNewNPC)ent_2).EnableCollisions(false);
	((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_2).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_2).EnableCollisions(false);
	((CActor)ent_2).EnableCharacterCollisions(false);
	((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = -30;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = 0.275;
	attach_vec.Y = -0.15;
	attach_vec.Z = -0.4;

	ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);



	ent_3 = theGame.CreateEntity( ent_2_temp, pos, rot );

	ent_3.AddTag('ACS_Toad_Test_3');

	((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_3).EnableCharacterCollisions(false);
	((CNewNPC)ent_3).EnableCollisions(false);
	((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_3).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_3).EnableCollisions(false);
	((CActor)ent_3).EnableCharacterCollisions(false);
	((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = -150;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = 0.275;
	attach_vec.Y = -0.15;
	attach_vec.Z = 0.4;

	ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);











	//anchor.DestroyAfter(3);

	//ent_1.DestroyAfter(3);

	//ent_2.DestroyAfter(3);

	//ent_3.DestroyAfter(3);
}

function ACS_toadtest(i:int)
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var AnimSettings													: SAnimatedComponentSlotAnimationSettings;
	var h 																: float;
	var bone_vec														: Vector;
	var bone_rot														: EulerAngles;
	var anchor_temp, ent_1_temp, ent_2_temp								: CEntityTemplate;

	GetACSToadTest_1().Destroy();

	GetACSToadTest_2().Destroy();

	GetACSToadTest_3().Destroy();

	GetToadAnchor().Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


	thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

	anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

	anchor.AddTag('toad_anchor');

	anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bone_vec, bone_rot );

	((CActor)anchor).EnableCollisions(false);
	((CActor)anchor).EnableCharacterCollisions(false);





	ent_1_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

	ent_2_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );





	ent_1 = theGame.CreateEntity( ent_2_temp, pos, rot );

	ent_1.AddTag('ACS_Toad_Test_1');

	((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_1).EnableCharacterCollisions(false);
	((CNewNPC)ent_1).EnableCollisions(false);
	((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_1).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_1).EnableCollisions(false);
	((CActor)ent_1).EnableCharacterCollisions(false);
	((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	thePlayer.EnableCharacterCollisions(false);

	animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = 90;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = -0.35;
	attach_vec.Y = 0.5;
	attach_vec.Z = 0;

	ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );

	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);




	ent_2 = theGame.CreateEntity( ent_2_temp, pos, rot );

	ent_2.AddTag('ACS_Toad_Test_2');

	((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_2).EnableCharacterCollisions(false);
	((CNewNPC)ent_2).EnableCollisions(false);
	((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_2).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_2).EnableCollisions(false);
	((CActor)ent_2).EnableCharacterCollisions(false);
	((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = -30;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = 0.275;
	attach_vec.Y = 0.5;
	attach_vec.Z = -0.4;

	ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);



	ent_3 = theGame.CreateEntity( ent_2_temp, pos, rot );

	ent_3.AddTag('ACS_Toad_Test_3');

	((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	((CNewNPC)ent_3).EnableCharacterCollisions(false);
	((CNewNPC)ent_3).EnableCollisions(false);
	((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
	((CActor)ent_3).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
	((CActor)ent_3).EnableCollisions(false);
	((CActor)ent_3).EnableCharacterCollisions(false);
	((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

	animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

	meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

	attach_rot.Roll = -150;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = 0.275;
	attach_vec.Y = 0.5;
	attach_vec.Z = 0.4;

	ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

	if (i == 1)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}
	else if (i == 2)
	{
		animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
	}

	animcomp.FreezePoseFadeIn(4.5f);











	anchor.DestroyAfter(2);

	ent_1.DestroyAfter(2);

	ent_2.DestroyAfter(2);

	ent_3.DestroyAfter(2);
}

exec function toadplayanim( i: int)
{
	var AnimatedComponent 		: CAnimatedComponent;
	var AnimSettings			: SAnimatedComponentSlotAnimationSettings;

	AnimatedComponent = (CAnimatedComponent)GetACSToadTest_1().GetComponentByClassName( 'CAnimatedComponent' );	

	AnimatedComponent.UnfreezePose();

	if (i == 1)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}
	else if (i == 2)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}

	AnimatedComponent.FreezePoseFadeIn(4.5);



	AnimatedComponent = (CAnimatedComponent)GetACSToadTest_2().GetComponentByClassName( 'CAnimatedComponent' );	

	AnimatedComponent.UnfreezePose();

	if (i == 1)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}
	else if (i == 2)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}

	AnimatedComponent.FreezePoseFadeIn(4.5);



	AnimatedComponent = (CAnimatedComponent)GetACSToadTest_3().GetComponentByClassName( 'CAnimatedComponent' );	

	AnimatedComponent.UnfreezePose();

	if (i == 1)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}
	else if (i == 2)
	{
		AnimatedComponent.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
	}


	AnimatedComponent.FreezePoseFadeIn(4.5);
}

function GetACSToadTest_1() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Toad_Test_1' );
	return entity;
}

function GetACSToadTest_2() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Toad_Test_2' );
	return entity;
}

function GetACSToadTest_3() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Toad_Test_3' );
	return entity;
}

function GetToadAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'toad_anchor' );
	return entity;
}


function GetACSToadTest_Array_Destroy()
{	
	var i												: int;
	var ents 											: array<CActor>;

	ents.Clear();

	theGame.GetActorsByTag( 'ACS_Toad_Test', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function GetACSLookatEntity() : CEntity
{
	var ent 							 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'acs_lookat_entity' );
	return ent;
}

exec function ACS_effecttest2()
{
	ACS_Umbral_Slash_End_Effect();
}

exec function ACS_fxteststop()
{
	GetACSTestEnt_Array_StopEffects();
}

exec function ACS_soundtest(str:string)
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

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function GetACSTestEnt_Array_StopEffects()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].StopAllEffects();
		ents[i].DestroyAfter(1);
	}

	thePlayer.SoundEvent("magic_man_tornado_loop_stop");
}

exec function acsmessagetest()
{
	GetWitcherPlayer().DisplayHudMessage( "LESHEN ITEMS DETECTED IN INVENTORY. YOU SHALL NOT ESCAPE ME." );
}

exec function acshighlighttest()
{
	DisableCatViewFx( 0 );
	EnableCatViewFx( 1.5 );
	SetTintColorsCatViewFx(Vector(0.1f,0.12f,0.13f,0.6f),Vector(0.075f,0.1f,0.11f,0.6f),0);
	SetBrightnessCatViewFx(0.0f);
	SetViewRangeCatViewFx(1000.0f);
	SetPositionCatViewFx( Vector(0,0,0,0) , true );	
	SetHightlightCatViewFx( Vector(0.5f,0.2f,0.2f,1.f),0.05f,10);
	SetFogDensityCatViewFx( 0.25 );

	ACS_HighlightObjects();
	
	theGame.GetFocusModeController().EnableVisuals( true, 0.0f, 0.15f );
}

function ACS_HighlightObjects()
{
	var ents : array<CGameplayEntity>;
	var i : int;

	FindGameplayEntitiesInSphere(ents, thePlayer.GetWorldPosition(), 100, 100, , FLAG_ExcludePlayer);
	
	for(i=0; i<ents.Size(); i+=1)
	{
		ents[i].SetHighlighted( true );
		ents[i].PlayEffect( 'medalion_detection_fx' );

		ents[i].SetFocusModeVisibility( FMV_Interactive, true );
	}
}

function ACS_HighlightObjects_2()
{
	var ents : array<CGameplayEntity>;
	var i : int;
	var catComponent : CGameplayEffectsComponent;

	FindGameplayEntitiesInSphere(ents, thePlayer.GetWorldPosition(), 100, 100, , FLAG_ExcludePlayer);
	
	for(i=0; i<ents.Size(); i+=1)
	{
		catComponent = GetGameplayEffectsComponent(ents[i]);

		if(catComponent)
		{
			catComponent.SetGameplayEffectFlag(EGEF_CatViewHiglight, true);
		}
	}
}

function ACS_EventHackAttack()
{
	if (thePlayer.HasTag('ACS_Shielded_Entity'))
	{
		return;
	}

	if (!thePlayer.IsInCombat())
	{
		//return;
	}

	if ( thePlayer.IsAlive() )
	{
		if (thePlayer.HasTag('igni_sword_equipped') 
		|| thePlayer.HasTag('igni_secondary_sword_equipped') 
		)
		{
			if (ACS_Bear_School_Check()
			|| ACS_Cat_School_Check()
			|| ACS_Griffin_School_Check()
			|| ACS_Manticore_School_Check()
			|| ACS_Viper_School_Check()
			)
			{
				thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
				thePlayer.RaiseForceEvent	 	( 'CombatAction' );
			}
			else if (ACS_Wolf_School_Check()
			|| ACS_Forgotten_Wolf_Check()
			|| ACS_Armor_Equipped_Check()
			)
			{
				thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
				thePlayer.RaiseForceEvent	 	( 'CombatAction' );
			}
			else
			{
				return;
			}
		}
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')	
			|| thePlayer.HasTag('aard_sword_equipped')	
			|| thePlayer.HasTag('yrden_sword_equipped')	
			|| thePlayer.HasTag('quen_sword_equipped')
			|| thePlayer.HasTag('axii_secondary_sword_equipped')
			|| thePlayer.HasTag('aard_secondary_sword_equipped')
			|| thePlayer.HasTag('yrden_secondary_sword_equipped')
			|| thePlayer.HasTag('quen_secondary_sword_equipped')

			|| thePlayer.HasTag('vampire_claws_equipped')
		)
		{
			thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
			thePlayer.RaiseForceEvent	 	( 'CombatAction' );
		}
	}
}

function ACS_EventHackSpecialAttack()
{
	if (thePlayer.HasTag('ACS_Shielded_Entity'))
	{
		return;
	}

	if (!thePlayer.IsInCombat())
	{
		//return;
	}

	if ( thePlayer.IsAlive() )
	{
		if (thePlayer.HasTag('igni_sword_equipped') 
		|| thePlayer.HasTag('igni_secondary_sword_equipped') 
		)
		{
			if (ACS_Bear_School_Check()
			|| ACS_Cat_School_Check()
			|| ACS_Griffin_School_Check()
			|| ACS_Manticore_School_Check()
			|| ACS_Viper_School_Check()
			)
			{
				thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
				thePlayer.RaiseForceEvent	 	( 'CombatAction' );
			}
			else if (ACS_Wolf_School_Check()
			|| ACS_Forgotten_Wolf_Check()
			|| ACS_Armor_Equipped_Check()
			)
			{
				thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
				thePlayer.RaiseForceEvent	 	( 'CombatAction' );
			}
			else
			{
				return;
			}
		}
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')	
			|| thePlayer.HasTag('aard_sword_equipped')	
			|| thePlayer.HasTag('yrden_sword_equipped')	
			|| thePlayer.HasTag('quen_sword_equipped')
			|| thePlayer.HasTag('axii_secondary_sword_equipped')
			|| thePlayer.HasTag('aard_secondary_sword_equipped')
			|| thePlayer.HasTag('yrden_secondary_sword_equipped')
			|| thePlayer.HasTag('quen_secondary_sword_equipped')
			|| thePlayer.HasTag('vampire_claws_equipped')
		)
		{
			thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_ItemThrow );
			thePlayer.RaiseForceEvent	 	( 'CombatAction' );
		}
	}
}

function ACS_EventHackDodge()
{
	if (thePlayer.HasTag('ACS_Shielded_Entity'))
	{
		return;
	}

	if (!thePlayer.IsInCombat())
	{
		//return;
	}

	if ( thePlayer.IsAlive() )
	{
		if (thePlayer.HasTag('igni_sword_equipped') 
		|| thePlayer.HasTag('igni_secondary_sword_equipped') 
		)
		{
			if (ACS_Wolf_School_Check()
			|| ACS_Bear_School_Check()
			|| ACS_Cat_School_Check()
			|| ACS_Griffin_School_Check()
			|| ACS_Manticore_School_Check()
			|| ACS_Forgotten_Wolf_Check()
			|| ACS_Viper_School_Check()
			|| ACS_Armor_Equipped_Check()
			)
			{
				thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_Dodge );
				thePlayer.RaiseForceEvent	 	( 'CombatAction' );
			}
			else
			{
				return;
			}
		}
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')	
			|| thePlayer.HasTag('aard_sword_equipped')	
			|| thePlayer.HasTag('yrden_sword_equipped')	
			|| thePlayer.HasTag('quen_sword_equipped')
			|| thePlayer.HasTag('axii_secondary_sword_equipped')
			|| thePlayer.HasTag('aard_secondary_sword_equipped')
			|| thePlayer.HasTag('yrden_secondary_sword_equipped')
			|| thePlayer.HasTag('quen_secondary_sword_equipped')

			|| thePlayer.HasTag('vampire_claws_equipped')
		)
		{
			thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_Dodge );
			thePlayer.RaiseForceEvent	 	( 'CombatAction' );
		}
	}
}

exec function ACS_EventHack_Test()
{
	//thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_Parry );
	//thePlayer.SetBehaviorVariable	( 'combatActionType', (int)CAT_Attack );
	thePlayer.RaiseForceEvent	 	( 'playerActionStart' );
}

exec function testthing(effect_name:name)
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;

	//GetACSTestEnt.Destroy();

	GetACSTestEnt_Array_Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 25;

	//pos.Z -= 200;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		//"dlc\bob\data\quests\minor_quests\quest_files\mq7006_the_paths_of_destiny\entities\mq7006_aerondight.w2ent"
		//"dlc\dlc_acs\data\fx\acs_sword_trail.w2ent"

		//"fx\quest\q502\conjunction\q502_sky_conjunction.w2ent"

		//"fx\quest\sq205\sq205_ritual_storm.w2ent"

		"dlc\dlc_acs\data\fx\fire_conjunction.w2ent"

		, true ), pos, rot );

	ent.AddTag('ACS_Test_Ent');

	//ent.CreateAttachment( thePlayer, 'r_weapon' );

	ent.PlayEffectSingle(effect_name);
}

exec function testproj()
{
	var actortarget																																					: CActor;
	var actors    																																					: array<CActor>;
	var i         																																					: int;
	var rock_pillar_temp																																			: CEntityTemplate;
	var proj_1	 																																					: W3ACSArmorPhysxProjectile;
	var initpos, targetPosition																																		: Vector;
	var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	var dmg																																							: W3DamageAction;

	initpos = thePlayer.GetWorldPosition();			
	initpos.Z += 1.1;
			
	targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 15;
	targetPosition.Z += 1.1;
			
	proj_1 = (W3ACSArmorPhysxProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_armor_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(thePlayer);
	//proj_1.PlayEffect('blade_glow');
	//proj_1.PlayEffectSingle('spit_hit');
	proj_1.ShootProjectileAtPosition( 0, 50, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function GetACSArmorCone() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Armor_Cone' );
	return entity;
}

function ACS_Armor_Cone()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos, proj_pos, targetPosition					: Vector;
	var proj_1	 										: W3ACSArmorPhysxProjectile;
	var projectileCollision 							: array< name >;

	projectileCollision.Clear();
	projectileCollision.PushBack( 'Projectile' );
	projectileCollision.PushBack( 'Door' );
	projectileCollision.PushBack( 'Static' );		
	projectileCollision.PushBack( 'ParticleCollider' ); 

	GetACSArmorCone().Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Armor_Cone');

	ent.DestroyAfter(1);

	if (thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
	&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina))
	{
		ent.PlayEffect('acs_armor_cone_orig');
	}
	else
	{
		ent.PlayEffect('acs_armor_cone');
	}


	proj_pos = thePlayer.GetWorldPosition();	
	proj_pos.Z += 0.5;		

	targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 15;
			
	proj_1 = (W3ACSArmorPhysxProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\acs_armor_projectile.w2ent"
		
	, true ), proj_pos, rot );
					
	proj_1.Init(thePlayer);
	proj_1.SetAttackRange( theGame.GetAttackRangeForEntity( ent, 'cone' ) );
	proj_1.ShootCakeProjectileAtPosition( 60, 3.5f, 0.0f, 30.0f, targetPosition, 500, projectileCollision );		
	proj_1.DestroyAfter(1);
}

function ACS_RedBladeProjectileActual()
{
	var proj_1								: ACSBladeProjectile;
	var initpos, newpos, targetPosition		: Vector;
	var portal_ent							: CEntity;

	thePlayer.SoundEvent("fx_rune_activate_igni");

	initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetHeadingVector() * RandRangeF(2, -2)) + (GetWitcherPlayer().GetWorldRight() * RandRangeF(7, -7)) ;	
	initpos.Z += RandRangeF(7, 2.25);

	portal_ent = (CEntity)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\portal.w2ent"
		
	, true ), initpos, thePlayer.GetWorldRotation() );

	portal_ent.PlayEffect('teleport');

	portal_ent.DestroyAfter(2);

	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent"
		
	, true ), initpos );
					
	proj_1.Init(thePlayer);

	if(thePlayer.IsInCombat())
	{
		if ( thePlayer.IsHardLockEnabled() )
		{
			targetPosition = ((CActor)( thePlayer.GetDisplayTarget() )).PredictWorldPosition(0.7);
			targetPosition.Z += 0.75;
		}
		else
		{
			targetPosition = ((CActor)(thePlayer.moveTarget)).PredictWorldPosition(0.7);
			targetPosition.Z += 0.75;
		}
	}
	else
	{
		targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 30;
		targetPosition.Z -= 5;
	}

	proj_1.ShootProjectileAtPosition( 0, RandRangeF(25,10), targetPosition, 500 );
}

function ACS_RedBladeProjectileActual_old()
{
	var proj_1								: ACSBladeProjectile;
	var initpos, newpos, targetPosition		: Vector;

	thePlayer.SoundEvent("magic_sorceress_vfx_hit_electric");

	thePlayer.SoundEvent("magic_sorceress_vfx_lightning_bolt");

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	//targetPosition.Z += 0.25;
	
	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_RedBladeProjectileActual360()
{
	var proj_1, proj_2, proj_3																				: ACSBladeProjectile;
	var initpos, targetPosition_1, targetPosition_2, targetPosition_3										: Vector;
	var temp																								: CEntityTemplate;

	thePlayer.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");

	temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition_1 = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_1.Z += 0.25;

	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );
	proj_1.DestroyAfter(10);




	targetPosition_2 = initpos  +GetWitcherPlayer().GetWorldRight() * 10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_2.Z += 0.25;

	proj_2 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_2.Init(thePlayer);

	proj_2.ShootProjectileAtPosition( 0, 25, targetPosition_2, 500 );
	proj_2.DestroyAfter(10);





	targetPosition_3 = initpos + GetWitcherPlayer().GetWorldRight() * -10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_3.Z += 0.25;

	proj_3 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_3.Init(thePlayer);

	proj_3.ShootProjectileAtPosition( 0, 25, targetPosition_3, 500 );
	proj_3.DestroyAfter(10);
}

exec function cthulucall()
{
	var actors, victims																		: array<CActor>;
	var i 																					: int;
	var npc 																				: CNewNPC;
	var actor, actortarget 																	: CActor;
	var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	var initpos, targetPosition																: Vector;
	var movementAdjustor																	: CMovementAdjustor;
	var ticket 																				: SMovementAdjustmentRequestTicket;
	var targetDistance																		: float;
	var drownerAnimatedComponent 															: CAnimatedComponent;
	var drownerAnimSettings																	: SAnimatedComponentSlotAnimationSettings;



	var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    							: CEntity;
	var rot, attach_rot                        						 						: EulerAngles;
   	var pos, attach_vec																		: Vector;
	var meshcomp																			: CComponent;
	var animcomp 																			: CAnimatedComponent;
	var AnimSettings																		: SAnimatedComponentSlotAnimationSettings;
	var h 																					: float;
	var bone_vec																			: Vector;
	var bone_rot																			: EulerAngles;
	var anchor_temp, ent_1_temp, ent_2_temp													: CEntityTemplate;

	var dmg																					: W3DamageAction;

	ACSTentacleTestAnchorDestroy();

	ACSTentacleTestDestroy();

	actors.Clear();
		
	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			npc.AddTag('ACS_Tentacle_Init');

			//npc.EnableCharacterCollisions(false);

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), npc.GetWorldPosition() ) ;

			if (
			(npc.HasAbility('mon_drowner_base')
			|| npc.HasAbility('mon_rotfiend')
			|| npc.HasAbility('mon_rotfiend_large')
			|| npc.HasAbility('mon_gravier'))
			&& (npc.GetStat(BCS_Stamina) >= npc.GetStatMax(BCS_Stamina) * 0.1)

			//npc.IsHuman()
			)			
			{
				if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
				{
					theSound.SoundLoadBank( "monster_toad.bnk", false );
				}

				movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

				drownerAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

				drownerAnimatedComponent.PlaySlotAnimationAsync ( 'monster_drowner_act2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Rotate_1');
				movementAdjustor.CancelByName( 'ACS_Tentacle_Rotate_1' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Rotate_1' );
				movementAdjustor.AdjustmentDuration( ticket, 1 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, thePlayer );

				npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) * 0.1, 2 );

				//npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
				//npc.SetCanPlayHitAnim(false); 
				//npc.AddBuffImmunity_AllNegative('acs_tentacle_immune', true); 


				//GetACSTentacle_1().Destroy();

				//GetACSTentacle_2().Destroy();

				//GetACSTentacle_3().Destroy();

				//GetACSTentacleAnchor().Destroy();

				rot = npc.GetWorldRotation();

				pos = npc.GetWorldPosition() + npc.GetWorldForward() * 5;

				anchor_temp = (CEntityTemplate)LoadResource( 
					
					//"dlc\dlc_acs\data\entities\other\fx_ent.w2ent"

					"dlc\dlc_acs\data\fx\drowner_warning.w2ent"
					
					, true );


				npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bone_vec, bone_rot );

				anchor = (CEntity)theGame.CreateEntity( anchor_temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

				anchor.PlayEffect('marker');

				anchor.AddTag('acs_tentacle_test_anchor');

				anchor.CreateAttachmentAtBoneWS( npc, 'head', bone_vec, bone_rot );

				((CActor)anchor).EnableCollisions(false);
				((CActor)anchor).EnableCharacterCollisions(false);




				ent_1_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

				ent_2_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );




				ent_1 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_1.AddTag('ACS_Test_Tentacle');

				((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
				((CNewNPC)ent_1).EnableCharacterCollisions(false);
				((CNewNPC)ent_1).EnableCollisions(false);
				((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				((CActor)ent_1).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
				((CActor)ent_1).EnableCollisions(false);
				((CActor)ent_1).EnableCharacterCollisions(false);
				((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

				npc.EnableCharacterCollisions(false);

				animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

				meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

				attach_rot.Roll = 90;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = 0.4;
				attach_vec.Y = 0.15;
				attach_vec.Z = 0;

				ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);




				ent_2 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_2.AddTag('ACS_Test_Tentacle');

				((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
				((CNewNPC)ent_2).EnableCharacterCollisions(false);
				((CNewNPC)ent_2).EnableCollisions(false);
				((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				((CActor)ent_2).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
				((CActor)ent_2).EnableCollisions(false);
				((CActor)ent_2).EnableCharacterCollisions(false);
				((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

				animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

				meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

				attach_rot.Roll = -30;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.3;
				attach_vec.Y = 0.15;
				attach_vec.Z = -0.35;

				ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);



				ent_3 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_3.AddTag('ACS_Test_Tentacle');

				((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
				((CNewNPC)ent_3).EnableCharacterCollisions(false);
				((CNewNPC)ent_3).EnableCollisions(false);
				((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				((CActor)ent_3).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
				((CActor)ent_3).EnableCollisions(false);
				((CActor)ent_3).EnableCharacterCollisions(false);
				((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

				animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

				meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

				attach_rot.Roll = -150;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.3;
				attach_vec.Y = 0.15;
				attach_vec.Z = 0.35;

				ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);

				anchor.DestroyAfter(3.5);

				ent_1.DestroyAfter(3.5);

				ent_2.DestroyAfter(3.5);

				ent_3.DestroyAfter(3.5);

				///npc.SetImmortalityMode( AIM_None, AIC_Combat ); 
				//npc.SetCanPlayHitAnim(true); 
				//npc.RemoveBuffImmunity_AllNegative('acs_tentacle_immune'); 
			}
		}
	}
}

function ACSTentacleTestDestroy()
{
	var skeleton 											: array<CActor>;
	var i													: int;
	
	skeleton.Clear();

	theGame.GetActorsByTag( 'ACS_Test_Tentacle', skeleton );	
	
	for( i = 0; i < skeleton.Size(); i += 1 )
	{
		skeleton[i].Destroy();
	}
}

function ACSTentacleTestAnchorDestroy()
{
	var skeleton 											: array<CEntity>;
	var i													: int;
	
	skeleton.Clear();

	theGame.GetEntitiesByTag( 'acs_tentacle_test_anchor', skeleton );	
	
	for( i = 0; i < skeleton.Size(); i += 1 )
	{
		skeleton[i].Destroy();
	}
}

function ACSContainerEntityDestroy()
{
	var ent 											: array<CEntity>;
	var i													: int;
	
	ent.Clear();

	theGame.GetEntitiesByTag( 'ACS_Container_Entity', ent );	
	
	for( i = 0; i < ent.Size(); i += 1 )
	{
		ent[i].Destroy();
	}
}

function ACS_SetupSimpleSyncAnim2( syncAction : name, master, slave : CEntity ) : bool
{
	var masterDef, slaveDef						: SAnimationSequenceDefinition;
	var masterSequencePart, slaveSequencePart	: SAnimationSequencePartDefinition;
	var syncInstance							: CAnimationManualSlotSyncInstance;
	
	var instanceIndex	: int;
	var sequenceIndex	: int;
	
	var actorMaster, actorSlave : CActor;
	
	var temp : name; 
	var tempF : float;
	var rot : EulerAngles;
	
	var finisherAnim : bool;
	var pos : Vector;
	
	var syncAnimName	: name;
	
	var node, node1 : CNode; 
	var rot0, rot1 : EulerAngles;

	var masterEntity				: CGameplayEntity;
	var slaveEntity					: CGameplayEntity;
	var syncInstances				: array< CAnimationManualSlotSyncInstance >;
	
	syncInstance = theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
	
	
	thePlayer.BlockAction(EIAB_Interactions, 'SyncManager' );
	thePlayer.BlockAction(EIAB_FastTravel, 'SyncManager' );
	
	switch( syncAction )
	{
		case 'BruxaBite':
		{
			rot = slave.GetWorldRotation();
			pos = ((CActor)slave).PredictWorldPosition( 0.1 );
			tempF = NodeToNodeAngleDistance( master, slave );
			
			
			if ( slave == thePlayer && ((CR4Player)slave).GetCombatIdleStance() == 0 )
			{
				
				if ( tempF >= -90.0 && tempF < 90.0 )
				{
					masterSequencePart.animation = 'bruxa_attack_bite_front_lp';
					slaveSequencePart.animation = 'bruxa_attack_bite_front_lp';
					masterSequencePart.finalHeading	= rot.Yaw + 180;
				}
				
				else
				{
					masterSequencePart.animation = 'bruxa_attack_bite_back_lp';
					slaveSequencePart.animation = 'bruxa_attack_bite_back_lp';
					masterSequencePart.finalHeading	= rot.Yaw;
				}
			}
			
			else
			{
				
				if ( tempF >= -90.0 && tempF < 90.0 )
				{
					masterSequencePart.animation = 'bruxa_attack_bite_front_rp';
					slaveSequencePart.animation = 'bruxa_attack_bite_front_rp';
					masterSequencePart.finalHeading	= rot.Yaw + 180;
				}
				
				else
				{
					masterSequencePart.animation = 'bruxa_attack_bite_back_rp';
					slaveSequencePart.animation = 'bruxa_attack_bite_back_rp';
					masterSequencePart.finalHeading	= rot.Yaw;
				}
			}
			
			((CActor)slave).AddEffectDefault( EET_Bleeding, (CActor)master, "BruxaBiteAttack" );
			master.SetBehaviorVariable( 'bite', 1 );
			FactsAdd( "player_bitten_by_vampire", 1, 3 );
			
			
			
			masterSequencePart.syncType			= AMST_SyncBeginning;
			masterSequencePart.syncEventName	= 'SyncEvent';
			masterSequencePart.finalPosition	= pos; 
			
			masterSequencePart.shouldSlide		= true;
			masterSequencePart.shouldRotate		= true;
			masterSequencePart.blendInTime		= 0.2f;
			masterSequencePart.blendOutTime		= 0.2f;
			masterSequencePart.sequenceIndex	= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity					= master;
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';
			masterDef.freezeAtEnd				= false;
			masterDef.startForceEvent 			= 'ForceIdle';
			
			
			
			slaveSequencePart.syncType			= AMST_SyncBeginning;
			slaveSequencePart.syncEventName		= 'SyncEvent';
			slaveSequencePart.shouldSlide		= false;
			slaveSequencePart.shouldRotate		= false;
			slaveSequencePart.blendInTime		= 0.2f;
			slaveSequencePart.blendOutTime		= 0.2f;
			slaveSequencePart.sequenceIndex		= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity						= slave;
			slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd				= false;
			
			break;
		}
		case 'DettlaffWings':
		{
			rot = slave.GetWorldRotation();
			pos = slave.GetWorldPosition();
				
			
			
			masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_cut_wings_lp';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.finalPosition		= pos; 
			masterSequencePart.finalHeading			= rot.Yaw+180;
			
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.1f;
			masterSequencePart.blendOutTime			= 0.2f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			masterDef.freezeAtEnd					= false;
			masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				
			
				
			slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_cut_wings_lp';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.blendInTime			= 0.1f;
			slaveSequencePart.blendOutTime			= 0.2f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			masterEntity = (CGameplayEntity)master;
			slaveEntity = (CGameplayEntity)slave;
			
			break;	
		}
		case 'DettlaffBlood':
		{
			rot = slave.GetWorldRotation();
			pos = slave.GetWorldPosition();
				
			
			
			masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_blood_drinking';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.finalPosition		= pos; 
			masterSequencePart.finalHeading			= rot.Yaw;
			
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.0f;
			masterSequencePart.blendOutTime			= 0.2f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			masterDef.freezeAtEnd					= false;
			masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				
			
				
			slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_blood_drinking';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.blendInTime			= 0.0f;
			slaveSequencePart.blendOutTime			= 0.2f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			masterEntity = (CGameplayEntity)master;
			slaveEntity = (CGameplayEntity)slave;
			
			
			
			break;	
		}
		case 'DettlaffTorso':
		{
			rot = slave.GetWorldRotation();
			pos = ((CActor)slave).PredictWorldPosition( 0.2f );
				
			
			
			masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_cut_torso_rp';
			masterSequencePart.syncType				= AMST_SyncMatchEvents;
			masterSequencePart.syncEventName 		= 'SyncEvent';
			masterSequencePart.finalPosition		= pos; 
			masterSequencePart.finalHeading			= rot.Yaw;
			
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.0f;
			masterSequencePart.blendOutTime			= 0.2f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			masterDef.freezeAtEnd					= false;
			masterDef.manualSlotName				= 'GAMEPLAY_SLOT';

				
			
				
			slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_cut_torso_rp';
			slaveSequencePart.syncType				= AMST_SyncMatchEvents;
			slaveSequencePart.syncEventName 		= 'SyncEvent';
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.blendInTime			= 0.0f;
			slaveSequencePart.blendOutTime			= 0.2f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
			
			slaveDef.manualSlotName					= 'FinisherSlot';
			slaveDef.startForceEvent				= 'PerformFinisher';
			slaveDef.raiseEventOnEnd				= 'DoneFinisher';
			slaveDef.freezeAtEnd					= false;
			finisherAnim 							= true;
			
			masterEntity = (CGameplayEntity)master;
			slaveEntity = (CGameplayEntity)slave;
			
			break;	
		}
		case 'ArchesporEating_01':
		{
			
			masterSequencePart.animation			= 'utility_wander_eating_end';	
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.shouldSlide			= false;
			masterSequencePart.shouldRotate			= false;		
			masterSequencePart.blendInTime			= 0.f;
			masterSequencePart.blendOutTime			= 0.f;
			masterSequencePart.sequenceIndex		= 0;
			masterSequencePart.allowBreakBeforeEnd 	= 7.0;
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
			masterDef.raiseEventOnEnd				= 'ForceIdle';
			
			
			slaveSequencePart.animation				= 'utility_wander_eating_end';
			slaveSequencePart.syncType				= AMST_SyncBeginning;	
			slaveSequencePart.blendInTime			= 0.f;
			slaveSequencePart.blendOutTime			= 0.f;
			slaveSequencePart.sequenceIndex			= 0;	
			slaveSequencePart.allowBreakBeforeEnd 	= 7.0;
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			
			masterEntity = (CGameplayEntity)master;
			slaveEntity = (CGameplayEntity)slave;
			
			break;	
		}
		
		case 'PetHorse':
		{
			rot = slave.GetWorldRotation();
			
			
			if( VecDistance(master.GetWorldPosition(), slave.GetWorldPosition() + VecConeRand(slave.GetHeading() - 90, 0, 1,1)) < VecDistance(master.GetWorldPosition(), slave.GetWorldPosition() + VecConeRand(slave.GetHeading() + 90, 0, 1,1))  )
			{
				
				masterSequencePart.animation			= 'high_standing_determined_gesture_preparing_horse1b';	
				masterSequencePart.finalPosition		= slave.GetWorldPosition() + VecConeRand(slave.GetHeading() - 90, 0, 0.82,0.82) + VecConeRand(slave.GetHeading(), 0, 0.5,0.5);				
				masterSequencePart.finalHeading			= rot.Yaw + 95;
			}
			else
			{
				
				masterSequencePart.animation			= 'high_standing_determined_gesture_preparing_horse2';	
				masterSequencePart.finalPosition		= slave.GetWorldPosition() + VecConeRand(slave.GetHeading() + 90, 0, 0.82,0.82) + VecConeRand(slave.GetHeading(), 0, 0.3,0.3);				
				masterSequencePart.finalHeading			= rot.Yaw - 90;
			}
			
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.syncEventName		= 'SyncEvent';
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			masterSequencePart.blendInTime			= 0.5f;
			masterSequencePart.blendOutTime			= 1.2f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
			masterDef.freezeAtEnd					= false;
			
			
			slaveSequencePart.animation				= 'horse_breathing_slow';			
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.syncEventName			= 'SyncEvent';
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.blendInTime			= 0.5f;
			slaveSequencePart.blendOutTime			= 0.5f;
			slaveSequencePart.sequenceIndex			= 0;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
			slaveDef.manualSlotName					= 'EXP_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			break;
		}	
		
		default : 
		{
			syncInstances.Remove( syncInstance );
			return false;
		}
		
	}
	
	sequenceIndex = syncInstance.RegisterMaster( masterDef );
	if( sequenceIndex == -1 )
	{
		syncInstances.Remove( syncInstance );
		return false;
	}
	
	
	actorMaster = (CActor)master;
	actorSlave = (CActor)slave;
	
	if(actorMaster)
	{
		actorMaster.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
		actorMaster.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
		if ( finisherAnim )
			actorMaster.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
		else
			actorMaster.SignalGameplayEvent( 'PlaySyncedAnim' );
		
	}
	
	sequenceIndex = syncInstance.RegisterSlave( slaveDef );
	if( sequenceIndex == -1 )
	{
		syncInstances.Remove( syncInstance );
		return false;
	}
	
	
	if(actorSlave)
	{
		if( syncAction == 'Throat' )
			actorSlave.SignalGameplayEventParamCName( 'SetupEndEvent', 'CriticalState' );
			
		actorSlave.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
		actorSlave.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
		if ( finisherAnim )
			actorSlave.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
		else
			actorSlave.SignalGameplayEvent( 'PlaySyncedAnim' );
	}
	
	
	
	return true;
}

exec function acsspawnent()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIMoveToAction;			

	GetACSEnemy().Destroy();

	GetACSEnemyDestroyAll();

	temp = (CEntityTemplate)LoadResource( 

	//nam

	//"dlc\dlc_acs\data\entities\monsters\the_mother.w2ent"

	//"dlc\bob\data\characters\npc_entities\monsters\fairytale_witch.w2ent"

	//"dlc\bob\data\characters\npc_entities\monsters\panther_black_fairytale_witch.w2ent"

	//"dlc\bob\data\quests\minor_quests\quest_files\mq7006_the_paths_of_destiny\characters\mq7006_hermit.w2ent"

	//"characters\npc_entities\main_npc\hjalmar.w2ent"

	//"quests\main_npcs\hjalmar.w2ent"

	//"dlc\dlc15\data\characters\npc_entities\secondary_npc\gaetan.w2ent"

	//"quests\sidequests\no_mans_land\quest_files\sq106_killbill\characters\sq106_tauler.w2ent"

	//"dlc\dlc_acs\data\entities\monsters\dark_centipede.w2ent"

	//"gameplay\templates\characters\player\player.w2ent"

	//"characters\player_entities\geralt\geralt_player.w2ent"

	//"quests\sidequests\skellige\quest_files\sq201_curse\characters\sq201_morkvarg.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent"

	//"quests\part_3\quest_files\q501_eredin\characters\q501_wild_hunt_tier_3.w2ent"

	//"gameplay\templates\characters\npcs\test_enemies\enemy_rider.w2ent"

	//"gameplay\templates\characters\presets\novigrad\nov_1h_sword_t2.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\entities\q704_flying_fleder_bg_v2.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\entities\q704_flying_fleder_bg_v2_circling.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\entities\q704_flying_fleder_picking_up_guy.w2ent"

	//"quests\minor_quests\novigrad\quest_files\mq3009_witch_hunter_raids\characters\mq3009_mage.w2ent"

	//"dlc\dlc_acs\data\entities\mages\rat_mage_rats.w2ent"

	//"dlc\dlc_acs\data\entities\mages\rat_mage.w2ent"

	//"characters\npc_entities\animals\rat.w2ent"

	//"quests\main_npcs\mousesack.w2ent"

	//"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

	//"quests\part_1\quest_files\q104_mine\characters\q104_wild_hunt_boss.w2ent"

	"dlc\dlc_acs\data\entities\monsters\xeno_egg_tyrant.w2ent"
		
	, true );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		//((CActor)ent).AddAbility('CaranthirStrong');

		ent.AddTag( 'ACS_enemy' );
	}
}

exec function acsspawnentmult()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIMoveToAction;			

	GetACSEnemyDestroyAll();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\xeno_egg_normal.w2ent"
		
	, true );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	
	count = 10;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Xeno_Egg' );
	}
}

exec function acsspawnratmage()
{
	ACS_spawnratmage();
}


exec function acsspawneredin()
{
	ACS_spawneredin();
}

exec function acsspawnmage()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIHorseDoNothingAction;			
	var horseTag 														: array<name>;							

	GetACSEnemy().Destroy();

	GetACSEnemyDestroyAll();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\mages\mage.w2ent"
		
	, true );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	
	count = 3;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel()/2);

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_enemy' );
	}
}

exec function acsspawnwings()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIHorseDoNothingAction;			
	var horseTag 														: array<name>;							

	GetACSFlederWings().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\other\fleder_wings.w2ent"
		
	, true );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	playerRot = thePlayer.GetWorldRotation();

	//playerRot.Yaw += 180;
	
	ent = theGame.CreateEntity( temp, playerPos, playerRot );

	((CActor)ent).EnableCollisions(false);

	((CActor)ent).EnableCharacterCollisions(false);

	ent.CreateAttachment( thePlayer, , Vector( 0, 0 , 0 ), EulerAngles(0,0,0) );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 1;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
	((CActor)ent).SetAnimationSpeedMultiplier(1);

	ent.AddTag( 'ACS_Fleder_Wings' );
}

function GetACSFlederWings() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Fleder_Wings' );
	return entity;
}

exec function acsspawnchain()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIHorseDoNothingAction;			
	var horseTag 														: array<name>;							

	GetACSEnemy().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\swords\bob_chain_190_hook_triple.w2ent"
		
	, true );

	GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	ent = theGame.CreateEntity( temp, bone_vec, bone_rot );

	ent.AddTag( 'ACS_Chain' );
}

exec function acsspawncloakvamp()
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIMoveToAction;			

	temp = (CEntityTemplate)LoadResource( 

	"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

	//"characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent"
		
	, true );

	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 15;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cloak_Vamp' );
	}
}

function GetACSChain() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Chain' );
	return entity;
}

exec function acsenemyeforceani(animation_name: name, blendIn, blendout : float)
{
	var animatedComponentA			: CAnimatedComponent;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSEnemy()).GetComponentByClassName( 'CAnimatedComponent' );	

	animatedComponentA.PlaySlotAnimationAsync ( animation_name, 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(blendIn, blendout) );
}

exec function acsspawnwh()
{
	ACS_Wild_Hunt_Riders_Spawner_Exec();
}

exec function acsspawndragon()
{
	ACS_BigLizard_Spawner();
}

exec function acsdropbearbossfight()
{	
	ACS_dropbearbossfight();
}

exec function acsdropbearmeteorascend()
{
	ACS_dropbearmeteorstart();
}

exec function acsunseenblade()
{
	ACS_Unseen_Blade_Summon_Start();
}

exec function acsknightmaresummon()
{
	ACS_knightmaresummon();
}

exec function ACS_changestyle()
{
	var actors																	: array<CActor>;
	var i 																		: int;

	actors.Clear();
		
	actors = thePlayer.GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if ( actors[i] )
			{
				actors[i].SignalGameplayEvent('LeaveCurrentCombatStyle');
			}
		}
	}
}

exec function ACS_AddWeaponsChangeAttitude()
{
	var actors																	: array<CActor>;
	var i 																		: int;

	actors.Clear();
		
	actors = thePlayer.GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if ( actors[i] 
			&& ((CNewNPC)actors[i] ).GetNPCType() == ENGT_Commoner
			&& ((CNewNPC)actors[i] ).GetNPCType() != ENGT_Quest
			)
			{
				if( RandF() < 0.5 )
				{
					if( RandF() < 0.5 )
					{
						actors[i].GetInventory().AddAnItem( 'Skellige sword 1', 1 );

						//sword = actors[i].GetInventory().GetItemId('Skellige sword 1');
					}
					else
					{
						actors[i].GetInventory().AddAnItem( 'Skellige sword 2', 1 );

						//sword = actors[i].GetInventory().GetItemId('Skellige sword 2');
					}	
				}
				else
				{
					if( RandF() < 0.5 )
					{
						actors[i].GetInventory().AddAnItem( 'Rusty Skellige sword', 1 );

						//sword = actors[i].GetInventory().GetItemId('Rusty Skellige sword');
					}
					else
					{
						actors[i].GetInventory().AddAnItem( 'Skellige sword 4', 1 );

						//sword = actors[i].GetInventory().GetItemId('Skellige sword 4');
					}
				}

				actors[i].SetTatgetableByPlayer(true);

				//((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Neutral);

				((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

				((CNewNPC)actors[i]).SetImmortalityMode( AIM_None, AIC_IsAttackableByPlayer ); 
			}
		}
	}
}

exec function ACS_equipgregsword()
{
	var actors																	: array<CActor>;
	var i 																		: int;
	var sword					: SItemUniqueId;

	actors.Clear();
		
	actors = thePlayer.GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if ( actors[i] )
			{
				actors[i].GetInventory().RemoveAllItems();

				actors[i].DropItemFromSlot('r_weapon'); 

				actors[i].GetInventory().AddAnItem( 'NPC Gregoire Sword', 1 );

				sword = actors[i].GetInventory().GetItemId('NPC Gregoire Sword');

				actors[i].GetInventory().MountItem(sword, true);

				actors[i].DrawItems( true, sword );
			}
		}
	}
}

exec function ACS_DropWeapon()
{
	var actors																	: array<CActor>;
	var i 																		: int;
	var sword					: SItemUniqueId;

	actors.Clear();
		
	actors = thePlayer.GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if ( actors[i] )
			{
				actors[i].DropItemFromSlot('r_weapon', true); 

				actors[i].DropItemFromSlot('l_weapon', true);

				actors[i].GetInventory().RemoveAllItems();
			}
		}
	}
}

exec function ACS_teleportvector( x:float, y:float, z:float )
{
	thePlayer.Teleport(Vector(x,y,z));
}

exec function ACS_wraithmode()
{
	GetACSWatcher().wraith_mode_quick();
}

exec function acstestgroup()
{
	var actors, deathactors		    																								: array<CActor>;
	var animatedComponent, animatedComponent_NPC_ANIMATION_CANCEL, animatedComponentA, NPCanimatedComponent, bowAnimatedComponent	: CAnimatedComponent;
	var i 																															: int;
	var npc																															: CActor;

	deathactors.Clear();

	deathactors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer  );

	if( deathactors.Size() > 0 )
	{
		for( i = 0; i < deathactors.Size(); i += 1 )
		{
			npc = (CNewNPC)deathactors[i];

			animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
			
			if(
			//&& !((CNewNPC)npc).IsInFinisherAnim()
			!((CNewNPC)npc).IsInInterior()
			&& npc.IsHuman()
			)
			{
				npc.GetComponent("Finish").SetEnabled(false);
				animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.9f) );
			}	
		}
	}
}

exec function acsweakenaura()
{
	thePlayer.AddEffectDefault( EET_WeakeningAura, thePlayer, 'bufftest', false );
}

exec function acsbuffaddtest()
{
	var act : CGameplayEntity;
	var ent : CEntity;

	act = thePlayer.GetDisplayTarget();
	ent = (CEntity) act;

	((CActor)ent).AddEffectDefault( EET_Ragdoll, thePlayer, 'bufftest' );
}

function ACS_AttackImportance(npc: CNewNPC) : float
{
	if (thePlayer.IsPerformingFinisher()
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.HasTag('blood_sucking')
	|| npc.HasTag('ACS_Final_Fear_Stack')
	)
	{
		if ( thePlayer.GetAttitude( npc ) == AIA_Hostile  )
		{
			return 0;
		}
		else
		{
			return 10000;
		}
	}
	else
	{
		if (thePlayer.GetTarget() == npc
		|| thePlayer.moveTarget == npc
		)
		{
			return 10000;
		}
		else
		{
			if (npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.50)
			{
				if ( thePlayer.IsGuarded()
				|| thePlayer.IsCurrentlyDodging()
				|| (thePlayer.IsCastingSign() && !thePlayer.HasTag('vampire_claws_equipped'))
				|| thePlayer.IsCurrentSignChanneled()
				)
				{
					if (theGame.GetDifficultyLevel() == EDM_Hardcore)
					{
						return 10000;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Hard)
					{
						return 5000;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Medium)
					{
						return 2500;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Easy)
					{
						return 1000;
					}
					else
					{
						return 1000;
					}
				}
				else
				{
					if (RandF() < 0.999)
					{
						if ( thePlayer.GetAttitude( npc ) == AIA_Hostile )
						{
							return 0;
						}
						else
						{
							return 10000;
						}
					}
					else
					{
						if (theGame.GetDifficultyLevel() == EDM_Hardcore)
						{
							return 10000;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Hard)
						{
							return 5000;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Medium)
						{
							return 2500;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Easy)
						{
							return 100;
						}
						else
						{
							return 100;
						}
					}
				}
			}
			else
			{
				if (theGame.GetDifficultyLevel() == EDM_Hardcore)
				{
					return 10000;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Hard)
				{
					return 5000;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Medium)
				{
					return 2500;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Easy)
				{
					return 1000;
				}
				else
				{
					return 1000;
				}
			}
		}
	}
	
}

exec function acsspawnmother()
{
	var temp, temp_2, ent_1_temp, trail_temp							: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot										: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;

	ACSSheWhoKnows().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\the_mother.w2ent"
		
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
		
		//ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

		theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

		ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), thePlayer.GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());
		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');

		//ent.PlayEffect('special_attack_only_black_fx');

		//ent.PlayEffect('countered_dash');

		//ent.PlayEffect('countered_dash');
		
		//ent.PlayEffectSingle('appear');
		//ent.StopEffect('appear');
		//ent.PlayEffectSingle('shadow_form');
		//ent.PlayEffectSingle('demonic_possession');

		//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
		//((CActor)ent).AddAbility( 'EtherealActive' );

		//((CActor)ent).RemoveBuffImmunity( EET_Stagger );
		//((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

		ent.AddTag( 'ACS_She_Who_Knows' );

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_She_Who_Knows', true);
	}
}

exec function acsmothereffect(enam : CName)
{
	ACSSheWhoKnows().StopAllEffects();
	ACSSheWhoKnows().PlayEffectSingle(enam);
}

exec function acsspawnvamp()
{
	ACS_Unseen_Monster_Summon_Start();
}

exec function acsvampeffect(enam : CName)
{
	ACSVampireMonster().StopAllEffects();
	ACSVampireMonster().PlayEffectSingle(enam);
}

exec function acsvampdothis(enam : CName)
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	
	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	animatedComponentA.PlaySlotAnimationAsync ( enam, 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
}

function ACS_FinisherHeal()
{
	var actors		    																											: array<CActor>;
	var i 																															: int;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() == 0 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.05 );
	}
	else if( actors.Size() >= 1 && actors.Size() < 2 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.1 );
	}
	else if( actors.Size() >= 2 && actors.Size() < 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.15 );
	}
	else if( actors.Size() >= 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.2 );
	}
}

function ACS_Transformation_Activated_Check() : bool
{
	if (FactsQuerySum("acs_transformation_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Werewolf_Check() : bool
{
	if (FactsQuerySum("acs_wolven_curse_activated") > 0)
	{
		return true;
	}

	return false;
}

exec function ACS_wwplayanim(animation_name: name, blendIn, blendout : float)
{
	GetACSWatcher().ACSTransformWerewolfPlayAnim(animation_name, blendIn, blendout);
}

exec function ACS_wwplayeff(enam : CName)
{
	GetACSTransfomrationWerewolf().StopAllEffects();
	GetACSTransfomrationWerewolf().PlayEffectSingle(enam);
}

exec function ACS_wwtemp(path: string)
{
	var p_actor 			: CActor;
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;
	
	p_actor = GetACSTransfomrationWerewolf();

	p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
}

exec function ACS_wwtempex(path: string)
{
	var p_actor 			: CActor;
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;
	
	p_actor = GetACSTransfomrationWerewolf();

	p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
}

exec function ACS_wwhighfashion( b : bool)
{
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;

	GetACSWatcher().ACSTransformWerewolfPlayAnim('monster_werewolf_scratching', 0.25, 0.25);

	p_comp = GetACSTransfomrationWerewolf().GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		"dlc\bob\data\characters\models\monsters\werewolf\i_19__werewolf.w2ent"
		
		, true);

	if (b == true)
	{
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	else
	{
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
}

exec function ACS_eaddability(abilityname : CName)
{
	var p_actor 			: CActor;
	
	p_actor = (CActor)( thePlayer.GetDisplayTarget() );

	p_actor.AddAbility(abilityname);
}

exec function ACS_eremoveability(abilityname : CName)
{
	var p_actor 			: CActor;
	
	p_actor = (CActor)( thePlayer.GetDisplayTarget() );

	p_actor.RemoveAbility(abilityname);
}

exec function ACS_etemp(path: string)
{
	var p_actor 			: CActor;
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;
	
	p_actor = (CActor)( thePlayer.GetDisplayTarget() );

	p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
}

exec function ACS_etempex(path: string)
{
	var p_actor 			: CActor;
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;
	
	p_actor = (CActor)( thePlayer.GetDisplayTarget() );

	p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
}

exec function ACS_ptemp(path: string)
{
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;

	p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
}

exec function ACS_ptempex(path: string)
{
	var p_comp				: CComponent;
	var temp				: CEntityTemplate;
	
	p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

	temp = (CEntityTemplate)LoadResource(

		path
		
		, true);
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
}

exec function acsspawnkatakan()
{
	var temp, temp2, ent_1_temp, trail_temp							: CEntityTemplate;
	var ent, ent2, ent_1, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;			
	var p_comp															: CComponent;
	var apptemp															: CEntityTemplate;								

	GetACSEnemy().Destroy();

	GetACSEnemyDestroyAll();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent"
		
	, true );



	temp2 = (CEntityTemplate)LoadResource( 

	//"characters\models\monsters\werewolf\h_01__werewolf.w2ent"

	"dlc\dlc_acs\data\entities\other\fx_ent.w2ent"
		
	, true );


	playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	

	ent = theGame.CreateEntity( temp, playerPos, playerRot );






	p_comp = ent.GetComponentByClassName( 'CAppearanceComponent' );

	apptemp = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\models\wolf_body_no_tail\werewolf_body_no_tail.w2ent"
		
	, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(apptemp);


	apptemp = (CEntityTemplate)LoadResource(

	"characters\models\monsters\katakan\t_01__katakan_mh.w2ent"
		
	, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(apptemp);


	apptemp = (CEntityTemplate)LoadResource(

	"dlc\bob\data\characters\models\monsters\fleder\t_02__fleder.w2ent"
		
	, true);
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(apptemp);


	apptemp = (CEntityTemplate)LoadResource(

	"dlc\bob\data\characters\models\monsters\garkain\t_02__garkain.w2ent"
		
	, true);
	
	((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(apptemp);


	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 1.25;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	//((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

	((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

	//((CNewNPC)ent).EnableCharacterCollisions(false); 

	//((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
	//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
	
	((CActor)ent).SetAnimationSpeedMultiplier(1);


	//ent2 = theGame.CreateEntity( temp2, ent.GetWorldPosition(), ent.GetWorldRotation() );

	//ent2.CreateAttachment(ent, 'head_fx' , Vector( -2, 0.55, 0 ), EulerAngles(-180,0,90));



	ent.AddTag( 'ACS_enemy' );
}

exec function acsspawnnighthunter()
{
	ACS_SpawnNightStalker();
}

exec function ACS_nhplayeff(enam : CName)
{
	GetACSNightStalker().StopAllEffects();
	GetACSNightStalker().PlayEffectSingle(enam);
}

exec function acswwjump()
{
	GetACSWatcher().ACSTransformWerewolfMovementAdjustJump();
}

exec function acswwchangestance( fl : float )
{
	((CNewNPC)GetACSTransfomrationWerewolf()).SetBehaviorVariable( 'npcStance', fl, true );
}

exec function acswwhowl()
{
	((CAnimatedComponent)((CNewNPC)GetACSTransfomrationWerewolf()).GetComponentByClassName( 'CAnimatedComponent' )).RaiseBehaviorForceEvent('AttackEnd');
}

exec function acssnow(enam : CName)
{
	GetACSSnowEntity().StopAllEffects();
	GetACSSnowEntity().PlayEffect(enam);
}

exec function ACS_eforceeff(enam : CName)
{
	var actor							: CActor; 
	
	actor = (CActor)( thePlayer.GetDisplayTarget() );
	
	actor.StopAllEffects();
	actor.PlayEffect(enam);
}

exec function acstestdur()
{
	var inv																	: CInventoryComponent;
	var items1, items2, items3, items4, items5, items6, allItems			: array< SItemUniqueId >;
	var	i																	: int;

	inv = thePlayer.inv;

	items1 = inv.GetItemsByCategory( 'steelsword' );
	items2 = inv.GetItemsByCategory( 'silversword' );
	items3 = inv.GetItemsByCategory( 'armor' );
	items4 = inv.GetItemsByCategory( 'gloves' );
	items5 = inv.GetItemsByCategory( 'pants' );
	items6 = inv.GetItemsByCategory( 'boots' );
	
	ArrayOfIdsAppend( allItems, items1 );
	ArrayOfIdsAppend( allItems, items2 );
	ArrayOfIdsAppend( allItems, items3 );
	ArrayOfIdsAppend( allItems, items4 );
	ArrayOfIdsAppend( allItems, items5 );
	ArrayOfIdsAppend( allItems, items6 );

	for ( i = 0; i < allItems.Size(); i += 1 )
	{
		if ( inv.HasItemDurability( allItems[ i ] ) )
		{
			inv.SetItemDurabilityScript( allItems[ i ], inv.GetItemMaxDurability( allItems[ i ] ) );
		}
		else
		{
			inv.SetItemDurabilityScript( allItems[ i ], inv.GetItemMaxDurability( allItems[ i ] ) );
		}
	}
}

exec function ACSTeleport(xx, yy, zz : float)
{
	thePlayer.Teleport(Vector(xx,yy,zz,1));
}

function ACS_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega'))
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves')
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Boots')
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega'))
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves')
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots')
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Equipped_Check() : bool
{
	if (ACS_NGP_Armor_Check()
	|| ACS_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Alpha_Equipped_Check() : bool
{
	if (
	(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Omega_Equipped_Check() : bool
{
	if (
	(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
	)
	{
		return true;
	}

	return false;
}

function ACS_IsNight() : bool
{
	var currentHour: int;

	currentHour = GameTimeHours(theGame.GetGameTime());
	
	if(currentHour > 20 || currentHour < 5)			
	{
		return true;
	}

	return false;
}

exec function ACS_Ragdoll()
{
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer );

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

			enemyAnimatedComponent.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
					
			actor.AddEffectDefault(EET_Ragdoll, thePlayer, "bufftest" );
		}
	}
}

exec function ACS_gps_cat( b : bool )
{
	if (b)
	{
		GetACSWatcher().Load_GPS_Entity();

		GetACSWatcher().RemoveTimer('ACS_GPS_Timer');
		GetACSWatcher().AddTimer('ACS_GPS_Timer', 0.01, true);
	}
	else
	{
		GetACSWatcher().RemoveTimer('ACS_GPS_Timer');

		GetACSWatcher().ACS_GPS_Remove();
	}
}

exec function acsaerondightbuff( b : bool )
{
	thePlayer.ManageAerondightBuff(b);
}

exec function ACSAard()
{
	GetACSWatcher().ACS_Aard();
}

exec function ACSIgni()
{
	GetACSWatcher().ACS_Igni();
}

exec function ACSQuen()
{
	GetACSWatcher().ACS_Quen();
}

function ACS_GetQuestPoint() : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				if (pinInstances.Size() > 0)
				return true;
			}
		}
	}

	return false;
}

function ACS_GetQuestPointPosition( out pinPos : Vector ) : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				pinPos = pinInstances[i].position;
				return true;
			}
		}
	}

	return false;
}

exec function acsspawnxenoswarm()
{
	GetACSWatcher().ACS_XenoTyrant_Spawner();
}

exec function acsxenoswitch( i : int )
{
	if (i == 0)
	{
		ACSXenoTyrantnRemoveAbility();
		ACSXenoSoldiersRemoveAbility();
		ACSXenoArmoredWorkersSwapAbility();
	}
	else if (i == 1)
	{
		ACSXenoTyrantAddAbility();
		ACSXenoSoldiersAddAbility();
		ACSXenoArmoredWorkersSwapAbility();
	}
}

exec function acsxenoablswap()
{
	ACSXenoArmoredWorkersSwapAbility();
}
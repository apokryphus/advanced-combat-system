function ACS_CombatBehSwitch()
{
	var vBehSwitch 										: cBehSwitch;

	vBehSwitch = new cBehSwitch in theGame;
	
	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	)
	{
		if (!thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle())
		{
			vBehSwitch.BehSwitch_Engage();

			if (!thePlayer.IsInCombat())
			{
				if (thePlayer.HasTag ('summoned_shades'))
				{
					thePlayer.RemoveTag('summoned_shades');
				}
				
				if (thePlayer.HasTag ('ethereal_shout'))
				{
					thePlayer.RemoveTag('ethereal_shout');
				}
				
				/*
				if (thePlayer.HasTag ('vampire_claws_equipped'))
				{
					ClawDestroy();

					thePlayer.PlayEffectSingle('claws_effect');
					thePlayer.StopEffect('claws_effect');
				}
				*/
				
				if (thePlayer.HasTag('Swords_Ready'))
				{
					thePlayer.RemoveTag('Swords_Ready');
				}

				ACS_Skele_Destroy();

				ACS_Revenant_Destroy();

				thePlayer.StopEffect('drain_energy');

				GetACSWatcher().Remove_On_Hit_Tags();

				GetACSWatcher().BerserkMarkDestroy();

				HybridTagRemoval();

				ACS_Axii_Shield_Destroy_IMMEDIATE();

				ACS_Shield_Destroy();

				ACS_ThingsThatShouldBeRemoved();

				ACS_RemoveStabbedEntities();

				Bruxa_Camo_Decoy_Deactivate();

				//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2, false);

				IgniBowDestroy();
				AxiiBowDestroy();
				AardBowDestroy();
				YrdenBowDestroy();
				QuenBowDestroy();

				thePlayer.ClearAnimationSpeedMultipliers();

				if (ACS_Forest_God() 
				&& VecDistanceSquared2D( thePlayer.GetWorldPosition(), ACS_Forest_God().GetWorldPosition() ) <= 700 * 700 
				&& !theGame.IsDialogOrCutscenePlaying() 
				&& !thePlayer.IsInNonGameplayCutscene() 
				&& !thePlayer.IsInGameplayScene()
				&& !ACS_PlayerSettlementCheck()
				)
				{
					if (
					thePlayer.inv.HasItem('mh204_leshy_trophy')
					|| thePlayer.inv.HasItem('mh302_leshy_trophy')
					|| thePlayer.inv.HasItem('Leshy resin')
					|| thePlayer.inv.HasItem('sq204_leshy_talisman')
					|| thePlayer.inv.HasItem('Ancient Leshy mutagen')
					|| thePlayer.inv.HasItem('Leshy mutagen')
					)
					{
						if( ACS_can_spawn_forest_god_shadows() ) 
						{
							ACS_refresh_forest_god_shadows_cooldown();
							ACS_Forest_God_Shadows_Spawner();
						}
					}
					else
					{
						if( RandF() < ACS_ShadowsSpawnChancesNormal() ) 
						{
							if( ACS_can_spawn_forest_god_shadows() ) 
							{
								ACS_refresh_forest_god_shadows_cooldown();
								ACS_Forest_God_Shadows_Spawner();
							}
						}
					}
				}
			}
		}
	}
}

function ACS_ExplorationBehSwitch()
{
	var vBehSwitch : cBehSwitch;
	vBehSwitch = new cBehSwitch in theGame;
	
	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive())
	{
		vBehSwitch.BehSwitch_Engage_3();
	}
}

function ACS_BehSwitchINIT()
{
	var vBehSwitch : cBehSwitch;
	vBehSwitch = new cBehSwitch in theGame;
	
	ACS_Init_Attempt();
	
	if (ACS_Enabled())
	{
		if (!thePlayer.IsCiri()
		&& !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& thePlayer.IsAlive()
		)
		{
			vBehSwitch.BehSwitch_Engage_2();
			//UpdateBehGraph();
		}
	}
}

statemachine class cBehSwitch
{
    function BehSwitch_Engage()
	{
		this.PushState('BehSwitch_Engage');
	}

	function BehSwitch_Engage_2()
	{
		this.PushState('BehSwitch_Engage_2');
	}

	function BehSwitch_Engage_3()
	{
		this.PushState('BehSwitch_Engage_3');
	}
}

state BehSwitch_Engage_3 in cBehSwitch
{
	var stupidArray : array< name >;

	event OnEnterState(prevStateName : name)
	{
		BehSwitch_3();
	}

	entry function BehSwitch_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}
}

state BehSwitch_Engage_2 in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var stupidArray, stupidArray_swordwalk 				: array< name >;

	event OnEnterState(prevStateName : name)
	{
		defaultBehSwitchEntry();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{	
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}

	entry function defaultBehSwitchEntry()
	{
		ACS_Theft_Prevention_6();

		ACS_WeaponDestroyInit();

		HybridTagRemoval();

		ActivateBehaviors_Default();

		/*
		if (ACS_SwordWalk_Enabled())
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}	
		*/

		if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
		{
			thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
		}
			

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

		RestoreStuff();
	}

	latent function RestoreStuff()
	{
		Sleep(0.25);

		if ( ACS_GetWeaponMode() == 0 )
		{
			ACS_PrimaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 1 || ACS_GetWeaponMode() == 3)
		{
			ACS_PrimaryWeaponSwitch();

			ACS_SecondaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 2 )
		{
			if ( ACS_GetHybridModeLightAttack() == 0 )
			{
				if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 1 )
			{
				if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 2 )
			{
				if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 3 )
			{
				if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 4 )
			{
				if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 5 )
			{
				if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 6 )
			{
				if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 7 )
			{
				if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 8 )
			{
				if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
		}
	}

	latent function ActivateBehaviors_Default()
	{
		if (ACS_SwordWalk_Enabled())
		{
			stupidArray_swordwalk.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray_swordwalk.PushBack( 'Gameplay' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'claw_beh' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray_swordwalk.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray_swordwalk.PushBack( 'Gameplay' );
				}
			}

			thePlayer.ActivateBehaviors(stupidArray_swordwalk);
		}
		else
		{
			stupidArray.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (
				thePlayer.HasTag('igni_secondary_sword_equipped')
				|| thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'Gameplay' );
				}
				else
				{
					stupidArray.PushBack( 'Gameplay' );
				}
			}

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}
 
state BehSwitch_Engage in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var tags 											: array< name >;
	private var stupidArray, stupidArray_swordwalk 				: array< name >;

	event OnEnterState(prevStateName : name)
	{
		Beh_Switch_Entry();
		
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{	
		ACS_Theft_Prevention_9 ();
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	entry function Beh_Switch_Entry()
	{
		if ( ACS_SwordWalk_Enabled() )
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime_SwordWalk();
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				BehSwitchPrime_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime();
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime()
	{
		ActivateBehaviors();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
			}
			else if 
			(
				thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_Passive_Taunt()
	{
		ActivateBehaviors_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
			}
			else if 
			(
				thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk()
	{
		ActivateBehaviors_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
			}
			else if 
			(
				thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
						{
							thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						}
					}
				}
			}
			else if 
			(
				thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped')
		|| thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'Gameplay' );
		}
		else
		{
			stupidArray.PushBack( 'Gameplay' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped')
		|| thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'Gameplay' );
		}
		else
		{
			stupidArray.PushBack( 'Gameplay' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SwordWalk()
	{
		stupidArray_swordwalk.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'quen_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'axii_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'yrden_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'quen_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'axii_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'aard_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'yrden_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'claw_beh' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray_swordwalk.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray_swordwalk.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}
		else
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}

		thePlayer.ActivateBehaviors(stupidArray_swordwalk);
	}

	latent function ActivateBehaviors_SwordWalk_Passive_Taunt()
	{
		stupidArray_swordwalk.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray_swordwalk.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray_swordwalk.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}
		else
		{
			stupidArray_swordwalk.PushBack( 'Gameplay' );
		}

		thePlayer.ActivateBehaviors(stupidArray_swordwalk);
	}
}

function ACS_EnemyBehDetach()
{
	var vACS_EnemyBehDetach : cACS_EnemyBehDetach;
	vACS_EnemyBehDetach = new cACS_EnemyBehDetach in theGame;
	
	vACS_EnemyBehDetach.ACS_EnemyBehDetach_Engage();

}

statemachine class cACS_EnemyBehDetach
{
    function ACS_EnemyBehDetach_Engage()
	{
		this.PushState('ACS_EnemyBehDetach_Engage');
	}
}
 
state ACS_EnemyBehDetach_Engage in cACS_EnemyBehDetach
{
	private var actors		    		: array<CActor>;
	private var actor					: CActor; 
	private var i						: int;
	private var npc						: CNewNPC;
	private var enemyAnimatedComponent 	: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		if (thePlayer.IsAlive())
		{
			EnemyBehDetach();
		}
	}
	
	entry function EnemyBehDetach()
	{
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];
				
				if ( !actor.IsAlive() )
				{
					if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
					{
						actor.DetachBehavior('sword_2handed');

						actor.TurnOnRagdoll();

						actor.RemoveTag('ACS_Swapped_To_2h_Sword');
					}

					if( actor.HasTag('ACS_Swapped_To_Witcher') )
					{
						actor.DetachBehavior('Witcher');

						actor.TurnOnRagdoll();

						actor.RemoveTag('ACS_Swapped_To_Witcher');
					}


					if( actor.HasTag('ACS_Swapped_To_Shield') )
					{
						actor.DetachBehavior( 'Shield' );

						actor.TurnOnRagdoll();

						actor.RemoveTag('ACS_Swapped_To_Shield');
					}

					//actor.DetachBehavior( 'sword_1handed' );
				}
				
			}
		}
	}
}
latent function ACS_BehSwitch(prevStateName : name)
{
	var stupidArray 	: array< name >;

	stupidArray.Clear();

	if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}
	}
	else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}
	}
	else
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh' );
			}
		}
	}

	if ( prevStateName == 'TraverseExploration' || prevStateName == 'PlayerDialogScene' )
	{
		ACS_CombatBehSwitch();
	}
	else
	{
		if(
		prevStateName=='HorseRiding'
		||prevStateName=='DismountBoat'
		||prevStateName=='DismountHorse'
		||prevStateName=='DismountTheVehicle'
		||prevStateName=='Swimming'
		||prevStateName=='MountBoat'
		||prevStateName=='MountHorse'
		||prevStateName=='MountTheVehicle'
		||prevStateName=='Sailing'
		||prevStateName=='ApproachTheVehicle'
		||prevStateName=='UseVehicle')
		{
			GetWitcherPlayer().ActivateAndSyncBehaviors(stupidArray);
		}
		else
		{
			ACS_CombatBehSwitch();
		}
	}
}

function ACS_CombatBehSwitch()
{
	var vBehSwitch 										: cBehSwitch;

	vBehSwitch = new cBehSwitch in theGame;
	
	if (!GetWitcherPlayer().IsCiri() 
	&& GetWitcherPlayer().IsAlive()
	)
	{
		if (!GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle())
		{
			vBehSwitch.BehSwitch_Engage();

			if ( !ACS_MS_Enabled() && !ACS_MS_Installed() )
			{
				GetACSWatcher().register_extra_inputs();
			}
			
			if (!GetWitcherPlayer().IsInCombat())
			{
				if (GetWitcherPlayer().HasTag ('summoned_shades'))
				{
					GetWitcherPlayer().RemoveTag('summoned_shades');
				}
				
				if (GetWitcherPlayer().HasTag ('ethereal_shout'))
				{
					GetWitcherPlayer().RemoveTag('ethereal_shout');
				}
				
				/*
				if (GetWitcherPlayer().HasTag ('vampire_claws_equipped'))
				{
					ClawDestroy();

					GetWitcherPlayer().PlayEffectSingle('claws_effect');
					GetWitcherPlayer().StopEffect('claws_effect');
				}
				*/

				GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

				GetWitcherPlayer().StopEffect('special_attack_fx');

				if ( !ACS_Transformation_Activated_Check() )
				{
					GetWitcherPlayer().BreakAttachment();
				}
				
				ACS_Skele_Destroy();

				ACS_Sword_Array_Fire_Override();

				ACS_Revenant_Destroy();

				GetWitcherPlayer().StopEffect('drain_energy');

				GetACSWatcher().Remove_On_Hit_Tags();

				GetACSWatcher().BerserkMarkDestroy();

				HybridTagRemoval();

				ACS_Axii_Shield_Destroy_IMMEDIATE();

				ACS_Shield_Destroy();

				ACS_ThingsThatShouldBeRemoved();

				ACS_RemoveStabbedEntities();

				Bruxa_Camo_Decoy_Deactivate();

				GetACSTentacle_1().Destroy();

				GetACSTentacle_2().Destroy();

				GetACSTentacle_3().Destroy();

				GetACSTentacleAnchor().Destroy();

				GetACSWatcher().SetRageProcess(false);

				//GetWitcherPlayer().RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
				
				//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2, false);

				IgniBowDestroy();
				AxiiBowDestroy();
				AardBowDestroy();
				YrdenBowDestroy();
				QuenBowDestroy();

				//ACS_NekkerGuardianShareLifeForce_Destroy();

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();

				ACS_Forest_God_Spawn_Controller();

				ACS_Wild_Hunt_Spawn_Controller();

				ACS_NightStalker_Spawn_Controller();
			}
			else
			{
				if (ACS_Armor_Equipped_Check())
				{
					thePlayer.SoundEvent("monster_caretaker_fx_summon");
					thePlayer.SoundEvent("monster_caretaker_fx_summon");
					thePlayer.SoundEvent("monster_caretaker_fx_summon");
					thePlayer.SoundEvent("monster_caretaker_fx_summon");
					thePlayer.SoundEvent("monster_caretaker_fx_summon");
				}
			}
		}
	}
}

function ACS_Forest_God_Spawn_Controller()
{
	if (ACS_Forest_God() 
	&& VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), ACS_Forest_God().GetWorldPosition() ) <= 800 * 800 
	&& ACS_ShadowsSpawnChancesNormal() != 0
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
	&& !GetWitcherPlayer().IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	)
	{
		if (
		GetWitcherPlayer().inv.HasItem('mh204_leshy_trophy')
		|| GetWitcherPlayer().inv.HasItem('mh302_leshy_trophy')
		|| GetWitcherPlayer().inv.HasItem('Leshy resin')
		|| GetWitcherPlayer().inv.HasItem('sq204_leshy_talisman')
		|| GetWitcherPlayer().inv.HasItem('Ancient Leshy mutagen')
		|| GetWitcherPlayer().inv.HasItem('Leshy mutagen')
		)
		{
			if( RandF() < 0.3 ) 
			{
				if( ACS_can_spawn_forest_god_shadows() ) 
				{
					ACS_refresh_forest_god_shadows_cooldown();

					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().DisplayHudMessage( "LESHEN ITEMS DETECTED IN INVENTORY. YOU SHALL NOT ESCAPE ME." );
					}
					else
					{
						GetWitcherPlayer().DisplayHudMessage( "LESHEN ITEMS DETECTED IN INVENTORY. I WILL FIND YOU." );
					}

					ACS_Forest_God_Shadows_Spawner();
				}
			}
		}
		else
		{
			if( RandF() < ACS_ShadowsSpawnChancesNormal() ) 
			{
				if( ACS_can_spawn_forest_god_shadows() ) 
				{
					ACS_refresh_forest_god_shadows_cooldown();

					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().DisplayHudMessage( "I SMELL YOUR FEAR, WITCHER. IT DELIGHTS ME." );
					}
					else
					{
						GetWitcherPlayer().DisplayHudMessage( "TELL ME, WITCHER. DO YOU FEAR DEATH?" );
					}

					ACS_Forest_God_Shadows_Spawner();
				}
			}
		}
	}
}

function ACS_Wild_Hunt_Spawn_Controller()
{
	if( RandF() < ACS_WildHuntSpawnChancesNormal() ) 
	{
		if (ACS_can_spawn_wild_hunt_warriors())
		{
			ACS_refresh_wild_hunt_warriors_spawn_cooldown();

			ACS_Wild_Hunt_Riders_Spawner();
		}
	}
}

function ACS_NightStalker_Spawn_Controller()
{
	if( RandF() < ACS_NightStalkerSpawnChancesNormal() 
	&& ACS_IsNight()
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
	&& !GetWitcherPlayer().IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& GetWitcherPlayer().IsOnGround()
	&& ACS_NightStalkerAreaCheck()
	&& !GetWitcherPlayer().IsInInterior()
	)
	{
		if (ACS_can_spawn_nightstalker())
		{
			ACS_refresh_nightstalker_spawn_cooldown();

			ACS_SpawnNightStalker();
		}
	}
}

function ACS_ExplorationBehSwitch()
{
	var vBehSwitch : cBehSwitch;
	vBehSwitch = new cBehSwitch in theGame;
	
	if (!GetWitcherPlayer().IsCiri() 
	&& GetWitcherPlayer().IsAlive())
	{
		vBehSwitch.BehSwitch_Engage_3();
	}
}

function ACS_BehSwitchINIT()
{
	var vBehSwitch : cBehSwitch;
	vBehSwitch = new cBehSwitch in theGame;
	
	if (ACS_Enabled())
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive()
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
		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			BehSwitch_SCAAR_3();
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
		{
			BehSwitch_E3ARP_3();
		}
		else
		{
			BehSwitch_3();
		}	
	}

	entry function BehSwitch_E3ARP_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	entry function BehSwitch_SCAAR_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	entry function BehSwitch_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}
}

state BehSwitch_Engage_2 in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		defaultBehSwitchEntry();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('fist'))
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
		
		GetWitcherPlayer().SetBehaviorVariable( 'WeaponType', 0);
		
		if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( GetWitcherPlayer().IsUsingHorse() )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 0, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 1, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			default:
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}

	entry function defaultBehSwitchEntry()
	{
		ACS_WeaponDestroyInit();

		HybridTagRemoval();

		if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
		{
			GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
		}

		ACS_Load_Sound();

		RestoreStuff();
	}

	latent function RestoreStuff()
	{
		GetWitcherPlayer().BreakAttachment();

		GetWitcherPlayer().SetVisibility(true);

		GetWitcherPlayer().EnableCollisions(true);

		GetWitcherPlayer().SetCanPlayHitAnim(true); 

		GetWitcherPlayer().EnableCharacterCollisions(true);

		GetWitcherPlayer().RemoveBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative'); 
		GetWitcherPlayer().RemoveBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical'); 
		GetWitcherPlayer().RemoveBuffImmunity_AllNegative('ACS_Finisher_Immune_Negative'); 
		GetWitcherPlayer().RemoveBuffImmunity_AllCritical('ACS_Finisher_Immune_Critical'); 

		Sleep(0.0625);

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
				if (!GetWitcherPlayer().HasTag('HybridDefaultWeaponTicket')){GetWitcherPlayer().AddTag('HybridDefaultWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 1 )
			{
				if (!GetWitcherPlayer().HasTag('HybridOlgierdWeaponTicket')){GetWitcherPlayer().AddTag('HybridOlgierdWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 2 )
			{
				if (!GetWitcherPlayer().HasTag('HybridEredinWeaponTicket')){GetWitcherPlayer().AddTag('HybridEredinWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 3 )
			{
				if (!GetWitcherPlayer().HasTag('HybridClawWeaponTicket')){GetWitcherPlayer().AddTag('HybridClawWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 4 )
			{
				if (!GetWitcherPlayer().HasTag('HybridImlerithWeaponTicket')){GetWitcherPlayer().AddTag('HybridImlerithWeaponTicket');}

				ACS_PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 5 )
			{
				if (!GetWitcherPlayer().HasTag('HybridSpearWeaponTicket')){GetWitcherPlayer().AddTag('HybridSpearWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 6 )
			{
				if (!GetWitcherPlayer().HasTag('HybridGregWeaponTicket')){GetWitcherPlayer().AddTag('HybridGregWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 7 )
			{
				if (!GetWitcherPlayer().HasTag('HybridAxeWeaponTicket')){GetWitcherPlayer().AddTag('HybridAxeWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 8 )
			{
				if (!GetWitcherPlayer().HasTag('HybridGiantWeaponTicket')){GetWitcherPlayer().AddTag('HybridGiantWeaponTicket');}

				ACS_SecondaryWeaponSwitch();
			}
		}

		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			ActivateBehaviors_SCAAR_Default();
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
		{
			ActivateBehaviors_E3ARP_Default();
		}
		else
		{
			ActivateBehaviors_Default();
		}
	}

	latent function ActivateBehaviors_E3ARP_Default()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_Default()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_Default()
	{
		if (ACS_SwordWalk_Enabled())
		{
			stupidArray.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
			}

			GetWitcherPlayer().ActivateBehaviors(stupidArray);
		}
		else
		{
			stupidArray.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else
			{
				if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
				else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
			}

			GetWitcherPlayer().ActivateBehaviors(stupidArray);
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
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		Beh_Switch_Entry();
		
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('fist'))
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
		
		GetWitcherPlayer().SetBehaviorVariable( 'WeaponType', 0);
		
		if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( GetWitcherPlayer().IsUsingHorse() )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 0, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 1, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			default:
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	entry function Beh_Switch_Entry()
	{
		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			if ( ACS_SwordWalk_Enabled() )
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_SCAAR_SwordWalk();
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_SCAAR_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_SCAAR();
				}
			}
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
		{
			if ( ACS_SwordWalk_Enabled() )
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_E3ARP_SwordWalk();
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_E3ARP_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_E3ARP();
				}
			}
		}
		else
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
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
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
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
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
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
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
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_Passive_Taunt()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SwordWalk()
	{
		stupidArray.Clear();
		
		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();
		
		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_SCAAR()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_Passive_Taunt()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_SwordWalk()
	{
		stupidArray.Clear();
		
		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();
		
		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR()
	{
		ActivateBehaviors_SCAAR();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk()
	{
		ActivateBehaviors_SCAAR_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_SCAAR_Passive_Taunt()
	{
		ActivateBehaviors_SCAAR_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_SCAAR_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_E3ARP()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_Passive_Taunt()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_SwordWalk()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();

		if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_bow_equipped')
		|| GetWitcherPlayer().HasTag('axii_bow_equipped')
		|| GetWitcherPlayer().HasTag('aard_bow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_bow_equipped')
		|| GetWitcherPlayer().HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		|| GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (
		GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}

		GetWitcherPlayer().ActivateBehaviors(stupidArray);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP()
	{
		ActivateBehaviors_E3ARP();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk()
	{
		ActivateBehaviors_E3ARP_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_E3ARP_Passive_Taunt()
	{
		ActivateBehaviors_E3ARP_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_E3ARP_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_bow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
			{
				if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().HasTag('axii_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && GetWitcherPlayer().HasTag('aard_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
				}
				else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().HasTag('axii_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && GetWitcherPlayer().HasTag('aard_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().HasTag('yrden_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().HasTag('quen_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else if 
			(
				GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
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
		if (GetWitcherPlayer().IsAlive())
		{
			EnemyBehDetach();
		}
	}
	
	entry function EnemyBehDetach()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer );

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
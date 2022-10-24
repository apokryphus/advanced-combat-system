function ACS_OnTakeDamage(action: W3DamageAction)
{
	if( thePlayer.IsActionBlockedBy(EIAB_Movement, 'Mutation11') && GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) && !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) && !GetWitcherPlayer().IsInAir() )
	{
		thePlayer.AddTag('ACS_Second_Life_Active');
	}

	ACS_Player_Fall_Negate(action);
	
	ACS_Take_Damage(action);

	ACS_Player_Attack(action);

    ACS_Player_Guard(action);

    ACS_Forest_God_Attack(action);

    ACS_Ice_Titan_Attack(action);
}

function ACS_Player_Fall_Negate(action: W3DamageAction)
{
	if (
	(CPlayer)action.victim && action.GetBuffSourceName() == "FallingDamage")
	{
		//action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * ACS_Player_Fall_Damage();

		action.SetCanPlayHitParticle(false);

		action.SetProcessBuffsIfNoDamage(false);

		if (
		(thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
		) 
		{
			ACS_ThingsThatShouldBeRemoved();

			thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Focus) );

			thePlayer.ClearAnimationSpeedMultipliers();

			GetACSWatcher().Grow_Geralt_Immediate();

			thePlayer.SoundEvent("cmb_play_dismemberment_gore");

			thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			thePlayer.SoundEvent("cmb_play_hit_heavy");

			GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

			GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

			ACS_Death_Animations_For_Falling(action);
		}
		else
		{
			thePlayer.StopEffect( 'heavy_hit' );

			thePlayer.StopEffect( 'hit_screen' );	

			thePlayer.PlayEffectSingle('quen_lasting_shield_hit');

			thePlayer.StopEffect('quen_lasting_shield_hit');

			thePlayer.PlayEffectSingle('lasting_shield_discharge');

			thePlayer.StopEffect('lasting_shield_discharge');
		}	
	}
}

function ACS_Player_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var settingsA, settingsB, settings_interrupt																					: SAnimatedComponentSlotAnimationSettings;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist										: float;
	var itemId_r, itemId_l 																											: SItemUniqueId;
	var itemTags_r, itemTags_l 																										: array<name>;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
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

		if(!theGame.IsDialogOrCutscenePlaying()
		&& !thePlayer.IsUsingHorse() 
		&& !thePlayer.IsUsingVehicle()
		&& npc.IsHuman()
		&& npc.IsMan()
		&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
		&& !npc.HasTag( 'ethereal' )
		&& !npc.HasBuff(EET_Burning)
		)
		{
			itemId_r = npc.GetInventory().GetItemFromSlot('r_weapon');

			itemId_l = npc.GetInventory().GetItemFromSlot('l_weapon');

			npc.GetInventory().GetItemTags(itemId_r, itemTags_r);

			npc.GetInventory().GetItemTags(itemId_l, itemTags_l);

			if ( 
			npc.GetStat( BCS_Vitality ) <= 0.1
			)
			{
				if( npc.HasTag('ACS_One_Hand_Swap_Stage_1') )
				{
					npc.RemoveTag('ACS_One_Hand_Swap_Stage_1');
				}

				if( npc.HasTag('ACS_One_Hand_Swap_Stage_2') )
				{
					npc.RemoveTag('ACS_One_Hand_Swap_Stage_2');
				}

				if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
				{
					npc.DetachBehavior('sword_2handed');

					npc.RemoveTag('ACS_Swapped_To_2h_Sword');
				}

				if( npc.HasTag('ACS_Swapped_To_Witcher') )
				{
					npc.DetachBehavior('Witcher');

					npc.RemoveTag('ACS_Swapped_To_Witcher');
				}

				if( npc.HasTag('ACS_Swapped_To_Shield') )
				{
					npc.DetachBehavior( 'Shield' );

					npc.RemoveTag('ACS_Swapped_To_Shield');
				}
			}
			else
			{
				if ( 
				itemTags_r.Contains('sword1h') 
				|| itemTags_r.Contains('axe1h')
				|| itemTags_r.Contains('blunt1h')
				|| itemTags_r.Contains('steelsword')
				)
				{
					if ( 
					((npc.GetStat(BCS_Vitality) <= npc.GetStatMax(BCS_Vitality) * RandRangeF(0.75,0.5) )
					|| (npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetStatMax(BCS_Vitality) * RandRangeF(0.75,0.5)))
					&& !npc.HasTag('ACS_One_Hand_Swap_Stage_1'))
					{
						if( RandF() < 0.5 ) 
						{
							ACS_EnemyBehSwitch_OnHit(2);

							npc.AddTag('ACS_Swapped_To_2h_Sword');
						}
						else
						{
							ACS_EnemyBehSwitch_OnHit(3);

							npc.AddTag('ACS_Swapped_To_Witcher');
						}

						npc.AddTag('ACS_One_Hand_Swap_Stage_1');
					}
					else if ( 
					((npc.GetStat(BCS_Vitality) < npc.GetStatMax(BCS_Vitality) * RandRangeF(0.5,0.25) )
					|| (npc.GetCurrentHealth() - action.processedDmg.vitalityDamage < npc.GetStatMax(BCS_Vitality) * RandRangeF(0.5,0.25)))
					&& !npc.HasTag('ACS_One_Hand_Swap_Stage_2'))
					{
						if( npc.HasTag('ACS_Swapped_To_Witcher') ) 
						{
							if (
							itemTags_l.Contains('Shield') 
							|| itemTags_l.Contains('shield') 
							)
							{
								ACS_EnemyBehSwitch_OnHit(2);

								npc.AddTag('ACS_Swapped_To_2h_Sword');
							}
							else
							{
								if (thePlayer.IsGuarded())
								{
									if( RandF() < 0.75 ) 
									{
										ACS_EnemyBehSwitch_OnHit(4);

										npc.AddTag('ACS_Swapped_To_Shield');
									}
									else
									{
										ACS_EnemyBehSwitch_OnHit(2);

										npc.AddTag('ACS_Swapped_To_2h_Sword');
									}
								}
								else
								{
									if( RandF() < 0.75 ) 
									{
										ACS_EnemyBehSwitch_OnHit(2);

										npc.AddTag('ACS_Swapped_To_2h_Sword');
									}
									else
									{
										ACS_EnemyBehSwitch_OnHit(4);

										npc.AddTag('ACS_Swapped_To_Shield');
									}
								}
							}
						}
						else if (npc.HasTag('ACS_Swapped_To_2h_Sword'))
						{
							if (
							itemTags_l.Contains('Shield') 
							|| itemTags_l.Contains('shield') 
							)
							{
								ACS_EnemyBehSwitch_OnHit(3);

								npc.AddTag('ACS_Swapped_To_Witcher');
							}
							else
							{
								if (thePlayer.IsGuarded())
								{
									if( RandF() < 0.75 ) 
									{
										ACS_EnemyBehSwitch_OnHit(4);

										npc.AddTag('ACS_Swapped_To_Shield');
									}
									else
									{
										ACS_EnemyBehSwitch_OnHit(3);

										npc.AddTag('ACS_Swapped_To_Witcher');
									}
								}
								else
								{
									if( RandF() < 0.75 ) 
									{
										ACS_EnemyBehSwitch_OnHit(3);

										npc.AddTag('ACS_Swapped_To_Witcher');
									}
									else
									{
										ACS_EnemyBehSwitch_OnHit(4);

										npc.AddTag('ACS_Swapped_To_Shield');
									}
								}
							}
						}

						npc.AddTag('ACS_One_Hand_Swap_Stage_2');
					}
				}
			}
		}

		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if (action.DealsAnyDamage())
			{
				if ( !thePlayer.HasTag('ACS_Storm_Spear_Active') && !thePlayer.HasTag('ACS_Sparagmos_Active') )
				{
					GetACSWatcher().weapon_blood_fx();
				}

				if ( action.GetHitReactionType() == EHRT_Light )
				{
					//ACS_Light_Attack_Trail();

					if (thePlayer.IsDeadlySwordHeld())
					{
						if ( thePlayer.HasTag('ACS_Storm_Spear_Active') )
						{
							thePlayer.SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_light");
							thePlayer.SoundEvent("cmb_play_hit_light");
						}
					}
				}
				else if ( action.GetHitReactionType() == EHRT_Heavy )
				{
					//ACS_Heavy_Attack_Trail();
					
					if (thePlayer.IsDeadlySwordHeld())
					{
						if ( thePlayer.HasTag('ACS_Storm_Spear_Active') )
						{
							thePlayer.SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_heavy");
							thePlayer.SoundEvent("cmb_play_hit_heavy");
						}
					}
				}
			}

			ACS_Caretaker_Drain_Energy();

			if (thePlayer.CanUseSkill(S_Sword_s01) && action.GetHitReactionType() != EHRT_Reflect)
			{
				npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

				npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

				npc.ForceSetStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) + npc.GetStatMax( BCS_Stamina ) * 0.5 );
			}
			
			if ( action.HasAnyCriticalEffect() 
			|| action.GetIsHeadShot() 
			|| action.HasForceExplosionDismemberment()
			|| action.IsCriticalHit() )
			{
				ACS_Wraith_Attack_Trail();
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
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}

					action.SetCanPlayHitParticle(false);
					action.SetSuppressHitSounds(true);
					action.SuppressHitSounds();
				}

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
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
							
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
								
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
							
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );	

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
			}
			else if ( 
			thePlayer.HasTag('axii_sword_equipped')
			|| thePlayer.HasTag('axii_secondary_sword_equipped')
			|| thePlayer.HasTag('quen_sword_equipped'))
			{
				finisherDist = 1.5f;

				if (ACS_Player_Scale() > 1)
				{
					finisherDist += ACS_Player_Scale() * 0.75;
				}

				if (
				VecDistance( thePlayer.GetWorldPosition(), npc.GetNearestPointInBothPersonalSpaces( thePlayer.GetWorldPosition() ) ) > finisherDist
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

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
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
								
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
								
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
							
								npc.DrainMorale( npc.GetStatMax( BCS_Morale ) );  
									
								npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) );

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
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
							
								npc.DrainMorale( npc.GetStatMax( BCS_Morale ) );  
									
								npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) );

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
			}
			else if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				npc.StopEffect('focus_sound_red_fx');

				if (((CActor)npc).HasAbility('DisableDismemberment'))
				{
					((CActor)npc).RemoveAbility( 'DisableDismemberment');
				}

				if (npc.IsUsingVehicle()) 
				{
					npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
				}

				thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

				thePlayer.IncreaseUninterruptedHitsCount();	

				ACS_Passive_Weapon_Effects_Switch();

				if (npc.UsesEssence())
				{
					thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.1 ); 

					maxTargetEssence = npc.GetStatMax( BCS_Essence );
					
					damageMax = maxTargetEssence * ACS_Vampire_Claws_Monster_Max_Damage(); 
					
					damageMin = maxTargetEssence * ACS_Vampire_Claws_Monster_Min_Damage(); 

					action.processedDmg.essenceDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.essenceDamage;
				}
				else if (npc.UsesVitality())
				{
					thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.05 );

					maxTargetVitality = npc.GetStatMax( BCS_Vitality );

					damageMax = maxTargetVitality * ACS_Vampire_Claws_Human_Max_Damage(); 
					
					damageMin = maxTargetVitality * ACS_Vampire_Claws_Human_Min_Damage(); 

					action.processedDmg.vitalityDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.vitalityDamage;
				}

				if( !npc.IsImmuneToBuff( EET_Bleeding ) && !npc.HasBuff( EET_Bleeding ) ) 
				{ 
					npc.AddEffectDefault( EET_Bleeding, thePlayer, 'acs_vampire_claw_effects' );	
				}

				if( !npc.IsImmuneToBuff( EET_BleedingTracking ) && !npc.HasBuff( EET_BleedingTracking ) ) 
				{ 
					npc.AddEffectDefault( EET_BleedingTracking, thePlayer, 'acs_vampire_claw_effects' );	
				}
				
				if (thePlayer.IsGuarded())
				{
					thePlayer.GainStat( BCS_Vitality, heal ); 
				}
				else
				{
					thePlayer.GainStat( BCS_Vitality, heal * 2 ); 
				}
				
				if ( thePlayer.HasBuff(EET_BlackBlood) )
				{
					if (RandF() < 0.5 )
					{
						ACS_Vampire_Arms_1_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_1_Get().StopEffect('blood');

						ACS_Vampire_Arms_2_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_2_Get().StopEffect('blood');

						ACS_Vampire_Arms_3_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_3_Get().StopEffect('blood');

						ACS_Vampire_Arms_4_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_4_Get().StopEffect('blood');

						thePlayer.PlayEffectSingle('blood_effect_claws');
						thePlayer.StopEffect('blood_effect_claws');
					}
				}

				thePlayer.SoundEvent("cmb_play_dismemberment_gore");

				thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				/*
				dmg = new W3DamageAction in theGame.damageMgr;
				
				dmg.Initialize(thePlayer, npc, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				//dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Heavy, true);

				dmg.SetIgnoreArmor(true);

				dmg.SetIgnoreImmortalityMode(true);
				
				//dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

				if (npc.UsesVitality()) 
				{ 
					//if (ACS_Vampire_Claws_Human_Max_Damage() <= 0.25)
					if (ACS_Vampire_Claws_Human_Max_Damage() <= 1)
					{
						dmg.SetForceExplosionDismemberment();
					}

					if (ACS_Vampire_Claws_Human_Max_Damage() == 1)
					{
						dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					}
					else
					{
						dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) + (damageMax * (GetACSWatcher().combo_counter_damage * 0.1)) );
					}
				}
				else if (npc.UsesEssence()) 
				{ 
					//if (ACS_Vampire_Claws_Monster_Max_Damage() <= 0.25)
					if (ACS_Vampire_Claws_Monster_Max_Damage() <= 1)
					{
						dmg.SetForceExplosionDismemberment();
					}

					if (ACS_Vampire_Claws_Monster_Max_Damage() == 1 )
					{
						dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					}
					else
					{
						dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) + (damageMax * (GetACSWatcher().combo_counter_damage * 0.1)) );
					}
				}

				if (RandF() < 0.05 )
				{
					if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
					{ 
						dmg.AddEffectInfo( EET_Stagger, 0.1 );
					}
				}

				if( !npc.IsImmuneToBuff( EET_Bleeding ) && !npc.HasBuff( EET_Bleeding ) ) 
				{ 
					dmg.AddEffectInfo( EET_Bleeding, 1 );
				}

				if( !npc.IsImmuneToBuff( EET_BleedingTracking ) && !npc.HasBuff( EET_BleedingTracking ) ) 
				{ 
					dmg.AddEffectInfo( EET_BleedingTracking, 3 );
				}
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	
				*/

				return;
			}		
		}
	}
}

function ACS_Player_Guard(action: W3DamageAction)
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
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

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
	&& !thePlayer.HasTag('igni_sword_equipped')
	&& !thePlayer.HasTag('igni_secondary_sword_equipped')
	)
	{
		if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			if ( action.DealsAnyDamage() && thePlayer.GetStat( BCS_Stamina ) >= thePlayer.GetStatMax( BCS_Stamina ) * 0.05 )
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
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
						thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.05, 1, );
					}
		
					if ( RandF() < 0.5 )
					{
						if ( RandF() < 0.45 )
						{
							if ( RandF() < 0.45 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_01_ACS', 'PLAYER_SLOT', settingsB );
								thePlayer.StopEffect('left_sparks');
								thePlayer.PlayEffectSingle('left_sparks');
							}
							else
							{
								if ( RandF() < 0.5 )
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', settingsB );
									thePlayer.StopEffect('taunt_sparks');
									thePlayer.PlayEffectSingle('taunt_sparks');
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_left_ACS', 'PLAYER_SLOT', settingsB );
									thePlayer.StopEffect('left_sparks');
									thePlayer.PlayEffectSingle('left_sparks');
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

							thePlayer.StopEffect('left_sparks');
							thePlayer.PlayEffectSingle('left_sparks');
						}
					}
					else
					{
						if ( RandF() < 0.45 )
						{
							if ( RandF() < 0.45 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_01_ACS', 'PLAYER_SLOT', settingsB );
								thePlayer.StopEffect('right_sparks');
								thePlayer.PlayEffectSingle('right_sparks');
							}
							else
							{
								if ( RandF() < 0.5 )
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', settingsB );
									thePlayer.StopEffect('taunt_sparks');
									thePlayer.PlayEffectSingle('taunt_sparks');
								}
								else
								{
									playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_right_ACS', 'PLAYER_SLOT', settingsB );
									thePlayer.StopEffect('right_sparks');
									thePlayer.PlayEffectSingle('right_sparks');
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
							thePlayer.StopEffect('right_sparks');
							thePlayer.PlayEffectSingle('right_sparks');
						}
					}
				}
			}
		}
		else if ( thePlayer.HasTag('axii_sword_equipped') )
		{
			if ( thePlayer.GetStat( BCS_Stamina ) >= thePlayer.GetStatMax( BCS_Stamina ) * 0.05 )
			{
				vACS_Shield_Summon = new cACS_Shield_Summon in theGame;

				vACS_Shield_Summon.Axii_Persistent_Shield_Summon();

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
}

function ACS_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var settingsA, settingsB, settings_interrupt																					: SAnimatedComponentSlotAnimationSettings;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality, money 																								: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	&& action.GetBuffSourceName() != "FallingDamage"
	&& !GetWitcherPlayer().IsAnyQuenActive()
	/*
	&& (thePlayer.HasTag('aard_sword_equipped')
	|| thePlayer.HasTag('aard_secondary_sword_equipped')
	|| thePlayer.HasTag('yrden_sword_equipped')
	|| thePlayer.HasTag('yrden_secondary_sword_equipped')
	|| thePlayer.HasTag('quen_secondary_sword_equipped')
	|| thePlayer.HasTag('axii_sword_equipped')
	|| thePlayer.HasTag('axii_secondary_sword_equipped')
	|| thePlayer.HasTag('quen_sword_equipped')
	|| thePlayer.HasTag('igni_sword_equipped')
	|| thePlayer.HasTag('igni_secondary_sword_equipped')
	|| thePlayer.HasTag('vampire_claws_equipped') )
	*/
	)
	{	
		if (
		(thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
		) 
		{
			if (((CNewNPC)npcAttacker).GetNPCType() == ENGT_Guard)
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage - thePlayer.GetCurrentHealth();
       			action.processedDmg.vitalityDamage -= 1.0;

				if (thePlayer.GetStat( BCS_Focus ) != 0)
				{
					thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) );
				}
				
				money = thePlayer.GetMoney();
				
				switch ( theGame.GetDifficultyLevel() )
				{
					case EDM_Easy:		money *= 0.025;  break;
					case EDM_Medium:	money *= 0.050;  break;
					case EDM_Hard:		money *= 0.075;  break;
					case EDM_Hardcore:	money *= 0.1;   break;
					default : 			money *= 0; 	 break;
				}
				
				if (money != 0)
				{
					thePlayer.RemoveMoney((int)money);
					GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_guards_took_money") );
				}
				else
				{
					npcAttacker.SetHealthPerc(100);
				}
				
				GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

				movementAdjustor.CancelAll();

				ACS_Hit_Animations(action);
			}
			else
			{
				if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
				{
					ACS_ThingsThatShouldBeRemoved();

					if (thePlayer.GetStat( BCS_Focus ) != 0)
					{
						thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) );
					}

					thePlayer.ClearAnimationSpeedMultipliers();

					GetACSWatcher().Grow_Geralt_Immediate();

					thePlayer.SoundEvent("cmb_play_dismemberment_gore");

					thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

					thePlayer.SoundEvent("cmb_play_hit_heavy");

					GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

					GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

					ACS_Death_Animations(action);
				}
			}
		}
		else
		{
			if (
			!action.IsDoTDamage()
			&& action.GetHitReactionType() != EHRT_Reflect
			&& !thePlayer.IsInGuardedState()
			&& !thePlayer.IsGuarded()
			&& !thePlayer.IsCurrentlyDodging()
			&& !action.WasDodged()
			&& !thePlayer.IsPerformingFinisher()
			&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
			&& action.GetBuffSourceName() != "vampirism" 
			)
			{
				if ( npcAttacker.HasTag('ACS_taunted') )
				{
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
						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

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
					GetACSWatcher().Grow_Geralt_Immediate();

					thePlayer.ClearAnimationSpeedMultipliers();	

					thePlayer.DrainFocus( thePlayer.GetStatMax(BCS_Focus) * 0.75 );

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
							if( ( RandF() < 0.45) || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.1 ) 
							{
								GetACSWatcher().Grow_Geralt_Immediate();

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.325;

								movementAdjustor.CancelAll();

								ACS_Hit_Animations(action);
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

								movementAdjustor.CancelAll();

								ACS_Hit_Animations(action);
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

								movementAdjustor.CancelAll();

								ACS_Hit_Animations(action);
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

							movementAdjustor.CancelAll();

							ACS_Hit_Animations(action);
						}
					}
					else
					{
						GetACSWatcher().ACS_Combo_Mode_Reset_Hard();
						
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

						movementAdjustor.CancelAll();

						ACS_Hit_Animations(action);
					}
				}
			}		
		}	
	}
}

function ACS_Death_Animations(action: W3DamageAction)
{
    var settingsB, settings_interrupt			            : SAnimatedComponentSlotAnimationSettings;
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

    if(thePlayer.HasTag('vampire_claws_equipped'))
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', settings_interrupt );
        }
        else
        {
           thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', settings_interrupt );
        }

        GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.5, false);
    }
    else
    {
        if( RandF() < 0.5 ) 
        { 																		
            if( RandF() < 0.5 ) 
            { 
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', settings_interrupt );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', settings_interrupt );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
        else
        {	
            if( RandF() < 0.5 ) 
            { 
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', settings_interrupt );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 0.5, false);
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', settings_interrupt );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
    }
}

function ACS_Death_Animations_For_Falling(action: W3DamageAction)
{
    var settingsB, settings_interrupt			            : SAnimatedComponentSlotAnimationSettings;
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

    if( RandF() < 0.5 ) 
	{ 
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', settings_interrupt );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
	else
	{
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', settings_interrupt );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
}

function ACS_Hit_Animations(action: W3DamageAction)
{
    var settingsB, settings_interrupt			            : SAnimatedComponentSlotAnimationSettings;
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;
	
    if ( ( thePlayer.HasTag('vampire_claws_equipped') && !thePlayer.HasBuff(EET_BlackBlood) ) || thePlayer.HasTag('aard_sword_equipped') )
    {
        GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', settingsB );
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_1_ACS', 'PLAYER_SLOT', settingsB );
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_ACS', 'PLAYER_SLOT', settingsB );
            }
        }
    }
    else if(thePlayer.HasTag('quen_sword_equipped'))
    {
        if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5)
        {
            if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
            {
                if ( RandF() < 0.5 )
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_cheast_lp_001_ACS', 'PLAYER_SLOT', settingsB );
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_lp_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_rp_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_lp_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_rp_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }
                }        
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settings_interrupt );
            }
        }
        else
        {
            if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_down_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_hips_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_strong_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_strong_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_left_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_right_ACS', 'PLAYER_SLOT', settingsB );
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
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_left_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_right_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            } 
                        }
                    }	
                }
            }	
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
            }
        }    
    }
    else if( thePlayer.HasTag('quen_secondary_sword_equipped') || thePlayer.HasTag('yrden_secondary_sword_equipped') || thePlayer.HasTag('yrden_sword_equipped') || thePlayer.HasTag('aard_secondary_sword_equipped') )
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_lp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_lp_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_up_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_down_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_up_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_lp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_down_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_lp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                        }
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_rp_01_ACS', 'PLAYER_SLOT', settingsB );
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_lp_01_ACS', 'PLAYER_SLOT', settingsB );
            }
        }
    }
    else if( thePlayer.HasTag('axii_sword_equipped') )
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_02_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_03_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_04_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_05_ACS', 'PLAYER_SLOT', settingsB );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_down_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_01_ACS', 'PLAYER_SLOT', settingsB );
                                    }
                                    else
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_02_ACS', 'PLAYER_SLOT', settingsB );
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_03_ACS', 'PLAYER_SLOT', settingsB );
                                    }
                                    else
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_04_ACS', 'PLAYER_SLOT', settingsB );
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
                                    if ( RandF() < 0.5 )
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_01_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_02_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_03_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_04_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_05_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_06_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_07_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_up_ACS', 'PLAYER_SLOT', settingsB );
                                        }
                                    }
                                }
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
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_01_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_02_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_03_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_04_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_05_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_06_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_07_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_ACS', 'PLAYER_SLOT', settingsB );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_02_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_03_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_04_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
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
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_02_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_03_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_down_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_04_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_05_ACS', 'PLAYER_SLOT', settingsB );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_02_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_03_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_down_ACS', 'PLAYER_SLOT', settingsB );
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
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_up_ACS', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_01_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_02_ACS', 'PLAYER_SLOT', settingsB );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_03_ACS', 'PLAYER_SLOT', settingsB );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_04_ACS', 'PLAYER_SLOT', settingsB );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_01_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_02_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_03_ACS', 'PLAYER_SLOT', settingsB );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_up_ACS', 'PLAYER_SLOT', settingsB );
                            }
                        }
                    }
                }
            }
        }
        else
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_back_ACS', 'PLAYER_SLOT', settingsB );
        }
    }
    else if( thePlayer.HasTag('axii_secondary_sword_equipped') )
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_lp_01_ACS', 'PLAYER_SLOT', settingsB );
                }
                else
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_rp_01_ACS', 'PLAYER_SLOT', settingsB );
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_1_ACS', 'PLAYER_SLOT', settingsB );
                }
                else
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_2_ACS', 'PLAYER_SLOT', settingsB );
                }
            }
        }	
        else
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_b_1_ACS', 'PLAYER_SLOT', settingsB );
        }
    }
	/*
    else 
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', settingsB );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', settingsB );
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
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', settingsB );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', settingsB );
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', settingsB );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', settingsB );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', settingsB );
                        }
                    }
                }	
            }
        }	
        else
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', settingsB );
        }
    }
	*/
}

function ACS_Forest_God_Attack(action: W3DamageAction)
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
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God')
	&& !action.IsDoTDamage()
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

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}
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
						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

						playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' ); 							

						npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
					}
					else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
					{
						npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}
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

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}
						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
					}
				}
			}
		}
		else
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

				playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

				playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
}

function ACS_Ice_Titan_Attack(action: W3DamageAction)
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
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	settingsA.blendIn = 0.25f;
	settingsA.blendOut = 0.75f;

	settingsB.blendIn = 0.3f;
	settingsB.blendOut = 0.3f;
	
	settings_interrupt.blendIn = 0.25f;
	settings_interrupt.blendOut = 0.75f;

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Ice_Titan')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if (thePlayer.IsGuarded()
				&& thePlayer.IsInGuardedState())
				{
					if (!npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded')
					&& !npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded')
					)
					{
						npcAttacker.AddTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded');

						npcAttacker.AddTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}
	
						playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 			

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

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
					
					if (!npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded')
					&& !npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded')
					)
					{
						playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 					

						npcAttacker.AddTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded');
					}
					else if (npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded'))
					{
						npcAttacker.RemoveTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded');
	
						playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 			

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

						playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' ); 					

						npcAttacker.AddTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded');
					}
					else if (npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded'))
					{
						npcAttacker.RemoveTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}

						playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 		

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 						
					}
				}
			}
		}
		else
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );}

				playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

				playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
}

function ACS_EnemyBehSwitch_OnHit(i: int)
{
	var vACS_EnemyBehSwitch_OnHit : cACS_EnemyBehSwitch_OnHit;
	vACS_EnemyBehSwitch_OnHit = new cACS_EnemyBehSwitch_OnHit in theGame;
	
	if (i == 1)
	{	
		vACS_EnemyBehSwitch_OnHit.EnemyBehSwitch_Sword1h();
	}
	else if (i == 2)
	{	
		vACS_EnemyBehSwitch_OnHit.EnemyBehSwitch_Sword2h();
	}
	else if (i == 3)
	{	
		vACS_EnemyBehSwitch_OnHit.EnemyBehSwitch_Witcher();
	}
	else if (i == 4)
	{	
		vACS_EnemyBehSwitch_OnHit.EnemyBehSwitch_Shield();
	}
}

statemachine class cACS_EnemyBehSwitch_OnHit
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
}
 
state EnemyBehSwitch_Sword1h in cACS_EnemyBehSwitch_OnHit
{
	private var actor					: CActor;
	private var sword					: SItemUniqueId;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword1h();
	}
	
	entry function EnemyBehSwitch_sword1h()
	{
		actor = thePlayer.GetTarget();

		/*
		if( RandF() < 0.5 )
		{
			actor.GetInventory().AddAnItem( 'Short Steel Sword', 1 );

			sword = actor.GetInventory().GetItemId('Short Steel Sword');
		}
		else
		{
			actor.GetInventory().AddAnItem( 'NPC Hanza steel sword', 1 );

			sword = actor.GetInventory().GetItemId('NPC Hanza steel sword');
		}
		*/

		if (((CNewNPC)actor).GetNPCType() != ENGT_Quest
		&& !actor.HasBuff(EET_Burning)
		)
		{
			actor.RemoveAllBuffsOfType(EET_Ragdoll);
			actor.RemoveAllBuffsOfType(EET_HeavyKnockdown);
			actor.RemoveAllBuffsOfType(EET_Stagger);
			actor.RemoveAllBuffsOfType(EET_Knockdown);
			actor.RemoveAllBuffsOfType(EET_Burning);

			actor.RemoveBuff(EET_Burning, true);
			actor.RemoveBuff(EET_Knockdown, true);
			actor.RemoveBuff(EET_Stagger, true);
			actor.RemoveBuff(EET_HeavyKnockdown, true);
			actor.RemoveBuff(EET_Ragdoll, true);

			actor.CriticalStateAnimStopped(true);

			if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				actor.DetachBehavior('sword_2handed');

				actor.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			if( actor.HasTag('ACS_Swapped_To_Witcher') )
			{
				actor.DetachBehavior('Witcher');

				actor.RemoveTag('ACS_Swapped_To_Witcher');
			}

			if( actor.HasTag('ACS_Swapped_To_Shield') )
			{
				actor.DetachBehavior( 'Shield' );

				actor.RemoveTag('ACS_Swapped_To_Shield');
			}

			actor.AttachBehavior( 'sword_1handed' );

			actor.CriticalStateAnimStopped(true);
		}

		//actor.DropItemFromSlot('r_weapon');

		//actor.DrawItemsLatent(sword);
	}
}

state EnemyBehSwitch_Sword2h in cACS_EnemyBehSwitch_OnHit
{
	private var actor					: CActor;
	private var sword					: SItemUniqueId;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_sword2h();
	}
	
	entry function EnemyBehSwitch_sword2h()
	{
		actor = thePlayer.GetTarget();

		/*
		if( RandF() < 0.5 )
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Nilfgaardian sword 1', 1 );

				sword = actor.GetInventory().GetItemId('Nilfgaardian sword 1');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Nilfgaardian sword 2', 1 );

				sword = actor.GetInventory().GetItemId('Nilfgaardian sword 2');
			}	
		}
		else
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Nilfgaardian sword 3', 1 );

				sword = actor.GetInventory().GetItemId('Nilfgaardian sword 3');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Nilfgaardian sword 4', 1 );

				sword = actor.GetInventory().GetItemId('Nilfgaardian sword 4');
			}
		}
		*/

		if (((CNewNPC)actor).GetNPCType() != ENGT_Quest
		&& !actor.HasBuff(EET_Burning)
		)
		{
			actor.RemoveAllBuffsOfType(EET_Ragdoll);
			actor.RemoveAllBuffsOfType(EET_HeavyKnockdown);
			actor.RemoveAllBuffsOfType(EET_Stagger);
			actor.RemoveAllBuffsOfType(EET_Knockdown);
			actor.RemoveAllBuffsOfType(EET_Burning);

			actor.RemoveBuff(EET_Burning, true);
			actor.RemoveBuff(EET_Knockdown, true);
			actor.RemoveBuff(EET_Stagger, true);
			actor.RemoveBuff(EET_HeavyKnockdown, true);
			actor.RemoveBuff(EET_Ragdoll, true);

			actor.CriticalStateAnimStopped(true);

			if( actor.HasTag('ACS_Swapped_To_Witcher') )
			{
				actor.DetachBehavior('Witcher');
			}

			if( actor.HasTag('ACS_Swapped_To_Shield') )
			{
				actor.DetachBehavior( 'Shield' );
			}

			actor.AttachBehavior( 'sword_2handed' );

			actor.CriticalStateAnimStopped(true);
		}

		//Sleep(0.5);

		//actor.DropItemFromSlot('r_weapon');

		//actor.DrawItemsLatent(sword);
	}
}

state EnemyBehSwitch_Witcher in cACS_EnemyBehSwitch_OnHit
{
	private var actor					: CActor;
	private var sword					: SItemUniqueId;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_witcher();
	}
	
	entry function EnemyBehSwitch_witcher()
	{
		actor = thePlayer.GetTarget();

		/*
		if( RandF() < 0.5 )
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Novigraadan sword 1', 1 );

				sword = actor.GetInventory().GetItemId('Novigraadan sword 1');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Novigraadan sword 2', 1 );

				sword = actor.GetInventory().GetItemId('Novigraadan sword 2');
			}	
		}
		else
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Novigraadan sword 3', 1 );

				sword = actor.GetInventory().GetItemId('Novigraadan sword 3');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Novigraadan sword 4', 1 );

				sword = actor.GetInventory().GetItemId('Novigraadan sword 4');
			}
		}
		*/

		if (((CNewNPC)actor).GetNPCType() != ENGT_Quest
		&& !actor.HasBuff(EET_Burning)
		)
		{
			actor.RemoveAllBuffsOfType(EET_Ragdoll);
			actor.RemoveAllBuffsOfType(EET_HeavyKnockdown);
			actor.RemoveAllBuffsOfType(EET_Stagger);
			actor.RemoveAllBuffsOfType(EET_Knockdown);
			actor.RemoveAllBuffsOfType(EET_Burning);

			actor.RemoveBuff(EET_Burning, true);
			actor.RemoveBuff(EET_Knockdown, true);
			actor.RemoveBuff(EET_Stagger, true);
			actor.RemoveBuff(EET_HeavyKnockdown, true);
			actor.RemoveBuff(EET_Ragdoll, true);

			actor.CriticalStateAnimStopped(true);

			if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				actor.DetachBehavior('sword_2handed');
			}

			if( actor.HasTag('ACS_Swapped_To_Shield') )
			{
				actor.DetachBehavior( 'Shield' );
			}

			actor.AttachBehavior( 'Witcher' );

			actor.CriticalStateAnimStopped(true);
		}

		//actor.DropItemFromSlot('r_weapon');

		//actor.DrawItemsLatent(sword);
	}
}

state EnemyBehSwitch_Shield in cACS_EnemyBehSwitch_OnHit
{
	private var actor															: CActor;
	private var sword															: SItemUniqueId;
	private var shield_temp														: CEntityTemplate;
	private var shield															: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		EnemyBehSwitch_shield();
	}
	
	entry function EnemyBehSwitch_shield()
	{
		actor = thePlayer.GetTarget();

		/*
		if( RandF() < 0.5 )
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Skellige sword 1', 1 );

				sword = actor.GetInventory().GetItemId('Skellige sword 1');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Skellige sword 2', 1 );

				sword = actor.GetInventory().GetItemId('Skellige sword 2');
			}	
		}
		else
		{
			if( RandF() < 0.5 )
			{
				actor.GetInventory().AddAnItem( 'Rusty Skellige sword', 1 );

				sword = actor.GetInventory().GetItemId('Rusty Skellige sword');
			}
			else
			{
				actor.GetInventory().AddAnItem( 'Skellige sword 4', 1 );

				sword = actor.GetInventory().GetItemId('Skellige sword 4');
			}
		}
		*/

		if (((CNewNPC)actor).GetNPCType() != ENGT_Quest
		&& !actor.HasBuff(EET_Burning)
		)
		{
			actor.RemoveAllBuffsOfType(EET_Ragdoll);
			actor.RemoveAllBuffsOfType(EET_HeavyKnockdown);
			actor.RemoveAllBuffsOfType(EET_Stagger);
			actor.RemoveAllBuffsOfType(EET_Knockdown);
			actor.RemoveAllBuffsOfType(EET_Burning);

			actor.RemoveBuff(EET_Burning, true);
			actor.RemoveBuff(EET_Knockdown, true);
			actor.RemoveBuff(EET_Stagger, true);
			actor.RemoveBuff(EET_HeavyKnockdown, true);
			actor.RemoveBuff(EET_Ragdoll, true);

			actor.CriticalStateAnimStopped(true);

			if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				actor.DetachBehavior('sword_2handed');
			}

			if( actor.HasTag('ACS_Swapped_To_Witcher') )
			{
				actor.DetachBehavior('Witcher');
			}

			actor.AttachBehavior( 'Shield' );

			actor.CriticalStateAnimStopped(true);
		}

		if( RandF() < 0.5 )
		{
			if( RandF() < 0.5 )
			{
				shield_temp = (CEntityTemplate)LoadResource( 

				"items\weapons\shields\bandit_shield_01.w2ent"
				
				, true );
			}
			else
			{
				shield_temp = (CEntityTemplate)LoadResource( 

				"items\weapons\shields\bandit_shield_02.w2ent"
				
				, true );
			}	
		}
		else
		{
			if( RandF() < 0.5 )
			{
				shield_temp = (CEntityTemplate)LoadResource( 
		
				"items\weapons\shields\bandit_shield_03.w2ent"
				
				, true );
			}
			else
			{
				shield_temp = (CEntityTemplate)LoadResource( 
	
				"items\weapons\shields\bandit_shield_04.w2ent"
				
				, true );
			}
		}

		shield = (CEntity)theGame.CreateEntity( shield_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

		shield.CreateAttachment( actor, 'l_weapon', Vector(0,0,0), EulerAngles(0,0,0) );

		shield.AddTag('ACS_Enemy_Shield');

		shield.DestroyAfter(120);

		//actor.DropItemFromSlot('r_weapon'); 

		//actor.DrawItemsLatent(sword);
	}
}

/*
// SHIELDS

// LIST OF AVAILABLE SHIELDS TO USE //

// VANILLA GAME SHIELDS
// "items\weapons\shields\bandit_shield_01.w2ent"
// items\weapons\shields\bandit_shield_02.w2ent
// items\weapons\shields\bandit_shield_03.w2ent
// items\weapons\shields\bandit_shield_04.w2ent
// items\weapons\shields\baron_guard_shield_01.w2ent
// items\weapons\shields\nilfgaard_shield_01.w2ent
// items\weapons\shields\nilfgaard_shield_02.w2ent
// items\weapons\shields\novigrad_shield_01.w2ent
// items\weapons\shields\novigrad_shield_02.w2ent
// items\weapons\shields\redanian_shield_01.w2ent
// items\weapons\shields\skellige_brokvar_shield_01.w2ent
// items\weapons\shields\skellige_craite_shield_01.w2ent
// items\weapons\shields\skellige_dimun_shield_01.w2ent
// items\weapons\shields\skellige_drummond_shield_01.w2ent
// items\weapons\shields\skellige_heymaey_shield_01.w2ent
// items\weapons\shields\skellige_tuiseach_shield_01.w2ent
// items\weapons\shields\temeria_shield_01.w2ent

// HEART OF STONE SHIELDS
// dlc\ep1\data\items\weapons\shields\borsody_shield_01.w2ent
// dlc\ep1\data\items\weapons\shields\flaming_rose_shield_01.w2ent
// dlc\ep1\data\items\weapons\shields\hakland_shield_01.w2ent
// dlc\ep1\data\items\weapons\shields\olgierd_man_shield_01.w2ent

// BLOOD AND WINE SHIELDS
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_1_peyrac.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_2_palmerin.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_3_troy.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_4_frenes.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_5_toussaint.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_01_6_flat_color.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_1_dornal.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_2_attre.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_3_attre_creiqiau.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_4_fourhorn.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_5_milton.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_6_toussaint.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_02_7_flat_color.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_1_anseis.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_2_maecht.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_3_mettina.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_4_rivia.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_5_toussaint.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_6_flat_color.w2ent
// dlc\bob\data\items\weapons\shields\toussaint_shield_03_7_dun_tynne.w2ent

*/
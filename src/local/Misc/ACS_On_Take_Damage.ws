function ACS_OnTakeDamage(action: W3DamageAction)
{
	var money : float;

	if (thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.IsPerformingFinisher())
	{
		return;
	}

	if( thePlayer.IsActionBlockedBy(EIAB_Movement, 'Mutation11') && GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) && !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) && !GetWitcherPlayer().IsInAir() )
	{
		thePlayer.AddTag('ACS_Second_Life_Active');
	}

	if (
	(CPlayer)action.victim 
	&& action.GetBuffSourceName() != "FallingDamage"
	&& action.GetBuffSourceName() != "ACS_Debug"
	&& action.GetBuffSourceName() != "Debug"
	&& action.GetBuffSourceName() != "Quest"
	&& (thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
	) 
	{
		if (((CNewNPC)action.attacker).GetNPCType() == ENGT_Guard)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

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
				case EDM_Hardcore:	money *= 0.1;    break;
				default : 			money *= 0; 	 break;
			}
			
			if (money != 0)
			{
				thePlayer.RemoveMoney((int)money);
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_guards_took_money") );
			}
			else
			{
				((CNewNPC)action.attacker).SetHealthPerc(100);
			}
			
			GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

			if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
			&& !thePlayer.IsPerformingFinisher())
			{
				ACS_Hit_Animations(action);
			}
		}
		else
		{
			if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
			{
				ACS_ThingsThatShouldBeRemoved();

				thePlayer.EnableCharacterCollisions(true); 

				thePlayer.EnableCollisions(true);

				thePlayer.SetIsCurrentlyDodging(false);

				if (thePlayer.GetStat( BCS_Focus ) != 0)
				{
					thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) );
				}

				thePlayer.ClearAnimationSpeedMultipliers();

				if (thePlayer.HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					thePlayer.RemoveTag('ACS_Size_Adjusted');
				}

				thePlayer.SoundEvent("cmb_play_dismemberment_gore");

				thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				thePlayer.SoundEvent("cmb_play_hit_heavy");

				GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

				GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

				if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
				&& !thePlayer.IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}

				thePlayer.StopEffect('blood');
				thePlayer.StopEffect('death_blood');
				thePlayer.StopEffect('heavy_hit');
				thePlayer.StopEffect('light_hit');
				thePlayer.StopEffect('blood_spill');
				thePlayer.StopEffect('fistfight_heavy_hit');
				thePlayer.StopEffect('heavy_hit_horseriding');
				thePlayer.StopEffect('fistfight_hit');
				thePlayer.StopEffect('critical hit');
				thePlayer.StopEffect('death_hit');
				thePlayer.StopEffect('blood_throat_cut');
				thePlayer.StopEffect('hit_back');
				thePlayer.StopEffect('standard_hit');
				thePlayer.StopEffect('critical_bleeding'); 
				thePlayer.StopEffect('fistfight_hit_back'); 
				thePlayer.StopEffect('heavy_hit_back'); 
				thePlayer.StopEffect('light_hit_back'); 

				thePlayer.PlayEffect('blood');
				thePlayer.PlayEffect('death_blood');
				thePlayer.PlayEffect('heavy_hit');
				thePlayer.PlayEffect('light_hit');
				thePlayer.PlayEffect('blood_spill');
				thePlayer.PlayEffect('fistfight_heavy_hit');
				thePlayer.PlayEffect('heavy_hit_horseriding');
				thePlayer.PlayEffect('fistfight_hit');
				thePlayer.PlayEffect('critical hit');
				thePlayer.PlayEffect('death_hit');
				thePlayer.PlayEffect('blood_throat_cut');
				thePlayer.PlayEffect('hit_back');
				thePlayer.PlayEffect('standard_hit');
				thePlayer.PlayEffect('critical_bleeding'); 
				thePlayer.PlayEffect('fistfight_hit_back'); 
				thePlayer.PlayEffect('heavy_hit_back'); 
				thePlayer.PlayEffect('light_hit_back'); 

				thePlayer.AddBuffImmunity_AllNegative('ACS_Death', true); 

				thePlayer.AddBuffImmunity_AllCritical('ACS_Death', true); 

				thePlayer.AddBuffImmunity(EET_Poison , 'ACS_Death', true);

				thePlayer.AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				thePlayer.DrainVitality( thePlayer.GetStat( BCS_Vitality ) * 0.99 );

				thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				thePlayer.SetCanPlayHitAnim(false);
				thePlayer.AddBuffImmunity_AllNegative('god', true);

				if(thePlayer.HasTag('ACS_Manual_Combat_Control')){thePlayer.RemoveTag('ACS_Manual_Combat_Control');} 
		
				GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

				GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

				GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);
			}
		}
		
		return;
	}

	ACS_Player_Fall_Negate(action);

	ACS_Player_Attack_Steel_Silver_Switch(action);

	ACS_Player_Attack_FX_Switch(action);

	ACS_Player_Attack_Enemy_Switch(action);

	ACS_Player_Attack(action);

    ACS_Player_Guard(action);

    ACS_Forest_God_Attack(action);

	ACS_Forest_God_Shadows_Attack(action);

    ACS_Ice_Titan_Attack(action);

	ACS_Fire_Bear_Attack(action);

	ACS_Knightmare_Attack(action);

	ACS_Rage_Attack(action);

	ACS_Take_Damage(action);
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
		(thePlayer.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
		) 
		{
			if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
			{
				ACS_ThingsThatShouldBeRemoved();

				thePlayer.EnableCharacterCollisions(true); 

				thePlayer.EnableCollisions(true);

				thePlayer.SetIsCurrentlyDodging(false);

				if (thePlayer.GetStat( BCS_Focus ) != 0)
				{
					thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) );
				}

				thePlayer.ClearAnimationSpeedMultipliers();

				if (thePlayer.HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					thePlayer.RemoveTag('ACS_Size_Adjusted');
				}

				thePlayer.SoundEvent("cmb_play_dismemberment_gore");

				thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				thePlayer.SoundEvent("cmb_play_hit_heavy");

				GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

				GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

				if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
				&& !thePlayer.IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}

				thePlayer.StopEffect('blood');
				thePlayer.StopEffect('death_blood');
				thePlayer.StopEffect('heavy_hit');
				thePlayer.StopEffect('light_hit');
				thePlayer.StopEffect('blood_spill');
				thePlayer.StopEffect('fistfight_heavy_hit');
				thePlayer.StopEffect('heavy_hit_horseriding');
				thePlayer.StopEffect('fistfight_hit');
				thePlayer.StopEffect('critical hit');
				thePlayer.StopEffect('death_hit');
				thePlayer.StopEffect('blood_throat_cut');
				thePlayer.StopEffect('hit_back');
				thePlayer.StopEffect('standard_hit');
				thePlayer.StopEffect('critical_bleeding'); 
				thePlayer.StopEffect('fistfight_hit_back'); 
				thePlayer.StopEffect('heavy_hit_back'); 
				thePlayer.StopEffect('light_hit_back'); 

				thePlayer.PlayEffect('blood');
				thePlayer.PlayEffect('death_blood');
				thePlayer.PlayEffect('heavy_hit');
				thePlayer.PlayEffect('light_hit');
				thePlayer.PlayEffect('blood_spill');
				thePlayer.PlayEffect('fistfight_heavy_hit');
				thePlayer.PlayEffect('heavy_hit_horseriding');
				thePlayer.PlayEffect('fistfight_hit');
				thePlayer.PlayEffect('critical hit');
				thePlayer.PlayEffect('death_hit');
				thePlayer.PlayEffect('blood_throat_cut');
				thePlayer.PlayEffect('hit_back');
				thePlayer.PlayEffect('standard_hit');
				thePlayer.PlayEffect('critical_bleeding'); 
				thePlayer.PlayEffect('fistfight_hit_back'); 
				thePlayer.PlayEffect('heavy_hit_back'); 
				thePlayer.PlayEffect('light_hit_back'); 

				thePlayer.AddBuffImmunity_AllNegative('ACS_Death', true); 

				thePlayer.AddBuffImmunity_AllCritical('ACS_Death', true); 

				thePlayer.AddBuffImmunity(EET_Poison , 'ACS_Death', true);

				thePlayer.AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				thePlayer.DrainVitality( thePlayer.GetStat( BCS_Vitality ) * 0.99 );

				thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				thePlayer.SetCanPlayHitAnim(false);
				thePlayer.AddBuffImmunity_AllNegative('god', true);

				if(thePlayer.HasTag('ACS_Manual_Combat_Control')){thePlayer.RemoveTag('ACS_Manual_Combat_Control');} 
		
				GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

				GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

				GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);
			}
		}
		else
		{
			if (action.processedDmg.vitalityDamage == 0)
			{
				thePlayer.StopEffect( 'heavy_hit' );

				thePlayer.DestroyEffect( 'heavy_hit' );

				thePlayer.StopEffect( 'hit_screen' );	

				thePlayer.DestroyEffect( 'hit_screen' );
			}

			if (thePlayer.IsOnGround())
			{
				thePlayer.PlayEffectSingle('quen_lasting_shield_hit');

				thePlayer.StopEffect('quen_lasting_shield_hit');

				thePlayer.PlayEffectSingle('lasting_shield_discharge');

				thePlayer.StopEffect('lasting_shield_discharge');

				ACS_Fall_Aard_Trigger();
			}
		}	
	}
}

function ACS_Fall_Aard_Trigger()
{
	var ent                  				: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;

	rot = thePlayer.GetWorldRotation();

	pos = thePlayer.GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"gameplay\templates\signs\pc_aard.w2ent"

	, true ), pos, rot );

	ent.PlayEffectSingle('blast_cutscene');

	ent.PlayEffectSingle('blast');

	ent.PlayEffectSingle('blast_water');

	ent.PlayEffectSingle('blast_ground');

	ent.PlayEffectSingle('blast_lv0');

	ent.PlayEffectSingle('blast_lv0_power');

	ent.PlayEffectSingle('blast_lv1_power');

	ent.PlayEffectSingle('blast_lv2_power');

	ent.PlayEffectSingle('blast_lv3_power');

	ent.PlayEffectSingle('blast_lv3_damage');

	ent.PlayEffectSingle('blast_lv1');

	ent.PlayEffectSingle('blast_lv2');

	ent.PlayEffectSingle('blast_lv3');

	ent.PlayEffectSingle('blast_ground_mutation_6');

	ent.DestroyAfter(3);
}

function ACS_Player_Attack_Steel_Silver_Switch(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																				: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist										: float;
	var itemId_r, itemId_l 																											: SItemUniqueId;
	var itemTags_r, itemTags_l, acs_npc_blood_fx 																					: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var blood 																														: EBloodType;
	var item_steel, item_silver																										: SItemUniqueId;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		&& action.DealsAnyDamage()
		)
		{
			if (thePlayer.IsWeaponHeld('steelsword'))
			{
				if (npc.UsesEssence()
				&& !npc.HasAbility('mon_wraith_base')
				&& !npc.HasAbility('mon_noonwraith_base')
				&& !npc.HasAbility('mon_nightwraith_banshee')
				&& !npc.HasAbility('mon_EP2_wraiths')
				&& !npc.HasAbility('mon_nightwraith_iris')
				&& !npc.HasAbility('q604_shades')
				&& !npc.HasAbility('mon_wraiths_ep1')
				&& !npc.HasAbility('mon_djinn')
				)
				{
					dmgValSilver = thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
					+ thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
					+ thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

					action.processedDmg.essenceDamage += dmgValSilver;
					action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
					//action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * RandRangeF(0.05, 0);
				}
			}
			else if (thePlayer.IsWeaponHeld('silversword'))
			{
				if (npc.UsesVitality())
				{
					dmgValSteel = thePlayer.GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

					action.processedDmg.vitalityDamage += dmgValSteel;

					action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);

					if (!ACS_GetItem_Aerondight())
					{
						thePlayer.GetInventory().SetItemDurabilityScript(item_silver, (thePlayer.GetInventory().GetItemDurability(item_silver) - (thePlayer.GetInventory().GetItemDurability(item_silver) * 0.025)) );
					}
					else
					{
						action.processedDmg.vitalityDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.05;
					}
				}
			}	
		}
	}
}

function ACS_Player_Attack_FX_Switch(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																				: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist										: float;
	var itemId_r, itemId_l 																											: SItemUniqueId;
	var itemTags_r, itemTags_l, acs_npc_blood_fx 																					: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var blood 																														: EBloodType;
	var item_steel, item_silver																										: SItemUniqueId;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			ACS_Caretaker_Drain_Energy();

			if (action.DealsAnyDamage())
			{
				if ( !thePlayer.HasTag('ACS_Storm_Spear_Active') && !thePlayer.HasTag('ACS_Sparagmos_Active') )
				{
					theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

					if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
					{
						if (npc.HasAbility('mon_lessog_base')
						|| npc.HasAbility('mon_sprigan_base')
						)
						{						
							GetACSWatcher().black_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().weapon_blood_fx();
						}
					}
					else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
					{
						if (npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{						
							GetACSWatcher().black_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().green_weapon_blood_fx();
						}
					}
					else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
					{
						if (npc.HasAbility('mon_archespor_base'))
						{
							GetACSWatcher().yellow_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().weapon_blood_fx();
						}
					}
					else if	( ((CNewNPC)npc).GetBloodType() == BT_Black) 
					{
						if ( mc == MC_Vampire ) 
						{
							GetACSWatcher().weapon_blood_fx();
						}
						else if ( mc == MC_Magicals ) 
						{
							if (npc.HasAbility('mon_golem_base')
							|| npc.HasAbility('mon_djinn')
							|| npc.HasAbility('mon_gargoyle')
							)
							{
								GetACSWatcher().black_weapon_blood_fx();
							}
							else
							{
								GetACSWatcher().weapon_blood_fx();
							}
						}
						else
						{
							GetACSWatcher().black_weapon_blood_fx();
						}
					}
					else
					{
						GetACSWatcher().weapon_blood_fx();
					}

					npc.PlayEffect('blood');
					npc.StopEffect('blood');

					npc.PlayEffect('death_blood');
					npc.StopEffect('death_blood');

					npc.PlayEffect('heavy_hit');
					npc.StopEffect('heavy_hit');

					npc.PlayEffect('light_hit');
					npc.StopEffect('light_hit');

					npc.PlayEffect('blood_spill');
					npc.StopEffect('blood_spill');

					acs_npc_blood_fx.Clear();

					acs_npc_blood_fx.PushBack('fistfight_heavy_hit');
					acs_npc_blood_fx.PushBack('heavy_hit_horseriding');
					acs_npc_blood_fx.PushBack('fistfight_hit');
					acs_npc_blood_fx.PushBack('critical hit');
					acs_npc_blood_fx.PushBack('death_hit');
					acs_npc_blood_fx.PushBack('blood_throat_cut');
					acs_npc_blood_fx.PushBack('hit_back');
					acs_npc_blood_fx.PushBack('standard_hit');
					acs_npc_blood_fx.PushBack('critical_bleeding'); 
					acs_npc_blood_fx.PushBack('fistfight_hit_back'); 
					acs_npc_blood_fx.PushBack('heavy_hit_back'); 
					acs_npc_blood_fx.PushBack('light_hit_back'); 
					
					npc.PlayEffectSingle(acs_npc_blood_fx[RandRange(acs_npc_blood_fx.Size())]);

					npc.StopEffect('light_hit_back');
					npc.StopEffect('heavy_hit_back');
					npc.StopEffect('fistfight_heavy_hit');
					npc.StopEffect('heavy_hit_horseriding');
					npc.StopEffect('fistfight_hit');
					npc.StopEffect('critical hit');
					npc.StopEffect('death_hit');
					npc.StopEffect('blood_throat_cut');
					npc.StopEffect('hit_back');
					npc.StopEffect('standard_hit');
					npc.StopEffect('critical_bleeding');
					npc.StopEffect('fistfight_hit_back');
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
			
			if ( action.HasAnyCriticalEffect() 
			|| action.GetIsHeadShot() 
			|| action.HasForceExplosionDismemberment()
			|| action.IsCriticalHit() )
			{
				ACS_Wraith_Attack_Trail();
			}	
		}
	}
}

function ACS_Player_Attack_Enemy_Switch(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																				: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality, bossbardamagevitality, bossbardamageessence															: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist										: float;
	var itemId_r, itemId_l 																											: SItemUniqueId;
	var itemTags_r, itemTags_l, acs_npc_blood_fx 																					: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var blood 																														: EBloodType;
	var item_steel, item_silver																										: SItemUniqueId;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

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

				GetWitcherPlayer().DisplayHudMessage( "DID YOU THINK IT WAS THAT EASY?" );

				npc.AddTag('ACS_Spawn_Adds_1');
			}
			else if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.25 )
			&& !npc.HasTag('ACS_Spawn_Adds_2'))
			{
				ACS_Forest_God_Adds_2_Spawner();

				GetWitcherPlayer().DisplayHudMessage( "DEATH AND DESTRUCTION TO ALL" );

				npc.AddTag('ACS_Spawn_Adds_2');
			} 

			//thePlayer.StopEffect('critical_poison');
			//thePlayer.PlayEffectSingle('critical_poison');
		}

		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if (action.GetHitReactionType() != EHRT_Reflect)
			{
				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( thePlayer ))
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0.05 );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0.05 );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.05 );
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}
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
			npc.HasTag('ACS_Swapped_To_Shield')
			|| npc.HasTag('ACS_Swapped_To_Vampire')
			|| npc.HasTag('ACS_In_Rage')
			)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustorNPC.RotateTowards( ticket, thePlayer );

				if (npc.HasTag('ACS_Swapped_To_Shield'))
				{
					npc.SoundEvent("shield_wood_impact");

					npc.SoundEvent("grunt_vo_block");
				}
			}

			if ( npc.HasTag('ACS_Nekker_Guardian'))
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, thePlayer );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if ( npc.HasTag('ACS_She_Who_Knows'))
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, thePlayer );

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if ( npc.HasAbility('WildHunt_Eredin')
			|| npc.HasAbility('WildHunt_Imlerith')
			)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			if ( npc.HasTag('ACS_Fire_Bear'))
			{
				if (ACSFireBear().IsEffectActive('flames', false))
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
				}
				else
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 100 );

				movementAdjustorNPC.RotateTowards( ticket, thePlayer );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}	

			if ( npc.HasTag('ACS_Knighmare_Eternum'))
			{
				//GetACSKnightmareQuen().StopEffect('quen_rebound_sphere');
				//GetACSKnightmareQuen().PlayEffect('quen_rebound_sphere');

				if(RandF() < 0.5)
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
					}

					GetACSKnightmareQuenHit().StopEffect('discharge');
					GetACSKnightmareQuenHit().PlayEffect('discharge');

					GetACSKnightmareQuen().PlayEffect('default_fx');
					GetACSKnightmareQuen().StopEffect('default_fx');

					//animatedComponentA.PlaySlotAnimationAsync ( 'idle_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					if(RandF() < 0.5)
					{
						//animatedComponentA.PlaySlotAnimationAsync ( 'man_ger_sword_quen_front_lp', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
					}
					else
					{
						//animatedComponentA.PlaySlotAnimationAsync ( 'man_ger_sword_quen_front_rp', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
					}

					//thePlayer.AddEffectDefault(EET_HeavyKnockdown, GetACSKnightmareEternum(), 'Knightmare_Quen_Rebound');
				}
				else
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
				}
				
				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2');
				//GetACSKnightmareQuenHit().PlayEffect('quen_rebound_sphere_bear_abl2');

				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2_copy');
				//GetACSKnightmareQuenHit().PlayEffect('quen_rebound_sphere_bear_abl2_copy');

				GetACSKnightmareQuenHit().StopEffect('quen_impulse_explode');
				//GetACSKnightmareQuen().PlayEffect('quen_impulse_explode');
			}

			if ( npc.HasTag('ACS_Blade_Of_The_Unseen'))
			{
				if (npc.UsesVitality())
				{
					if (GetACSWatcher().unseen_blade_death_count == 0)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if (GetACSWatcher().unseen_blade_death_count == 1)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else if (GetACSWatcher().unseen_blade_death_count == 2)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
				}
				else if (npc.UsesEssence())
				{
					if (GetACSWatcher().unseen_blade_death_count == 0)
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
					else if (GetACSWatcher().unseen_blade_death_count == 1)
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
					else if (GetACSWatcher().unseen_blade_death_count == 2)
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
				}
			}
		}
		else
		{
			if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( thePlayer ))
			{
				npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

				npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

				if (
				npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ) 
				&& npc.GetBehaviorGraphInstanceName() != 'Shield'
				)	
				{
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}	
			}
			else
			{
				npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

				npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
					
				if (npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ))	
				{
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}
			}
		}
	}
}

function ACS_Player_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																																		: CPlayer;
	var npc, npcAttacker 																																					: CActor;
	var animatedComponentA 																																					: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																																: CMovementAdjustor;
	var ticket 																																								: SMovementAdjustmentRequestTicket;
	var item																																								: SItemUniqueId;
	var dmg																																									: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																														: float;
	var vACS_Shield_Summon 																																					: cACS_Shield_Summon;
	var heal, playerVitality 																																				: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist, vampireDmgValSteel, vampireDmgValSilver										: float;
	var itemId_r, itemId_l 																																					: SItemUniqueId;
	var itemTags_r, itemTags_l, acs_npc_blood_fx 																															: array<name>;
	var tmpName 																																							: name;
	var tmpBool 																																							: bool;
	var mc 																																									: EMonsterCategory;
	var blood 																																								: EBloodType;
	var item_steel, item_silver																																				: SItemUniqueId;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = thePlayer.GetStatMax(BCS_Vitality) * 0.025;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	if 
	(playerAttacker && npc)
	{
		npc.AddAbility( 'InstantKillImmune' );

		if (npc.HasTag('ACS_Final_Fear_Stack')
		&& !action.IsDoTDamage() )
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += npc.GetMaxHealth();
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += npc.GetMaxHealth();
			}

			thePlayer.SoundEvent("cmb_play_dismemberment_gore");

			thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			return;
		}

		if (action.WasDodged())
		{
			if (npc.HasTag('ACS_Swapped_To_Shield'))
			{
				npc.SoundEvent("shield_wood_impact");

				npc.SoundEvent("grunt_vo_block");
			}

			return;
		}

		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
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

				if (thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15)
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
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
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
				
				if (thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15)
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
								
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
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
				if (ACS_Griffin_School_Check()
				&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
				{
					if ( thePlayer.GetEquippedSign() == ST_Igni )
					{
						npc.AddEffectDefault( EET_Burning, thePlayer, 'ACS_Griffin_Special_Attack' );	
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii )
					{
						npc.AddEffectDefault( EET_Confusion, thePlayer, 'ACS_Griffin_Special_Attack' );	
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard )
					{
						npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Griffin_Special_Attack' );	
					}
					else if ( thePlayer.GetEquippedSign() == ST_Quen )
					{
						npc.AddEffectDefault( EET_Bleeding, thePlayer, 'ACS_Griffin_Special_Attack' );	
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden )
					{
						npc.AddEffectDefault( EET_Slowdown, thePlayer, 'ACS_Griffin_Special_Attack' );	
					}
				}

				if (ACS_Manticore_School_Check()
				&& thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, thePlayer, 'ACS_Manticore_Special_Attack' );

					npc.AddEffectDefault( EET_Bleeding, thePlayer, 'ACS_Manticore_Special_Attack' );	
				}

				if (ACS_Bear_School_Check()
				&& thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Bear_Special_Attack' );
				}

				if (ACS_Viper_School_Check()
				&& thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, thePlayer, 'ACS_Manticore_Special_Attack' );
				}

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
								
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
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

					if (ACS_Vampire_Claws_Monster_Max_Damage() != 0 
					&& ACS_Vampire_Claws_Monster_Min_Damage() != 0 )
					{
						maxTargetEssence = npc.GetStatMax( BCS_Essence );
						
						damageMax = maxTargetEssence * ACS_Vampire_Claws_Monster_Max_Damage(); 
						
						damageMin = maxTargetEssence * ACS_Vampire_Claws_Monster_Min_Damage(); 

						action.processedDmg.essenceDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.essenceDamage;
					}
					else
					{
						vampireDmgValSilver = thePlayer.GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

						action.processedDmg.essenceDamage += vampireDmgValSilver;

						action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
					}

					if ( thePlayer.HasTag('ACS_Vampire_Dash_Attack') )
					{
						action.processedDmg.essenceDamage += (npc.GetStatMax(BCS_Essence)  - npc.GetStat(BCS_Essence) ) * 0.15;
					}
				}
				else if (npc.UsesVitality())
				{
					thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.05 );

					if (ACS_Vampire_Claws_Human_Max_Damage() != 0 
					&& ACS_Vampire_Claws_Human_Min_Damage() != 0 )
					{
						maxTargetVitality = npc.GetStatMax( BCS_Vitality );

						damageMax = maxTargetVitality * ACS_Vampire_Claws_Human_Max_Damage(); 
						
						damageMin = maxTargetVitality * ACS_Vampire_Claws_Human_Min_Damage(); 

						action.processedDmg.vitalityDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.vitalityDamage;
					}
					else
					{
						vampireDmgValSteel = thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
						+ thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
						+ thePlayer.GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

						action.processedDmg.vitalityDamage += vampireDmgValSteel;
						action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);
					}

					if ( thePlayer.HasTag('ACS_Vampire_Dash_Attack') )
					{
						action.processedDmg.vitalityDamage += (npc.GetStatMax(BCS_Vitality) - npc.GetStat(BCS_Vitality)) * 0.15;
					}
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

				thePlayer.RemoveTag('ACS_Vampire_Dash_Attack');

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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	//&& !playerAttacker
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !action.IsDoTDamage()
	&& (thePlayer.IsGuarded() || thePlayer.IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5)
	&& !thePlayer.IsPerformingFinisher()
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	&& !thePlayer.IsCurrentlyDodging()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !action.WasDodged()
	&& !thePlayer.IsInFistFightMiniGame() 
	&& !thePlayer.HasTag('ACS_Camo_Active')
	//&& !thePlayer.HasTag('igni_sword_equipped')
	//&& !thePlayer.HasTag('igni_secondary_sword_equipped')
	)
	{
		if ( thePlayer.HasTag('vampire_claws_equipped') )
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

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.1, 1, );
			
			if ( RandF() < 0.5 )
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						thePlayer.StopEffect('left_sparks');
						thePlayer.PlayEffectSingle('left_sparks');
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							thePlayer.StopEffect('taunt_sparks');
							thePlayer.PlayEffectSingle('taunt_sparks');
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							thePlayer.StopEffect('left_sparks');
							thePlayer.PlayEffectSingle('left_sparks');
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						thePlayer.StopEffect('right_sparks');
						thePlayer.PlayEffectSingle('right_sparks');
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							thePlayer.StopEffect('taunt_sparks');
							thePlayer.PlayEffectSingle('taunt_sparks');
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							thePlayer.StopEffect('right_sparks');
							thePlayer.PlayEffectSingle('right_sparks');
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					thePlayer.StopEffect('right_sparks');
					thePlayer.PlayEffectSingle('right_sparks');
				}
			}
		}
		else if ( thePlayer.HasTag('axii_sword_equipped') )
		{
			vACS_Shield_Summon = new cACS_Shield_Summon in theGame;

			vACS_Shield_Summon.Axii_Persistent_Shield_Summon();

			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.1, 1, );

			thePlayer.SoundEvent("cmb_imlerith_shield_impact");

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
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
				}
			}
			else
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}	
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
			thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax(BCS_Stamina) * 0.1, 1, );

			thePlayer.SoundEvent("grunt_vo_block");
								
			thePlayer.SoundEvent("cmb_play_parry");

			if ( theInput.GetActionValue('LockAndGuard') > 0.5
			&& !thePlayer.IsInCombat())
			{
				thePlayer.SetBehaviorVariable( 'parryType', 7.0 );
				thePlayer.RaiseForceEvent( 'PerformParry' );
			}

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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	&& action.GetBuffSourceName() != "FallingDamage"
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !thePlayer.HasTag('blood_sucking')
	&& thePlayer.GetImmortalityMode() != AIM_Immortal
	&& thePlayer.GetImmortalityMode() != AIM_Invulnerable
	&& !thePlayer.IsDodgeTimerRunning()
	&& !thePlayer.IsCurrentlyDodging()
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
		!action.IsDoTDamage()
		&& action.GetHitReactionType() != EHRT_Reflect
		&& !thePlayer.IsInGuardedState()
		&& !thePlayer.IsGuarded()
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

				if (thePlayer.HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					thePlayer.RemoveTag('ACS_Size_Adjusted');
				}

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
					if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

					movementAdjustor.CancelAll();

					playerVictim.AddEffectDefault( EET_Knockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Drunkenness, npcAttacker, 'acs_HIT_REACTION' ); 							
				}

				ACS_PlayerHitEffects();

				thePlayer.PlayEffectSingle('mutation_7_adrenaline_drop');
				thePlayer.StopEffect('mutation_7_adrenaline_drop');
			}
			else if ( thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9
			&& thePlayer.GetStat(BCS_Stamina) >= thePlayer.GetStatMax(BCS_Stamina) * 0.5
			&& thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5
			)
			{
				if (thePlayer.HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					thePlayer.RemoveTag('ACS_Size_Adjusted');
				}

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
				if (npcAttacker.HasBuff(EET_Stagger))
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else
				{
					ACS_PlayerHitEffects();

					if( thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Armor, item) && action.IsActionMelee() )
					{
						if( thePlayer.GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							if( ( RandF() < 0.45) || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.1 ) 
							{
								if (thePlayer.HasTag('ACS_Size_Adjusted'))
								{
									GetACSWatcher().Grow_Geralt_Immediate_Fast();

									thePlayer.RemoveTag('ACS_Size_Adjusted');
								}

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.325;

								if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
								&& !thePlayer.IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
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
									damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.025; 
									
									damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.0125; 
								} 
								else if (npcAttacker.UsesEssence()) 
								{ 
									damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.025; 
									
									damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.0125; 
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
								if (thePlayer.HasTag('ACS_Size_Adjusted'))
								{
									GetACSWatcher().Grow_Geralt_Immediate_Fast();

									thePlayer.RemoveTag('ACS_Size_Adjusted');
								}

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

								if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
								&& !thePlayer.IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
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
									damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.0125; 
									
									damageMin = 0; 
								} 
								else if (npcAttacker.UsesEssence()) 
								{ 
									damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.0125; 
									
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
								if (thePlayer.HasTag('ACS_Size_Adjusted'))
								{
									GetACSWatcher().Grow_Geralt_Immediate_Fast();

									thePlayer.RemoveTag('ACS_Size_Adjusted');
								}

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

								if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
								&& !thePlayer.IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
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
									damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.005; 
									
									damageMin = 0; 
								} 
								else if (npcAttacker.UsesEssence()) 
								{ 
									damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.005; 
									
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

							if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
							&& !thePlayer.IsPerformingFinisher())
							{
								ACS_Hit_Animations(action);
							}
						}
					}
					else
					{
						GetACSWatcher().ACS_Combo_Mode_Reset_Hard();
						
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

						if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
						&& !thePlayer.IsPerformingFinisher())
						{
							ACS_Hit_Animations(action);
						}
					}
				}	
			}
		}		
	}
}

function ACS_Death_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

    if(thePlayer.HasTag('vampire_claws_equipped'))
    {
        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }
        else
        {
           thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }

        GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.5, false);
    }
    else
    {
        if( RandF() < 0.5 ) 
        { 																		
            if( RandF() < 0.5 ) 
            { 
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
        else
        {	
            if( RandF() < 0.5 ) 
            { 
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 0.5, false);
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
    }
}

function ACS_Death_Animations_For_Falling(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

    if( RandF() < 0.5 ) 
	{ 
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
	else
	{
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
}

function ACS_Hit_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	if (thePlayer.HasTag('blood_sucking')
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.HasTag('yrden_secondary_sword_equipped')
	|| thePlayer.HasTag('yrden_sword_equipped')
	|| thePlayer.IsCurrentlyDodging()
	|| thePlayer.GetImmortalityMode() == AIM_Invulnerable
	|| thePlayer.IsPerformingFinisher() 
	)
	{
		return;
	}

	npcAttacker = (CActor)action.attacker;

	thePlayer.GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	thePlayer.ClearAnimationSpeedMultipliers();	
	
    if ( ( thePlayer.HasTag('vampire_claws_equipped') && !thePlayer.HasBuff(EET_BlackBlood) ) || thePlayer.HasTag('aard_sword_equipped') )
    {
        GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

		Bruxa_Camo_Decoy_Deactivate();

		thePlayer.StopEffect('shadowdash');

		thePlayer.StopEffect('shadowdash_short');

        if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_cheast_lp_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }        
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_hips_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_strong_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_strong_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            } 
                        }
                    }	
                }
            }	
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
        }    
    }
    else if( thePlayer.HasTag('quen_secondary_sword_equipped') || thePlayer.HasTag('aard_secondary_sword_equipped') )
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
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
            else
            {
                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                    else
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                    else
                                    {
                                        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_06_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_07_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_06_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_07_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                    }
                }
            }
        }
        else
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_2_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
            }
        }	
        else
        {
            thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_b_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
        }
    }
    else if( 
	thePlayer.HasTag('igni_sword_equipped')
	|| thePlayer.HasTag('igni_secondary_sword_equipped')
	|| thePlayer.HasTag('igni_sword_equipped_TAG')
	|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
	) 
    {
		if (ACS_Bear_School_Check()
		|| ACS_Forgotten_Wolf_Check()
		)
		{
			return;
		}
	
		if (thePlayer.IsEnemyInCone( npcAttacker, thePlayer.GetHeadingVector(), 50, 145, npcAttacker ))
		{
			if ( RandF() < 0.5 )
			{
				if ( RandF() < 0.5 )
				{
					if ( RandF() < 0.5 )
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						if ( RandF() < 0.5 )
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						if ( RandF() < 0.5 )
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
				}	
			}
		}	
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
		}
	}		
}

function ACS_Forest_God_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God')
	&& !action.IsDoTDamage()
	)
	{	
		if (playerVictim)
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

							if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

							movementAdjustor.CancelAll();

							GetWitcherPlayer().DisplayHudMessage( "I SHALL FEAST UPON YOUR FRAGILITY" );

							//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

							params.effectType = EET_Knockdown;
							params.creator = npc;
							params.sourceName = "acs_HIT_REACTION";
							params.duration = 1;

							playerVictim.AddEffectCustom( params );							
						}
					}
					else
					{
						if (npcAttacker.GetStat(BCS_Essence) <= npcAttacker.GetStatMax(BCS_Essence)/2)
						{
							npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
						}	

						if (!npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded')
						&& !npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded')
						)
						{
							if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}			

							npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
						}
						else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
						{
							npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');

							if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

							movementAdjustor.CancelAll();

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

							GetWitcherPlayer().DisplayHudMessage( "I CRAVE THE ESSENCE OF YOUR FLESH" );

							if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
							
							movementAdjustor.CancelAll();
							
							//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

							params.effectType = EET_Knockdown;
							params.creator = npc;
							params.sourceName = "acs_HIT_REACTION";
							params.duration = 1;

							playerVictim.AddEffectCustom( params );							
						}
					}
				}
			}
			else
			{
				if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
				{
					if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
					
					movementAdjustor.CancelAll();

					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().DisplayHudMessage( "NONE LEAVE THE SLAUGHTERHOUSE. NOT ALIVE." );
					}
					else
					{
						GetWitcherPlayer().DisplayHudMessage( "YOUR FEAR IS DELICIOUS. I WANT MORE." );
					}

					//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "acs_HIT_REACTION";
					params.duration = 1;

					playerVictim.AddEffectCustom( params );							

					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 		
				}					
			}
		}
		else
		{
			npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.10 );
		}
	}
}

function ACS_Forest_God_Shadows_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God_Shadows')
	&& !action.IsDoTDamage()
	)
	{	
		if (
			 thePlayer.HasTag('igni_sword_equipped_TAG') || !thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
		)
		{
			if (playerVictim)
			{
				if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
				{
					if (action.IsActionMelee())
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.0125 );

						npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.25 );

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
			}
			else
			{
				npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.25 );

				npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.5 );

				if (npc.UsesEssence())
				{
					npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					npc.DrainVitality(npc.GetStatMax(BCS_Vitality) * 0.25 );
				}
			}
		}
		else
		{
			if (playerVictim)
			{
				if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
				{
					if (action.IsActionMelee())
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.025 );

						npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.25 );

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}	
				}
			}
			else
			{
				npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.25 );

				npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.5 );

				if (npc.UsesEssence())
				{
					npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					npc.DrainVitality(npc.GetStatMax(BCS_Vitality) * 0.25 );
				}
			}
		}
	}
}

function ACS_Ice_Titan_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Ice_Titan')
	&& !action.IsDoTDamage()
	&& playerVictim
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

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

						params.effectType = EET_Knockdown;
						params.creator = npc;
						params.sourceName = "acs_HIT_REACTION";
						params.duration = 1;

						playerVictim.AddEffectCustom( params );					
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

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

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

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

						params.effectType = EET_Knockdown;
						params.creator = npc;
						params.sourceName = "acs_HIT_REACTION";
						params.duration = 1;

						playerVictim.AddEffectCustom( params );							
					}
				}
			}
		}
		else
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

				movementAdjustor.CancelAll();

				//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

				params.effectType = EET_Knockdown;
				params.creator = npc;
				params.sourceName = "acs_HIT_REACTION";
				params.duration = 1;

				playerVictim.AddEffectCustom( params );							

				playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
}

function ACS_Fire_Bear_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fire_Bear')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			thePlayer.ClearAnimationSpeedMultipliers();	

			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if (thePlayer.IsGuarded()
				&& thePlayer.IsInGuardedState())
				{
					if (!npcAttacker.HasTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded')
					&& !npcAttacker.HasTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded')
					)
					{
						npcAttacker.AddTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded');

						npcAttacker.AddTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded');
					}
					else if (npcAttacker.HasTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded'))
					{
						npcAttacker.RemoveTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}
	
						playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 			

						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
						
						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

						params.effectType = EET_Knockdown;
						params.creator = npc;
						params.sourceName = "acs_HIT_REACTION";
						params.duration = 1;

						playerVictim.AddEffectCustom( params );						
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
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.0125 );
					}

					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 		

					if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

					movementAdjustor.CancelAll();

					//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "acs_HIT_REACTION";
					params.duration = 1;

					playerVictim.AddEffectCustom( params );	
				}
			}
		}
		else
		{
			if (npc)
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
			}

			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
				
				movementAdjustor.CancelAll();

				//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

				//playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
}

function ACS_Knightmare_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Knighmare_Eternum')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				if ( playerVictim)
				{
					thePlayer.ClearAnimationSpeedMultipliers();	
				}

				if (
					(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
					||
					(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
					)
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
			}
		}
	}
}

function ACS_Unseen_Monster(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Vampire_Monster')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !thePlayer.IsCurrentlyDodging())
			{
				thePlayer.ClearAnimationSpeedMultipliers();	

				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;

				if (npcAttacker.UsesVitality()) 
				{ 
					ACSVampireMonsterBossBar().GainStat( BCS_Vitality, ACSVampireMonsterBossBar().GetStatMax(BCS_Vitality) * 0.10 );
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					ACSVampireMonsterBossBar().GainStat( BCS_Essence, ACSVampireMonsterBossBar().GetStatMax(BCS_Essence) * 0.10 );
				} 
			}
		}
	}
}

function ACS_Rage_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality 																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var paramsKnockdown, paramsDrunkEffect 																							: SCustomEffectParams;
	
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

	movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

	if (
	npcAttacker
	&& playerVictim
	&& npcAttacker.HasTag('ACS_In_Rage') 
	&& !npcAttacker.HasTag('ACS_Forest_God')
	&& !npcAttacker.HasTag('ACS_Forest_God_Shadows')
	&& !action.IsDoTDamage()
	)
	{
		if (action.IsActionMelee())
		{
			if (
			!GetWitcherPlayer().IsQuenActive(true)
			&& !action.WasDodged() 
			&& !thePlayer.IsCurrentlyDodging()
			&& !thePlayer.IsPerformingFinisher()
			&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
			)
			{
				thePlayer.RemoveBuffImmunity( EET_Stagger,					'acs_guard');
				thePlayer.RemoveBuffImmunity( EET_LongStagger,				'acs_guard');

				if (thePlayer.IsGuarded()
				|| thePlayer.IsInGuardedState())
				{
					thePlayer.SetGuarded(false);
					thePlayer.OnGuardedReleased();	
				}

				if ( GetWitcherPlayer().IsQuenActive(false))
				{
					GetWitcherPlayer().FinishQuen(false);
				}
				
				GetACSWatcher().RemoveTimer('ACS_Shield_Spawn_Delay'); 

				ACS_Shield_Destroy(); 

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				thePlayer.GetMovingAgentComponent().ResetMoveRequests();
				thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);
				thePlayer.ResetRawPlayerHeading();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				if (thePlayer.HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					thePlayer.RemoveTag('ACS_Size_Adjusted');
				}

				thePlayer.ClearAnimationSpeedMultipliers();	

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				thePlayer.SetPlayerTarget( npcAttacker );

				thePlayer.SetPlayerCombatTarget( npcAttacker );

				thePlayer.UpdateDisplayTarget( true );

				thePlayer.UpdateLookAtTarget();

				thePlayer.RaiseEvent( 'AttackInterrupt' );

				if (((CMovingPhysicalAgentComponent)(npcAttacker.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| npcAttacker.GetRadius() >= 0.7
				)
				{
					if( !playerVictim.IsImmuneToBuff( EET_HeavyKnockdown ) && !playerVictim.HasBuff( EET_HeavyKnockdown ) ) 
					{ 	
						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' );

						paramsKnockdown.effectType = EET_HeavyKnockdown;
						paramsKnockdown.creator = npcAttacker;
						paramsKnockdown.sourceName = "ACS_Rage_Effect_Custom";
						paramsKnockdown.duration = 2;

						playerVictim.AddEffectCustom( paramsKnockdown ); 							
					}
				}
				else
				{
					if( !playerVictim.IsImmuneToBuff( EET_Stagger ) && !playerVictim.HasBuff( EET_Stagger ) ) 
					{ 	
						if(thePlayer.IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' );

						paramsKnockdown.effectType = EET_Stagger;
						paramsKnockdown.creator = npcAttacker;
						paramsKnockdown.sourceName = "ACS_Rage_Effect_Custom";
						paramsKnockdown.duration = 0.25;

						playerVictim.AddEffectCustom( paramsKnockdown ); 							
					}
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					paramsDrunkEffect.effectType = EET_Drunkenness;
					paramsDrunkEffect.creator = npcAttacker;
					paramsDrunkEffect.sourceName = "ACS_Rage_Effect_Custom";
					paramsDrunkEffect.duration = 1;

					playerVictim.AddEffectCustom( paramsDrunkEffect );								
				}

				ACS_PlayerHitEffects();

				thePlayer.PlayEffectSingle('mutation_7_adrenaline_drop');
				thePlayer.StopEffect('mutation_7_adrenaline_drop');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += thePlayer.GetStat(BCS_Vitality) * 0.3;

				//thePlayer.DrainVitality((thePlayer.GetStat(BCS_Vitality) * 0.3) + 25);

				thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStat(BCS_Stamina) * 0.3 );

				thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) * 0.3 );

				thePlayer.SoundEvent("cmb_play_hit_heavy");

				thePlayer.PlayEffect('heavy_hit');
				thePlayer.StopEffect('heavy_hit');
			}

			ACS_Rage_Markers_Destroy();

			ACS_Rage_Markers_Player_Destroy();

			GetACSWatcher().RemoveTimer('ACS_Rage_Remove');
			GetACSWatcher().AddTimer('ACS_Rage_Remove', 0.0001, false);

			if (action.WasDodged())
			{
				npcAttacker.RemoveBuffImmunity_AllNegative('ACS_Rage');

				npcAttacker.RemoveBuffImmunity_AllCritical('ACS_Rage');

				npcAttacker.SetImmortalityMode( AIM_None, AIC_Combat ); 

				npcAttacker.SetCanPlayHitAnim(true); 

				npcAttacker.DrainStamina( ESAT_FixedValue, npcAttacker.GetStat(BCS_Stamina)/2 );

				dmg = new W3DamageAction in theGame.damageMgr;
						
				dmg.Initialize(thePlayer, npcAttacker, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Heavy );

				//dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				dmg.SetCanPlayHitParticle(false);

				dmg.SetSuppressHitSounds(true);

				dmg.SuppressHitSounds();

				if (npcAttacker.UsesVitality()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.1; 
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.1; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax) );

				dmg.AddEffectInfo( EET_Stagger, 2 );
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
			}

			((CNewNPC)npcAttacker).SetAttitude(thePlayer, AIA_Hostile);
		}
	}
}

function ACS_EnemyBehSwitch_Watcher()
{
	var vACS_EnemyBehSwitch 	: cACS_EnemyBehSwitch;

	vACS_EnemyBehSwitch = new cACS_EnemyBehSwitch in theGame;

	vACS_EnemyBehSwitch.EnemyBehSwitch();
}

statemachine class cACS_EnemyBehSwitch
{
	function EnemyBehSwitch()
	{
		this.PushState('EnemyBehSwitch');
	}
}

state EnemyBehSwitch in cACS_EnemyBehSwitch
{
	private var actors		    												: array<CActor>;
	private var i																: int;
	private var npc																: CActor;
	private var sword															: SItemUniqueId;
	private var shield_temp														: CEntityTemplate;
	private var shield															: ACSShieldSpawner;
	private var behGraphNames 													: array< name >;
	private var params 															: SCustomEffectParams;
	private var l_aiTree														: CAIExecuteAttackAction;
	private var i_aiTree														: CAIInterruptableByHitAction;
	private var itemId_r, itemId_l 												: SItemUniqueId;
	private var itemTags_r, itemTags_l 											: array<name>;
	private var item_steel, item_silver											: SItemUniqueId;
	private var animcomp 														: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		EnemyBehSwitch_AllInOne();
	}
	
	entry function EnemyBehSwitch_AllInOne()
	{
		actors.Clear();
		
		actors = thePlayer.GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = actors[i];

				if(!theGame.IsDialogOrCutscenePlaying()
				&& !thePlayer.IsUsingHorse() 
				&& !thePlayer.IsUsingVehicle()
				&& npc.IsHuman()
				&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
				&& !npc.HasTag( 'ethereal' )
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.HasTag('ACS_In_Rage')
				&& !npc.HasTag('ACS_Pre_Rage')
				
				&& !npc.HasTag('ACS_Final_Fear_Stack')

				&& !npc.HasBuff(EET_Knockdown)

				&& !npc.HasBuff(EET_HeavyKnockdown)

				&& !npc.HasBuff(EET_Ragdoll)

				&& !npc.HasBuff(EET_Burning)

				&& !npc.HasBuff(EET_Frozen)

				&& !npc.HasBuff(EET_LongStagger)

				&& !npc.HasBuff(EET_Stagger)

				&& !((CNewNPC)npc).IsInFinisherAnim()

				&& GetACSWatcher().ACS_Rage_Process == false

				&& npc.GetBehaviorGraphInstanceName() != 'Shield'

				&& !StrContains( npc.I_GetDisplayName(), "Bandit" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Cannibal" )
				&& !StrContains( npc.I_GetDisplayName(), "Thug" )

				&& !StrContains( npc.I_GetDisplayName(), "Cannibale" )
				&& !StrContains( npc.I_GetDisplayName(), "Voyou" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandito" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Delinquente" )

				&& !StrContains( npc.I_GetDisplayName(), "Kannibale" )
				&& !StrContains( npc.I_GetDisplayName(), "Schurke" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandido" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Caníbal" )
				&& !StrContains( npc.I_GetDisplayName(), "Matón" )

				&& !StrContains( npc.I_GetDisplayName(), "قاطع طريق" ) 
				&& !StrContains( npc.I_GetDisplayName(), "آكلي لحوم البشر" )
				&& !StrContains( npc.I_GetDisplayName(), "سفاح" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandita" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Kanibal" )

				&& !StrContains( npc.I_GetDisplayName(), "Kannibál" )
				&& !StrContains( npc.I_GetDisplayName(), "Orgyilkos" )

				&& !StrContains( npc.I_GetDisplayName(), "山賊" ) 
				&& !StrContains( npc.I_GetDisplayName(), "人食い人種" )
				&& !StrContains( npc.I_GetDisplayName(), "ちんぴら" )

				&& !StrContains( npc.I_GetDisplayName(), "적기" ) 
				&& !StrContains( npc.I_GetDisplayName(), "식인종" )
				&& !StrContains( npc.I_GetDisplayName(), "자객" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandyta" )

				&& !StrContains( npc.I_GetDisplayName(), "Canibal" )

				&& !StrContains( npc.I_GetDisplayName(), "Бандит" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Каннибал" )
				&& !StrContains( npc.I_GetDisplayName(), "бандит" )

				&& !StrContains( npc.I_GetDisplayName(), "土匪" ) 
				&& !StrContains( npc.I_GetDisplayName(), "食人族" )
				&& !StrContains( npc.I_GetDisplayName(), "暴徒" )
				&& !StrContains( npc.GetReadableName(), "bandit" ) 
				&& !StrContains( npc.GetReadableName(), "cannibal" ) 
				)
				{
					itemId_r = npc.GetInventory().GetItemFromSlot('r_weapon');

					itemId_l = npc.GetInventory().GetItemFromSlot('l_weapon');

					npc.GetInventory().GetItemTags(itemId_r, itemTags_r);

					npc.GetInventory().GetItemTags(itemId_l, itemTags_l);

					if ( 
					itemTags_r.Contains('sword1h') 
					|| itemTags_r.Contains('axe1h')
					|| itemTags_r.Contains('blunt1h')
					|| itemTags_r.Contains('steelsword')
					)
					{
						if ( 
						(
						( npc.GetCurrentHealth() <= npc.GetMaxHealth() * RandRangeF(0.875, 0.625) )
						)
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_1')
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_2')
						)
						{
							if ( npc.GetBehaviorGraphInstanceName() == 'sword_2handed' )
							{
								npc.AddTag('ACS_sword2h_npc');

								if( RandF() < 0.5 ) 
								{
									Sword1h_Switch(npc);
								}
								else
								{
									Witcher_Switch(npc);
								}
							}
							else if ( npc.GetBehaviorGraphInstanceName() == 'sword_1handed' )
							{
								npc.AddTag('ACS_sword1h_npc');

								if( RandF() < 0.5 ) 
								{
									Sword2h_Switch(npc);
								}
								else
								{
									Witcher_Switch(npc);
								}
							}
							else if ( npc.GetBehaviorGraphInstanceName() == 'Witcher' )
							{
								npc.AddTag('ACS_witcher_npc');

								if( RandF() < 0.5 ) 
								{
									Sword1h_Switch(npc);
								}
								else
								{
									Sword2h_Switch(npc);
								}
							}

							npc.AddTag('ACS_One_Hand_Swap_Stage_1');
						}
						else if 
						(
						( 
						( npc.GetCurrentHealth() <= npc.GetMaxHealth() * RandRangeF(0.5, 0.25) )
						)
						&& npc.HasTag('ACS_One_Hand_Swap_Stage_1')
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_2')
						)
						{
							if( npc.HasTag('ACS_Swapped_To_Witcher') ) 
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								)
								{
									if( npc.HasTag('ACS_sword1h_npc') )
									{
										Sword2h_Switch(npc);
									}
									else if( npc.HasTag('ACS_sword2h_npc') )
									{
										Sword1h_Switch(npc);
									}
									else
									{
										if( RandF() < 0.33 ) 
										{
											Sword1h_Switch(npc);
										}
										else
										{
											Sword2h_Switch(npc);
										}
									}
								}
								else
								{
									if (thePlayer.IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Sword2h_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Sword2h_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}
							else if (npc.HasTag('ACS_Swapped_To_2h_Sword'))
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								)
								{
									if( npc.HasTag('ACS_sword1h_npc') )
									{
										Witcher_Switch(npc);
									}
									else if( npc.HasTag('ACS_witcher_npc') )
									{
										Sword1h_Switch(npc);
									}
									else
									{
										if( RandF() < 0.33 ) 
										{
											Sword1h_Switch(npc);
										}
										else
										{
											Witcher_Switch(npc);
										}
									}
								}
								else
								{
									if (thePlayer.IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Witcher_Switch(npc);
											}
											else if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Witcher_Switch(npc);
											}
											else if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}
							else if( npc.HasTag('ACS_Swapped_To_1h_Sword') ) 
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								)
								{
									if( npc.HasTag('ACS_witcher_npc') )
									{
										Sword2h_Switch(npc);
									}
									else if( npc.HasTag('ACS_sword2h_npc') )
									{
										Witcher_Switch(npc);
									}
									else
									{
										if( RandF() < 0.5 ) 
										{
											Sword2h_Switch(npc);
										}
										else
										{
											Witcher_Switch(npc);
										}
									}	
								}
								else
								{
									if (thePlayer.IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Witcher_Switch(npc);
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													Sword2h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Witcher_Switch(npc);
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													Sword2h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												Shield_Switch(npc);
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}

							npc.AddTag('ACS_One_Hand_Swap_Stage_2');
						}
					}
				}
			}
		}
	}

	latent function Sword1h_Switch( npc : CActor )
	{
		if( !npc.HasTag('ACS_Swapped_To_1h_Sword') )
		{
			((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.AttachBehavior( 'sword_1handed' );

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			npc.SetAnimationSpeedMultiplier(1);

			npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_1h_Sword');
		}
	}

	latent function Sword2h_Switch( npc : CActor )
	{
		if( !npc.HasTag('ACS_Swapped_To_2h_Sword') )
		{
			((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'sword_2handed' );

			npc.SetAnimationSpeedMultiplier(1.15);

			npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_2h_Sword');
		}
	}

	latent function Witcher_Switch( npc : CActor )
	{
		if( !npc.HasTag('ACS_Swapped_To_Witcher') )
		{
			((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			npc.AttachBehavior( 'Witcher' );

			npc.SetAnimationSpeedMultiplier(0.875);

			npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_Witcher');
		}
	}

	latent function Shield_Switch( npc : CActor )
	{
		if( !npc.HasTag('ACS_Swapped_To_Shield') )
		{
			((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'Shield' );

			npc.SetAnimationSpeedMultiplier(1.25);

			npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Beh_Swich_Effect' ); 

			shield_temp = (CEntityTemplate)LoadResourceAsync( 
		
			"dlc\dlc_acs\data\entities\other\shield_spawner.w2ent"
			
			, true );

			shield = (ACSShieldSpawner)theGame.CreateEntity( shield_temp, npc.GetBoneWorldPosition('l_weapon') );

			shield.CreateAttachment( npc, 'l_weapon', Vector(0,0,0), EulerAngles(0,0,0) );

			npc.AddTag('ACS_Swapped_To_Shield');
		}
	}

	latent function Vamp_Switch( npc : CActor )
	{
		if( !npc.HasTag('ACS_Swapped_To_Vampire') )
		{
			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'DettlaffVampire_ACS' );

			npc.AddEffectDefault( EET_Stagger, thePlayer, 'ACS_Beh_Swich_Effect' ); 

			(npc.GetInventory().GetItemEntityUnsafe( npc.GetInventory().GetItemFromSlot( 'r_weapon' ) )).SetHideInGame(true);

			npc.StopEffect('demonic_possession');
			npc.PlayEffect('demonic_possession');

			npc.AddTag('ACS_Swapped_To_Vampire');
		}
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
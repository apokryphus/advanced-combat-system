function ACS_OnTakeDamage(action: W3DamageAction)
{
	var money : float;

	if (GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	|| GetWitcherPlayer().IsPerformingFinisher())
	{
		return;
	}

	if( GetWitcherPlayer().IsActionBlockedBy(EIAB_Movement, 'Mutation11') && GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) && !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) && !GetWitcherPlayer().IsInAir() )
	{
		GetWitcherPlayer().AddTag('ACS_Second_Life_Active');
	}

	ACS_Player_Fall_Negate(action);

	ACS_Player_Attack_Steel_Silver_Switch(action);

	ACS_Player_Attack_FX_Switch(action);

	ACS_Player_Attack(action);

    ACS_Player_Guard(action);



	ACS_Enemy_On_Take_Damage_General(action);

	ACS_Forest_God_On_Take_Damage(action);

	ACS_Rage_Enemy_On_Take_Damage(action);

	ACS_Nekker_Guardian_On_Take_Damage(action);

	ACS_She_Who_Knows_On_Take_Damage(action);

	ACS_Wild_Hunt_Bosses_On_Take_Damage(action);

	ACS_Fire_Bear_On_Take_Damage(action);

	ACS_Knightmare_On_Take_Damage(action);

	ACS_Unseen_Blade_On_Take_Damage(action);

	ACS_Big_Lizard_On_Take_Damage(action);

	ACS_Rat_Mage_On_Take_Damage(action);

	ACS_NightStalker_On_Take_Damage(action);

	ACS_XenoTyrant_On_Take_Damage(action);

	ACS_XenoSoldier_On_Take_Damage(action);

	ACS_XenoArmoredWorker_On_Take_Damage(action);



	ACS_Forest_God_Attack(action);

	ACS_Forest_God_Shadows_Attack(action);

    ACS_Ice_Titan_Attack(action);

	ACS_Fire_Bear_Attack(action);

	ACS_Knightmare_Attack(action);

	ACS_Eredin_Attack(action);

	ACS_NightStalker_Attack(action);

	ACS_XenoTyrant_Attack(action);

	ACS_XenoSoldier_Attack(action);

	ACS_XenoWorker_Attack(action);

	ACS_XenoArmoredWorker_Attack(action);

	ACS_Big_Lizard_Attack(action);

	ACS_Rage_Attack(action);

	ACS_NPC_Normal_Attack(action);

	ACS_Take_Damage(action);


	if (
	(CPlayer)action.victim 
	&& action.GetBuffSourceName() != "FallingDamage"
	&& action.GetBuffSourceName() != "ACS_Debug"
	&& action.GetBuffSourceName() != "Debug"
	&& action.GetBuffSourceName() != "Quest"
	&& (GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
	) 
	{
		if (((CNewNPC)action.attacker).GetNPCType() == ENGT_Guard)
		{
			ACS_Guards_Tutorial();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
			{
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
			}
			
			money = GetWitcherPlayer().GetMoney();

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
				GetWitcherPlayer().RemoveMoney((int)money);
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_guards_took_money") );
			}
			else
			{
				((CNewNPC)action.attacker).SetHealthPerc(100);
			}
			
			GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

			if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
			&& !GetWitcherPlayer().IsPerformingFinisher())
			{
				ACS_Hit_Animations(action);
			}
		}
		else
		{
			if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
			{
				if(!GetWitcherPlayer().HasTag('ACS_Enter_Death_Scene_Start'))
				{
					ACS_ThingsThatShouldBeRemoved();

					GetWitcherPlayer().EnableCharacterCollisions(true); 

					GetWitcherPlayer().EnableCollisions(true);

					GetWitcherPlayer().SetIsCurrentlyDodging(false);

					if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
					{
						GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
					}

					if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
					{
						GetACSWatcher().Grow_Geralt_Immediate_Fast();

						GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
					}

					GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

					GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

					GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

					GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

					GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

					if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
					&& !GetWitcherPlayer().IsPerformingFinisher())
					{
						ACS_Hit_Animations(action);
					}

					GetWitcherPlayer().DestroyEffect('blood');
					GetWitcherPlayer().DestroyEffect('death_blood');
					GetWitcherPlayer().DestroyEffect('heavy_hit');
					GetWitcherPlayer().DestroyEffect('light_hit');
					GetWitcherPlayer().DestroyEffect('blood_spill');
					GetWitcherPlayer().DestroyEffect('fistfight_heavy_hit');
					GetWitcherPlayer().DestroyEffect('heavy_hit_horseriding');
					GetWitcherPlayer().DestroyEffect('fistfight_hit');
					GetWitcherPlayer().DestroyEffect('critical hit');
					GetWitcherPlayer().DestroyEffect('death_hit');
					GetWitcherPlayer().DestroyEffect('blood_throat_cut');
					GetWitcherPlayer().DestroyEffect('hit_back');
					GetWitcherPlayer().DestroyEffect('standard_hit');
					GetWitcherPlayer().DestroyEffect('critical_bleeding'); 
					GetWitcherPlayer().DestroyEffect('fistfight_hit_back'); 
					GetWitcherPlayer().DestroyEffect('heavy_hit_back'); 
					GetWitcherPlayer().DestroyEffect('light_hit_back'); 

					GetWitcherPlayer().PlayEffectSingle('blood');
					GetWitcherPlayer().PlayEffectSingle('death_blood');
					GetWitcherPlayer().PlayEffectSingle('heavy_hit');
					GetWitcherPlayer().PlayEffectSingle('light_hit');
					GetWitcherPlayer().PlayEffectSingle('blood_spill');
					GetWitcherPlayer().PlayEffectSingle('fistfight_heavy_hit');
					GetWitcherPlayer().PlayEffectSingle('heavy_hit_horseriding');
					GetWitcherPlayer().PlayEffectSingle('fistfight_hit');
					GetWitcherPlayer().PlayEffectSingle('critical hit');
					GetWitcherPlayer().PlayEffectSingle('death_hit');
					GetWitcherPlayer().PlayEffectSingle('blood_throat_cut');
					GetWitcherPlayer().PlayEffectSingle('hit_back');
					GetWitcherPlayer().PlayEffectSingle('standard_hit');
					GetWitcherPlayer().PlayEffectSingle('critical_bleeding'); 
					GetWitcherPlayer().PlayEffectSingle('fistfight_hit_back'); 
					GetWitcherPlayer().PlayEffectSingle('heavy_hit_back'); 
					GetWitcherPlayer().PlayEffectSingle('light_hit_back'); 

					GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Death', true); 

					GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Death', true); 

					GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Death', true);

					GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

					GetWitcherPlayer().DrainVitality( GetWitcherPlayer().GetStat( BCS_Vitality ) * 0.99 );

					GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
					GetWitcherPlayer().SetCanPlayHitAnim(false);
					GetWitcherPlayer().AddBuffImmunity_AllNegative('god', true);

					if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} 
		
					GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

					GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

					GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);
					
					GetWitcherPlayer().AddTag('ACS_Enter_Death_Scene_Start');
				}
			}
		}
		
		return;
	}
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
		(GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
		) 
		{
			if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
			{
				ACS_ThingsThatShouldBeRemoved();

				GetWitcherPlayer().EnableCharacterCollisions(true); 

				GetWitcherPlayer().EnableCollisions(true);

				GetWitcherPlayer().SetIsCurrentlyDodging(false);

				if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
				{
					GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
				}

				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

				GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

				GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

				if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
				&& !GetWitcherPlayer().IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}

				GetWitcherPlayer().StopEffect('blood');
				GetWitcherPlayer().StopEffect('death_blood');
				GetWitcherPlayer().StopEffect('heavy_hit');
				GetWitcherPlayer().StopEffect('light_hit');
				GetWitcherPlayer().StopEffect('blood_spill');
				GetWitcherPlayer().StopEffect('fistfight_heavy_hit');
				GetWitcherPlayer().StopEffect('heavy_hit_horseriding');
				GetWitcherPlayer().StopEffect('fistfight_hit');
				GetWitcherPlayer().StopEffect('critical hit');
				GetWitcherPlayer().StopEffect('death_hit');
				GetWitcherPlayer().StopEffect('blood_throat_cut');
				GetWitcherPlayer().StopEffect('hit_back');
				GetWitcherPlayer().StopEffect('standard_hit');
				GetWitcherPlayer().StopEffect('critical_bleeding'); 
				GetWitcherPlayer().StopEffect('fistfight_hit_back'); 
				GetWitcherPlayer().StopEffect('heavy_hit_back'); 
				GetWitcherPlayer().StopEffect('light_hit_back'); 

				GetWitcherPlayer().PlayEffect('blood');
				GetWitcherPlayer().PlayEffect('death_blood');
				GetWitcherPlayer().PlayEffect('heavy_hit');
				GetWitcherPlayer().PlayEffect('light_hit');
				GetWitcherPlayer().PlayEffect('blood_spill');
				GetWitcherPlayer().PlayEffect('fistfight_heavy_hit');
				GetWitcherPlayer().PlayEffect('heavy_hit_horseriding');
				GetWitcherPlayer().PlayEffect('fistfight_hit');
				GetWitcherPlayer().PlayEffect('critical hit');
				GetWitcherPlayer().PlayEffect('death_hit');
				GetWitcherPlayer().PlayEffect('blood_throat_cut');
				GetWitcherPlayer().PlayEffect('hit_back');
				GetWitcherPlayer().PlayEffect('standard_hit');
				GetWitcherPlayer().PlayEffect('critical_bleeding'); 
				GetWitcherPlayer().PlayEffect('fistfight_hit_back'); 
				GetWitcherPlayer().PlayEffect('heavy_hit_back'); 
				GetWitcherPlayer().PlayEffect('light_hit_back'); 

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Death', true); 

				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Death', true); 

				GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Death', true);

				GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				GetWitcherPlayer().DrainVitality( GetWitcherPlayer().GetStat( BCS_Vitality ) * 0.99 );

				GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
				GetWitcherPlayer().SetCanPlayHitAnim(false);
				GetWitcherPlayer().AddBuffImmunity_AllNegative('god', true);

				if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} 
		
				GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

				GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

				GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);
			}
		}
		else
		{
			if (action.processedDmg.vitalityDamage == 0)
			{
				GetWitcherPlayer().StopEffect( 'heavy_hit' );

				GetWitcherPlayer().DestroyEffect( 'heavy_hit' );

				GetWitcherPlayer().StopEffect( 'hit_screen' );	

				GetWitcherPlayer().DestroyEffect( 'hit_screen' );
			}

			if (GetWitcherPlayer().IsOnGround())
			{
				GetWitcherPlayer().PlayEffectSingle('red_quen_lasting_shield_hit');

				GetWitcherPlayer().StopEffect('red_quen_lasting_shield_hit');

				GetWitcherPlayer().PlayEffectSingle('red_lasting_shield_discharge');

				GetWitcherPlayer().StopEffect('red_lasting_shield_discharge');

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
	var actors    							: array<CActor>;
	var i									: int;	
	var npc     							: CNewNPC;

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	for( i = 0; i < actors.Size(); i += 1 )
	{
		npc = (CNewNPC)actors[i];
		
		if( actors.Size() > 0 )
		{	
			npc.SignalGameplayEvent( 'AI_GetOutOfTheWay' ); 
		
			npc.SignalGameplayEventParamObject( 'CollideWithPlayer', thePlayer ); 

			theGame.GetBehTreeReactionManager().CreateReactionEvent( npc, 'BumpAction', 1, 1, 1, 1, false );

			if (!npc.HasBuff(EET_HeavyKnockdown))
			{
				npc.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
			}

			if (!npc.HasBuff(EET_Stagger))
			{
				npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
			}
		}
	}

	rot = GetWitcherPlayer().GetWorldRotation();

	pos = GetWitcherPlayer().GetWorldPosition();

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

	theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( thePlayer, 'CastSignAction', -1, 20.0f, -1.f, -1, true );
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
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
					dmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
					+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
					+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

					action.processedDmg.essenceDamage += dmgValSilver;
					action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
					//action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * RandRangeF(0.05, 0);
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				if (npc.UsesVitality())
				{
					dmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

					action.processedDmg.vitalityDamage += dmgValSteel;

					action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);

					if (!ACS_GetItem_Aerondight())
					{
						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.025)) );
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
				if ( !GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') && !GetWitcherPlayer().HasTag('ACS_Sparagmos_Active') )
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

					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_light");
							GetWitcherPlayer().SoundEvent("cmb_play_hit_light");
						}
					}
				}
				else if ( action.GetHitReactionType() == EHRT_Heavy )
				{
					//ACS_Heavy_Attack_Trail();
					
					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_heavy");
							GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");
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

function ACS_Enemy_On_Take_Damage_General(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if (action.GetHitReactionType() != EHRT_Reflect)
			{
				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
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
		}
		else
		{
			if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
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

function ACS_Forest_God_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( npc.HasTag('ACS_Forest_God') )
		{
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
		}
	}
}

function ACS_Rage_Enemy_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if (
			npc.HasTag('ACS_Swapped_To_Shield')
			|| npc.HasTag('ACS_Swapped_To_Vampire')
			|| npc.HasTag('ACS_In_Rage')
			)
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				if (npc.HasTag('ACS_Swapped_To_Shield'))
				{
					npc.SoundEvent("shield_wood_impact");

					npc.SoundEvent("grunt_vo_block");
				}
			}
		}
	}
}

function ACS_Nekker_Guardian_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if ( npc.HasTag('ACS_Nekker_Guardian'))
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}
		}
	}
}

function ACS_She_Who_Knows_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}
		}
	}
}

function ACS_Wild_Hunt_Bosses_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if ( npc.HasAbility('WildHunt_Eredin')
			|| npc.HasAbility('WildHunt_Imlerith')
			)
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
				}
			}
		}
	}
}

function ACS_NightStalker_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if ( npc.HasTag('ACS_Night_Stalker'))
			{
				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
				
				if (GetACSNightStalker().IsEffectActive('predator_mode', false))
				{
					npc.SetCanPlayHitAnim(true); 
					GetACSNightStalker().DestroyEffect('predator_mode');

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
				else
				{
					npc.SetCanPlayHitAnim(false); 

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
					}
				}

				GetACSNightStalker().DestroyEffect('glow');
				GetACSNightStalker().PlayEffectSingle('glow');

				if (!GetACSNightStalker().IsEffectActive('demonic_possession', false))
				{
					GetACSNightStalker().PlayEffectSingle('demonic_possession');
				}
			}
		}
	}
}

function ACS_XenoTyrant_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if ( npc.HasTag('ACS_Xeno_Tyrant'))
			{
				npc.SetCanPlayHitAnim(false); 

				if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
				{
					GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
				}
				else
				{
					GetACSXenoTyrant().AddAbility('mon_kikimore_small');
				}

				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
				}
			}
		}
	}
}

function ACS_XenoSoldier_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if ( npc.HasTag('ACS_Xeno_Soldiers'))
			{
				if (npc.HasAbility('mon_kikimore_small'))
				{
					if (npc.HasAbility('Burrow'))
					{
						npc.RemoveAbility('Burrow');
					}

					if (npc.HasAbility('mon_kikimora_worker'))
					{
						npc.RemoveAbility('mon_kikimora_worker');
					}

					if (!npc.HasAbility('mon_kikimore_big'))
					{
						npc.AddAbility('mon_kikimore_big');
					}

					if (!npc.HasAbility('mon_kikimora_warrior'))
					{
						npc.AddAbility('mon_kikimora_warrior');
					}

					npc.RemoveAbility('mon_kikimore_small');
				}
				else
				{
					if (!npc.HasAbility('Burrow'))
					{
						npc.AddAbility('Burrow');
					}

					if (!npc.HasAbility('mon_kikimora_worker'))
					{
						npc.AddAbility('mon_kikimora_worker');
					}

					if (npc.HasAbility('mon_kikimore_big'))
					{
						npc.RemoveAbility('mon_kikimore_big');
					}

					if (npc.HasAbility('mon_kikimora_warrior'))
					{
						npc.RemoveAbility('mon_kikimora_warrior');
					}

					npc.AddAbility('mon_kikimore_small');
				}

				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
				}
			}
		}
	}
}

function ACS_XenoArmoredWorker_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if ( npc.HasTag('ACS_Xeno_Armored_Workers'))
			{
				if (RandF() < 0.5)
				{
					if (RandF() < 0.5)
					{
						if (!npc.HasAbility('Venom'))
						{
							npc.AddAbility('Venom');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
					else
					{
						if (!npc.HasAbility('Charge'))
						{
							npc.AddAbility('Charge');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
				}
				else
				{
					if (RandF() < 0.5)
					{
						if (!npc.HasAbility('Block'))
						{
							npc.AddAbility('Block');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
					else
					{
						if (!npc.HasAbility('Spikes'))
						{
							npc.AddAbility('Spikes');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}
					}
				}
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
				}
			}
		}
	}
}

function ACS_Fire_Bear_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}	
		}
	}
}

function ACS_Knightmare_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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

					//GetWitcherPlayer().AddEffectDefault(EET_HeavyKnockdown, GetACSKnightmareEternum(), 'Knightmare_Quen_Rebound');
				}
				else
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
					}
				}
				
				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2');
				//GetACSKnightmareQuenHit().PlayEffect('quen_rebound_sphere_bear_abl2');

				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2_copy');
				//GetACSKnightmareQuenHit().PlayEffect('quen_rebound_sphere_bear_abl2_copy');

				GetACSKnightmareQuenHit().StopEffect('quen_impulse_explode');
				//GetACSKnightmareQuen().PlayEffect('quen_impulse_explode');
			}
		}
	}
}

function ACS_Unseen_Blade_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
	}
}

function ACS_Big_Lizard_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if ( npc.HasTag('ACS_Big_Lizard'))
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
				}

				if (!((CNewNPC)npc).IsFlying()
				&& npc.IsOnGround())
				{
					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
				}

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}
		}
	}
}

function ACS_Rat_Mage_On_Take_Damage(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			if ( npc.HasTag('ACS_Rat_Mage'))
			{
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

					GetACSRatMageQuenHit().StopEffect('discharge');
					GetACSRatMageQuenHit().PlayEffect('discharge');

					GetACSRatMageQuen().PlayEffect('default_fx');
					GetACSRatMageQuen().StopEffect('default_fx');
				}
				else
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
				
				GetACSRatMageQuenHit().StopEffect('quen_rebound_sphere_bear_abl2');

				GetACSRatMageQuenHit().StopEffect('quen_rebound_sphere_bear_abl2_copy');

				GetACSRatMageQuenHit().StopEffect('quen_impulse_explode');
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	if 
	(playerAttacker && npc)
	{
		if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
		{
			if (npc.GetImmortalityMode() != AIM_None)
			{
				npc.SetImmortalityMode( AIM_None, AIC_Combat ); 
			}
		}

		if (!npc.HasAbility('InstantKillImmune'))
		{
			npc.AddAbility('InstantKillImmune');
		}

		if (!npc.HasAbility('OneShotImmune'))
		{
			npc.AddAbility('OneShotImmune');
		}

		if (!npc.HasAbility('ablParryHeavyAttacks'))
		{
			npc.AddAbility('ablParryHeavyAttacks');
		}

		if (!npc.HasAbility('ablCounterHeavyAttacks'))
		{
			npc.AddAbility('ablCounterHeavyAttacks');
		}

		if (!npc.HasAbility('IgnoreLevelDiffForParryTest'))
		{
			npc.AddAbility('IgnoreLevelDiffForParryTest');
		}

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

			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			if (ACS_Armor_Equipped_Check())
			{
				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
			}

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

		if (ACS_Armor_Equipped_Check() 
		&& !action.IsDoTDamage() )
		{
			if (RandF() < 0.5)
			{
				thePlayer.SoundEvent("monster_caretaker_vo_attack_short", 'head' );
			}
		}

		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if (ACS_Armor_Equipped_Check() )
			{
				thePlayer.SoundEvent("monster_caretaker_fx_drain_energy_player");

				if (npc.UsesEssence())
				{
					GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.essenceDamage * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.vitalityDamage * 0.25 );
				}
				
				if ((GetWitcherPlayer().HasTag('igni_sword_equipped')
				|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
				&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina)
				)
				{
					if (RandF() < 0.5)
					{
						npc.SoundEvent("fx_fire_geralt_fire_hit");

						npc.SoundEvent("fx_fire_burning_strong_end");
						
						dmg = new W3DamageAction in theGame.damageMgr;
					
						dmg.Initialize(GetWitcherPlayer(), npc, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
						
						dmg.SetProcessBuffsIfNoDamage(true);

						dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, 1 );

						if (!npc.HasBuff(EET_Burning))
						{
							dmg.AddEffectInfo( EET_Burning, 0.5 );
						}
							
						theGame.damageMgr.ProcessAction( dmg );
							
						delete dmg;	
					}
				}
			}

			if (
			GetWitcherPlayer().HasTag('aard_sword_equipped')
			|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
			|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
			)
			{
				GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

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

				if (GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15)
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

				if (GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active'))
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

				if (GetWitcherPlayer().HasTag('ACS_Sparagmos_Active'))
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

				if (GetWitcherPlayer().HasTag('ACS_AardPull_Active'))
				{
					GetWitcherPlayer().GainStat( BCS_Stamina, GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 );
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
								((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
								
								// npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
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
			GetWitcherPlayer().HasTag('axii_sword_equipped')
			|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				finisherDist = 1.5f;

				if (ACS_Player_Scale() > 1)
				{
					finisherDist += ACS_Player_Scale() * 0.75;
				}

				if (
				VecDistance( GetWitcherPlayer().GetWorldPosition(), npc.GetNearestPointInBothPersonalSpaces( GetWitcherPlayer().GetWorldPosition() ) ) > finisherDist
				)
				{
					GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

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
				
				if (GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15)
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

				if (GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active'))
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

				if (GetWitcherPlayer().HasTag('ACS_Sparagmos_Active'))
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
								((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
								
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
								//npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
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
			GetWitcherPlayer().HasTag('igni_sword_equipped')
			|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
			)
			{
				if (ACS_Griffin_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Griffin_Special_Attack'))
				{
					if ( GetWitcherPlayer().GetEquippedSign() == ST_Igni )
					{
						npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
					}
					else if ( GetWitcherPlayer().GetEquippedSign() == ST_Axii )
					{
						npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
					}
					else if ( GetWitcherPlayer().GetEquippedSign() == ST_Aard )
					{
						npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
					}
					else if ( GetWitcherPlayer().GetEquippedSign() == ST_Quen )
					{
						npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
					}
					else if ( GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
					{
						npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
					}
				}

				if (ACS_Manticore_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Manticore_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );

					npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );	
				}

				if (ACS_Bear_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Bear_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Bear_Special_Attack' );
				}

				if (ACS_Viper_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Viper_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );
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
								((CNewNPC)npc).SetLevel( (GetWitcherPlayer().GetLevel() * 7 ) / 4 );
								
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
								//npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
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
			else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
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

				GetWitcherPlayer().SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

				GetWitcherPlayer().IncreaseUninterruptedHitsCount();	

				GetACSWatcher().Passive_Weapon_Effects_Switch();

				if (npc.UsesEssence())
				{
					GetWitcherPlayer().GainStat( BCS_Focus, GetWitcherPlayer().GetStatMax( BCS_Focus) * 0.1 ); 

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
						vampireDmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

						action.processedDmg.essenceDamage += vampireDmgValSilver;

						action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
					}

					if ( GetWitcherPlayer().HasTag('ACS_Vampire_Dash_Attack') )
					{
						action.processedDmg.essenceDamage += (npc.GetStatMax(BCS_Essence)  - npc.GetStat(BCS_Essence) ) * 0.15;
					}
				}
				else if (npc.UsesVitality())
				{
					GetWitcherPlayer().GainStat( BCS_Focus, GetWitcherPlayer().GetStatMax( BCS_Focus) * 0.05 );

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
						vampireDmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
						+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
						+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

						action.processedDmg.vitalityDamage += vampireDmgValSteel;
						action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);
					}

					if ( GetWitcherPlayer().HasTag('ACS_Vampire_Dash_Attack') )
					{
						action.processedDmg.vitalityDamage += (npc.GetStatMax(BCS_Vitality) - npc.GetStat(BCS_Vitality)) * 0.15;
					}
				}

				if( !npc.IsImmuneToBuff( EET_Bleeding ) && !npc.HasBuff( EET_Bleeding ) ) 
				{ 
					npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_vampire_claw_effects' );	
				}

				if( !npc.IsImmuneToBuff( EET_BleedingTracking ) && !npc.HasBuff( EET_BleedingTracking ) ) 
				{ 
					npc.AddEffectDefault( EET_BleedingTracking, GetWitcherPlayer(), 'acs_vampire_claw_effects' );	
				}
				
				if (GetWitcherPlayer().IsGuarded())
				{
					GetWitcherPlayer().GainStat( BCS_Vitality, heal ); 
				}
				else
				{
					GetWitcherPlayer().GainStat( BCS_Vitality, heal * 2 ); 
				}
				
				if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
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

						GetWitcherPlayer().PlayEffectSingle('blood_effect_claws');
						GetWitcherPlayer().StopEffect('blood_effect_claws');
					}
				}

				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_hit_claws");

				GetWitcherPlayer().RemoveTag('ACS_Vampire_Dash_Attack');

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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	//&& !playerAttacker
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !action.IsDoTDamage()
	&& (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5)
	&& !GetWitcherPlayer().IsPerformingFinisher()
	&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !action.WasDodged()
	&& !GetWitcherPlayer().IsInFistFightMiniGame() 
	&& !GetWitcherPlayer().HasTag('ACS_Camo_Active')
	//&& !GetWitcherPlayer().HasTag('igni_sword_equipped')
	//&& !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	)
	{
		if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
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
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Vamp_Claws_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

			GetWitcherPlayer().SetPlayerTarget( npcAttacker );

			GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

			GetWitcherPlayer().UpdateDisplayTarget( true );

			GetWitcherPlayer().UpdateLookAtTarget();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.1, 1, );
			
			if ( RandF() < 0.5 )
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						GetWitcherPlayer().StopEffect('left_sparks');
						GetWitcherPlayer().PlayEffectSingle('left_sparks');
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('taunt_sparks');
							GetWitcherPlayer().PlayEffectSingle('taunt_sparks');
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('left_sparks');
							GetWitcherPlayer().PlayEffectSingle('left_sparks');
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

					GetWitcherPlayer().StopEffect('left_sparks');
					GetWitcherPlayer().PlayEffectSingle('left_sparks');
				}
			}
			else
			{
				if ( RandF() < 0.45 )
				{
					if ( RandF() < 0.45 )
					{
						playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						GetWitcherPlayer().StopEffect('right_sparks');
						GetWitcherPlayer().PlayEffectSingle('right_sparks');
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('taunt_sparks');
							GetWitcherPlayer().PlayEffectSingle('taunt_sparks');
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('right_sparks');
							GetWitcherPlayer().PlayEffectSingle('right_sparks');
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
					GetWitcherPlayer().StopEffect('right_sparks');
					GetWitcherPlayer().PlayEffectSingle('right_sparks');
				}
			}
		}
		else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
		{
			vACS_Shield_Summon = new cACS_Shield_Summon in theGame;

			vACS_Shield_Summon.Axii_Persistent_Shield_Summon();

			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.1, 1, );

			GetWitcherPlayer().SoundEvent("cmb_imlerith_shield_impact");

			//GetWitcherPlayer().SetPlayerTarget( npcAttacker );

			//GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

			//GetWitcherPlayer().UpdateDisplayTarget( true );

			//GetWitcherPlayer().UpdateLookAtTarget();

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
			GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.1, 1, );

			GetWitcherPlayer().SoundEvent("grunt_vo_block");
								
			GetWitcherPlayer().SoundEvent("cmb_play_parry");

			if ( theInput.GetActionValue('LockAndGuard') > 0.5
			&& !GetWitcherPlayer().IsInCombat())
			{
				GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
				GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
			}

			/*
			if (
			GetWitcherPlayer().IsGuarded()
			|| GetWitcherPlayer().IsInGuardedState()
			)
			{
				GetWitcherPlayer().SetGuarded(false);
				GetWitcherPlayer().OnGuardedReleased();	
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
	var movementAdjustor, movementAdjustorWerewolf																					: CMovementAdjustor;
	var ticket, ticketWerewolf 																										: SMovementAdjustmentRequestTicket;
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorWerewolf = GetACSTransfomrationWerewolf().GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	&& action.GetBuffSourceName() != "FallingDamage"
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !GetWitcherPlayer().HasTag('blood_sucking')
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Immortal
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Invulnerable
	&& !GetWitcherPlayer().IsDodgeTimerRunning()
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	/*
	&& (GetWitcherPlayer().HasTag('aard_sword_equipped')
	|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('axii_sword_equipped')
	|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('quen_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('vampire_claws_equipped') )
	*/
	)
	{
		if (
		!action.IsDoTDamage()
		&& action.GetHitReactionType() != EHRT_Reflect
		&& !GetWitcherPlayer().IsInGuardedState()
		&& !GetWitcherPlayer().IsGuarded()
		&& !action.WasDodged()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
		&& action.GetBuffSourceName() != "vampirism" 
		)
		{
			if (ACS_Transformation_Activated_Check())
			{
				if (ACS_Transformation_Werewolf_Check())
				{
					ticketWerewolf = movementAdjustorWerewolf.GetRequest( 'ACS_Transformation_Werewolf_Hit_Rotate');
					movementAdjustorWerewolf.CancelByName( 'ACS_Transformation_Werewolf_Hit_Rotate' );
					movementAdjustorWerewolf.CancelAll();

					ticketWerewolf = movementAdjustorWerewolf.CreateNewRequest( 'ACS_Transformation_Werewolf_Hit_Rotate' );
					movementAdjustorWerewolf.AdjustmentDuration( ticketWerewolf, 0.25 );
					movementAdjustorWerewolf.MaxRotationAdjustmentSpeed( ticketWerewolf, 500000 );

					if (GetCurMoonState() == EMS_Full
					&& (GetCurWeather() == EWE_Clear || GetCurWeather() == EWE_None)
					)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

						if (!GetACSTransfomrationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
						{
							movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
						}
					}
					else
					{
						if (!GetACSTransfomrationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;

							movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
						}
					}

					ACS_Transformation_Werewolf_Hit_Animations();
				}

				return;
			}

			GetACSWatcher().RemoveTimer('RendProjectileSwitchDelay');

			if ( npcAttacker.HasTag('ACS_taunted') )
			{
				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

				if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Knockdown ) && !playerVictim.HasBuff( EET_Knockdown ) ) 
				{ 	
					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

					movementAdjustor.CancelAll();

					playerVictim.AddEffectDefault( EET_Knockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Drunkenness, npcAttacker, 'acs_HIT_REACTION' ); 							
				}

				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('mutation_7_adrenaline_drop');
				GetWitcherPlayer().StopEffect('mutation_7_adrenaline_drop');
			}
			/*
			else if ( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus) * 0.9
			&& GetWitcherPlayer().GetStat(BCS_Stamina) >= GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.5
			&& GetWitcherPlayer().GetStat(BCS_Vitality) <= GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.5
			)
			{
				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax(BCS_Focus) * 0.75 );

				if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
				{
					if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.3;
					}
					else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
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
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('special_attack_break');
				GetWitcherPlayer().StopEffect('special_attack_break');

				GetACSWatcher().ACS_Hit_Reaction();
			}
			*/
			else
			{
				if (ACS_Armor_Omega_Equipped_Check())
				{
					thePlayer.SoundEvent("monster_caretaker_vo_pain");

					if (RandF() < 0.125)
					{
						thePlayer.SoundEvent("monster_caretaker_vo_death");
					}

					GetWitcherPlayer().PlayEffectSingle('hit_lightning');
					GetWitcherPlayer().StopEffect('hit_lightning');

					GetWitcherPlayer().SoundEvent("cmb_play_parry");

					GetWitcherPlayer().SetCanPlayHitAnim(false); 

					GetWitcherPlayer().AddBuffImmunity(EET_Stagger , 			'ACS_Armor', true);
					GetWitcherPlayer().AddBuffImmunity(EET_SlowdownFrost , 		'ACS_Armor', true);
					GetWitcherPlayer().AddBuffImmunity(EET_Frozen ,			 	'ACS_Armor', true);
					GetWitcherPlayer().AddBuffImmunity(EET_LongStagger , 		'ACS_Armor', true);
				}
				else if (ACS_Armor_Alpha_Equipped_Check())
				{
					thePlayer.SoundEvent("monster_caretaker_vo_pain");

					if (RandF() < 0.125)
					{
						thePlayer.SoundEvent("monster_caretaker_vo_death");
					}

					if (RandF() < 0.5)
					{
						GetWitcherPlayer().PlayEffectSingle('hit_lightning');
						GetWitcherPlayer().StopEffect('hit_lightning');

						GetWitcherPlayer().SoundEvent("cmb_play_parry");

						GetWitcherPlayer().SetCanPlayHitAnim(false); 

						GetWitcherPlayer().AddBuffImmunity(EET_Stagger , 			'ACS_Armor', true);
						GetWitcherPlayer().AddBuffImmunity(EET_SlowdownFrost , 		'ACS_Armor', true);
						GetWitcherPlayer().AddBuffImmunity(EET_Frozen ,			 	'ACS_Armor', true);
						GetWitcherPlayer().AddBuffImmunity(EET_LongStagger , 		'ACS_Armor', true);
					}
					else
					{
						GetWitcherPlayer().SetCanPlayHitAnim(true); 

						GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'ACS_Armor');
						GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'ACS_Armor');
						GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'ACS_Armor');
						GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'ACS_Armor');
						GetWitcherPlayer().RemoveBuffImmunity( EET_SlowdownFrost,			'ACS_Armor');
						GetWitcherPlayer().RemoveBuffImmunity( EET_Frozen,			 		'ACS_Armor');
					}
				}
				else
				{
					GetWitcherPlayer().SetCanPlayHitAnim(true); 

					GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'ACS_Armor');
					GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'ACS_Armor');
					GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'ACS_Armor');
					GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'ACS_Armor');
					GetWitcherPlayer().RemoveBuffImmunity( EET_SlowdownFrost,			'ACS_Armor');
					GetWitcherPlayer().RemoveBuffImmunity( EET_Frozen,			 		'ACS_Armor');
				}

				if (npcAttacker.HasBuff(EET_Stagger)
				|| npcAttacker.HasBuff(EET_HeavyKnockdown)
				|| npcAttacker.HasBuff(EET_Knockdown)
				)
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else
				{
					ACS_PlayerHitEffects();

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) && action.IsActionMelee() )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							if( ( RandF() < 0.45) || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.325;

								if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
								&& !GetWitcherPlayer().IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
								}
							}
							else
							{
								ACS_ArmorSystem_Tutorial();

								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;

								GetWitcherPlayer().SoundEvent("grunt_vo_block");
								
								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
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

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.2 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.2, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
							}
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							if( ( RandF() < 0.65 ) || GetWitcherPlayer().GetStat( BCS_Stamina )  <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

								if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
								&& !GetWitcherPlayer().IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
								}
							}
							else
							{
								ACS_ArmorSystem_Tutorial();

								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								GetWitcherPlayer().SoundEvent("grunt_vo_block");

								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
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

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
							}
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							if( ( RandF() < 0.85 ) || GetWitcherPlayer().GetStat( BCS_Stamina )  <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

								if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
								&& !GetWitcherPlayer().IsPerformingFinisher())
								{
									ACS_Hit_Animations(action);
								}
							}
							else
							{
								ACS_ArmorSystem_Tutorial();
								
								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								GetWitcherPlayer().SoundEvent("grunt_vo_block");

								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
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

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
							}
						}
						else
						{
							GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

							if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
							&& !GetWitcherPlayer().IsPerformingFinisher())
							{
								ACS_Hit_Animations(action);
							}
						}
					}
					else
					{
						GetACSWatcher().ACS_Combo_Mode_Reset_Hard();
						
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.1;

						if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
						&& !GetWitcherPlayer().IsPerformingFinisher())
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

    if(GetWitcherPlayer().HasTag('vampire_claws_equipped'))
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }
        else
        {
           GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }

        GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.5, false);
    }
    else
    {
        if( RandF() < 0.5 ) 
        { 																		
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
        else
        {	
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 0.5, false);
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

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
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
	else
	{
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
}

function ACS_Hit_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	if (GetWitcherPlayer().HasTag('blood_sucking')
	|| GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
	|| GetWitcherPlayer().IsCurrentlyDodging()
	|| GetWitcherPlayer().GetImmortalityMode() == AIM_Invulnerable
	|| GetWitcherPlayer().IsPerformingFinisher() 
	|| ACS_Armor_Omega_Equipped_Check()
	)
	{
		return;
	}

	if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate_Fast();

		GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
	}

	npcAttacker = (CActor)action.attacker;

	GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
	
    if ( ( GetWitcherPlayer().HasTag('vampire_claws_equipped') && !GetWitcherPlayer().HasBuff(EET_BlackBlood) ) || GetWitcherPlayer().HasTag('aard_sword_equipped') )
    {
        GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

		Bruxa_Camo_Decoy_Deactivate();

		GetWitcherPlayer().StopEffect('shadowdash');

		GetWitcherPlayer().StopEffect('shadowdash_short');

        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_left_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.45 )
                {
                    if ( RandF() < 0.45 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }	
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_front_right_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'reaction_hit_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
        }
    }
    else if(GetWitcherPlayer().HasTag('quen_sword_equipped'))
    {
        if (GetWitcherPlayer().GetStat(BCS_Vitality) <= GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.5)
        {
            if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
            {
                if ( RandF() < 0.5 )
                {
                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_cheast_lp_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_head_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_hit_leg_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }        
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
            }
        }
        else
        {
            if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_hips_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_strong_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_strong_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_heavy_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_combat_front_light_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_light_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_down_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_down_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_forward_front_head_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            } 
                        }
                    }	
                }
            }	
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
        }    
    }
    else if( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') || GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    if ( RandF() < 0.5 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_up_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }
                else
                {
                    if ( RandF() < 0.5 )
                    {
                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_right_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                    }
                    else
                    {
                        if ( RandF() < 0.5 )
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_front_left_down_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                    }
                }
            }
        }
        else
        {
            if ( RandF() < 0.5 )
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_hit_back_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
            }
        }
    }
    else if( GetWitcherPlayer().HasTag('axii_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                    else
                                    {
                                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                    }
                                    else
                                    {
                                        GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_down_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                }
                                else
                                {
                                    if ( RandF() < 0.5 )
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_06_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                    }
                                    else
                                    {
                                        if ( RandF() < 0.5 )
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_up_07_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                        }
                                        else
                                        {
                                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_front_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_06_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_07_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_down_05_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_down_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_down_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_left_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                            }
                            else
                            {
                                if ( RandF() < 0.5 )
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                                }
                                else
                                {
                                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_left_up_04_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                        else
                        {
                            if ( RandF() < 0.5 )
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_longsword_hit_front_right_up_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                            else
                            {
                                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_right_up_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                            }
                        }
                    }
                }
            }
        }
        else
        {
            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_hit_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
        }
    }
    else if( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            if ( RandF() < 0.5 )
            {
                if ( RandF() < 0.5 )
                {
                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_hit_front_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
            }
            else
            {
                if ( RandF() < 0.5 )
                {
                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
                else
                {
                    GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_f_2_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
                }
            }
        }	
        else
        {
            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_hit_light_b_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
        }
    }
    else if( 
	GetWitcherPlayer().HasTag('igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
	) 
    {
		if (ACS_Bear_School_Check()
		|| ACS_Forgotten_Wolf_Check()
		)
		{
			return;
		}
	
		if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
		{
			if ( RandF() < 0.5 )
			{
				if ( RandF() < 0.5 )
				{
					if ( RandF() < 0.5 )
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						if ( RandF() < 0.5 )
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_down_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_up_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
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
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
					}
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						if ( RandF() < 0.5 )
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_up_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_down_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_right_down_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_hit_front_left_up_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
				}	
			}
		}	
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_sword_hit_back_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
		}
	}		
}

function ACS_Transformation_Werewolf_Hit_Animations()
{
	GetACSTransfomrationWerewolf().DestroyEffect('light_hit');
	GetACSTransfomrationWerewolf().DestroyEffect('heavy_hit');
	GetACSTransfomrationWerewolf().DestroyEffect('light_hit_back');
	GetACSTransfomrationWerewolf().DestroyEffect('heavy_hit_back');
	GetACSTransfomrationWerewolf().DestroyEffect('blood_spill');

	GetACSTransfomrationWerewolf().PlayEffect('light_hit');
	GetACSTransfomrationWerewolf().PlayEffect('heavy_hit');
	GetACSTransfomrationWerewolf().PlayEffect('light_hit_back');
	GetACSTransfomrationWerewolf().PlayEffect('heavy_hit_back');
	GetACSTransfomrationWerewolf().PlayEffect('blood_spill');

	if (GetACSTransfomrationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
	{
		return;
	}

	GetACSWatcher().ACSWerewolfRemoveAttackTimers();

	if ( RandF() < 0.5 )
	{
		if ( RandF() < 0.5 )
		{
			GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_light_front_down', 0.25f, 0.875f);
		}
		else
		{
			GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_heavy_front_down', 0.25f, 0.875f);
		}
	}
	else
	{
		if ( RandF() < 0.5 )
		{
			if ( RandF() < 0.5 )
			{
				GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_heavy_front_right', 0.25f, 0.875f);
			}
			else
			{
				GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_light_front_left', 0.25f, 0.875f);
			}
		}
		else
		{
			if ( RandF() < 0.5 )
			{
				GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_light_front_right', 0.25f, 0.875f);
			}
			else
			{
				GetACSWatcher().ACSTransformWerewolfPlayAnim( 'monster_werewolf_hit_heavy_front_left', 0.25f, 0.875f);
			}
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God')
	&& !action.IsDoTDamage()
	)
	{	
		if (playerVictim)
		{
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (GetWitcherPlayer().IsGuarded()
					&& GetWitcherPlayer().IsInGuardedState())
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

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}			

							npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
						}
						else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
						{
							npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
							
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
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
					
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God_Shadows')
	&& !action.IsDoTDamage()
	)
	{	
		if (
			 GetWitcherPlayer().HasTag('igni_sword_equipped_TAG') || !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
		)
		{
			if (playerVictim)
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
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
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Ice_Titan')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (GetWitcherPlayer().IsGuarded()
				&& GetWitcherPlayer().IsInGuardedState())
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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fire_Bear')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (GetWitcherPlayer().IsGuarded()
				&& GetWitcherPlayer().IsInGuardedState())
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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
						
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

					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
				
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

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Knighmare_Eternum')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
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

function ACS_Eredin_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Eredin')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
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
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;
				}
			}
		}
		else
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
		}
	}
}

function ACS_NightStalker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Night_Stalker')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Poison))
					{
						playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Night_Stalker' );
					}
					
					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Night_Stalker' );
					}

					if (!playerVictim.HasBuff(EET_HeavyKnockdown))
					{
						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Night_Stalker' );
					}
				}

				if (npcAttacker.UsesVitality()) 
				{ 
					npcAttacker.GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
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
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;
				}
			}
		}
	}
}

function ACS_XenoTyrant_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var params 												: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Tyrant')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Poison))
					{
						playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Tyrant' );
					}
					
					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Tyrant' );
					}

					if (!playerVictim.HasBuff(EET_HeavyKnockdown))
					{
						playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Xeno_Tyrant' );	
					}

					if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
					{
						GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
					}
				}

				if (npcAttacker.UsesVitality()) 
				{ 
					npcAttacker.GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.0125 );
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.0125 );
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
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;
				}
			}
		}
	}
}

function ACS_XenoSoldier_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Soldiers')
	&& !action.IsDoTDamage()
	)
	{	
		if (npc.HasAbility('mon_kikimore_small'))
		{
			if (npc.HasAbility('Burrow'))
			{
				npc.RemoveAbility('Burrow');
			}

			if (npc.HasAbility('mon_kikimora_worker'))
			{
				npc.RemoveAbility('mon_kikimora_worker');
			}

			if (!npc.HasAbility('mon_kikimore_big'))
			{
				npc.AddAbility('mon_kikimore_big');
			}

			if (!npc.HasAbility('mon_kikimora_warrior'))
			{
				npc.AddAbility('mon_kikimora_warrior');
			}

			npc.RemoveAbility('mon_kikimore_small');
		}
		else
		{
			if (!npc.HasAbility('Burrow'))
			{
				npc.AddAbility('Burrow');
			}

			if (!npc.HasAbility('mon_kikimora_worker'))
			{
				npc.AddAbility('mon_kikimora_worker');
			}

			if (npc.HasAbility('mon_kikimore_big'))
			{
				npc.RemoveAbility('mon_kikimore_big');
			}

			if (npc.HasAbility('mon_kikimora_warrior'))
			{
				npc.RemoveAbility('mon_kikimora_warrior');
			}

			npc.AddAbility('mon_kikimore_small');
		}

		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Poison))
					{
						playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Soldiers' );
					}
					
					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Soldiers' );
					}
				}

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.025 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.025 );
				} 
			}
		}
	}
}

function ACS_XenoWorker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Workers')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Poison))
					{
						playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Workers' );
					}
				}

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
				} 
			}
		}
	}
}

function ACS_XenoArmoredWorker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Armored_Workers')
	&& !action.IsDoTDamage()
	)
	{	
		if (RandF() < 0.5)
		{
			if (RandF() < 0.5)
			{
				if (!npc.HasAbility('Venom'))
				{
					npc.AddAbility('Venom');
				}

				if (npc.HasAbility('Charge'))
				{
					npc.RemoveAbility('Charge');
				}

				if (npc.HasAbility('Block'))
				{
					npc.RemoveAbility('Block');
				}

				if (npc.HasAbility('Spikes'))
				{
					npc.RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!npc.HasAbility('Charge'))
				{
					npc.AddAbility('Charge');
				}

				if (npc.HasAbility('Venom'))
				{
					npc.RemoveAbility('Venom');
				}

				if (npc.HasAbility('Block'))
				{
					npc.RemoveAbility('Block');
				}

				if (npc.HasAbility('Spikes'))
				{
					npc.RemoveAbility('Spikes');
				}


			}
		}
		else
		{
			if (RandF() < 0.5)
			{
				if (!npc.HasAbility('Block'))
				{
					npc.AddAbility('Block');
				}

				if (npc.HasAbility('Charge'))
				{
					npc.RemoveAbility('Charge');
				}

				if (npc.HasAbility('Venom'))
				{
					npc.RemoveAbility('Venom');
				}

				if (npc.HasAbility('Spikes'))
				{
					npc.RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!npc.HasAbility('Spikes'))
				{
					npc.AddAbility('Spikes');
				}

				if (npc.HasAbility('Charge'))
				{
					npc.RemoveAbility('Charge');
				}

				if (npc.HasAbility('Block'))
				{
					npc.RemoveAbility('Block');
				}

				if (npc.HasAbility('Venom'))
				{
					npc.RemoveAbility('Venom');
				}
			}
		}

		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Armored_Workers' );
					}
				}

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
				} 
			}
		}
	}
}

function ACS_Unseen_Monster_Attack(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Vampire_Monster')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
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

function ACS_Big_Lizard_Attack(action: W3DamageAction)
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Big_Lizard')
	&& !action.IsDoTDamage()
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if ( playerVictim)
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Night_Stalker' );
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

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' ); ACS_Theft_Prevention_6 ();

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

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
			&& !GetWitcherPlayer().IsCurrentlyDodging()
			&& !GetWitcherPlayer().IsPerformingFinisher()
			&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
			)
			{
				GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'acs_guard');
				GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'acs_guard');

				if (GetWitcherPlayer().IsGuarded()
				|| GetWitcherPlayer().IsInGuardedState())
				{
					GetWitcherPlayer().SetGuarded(false);
					GetWitcherPlayer().OnGuardedReleased();	
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
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				thePlayer.ClearAnimationSpeedMultipliers();

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

				if (((CMovingPhysicalAgentComponent)(npcAttacker.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| npcAttacker.GetRadius() >= 0.7
				)
				{
					if( !playerVictim.IsImmuneToBuff( EET_HeavyKnockdown ) && !playerVictim.HasBuff( EET_HeavyKnockdown ) ) 
					{ 	
						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

				GetWitcherPlayer().PlayEffectSingle('mutation_7_adrenaline_drop');
				GetWitcherPlayer().StopEffect('mutation_7_adrenaline_drop');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.3;

				//GetWitcherPlayer().DrainVitality((GetWitcherPlayer().GetStat(BCS_Vitality) * 0.3) + 25);

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStat(BCS_Stamina) * 0.3 );

				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 0.3 );

				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

				GetWitcherPlayer().PlayEffect('heavy_hit');
				GetWitcherPlayer().StopEffect('heavy_hit');
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
						
				dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
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

				//dmg.AddEffectInfo( EET_Stagger, 2 );
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
			}

			((CNewNPC)npcAttacker).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		}
	}
}

function ACS_NPC_Normal_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (
	npcAttacker
	&& playerVictim
	&& !action.IsDoTDamage()
	)
	{
		if (action.WasDodged()
		//|| (((W3Action_Attack)action).IsParried())
		|| (((W3Action_Attack)action).IsCountered())
		)
		{
			ACS_PerfectDodgesCounters_Tutorial();
			GetACSWatcher().ACS_SlowMo();
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
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = actors[i];

				if(!theGame.IsDialogOrCutscenePlaying()
				&& !GetWitcherPlayer().IsUsingHorse() 
				&& !GetWitcherPlayer().IsUsingVehicle()
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

				&& !npc.HasBuff(EET_Weaken)

				&& !npc.HasBuff(EET_Confusion)

				&& !npc.HasBuff(EET_AxiiGuardMe)

				&& !npc.HasBuff(EET_Hypnotized)

				&& !npc.HasBuff(EET_Immobilized)

				&& !npc.HasBuff(EET_Paralyzed)

				&& !npc.HasBuff(EET_Blindness)

				&& !npc.HasBuff(EET_Choking)

				&& !npc.HasBuff(EET_Swarm)

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
							ACS_Dynamic_Enemy_Behavior_System_Tutorial();

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
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
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
									if (GetWitcherPlayer().IsGuarded())
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
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
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
									if (GetWitcherPlayer().IsGuarded())
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
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
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
									if (GetWitcherPlayer().IsGuarded())
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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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
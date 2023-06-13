function ACS_BruxaDodgeSlideBackInit()
{
	var vBruxaDodgeSlideBack : cBruxaDodgeSlideBack;
	vBruxaDodgeSlideBack = new cBruxaDodgeSlideBack in theGame;
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('in_wraith')
		&& !GetWitcherPlayer().HasTag('blood_sucking')
		&& ACS_BuffCheck()
		&& GetWitcherPlayer().IsActionAllowed(EIAB_Dodge)
		)
		{
			vBruxaDodgeSlideBack.BruxaDodgeSlideBack_Engage();
		}
	}
}

statemachine class cBruxaDodgeSlideBack
{
    function BruxaDodgeSlideBack_Engage()
	{
		this.PushState('BruxaDodgeSlideBack_Engage');
	}
}

state BruxaDodgeSlideBack_Engage in cBruxaDodgeSlideBack
{
	private var pActor, actor 									: CActor;
	private var movementAdjustor								: CMovementAdjustor;
	private var ticket 											: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance							: float;
	private var actors, targetActors    						: array<CActor>;
	private var i         										: int;
	private var npc, targetNpc     								: CNewNPC;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		BruxaDodgeSlideBack();
	}
	
	entry function BruxaDodgeSlideBack()
	{	
		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		GetWitcherPlayer().StopEffect('dive_shape');
		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();

		DodgePunishment();

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		GetWitcherPlayer().SendAttackReactionEvent();

		//GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

		GetWitcherPlayer().RaiseEvent( 'Dodge' );

		if (ACS_Bruxa_Camo_Trail())
		{
			ACS_Bruxa_Camo_Trail().StopEffect('smoke');
			ACS_Bruxa_Camo_Trail().PlayEffect('smoke');
		}

		if (ACS_Armor_Equipped_Check())
		{
			thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_mv_footstep" );
		}

		if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
		{
			theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
		}
		
		if ( ACS_StaminaBlockAction_Enabled() 
		&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
		)
		{
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");
		}
		else
		{
			if (
			GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				vampire_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('aard_sword_equipped')
			)
			{
				aard_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('yrden_sword_equipped')
			)
			{
				yrden_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
			)
			{
				yrden_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
			)
			{
				axii_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('axii_sword_equipped')
			)
			{
				axii_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
			)
			{
				quen_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
			)
			{
				aard_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('quen_sword_equipped')
			)
			{
				quen_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('igni_sword_equipped') 
			|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
			)
			{
				ignii_sword_dodges();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 
				&& ACS_BruxaDodgeSlideBack_Enabled()
				&& ACS_can_special_dodge())
				{
					ACS_refresh_special_dodge_cooldown();

					WeaponRespawn();

					GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

					bruxa_slide_back();	

					GetACSWatcher().ACS_StaminaDrain(4);
				}
				else
				{
					WeaponRespawn();

					GetACSWatcher().dodge_timer_attack_actual();

					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

					Sleep(0.0625);

					GetWitcherPlayer().EvadePressed(EBAT_Dodge);	
				}
			}
		}
	}

	latent function WeaponRespawn()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}
	}

	latent function DodgeEffects()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled())
		{
			GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
	}

	latent function DodgePunishment()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 3.5, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() == 1 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (npc.IsHuman())
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0.5 );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0.5 );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
				}
			}
		}
		else if( actors.Size() > 1 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (npc.IsHuman())
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
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function vampire_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_can_special_dodge()
			&& ACS_BruxaDodgeSlideBack_Enabled())
			{
				ACS_refresh_special_dodge_cooldown();
		
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

				bruxa_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if ( ACS_BruxaDodgeRight_Enabled() )
			{
				ACS_BruxaDodgeBackRightInit();
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
						
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if ( ACS_BruxaDodgeLeft_Enabled() )
			{
				ACS_BruxaDodgeBackLeftInit();
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
						
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}	
		}
		else
		{
			if ( ACS_BruxaDodgeCenter_Enabled() )
			{
				ACS_BruxaDodgeBackCenterInit();
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function aard_sword_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_can_special_dodge()
			&& ACS_BruxaDodgeSlideBack_Enabled())
			{
				ACS_refresh_special_dodge_cooldown();
		
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

				bruxa_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);	
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				bruxa_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				bruxa_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function yrden_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function yrden_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function axii_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function axii_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function quen_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}		
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_1();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function aard_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);	
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_front_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function quen_sword_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				olgierd_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function ignii_sword_dodges()
	{
		WeaponRespawn();

		if (ACS_Zireael_Check())
		{
			ciri_dodges();
		}
		else
		{
			if (ACS_Wolf_School_Check())
			{
				wolf_school_dodges();
			}
			else if (ACS_Bear_School_Check())
			{
				bear_school_dodges();
			}
			else if (ACS_Cat_School_Check()|| ACS_Armor_Alpha_Equipped_Check())
			{
				cat_school_dodges();
			}
			else if (ACS_Griffin_School_Check() || ACS_Armor_Omega_Equipped_Check())
			{
				griffin_school_dodges();
			}
			else if (ACS_Manticore_School_Check())
			{
				manticore_school_dodges();
			}
			else if (ACS_Forgotten_Wolf_Check())
			{
				forgotten_wolf_school_dodges();
			}
			else if (ACS_Viper_School_Check())
			{
				viper_school_dodges();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 
				&& ACS_BruxaDodgeSlideBack_Enabled()
				&& ACS_can_special_dodge())
				{
					ACS_refresh_special_dodge_cooldown();

					WeaponRespawn();

					if (ACS_Armor_Equipped_Check())
					{
						olgierd_slide_back();	
					}
					else
					{
						olgierd_slide_back_2();	
					}

					GetACSWatcher().ACS_StaminaDrain(4);
				}
				else
				{
					WeaponRespawn();

					GetACSWatcher().dodge_timer_attack_actual();

					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

					Sleep(0.0625);

					GetWitcherPlayer().EvadePressed(EBAT_Dodge);	
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function bear_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function cat_school_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_front_dodge_alt_3();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_right_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_left_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function griffin_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function manticore_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function forgotten_wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4_short();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4_short();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function viper_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function ciri_dodges()
	{
		if (!GetWitcherPlayer().IsEffectActive('fury_403_ciri', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'fury_403_ciri' );
		}

		if (!GetWitcherPlayer().IsEffectActive('fury_ciri', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'fury_ciri' );
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			if (ACS_BruxaDodgeSlideBack_Enabled()
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeBack();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeBack();

					one_hand_sword_back_dodge_alt_3_long();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeFront();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1_long();
				}
				else
				{
					one_hand_sword_front_dodge_long();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeRight();

				one_hand_sword_right_dodge_alt_4_long();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeLeft();

				one_hand_sword_left_dodge_alt_4_long();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeBack();

				one_hand_sword_back_dodge_alt_3_long();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function bruxa_slide_back()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_slide_back');
		
		movementAdjustor.CancelByName( 'bruxa_slide_back' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_slide_back' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if( targetDistance <= 2*2 ) 
			{
				if ( ACS_BruxaDodgeCenter_Enabled() )
				{
					ACS_BruxaDodgeBackCenterInit();
				}
				else
				{
					GetACSWatcher().dodge_timer_actual();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
					&& ACS_DodgeEffects_Enabled())
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

						GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
						GetWitcherPlayer().StopEffect( 'shadowdash_short' );
					}

					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					
					movementAdjustor.SlideTo( ticket, TraceFloor(GetWitcherPlayer().GetWorldPosition() + theCamera.GetCameraDirection() * -2) );
				}
			}
			else
			{
				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_DodgeEffects_Enabled())
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
					GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_slideback_actual();

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 2  ); }	
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				
				movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
				GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	
			}
					
			GetACSWatcher().dodge_timer_slideback_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 2  ); }	
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			
			movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );
		}

		//Sleep(1);
		
		//GetWitcherPlayer().SetIsCurrentlyDodging(false);
	}

	latent function olgierd_slide_back()
	{
		if (ACS_Armor_Equipped_Check())
		{
			olgierd_slide_back_actual();	
		}
		else
		{
			if (ACS_GetWeaponMode() == 3)
			{
				if (ACS_GetItem_Iris())
				{
					olgierd_slide_back_actual();
				}
				else
				{
					olgierd_slide_back_2();
				}
			}
			else
			{
				olgierd_slide_back_actual();
			}
		}
	}

	latent function olgierd_slide_back_actual()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if( targetDistance <= 2*2 ) 
			{
				GetACSWatcher().dodge_timer_attack_actual();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_DodgeEffects_Enabled())
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, TraceFloor((GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.5) + theCamera.GetCameraDirection() * -1.5) );
			}
			else
			{
				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_DodgeEffects_Enabled())
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_attack_actual();

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3 );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
				GetWitcherPlayer().StopEffect('special_attack_fx');

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}

		if (!GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
		{
			GetWitcherPlayer().AddTag('ACS_Special_Dodge');
		}
	}

	latent function olgierd_slide_back_2()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back_2');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back_2' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
		
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );		
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}

		if (!GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
		{
			GetWitcherPlayer().AddTag('ACS_Special_Dodge');
		}
	}

	latent function bruxa_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_front_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_front_dodge' );
		
		movementAdjustor.CancelAll();

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_DodgeEffects_Enabled())
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );
		}
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//movementAdjustor.RotateTowards( ticket, actor );
					
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		
		}
	}

	latent function bruxa_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function two_hand_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( targetDistance <= 3*3 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( targetDistance <= 3*3 ) 
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function two_hand_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function two_hand_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				/*
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				*/

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{				
			/*
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			*/
			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		/*	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	
	}

	latent function two_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		/*
		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	

		*/
	}

	latent function one_hand_sword_front_dodge_long()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 3) );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		/*
		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	

		*/
	}

	latent function one_hand_sword_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_1_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1_long' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 3) );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_left_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		/*
		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_back_dodge_alt_3_long()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_3_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_3_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_3_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function one_hand_sword_left_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_left_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_left_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4_short');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4_short' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4_short' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4_short');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4_short' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4_short' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_left_dodge_alt_4_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function cat_one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_back_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);	

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function cat_one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function cat_one_hand_sword_left_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_left_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function cat_one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_right_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BruxaDodgeSlideBackInitForWeaponSwitching()
{
	var vBruxaDodgeSlideBackInitForWeaponSwitching : cBruxaDodgeSlideBackInitForWeaponSwitching;
	vBruxaDodgeSlideBackInitForWeaponSwitching = new cBruxaDodgeSlideBackInitForWeaponSwitching in theGame;
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('in_wraith')
		&& !GetWitcherPlayer().HasTag('blood_sucking')
		&& ACS_BuffCheck()
		&& GetWitcherPlayer().IsActionAllowed(EIAB_Dodge)
		&& !GetWitcherPlayer().IsInAir()
		)
		{
			vBruxaDodgeSlideBackInitForWeaponSwitching.BruxaDodgeSlideBackInitForWeaponSwitching_Engage();
		}
	}
}

statemachine class cBruxaDodgeSlideBackInitForWeaponSwitching
{
    function BruxaDodgeSlideBackInitForWeaponSwitching_Engage()
	{
		this.PushState('BruxaDodgeSlideBackInitForWeaponSwitching_Engage');
	}
}

state BruxaDodgeSlideBackInitForWeaponSwitching_Engage in cBruxaDodgeSlideBackInitForWeaponSwitching
{
	private var pActor, actor 									: CActor;
	private var movementAdjustor								: CMovementAdjustor;
	private var ticket 											: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance							: float;
	private var actors, targetActors    						: array<CActor>;
	private var i         										: int;
	private var npc, targetNpc     								: CNewNPC;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		BruxaDodgeSlideBack();
	}
	
	entry function BruxaDodgeSlideBack()
	{
		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
		{
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		}	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Dodge_On_Change_Beh_Movement_Adjust' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );

		movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTowards( ticket, actor );
		}
		
		if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
				GetWitcherPlayer().StopEffect( 'shadowdash_short' );
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				bruxa_regular_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				bruxa_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				bruxa_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				bruxa_left_dodge();
			}
			else
			{
				bruxa_regular_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('yrden_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				two_hand_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				one_hand_sword_front_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				two_hand_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				two_hand_left_dodge();
			}
			else
			{
				two_hand_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				two_hand_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				two_hand_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				one_hand_sword_right_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				one_hand_sword_left_dodge_alt_2();
			}
			else
			{
				two_hand_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				one_hand_sword_back_dodge_alt_1();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				one_hand_sword_right_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				one_hand_sword_left_dodge_alt_1();
			}
			else
			{
				one_hand_sword_back_dodge_alt_1();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				one_hand_sword_back_dodge_alt_2();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				one_hand_sword_front_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				one_hand_sword_right_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				one_hand_sword_left_dodge_alt_2();
			}
			else
			{
				one_hand_sword_back_dodge_alt_2();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				two_hand_sword_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				two_hand_sword_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				two_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				two_hand_sword_left_dodge();
			}
			else
			{
				two_hand_sword_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('axii_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				one_hand_sword_back_dodge();		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				one_hand_sword_front_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				one_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				one_hand_sword_left_dodge();
			}
			else
			{
				one_hand_sword_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('quen_sword_equipped')
		|| GetWitcherPlayer().HasTag('igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
		|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				one_hand_sword_back_dodge();		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				one_hand_sword_front_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				one_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				one_hand_sword_left_dodge();
			}
			else
			{
				one_hand_sword_back_dodge();
			}
		}
		else
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				two_hand_sword_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				two_hand_sword_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				two_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				two_hand_sword_left_dodge();
			}
			else
			{
				two_hand_sword_back_dodge();
			}
		}
	}

	latent function bruxa_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_front_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_front_dodge' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_right_dodge()
	{		
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function two_hand_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( targetDistance <= 3*3 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( targetDistance <= 3*3 ) 
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function two_hand_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function two_hand_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
									
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( targetDistance <= 3*3 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
						}
						else
						{
							GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
						}
					}
				}
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( targetDistance <= 3*3 ) 
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
	}

	latent function two_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_front_dodge()
	{	
		/*
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	
	}

	latent function one_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_left_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
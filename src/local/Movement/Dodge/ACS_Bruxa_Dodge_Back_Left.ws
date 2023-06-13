function ACS_BruxaDodgeBackLeftInit()
{
	var vBruxaDodgeBackLeft : cBruxaDodgeBackLeft;
	vBruxaDodgeBackLeft = new cBruxaDodgeBackLeft in theGame;
	
	if ( ACS_Enabled() && ACS_BruxaDodgeLeft_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('in_wraith')
		&& ACS_BuffCheck()
		)
		{
			if (!GetWitcherPlayer().HasTag('blood_sucking') && GetWitcherPlayer().IsActionAllowed(EIAB_Dodge) )
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();	

						ACS_ThingsThatShouldBeRemoved();

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackLeft.BruxaDodgeBackLeft_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				/*
				else
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();	

						ACS_ThingsThatShouldBeRemoved();

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackLeft.BruxaRegularDodgeLeft_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				*/
			}
			else if ( GetWitcherPlayer().HasTag('blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackLeft.BruxaDodgeBackLeft_HijackLeft();
			}
		}
	}
	else
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);
	}
}

statemachine class cBruxaDodgeBackLeft
{
    function BruxaDodgeBackLeft_Engage()
	{
		this.PushState('BruxaDodgeBackLeft_Engage');
	}

	function BruxaDodgeBackLeft_HijackLeft()
	{
		this.PushState('BruxaDodgeBackLeft_HijackLeft');
	}

	function BruxaRegularDodgeLeft_Engage()
	{
		this.PushState('BruxaRegularDodgeLeft_Engage');
	}
}

state BruxaRegularDodgeLeft_Engage in cBruxaDodgeBackLeft
{
	private var pActor, actor 							: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors, targetActors    				: array<CActor>;
	private var i         								: int;
	private var npc, targetNpc     						: CNewNPC;
	private var teleport_fx								: CEntity;

	event OnEnterState(prevStateName : name)
	{
		bruxa_regular_dodge_Entry();
	}
	
	entry function bruxa_regular_dodge_Entry()
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

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

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
}

state BruxaDodgeBackLeft_HijackLeft in cBruxaDodgeBackLeft
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		HijackLeftEntry();
	}
	
	entry function HijackLeftEntry()
	{
		HijackLeftLatent();	
	}

	latent function HijackLeftLatent()
	{
		actors.Clear();
		
		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
			if( actors.Size() > 0 )
			{	
				npc.ClearAnimationSpeedMultipliers();

				if (npc.IsFlying())
				{
					((CNewNPC)npc).SetUnstoppable(true);

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ul_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_ul', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_ul_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ul_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5)
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dl', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dl_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_l_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_l_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_l_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}
				else
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'walk_left_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}

				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackLeft_Engage in cBruxaDodgeBackLeft
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBackLeft();
	}
	
	entry function BruxaDodgeBackLeft()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_DodgeEffects_Enabled())
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_left();	
	}
	
	latent function dodge_back_left ()
	{	
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_left');
		
		movementAdjustor.CancelByName( 'dodge_back_left' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_left' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 ) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

		movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -2 ) );
		
		//if( actor.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && actor.IsAlive() )
		//{	
			//movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );

			//movementAdjustor.RotateTowards( ticket, actor );
		//}
		//else
		//{
			//movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		//}
		
		//Sleep(1);
		
		//GetWitcherPlayer().SetIsCurrentlyDodging(false);
	}
}
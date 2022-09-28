function ACS_BruxaDodgeBackRightInit()
{
	var vBruxaDodgeBackRight : cBruxaDodgeBackRight;
	vBruxaDodgeBackRight = new cBruxaDodgeBackRight in theGame;
	
	if ( ACS_Enabled() && ACS_BruxaDodgeRight_Enabled() )
	{
		if (!thePlayer.IsCiri()
		&& !thePlayer.IsPerformingFinisher()
		&& !thePlayer.HasTag('in_wraith')
		&& ACS_BuffCheck()
		)
		{
			if (!thePlayer.HasTag('blood_sucking') && thePlayer.IsActionAllowed(EIAB_Dodge) )
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						ACS_ThingsThatShouldBeRemoved();

						thePlayer.ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackRight.BruxaDodgeBackRight_Engage();

						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
				/*
				else
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						ACS_ThingsThatShouldBeRemoved();

						thePlayer.ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackRight.BruxaRegularDodgeRight_Engage();

						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
				*/
			}
			else if ( thePlayer.HasTag('blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackRight.BruxaDodgeBackRight_HijackRight();
			}
		}
	}
	else
	{
		thePlayer.EvadePressed(EBAT_Dodge);
	}
}

statemachine class cBruxaDodgeBackRight
{
    function BruxaDodgeBackRight_Engage()
	{
		this.PushState('BruxaDodgeBackRight_Engage');
	}

	function BruxaDodgeBackRight_HijackRight()
	{
		this.PushState('BruxaDodgeBackRight_HijackRight');
	}

	function BruxaRegularDodgeRight_Engage()
	{
		this.PushState('BruxaRegularDodgeRight_Engage');
	}
}

state BruxaRegularDodgeRight_Engage in cBruxaDodgeBackRight
{
	private var settings, settings_interrupt			: SAnimatedComponentSlotAnimationSettings;
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
		settings.blendIn = 0.25f;
		settings.blendOut = 0.875f;
		
		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		actor = (CActor)( thePlayer.GetTarget() );

		thePlayer.SetSlideTarget ( actor );

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
	}
}

state BruxaDodgeBackRight_HijackRight in cBruxaDodgeBackRight
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		HijackRightEntry();
	}
	
	entry function HijackRightEntry()
	{
		HijackRightLatent();	
	}

	latent function HijackRightLatent()
	{
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
				
			settings.blendIn = 0.2f;
			settings.blendOut = 1.0f;
				
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
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ur_tighter', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_ur', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_up', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_ur_tight', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_up', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ur_tighter', 'NPC_ANIM_SLOT', settings);
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5)
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dr', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dr_tight', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', settings);
						}
					}
					else
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_r_tighter', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_r_tight', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_r_tighter', 'NPC_ANIM_SLOT', settings);
						}
					}
				}
				else
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'walk_right_fast', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
					}
					else
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', settings);
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', settings);
						}
					}
				}
					
				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackRight_Engage in cBruxaDodgeBackRight
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;
	private var settings								: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBackRight();
	}
	
	entry function BruxaDodgeBackRight()
	{
		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.PlayEffectSingle( 'shadowdash_short' );
			thePlayer.StopEffect( 'shadowdash_short' );

			thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
			thePlayer.StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_right();	
	}
	
	latent function dodge_back_right ()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		actor = (CActor)( thePlayer.GetTarget() );
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_right');
		
		movementAdjustor.CancelByName( 'dodge_back_right' );
		
		movementAdjustor.CancelAll();
		
		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_right' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', settings);

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 2 ) );

		/*
		
		if( actor.GetAttitude(thePlayer) == AIA_Hostile && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.25 )  + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );
		}
		
		Sleep(1);
		
		thePlayer.SetIsCurrentlyDodging(false);
		*/
	}
}
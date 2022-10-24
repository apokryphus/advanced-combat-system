function ACS_BruxaDodgeBackCenterInit()
{
	var vBruxaDodgeBackCenter : cBruxaDodgeBackCenter;
	vBruxaDodgeBackCenter = new cBruxaDodgeBackCenter in theGame;
	
	if ( ACS_Enabled() && ACS_BruxaDodgeCenter_Enabled() )
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

						vBruxaDodgeBackCenter.BruxaDodgeBackCenter_Engage();
						
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
						ACS_ThingsThatShouldBeRemoved();

						thePlayer.ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackCenter.BruxaRegularDodgeBack_Engage();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
				*/
			}
			else if ( thePlayer.HasTag('blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackCenter.BruxaDodgeBackCenter_HijackBack();
			}
		}
	}
	else
	{
		thePlayer.EvadePressed(EBAT_Dodge);
	}
}

statemachine class cBruxaDodgeBackCenter
{
    function BruxaDodgeBackCenter_Engage()
	{
		this.PushState('BruxaDodgeBackCenter_Engage');
	}

	function BruxaDodgeBackCenter_HijackBack()
	{
		this.PushState('BruxaDodgeBackCenter_HijackBack');
	}

	function BruxaRegularDodgeBack_Engage()
	{
		this.PushState('BruxaRegularDodgeBack_Engage');
	}
}

state BruxaRegularDodgeBack_Engage in cBruxaDodgeBackCenter
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
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}
}

state BruxaDodgeBackCenter_HijackBack in cBruxaDodgeBackCenter
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;
	private var settings				: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		HijackBackEntry();
	}
	
	entry function HijackBackEntry()
	{
		HijackBackLatent();	
	}

	latent function HijackBackLatent()
	{
		//actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim', true);

		actors.Clear();
		
		theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
				
			settings.blendIn = 0.2f;
			settings.blendOut = 1.0f;
				
			if( actors.Size() > 0 )
			{	
				/*
				((CNewNPC)npc).SetUnstoppable(true);

				npc.RemoveBuffImmunity_AllNegative();

				npc.RemoveBuffImmunity_AllCritical();

				npc.ClearAnimationSpeedMultipliers();
				
				if (npc.HasAbility('mon_gryphon_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_fall_stop', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_siren_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_d', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_knockdown_loop', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_wyvern_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_knockdown_fall', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_harpy_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_d', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_death_fly_high_loop', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_draco_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_knockdown_fall', 'NPC_ANIM_SLOT', settings);
				}	
				else if (npc.HasAbility('mon_basilisk'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', settings);
					animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_fall_stop', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_garkain'))
				{
					animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_up_aoe_attack', 'NPC_ANIM_SLOT', settings);
				}
				else if (npc.HasAbility('mon_sharley_base'))
				{
					animatedComponent.PlaySlotAnimationAsync ( 'roll_back_from_idle_to_idle', 'NPC_ANIM_SLOT', settings);
				}
				
				npc.ClearAnimationSpeedMultipliers();
				*/

				npc.ClearAnimationSpeedMultipliers();

				if (npc.IsFlying())
				{
					((CNewNPC)npc).SetUnstoppable(false);

					if( !npc.HasBuff( EET_HeavyKnockdown ) )
					{
						npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );	
					}
				}
				else
				{
					if (npc.HasAbility('mon_garkain'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_back', 'NPC_ANIM_SLOT', settings);
					}
					else if (npc.HasAbility('mon_sharley_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'roll_back_from_idle_to_idle', 'NPC_ANIM_SLOT', settings);
					}
					else if (npc.HasAbility('mon_bies_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_dodge_b', 'NPC_ANIM_SLOT', settings);
					}
					else if (npc.HasAbility('mon_golem_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_idle_to_walk_r180', 'NPC_ANIM_SLOT', settings);
					}
					else if (
					npc.HasAbility('mon_endriaga_base')
					|| npc.HasAbility('mon_arachas_base')
					|| npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_b', 'NPC_ANIM_SLOT', settings);
					}
					else if (
					npc.HasAbility('mon_ice_giant')
					|| npc.HasAbility('mon_cyclops')
					|| npc.HasAbility('mon_knight_giant')
					|| npc.HasAbility('mon_cloud_giant')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_taunt_2', 'NPC_ANIM_SLOT', settings);
					}
					else if (npc.HasAbility('mon_troll_base'))
					{
						if( RandF() < 0.5 ) 
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_turn_r_180', 'NPC_ANIM_SLOT', settings);
						}
						else
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_turn_l_180', 'NPC_ANIM_SLOT', settings);
						}
					}
				}
				
				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackCenter_Engage in cBruxaDodgeBackCenter
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;
	private var settings								: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBack();
	}
	
	entry function BruxaDodgeBack()
	{
		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.PlayEffectSingle( 'shadowdash_short' );
			thePlayer.StopEffect( 'shadowdash_short' );

			thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
			thePlayer.StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_center();	
	}
	
	latent function dodge_back_center ()
	{
		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_center');
		
		movementAdjustor.CancelByName( 'dodge_back_center' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_center' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 10 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', settings);

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -2 );

		/*
		
		if( actor.GetAttitude(thePlayer) == AIA_Hostile && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.25 );
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.25 );
		}
		
		Sleep(1);
		
		thePlayer.SetIsCurrentlyDodging(false);

		*/
	}
}
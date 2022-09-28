function ACS_WildHuntBlinkInit()
{
	var vWildHuntBlink : cWildHuntBlink;
	vWildHuntBlink = new cWildHuntBlink in theGame;
	
	if ( ACS_Enabled()
	&& !thePlayer.IsCiri()
	&& !thePlayer.IsPerformingFinisher()
	&& !thePlayer.HasTag('in_wraith')
	&& !thePlayer.HasTag('blood_sucking')
	&& ACS_BuffCheck()
	&& thePlayer.IsActionAllowed(EIAB_Roll)
	)
	{
		vWildHuntBlink.WildHuntBlink_Engage();
	}
}

statemachine class cWildHuntBlink
{	
    function WildHuntBlink_Engage()
	{
		this.PushState('WildHuntBlink_Engage');
	}
}
 

state WildHuntBlink_Engage in cWildHuntBlink
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
	private var dodge_counter_roll						: int;
		
	event OnEnterState(prevStateName : name)
	{
		WildHuntBlink();
	}
	
	entry function WildHuntBlink()
	{	
		//settings.blendIn = 0.25f;
		//settings.blendOut = 0.75f;

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

		thePlayer.ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved();
		
		ACS_ExplorationDelayHack();

		DodgePunishment();

		thePlayer.ResetUninterruptedHitsCount();

		thePlayer.SendAttackReactionEvent();

		//GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

		if (thePlayer.HasTag('vampire_claws_equipped')
		|| thePlayer.HasTag('aard_sword_equipped'))
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if (ACS_can_special_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_special_dodge_cooldown();
				
						thePlayer.SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

						bruxa_jump_up();	
						
						thePlayer.DrainStamina(ESAT_Roll);
					}		
				}
				else 
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();
							
							//ACS_Dodge();

							if (!thePlayer.HasTag('ACS_Camo_Active'))
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							GetACSWatcher().dodge_timer_actual();

							bruxa_regular_dodge();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();
						
						//ACS_Dodge();

						if (!thePlayer.HasTag('ACS_Camo_Active'))
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );

							thePlayer.PlayEffectSingle( 'shadowdash_short' );
							thePlayer.StopEffect( 'shadowdash_short' );
						}

						bruxa_front_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();
						
						//ACS_Dodge();

						if (!thePlayer.HasTag('ACS_Camo_Active'))
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						bruxa_right_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();
						
						//ACS_Dodge();

						if (!thePlayer.HasTag('ACS_Camo_Active'))
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						bruxa_left_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();
						
						//ACS_Dodge();

						if (!thePlayer.HasTag('ACS_Camo_Active'))
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						GetACSWatcher().dodge_timer_actual();

						bruxa_regular_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else if (
		thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
			&& !thePlayer.HasTag('blood_sucking')
			)
			{
				ACS_Weapon_Respawn();

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if ( ACS_WildHuntBlink_Enabled() )
				{
					if (ACS_can_special_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_special_dodge_cooldown();
							
							wild_hunt_blink();	

							thePlayer.DrainStamina(ESAT_Roll);	
						}
					}
					else
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								two_hand_back_dodge();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
				}
				else
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();

							if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							two_hand_back_dodge();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							front_dodge_skate();
						}
						else
						{
							one_hand_sword_front_dodge_alt_1();
						}	
			
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							right_dodge_skate();
						}
						else
						{
							two_hand_right_dodge_alt();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							left_dodge_skate();
						}
						else
						{
							two_hand_left_dodge_alt();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						two_hand_back_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else if (
		thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
			&& !thePlayer.HasTag('blood_sucking')
			)
			{
				ACS_Weapon_Respawn();

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if ( ACS_WildHuntBlink_Enabled() )
				{
					if (ACS_can_special_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_special_dodge_cooldown();
							
							wild_hunt_blink();	

							thePlayer.DrainStamina(ESAT_Roll);	
						}
					}
					else
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								two_hand_back_dodge();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
				}
				else
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();

							if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							two_hand_back_dodge();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							front_dodge_skate();
						}
						else
						{
							two_hand_front_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							right_dodge_skate();
						}
						else
						{
							two_hand_right_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							left_dodge_skate();
						}
						else
						{
							two_hand_left_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						two_hand_back_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else if (
		thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
			&& !thePlayer.HasTag('blood_sucking')
			)
			{
				ACS_Weapon_Respawn();

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if ( ACS_WildHuntBlink_Enabled() )
				{
					if (ACS_can_special_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_special_dodge_cooldown();
							
							wild_hunt_blink();	

							thePlayer.DrainStamina(ESAT_Roll);	
						}
					}
					else
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								two_hand_sword_back_dodge();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
				}
				else
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();

							if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							two_hand_sword_back_dodge();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							front_dodge_skate();
						}
						else
						{
							one_hand_sword_front_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							right_dodge_skate();
						}
						else
						{
							two_hand_sword_right_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							left_dodge_skate();
						}
						else
						{
							two_hand_sword_left_dodge();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						two_hand_sword_back_dodge();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else if (
		thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
			&& !thePlayer.HasTag('blood_sucking')
			)
			{
				ACS_Weapon_Respawn();

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if ( ACS_WildHuntBlink_Enabled() )
				{
					if (ACS_can_special_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_special_dodge_cooldown();
							
							wild_hunt_blink();	

							thePlayer.DrainStamina(ESAT_Roll);	
						}
					}
					else
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								one_hand_sword_back_dodge_alt_1();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
				}
				else
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();

							if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							one_hand_sword_back_dodge_alt_1();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							front_dodge_skate();
						}
						else
						{
							one_hand_sword_front_dodge_alt_1();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							right_dodge_skate();
						}
						else
						{
							one_hand_sword_right_dodge_alt_2();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							left_dodge_skate();
						}
						else
						{
							one_hand_sword_left_dodge_alt_2();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						one_hand_sword_back_dodge_alt_1();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else if (
		thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
			&& !thePlayer.HasTag('blood_sucking')
			)
			{
				ACS_Weapon_Respawn();

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

				thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if ( ACS_WildHuntBlink_Enabled() )
				{
					if (ACS_can_special_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_special_dodge_cooldown();
							
							wild_hunt_blink();	

							thePlayer.DrainStamina(ESAT_Roll);	
						}
					}
					else
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								one_hand_sword_back_dodge_alt_2();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
				}
				else
				{
					if (ACS_can_dodge())
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' );
							thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							ACS_refresh_dodge_cooldown();

							if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
							{
								thePlayer.PlayEffectSingle( 'magic_step_l_new' );
								thePlayer.StopEffect( 'magic_step_l_new' );	

								thePlayer.PlayEffectSingle( 'magic_step_r_new' );
								thePlayer.StopEffect( 'magic_step_r_new' );	

								thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
								thePlayer.StopEffect( 'bruxa_dash_trails' );
							}

							one_hand_sword_back_dodge_alt_2();
							
							thePlayer.DrainStamina(ESAT_Dodge);
						}
					}
				}		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							front_dodge_skate();
						}
						else
						{
							one_hand_sword_front_dodge_alt_2();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							right_dodge_skate();
						}
						else
						{
							one_hand_sword_right_dodge_alt_2();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						if ( thePlayer.IsGuarded() ) 
						{
							left_dodge_skate();
						}
						else
						{
							one_hand_sword_left_dodge_alt_2();
						}
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
			else
			{
				if (ACS_can_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
						{
							thePlayer.PlayEffectSingle( 'magic_step_l_new' );
							thePlayer.StopEffect( 'magic_step_l_new' );	

							thePlayer.PlayEffectSingle( 'magic_step_r_new' );
							thePlayer.StopEffect( 'magic_step_r_new' );	

							thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
							thePlayer.StopEffect( 'bruxa_dash_trails' );
						}

						one_hand_sword_back_dodge_alt_2();
						
						thePlayer.DrainStamina(ESAT_Dodge);
					}
				}
			}
		}
		else
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 
			&& ACS_WildHuntBlink_Enabled())
			{
				if (ACS_can_special_dodge())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						thePlayer.RaiseEvent( 'CombatTaunt' );
						thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_special_dodge_cooldown();
						
						wild_hunt_blink();	

						thePlayer.DrainStamina(ESAT_Roll);	
					}
				}
				else
				{
					GetACSWatcher().dodge_timer_attack_actual();

					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

					Sleep(0.125);

					thePlayer.EvadePressed(EBAT_Roll);	
				}
			}
			else
			{
				if ( thePlayer.IsGuarded() ) 
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								front_dodge_skate();
								
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								right_dodge_skate();
		
								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								thePlayer.RaiseEvent( 'CombatTaunt' );
								thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									thePlayer.PlayEffectSingle( 'magic_step_l_new' );
									thePlayer.StopEffect( 'magic_step_l_new' );	

									thePlayer.PlayEffectSingle( 'magic_step_r_new' );
									thePlayer.StopEffect( 'magic_step_r_new' );	

									thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
									thePlayer.StopEffect( 'bruxa_dash_trails' );
								}

								left_dodge_skate();

								thePlayer.DrainStamina(ESAT_Dodge);
							}
						}
					}
					else
					{
						if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
						&& !thePlayer.HasTag('blood_sucking')
						)
						{
							ACS_Weapon_Respawn();

							thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

							thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
						}

						GetACSWatcher().dodge_timer_attack_actual();

						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

						Sleep(0.125);
						
						thePlayer.EvadePressed(EBAT_Roll);	
					}
				}
				else
				{
					if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
					&& !thePlayer.HasTag('blood_sucking')
					)
					{
						ACS_Weapon_Respawn();

						thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

						thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
					}

					GetACSWatcher().dodge_timer_attack_actual();

					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

					Sleep(0.125);
					
					thePlayer.EvadePressed(EBAT_Roll);	
				}	
			}
		}
	}

	latent function DodgePunishment()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 3.5, 50, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

				npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
					
				npc.ForceSetStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) + npc.GetStatMax( BCS_Stamina ) * 0.1 );
			}
		}
	}
	
	latent function wild_hunt_blink ()
	{	
		GetACSWatcher().Shrink_Geralt(0.25);

		theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		thePlayer.AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		actor = (CActor)( thePlayer.GetTarget() );		

		thePlayer.SetSlideTarget ( actor );
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		
		if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
    	{
        	theSound.SoundLoadBank( "magic_caranthil.bnk", false );
    	}
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.StopAllEffects();
				
				thePlayer.StopEffect( 'ice_armor' );
				thePlayer.PlayEffectSingle( 'ice_armor' );
			}

			movementAdjustor.RotateTowards( ticket, actor );

			thePlayer.SetIsCurrentlyDodging(true);
						
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'blink_start_back_ready_ACS', 'PLAYER_SLOT', settings);
			
			thePlayer.SoundEvent("magic_canaris_teleport_short");

			theGame.GetGameCamera().PlayEffectSingle( 'frost' );

			thePlayer.AddTag('ACS_wildhunt_teleport_init');
			
			ACS_wh_teleport_entity().Destroy();
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), EulerAngles(0,0,0) );
			//teleport_fx.CreateAttachment(thePlayer);
			teleport_fx.AddTag('wh_teleportfx');
			teleport_fx.PlayEffectSingle('disappear');
			
			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 1.f, 15, 2.f, 25.f, 0);

			//Sleep ( 0.45 / thePlayer.GetAnimationTimeMultiplier() );
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / thePlayer.GetAnimationTimeMultiplier() , false);
			
			/*
			movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor.CancelAll();

			thePlayer.ActionCancelAll();

			thePlayer.GetMovingAgentComponent().ResetMoveRequests();

			thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

			thePlayer.ResetRawPlayerHeading();

			ticket = movementAdjustor.CreateNewRequest( 'wh_blink' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.RotateTowards( ticket, actor );
			movementAdjustor.SlideTo(ticket, pos);
			*/
			
			actors = GetActorsInRange(thePlayer, 55, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), npc.GetWorldPosition() ) ;
				
				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && npc.IsAlive() )
					{
						if( targetDistance <= 2*2 ) 
						{
							npc.AddEffectDefault( EET_Frozen, npc, 'console' );
						}
					}
				}
			}
		}
	}

	latent function bruxa_jump_up()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		actor = (CActor)( thePlayer.GetTarget() );		

		thePlayer.SetSlideTarget ( actor );
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			thePlayer.SetIsCurrentlyDodging(true);
						
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_start_ACS', 'PLAYER_SLOT', settings);

			rot = thePlayer.GetWorldRotation();

			pos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() * 1.3;

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

				, true ), pos, rot );

			ent.CreateAttachment( thePlayer, , Vector( 0, 0, 0 ), EulerAngles( 0, 90, 0 ) );

			ent.PlayEffectSingle('swarm_attack');

			ent.DestroyAfter(2);

			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'magic_step_l_new' );
				thePlayer.StopEffect( 'magic_step_l_new' );	

				thePlayer.PlayEffectSingle( 'magic_step_r_new' );
				thePlayer.StopEffect( 'magic_step_r_new' );	

				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );

				thePlayer.PlayEffectSingle( 'shadowdash' );
			}

			thePlayer.AddTag('ACS_Bruxa_Jump_Init');
			
			//Sleep ( 0.5  / thePlayer.GetAnimationTimeMultiplier() );
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.65  , false);
			
			//movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
			//movementAdjustor.CancelAll();

			//thePlayer.ActionCancelAll();

			//thePlayer.GetMovingAgentComponent().ResetMoveRequests();

			//thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

			//thePlayer.ResetRawPlayerHeading();

			//ticket = movementAdjustor.CreateNewRequest( 'acs_bruxa_jump_up' );
			//movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			//movementAdjustor.RotateTowards( ticket, actor );
			//movementAdjustor.SlideTo(ticket, pos);
			
			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			GetACSWatcher().dodge_timer_actual();

			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
	}

	latent function bruxa_front_dodge()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'bruxa_front_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			//movementAdjustor.RotateTowards( ticket, actor );
					
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
				
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 2 ) + theCamera.GetCameraDirection() * 2 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
				
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 2 ) + theCamera.GetCameraDirection() * 2 );		
		}
	}

	latent function bruxa_right_dodge()
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
					
			GetACSWatcher().dodge_timer_actual();
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
	}

	latent function bruxa_left_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	latent function bruxa_regular_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_back_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}
	}

	latent function two_hand_front_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				if( targetDistance <= 3*3 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', settings);	
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', settings);	
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', settings);	
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
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', settings);	
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', settings);	
					}
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_rp_f_01', 'PLAYER_SLOT', settings);	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', settings);
		}
	}

	latent function two_hand_right_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}
		else
		{				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);
		}
		*/
	}

	latent function two_hand_left_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}
		else
		{				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
		
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);
		}
		*/
	}

	latent function two_hand_right_dodge_alt()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);
		}
		*/
	}

	latent function two_hand_left_dodge_alt()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
		
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', settings);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);
		}
		*/
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', settings);	
			}
			else
			{
				/*
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', settings);
				}
				*/

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{				
			/*
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', settings);
			}
			*/
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', settings);
		}
	}

	latent function two_hand_sword_left_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', settings);
	}

	latent function two_hand_sword_right_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'two_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', settings);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}

	latent function one_hand_sword_front_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', settings);
		}

		/*
		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

		Sleep(0.125);

		thePlayer.EvadePressed(EBAT_Dodge);	

		*/
	}

	latent function one_hand_sword_left_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}

	latent function one_hand_sword_right_dodge()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_1()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', settings);
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_front_dodge_alt_1()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', settings);	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg_lp', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_180deg', 'PLAYER_SLOT', settings);	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_left_dodge_alt_1()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', settings);
			}
		}
	}

	latent function one_hand_sword_right_dodge_alt_1()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', settings);
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_2()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', settings);
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_front_dodge_alt_2()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
		
		if (!thePlayer.HasTag('ACS_Camo_Active')
		&& !thePlayer.HasTag('blood_sucking'))
		{
			thePlayer.PlayEffectSingle( 'bruxa_dash_trails_backup' );
			thePlayer.StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.75 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', settings);	
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', settings);	
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', settings);
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', settings);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', settings);
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_front_dodge_alt_3()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}

		if (!thePlayer.HasTag('ACS_Camo_Active')
		&& !thePlayer.HasTag('blood_sucking'))
		{
			thePlayer.PlayEffectSingle( 'bruxa_dash_trails_backup' );
			thePlayer.StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.5 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', settings);	
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', settings);	
		}
	}

	latent function one_hand_sword_left_dodge_alt_3()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', settings);
	}

	latent function one_hand_sword_right_dodge_alt_3()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', settings);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function front_dodge_skate()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (thePlayer.IsEnemyInCone( actor, thePlayer.GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 2.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 2.5 );
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 2.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 2.5 );
		}
		
		if (!thePlayer.HasTag('ACS_Camo_Active')
		&& !thePlayer.HasTag('blood_sucking'))
		{
			thePlayer.PlayEffectSingle( 'bruxa_dash_trails_backup' );
			thePlayer.StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.5 ) 
		{
			if( RandF() < 0.75 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l_ACS', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r_ACS', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{
			if( RandF() < 0.75 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_02_loop_l_ACS', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_02_loop_r_ACS', 'PLAYER_SLOT', settings);	
			}
		}
	}

	latent function left_dodge_skate()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if (!thePlayer.HasTag('ACS_Camo_Active')
		&& !thePlayer.HasTag('blood_sucking'))
		{
			thePlayer.PlayEffectSingle( 'bruxa_dash_trails_backup' );
			thePlayer.StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.75 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l_turn_l_ACS', 'PLAYER_SLOT', settings);	
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r_turn_l_ACS', 'PLAYER_SLOT', settings);	
		}
	}

	latent function right_dodge_skate()
	{	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if (!thePlayer.HasTag('ACS_Camo_Active')
		&& !thePlayer.HasTag('blood_sucking'))
		{
			thePlayer.PlayEffectSingle( 'bruxa_dash_trails_backup' );
			thePlayer.StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.75 ) 
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l_turn_r_ACS', 'PLAYER_SLOT', settings);	
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r_turn_r_ACS', 'PLAYER_SLOT', settings);	
		}
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Blink_Hit_Reaction()
{
	var vACS_BlinkHitReaction : cACS_BlinkHitReaction;
	vACS_BlinkHitReaction = new cACS_BlinkHitReaction in theGame;
	
	vACS_BlinkHitReaction.BlinkHitReaction_Engage();
}

statemachine class cACS_BlinkHitReaction
{	
    function BlinkHitReaction_Engage()
	{
		this.PushState('BlinkHitReaction_Engage');
	}
}
 

state BlinkHitReaction_Engage in cACS_BlinkHitReaction
{
	private var settings, settings_interrupt			: SAnimatedComponentSlotAnimationSettings;
	private var actor 									: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors    								: array<CActor>;
	private var i         								: int;
	private var npc     								: CNewNPC;
	private var teleport_fx								: CEntity;
		
	event OnEnterState(prevStateName : name)
	{
		BlinkHitReaction_Entry();
	}
	
	entry function BlinkHitReaction_Entry()
	{		
		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;
		
		if (!thePlayer.IsCiri()
		&& !thePlayer.IsPerformingFinisher()
		&& !thePlayer.HasTag('in_wraith')
		&& !thePlayer.HasTag('blood_sucking')
		)
		{
			GetACSWatcher().Shrink_Geralt(0.25);
			BlinkHitReaction_Latent();
		}
	}
	
	latent function BlinkHitReaction_Latent ()
	{		
		//settings.blendIn = 0.3f;
		//settings.blendOut = 0.3f;

		settings.blendIn = 0.25f;
		settings.blendOut = 0.875f;
		
		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;
		
		actor = (CActor)( thePlayer.GetTarget() );		

		thePlayer.SetSlideTarget ( actor );
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 1.25;
		
		if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
    	{
        	theSound.SoundLoadBank( "magic_caranthil.bnk", false );
    	}
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.StopAllEffects();
				
				thePlayer.StopEffect( 'ice_armor' );
				thePlayer.PlayEffectSingle( 'ice_armor' );
			}

			movementAdjustor.RotateTowards( ticket, actor );

			thePlayer.SetIsCurrentlyDodging(true);
						
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'blink_start_back_ready_ACS', 'PLAYER_SLOT', settings);
			
			thePlayer.SoundEvent("magic_canaris_teleport_short");

			theGame.GetGameCamera().PlayEffectSingle( 'frost' );

			thePlayer.AddTag('ACS_wildhunt_teleport_init');
			
			ACS_wh_teleport_entity().Destroy();
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), EulerAngles(0,0,0) );
			//teleport_fx.CreateAttachment(thePlayer);
			teleport_fx.AddTag('wh_teleportfx');
			teleport_fx.PlayEffectSingle('disappear');
			
			
			//Sleep ( 0.45 / thePlayer.GetAnimationTimeMultiplier() );
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / thePlayer.GetAnimationTimeMultiplier() , false);
			
			/*
			movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor.CancelAll();

			thePlayer.ActionCancelAll();

			thePlayer.GetMovingAgentComponent().ResetMoveRequests();

			thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

			thePlayer.ResetRawPlayerHeading();

			ticket = movementAdjustor.CreateNewRequest( 'wh_blink' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.RotateTowards( ticket, actor );
			movementAdjustor.SlideTo(ticket, pos);
			*/
		}
	}
}

function ACS_wh_teleport_entity() : CEntity
{
	var teleport_fx 			 : CEntity;
	
	teleport_fx = (CEntity)theGame.GetEntityByTag( 'wh_teleportfx' );
	return teleport_fx;
}
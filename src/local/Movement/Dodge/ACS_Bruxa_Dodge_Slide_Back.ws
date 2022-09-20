function ACS_BruxaDodgeSlideBackInit()
{
	var vBruxaDodgeSlideBack : cBruxaDodgeSlideBack;
	vBruxaDodgeSlideBack = new cBruxaDodgeSlideBack in theGame;
	
	if ( ACS_Enabled() )
	{
		if (!thePlayer.IsCiri()
		&& !thePlayer.IsPerformingFinisher()
		&& !thePlayer.HasTag('in_wraith')
		&& !thePlayer.HasTag('blood_sucking')
		&& ACS_BuffCheck()
		&& thePlayer.IsActionAllowed(EIAB_Dodge)
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
	private var settings, settings_interrupt					: SAnimatedComponentSlotAnimationSettings;
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

		if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
		{
			theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
		}
		
		if (
		thePlayer.HasTag('vampire_claws_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if (ACS_can_special_dodge()
				&& ACS_BruxaDodgeSlideBack_Enabled())
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

						bruxa_slide_back();	
						
						thePlayer.DrainStamina(ESAT_Roll);
					}		
				}
				else if (ACS_can_dodge())
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
				if ( ACS_BruxaDodgeRight_Enabled() )
				{
					ACS_BruxaDodgeBackRightInit();
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
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5) 
			{
				if ( ACS_BruxaDodgeLeft_Enabled() )
				{
					ACS_BruxaDodgeBackLeftInit();
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
		thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				if (ACS_can_special_dodge()
				&& ACS_BruxaDodgeSlideBack_Enabled())
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

						bruxa_slide_back();	
						
						thePlayer.DrainStamina(ESAT_Roll);
					}		
				}
				else if (ACS_can_dodge())
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						one_hand_sword_front_dodge_alt_1();
						
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

						two_hand_right_dodge();
						
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

						two_hand_left_dodge();
						
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						two_hand_front_dodge();
						
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

						one_hand_sword_right_dodge_alt_2();
						
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

						one_hand_sword_left_dodge_alt_2();
						
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						one_hand_sword_front_dodge();
						
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

						two_hand_sword_right_dodge();
						
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

						two_hand_sword_left_dodge();
						
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
		thePlayer.HasTag('axii_sword_equipped')
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						one_hand_sword_front_dodge_alt_3();
						
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

						one_hand_sword_right_dodge_alt_1();
						
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

						one_hand_sword_left_dodge_alt_1();
						
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

						one_hand_sword_back_dodge();
						
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						one_hand_sword_front_dodge_alt_1();
						
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

						one_hand_sword_right_dodge_alt_2();
						
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

						one_hand_sword_left_dodge_alt_2();
						
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
				if (ACS_BruxaDodgeSlideBack_Enabled())
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

							olgierd_slide_back_2();	
							
							thePlayer.DrainStamina(ESAT_Roll);
						}
						
					}
					else if (ACS_can_dodge())
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

						one_hand_sword_front_dodge_alt_2();
						
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

						one_hand_sword_right_dodge_alt_2();
						
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

						one_hand_sword_left_dodge_alt_2();
						
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
		else if (
		thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
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
				
						olgierd_slide_back();	
						
						thePlayer.DrainStamina(ESAT_Roll);
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

					thePlayer.EvadePressed(EBAT_Dodge);	
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

						one_hand_sword_front_dodge();
						
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

						one_hand_sword_right_dodge_alt_3();
						
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

						one_hand_sword_left_dodge_alt_3();
						
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
			&& ACS_BruxaDodgeSlideBack_Enabled())
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

						olgierd_slide_back_2();	
						
						thePlayer.DrainStamina(ESAT_Roll);
					}
					
				}
				else if (ACS_can_dodge())
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

						thePlayer.EvadePressed(EBAT_Dodge);	
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

				thePlayer.EvadePressed(EBAT_Dodge);	
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
	
	latent function bruxa_slide_back()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_slide_back');
		
		movementAdjustor.CancelByName( 'bruxa_slide_back' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_slide_back' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
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

					if (!thePlayer.HasTag('ACS_Camo_Active'))
					{
						thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
						thePlayer.StopEffect( 'bruxa_dash_trails' );
					}

					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
					
					movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * -2 );
				}
			}
			else
			{
				if (!thePlayer.HasTag('ACS_Camo_Active'))
				{
					thePlayer.PlayEffectSingle( 'special_attack_only_black_fx' );
					thePlayer.StopEffect( 'special_attack_only_black_fx' );

					thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
					thePlayer.StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_slideback_actual();

				thePlayer.ClearAnimationSpeedMultipliers();
			
				if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 2  ); }	
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', settings);	
				
				movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.25 );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'special_attack_only_black_fx' );
				thePlayer.StopEffect( 'special_attack_only_black_fx' );

				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_slideback_actual();

			thePlayer.ClearAnimationSpeedMultipliers();
			
			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 2  ); }	
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', settings);	
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.75 );
		}

		//Sleep(1);
		
		//thePlayer.SetIsCurrentlyDodging(false);
	}

	latent function olgierd_slide_back()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if( targetDistance <= 2*2 ) 
			{
				GetACSWatcher().dodge_timer_attack_actual();

				if (!thePlayer.HasTag('ACS_Camo_Active'))
				{
					thePlayer.PlayEffectSingle('special_attack_fx');
					thePlayer.StopEffect('special_attack_fx');

					thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
					thePlayer.StopEffect( 'bruxa_dash_trails' );
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', settings);
				
				//movementAdjustor.SlideTo( ticket, (thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -1.1) + theCamera.GetCameraDirection() * -1.1 );
			}
			else
			{
				if (!thePlayer.HasTag('ACS_Camo_Active'))
				{
					thePlayer.PlayEffectSingle('special_attack_fx');
					thePlayer.StopEffect('special_attack_fx');

					thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
					thePlayer.StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_attack_actual();

				thePlayer.ClearAnimationSpeedMultipliers();
			
				if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', settings);
				
				movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) + theCamera.GetCameraDirection() * -2 );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle('special_attack_fx');
				thePlayer.StopEffect('special_attack_fx');

				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			thePlayer.ClearAnimationSpeedMultipliers();
			
			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) + theCamera.GetCameraDirection() * -2 );
		}

		//Sleep(1);
		
		//thePlayer.SetIsCurrentlyDodging(false);
	}

	latent function olgierd_slide_back_2()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back_2');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();

		thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		thePlayer.ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			thePlayer.ClearAnimationSpeedMultipliers();
		
			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.5  ); }
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) + theCamera.GetCameraDirection() * -2 );		
		}
		else
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
				thePlayer.StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			thePlayer.ClearAnimationSpeedMultipliers();
			
			if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', settings);
			
			movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -2 ) + theCamera.GetCameraDirection() * -2 );
		}

		//Sleep(1);
		
		//thePlayer.SetIsCurrentlyDodging(false);
	}

	latent function bruxa_front_dodge()
	{	
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
			//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//movementAdjustor.RotateTowards( ticket, actor );
					
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);
			
			//movementAdjustor.SlideTo( ticket, ( thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		
		}
	}

	latent function bruxa_right_dodge()
	{		
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
			
		/*
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
		*/

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
	}

	latent function two_hand_left_dodge()
	{	
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
		
		/*
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
		*/

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{	
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
		/*	
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
		*/

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

		Sleep(0.125);

		thePlayer.EvadePressed(EBAT_Dodge);	
	}

	latent function two_hand_sword_left_dodge()
	{	
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
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

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', settings);	
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
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{	
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_3' );
		
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

				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', settings);	
				}
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
				
			if( RandF() < 0.5 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', settings);	
			}
		}
	}

	latent function one_hand_sword_left_dodge_alt_3()
	{	
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
		if (!thePlayer.IsCiri()
		&& !thePlayer.IsPerformingFinisher()
		&& !thePlayer.HasTag('in_wraith')
		&& !thePlayer.HasTag('blood_sucking')
		&& ACS_BuffCheck()
		&& thePlayer.IsActionAllowed(EIAB_Dodge)
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
	private var settings, settings_interrupt					: SAnimatedComponentSlotAnimationSettings;
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
		//settings.blendIn = 0.3f;
		//settings.blendOut = 0.3f;

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

		thePlayer.ClearAnimationSpeedMultipliers();	

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Dodge_On_Change_Beh_Movement_Adjust' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );

		movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTowards( ticket, actor );
		}

		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.PlayEffectSingle( 'magic_step_l_new' );
			thePlayer.StopEffect( 'magic_step_l_new' );	

			thePlayer.PlayEffectSingle( 'magic_step_r_new' );
			thePlayer.StopEffect( 'magic_step_r_new' );	

			thePlayer.PlayEffectSingle( 'bruxa_dash_trails' );
			thePlayer.StopEffect( 'bruxa_dash_trails' );
		}
		
		if (thePlayer.HasTag('aard_sword_equipped'))
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.PlayEffectSingle( 'shadowdash_short' );
				thePlayer.StopEffect( 'shadowdash_short' );
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
		thePlayer.HasTag('yrden_sword_equipped')
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
		thePlayer.HasTag('yrden_secondary_sword_equipped')
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
		thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
			{
				one_hand_sword_back_dodge_alt_1();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
			{
				one_hand_sword_front_dodge_alt_1();
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
		thePlayer.HasTag('aard_secondary_sword_equipped')
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
		thePlayer.HasTag('axii_secondary_sword_equipped')
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
		thePlayer.HasTag('axii_sword_equipped')
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

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', settings);
		}
	}

	latent function bruxa_right_dodge()
	{		
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

	latent function bruxa_left_dodge()
	{	
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
					
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
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
					
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
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

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	

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
		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		thePlayer.ClearAnimationSpeedMultipliers();	
		
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

		thePlayer.ClearAnimationSpeedMultipliers();	

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		/*
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
		*/

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
	}

	latent function two_hand_left_dodge()
	{	
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

		thePlayer.ClearAnimationSpeedMultipliers();	

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', settings);	
		
		/*
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
		*/

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{	
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

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', settings);	
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
			}
		}
		else
		{				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', settings);	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		thePlayer.ClearAnimationSpeedMultipliers();	
									
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
						if( RandF() < 0.5 ) 
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', settings);	
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', settings);	
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', settings);	
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', settings);	
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
				
			if( RandF() < 0.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', settings);	
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', settings);	
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', settings);	
				}
			}
		}
	}

	latent function two_hand_sword_left_dodge()
	{	
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

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', settings);
	}

	latent function two_hand_sword_right_dodge()
	{	
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

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		thePlayer.ClearAnimationSpeedMultipliers();	

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', settings);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{	
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
		/*
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
		*/

		GetACSWatcher().dodge_timer_attack_actual();

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

		Sleep(0.125);

		thePlayer.EvadePressed(EBAT_Dodge);	
	}

	latent function one_hand_sword_left_dodge()
	{	
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
			if( targetDistance <= 3*3 ) 
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
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', settings);
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
			if( targetDistance <= 3*3 ) 
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
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', settings);
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		thePlayer.ActionCancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
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

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', settings);	
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
				
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', settings);
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{	
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

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', settings);
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{	
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

		thePlayer.ClearAnimationSpeedMultipliers();	
								
		//if (thePlayer.IsGuarded() || thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15){thePlayer.SetAnimationSpeedMultiplier( 1  ); }else{thePlayer.SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', settings);
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
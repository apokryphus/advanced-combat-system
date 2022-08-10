function ACS_PrimaryWeaponSwitch()
{
	var vPrimaryWeaponSwitch : cPrimaryWeaponSwitch;
	vPrimaryWeaponSwitch = new cPrimaryWeaponSwitch in theGame;
	
	if (ACS_Enabled())
	{	
		vPrimaryWeaponSwitch.Primary_Weapon_Switch_Engage();
	}
}

statemachine class cPrimaryWeaponSwitch
{
    function Primary_Weapon_Switch_Engage()
	{
		this.PushState('Primary_Weapon_Switch_Engage');
	}
}
 
state Primary_Weapon_Switch_Engage in cPrimaryWeaponSwitch
{
	private var steelID, silverID 																																																																																				: SItemUniqueId;
	private var steelsword, silversword																																																																																			: CDrawableComponent;
	private var attach_vec, bone_vec																																																																																			: Vector;
	private var attach_rot, bone_rot																																																																																			: EulerAngles;
	private var anchor_temp, blade_temp, claw_temp, extra_arms_temp_r, extra_arms_temp_l, extra_arms_anchor_temp, head_temp, back_claw_temp 																																																									: CEntityTemplate;
	private var r_blade1, r_blade2, r_blade3, r_blade4, l_blade1, l_blade2, l_blade3, l_blade4, r_anchor, l_anchor, sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8, blade_temp_ent, extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var p_actor 																																																																																						: CActor;
	private var p_comp, meshcompHead																																																																																			: CComponent;
	private var weapontype 																																																																																						: EPlayerWeapon;
	private var item 																																																																																							: SItemUniqueId;
	private var res 																																																																																							: bool;
	private var inv 																																																																																							: CInventoryComponent;
	private var tags 																																																																																							: array<name>;
	private var settings																																																																																						: SAnimatedComponentSlotAnimationSettings;
	private var animatedComponent_extra_arms 																																																																																	: CAnimatedComponent;
	private var stupidArray_extra_arms 																																																																																			: array< name >;
	private var h 																																																																																								: float;
	private var d_comp																																																																																							: array<CComponent>;							
	private var i, manual_sword_check																																																																																			: int;								
	private var watcher																																																																																							: W3ACSWatcher;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		PrimaryWeaponSwitch();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
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
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('vampire_claws_equipped') && thePlayer.IsInCombat() )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype ); ACS_Theft_Prevention_9 ();
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	entry function PrimaryWeaponSwitch()
	{
		settings.blendIn = 1;
		settings.blendOut = 1;

		if ( ACS_GetWeaponMode() == 0 )
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
				&& (thePlayer.IsWeaponHeld( 'silversword' ) 
				|| thePlayer.IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
				{
					if (!thePlayer.HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
					}
				}
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
				&& (thePlayer.IsWeaponHeld( 'silversword' ) 
				|| thePlayer.IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
				{
					if (!thePlayer.HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
					}
				}
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
				&& (thePlayer.IsWeaponHeld( 'silversword' ) 
				|| thePlayer.IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
				{
					if (!thePlayer.HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
					}
				}
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
				&& (thePlayer.IsWeaponHeld( 'silversword' ) 
				|| thePlayer.IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
				{
					if (!thePlayer.HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
					}
				}
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
				&& (thePlayer.IsWeaponHeld( 'silversword' ) 
				|| thePlayer.IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
				{
					if (!thePlayer.HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword(); ACS_Theft_Prevention_9 ();

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();		
					}
				}
			}	
			else if 
			(
				thePlayer.IsWeaponHeld( 'fist' )
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !thePlayer.HasTag('vampire_claws_equipped') )
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_sword_equipped')
			)
			{
				IgniSword();

				IgniSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_sword_equipped')
			)
			{
				FocusModeAxiiSword();

				AxiiSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_sword_equipped')
			)
			{
				FocusModeAardSword();

				AardSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_sword_equipped')
			)
			{
				FocusModeYrdenSword();

				YrdenSwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_sword_equipped')
			)
			{
				FocusModeQuenSword();

				QuenSwordSwitch();
			}
			
			else if 
			(
				thePlayer.IsWeaponHeld( 'fist' ) 
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !thePlayer.HasTag('vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 2)
		{
			if 
			(
				thePlayer.HasTag('HybridDefaultWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('igni_sword_equipped') )
				{
					IgniSword();

					IgniSwordSwitch();
				}	

				HybridTagRemoval();
			}
			
			else if  
			(
				thePlayer.HasTag('HybridEredinWeaponTicket') 
			)
			{
				if (!thePlayer.HasTag('axii_sword_equipped') )
				{
					HybridModeAxiiSword();

					AxiiSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if  
			(
				thePlayer.HasTag('HybridClawWeaponTicket') 
			)
			{
				if (!thePlayer.HasTag('aard_sword_equipped') )
				{
					HybridModeAardSword();

					AardSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if  
			(
				thePlayer.HasTag('HybridImlerithWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('yrden_sword_equipped') )
				{
					HybridModeYrdenSword();

					YrdenSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.HasTag('HybridOlgierdWeaponTicket') 
			)
			{
				if (!thePlayer.HasTag('quen_sword_equipped') )
				{
					HybridModeQuenSword();

					QuenSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.IsWeaponHeld( 'fist' )
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !thePlayer.HasTag('vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 3)
		{	
			if 
			(
				ACS_GetItem_Eredin_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_sword_equipped') 
				|| ACS_GetItem_Eredin_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('axii_sword_equipped');

				AxiiSwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Claws_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_sword_equipped') 
				|| ACS_GetItem_Claws_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_sword_equipped')
			)
			{
				EquipmentModeAardSword();

				AardSwordSwitch();

				//Sleep(0.125);

				WeaponSummonEffect();
			}
			
			else if 
			(
				ACS_GetItem_Imlerith_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_sword_equipped') 
				|| ACS_GetItem_Imlerith_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('yrden_sword_equipped');

				YrdenSwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Olgierd_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_sword_equipped') 
				|| ACS_GetItem_Olgierd_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('quen_sword_equipped');

				QuenSwordSwitch();
			}
			else if 
			(
				ACS_GetItem_Katana_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
				|| ACS_GetItem_Katana_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
			)
			{
				ACS_SecondaryWeaponSwitch();
			}

			else if 
			(
				ACS_GetItem_VampClaw_Shades() && thePlayer.IsWeaponHeld( 'fist' ) && !thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				//thePlayer.AddTag('vampire_claws_equipped');

				VampireClaws();

				VampireClawsSwitch();
			}

			else if 
			(
				ACS_GetItem_VampClaw() && thePlayer.IsWeaponHeld( 'fist' ) && !thePlayer.HasTag('vampire_claws_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				VampireClaws();

				VampireClawsSwitch();
			}
		}
	}

	latent function WeaponSummonEffect()
	{
		thePlayer.RemoveTimer('ACS_Weapon_Summon_Delay');
		
		if (thePlayer.HasTag('igni_sword_equipped')
		&& !thePlayer.HasTag('igni_sword_effect_played'))
		{
			igni_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('igni_sword_effect_played');
			thePlayer.AddTag('igni_secondary_sword_effect_played');
		}
		else if (thePlayer.HasTag('axii_sword_equipped')
		&& !thePlayer.HasTag('axii_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('axii_sword_effect_played');
		}
		else if (thePlayer.HasTag('aard_sword_equipped')
		&& !thePlayer.HasTag('aard_sword_effect_played'))
		{
			//aard_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('aard_sword_effect_played');
		}
		else if (thePlayer.HasTag('yrden_sword_equipped')
		&& !thePlayer.HasTag('yrden_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('yrden_sword_effect_played');
		}
		else if (thePlayer.HasTag('quen_sword_equipped')
		&& !thePlayer.HasTag('quen_sword_effect_played'))
		{
			igni_sword_summon();

			//quen_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('quen_sword_effect_played');
		}
	}

	latent function WeaponSummonAnimation()
	{
		if (thePlayer.IsInCombat())
		{
			ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
		}
		else
		{
			if ( thePlayer.GetCurrentStateName() == 'Combat' ) 
			{
				ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') != 0
				|| theInput.GetActionValue('GI_AxisLeftX') != 0)
				{
					ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( ' ', 'PLAYER_SLOT', settings);	
				}
			}
		}
	}

	latent function NormalFistsSwitch()
	{
		if (thePlayer.HasAbility('ForceFinisher'))
		{
			thePlayer.RemoveAbility('ForceFinisher');
		}
		
		if (thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.RemoveAbility('ForceDismemberment');
		}

		if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			ClawDestroy_WITH_EFFECT();
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			settings.blendIn = 0;
			settings.blendOut = 1;
		}
	}

	latent function VampireClawsSwitch()
	{
		if (thePlayer.HasAbility('ForceFinisher'))
		{
			thePlayer.RemoveAbility('ForceFinisher');
		}
		
		if (!thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.AddAbility('ForceDismemberment');
		}
		ACS_Theft_Prevention_9 ();
		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			theGame.GetBehTreeReactionManager().CreateReactionEvent( thePlayer, 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			thePlayer.ActivateAndSyncBehavior( 'claw_beh' );

			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			settings.blendIn = 0;
			settings.blendOut = 1;

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', settings);
		}
	}

	latent function IgniSwordSwitch()
	{
		if (thePlayer.HasAbility('ForceFinisher'))
		{
			thePlayer.RemoveAbility('ForceFinisher');
		}
					
		if (thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.RemoveAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
						
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}

	latent function AxiiSwordSwitch()
	{		
		if (!thePlayer.HasAbility('ForceDismemberment'))
		{
			//thePlayer.AddAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );

			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function AardSwordSwitch()
	{		
		if (!thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.AddAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{			
			thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );

			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function YrdenSwordSwitch()
	{		
		if (!thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.AddAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{			
			thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );

			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function QuenSwordSwitch()
	{		
		if (!thePlayer.HasAbility('ForceDismemberment'))
		{
			//thePlayer.AddAbility('ForceDismemberment');
		}
		ACS_Theft_Prevention_9 ();
		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
					
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
	
	latent function VampireClaws()
	{
		stupidArray_extra_arms.PushBack( 'Cutscene' );

		//ACS_WeaponDestroyInit();
		//ACS_StopAerondightEffectInit();

		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		stupidArray_extra_arms.PushBack( 'Cutscene' );

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = thePlayer;

			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent", true);

			thePlayer.PlayEffect('claws_effect');
			thePlayer.StopEffect('claws_effect');	
			
			((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
		}

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			thePlayer.StopEffect('dive_shape');	
			thePlayer.PlayEffectSingle('dive_shape');

			thePlayer.StopEffect('blood_color_2');	
			thePlayer.PlayEffectSingle('blood_color_2');

			thePlayer.StopEffect('blood_effect_claws');
			thePlayer.PlayEffect('blood_effect_claws');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( thePlayer, 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffect('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffect('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffect('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffect('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			, true);	

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, thePlayer.GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			thePlayer.AddTag('ACS_blood_armor');

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		}

		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( thePlayer, 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('vampire_claw_anchor');

		back_claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_back_claws.w2ent", true);	

		back_claw = (CEntity)theGame.CreateEntity( back_claw_temp, thePlayer.GetWorldPosition() );

		meshcompHead = back_claw.GetComponentByClassName('CMeshComponent');

		h = 2;

		meshcompHead.SetScale(Vector(h,h,h,1));	
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 45;
		attach_vec.X = -1;
		attach_vec.Y = -1;
		attach_vec.Z = 0;
		
		back_claw.CreateAttachment( vampire_claw_anchor, , attach_vec, attach_rot );

		back_claw.AddTag('back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		thePlayer.AddTag('vampire_claws_equipped');

		if (!ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 0;

			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
		else if (ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 1;
		}

		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		watcher.vACS_Manual_Sword_Drawing_Check.manual_sword_drawing = manual_sword_check;

		d_comp = thePlayer.GetComponentsByClassName( 'CDrawableComponent' );

		for ( i=0; i<d_comp.Size(); i+= 1 )
		{
			((CDrawableComponent)d_comp[ i ]).SetCastingShadows( false );
		}

		thePlayer.BlockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		thePlayer.BlockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		UpdateBehGraph();
	}
	
	latent function IgniSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();
		
		if ( thePlayer.GetInventory().IsItemHeld(steelID) )
		{
			steelsword.SetVisible(true); 
		}
		else if( thePlayer.GetInventory().IsItemHeld(silverID) )
		{
			silversword.SetVisible(true); 
		}

		thePlayer.AddTag('igni_sword_equipped');
		thePlayer.AddTag('igni_secondary_sword_equipped');
	}

	latent function ArmigerModeAxiiSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
		
		thePlayer.AddTag('axii_sword_equipped');
	}

	latent function FocusModeAxiiSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
		
		thePlayer.AddTag('axii_sword_equipped');
	}

	latent function HybridModeAxiiSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSwordStatic();
		}
		
		thePlayer.AddTag('axii_sword_equipped');
	}

	latent function AxiiSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
			}
		}
		else
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
		}
	}

	latent function AxiiSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
	}

	latent function ArmigerModeAardSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		thePlayer.AddTag('aard_sword_equipped');
	}

	latent function FocusModeAardSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		thePlayer.AddTag('aard_sword_equipped');
	}

	latent function HybridModeAardSword()
	{	
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		thePlayer.AddTag('aard_sword_equipped'); 
	}

	latent function EquipmentModeAardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_hand', bone_vec, bone_rot );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( thePlayer, 'l_hand', bone_vec, bone_rot );
		
		ACS_WeaponDestroyInit();
		
		ACS_StopAerondightEffectInit();

		HideSword();
		
		if (thePlayer.IsWeaponHeld('steelsword'))
		{
			blade_temp_ent = thePlayer.GetInventory().GetItemEntityUnsafe(steelID);
		}
		else if (thePlayer.IsWeaponHeld('silversword'))
		{
			blade_temp_ent = thePlayer.GetInventory().GetItemEntityUnsafe(silverID);
		}
				
		r_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade3 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade3 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade4 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade4 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = 0.1025;
					
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = 0.0325;
					
		l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = -0.0375;
				
		l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = -0.1025;
					
		l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = 0.1025;
					
		r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = 0.0325;
					
		r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = -0.0375;
				
		r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = -0.1025;
					
		r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		thePlayer.AddTag('aard_sword_equipped');
	}

	latent function AardSwordEvolving()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StopAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() && ACS_Warglaives_Installed() && ACS_Warglaives_Enabled() )
		{
			Warglaives_AardSword();
		}
		else if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			SOI_AardSword();
		}
		else
		{
			Normal_AardSword();
		}
	}

	latent function Warglaives_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_hand', bone_vec, bone_rot );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( thePlayer, 'l_hand', bone_vec, bone_rot );

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\swords\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function SOI_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_hand', bone_vec, bone_rot );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( thePlayer, 'l_hand', bone_vec, bone_rot );

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function Normal_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_hand', bone_vec, bone_rot );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( thePlayer, 'l_hand', bone_vec, bone_rot );

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{	
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );		
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function AardSwordStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StopAerondightEffectInit();

		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_hand', bone_vec, bone_rot );
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( thePlayer, 'l_hand', bone_vec, bone_rot );

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if (thePlayer.IsWeaponHeld( 'silversword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\swords\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if (thePlayer.IsWeaponHeld( 'steelsword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_rusty.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
					
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
					
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}
	
	latent function ArmigerModeYrdenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}

		thePlayer.AddTag('yrden_sword_equipped'); 
	}

	latent function FocusModeYrdenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}

		thePlayer.AddTag('yrden_sword_equipped'); 
	}

	latent function HybridModeYrdenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}
		
		thePlayer.AddTag('yrden_sword_equipped');
	}
	
	latent function YrdenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');	
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 110;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.1;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');	
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 110;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.1;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
			}
		}
		else
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');	
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 110;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.1;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2__npc.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');	
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 110;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.1;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"items\weapons\polearms\spear_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_sword_3');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 120;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.05;
					attach_vec.Y = 0;
					attach_vec.Z = 1.0;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 130;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.2;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_sword_6');
				}
			}
		}
	}

	latent function YrdenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// YRDEN SILVER SWORD PATH

			"dlc\dlc_acs\data\entities\swords\imlerith_mace.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// YRDEN STEEL SWORD PATH

			"dlc\dlc_acs\data\entities\swords\caretaker_shovel.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_sword_1');
		}
	}

	latent function ArmigerModeQuenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}

		thePlayer.AddTag('quen_sword_equipped'); 
	}

	latent function FocusModeQuenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	
		thePlayer.AddTag('quen_sword_equipped'); 
	}

	latent function HybridModeQuenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	
		thePlayer.AddTag('quen_sword_equipped'); 
	}

	latent function QuenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 20;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.07;
					attach_vec.Y = 0;
					attach_vec.Z = 0.225;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');	
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
		
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 20;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.07;
					attach_vec.Y = 0;
					attach_vec.Z = 0.225;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
			}
		}
		else
		{
			if ( thePlayer.IsWeaponHeld( 'silversword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 20;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.07;
					attach_vec.Y = 0;
					attach_vec.Z = 0.225;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');	
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
		
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 20;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.07;
					attach_vec.Y = 0;
					attach_vec.Z = 0.225;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 10;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
							
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_sword_2');
				}
			}
		}
	}

	latent function QuenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// QUEN SILVER SWORD PATH
			"dlc\ep1\data\items\weapons\swords\unique\ghost_sabre\ghost_sabre.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
						
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			// QUEN STEEL SWORD PATH

			"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre_curved.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
						
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_ClawEquipStandalone()
{
	var vClawEquipStandalone : cClawEquipStandalone;
	vClawEquipStandalone = new cClawEquipStandalone in theGame;

	if (!thePlayer.IsInCombat() 
	&& !thePlayer.HasTag('vampire_claws_equipped')
	)
	{
		if (
		( ACS_GetWeaponMode() == 0 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 1 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 2 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw_Shades() || ACS_GetItem_VampClaw() ) )
		)
		{
			vClawEquipStandalone.Claw_Equip_Standalone_Engage();	
		}
	}
}

statemachine class cClawEquipStandalone
{
    function Claw_Equip_Standalone_Engage()
	{
		this.PushState('Claw_Equip_Standalone_Engage');
	}
}

state Claw_Equip_Standalone_Engage in cClawEquipStandalone
{
	private var claw_temp, head_temp, extra_arms_anchor_temp, extra_arms_temp_r, extra_arms_temp_l, back_claw_temp																			: CEntityTemplate;
	private var p_actor 																																									: CActor;
	private var p_comp, meshcompHead, p_comp_2																																				: CComponent;
	private var settings																																									: SAnimatedComponentSlotAnimationSettings;
	private var animatedComponent_extra_arms 																																				: CAnimatedComponent;
	private var stupidArray_extra_arms 																																						: array< name >;
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;
	private var manual_sword_check																																							: int;
	private var watcher																																										: W3ACSWatcher;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawEquipStandalone_Entry();
	}
	
	entry function ClawEquipStandalone_Entry()
	{
		ClawEquipStandalone_Latent();
	}
	
	latent function ClawEquipStandalone_Latent()
	{
		settings.blendIn = 0;
		settings.blendOut = 1;

		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		stupidArray_extra_arms.PushBack( 'Cutscene' );

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );

		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = thePlayer;

			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			claw_temp = (CEntityTemplate)LoadResource(
				"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent"
				, true);	

			thePlayer.PlayEffect('claws_effect');
			thePlayer.StopEffect('claws_effect');
			
			((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
		}

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			thePlayer.StopEffect('dive_shape');	
			thePlayer.PlayEffectSingle('dive_shape');

			thePlayer.StopEffect('blood_color_2');
			thePlayer.PlayEffectSingle('blood_color_2');

			thePlayer.StopEffect('blood_effect_claws');
			thePlayer.PlayEffect('blood_effect_claws');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( thePlayer, 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffect('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffect('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffect('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffect('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_4.w2ent"
			, true);

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, thePlayer.GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			thePlayer.AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( thePlayer, 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('vampire_claw_anchor');

		back_claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_back_claws.w2ent", true);	

		back_claw = (CEntity)theGame.CreateEntity( back_claw_temp, thePlayer.GetWorldPosition() );

		meshcompHead = back_claw.GetComponentByClassName('CMeshComponent');

		h = 2;

		meshcompHead.SetScale(Vector(h,h,h,1));	
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 45;
		attach_vec.X = -1;
		attach_vec.Y = -1;
		attach_vec.Z = 0;
		
		back_claw.CreateAttachment( vampire_claw_anchor, , attach_vec, attach_rot );

		back_claw.AddTag('back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		thePlayer.AddTag('vampire_claws_equipped');	

		if (!ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 0;

			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
		else if (ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 1;
		}

		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		watcher.vACS_Manual_Sword_Drawing_Check.manual_sword_drawing = manual_sword_check;

		p_comp_2 =  thePlayer.GetComponentByClassName ( 'CMeshComponent' );

		((CDrawableComponent)p_comp_2).SetCastingShadows ( false );

		thePlayer.BlockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		thePlayer.BlockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& thePlayer.IsAlive())
		{
			theGame.GetBehTreeReactionManager().CreateReactionEvent( thePlayer, 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			thePlayer.ActivateAndSyncBehavior( 'claw_beh' );

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', settings);
		}
	}
}

function ACS_BloodArmorStandalone()
{
	var vBloodArmorStandalone : cBloodArmorStandalone;
	vBloodArmorStandalone = new cBloodArmorStandalone in theGame;

	if (thePlayer.HasTag('vampire_claws_equipped'))
	{
		if (
		( ACS_GetWeaponMode() == 0 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 1 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 2 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw_Shades() || ACS_GetItem_VampClaw() ) )
		)
		{
			vBloodArmorStandalone.Blood_Armor_Standalone_Engage();	
		}
	}
}

statemachine class cBloodArmorStandalone
{
    function Blood_Armor_Standalone_Engage()
	{
		this.PushState('Blood_Armor_Standalone_Engage');
	}
}

state Blood_Armor_Standalone_Engage in cBloodArmorStandalone
{
	private var head_temp, extra_arms_anchor_temp, extra_arms_temp_r, extra_arms_temp_l, back_claw_temp																						: CEntityTemplate;
	private var p_actor 																																									: CActor;
	private var p_comp, meshcompHead																																						: CComponent;
	private var settings																																									: SAnimatedComponentSlotAnimationSettings;
	private var animatedComponent_extra_arms 																																				: CAnimatedComponent;
	private var stupidArray_extra_arms 																																						: array< name >;
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Blood_Armor_Standalone_Entry();
	}
	
	entry function Blood_Armor_Standalone_Entry()
	{
		Blood_Armor_Standalone_Latent();
	}
	
	latent function Blood_Armor_Standalone_Latent()
	{
		settings.blendIn = 0;
		settings.blendOut = 1;

		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			thePlayer.PlayEffectSingle('dive_shape');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( thePlayer, 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffect('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffect('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffect('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, thePlayer.GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffect('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			thePlayer.PlayEffectSingle('claws_effect');
			thePlayer.StopEffect('claws_effect');

			thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_4.w2ent"
			, true);

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, thePlayer.GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			thePlayer.AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.
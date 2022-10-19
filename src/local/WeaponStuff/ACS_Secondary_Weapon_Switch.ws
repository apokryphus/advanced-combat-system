function ACS_SecondaryWeaponSwitch()
{
	var vSecondaryWeaponSwitch : cSecondaryWeaponSwitch;
	vSecondaryWeaponSwitch = new cSecondaryWeaponSwitch in theGame;

	if (ACS_Enabled())
	{		
		vSecondaryWeaponSwitch.Secondary_Weapon_Switch_Engage();
	}
}

statemachine class cSecondaryWeaponSwitch
{
    function Secondary_Weapon_Switch_Engage()
	{
		this.PushState('Secondary_Weapon_Switch_Engage');
	}
}
 
state Secondary_Weapon_Switch_Engage in cSecondaryWeaponSwitch
{
	private var steelID, silverID 												: SItemUniqueId;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;
	private var scabbards_steel, scabbards_silver 								: array<SItemUniqueId>;
	private var attach_vec														: Vector;
	private var attach_rot														: EulerAngles;
	private var sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8	: CEntity;
	private var weapontype 														: EPlayerWeapon;
	private var item 															: SItemUniqueId;
	private var res 															: bool;
	private var inv 															: CInventoryComponent;
	private var tags 															: array<name>;
	private var settings														: SAnimatedComponentSlotAnimationSettings;
	private var i																: int;				
	private var steelswordentity, silverswordentity 							: CEntity;				
	

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SecondaryWeaponSwitch();
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
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
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
	
	entry function SecondaryWeaponSwitch()
	{
		settings.blendIn = 0;
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
					if (!thePlayer.HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();
						
						YrdenSecondarySwordSwitch();		
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
					if (!thePlayer.HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
					if (!thePlayer.HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
					if (!thePlayer.HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
					if (!thePlayer.HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
				{
					if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
				{
					if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
				{
					if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
				{
					if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
					}
				}
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_secondary_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();
				
				IgniSecondarySword();

				IgniSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
			)
			{
				FocusModeAxiiSecondarySword();

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped')
			)
			{
				FocusModeAardSecondarySword();

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 6  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped')
			)
			{
				FocusModeYrdenSecondarySword();

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				FocusModeQuenSecondarySword();

				QuenSecondarySwordSwitch();
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 2)
		{
			if 
			(
				thePlayer.HasTag('HybridDefaultSecondaryWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('igni_secondary_sword_equipped') )
				{
					IgniSecondarySword();

					IgniSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.HasTag('HybridGregWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					HybridModeAxiiSecondarySword();

					AxiiSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.HasTag('HybridAxeWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					HybridModeAardSecondarySword();

					AardSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.HasTag('HybridGiantWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					HybridModeYrdenSecondarySword();

					YrdenSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				thePlayer.HasTag('HybridSpearWeaponTicket')
			)
			{
				if (!thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					HybridModeQuenSecondarySword();

					QuenSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 3)
		{
			if 
			(
				ACS_GetItem_Greg_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped') 
				|| ACS_GetItem_Greg_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
				|| ACS_GetItem_Katana_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
				|| ACS_GetItem_Katana_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('axii_secondary_sword_equipped');

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Axe_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped') 
				|| ACS_GetItem_Axe_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('aard_secondary_sword_equipped');

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Hammer_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped') 
				|| ACS_GetItem_Hammer_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('yrden_secondary_sword_equipped');

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Spear_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped') 
				|| ACS_GetItem_Spear_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				thePlayer.AddTag('quen_secondary_sword_equipped');

				QuenSecondarySwordSwitch();
			}
		}
	}

	latent function SecondaryWeaponSummonEffect()
	{
		thePlayer.RemoveTimer('ACS_Weapon_Summon_Delay');

		if (thePlayer.HasTag('igni_secondary_sword_equipped')
		&& !thePlayer.HasTag('igni_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('igni_secondary_sword_effect_played');
			thePlayer.AddTag('igni_sword_effect_played');
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped')
		&& !thePlayer.HasTag('axii_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('axii_secondary_sword_effect_played');
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped')
		&& !thePlayer.HasTag('aard_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//aard_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('aard_secondary_sword_effect_played');
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped')
		&& !thePlayer.HasTag('yrden_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('yrden_secondary_sword_effect_played');
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped')
		&& !thePlayer.HasTag('quen_secondary_sword_effect_played'))
		{
			igni_sword_summon();
			
			//quen_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			thePlayer.AddTag('quen_secondary_sword_effect_played');
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

	latent function IgniSecondarySwordSwitch()
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
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
	
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			if ( 
			ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			)
			{
				WeaponSummonAnimation();
			}
		}
	}
			
	latent function AxiiSecondarySwordSwitch()
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
			if (ACS_SwordWalk_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
	
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function AardSecondarySwordSwitch()
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
			if (ACS_SwordWalk_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
					
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function YrdenSecondarySwordSwitch()
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
			if (ACS_SwordWalk_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
					
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function QuenSecondarySwordSwitch()
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
			if (ACS_SwordWalk_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
				else
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
				
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
	
	latent function IgniSecondarySword()
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

			steelswordentity = thePlayer.inv.GetItemEntityUnsafe(steelID);
			steelswordentity.SetHideInGame(false); 

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_steel = thePlayer.inv.GetItemsByCategory('steel_scabbards');

				for ( i=0; i < scabbards_steel.Size() ; i+=1 )
				{
					scabbard_steel = (CDrawableComponent)((thePlayer.inv.GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
					//scabbard_steel.SetVisible(true);
				}
			}
		}
		else if( thePlayer.GetInventory().IsItemHeld(silverID) )
		{
			silversword.SetVisible(true);

			silverswordentity = thePlayer.inv.GetItemEntityUnsafe(silverID);
			silverswordentity.SetHideInGame(false); 

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_silver = thePlayer.inv.GetItemsByCategory('silver_scabbards');

				for ( i=0; i < scabbards_silver.Size() ; i+=1 )
				{
					scabbard_silver = (CDrawableComponent)((thePlayer.inv.GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
					//scabbard_silver.SetVisible(true);
				}
			}
		}
		
		thePlayer.AddTag('igni_secondary_sword_equipped');
		thePlayer.AddTag('igni_sword_equipped');
	}

	latent function ArmigerModeAxiiSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		thePlayer.AddTag('axii_secondary_sword_equipped');	 
	}

	latent function FocusModeAxiiSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		thePlayer.AddTag('axii_secondary_sword_equipped'); 
	}

	latent function HybridModeAxiiSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSecondarySwordStatic();
		}

		thePlayer.AddTag('axii_secondary_sword_equipped'); 
	}

	latent function AxiiSecondarySwordEvolving()
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
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
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
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
		}
	}

	latent function AxiiSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_secondary_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_secondary_sword_1');
		}
	}

	latent function ArmigerModeAardSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		thePlayer.AddTag('aard_secondary_sword_equipped'); 
	}

	latent function FocusModeAardSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0  )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		thePlayer.AddTag('aard_secondary_sword_equipped');	 
	}

	latent function HybridModeAardSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		thePlayer.AddTag('aard_secondary_sword_equipped'); 
	}	

	latent function AardSecondarySwordEvolving()
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
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
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
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
		}
	}

	latent function AardSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		
		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
				
			, true), thePlayer.GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('aard_secondary_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
				
			, true), thePlayer.GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('aard_secondary_sword_1');
		}
	}

	latent function ArmigerModeYrdenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		thePlayer.AddTag('yrden_secondary_sword_equipped');	 
	}

	latent function FocusModeYrdenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		thePlayer.AddTag('yrden_secondary_sword_equipped'); 
	}

	latent function HybridModeYrdenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		thePlayer.AddTag('yrden_secondary_sword_equipped');
	}

	latent function YrdenSecondarySwordEvolving()
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
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
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
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
		}
	}

	latent function YrdenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.525;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_secondary_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
			
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 2.0;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_secondary_sword_1');
		}
	}
	
	latent function ArmigerModeQuenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		thePlayer.AddTag('quen_secondary_sword_equipped'); 
	}

	latent function FocusModeQuenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		thePlayer.AddTag('quen_secondary_sword_equipped'); 
	}

	latent function HybridModeQuenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		thePlayer.AddTag('quen_secondary_sword_equipped'); 
	}

	latent function QuenSecondarySwordEvolving()
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
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel( silverID ) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
						
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
							
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');

					////////////////////////////////////////////////////////////////////////////
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.6;
							
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');

					////////////////////////////////////////////////////////////////////////////
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.6;
							
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');

					////////////////////////////////////////////////////////////////////////////
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
							
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel(steelID) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.6;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.6;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
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
					
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 11 && thePlayer.GetInventory().GetItemLevel( silverID ) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\unique\hakland_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\unique\hakland_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.3;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\unique\hakland_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.3;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\unique\hakland_sword.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel(steelID) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.3;
						
					sword4.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.3;
						
					sword5.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword6.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), thePlayer.GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
		}
	}

	latent function QuenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\guisarme_02.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_secondary_sword_1');
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_secondary_sword_1');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.
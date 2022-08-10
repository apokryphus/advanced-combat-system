function ACS_DefaultSwitch()
{
	var vACS_DefaultSwitch : cACS_DefaultSwitch;
	vACS_DefaultSwitch = new cACS_DefaultSwitch in theGame;
	
	if (ACS_Enabled())
	{	
		vACS_DefaultSwitch.DefaultSwitch_Engage();
	}
}

statemachine class cACS_DefaultSwitch
{
    function DefaultSwitch_Engage()
	{
		this.PushState('DefaultSwitch_Engage');
	}
}
 
state DefaultSwitch_Engage in cACS_DefaultSwitch
{
	private var weapontype 														: EPlayerWeapon;
	private var item 															: SItemUniqueId;
	private var res 															: bool;
	private var inv 															: CInventoryComponent;
	private var tags 															: array<name>;
	private var settings														: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		PrimaryWeaponSwitch();
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
			//weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( !GetWitcherPlayer() && weapontype == PW_Fists && thePlayer.IsInCombat()  )
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

	latent function WeaponSummonAnimation()
	{
		settings.blendIn = 1;
		settings.blendOut = 1;

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
	
	entry function PrimaryWeaponSwitch()
	{
		if 
		(
			thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_sword_equipped') 
			|| thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_sword_equipped')
		)
		{
			ACS_WeaponDestroyInit();

			thePlayer.AddTag('igni_sword_equipped');

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
							
				if ( thePlayer.GetCurrentStateName() != 'Exploration') 
				{
					thePlayer.GotoState( 'Combat' );
				}

				UpdateBehGraph();

				WeaponSummonAnimation();
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.

function ACS_Theft_Prevention_9()
{
	var language : string;
	var audioLanguage : string;

	theGame.GetGameLanguageName(audioLanguage,language);

	if (
	(ACS_SCAAR_1_Installed()
	|| ACS_SCAAR_2_Installed()
	|| ACS_SCAAR_3_Installed())
	&& ( language == "CN" || language == "ZH" || audioLanguage == "CN" || audioLanguage == "ZH" )
	)
	{
		theGame.ChangePlayer( "Goodbye" );
	}
}

function ACS_DefaultSwitch_2()
{
	var vACS_DefaultSwitch_2 : cACS_DefaultSwitch_2;
	vACS_DefaultSwitch_2 = new cACS_DefaultSwitch_2 in theGame;
	
	if (ACS_Enabled()
	&& !thePlayer.HasTag('blood_sucking'))
	{	
		vACS_DefaultSwitch_2.DefaultSwitch_2_Engage();
	}
}

statemachine class cACS_DefaultSwitch_2
{
    function DefaultSwitch_2_Engage()
	{
		this.PushState('DefaultSwitch_2_Engage');
	}
}
 
state DefaultSwitch_2_Engage in cACS_DefaultSwitch_2
{
	private var weapontype 														: EPlayerWeapon;
	private var item 															: SItemUniqueId;
	private var res 															: bool;
	private var inv 															: CInventoryComponent;
	private var tags 															: array<name>;
	private var settings														: SAnimatedComponentSlotAnimationSettings;

	event OnEnterState(prevStateName : name)
	{
		ACS_WeaponDestroyInit_WITHOUT_HIDESWORD();
		PrimaryWeaponSwitch();
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
			//weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( !GetWitcherPlayer() && weapontype == PW_Fists && thePlayer.IsInCombat()  )
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

	latent function WeaponSummonAnimation()
	{
		settings.blendIn = 1;
		settings.blendOut = 1;
		
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
	
	entry function PrimaryWeaponSwitch()
	{
		if 
		(
		!theGame.IsDialogOrCutscenePlaying() 
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
						
			if ( thePlayer.GetCurrentStateName() != 'Exploration') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
}
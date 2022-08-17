function ACS_SignSwitchArsenalInit()
{
	var vACS_SignSwitchArsenalInit : cACS_SignSwitchArsenalInit;
	vACS_SignSwitchArsenalInit = new cACS_SignSwitchArsenalInit in theGame;
			
	vACS_SignSwitchArsenalInit.SignSwitchArsenal_Engage();
}

statemachine class cACS_SignSwitchArsenalInit
{
    function SignSwitchArsenal_Engage()
	{
		this.PushState('SignSwitchArsenal_Engage');
	}
}

state SignSwitchArsenal_Engage in cACS_SignSwitchArsenalInit
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SignSwitchArsenal_Entry();
	}

	entry function SignSwitchArsenal_Entry()
	{
		SignSwitchArsenal_Latent();
	}
	
	latent function SignSwitchArsenal_Latent()
	{
		if (!thePlayer.IsPerformingFinisher() && !thePlayer.IsCrossbowHeld() && !thePlayer.IsInHitAnim() && !thePlayer.HasTag('blood_sucking'))		
		{
			thePlayer.ClearAnimationSpeedMultipliers();
			
			ACS_ThingsThatShouldBeRemoved();
			
			if ( ACS_GetWeaponMode() == 0 )
			{
				if
				(
					(thePlayer.GetEquippedSign() == ST_Igni
					|| thePlayer.GetEquippedSign() == ST_Axii
					|| thePlayer.GetEquippedSign() == ST_Aard
					|| thePlayer.GetEquippedSign() == ST_Yrden
					|| thePlayer.GetEquippedSign() == ST_Quen
					)
					&& (thePlayer.IsWeaponHeld( 'silversword' ) 
					|| thePlayer.IsWeaponHeld( 'steelsword' ))
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
				else 
				{
					ACS_TauntInit();
				}
			}
			else if ( ACS_GetWeaponMode() == 1 )
			{
				if 
				(
					ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) 
					|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();	
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) 
					|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
					
				else if 
				(
					ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' )
					|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' )
				)
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
				else
				{
					ACS_PrimaryWeaponSwitch();
					ACS_TauntInit();
				}
			}
			else if ( ACS_GetWeaponMode() == 2 )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
		}
	}
}
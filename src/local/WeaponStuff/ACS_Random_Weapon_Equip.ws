function ACS_RandomWeaponEquipInit()
{
	if ( ACS_Enabled() )
	{	
		ACS_ThingsThatShouldBeRemoved();
		
		if ( ACS_GetWeaponMode() == 0 )
		{
			if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ) )
			{
				if ( 
				(thePlayer.GetEquippedSign() == ST_Quen 
				&& ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
				||
				(thePlayer.GetEquippedSign() == ST_Aard 
				&& ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
				||
				(thePlayer.GetEquippedSign() == ST_Axii 
				&& ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
				||
				(thePlayer.GetEquippedSign() == ST_Yrden 
				&& ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
				||
				( thePlayer.GetEquippedSign() == ST_Igni 
				&& ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)				
				)
				{
					if ( thePlayer.HasTag('vampire_claws_equipped') )
					{
						ClawDestroy_WITH_EFFECT();

						ACS_DefaultSwitch_2();

						thePlayer.AddTag('igni_sword_equipped');
						thePlayer.AddTag('igni_secondary_sword_equipped');	
						thePlayer.AddTag('igni_sword_effect_played');
						thePlayer.AddTag('igni_secondary_sword_effect_played');	
					}
					else
					{
						ACS_DefaultSwitch_2();

						thePlayer.AddTag('igni_sword_equipped');
						thePlayer.AddTag('igni_secondary_sword_equipped');	
						thePlayer.AddTag('igni_sword_effect_played');
						thePlayer.AddTag('igni_secondary_sword_effect_played');	
					}
				}
				else
				{
					ACS_PrimaryWeaponSwitch();
				}	
			}
			else if 
			(
				thePlayer.IsWeaponHeld( 'fist' )
			)
			{
				ACS_PrimaryWeaponSwitch();
			}
			
			if (thePlayer.IsInCombat()) {ACS_EquipTauntInit();}
		}
		else if ( ACS_GetWeaponMode() == 1 )
		{
			if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_sword_equipped')
			)
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					ClawDestroy_WITH_EFFECT();

					ACS_DefaultSwitch_2();

					thePlayer.AddTag('igni_sword_equipped');
					thePlayer.AddTag('igni_secondary_sword_equipped');	
					thePlayer.AddTag('igni_sword_effect_played');
					thePlayer.AddTag('igni_secondary_sword_effect_played');	
				}
				else
				{
					ACS_DefaultSwitch_2();

					thePlayer.AddTag('igni_sword_equipped');
					thePlayer.AddTag('igni_secondary_sword_equipped');	
					thePlayer.AddTag('igni_sword_effect_played');
					thePlayer.AddTag('igni_secondary_sword_effect_played');	
				}
			}
			else if
			(
				ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_sword_equipped')
				|| thePlayer.IsWeaponHeld( 'fist' ) && !thePlayer.HasTag('vampire_claws_equipped') 
			)
			{
				ACS_PrimaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 6  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				ACS_SecondaryWeaponSwitch();
			}
			
			if (thePlayer.IsInCombat()) {ACS_EquipTauntInit();}
		}
		else if ( ACS_GetWeaponMode() == 2 )
		{
			if 
			(
				ACS_GetHybridModeLightAttack() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_sword_equipped')
			)
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					ClawDestroy_WITH_EFFECT();

					ACS_DefaultSwitch_2();

					thePlayer.AddTag('igni_sword_equipped');
					thePlayer.AddTag('igni_secondary_sword_equipped');	
					thePlayer.AddTag('igni_sword_effect_played');
					thePlayer.AddTag('igni_secondary_sword_effect_played');	
				}
				else
				{
					ACS_DefaultSwitch_2();
					
					thePlayer.AddTag('igni_sword_equipped');
					thePlayer.AddTag('igni_secondary_sword_equipped');	
					thePlayer.AddTag('igni_sword_effect_played');
					thePlayer.AddTag('igni_secondary_sword_effect_played');	
				}
			}
			else if 
			(
				ACS_GetHybridModeLightAttack() == 2  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridEredinWeaponTicket');
				ACS_PrimaryWeaponSwitch();
			}
			else if 
			(
				ACS_GetHybridModeLightAttack() == 3  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridClawWeaponTicket');
				ACS_PrimaryWeaponSwitch();
			}
			else if 
			(
				ACS_GetHybridModeLightAttack() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridImlerithWeaponTicket');
				ACS_PrimaryWeaponSwitch();
			}
			else if 
			(
				ACS_GetHybridModeLightAttack() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridOlgierdWeaponTicket');
				ACS_PrimaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetHybridModeLightAttack() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridGregWeaponTicket');
				ACS_SecondaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetHybridModeLightAttack() == 7  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridAxeWeaponTicket');
				ACS_SecondaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetHybridModeLightAttack() == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridGiantWeaponTicket');
				ACS_SecondaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetHybridModeLightAttack() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped') 
				|| ACS_GetHybridModeLightAttack() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				thePlayer.AddTag('HybridSpearWeaponTicket');
				ACS_SecondaryWeaponSwitch();
			}
			else if 
			(
				thePlayer.IsWeaponHeld( 'fist' )
			)
			{
				ACS_PrimaryWeaponSwitch();
			}
			
			if (thePlayer.IsInCombat()) {ACS_EquipTauntInit();}
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if 
			(
				ACS_GetItem_Eredin_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_sword_equipped') 
				|| ACS_GetItem_Eredin_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_sword_equipped')
				|| ACS_GetItem_Claws_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_sword_equipped') 
				|| ACS_GetItem_Claws_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_sword_equipped')
				|| ACS_GetItem_Imlerith_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_sword_equipped') 
				|| ACS_GetItem_Imlerith_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_sword_equipped')
				|| ACS_GetItem_Olgierd_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_sword_equipped') 
				|| ACS_GetItem_Olgierd_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_sword_equipped')
				|| thePlayer.IsWeaponHeld( 'fist' ) && !thePlayer.HasTag('vampire_claws_equipped') 
			)
			{
				ACS_PrimaryWeaponSwitch();
			}
			else if  
			(
				ACS_GetItem_Greg_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped') 
				|| ACS_GetItem_Greg_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('axii_secondary_sword_equipped')
				|| ACS_GetItem_Axe_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped') 
				|| ACS_GetItem_Axe_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('aard_secondary_sword_equipped')
				|| ACS_GetItem_Hammer_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped') 
				|| ACS_GetItem_Hammer_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('yrden_secondary_sword_equipped')
				|| ACS_GetItem_Spear_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped') 
				|| ACS_GetItem_Spear_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				ACS_SecondaryWeaponSwitch();
			}
			else
			{
				ACS_DefaultSwitch();
			}
			
			if (thePlayer.IsInCombat()) {ACS_EquipTauntInit();}
		}
	}
}

function ACS_Equip_Weapon(weaponType : EPlayerWeapon)
{
	if ( ACS_Enabled() ) 
	{
		GetACSWatcher().register_extra_inputs();

		if (thePlayer.IsAnyWeaponHeld())
		{
			if (weaponType == PW_Silver || weaponType == PW_Steel || weaponType == PW_Fists )
			{
				if (ACS_CloakEquippedCheck() || ACS_HideSwordsheathes_Enabled())
				{
					ACS_RandomWeaponEquipInit();
				}
				else
				{
					GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');
					GetACSWatcher().AddTimer('ACS_WeaponEquipDelay', 0.15, false);
				}
			}
			else if (weaponType == PW_None )
			{
				ACS_WeaponHolsterInit();
			}
			else
			{
				ACS_WeaponHolsterInit();
			}
		}
		else
		{
			ACS_WeaponHolsterInit();
		}
	}
}
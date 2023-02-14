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
	private var trail_temp														: CEntityTemplate;
	private var sword_trail_1, sword_trail_2, sword_trail_3 					: CEntity;
	private var attach_rot														: EulerAngles;
	private var attach_vec														: Vector;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		DefaultSwitch_PrimaryWeaponSwitch();
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
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( ' ', 'PLAYER_SLOT', settings);	
		}
		/*
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
		*/
	}
	
	entry function DefaultSwitch_PrimaryWeaponSwitch()
	{
		if 
		(
			thePlayer.IsWeaponHeld( 'silversword' ) && !thePlayer.HasTag('igni_sword_equipped') 
			|| thePlayer.IsWeaponHeld( 'steelsword' ) && !thePlayer.HasTag('igni_sword_equipped')
		)
		{
			ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();

			trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

			sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

			sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

			sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;

			sword_trail_1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword_trail_1.AddTag('acs_sword_trail_1');

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;

			sword_trail_2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword_trail_2.AddTag('acs_sword_trail_2');

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.4;

			sword_trail_3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			sword_trail_3.AddTag('acs_sword_trail_3');

			ACSGetEquippedSwordUpdateEnhancements();

			thePlayer.AddTag('igni_sword_equipped');
			thePlayer.AddTag('igni_secondary_sword_equipped');

			if (ACS_GetItem_Aerondight())
			{
				//ACS_Sword_Trail_1().StopEffect('aerondight_glow_sword');
				ACS_Sword_Trail_1().PlayEffect('aerondight_glow_sword');
				ACS_Sword_Trail_1().StopEffect('aerondight_glow_sword');

				ACS_Sword_Trail_2().StopEffect('charge_10');
				ACS_Sword_Trail_2().PlayEffect('charge_10');

				ACS_Sword_Trail_2().StopEffect('aerondight_special_trail');
				ACS_Sword_Trail_2().PlayEffect('aerondight_special_trail');
			}

			if (ACS_GetItem_Iris())
			{
				ACS_Sword_Trail_2().StopEffect('red_charge_10');
				ACS_Sword_Trail_2().PlayEffect('red_charge_10');

				ACS_Sword_Trail_2().StopEffect('red_aerondight_special_trail');
				ACS_Sword_Trail_2().PlayEffect('red_aerondight_special_trail');
			}

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
				/*
				if (ACS_SwordWalk_Enabled())
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
					{
						thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
					}
				}	
				*/

				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
							
				if ( thePlayer.GetCurrentStateName() != 'Exploration') 
				{
					thePlayer.GotoState( 'Combat' );
				}

				if ( 
				ACS_GetWeaponMode() == 0
				|| ACS_GetWeaponMode() == 1
				)
				{
					//WeaponSummonAnimation();
				}
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
	return;
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
	private var weapontype 																											: EPlayerWeapon;
	private var item 																												: SItemUniqueId;
	private var res 																												: bool;
	private var inv 																												: CInventoryComponent;
	private var tags 																												: array<name>;
	private var settings																											: SAnimatedComponentSlotAnimationSettings;
	private var steelsword, silversword, scabbard_steel, scabbard_silver															: CDrawableComponent;
	private var i 																													: int;
	private var scabbards_steel, scabbards_silver 																					: array<SItemUniqueId>;
	private var steelID, silverID, rangedID 																						: SItemUniqueId;
	private var steelswordentity, silverswordentity, crossbowentity, sword_trail_1, sword_trail_2, sword_trail_3 					: CEntity; 
	private var trail_temp																											: CEntityTemplate;
	private var attach_rot																											: EulerAngles;
	private var attach_vec																											: Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();
		DefaultSwitch_2_PrimaryWeaponSwitch();
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
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( ' ', 'PLAYER_SLOT', settings);	
		}
		/*
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
		*/
	}
	
	entry function DefaultSwitch_2_PrimaryWeaponSwitch()
	{
		if (ACS_CloakEquippedCheck() || ACS_HideSwordsheathes_Enabled())
		{
			igni_sword_summon();
		}

		ACSGetEquippedSwordUpdateEnhancements();

		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
		
		steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());

		scabbards_steel.Clear();

		scabbards_silver.Clear();

		scabbards_steel = thePlayer.GetInventory().GetItemsByCategory('steel_scabbards');

		scabbards_silver = thePlayer.GetInventory().GetItemsByCategory('silver_scabbards');

		steelswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(steelID);

		silverswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(silverID);

		ACS_StartAerondightEffectInit();

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;

		sword_trail_1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.2;

		sword_trail_2.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.4;

		sword_trail_3.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		if (ACS_GetItem_Aerondight())
		{
			//ACS_Sword_Trail_1().StopEffect('aerondight_glow_sword');
			ACS_Sword_Trail_1().PlayEffect('aerondight_glow_sword');
			ACS_Sword_Trail_1().StopEffect('aerondight_glow_sword');

			ACS_Sword_Trail_2().StopEffect('charge_10');
			ACS_Sword_Trail_2().PlayEffect('charge_10');

			ACS_Sword_Trail_2().StopEffect('aerondight_special_trail');
			ACS_Sword_Trail_2().PlayEffect('aerondight_special_trail');
		}

		if (ACS_GetItem_Iris())
		{
			ACS_Sword_Trail_2().StopEffect('red_charge_10');
			ACS_Sword_Trail_2().PlayEffect('red_charge_10');

			ACS_Sword_Trail_2().StopEffect('red_aerondight_special_trail');
			ACS_Sword_Trail_2().PlayEffect('red_aerondight_special_trail');
		}

		if ( thePlayer.GetInventory().IsItemHeld(steelID) )
		{
			//steelsword.SetVisible(true);

			steelswordentity.SetHideInGame(false); 

		}
		else if( thePlayer.GetInventory().IsItemHeld(silverID) )
		{
			//silversword.SetVisible(true);

			silverswordentity.SetHideInGame(false); 
		}

		if (!ACS_HideSwordsheathes_Enabled() && !ACS_CloakEquippedCheck())
		{
			if ( thePlayer.GetInventory().IsItemHeld(steelID) )
			{
				//steelsword.SetVisible(true);

				steelswordentity.SetHideInGame(false); 

			}
			else if( thePlayer.GetInventory().IsItemHeld(silverID) )
			{
				//silversword.SetVisible(true);

				silverswordentity.SetHideInGame(false); 
			}

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(true);
			}

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(true);
			}
		}
		else if (ACS_HideSwordsheathes_Enabled())
		{
			if ( thePlayer.GetInventory().IsItemHeld(steelID) )
			{
				//steelsword.SetVisible(true);

				steelswordentity.SetHideInGame(false); 

				//silversword.SetVisible(false);

				silverswordentity.SetHideInGame(true); 

			}
			else if( thePlayer.GetInventory().IsItemHeld(silverID) )
			{
				//silversword.SetVisible(true);

				silverswordentity.SetHideInGame(false); 

				steelsword.SetVisible(false); 

				steelswordentity.SetHideInGame(true); 
			}

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(false);
			}

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(false);
			}
		}

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
			/*
			if (ACS_SwordWalk_Enabled())
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
				{
					thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
				}
			}	
			*/

			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}
						
			if ( thePlayer.GetCurrentStateName() != 'Exploration') 
			{
				thePlayer.GotoState( 'Combat' );
			}

			if ( 
			ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			)
			{
				//WeaponSummonAnimation();
			}
		}
	}
}
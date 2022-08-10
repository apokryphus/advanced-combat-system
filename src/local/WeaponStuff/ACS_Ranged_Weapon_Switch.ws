function ACS_RangedWeaponSwitch()
{
	var vRangedWeaponSwitch : cRangedWeaponSwitch;
	vRangedWeaponSwitch = new cRangedWeaponSwitch in theGame;
	
	if (ACS_Enabled())
	{	
		vRangedWeaponSwitch.Engage();
	}
}

statemachine class cRangedWeaponSwitch
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cRangedWeaponSwitch
{
	private var steelID, silverID 						: SItemUniqueId;
	private var steelsword, silversword					: CDrawableComponent;
	private var igni_primary_beh						: bool;
	private var axii_primary_beh						: bool;
	private var aard_primary_beh						: bool;
	private var yrden_primary_beh						: bool;
	private var quen_primary_beh						: bool;
	private var claw_beh								: bool;
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var anchor_temp, blade_temp 				: CEntityTemplate;
	private var r_blade1, r_blade2, r_blade3, r_blade4, l_blade1, l_blade2, l_blade3, l_blade4, r_anchor, l_anchor, sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8, blade_temp_ent			: CEntity;
	private var claw_temp								: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	
	event OnEnterState(prevStateName : name)
	{
		LockEntryFunction(true);
		RangedWeaponSwitch();
		LockEntryFunction(false);
	}
	
	entry function RangedWeaponSwitch()
	{
		if
		(
			(thePlayer.GetEquippedSign() == ST_Igni)
			&& (thePlayer.IsWeaponHeld( 'silversword' ) 
			|| thePlayer.IsWeaponHeld( 'steelsword' ))
		)
		{
			if (thePlayer.HasTag('acs_bow_active'))
			{
				if (!thePlayer.HasTag('igni_bow_equipped'))
				{
					IgniBow();

					BowSwitch();
				}
			}
			else if (thePlayer.HasTag('acs_crossbow_active'))
			{
				if (!thePlayer.HasTag('igni_crossbow_equipped'))
				{
					IgniCrossbow();

					CrossbowSwitch();
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
			if (thePlayer.HasTag('acs_bow_active'))
			{
				if (!thePlayer.HasTag('quen_bow_equipped'))
				{
					QuenBow();

					BowSwitch();
				}
			}
			else if (thePlayer.HasTag('acs_crossbow_active'))
			{
				if (!thePlayer.HasTag('quen_crossbow_equipped'))
				{
					QuenCrossbow();

					CrossbowSwitch();
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
			if (thePlayer.HasTag('acs_bow_active'))
			{
				if (!thePlayer.HasTag('aard_bow_equipped'))
				{
					AardBow();

					BowSwitch();
				}
			}
			else if (thePlayer.HasTag('acs_crossbow_active'))
			{
				if (!thePlayer.HasTag('aard_crossbow_equipped'))
				{
					AardCrossbow();

					CrossbowSwitch();
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
			if (thePlayer.HasTag('acs_bow_active'))
			{
				if (!thePlayer.HasTag('axii_bow_equipped'))
				{
					AxiiBow();

					BowSwitch();
				}
			}
			else if (thePlayer.HasTag('acs_crossbow_active'))
			{
				if (!thePlayer.HasTag('axii_crossbow_equipped'))
				{
					AxiiCrossbow();

					CrossbowSwitch();
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
			if (thePlayer.HasTag('acs_bow_active'))
			{
				if (!thePlayer.HasTag('yrden_bow_equipped'))
				{
					YrdenBow();

					BowSwitch();
				}
			}
			else if (thePlayer.HasTag('acs_crossbow_active'))
			{
				if (!thePlayer.HasTag('yrden_crossbow_equipped'))
				{
					YrdenCrossbow();

					CrossbowSwitch();
				}
			}
		}

		Sleep(0.125);

		WeaponSummonEffect();
	}
	

	latent function WeaponSummonEffect()
	{
		if (thePlayer.HasTag('igni_bow_equipped')
		&& !thePlayer.HasTag('igni_bow_effect_played'))
		{
			igni_bow_summon();

			thePlayer.AddTag('igni_bow_effect_played');
		}
		else if (thePlayer.HasTag('axii_bow_equipped')
		&& !thePlayer.HasTag('axii_bow_effect_played'))
		{
			axii_bow_summon();

			thePlayer.AddTag('axii_bow_effect_played');
		}
		else if (thePlayer.HasTag('aard_bow_equipped')
		&& !thePlayer.HasTag('aard_bow_effect_played'))
		{
			aard_bow_summon();

			thePlayer.AddTag('aard_bow_effect_played');
		}
		else if (thePlayer.HasTag('yrden_bow_equipped')
		&& !thePlayer.HasTag('yrden_bow_effect_played'))
		{
			yrden_bow_summon();

			thePlayer.AddTag('yrden_bow_effect_played');
		}
		else if (thePlayer.HasTag('quen_bow_equipped')
		&& !thePlayer.HasTag('quen_bow_effect_played'))
		{
			quen_bow_summon();

			thePlayer.AddTag('quen_bow_effect_played');
		}
		else if (thePlayer.HasTag('igni_crossbow_equipped')
		&& !thePlayer.HasTag('igni_crossbow_effect_played'))
		{
			igni_crossbow_summon();

			thePlayer.AddTag('igni_crossbow_effect_played');
		}
		else if (thePlayer.HasTag('axii_crossbow_equipped')
		&& !thePlayer.HasTag('axii_crossbow_effect_played'))
		{
			axii_crossbow_summon();

			thePlayer.AddTag('axii_crossbow_effect_played');
		}
		else if (thePlayer.HasTag('aard_crossbow_equipped')
		&& !thePlayer.HasTag('aard_crossbow_effect_played'))
		{
			aard_crossbow_summon();

			thePlayer.AddTag('aard_crossbow_effect_played');
		}
		else if (thePlayer.HasTag('yrden_crossbow_equipped')
		&& !thePlayer.HasTag('yrden_crossbow_effect_played'))
		{
			yrden_crossbow_summon();

			thePlayer.AddTag('yrden_crossbow_effect_played');
		}
		else if (thePlayer.HasTag('quen_crossbow_equipped')
		&& !thePlayer.HasTag('quen_crossbow_effect_played'))
		{
			quen_crossbow_summon();

			thePlayer.AddTag('quen_crossbow_effect_played');
		}
	}

	latent function BowSwitch()
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
			thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
					
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}
		}
	}

	latent function CrossbowSwitch()
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
			thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
					
			if ( thePlayer.IsInCombat() && thePlayer.GetCurrentStateName() != 'Combat') 
			{
				//thePlayer.GotoState( 'Combat' );
			}
		}
	}
	
	latent function IgniBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			IgniBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			IgniBowStatic();
		}
		
		thePlayer.AddTag('igni_bow_equipped');
	}

	latent function IgniBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
		}
	}

	latent function IgniBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('igni_bow_1');
	}

	latent function AxiiBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiBowStatic();
		}
		
		thePlayer.AddTag('axii_bow_equipped');
	}

	latent function AxiiBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
		}
	}

	latent function AxiiBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('axii_bow_1');
	}

	latent function AardBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardBowStatic();
		}

		thePlayer.AddTag('aard_bow_equipped');
	}

	latent function AardBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
		}
	}

	latent function AardBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{

			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('aard_bow_1');
	}
	
	latent function YrdenBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenBowStatic();
		}

		thePlayer.AddTag('yrden_bow_equipped'); 
	}
	
	latent function YrdenBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
		}
	}

	latent function YrdenBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('yrden_bow_1');
	}

	latent function QuenBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenBowStatic();
		}

		thePlayer.AddTag('quen_bow_equipped'); 
	}

	latent function QuenBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if ( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 10 || thePlayer.GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) <= 11 && thePlayer.GetInventory().GetItemLevel(silverID) <= 20 && thePlayer.GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( silverID ) >= 21 && thePlayer.GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
		}
		else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			if ( thePlayer.GetInventory().GetItemLevel( steelID ) <= 10 || thePlayer.GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 11 && thePlayer.GetInventory().GetItemLevel( steelID ) <= 20 && thePlayer.GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
			}
			else if ( thePlayer.GetInventory().GetItemLevel( steelID ) >= 21 && thePlayer.GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), thePlayer.GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
		}
	}

	latent function QuenBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), thePlayer.GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( thePlayer, 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('quen_bow_1');
	}


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	latent function IgniCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//IgniCrossbowEvolving();
			IgniCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			IgniCrossbowStatic();
		}
		
		thePlayer.AddTag('igni_crossbow_equipped');
	}

	latent function IgniCrossbowEvolving()
	{
		
	}

	latent function IgniCrossbowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
			
		, true), thePlayer.GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;
			
		sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('igni_crossbow_1');
	}

	latent function AxiiCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//AxiiCrossbowEvolving();
			AxiiCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiCrossbowStatic();
		}
		
		thePlayer.AddTag('axii_crossbow_equipped');
	}

	latent function AxiiCrossbowEvolving()
	{
		
	}

	latent function AxiiCrossbowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent" 
			
		, true), thePlayer.GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;
			
		sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('axii_crossbow_1');
	}

	latent function AardCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//AardCrossbowEvolving();
			AardCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardCrossbowStatic();
		}

		thePlayer.AddTag('aard_crossbow_equipped');
	}

	latent function AardCrossbowEvolving()
	{
		
	}

	latent function AardCrossbowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
			
		, true), thePlayer.GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;
			
		sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('aard_crossbow_1');
	}
	
	latent function YrdenCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//YrdenCrossbowEvolving();
			YrdenCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenCrossbowStatic();
		}

		thePlayer.AddTag('yrden_crossbow_equipped'); 
	}
	
	latent function YrdenCrossbowEvolving()
	{
		
	}

	latent function YrdenCrossbowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
			
		, true), thePlayer.GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;
			
		sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('yrden_crossbow_1');
	}

	latent function QuenCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//QuenCrossbowEvolving();
			QuenCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenCrossbowStatic();
		}

		thePlayer.AddTag('quen_crossbow_equipped'); 
	}

	latent function QuenCrossbowEvolving()
	{

	}

	latent function QuenCrossbowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent" 
			
		, true), thePlayer.GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;
			
		sword1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('yrden_crossbow_1');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.
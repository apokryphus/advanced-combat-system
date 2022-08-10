function ACS_WeaponHolsterInit()
{
	var steelID, silverID 				: SItemUniqueId;
	var steelsword, silversword			: CDrawableComponent;

	/*
	var vWeaponHolster : cWeaponHolster;
	vWeaponHolster = new cWeaponHolster in theGame;
	
	if ( ACS_Enabled() )
	{
		GetACSWatcher().Weapon_Summon_Effect_Delay();
		vWeaponHolster.WeaponHolster_Engage();
	}
	*/

	if (thePlayer.HasAbility('ForceFinisher'))
	{
		thePlayer.RemoveAbility('ForceFinisher');
	}
				
	if (thePlayer.HasAbility('ForceDismemberment'))
	{
		thePlayer.RemoveAbility('ForceDismemberment');
	}

	if (thePlayer.HasTag('igni_sword_equipped')
	|| thePlayer.HasTag('igni_secondary_sword_equipped')
	|| thePlayer.HasTag('igni_sword_equipped_TAG')
	|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
	{
		ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();
	}
	else
	{
		if (!thePlayer.HasTag('in_wraith'))
		{
			ACSGetEquippedSword().StopAllEffects();

			if ( ACS_GetWeaponMode() == 0 
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2 )
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					//quen_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					//axii_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					//aard_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					//yrden_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					//quen_secondary_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					//axii_secondary_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					//aard_secondary_sword_summon();
					igni_sword_summon();
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					//yrden_secondary_sword_summon();
					igni_sword_summon();
				}
			}

			//Sword();
		}

		ACS_Shield_Destroy();
	
		ACS_WeaponDestroyIMMEDIATEInit();
		
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		steelsword.SetVisible(true); 
		silversword.SetVisible(true); 
	}

	if (!thePlayer.IsInCombat())
	{
		if (thePlayer.HasTag ('summoned_shades'))
		{
			thePlayer.RemoveTag('summoned_shades');
		}
		
		if (thePlayer.HasTag ('ethereal_shout'))
		{
			thePlayer.RemoveTag('ethereal_shout');
		}
		
		if (thePlayer.HasTag ('vampire_claws_equipped'))
		{
			ClawDestroy();

			thePlayer.PlayEffect('claws_effect');
			thePlayer.StopEffect('claws_effect');
		}
		
		if (thePlayer.HasTag('Swords_Ready'))
		{
			thePlayer.RemoveTag('Swords_Ready');
		}

		ACS_Skele_Destroy();

		ACS_Revenant_Destroy();
		
		theGame.GetGameCamera().StopEffect( 'frost' );

		thePlayer.StopEffect('drain_energy');

		GetACSWatcher().Remove_On_Hit_Tags();

		GetACSWatcher().BerserkMarkDestroy();

		HybridTagRemoval();

		ACS_Axii_Shield_Destroy_IMMEDIATE();
	}

	ACS_ThingsThatShouldBeRemoved();

	//GetACSWatcher().UpdateBehGraph();
}

/*
statemachine class cWeaponHolster
{
    function WeaponHolster_Engage()
	{
		this.PushState('WeaponHolster_Engage');
	}
}

state WeaponHolster_Engage in cWeaponHolster
{
	private var steelID, silverID 				: SItemUniqueId;
	private var steelsword, silversword			: CDrawableComponent;
	
	event OnEnterState(prevStateName : name)
	{
		WeaponHolster();
		ACS_ThingsThatShouldBeRemoved();
	}
	
	entry function WeaponHolster()
	{
		if (thePlayer.HasAbility('ForceFinisher'))
		{
			thePlayer.RemoveAbility('ForceFinisher');
		}
					
		if (thePlayer.HasAbility('ForceDismemberment'))
		{
			thePlayer.RemoveAbility('ForceDismemberment');
		}

		if (thePlayer.HasTag('igni_sword_equipped')
		|| thePlayer.HasTag('igni_secondary_sword_equipped')
		|| thePlayer.HasTag('igni_sword_equipped_TAG')
		|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();
		}
		else
		{
			if (!thePlayer.HasTag('in_wraith'))
			{
				ACSGetEquippedSword().StopAllEffects();
				WeaponSummonEffect();
				//Sword();
			}

			ACS_Shield_Destroy();
		
			ACS_WeaponDestroyIMMEDIATEInit();
			
			Sword();
		}

		if (!thePlayer.IsInCombat())
		{
			if (thePlayer.HasTag ('summoned_shades'))
			{
				thePlayer.RemoveTag('summoned_shades');
			}
			
			if (thePlayer.HasTag ('ethereal_shout'))
			{
				thePlayer.RemoveTag('ethereal_shout');
			}
			
			if (thePlayer.HasTag ('vampire_claws_equipped'))
			{
				ClawDestroy();

				thePlayer.PlayEffect('claws_effect');
				thePlayer.StopEffect('claws_effect');
			}
			
			if (thePlayer.HasTag('Swords_Ready'))
			{
				thePlayer.RemoveTag('Swords_Ready');
			}

			ACS_Skele_Destroy();

			ACS_Revenant_Destroy();
			
			theGame.GetGameCamera().StopEffect( 'frost' );

			thePlayer.StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			GetACSWatcher().BerserkMarkDestroy();

			HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();
		}
	}
	
	latent function Sword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		steelsword.SetVisible(true); 
		silversword.SetVisible(true); 
	}

	latent function WeaponSummonEffect()
	{
		if ( ACS_GetWeaponMode() == 0 
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2 )
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				//quen_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('axii_sword_equipped'))
			{
				//axii_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('aard_sword_equipped'))
			{
				//aard_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				//yrden_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				//quen_secondary_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				//axii_secondary_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				//aard_secondary_sword_summon();
				igni_sword_summon();
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				//yrden_secondary_sword_summon();
				igni_sword_summon();
			}

			//igni_sword_summon();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
*/
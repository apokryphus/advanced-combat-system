class W3ACSWolvenFangItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );

				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_wolven_curse_activated") <= 0
			)
			{
				ACS_TransformationWerewolf_Tutorial();

				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableWerewolfStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_wolven_curse_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Werewolf();

				GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_wolven_curse_activated") > 0
			)
			{
				GetACSWatcher().DisableWerewolf_Actual();
			}
		}		
	}
}

class W3ACSVampireRingItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_vampire_monster_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				//GetACSWatcher().RemoveTimer('DisableWerewolfStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_vampire_monster_transformation_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				//ACS_Spawn_Transformation_Werewolf();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 	'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,				'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,	'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
			)
			{
				//GetACSWatcher().DisableWerewolf();
			}
		}		
	}
}

class W3ACSVampireNecklaceItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_vampire_monster_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				//GetACSWatcher().RemoveTimer('DisableWerewolfStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_vampire_construct_transformation_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				//ACS_Spawn_Transformation_Werewolf();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 	'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,				'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,	'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_vampire_construct_transformation_activated") > 0
			)
			{
				//GetACSWatcher().DisableWerewolf();
			}
		}		
	}
}
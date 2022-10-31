function ACS_WeaponDestroyInit()
{
	if ( 
	ACS_GetWeaponMode() == 0
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2
	)
	{
		ACS_HideSword();
	}

	if (thePlayer.HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}

	IgniSwordDestroy();
	QuenSwordDestroy();
	AardSwordDestroy();
	YrdenSwordDestroy();
	AxiiSwordDestroy();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroy();
	AardSecondarySwordDestroy();
	YrdenSecondarySwordDestroy();
	AxiiSecondarySwordDestroy();

	IgniBowDestroy();
	AxiiBowDestroy();
	AardBowDestroy();
	YrdenBowDestroy();
	QuenBowDestroy();

	IgniCrossbowDestroy();
	AxiiCrossbowDestroy();
	AardCrossbowDestroy();
	YrdenCrossbowDestroy();
	QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	ACS_Yrden_Sidearm_Destroy();

	ACS_Bow_Arrow().Destroy();
}

function ACS_WeaponDestroyIMMEDIATEInit()
{
	if ( 
	ACS_GetWeaponMode() == 0
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2
	)
	{
		ACS_HideSword();
	}

	if (thePlayer.HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}

	IgniSwordDestroy();
	QuenSwordDestroyIMMEDIATE();
	AardSwordDestroyIMMEDIATE();
	YrdenSwordDestroyIMMEDIATE();
	AxiiSwordDestroyIMMEDIATE();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroyIMMEDIATE();
	AardSecondarySwordDestroyIMMEDIATE();
	YrdenSecondarySwordDestroyIMMEDIATE();
	AxiiSecondarySwordDestroyIMMEDIATE();

	IgniBowDestroyIMMEDIATE();
	AxiiBowDestroyIMMEDIATE();
	AardBowDestroyIMMEDIATE();
	YrdenBowDestroyIMMEDIATE();
	QuenBowDestroyIMMEDIATE();

	IgniCrossbowDestroyIMMEDIATE();
	AxiiCrossbowDestroyIMMEDIATE();
	AardCrossbowDestroyIMMEDIATE();
	YrdenCrossbowDestroyIMMEDIATE();
	QuenCrossbowDestroyIMMEDIATE();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();

	ACS_Bow_Arrow().Destroy();
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD()
{
	if (thePlayer.HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}
	
	IgniSwordDestroy();
	QuenSwordDestroy();
	AardSwordDestroy();
	YrdenSwordDestroy();
	AxiiSwordDestroy();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroy();
	AardSecondarySwordDestroy();
	YrdenSecondarySwordDestroy();
	AxiiSecondarySwordDestroy();

	IgniBowDestroy();
	AxiiBowDestroy();
	AardBowDestroy();
	YrdenBowDestroy();
	QuenBowDestroy();

	IgniCrossbowDestroy();
	AxiiCrossbowDestroy();
	AardCrossbowDestroy();
	YrdenCrossbowDestroy();
	QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	ACS_Yrden_Sidearm_Destroy();
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE()
{
	if (thePlayer.HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}
	
	IgniSwordDestroy();
	QuenSwordDestroyIMMEDIATE();
	AardSwordDestroyIMMEDIATE();
	YrdenSwordDestroyIMMEDIATE();
	AxiiSwordDestroyIMMEDIATE();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroyIMMEDIATE();
	AardSecondarySwordDestroyIMMEDIATE();
	YrdenSecondarySwordDestroyIMMEDIATE();
	AxiiSecondarySwordDestroyIMMEDIATE();

	IgniBowDestroyIMMEDIATE();
	AxiiBowDestroyIMMEDIATE();
	AardBowDestroyIMMEDIATE();
	YrdenBowDestroyIMMEDIATE();
	QuenBowDestroyIMMEDIATE();

	IgniCrossbowDestroyIMMEDIATE();
	AxiiCrossbowDestroyIMMEDIATE();
	AardCrossbowDestroyIMMEDIATE();
	YrdenCrossbowDestroyIMMEDIATE();
	QuenCrossbowDestroyIMMEDIATE();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();
}

function ACS_Weapon_Invisible()
{
	if (!thePlayer.HasTag('ACS_HideWeaponOnDodge_Claw_Effect'))
	{
		/*
		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			if (!ACS_GetItem_VampClaw_Shades() 
			&& !thePlayer.HasTag('vampire_claws_equipped') 
			&& thePlayer.IsInCombat())
			{
				thePlayer.PlayEffectSingle('claws_effect');
				thePlayer.StopEffect('claws_effect');

				ACS_ClawEquip_OnDodge();
			}
		}
		*/

		ACS_HideSwordWitoutScabbardStuff();

		if ( ACS_GetWeaponMode() == 3)
		{
			if (!thePlayer.HasTag('blood_sucking'))
			{
				if (!thePlayer.HasTag('aard_sword_equipped') )
				{
					igni_sword_summon();
				}
			}
		}

		thePlayer.AddTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}

	if (thePlayer.HasTag('quen_sword_equipped'))
	{
		quen_sword_summon();
		QuenSwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('axii_sword_equipped'))
	{
		axii_sword_summon();
		AxiiSwordDestroy_NOTAG();	
	}
	else if (thePlayer.HasTag('aard_sword_equipped'))
	{
		aard_sword_summon();
		AardSwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('yrden_sword_equipped'))
	{
		yrden_sword_summon();
		YrdenSwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
	{
		quen_secondary_sword_summon();
		QuenSecondarySwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
	{
		axii_secondary_sword_summon();
		AxiiSecondarySwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
	{
		aard_secondary_sword_summon();
		AardSecondarySwordDestroy_NOTAG();
	}
	else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
	{
		yrden_secondary_sword_summon();
		YrdenSecondarySwordDestroy_NOTAG();
	}
}

function ACS_HideSwordWitoutScabbardStuff()
{
	var steelID, silverID 													: SItemUniqueId;
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelswordentity, silverswordentity 								: CEntity;
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
	steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( thePlayer.GetInventory().IsItemHeld(steelID) )
	{
		steelsword.SetVisible(false);

		steelswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(true);
	}
	else if ( thePlayer.GetInventory().IsItemHeld(silverID) )
	{
		silversword.SetVisible(false);

		silverswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(silverID);
		silverswordentity.SetHideInGame(true); 
	}

	thePlayer.RemoveTag('igni_sword_effect_played');

	thePlayer.RemoveTag('igni_secondary_sword_effect_played');
}

function ACS_HideSword()
{
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelID, silverID, rangedID 										: SItemUniqueId;
	var steelswordentity, silverswordentity, crossbowentity 				: CEntity;
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
		
	steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( thePlayer.GetInventory().IsItemHeld(steelID) )
	{
		steelsword.SetVisible(false);

		steelswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(true); 

		scabbards_steel.Clear();

		scabbards_steel = thePlayer.GetInventory().GetItemsByCategory('steel_scabbards');

		for ( i=0; i < scabbards_steel.Size() ; i+=1 )
		{
			scabbard_steel = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
			scabbard_steel.SetVisible(false);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (ACS_HideSwordsheathes_Enabled() || ACS_CloakEquippedCheck())
		{
			silversword.SetVisible(false);

			silverswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(silverID);
			silverswordentity.SetHideInGame(true); 

			scabbards_silver.Clear();

			scabbards_silver = thePlayer.GetInventory().GetItemsByCategory('silver_scabbards');

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(false);
			}

			crossbowentity = thePlayer.GetInventory().GetItemEntityUnsafe(rangedID);

			crossbowentity.SetHideInGame(true);
			
			thePlayer.rangedWeapon.ClearDeployedEntity(true);
		}
		
	}
	else if ( thePlayer.GetInventory().IsItemHeld(silverID) )
	{
		silversword.SetVisible(false);

		silverswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(silverID);
		silverswordentity.SetHideInGame(true); 

		scabbards_silver.Clear();

		scabbards_silver = thePlayer.GetInventory().GetItemsByCategory('silver_scabbards');

		for ( i=0; i < scabbards_silver.Size() ; i+=1 )
		{
			scabbard_silver = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
			scabbard_silver.SetVisible(false);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (ACS_HideSwordsheathes_Enabled() || ACS_CloakEquippedCheck())
		{
			steelsword.SetVisible(false);

			steelswordentity = thePlayer.GetInventory().GetItemEntityUnsafe(steelID);
			steelswordentity.SetHideInGame(true); 

			scabbards_steel.Clear();

			scabbards_steel = thePlayer.GetInventory().GetItemsByCategory('steel_scabbards');

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(false);
			}

			crossbowentity = thePlayer.GetInventory().GetItemEntityUnsafe(rangedID);

			crossbowentity.SetHideInGame(true);
			
			thePlayer.rangedWeapon.ClearDeployedEntity(true);
		}

	}

	thePlayer.RemoveTag('igni_sword_effect_played');

	thePlayer.RemoveTag('igni_secondary_sword_effect_played');
}

function ACS_ClawEquip_OnDodge()
{
	var vACS_ClawEquip_OnDodge : cACS_ClawEquip_OnDodge;
	vACS_ClawEquip_OnDodge = new cACS_ClawEquip_OnDodge in theGame;
			
	vACS_ClawEquip_OnDodge.ClawEquip_OnDodge_Engage();	
}

statemachine class cACS_ClawEquip_OnDodge
{
    function ClawEquip_OnDodge_Engage()
	{
		this.PushState('ClawEquip_OnDodge_Engage');
	}
}

state ClawEquip_OnDodge_Engage in cACS_ClawEquip_OnDodge
{
	private var claw_temp								: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = thePlayer;
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
			
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
		}
	}
}

function ClawDestroy_NOTAG()
{
	var vClawDestroy_NOTAG : cClawDestroy_NOTAG;
	vClawDestroy_NOTAG = new cClawDestroy_NOTAG in theGame;
			
	vClawDestroy_NOTAG.ClawDestroy_NOTAG_Engage();	
}

statemachine class cClawDestroy_NOTAG
{
    function ClawDestroy_NOTAG_Engage()
	{
		this.PushState('ClawDestroy_NOTAG_Engage');
	}
}

state ClawDestroy_NOTAG_Engage in cClawDestroy_NOTAG
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		//ACS_Blood_Armor_Destroy();

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			//thePlayer.PlayEffectSingle('dive_shape');
		}

		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = thePlayer;
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent", true);		

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			//thePlayer.PlayEffectSingle('claws_effect');
			//thePlayer.StopEffect('claws_effect');
		}
	}
}

function ClawDestroy()
{
	var vClawDestroy : cClawDestroy;
	vClawDestroy = new cClawDestroy in theGame;
			
	vClawDestroy.ClawDestroy_Engage();	
}

statemachine class cClawDestroy
{
    function ClawDestroy_Engage()
	{
		this.PushState('ClawDestroy_Engage');
	}
}

state ClawDestroy_Engage in cClawDestroy
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var settings								: SAnimatedComponentSlotAnimationSettings;
	private var components 								: array < CComponent >;
	private var playerccomp 							: CComponent;
	private var i										: int;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		settings.blendIn = 0;
		settings.blendOut = 1;

		ACS_Blood_Armor_Destroy();

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			thePlayer.StopEffect('dive_shape');	
			thePlayer.PlayEffectSingle('dive_shape');

			thePlayer.StopEffect('blood_color_2');
			thePlayer.PlayEffectSingle('blood_color_2');
		}

		if (!ACS_GetItem_VampClaw_Shades())
		{
			thePlayer.PlayEffectSingle('claws_effect');
			thePlayer.StopEffect('claws_effect');

			p_actor = thePlayer;
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	
				
				"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent"

				, true);	
				
			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
		}
			
		thePlayer.RemoveTag('vampire_claws_equipped');	

		if (ACS_Manual_Sword_Drawing_Check_Actual() == 0)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', false);
		}
		else if (ACS_Manual_Sword_Drawing_Check_Actual() == 1)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
			
		thePlayer.RemoveTag('ACS_blood_armor');

		thePlayer.UnblockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		thePlayer.UnblockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& thePlayer.IsAlive())
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walk_forward_dettlaff_ACS', 'PLAYER_SLOT', settings);
		}
	}
}

function ACS_Blood_Armor_Destroy()
{
	ACS_Vampire_Arms_1_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_2_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_3_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_4_Get().StopEffect('blood_color');

	ACS_Vampire_Head_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_1_Get().BreakAttachment(); 
	ACS_Vampire_Arms_1_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_1_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_2_Get().BreakAttachment(); 
	ACS_Vampire_Arms_2_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_2_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_3_Get().BreakAttachment(); 
	ACS_Vampire_Arms_3_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_3_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_4_Get().BreakAttachment(); 
	ACS_Vampire_Arms_4_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_4_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_Anchor_L_Get().BreakAttachment(); 
	ACS_Vampire_Arms_Anchor_L_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_Anchor_L_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_Anchor_R_Get().BreakAttachment(); 
	ACS_Vampire_Arms_Anchor_R_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_Anchor_R_Get().DestroyAfter(0.00125);

	ACS_Vampire_Head_Anchor_Get().BreakAttachment(); 
	ACS_Vampire_Head_Anchor_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Head_Anchor_Get().DestroyAfter(0.00125);

	ACS_Vampire_Head_Get().BreakAttachment(); 
	ACS_Vampire_Head_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Head_Get().DestroyAfter(0.00125);

	ACS_Vampire_Back_Claw_Get().BreakAttachment(); 
	ACS_Vampire_Back_Claw_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Back_Claw_Get().DestroyAfter(0.00125);

	ACS_Vampire_Claw_Anchor_Get().BreakAttachment(); 
	ACS_Vampire_Claw_Anchor_Get().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Claw_Anchor_Get().DestroyAfter(0.00125);
}

function ACS_Blood_Armor_Destroy_IMMEDIATE()
{
	ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE();

	ACS_Vampire_Back_Claw_Get().Destroy();

	ACS_Vampire_Claw_Anchor_Get().Destroy();
}

function ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE()
{
	ACS_Vampire_Arms_1_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_2_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_3_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_4_Get().StopEffect('blood_color');

	ACS_Vampire_Head_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_1_Get().Destroy();

	ACS_Vampire_Arms_2_Get().Destroy();

	ACS_Vampire_Arms_3_Get().Destroy();

	ACS_Vampire_Arms_4_Get().Destroy();

	ACS_Vampire_Arms_Anchor_L_Get().Destroy();

	ACS_Vampire_Arms_Anchor_R_Get().Destroy();

	ACS_Vampire_Head_Anchor_Get().Destroy();

	ACS_Vampire_Head_Get().Destroy();
}

function ClawDestroy_WITH_EFFECT()
{
	var vClawDestroy_WITH_EFFECT : cClawDestroy_WITH_EFFECT;
	vClawDestroy_WITH_EFFECT = new cClawDestroy_WITH_EFFECT in theGame;
			
	vClawDestroy_WITH_EFFECT.ClawDestroy_WITH_EFFECT_Engage();
}

statemachine class cClawDestroy_WITH_EFFECT
{
    function ClawDestroy_WITH_EFFECT_Engage()
	{
		this.PushState('ClawDestroy_WITH_EFFECT_Engage');
	}
}

state ClawDestroy_WITH_EFFECT_Engage in cClawDestroy_WITH_EFFECT
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var settings								: SAnimatedComponentSlotAnimationSettings;
	private var components 								: array < CComponent >;
	private var drawableComponent 						: CDrawableComponent;
	private var i										: int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		settings.blendIn = 0;
		settings.blendOut = 1;

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !thePlayer.IsInCombat()
		&& !thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& thePlayer.IsAlive())
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'Gameplay' )
			{
				thePlayer.ActivateAndSyncBehavior( 'Gameplay' );
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walk_forward_dettlaff_ACS', 'PLAYER_SLOT', settings);
		}

		ACS_Blood_Armor_Destroy();

		if ( thePlayer.HasBuff(EET_BlackBlood) )
		{
			thePlayer.StopEffect('dive_shape');	
			thePlayer.PlayEffectSingle('dive_shape');

			thePlayer.StopEffect('blood_color_2');
			thePlayer.PlayEffectSingle('blood_color_2');
		}
		
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = thePlayer;
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_ACS\data\entities\swords\vamp_claws.w2ent", true);		

			thePlayer.PlayEffectSingle('claws_effect');
			thePlayer.StopEffect('claws_effect');

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
		}
			
		thePlayer.RemoveTag('vampire_claws_equipped');	

		if (ACS_Manual_Sword_Drawing_Check_Actual() == 0)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', false);
		}
		else if (ACS_Manual_Sword_Drawing_Check_Actual() == 1)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}

		components.Clear();

		components =  thePlayer.GetComponentsByClassName ( 'CDrawableComponent' );
			
		for ( i = 0; i < components.Size(); i+=1 )
		{
			drawableComponent = ( CDrawableComponent)components[i];
			drawableComponent.SetCastingShadows ( true );
		}

		thePlayer.RemoveTag('ACS_blood_armor');

		thePlayer.UnblockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		thePlayer.UnblockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

function IgniSwordDestroy()
{
	//ACS_HideSword();
		
	thePlayer.RemoveTag('igni_sword_equipped');

	thePlayer.RemoveTag('igni_sword_equipped_TAG');

	thePlayer.RemoveTag('igni_sword_effect_played');
}
	
function IgniSecondarySwordDestroy()
{
	//ACS_HideSword();
		
	thePlayer.RemoveTag('igni_secondary_sword_equipped');

	thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');

	thePlayer.RemoveTag('igni_secondary_sword_effect_played');
}
	
function QuenSwordDestroy()
{
	quen_sword_1().BreakAttachment();
	quen_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_1().DestroyAfter(0.00125);

	quen_sword_2().BreakAttachment();
	quen_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_2().DestroyAfter(0.00125);

	quen_sword_3().BreakAttachment();
	quen_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_3().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('quen_sword_equipped');

	thePlayer.RemoveTag('quen_sword_effect_played');
}

function QuenSwordDestroyIMMEDIATE()
{
	quen_sword_1().Destroy();

	quen_sword_2().Destroy();

	quen_sword_3().Destroy();
		
	thePlayer.RemoveTag('quen_sword_equipped');

	thePlayer.RemoveTag('quen_sword_effect_played');
}

function QuenSwordDestroy_NOTAG()
{
	quen_sword_1().BreakAttachment();
	quen_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_1().DestroyAfter(0.00125);

	quen_sword_2().BreakAttachment();
	quen_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_2().DestroyAfter(0.00125);

	quen_sword_3().BreakAttachment();
	quen_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_3().DestroyAfter(0.00125);

	thePlayer.RemoveTag('quen_sword_effect_played');
}
	
function QuenSecondarySwordDestroy()
{	
	quen_secondary_sword_1().BreakAttachment(); 
	quen_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_1().DestroyAfter(0.00125);
		
	quen_secondary_sword_2().BreakAttachment(); 
	quen_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_2().DestroyAfter(0.00125);
		
	quen_secondary_sword_3().BreakAttachment(); 
	quen_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_3().DestroyAfter(0.00125);
		
	quen_secondary_sword_4().BreakAttachment(); 
	quen_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_4().DestroyAfter(0.00125);
		
	quen_secondary_sword_5().BreakAttachment(); 
	quen_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_5().DestroyAfter(0.00125);
		
	quen_secondary_sword_6().BreakAttachment(); 
	quen_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_6().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('quen_secondary_sword_equipped');

	thePlayer.RemoveTag('quen_secondary_sword_effect_played');
}

function QuenSecondarySwordDestroyIMMEDIATE()
{	
	quen_secondary_sword_1().Destroy();

	quen_secondary_sword_2().Destroy();

	quen_secondary_sword_3().Destroy();

	quen_secondary_sword_4().Destroy();

	quen_secondary_sword_5().Destroy();

	quen_secondary_sword_6().Destroy();
		
	thePlayer.RemoveTag('quen_secondary_sword_equipped');

	thePlayer.RemoveTag('quen_secondary_sword_effect_played');
}

function QuenSecondarySwordDestroy_NOTAG()
{	
	quen_secondary_sword_1().BreakAttachment(); 
	quen_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_1().DestroyAfter(0.00125);
		
	quen_secondary_sword_2().BreakAttachment(); 
	quen_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_2().DestroyAfter(0.00125);
		
	quen_secondary_sword_3().BreakAttachment(); 
	quen_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_3().DestroyAfter(0.00125);
		
	quen_secondary_sword_4().BreakAttachment(); 
	quen_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_4().DestroyAfter(0.00125);
		
	quen_secondary_sword_5().BreakAttachment(); 
	quen_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_5().DestroyAfter(0.00125);
		
	quen_secondary_sword_6().BreakAttachment(); 
	quen_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_6().DestroyAfter(0.00125);

	thePlayer.RemoveTag('quen_secondary_sword_effect_played');
}
	
function AardSwordDestroy()
{	
	aard_l_anchor_1().BreakAttachment(); 
	aard_l_anchor_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_l_anchor_1().DestroyAfter(0.00125);

	aard_r_anchor_1().BreakAttachment(); 
	aard_r_anchor_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_r_anchor_1().DestroyAfter(0.00125);

	aard_blade_1().BreakAttachment(); 
	aard_blade_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_1().DestroyAfter(0.00125);
		
	aard_blade_2().BreakAttachment(); 
	aard_blade_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_2().DestroyAfter(0.00125);
		
	aard_blade_3().BreakAttachment(); 
	aard_blade_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_3().DestroyAfter(0.00125);
		
	aard_blade_4().BreakAttachment(); 
	aard_blade_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_4().DestroyAfter(0.00125);
		
	aard_blade_5().BreakAttachment(); 
	aard_blade_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_5().DestroyAfter(0.00125);
		
	aard_blade_6().BreakAttachment(); 
	aard_blade_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_6().DestroyAfter(0.00125);

	aard_blade_7().BreakAttachment(); 
	aard_blade_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_7().DestroyAfter(0.00125);

	aard_blade_8().BreakAttachment(); 
	aard_blade_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('aard_sword_equipped');

	thePlayer.RemoveTag('aard_sword_effect_played');
}

function AardSwordDestroyIMMEDIATE()
{	
	aard_l_anchor_1().Destroy();

	aard_r_anchor_1().Destroy();

	aard_blade_1().Destroy();
		
	aard_blade_2().Destroy();

	aard_blade_3().Destroy();

	aard_blade_4().Destroy();

	aard_blade_5().Destroy();

	aard_blade_6().Destroy();

	aard_blade_7().Destroy();

	aard_blade_8().Destroy();
		
	thePlayer.RemoveTag('aard_sword_equipped');

	thePlayer.RemoveTag('aard_sword_effect_played');
}

function AardSwordDestroy_NOTAG()
{	
	aard_l_anchor_1().BreakAttachment(); 
	aard_l_anchor_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_l_anchor_1().DestroyAfter(0.00125);

	aard_r_anchor_1().BreakAttachment(); 
	aard_r_anchor_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_r_anchor_1().DestroyAfter(0.00125);

	aard_blade_1().BreakAttachment(); 
	aard_blade_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_1().DestroyAfter(0.00125);
		
	aard_blade_2().BreakAttachment(); 
	aard_blade_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_2().DestroyAfter(0.00125);
		
	aard_blade_3().BreakAttachment(); 
	aard_blade_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_3().DestroyAfter(0.00125);
		
	aard_blade_4().BreakAttachment(); 
	aard_blade_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_4().DestroyAfter(0.00125);
		
	aard_blade_5().BreakAttachment(); 
	aard_blade_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_5().DestroyAfter(0.00125);
		
	aard_blade_6().BreakAttachment(); 
	aard_blade_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_6().DestroyAfter(0.00125);

	aard_blade_7().BreakAttachment(); 
	aard_blade_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_7().DestroyAfter(0.00125);

	aard_blade_8().BreakAttachment(); 
	aard_blade_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_8().DestroyAfter(0.00125);

	thePlayer.RemoveTag('aard_sword_effect_played');
}
	
function AardSecondarySwordDestroy()
{
	aard_secondary_sword_1().BreakAttachment(); 
	aard_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_1().DestroyAfter(0.00125);
		
	aard_secondary_sword_2().BreakAttachment(); 
	aard_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_2().DestroyAfter(0.00125);
		
	aard_secondary_sword_3().BreakAttachment(); 
	aard_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_3().DestroyAfter(0.00125);
		
	aard_secondary_sword_4().BreakAttachment(); 
	aard_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_4().DestroyAfter(0.00125);
		
	aard_secondary_sword_5().BreakAttachment(); 
	aard_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_5().DestroyAfter(0.00125);
		
	aard_secondary_sword_6().BreakAttachment(); 
	aard_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_6().DestroyAfter(0.00125);

	aard_secondary_sword_7().BreakAttachment(); 
	aard_secondary_sword_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_7().DestroyAfter(0.00125);

	aard_secondary_sword_8().BreakAttachment(); 
	aard_secondary_sword_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('aard_secondary_sword_equipped');

	thePlayer.RemoveTag('aard_secondary_sword_effect_played');
}

function AardSecondarySwordDestroyIMMEDIATE()
{
	aard_secondary_sword_1().Destroy();

	aard_secondary_sword_2().Destroy();

	aard_secondary_sword_3().Destroy();

	aard_secondary_sword_4().Destroy();

	aard_secondary_sword_5().Destroy();

	aard_secondary_sword_6().Destroy();

	aard_secondary_sword_7().Destroy();

	aard_secondary_sword_8().Destroy();
		
	thePlayer.RemoveTag('aard_secondary_sword_equipped');

	thePlayer.RemoveTag('aard_secondary_sword_effect_played');
}

function AardSecondarySwordDestroy_NOTAG()
{
	aard_secondary_sword_1().BreakAttachment(); 
	aard_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_1().DestroyAfter(0.00125);
		
	aard_secondary_sword_2().BreakAttachment(); 
	aard_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_2().DestroyAfter(0.00125);
		
	aard_secondary_sword_3().BreakAttachment(); 
	aard_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_3().DestroyAfter(0.00125);
		
	aard_secondary_sword_4().BreakAttachment(); 
	aard_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_4().DestroyAfter(0.00125);
		
	aard_secondary_sword_5().BreakAttachment(); 
	aard_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_5().DestroyAfter(0.00125);
		
	aard_secondary_sword_6().BreakAttachment(); 
	aard_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_6().DestroyAfter(0.00125);

	aard_secondary_sword_7().BreakAttachment(); 
	aard_secondary_sword_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_7().DestroyAfter(0.00125);

	aard_secondary_sword_8().BreakAttachment(); 
	aard_secondary_sword_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_8().DestroyAfter(0.00125);

	thePlayer.RemoveTag('aard_secondary_sword_effect_played');
}
	
function YrdenSwordDestroy()
{
	yrden_sword_1().BreakAttachment(); 
	yrden_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_1().DestroyAfter(0.00125);
		
	yrden_sword_2().BreakAttachment(); 
	yrden_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_2().DestroyAfter(0.00125);
		
	yrden_sword_3().BreakAttachment(); 
	yrden_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_3().DestroyAfter(0.00125);
		
	yrden_sword_4().BreakAttachment(); 
	yrden_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_4().DestroyAfter(0.00125);
		
	yrden_sword_5().BreakAttachment(); 
	yrden_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_5().DestroyAfter(0.00125);
		
	yrden_sword_6().BreakAttachment(); 
	yrden_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_6().DestroyAfter(0.00125);

	yrden_sword_7().BreakAttachment(); 
	yrden_sword_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_7().DestroyAfter(0.00125);

	yrden_sword_8().BreakAttachment(); 
	yrden_sword_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('yrden_sword_equipped');

	thePlayer.RemoveTag('yrden_sword_effect_played');
}

function YrdenSwordDestroyIMMEDIATE()
{
	yrden_sword_1().Destroy();

	yrden_sword_2().Destroy();

	yrden_sword_3().Destroy();

	yrden_sword_4().Destroy();

	yrden_sword_5().Destroy();

	yrden_sword_6().Destroy();

	yrden_sword_7().Destroy();

	yrden_sword_8().Destroy();
		
	thePlayer.RemoveTag('yrden_sword_equipped');

	thePlayer.RemoveTag('yrden_sword_effect_played');
}

function YrdenSwordDestroy_NOTAG()
{
	yrden_sword_1().BreakAttachment(); 
	yrden_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_1().DestroyAfter(0.00125);
		
	yrden_sword_2().BreakAttachment(); 
	yrden_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_2().DestroyAfter(0.00125);
		
	yrden_sword_3().BreakAttachment(); 
	yrden_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_3().DestroyAfter(0.00125);
		
	yrden_sword_4().BreakAttachment(); 
	yrden_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_4().DestroyAfter(0.00125);
		
	yrden_sword_5().BreakAttachment(); 
	yrden_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_5().DestroyAfter(0.00125);
		
	yrden_sword_6().BreakAttachment(); 
	yrden_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_6().DestroyAfter(0.00125);

	yrden_sword_7().BreakAttachment(); 
	yrden_sword_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_7().DestroyAfter(0.00125);

	yrden_sword_8().BreakAttachment(); 
	yrden_sword_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_8().DestroyAfter(0.00125);

	thePlayer.RemoveTag('yrden_sword_effect_played');
}
	
function YrdenSecondarySwordDestroy()
{
	yrden_secondary_sword_1().BreakAttachment(); 
	yrden_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_1().DestroyAfter(0.00125);
		
	yrden_secondary_sword_2().BreakAttachment(); 
	yrden_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_2().DestroyAfter(0.00125);
		
	yrden_secondary_sword_3().BreakAttachment(); 
	yrden_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_3().DestroyAfter(0.00125);
		
	yrden_secondary_sword_4().BreakAttachment(); 
	yrden_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_4().DestroyAfter(0.00125);
		
	yrden_secondary_sword_5().BreakAttachment(); 
	yrden_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_5().DestroyAfter(0.00125);
		
	yrden_secondary_sword_6().BreakAttachment(); 
	yrden_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_6().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('yrden_secondary_sword_equipped');

	thePlayer.RemoveTag('yrden_secondary_sword_effect_played');
}

function YrdenSecondarySwordDestroyIMMEDIATE()
{
	yrden_secondary_sword_1().Destroy();

	yrden_secondary_sword_2().Destroy();

	yrden_secondary_sword_3().Destroy();

	yrden_secondary_sword_4().Destroy();

	yrden_secondary_sword_5().Destroy();

	yrden_secondary_sword_6().Destroy();
		
	thePlayer.RemoveTag('yrden_secondary_sword_equipped');

	thePlayer.RemoveTag('yrden_secondary_sword_effect_played');
}

function YrdenSecondarySwordDestroy_NOTAG()
{
	yrden_secondary_sword_1().BreakAttachment(); 
	yrden_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_1().DestroyAfter(0.00125);
		
	yrden_secondary_sword_2().BreakAttachment(); 
	yrden_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_2().DestroyAfter(0.00125);
		
	yrden_secondary_sword_3().BreakAttachment(); 
	yrden_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_3().DestroyAfter(0.00125);
		
	yrden_secondary_sword_4().BreakAttachment(); 
	yrden_secondary_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_4().DestroyAfter(0.00125);
		
	yrden_secondary_sword_5().BreakAttachment(); 
	yrden_secondary_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_5().DestroyAfter(0.00125);
		
	yrden_secondary_sword_6().BreakAttachment(); 
	yrden_secondary_sword_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_6().DestroyAfter(0.00125);

	thePlayer.RemoveTag('yrden_secondary_sword_effect_played');
}
	
function AxiiSwordDestroy()
{
	axii_sword_1().BreakAttachment(); 
	axii_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_1().DestroyAfter(0.00125);
		
	axii_sword_2().BreakAttachment(); 
	axii_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_2().DestroyAfter(0.00125);
		
	axii_sword_3().BreakAttachment(); 
	axii_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_3().DestroyAfter(0.00125);
		
	axii_sword_4().BreakAttachment(); 
	axii_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_4().DestroyAfter(0.00125);
		
	axii_sword_5().BreakAttachment(); 
	axii_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_5().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('axii_sword_equipped');

	thePlayer.RemoveTag('axii_sword_effect_played');
}

function AxiiSwordDestroyIMMEDIATE()
{
	axii_sword_1().Destroy();

	axii_sword_2().Destroy();

	axii_sword_3().Destroy();

	axii_sword_4().Destroy();

	axii_sword_5().Destroy();
		
	thePlayer.RemoveTag('axii_sword_equipped');

	thePlayer.RemoveTag('axii_sword_effect_played');
}

function AxiiSwordDestroy_NOTAG()
{
	axii_sword_1().BreakAttachment(); 
	axii_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_1().DestroyAfter(0.00125);
		
	axii_sword_2().BreakAttachment(); 
	axii_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_2().DestroyAfter(0.00125);
		
	axii_sword_3().BreakAttachment(); 
	axii_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_3().DestroyAfter(0.00125);
		
	axii_sword_4().BreakAttachment(); 
	axii_sword_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_4().DestroyAfter(0.00125);
		
	axii_sword_5().BreakAttachment(); 
	axii_sword_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_5().DestroyAfter(0.00125);

	thePlayer.RemoveTag('axii_sword_effect_played');
}
	
function AxiiSecondarySwordDestroy()
{
	axii_secondary_sword_1().BreakAttachment(); 
	axii_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_1().DestroyAfter(0.00125);
		
	axii_secondary_sword_2().BreakAttachment(); 
	axii_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_2().DestroyAfter(0.00125);
		
	axii_secondary_sword_3().BreakAttachment(); 
	axii_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_3().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('axii_secondary_sword_equipped');

	thePlayer.RemoveTag('axii_secondary_sword_effect_played');
}

function AxiiSecondarySwordDestroyIMMEDIATE()
{
	axii_secondary_sword_1().Destroy();

	axii_secondary_sword_2().Destroy();

	axii_secondary_sword_3().Destroy();
		
	thePlayer.RemoveTag('axii_secondary_sword_equipped');

	thePlayer.RemoveTag('axii_secondary_sword_effect_played');
}

function AxiiSecondarySwordDestroy_NOTAG()
{
	axii_secondary_sword_1().BreakAttachment(); 
	axii_secondary_sword_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_1().DestroyAfter(0.00125);
		
	axii_secondary_sword_2().BreakAttachment(); 
	axii_secondary_sword_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_2().DestroyAfter(0.00125);
		
	axii_secondary_sword_3().BreakAttachment(); 
	axii_secondary_sword_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_3().DestroyAfter(0.00125);

	thePlayer.RemoveTag('axii_secondary_sword_effect_played');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function IgniBowDestroy()
{
	igni_bow_1().BreakAttachment(); 
	igni_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_1().DestroyAfter(0.00125);
		
	igni_bow_2().BreakAttachment(); 
	igni_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_2().DestroyAfter(0.00125);
		
	igni_bow_3().BreakAttachment(); 
	igni_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_3().DestroyAfter(0.00125);
		
	igni_bow_4().BreakAttachment(); 
	igni_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_4().DestroyAfter(0.00125);
		
	igni_bow_5().BreakAttachment(); 
	igni_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_5().DestroyAfter(0.00125);
		
	igni_bow_6().BreakAttachment(); 
	igni_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_6().DestroyAfter(0.00125);

	igni_bow_7().BreakAttachment(); 
	igni_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_7().DestroyAfter(0.00125);

	igni_bow_8().BreakAttachment(); 
	igni_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('igni_bow_equipped');

	thePlayer.RemoveTag('igni_bow_effect_played');
}

function IgniBowDestroyIMMEDIATE()
{
	igni_bow_1().Destroy();

	igni_bow_2().Destroy();

	igni_bow_3().Destroy();

	igni_bow_4().Destroy();

	igni_bow_5().Destroy();

	igni_bow_6().Destroy();

	igni_bow_7().Destroy();

	igni_bow_8().Destroy();
		
	thePlayer.RemoveTag('igni_bow_equipped');

	thePlayer.RemoveTag('igni_bow_effect_played');
}

function IgniBowDestroy_NOTAG()
{
	igni_bow_1().BreakAttachment(); 
	igni_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_1().DestroyAfter(0.00125);
		
	igni_bow_2().BreakAttachment(); 
	igni_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_2().DestroyAfter(0.00125);
		
	igni_bow_3().BreakAttachment(); 
	igni_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_3().DestroyAfter(0.00125);
		
	igni_bow_4().BreakAttachment(); 
	igni_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_4().DestroyAfter(0.00125);
		
	igni_bow_5().BreakAttachment(); 
	igni_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_5().DestroyAfter(0.00125);
		
	igni_bow_6().BreakAttachment(); 
	igni_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_6().DestroyAfter(0.00125);

	igni_bow_7().BreakAttachment(); 
	igni_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_7().DestroyAfter(0.00125);

	igni_bow_8().BreakAttachment(); 
	igni_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_8().DestroyAfter(0.00125);
}

function AxiiBowDestroy()
{
	axii_bow_1().BreakAttachment(); 
	axii_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_1().DestroyAfter(0.00125);
		
	axii_bow_2().BreakAttachment(); 
	axii_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_2().DestroyAfter(0.00125);
		
	axii_bow_3().BreakAttachment(); 
	axii_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_3().DestroyAfter(0.00125);
		
	axii_bow_4().BreakAttachment(); 
	axii_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_4().DestroyAfter(0.00125);
		
	axii_bow_5().BreakAttachment(); 
	axii_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_5().DestroyAfter(0.00125);
		
	axii_bow_6().BreakAttachment(); 
	axii_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_6().DestroyAfter(0.00125);

	axii_bow_7().BreakAttachment(); 
	axii_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_7().DestroyAfter(0.00125);

	axii_bow_8().BreakAttachment(); 
	axii_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('axii_bow_equipped');

	thePlayer.RemoveTag('axii_bow_effect_played');
}

function AxiiBowDestroyIMMEDIATE()
{
	axii_bow_1().Destroy();

	axii_bow_2().Destroy();

	axii_bow_3().Destroy();

	axii_bow_4().Destroy();

	axii_bow_5().Destroy();

	axii_bow_6().Destroy();

	axii_bow_7().Destroy();

	axii_bow_8().Destroy();
		
	thePlayer.RemoveTag('axii_bow_equipped');

	thePlayer.RemoveTag('axii_bow_effect_played');
}

function AxiiBowDestroy_NOTAG()
{
	axii_bow_1().BreakAttachment(); 
	axii_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_1().DestroyAfter(0.00125);
		
	axii_bow_2().BreakAttachment(); 
	axii_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_2().DestroyAfter(0.00125);
		
	axii_bow_3().BreakAttachment(); 
	axii_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_3().DestroyAfter(0.00125);
		
	axii_bow_4().BreakAttachment(); 
	axii_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_4().DestroyAfter(0.00125);
		
	axii_bow_5().BreakAttachment(); 
	axii_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_5().DestroyAfter(0.00125);
		
	axii_bow_6().BreakAttachment(); 
	axii_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_6().DestroyAfter(0.00125);

	axii_bow_7().BreakAttachment(); 
	axii_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_7().DestroyAfter(0.00125);

	axii_bow_8().BreakAttachment(); 
	axii_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_8().DestroyAfter(0.00125);
}

function AardBowDestroy()
{
	aard_bow_1().BreakAttachment(); 
	aard_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_1().DestroyAfter(0.00125);
		
	aard_bow_2().BreakAttachment(); 
	aard_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_2().DestroyAfter(0.00125);
		
	aard_bow_3().BreakAttachment(); 
	aard_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_3().DestroyAfter(0.00125);
		
	aard_bow_4().BreakAttachment(); 
	aard_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_4().DestroyAfter(0.00125);
		
	aard_bow_5().BreakAttachment(); 
	aard_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_5().DestroyAfter(0.00125);
		
	aard_bow_6().BreakAttachment(); 
	aard_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_6().DestroyAfter(0.00125);

	aard_bow_7().BreakAttachment(); 
	aard_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_7().DestroyAfter(0.00125);

	aard_bow_8().BreakAttachment(); 
	aard_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('aard_bow_equipped');

	thePlayer.RemoveTag('aard_bow_effect_played');
}

function AardBowDestroyIMMEDIATE()
{
	aard_bow_1().Destroy();

	aard_bow_2().Destroy();

	aard_bow_3().Destroy();

	aard_bow_4().Destroy();
	
	aard_bow_5().Destroy();

	aard_bow_6().Destroy();

	aard_bow_7().Destroy();

	aard_bow_8().Destroy();
		
	thePlayer.RemoveTag('aard_bow_equipped');

	thePlayer.RemoveTag('aard_bow_effect_played');
}

function AardBowDestroy_NOTAG()
{
	aard_bow_1().BreakAttachment(); 
	aard_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_1().DestroyAfter(0.00125);
		
	aard_bow_2().BreakAttachment(); 
	aard_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_2().DestroyAfter(0.00125);
		
	aard_bow_3().BreakAttachment(); 
	aard_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_3().DestroyAfter(0.00125);
		
	aard_bow_4().BreakAttachment(); 
	aard_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_4().DestroyAfter(0.00125);
		
	aard_bow_5().BreakAttachment(); 
	aard_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_5().DestroyAfter(0.00125);
		
	aard_bow_6().BreakAttachment(); 
	aard_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_6().DestroyAfter(0.00125);

	aard_bow_7().BreakAttachment(); 
	aard_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_7().DestroyAfter(0.00125);

	aard_bow_8().BreakAttachment(); 
	aard_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_8().DestroyAfter(0.00125);
}

function YrdenBowDestroy()
{
	yrden_bow_1().BreakAttachment(); 
	yrden_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_1().DestroyAfter(0.00125);
		
	yrden_bow_2().BreakAttachment(); 
	yrden_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_2().DestroyAfter(0.00125);
		
	yrden_bow_3().BreakAttachment(); 
	yrden_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_3().DestroyAfter(0.00125);
		
	yrden_bow_4().BreakAttachment(); 
	yrden_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_4().DestroyAfter(0.00125);
		
	yrden_bow_5().BreakAttachment(); 
	yrden_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_5().DestroyAfter(0.00125);
		
	yrden_bow_6().BreakAttachment(); 
	yrden_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_6().DestroyAfter(0.00125);

	yrden_bow_7().BreakAttachment(); 
	yrden_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_7().DestroyAfter(0.00125);

	yrden_bow_8().BreakAttachment(); 
	yrden_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('yrden_bow_equipped');

	thePlayer.RemoveTag('yrden_bow_effect_played');
}

function YrdenBowDestroyIMMEDIATE()
{
	yrden_bow_1().Destroy();

	yrden_bow_2().Destroy();

	yrden_bow_3().Destroy();

	yrden_bow_4().Destroy();

	yrden_bow_5().Destroy();

	yrden_bow_6().Destroy();

	yrden_bow_7().Destroy();

	yrden_bow_8().Destroy();
		
	thePlayer.RemoveTag('yrden_bow_equipped');

	thePlayer.RemoveTag('yrden_bow_effect_played');
}

function YrdenBowDestroy_NOTAG()
{
	yrden_bow_1().BreakAttachment(); 
	yrden_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_1().DestroyAfter(0.00125);
		
	yrden_bow_2().BreakAttachment(); 
	yrden_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_2().DestroyAfter(0.00125);
		
	yrden_bow_3().BreakAttachment(); 
	yrden_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_3().DestroyAfter(0.00125);
		
	yrden_bow_4().BreakAttachment(); 
	yrden_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_4().DestroyAfter(0.00125);
		
	yrden_bow_5().BreakAttachment(); 
	yrden_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_5().DestroyAfter(0.00125);
		
	yrden_bow_6().BreakAttachment(); 
	yrden_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_6().DestroyAfter(0.00125);

	yrden_bow_7().BreakAttachment(); 
	yrden_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_7().DestroyAfter(0.00125);

	yrden_bow_8().BreakAttachment(); 
	yrden_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_8().DestroyAfter(0.00125);
}

function QuenBowDestroy()
{
	quen_bow_1().BreakAttachment(); 
	quen_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_1().DestroyAfter(0.00125);
		
	quen_bow_2().BreakAttachment(); 
	quen_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_2().DestroyAfter(0.00125);
		
	quen_bow_3().BreakAttachment(); 
	quen_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_3().DestroyAfter(0.00125);
		
	quen_bow_4().BreakAttachment(); 
	quen_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_4().DestroyAfter(0.00125);
		
	quen_bow_5().BreakAttachment(); 
	quen_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_5().DestroyAfter(0.00125);
		
	quen_bow_6().BreakAttachment(); 
	quen_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_6().DestroyAfter(0.00125);

	quen_bow_7().BreakAttachment(); 
	quen_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_7().DestroyAfter(0.00125);

	quen_bow_8().BreakAttachment(); 
	quen_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('quen_bow_equipped');

	thePlayer.RemoveTag('quen_bow_effect_played');
}

function QuenBowDestroyIMMEDIATE()
{
	quen_bow_1().Destroy();
	
	quen_bow_2().Destroy();
	
	quen_bow_3().Destroy();

	quen_bow_4().Destroy();

	quen_bow_5().Destroy();

	quen_bow_6().Destroy();

	quen_bow_7().Destroy();

	quen_bow_8().Destroy();
		
	thePlayer.RemoveTag('quen_bow_equipped');

	thePlayer.RemoveTag('quen_bow_effect_played');
}

function QuenBowDestroy_NOTAG()
{
	quen_bow_1().BreakAttachment(); 
	quen_bow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_1().DestroyAfter(0.00125);
		
	quen_bow_2().BreakAttachment(); 
	quen_bow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_2().DestroyAfter(0.00125);
		
	quen_bow_3().BreakAttachment(); 
	quen_bow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_3().DestroyAfter(0.00125);
		
	quen_bow_4().BreakAttachment(); 
	quen_bow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_4().DestroyAfter(0.00125);
		
	quen_bow_5().BreakAttachment(); 
	quen_bow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_5().DestroyAfter(0.00125);
		
	quen_bow_6().BreakAttachment(); 
	quen_bow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_6().DestroyAfter(0.00125);

	quen_bow_7().BreakAttachment(); 
	quen_bow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_7().DestroyAfter(0.00125);

	quen_bow_8().BreakAttachment(); 
	quen_bow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_8().DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function IgniCrossbowDestroy()
{
	igni_crossbow_1().BreakAttachment(); 
	igni_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_1().DestroyAfter(0.00125);
		
	igni_crossbow_2().BreakAttachment(); 
	igni_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_2().DestroyAfter(0.00125);
		
	igni_crossbow_3().BreakAttachment(); 
	igni_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_3().DestroyAfter(0.00125);
		
	igni_crossbow_4().BreakAttachment(); 
	igni_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_4().DestroyAfter(0.00125);
		
	igni_crossbow_5().BreakAttachment(); 
	igni_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_5().DestroyAfter(0.00125);
		
	igni_crossbow_6().BreakAttachment(); 
	igni_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_6().DestroyAfter(0.00125);

	igni_crossbow_7().BreakAttachment(); 
	igni_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_7().DestroyAfter(0.00125);

	igni_crossbow_8().BreakAttachment(); 
	igni_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('igni_crossbow_equipped');

	thePlayer.RemoveTag('igni_crossbow_effect_played');
}

function IgniCrossbowDestroyIMMEDIATE()
{
	igni_crossbow_1().Destroy();

	igni_crossbow_2().Destroy();

	igni_crossbow_3().Destroy();

	igni_crossbow_4().Destroy();

	igni_crossbow_5().Destroy();

	igni_crossbow_6().Destroy();

	igni_crossbow_7().Destroy();

	igni_crossbow_8().Destroy();
		
	thePlayer.RemoveTag('igni_crossbow_equipped');

	thePlayer.RemoveTag('igni_crossbow_effect_played');
}

function IgniCrossbowDestroy_NOTAG()
{
	igni_crossbow_1().BreakAttachment(); 
	igni_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_1().DestroyAfter(0.00125);
		
	igni_crossbow_2().BreakAttachment(); 
	igni_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_2().DestroyAfter(0.00125);
		
	igni_crossbow_3().BreakAttachment(); 
	igni_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_3().DestroyAfter(0.00125);
		
	igni_crossbow_4().BreakAttachment(); 
	igni_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_4().DestroyAfter(0.00125);
		
	igni_crossbow_5().BreakAttachment(); 
	igni_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_5().DestroyAfter(0.00125);
		
	igni_crossbow_6().BreakAttachment(); 
	igni_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_6().DestroyAfter(0.00125);

	igni_crossbow_7().BreakAttachment(); 
	igni_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_7().DestroyAfter(0.00125);

	igni_crossbow_8().BreakAttachment(); 
	igni_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_8().DestroyAfter(0.00125);
}

function AxiiCrossbowDestroy()
{
	axii_crossbow_1().BreakAttachment(); 
	axii_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_1().DestroyAfter(0.00125);
		
	axii_crossbow_2().BreakAttachment(); 
	axii_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_2().DestroyAfter(0.00125);
		
	axii_crossbow_3().BreakAttachment(); 
	axii_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_3().DestroyAfter(0.00125);
		
	axii_crossbow_4().BreakAttachment(); 
	axii_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_4().DestroyAfter(0.00125);
		
	axii_crossbow_5().BreakAttachment(); 
	axii_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_5().DestroyAfter(0.00125);
		
	axii_crossbow_6().BreakAttachment(); 
	axii_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_6().DestroyAfter(0.00125);

	axii_crossbow_7().BreakAttachment(); 
	axii_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_7().DestroyAfter(0.00125);

	axii_crossbow_8().BreakAttachment(); 
	axii_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('axii_crossbow_equipped');

	thePlayer.RemoveTag('axii_crossbow_effect_played');
}

function AxiiCrossbowDestroyIMMEDIATE()
{
	axii_crossbow_1().Destroy();
	
	axii_crossbow_2().Destroy();

	axii_crossbow_3().Destroy();

	axii_crossbow_4().Destroy();

	axii_crossbow_5().Destroy();

	axii_crossbow_6().Destroy();

	axii_crossbow_7().Destroy();

	axii_crossbow_8().Destroy();
		
	thePlayer.RemoveTag('axii_crossbow_equipped');

	thePlayer.RemoveTag('axii_crossbow_effect_played');
}

function AxiiCrossbowDestroy_NOTAG()
{
	axii_crossbow_1().BreakAttachment(); 
	axii_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_1().DestroyAfter(0.00125);
		
	axii_crossbow_2().BreakAttachment(); 
	axii_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_2().DestroyAfter(0.00125);
		
	axii_crossbow_3().BreakAttachment(); 
	axii_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_3().DestroyAfter(0.00125);
		
	axii_crossbow_4().BreakAttachment(); 
	axii_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_4().DestroyAfter(0.00125);
		
	axii_crossbow_5().BreakAttachment(); 
	axii_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_5().DestroyAfter(0.00125);
		
	axii_crossbow_6().BreakAttachment(); 
	axii_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_6().DestroyAfter(0.00125);

	axii_crossbow_7().BreakAttachment(); 
	axii_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_7().DestroyAfter(0.00125);

	axii_crossbow_8().BreakAttachment(); 
	axii_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_8().DestroyAfter(0.00125);
}

function AardCrossbowDestroy()
{
	aard_crossbow_1().BreakAttachment(); 
	aard_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_1().DestroyAfter(0.00125);
		
	aard_crossbow_2().BreakAttachment(); 
	aard_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_2().DestroyAfter(0.00125);
		
	aard_crossbow_3().BreakAttachment(); 
	aard_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_3().DestroyAfter(0.00125);
		
	aard_crossbow_4().BreakAttachment(); 
	aard_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_4().DestroyAfter(0.00125);
		
	aard_crossbow_5().BreakAttachment(); 
	aard_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_5().DestroyAfter(0.00125);
		
	aard_crossbow_6().BreakAttachment(); 
	aard_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_6().DestroyAfter(0.00125);

	aard_crossbow_7().BreakAttachment(); 
	aard_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_7().DestroyAfter(0.00125);

	aard_crossbow_8().BreakAttachment(); 
	aard_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('aard_crossbow_equipped');

	thePlayer.RemoveTag('aard_crossbow_effect_played');
}

function AardCrossbowDestroyIMMEDIATE()
{
	aard_crossbow_1().Destroy();

	aard_crossbow_2().Destroy();

	aard_crossbow_3().Destroy();

	aard_crossbow_4().Destroy();

	aard_crossbow_5().Destroy();

	aard_crossbow_6().Destroy();

	aard_crossbow_7().Destroy();

	aard_crossbow_8().Destroy();
		
	thePlayer.RemoveTag('aard_crossbow_equipped');

	thePlayer.RemoveTag('aard_crossbow_effect_played');
}

function AardCrossbowDestroy_NOTAG()
{
	aard_crossbow_1().BreakAttachment(); 
	aard_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_1().DestroyAfter(0.00125);
		
	aard_crossbow_2().BreakAttachment(); 
	aard_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_2().DestroyAfter(0.00125);
		
	aard_crossbow_3().BreakAttachment(); 
	aard_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_3().DestroyAfter(0.00125);
		
	aard_crossbow_4().BreakAttachment(); 
	aard_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_4().DestroyAfter(0.00125);
		
	aard_crossbow_5().BreakAttachment(); 
	aard_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_5().DestroyAfter(0.00125);
		
	aard_crossbow_6().BreakAttachment(); 
	aard_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_6().DestroyAfter(0.00125);

	aard_crossbow_7().BreakAttachment(); 
	aard_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_7().DestroyAfter(0.00125);

	aard_crossbow_8().BreakAttachment(); 
	aard_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_8().DestroyAfter(0.00125);
}

function YrdenCrossbowDestroy()
{
	yrden_crossbow_1().BreakAttachment(); 
	yrden_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_1().DestroyAfter(0.00125);
		
	yrden_crossbow_2().BreakAttachment(); 
	yrden_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_2().DestroyAfter(0.00125);
		
	yrden_crossbow_3().BreakAttachment(); 
	yrden_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_3().DestroyAfter(0.00125);
		
	yrden_crossbow_4().BreakAttachment(); 
	yrden_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_4().DestroyAfter(0.00125);
		
	yrden_crossbow_5().BreakAttachment(); 
	yrden_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_5().DestroyAfter(0.00125);
		
	yrden_crossbow_6().BreakAttachment(); 
	yrden_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_6().DestroyAfter(0.00125);

	yrden_crossbow_7().BreakAttachment(); 
	yrden_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_7().DestroyAfter(0.00125);

	yrden_crossbow_8().BreakAttachment(); 
	yrden_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('yrden_crossbow_equipped');

	thePlayer.RemoveTag('yrden_crossbow_effect_played');
}

function YrdenCrossbowDestroyIMMEDIATE()
{
	yrden_crossbow_1().Destroy();

	yrden_crossbow_2().Destroy();

	yrden_crossbow_3().Destroy();

	yrden_crossbow_4().Destroy();

	yrden_crossbow_5().Destroy();
		
	yrden_crossbow_6().Destroy();

	yrden_crossbow_7().Destroy();

	yrden_crossbow_8().Destroy();
		
	thePlayer.RemoveTag('yrden_crossbow_equipped');

	thePlayer.RemoveTag('yrden_crossbow_effect_played');
}

function YrdenCrossbowDestroy_NOTAG()
{
	yrden_crossbow_1().BreakAttachment(); 
	yrden_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_1().DestroyAfter(0.00125);
		
	yrden_crossbow_2().BreakAttachment(); 
	yrden_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_2().DestroyAfter(0.00125);
		
	yrden_crossbow_3().BreakAttachment(); 
	yrden_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_3().DestroyAfter(0.00125);
		
	yrden_crossbow_4().BreakAttachment(); 
	yrden_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_4().DestroyAfter(0.00125);
		
	yrden_crossbow_5().BreakAttachment(); 
	yrden_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_5().DestroyAfter(0.00125);
		
	yrden_crossbow_6().BreakAttachment(); 
	yrden_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_6().DestroyAfter(0.00125);

	yrden_crossbow_7().BreakAttachment(); 
	yrden_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_7().DestroyAfter(0.00125);

	yrden_crossbow_8().BreakAttachment(); 
	yrden_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_8().DestroyAfter(0.00125);
}

function QuenCrossbowDestroy()
{
	quen_crossbow_1().BreakAttachment(); 
	quen_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_1().DestroyAfter(0.00125);
		
	quen_crossbow_2().BreakAttachment(); 
	quen_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_2().DestroyAfter(0.00125);
		
	quen_crossbow_3().BreakAttachment(); 
	quen_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_3().DestroyAfter(0.00125);
		
	quen_crossbow_4().BreakAttachment(); 
	quen_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_4().DestroyAfter(0.00125);
		
	quen_crossbow_5().BreakAttachment(); 
	quen_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_5().DestroyAfter(0.00125);
		
	quen_crossbow_6().BreakAttachment(); 
	quen_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_6().DestroyAfter(0.00125);

	quen_crossbow_7().BreakAttachment(); 
	quen_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_7().DestroyAfter(0.00125);

	quen_crossbow_8().BreakAttachment(); 
	quen_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_8().DestroyAfter(0.00125);
		
	thePlayer.RemoveTag('quen_crossbow_equipped');

	thePlayer.RemoveTag('quen_crossbow_effect_played');
}

function QuenCrossbowDestroyIMMEDIATE()
{
	quen_crossbow_1().Destroy();

	quen_crossbow_2().Destroy();

	quen_crossbow_3().Destroy();

	quen_crossbow_4().Destroy();

	quen_crossbow_5().Destroy();

	quen_crossbow_6().Destroy();

	quen_crossbow_7().Destroy();

	quen_crossbow_8().Destroy();
		
	thePlayer.RemoveTag('quen_crossbow_equipped');

	thePlayer.RemoveTag('quen_crossbow_effect_played');
}

function QuenCrossbowDestroy_NOTAG()
{
	quen_crossbow_1().BreakAttachment(); 
	quen_crossbow_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_1().DestroyAfter(0.00125);
		
	quen_crossbow_2().BreakAttachment(); 
	quen_crossbow_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_2().DestroyAfter(0.00125);
		
	quen_crossbow_3().BreakAttachment(); 
	quen_crossbow_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_3().DestroyAfter(0.00125);
		
	quen_crossbow_4().BreakAttachment(); 
	quen_crossbow_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_4().DestroyAfter(0.00125);
		
	quen_crossbow_5().BreakAttachment(); 
	quen_crossbow_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_5().DestroyAfter(0.00125);
		
	quen_crossbow_6().BreakAttachment(); 
	quen_crossbow_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_6().DestroyAfter(0.00125);

	quen_crossbow_7().BreakAttachment(); 
	quen_crossbow_7().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_7().DestroyAfter(0.00125);

	quen_crossbow_8().BreakAttachment(); 
	quen_crossbow_8().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_8().DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function HybridTagRemoval()
{
	if (thePlayer.HasTag('HybridDefaultWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridDefaultWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridDefaultSecondaryWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridDefaultSecondaryWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridEredinWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridEredinWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridClawWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridClawWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridImlerithWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridImlerithWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridOlgierdWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridOlgierdWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridSpearWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridSpearWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridGregWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridGregWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridAxeWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridAxeWeaponTicket');
	}
	else if (thePlayer.HasTag('HybridGiantWeaponTicket'))
	{
		thePlayer.RemoveTag('HybridGiantWeaponTicket');
	}
}
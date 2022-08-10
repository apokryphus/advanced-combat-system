function ACS_Dodge()
{
	var vACS_Dodge : cACS_Dodge;
	vACS_Dodge = new cACS_Dodge in theGame;
	
	if ( ACS_Enabled()
	&& ACS_DodgeEffects_Enabled())
	{
		if (!thePlayer.IsCiri()
		&& !thePlayer.IsPerformingFinisher()
		&& !thePlayer.HasTag('in_wraith')
		&& !thePlayer.HasTag('blood_sucking')
		)
		{	
			vACS_Dodge.ACS_Dodge_Engage();
		}
	}
}

statemachine class cACS_Dodge
{
    function ACS_Dodge_Engage()
	{
		this.PushState('ACS_Dodge_Engage');
	}
}

state ACS_Dodge_Engage in cACS_Dodge
{
	private var teleport_fx								: CEntity;
	private var i 										: int;
    private var npc     								: CNewNPC;
	private var actor       							: CActor;
	private var actors 									: array< CActor >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		Dodge();
	}
	
	entry function Dodge()
	{
		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.PlayEffect( 'magic_step_l' );
			thePlayer.StopEffect( 'magic_step_l' );	

			thePlayer.PlayEffect( 'magic_step_r' );
			thePlayer.StopEffect( 'magic_step_r' );	

			thePlayer.PlayEffect( 'bruxa_dash_trails' );
			thePlayer.StopEffect( 'bruxa_dash_trails' );
		}
		
		//Dodge_Effects();
	}
	
	latent function Dodge_Effects()
	{
		if ( ACS_GetWeaponMode() == 0 )
		{	
			if (thePlayer.IsAnyWeaponHeld())
			{
				if (!thePlayer.IsWeaponHeld( 'fist' ))
				{
					if (thePlayer.GetEquippedSign() == ST_Igni )
					{
						if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
						{
							FireDodge();
						}
						else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
						{
							IceDodge();
						}
						else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
						{
							BloodDodge();
						}
						else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (thePlayer.GetEquippedSign() == ST_Axii )
					{
						if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
						{
							FireDodge();
						}
						else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
						{
							IceDodge();
						}
						else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
						{
							BloodDodge();
						}
						else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (thePlayer.GetEquippedSign() == ST_Aard )
					{
						if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
						{
							FireDodge();
						}
						else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
						{
							IceDodge();
						}
						else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
						{
							BloodDodge();
						}
						else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (thePlayer.GetEquippedSign() == ST_Yrden )
					{
						if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
						{
							FireDodge();
						}
						else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
						{
							IceDodge();
						}
						else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
						{
							BloodDodge();
						}
						else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (thePlayer.GetEquippedSign() == ST_Quen )
					{
						if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
						{
							FireDodge();
						}
						else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
						{
							IceDodge();
						}
						else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
						{
							BloodDodge();
						}
						else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
						{
							ParalyzeDodge();
						}
					}
				}
				else if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped') )
				{
					BloodDodge();
				}
			}
		}
		else if ( ACS_GetWeaponMode() == 1 )
		{
			if ( 
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped') 
			)
			{
				ShadowDodge();
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped') 
			)
			{
				BloodDodge();
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}	
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
			|| ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
			)
			{
				FireDodge();	
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 6  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_GetFocusModeSilverWeapon() == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			)
			{
				FireDodge();	
			}
			else if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped') )
			{
				BloodDodge();	
			}
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if ( 
			ACS_GetItem_Olgierd_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetItem_Olgierd_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
			)
			{
				ShadowDodge();
			}
			else if ( 
			ACS_GetItem_Claws_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetItem_Claws_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
			)
			{
				BloodDodge();
			}
			else if ( 
			ACS_GetItem_Eredin_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetItem_Eredin_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_GetItem_Imlerith_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetItem_Imlerith_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}	
			else if ( 
			ACS_GetItem_Spear_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetItem_Spear_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
			)
			{
				ShadowDodge();	
			}
			else if ( 
			ACS_GetItem_Greg_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetItem_Greg_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_GetItem_Hammer_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetItem_Hammer_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_GetItem_Axe_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetItem_Axe_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}
			else if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped') )
			{
				BloodDodge();	
			}
		}
	}

	latent function FireDodge()
	{
		if (thePlayer.GetEquippedSign() == ST_Igni )
		{
			thePlayer.PlayEffect('fire_hit');
			thePlayer.StopEffect('fire_hit');
		}
		else if (thePlayer.GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			teleport_fx.PlayEffect('disappear');
			thePlayer.SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (thePlayer.GetEquippedSign() == ST_Aard )
		{
			thePlayer.PlayEffect('trap_attack_smoke');
			thePlayer.StopEffect('trap_attack_smoke');
							
			thePlayer.PlayEffect('move_trail');
			thePlayer.StopEffect('move_trail');
							
			thePlayer.PlayEffect('roll_dettlaff_flesh');
			thePlayer.StopEffect('roll_dettlaff_flesh');
		}
		else if (thePlayer.GetEquippedSign() == ST_Yrden )
		{
			thePlayer.PlayEffect('special_attack_steps');
			thePlayer.StopEffect('special_attack_steps');
							
			thePlayer.PlayEffect('yrden_shock');
			thePlayer.StopEffect('yrden_shock');
		}
		else if (thePlayer.GetEquippedSign() == ST_Quen )
		{
			thePlayer.PlayEffect( 'special_attack_only_black_fx' );
			thePlayer.StopEffect( 'special_attack_only_black_fx' );
							
			thePlayer.PlayEffect('hit_electric');
			thePlayer.StopEffect('hit_electric');
		}
		
						
		//thePlayer.PlayEffect('fire_blowing');
		//thePlayer.StopEffect('fire_blowing');
						
		//thePlayer.PlayEffect('fire_blowing_2');
		//thePlayer.StopEffect('fire_blowing_2');
						
		if( RandF() < 0.1 ) 
		{
			actors = GetActorsInRange(thePlayer, 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Burning ) )
						{
							npc.AddEffectDefault( EET_Burning, npc, 'acs_dodge_buffs' );
						}										
					}
				}		
			}
		}
	}

	latent function IceDodge()
	{
		if (thePlayer.GetEquippedSign() == ST_Igni )
		{
			thePlayer.PlayEffect('fire_hit');
			thePlayer.StopEffect('fire_hit');
		}
		else if (thePlayer.GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			teleport_fx.PlayEffect('disappear');
			thePlayer.SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (thePlayer.GetEquippedSign() == ST_Aard )
		{
			thePlayer.PlayEffect('trap_attack_smoke');
			thePlayer.StopEffect('trap_attack_smoke');
							
			thePlayer.PlayEffect('move_trail');
			thePlayer.StopEffect('move_trail');
							
			thePlayer.PlayEffect('roll_dettlaff_flesh');
			thePlayer.StopEffect('roll_dettlaff_flesh');
		}
		else if (thePlayer.GetEquippedSign() == ST_Yrden )
		{
			thePlayer.PlayEffect('special_attack_steps');
			thePlayer.StopEffect('special_attack_steps');
							
			thePlayer.PlayEffect('yrden_shock');
			thePlayer.StopEffect('yrden_shock');
		}
		else if (thePlayer.GetEquippedSign() == ST_Quen )
		{
			thePlayer.PlayEffect( 'special_attack_only_black_fx' );
			thePlayer.StopEffect( 'special_attack_only_black_fx' );
							
			thePlayer.PlayEffect('hit_electric');
			thePlayer.StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors = GetActorsInRange(thePlayer, 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_SlowdownFrost ) )
						{
							npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_dodge_buffs' );
						}										
					}
				}		
			}
		}
	}

	latent function BloodDodge()
	{
		if (thePlayer.GetEquippedSign() == ST_Igni )
		{
			thePlayer.PlayEffect('fire_hit');
			thePlayer.StopEffect('fire_hit');
		}
		else if (thePlayer.GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			teleport_fx.PlayEffect('disappear');
			thePlayer.SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (thePlayer.GetEquippedSign() == ST_Aard )
		{
			thePlayer.PlayEffect('trap_attack_smoke');
			thePlayer.StopEffect('trap_attack_smoke');
							
			thePlayer.PlayEffect('move_trail');
			thePlayer.StopEffect('move_trail');
							
			thePlayer.PlayEffect('roll_dettlaff_flesh');
			thePlayer.StopEffect('roll_dettlaff_flesh');
		}
		else if (thePlayer.GetEquippedSign() == ST_Yrden )
		{
			thePlayer.PlayEffect('special_attack_steps');
			thePlayer.StopEffect('special_attack_steps');
							
			thePlayer.PlayEffect('yrden_shock');
			thePlayer.StopEffect('yrden_shock');
		}
		else if (thePlayer.GetEquippedSign() == ST_Quen )
		{
			thePlayer.PlayEffect( 'special_attack_only_black_fx' );
			thePlayer.StopEffect( 'special_attack_only_black_fx' );
							
			thePlayer.PlayEffect('hit_electric');
			thePlayer.StopEffect('hit_electric');
		}

		if( RandF() < 0.1 ) 
		{
			actors = GetActorsInRange(thePlayer, 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{										
						if( !npc.HasBuff( EET_Bleeding ) )
						{
							npc.AddEffectDefault( EET_Bleeding, npc, 'acs_dodge_buffs' );	
						}
					}
				}		
			}
		}
	}

	latent function ParalyzeDodge()
	{
		if (thePlayer.GetEquippedSign() == ST_Igni )
		{
			thePlayer.PlayEffect('fire_hit');
			thePlayer.StopEffect('fire_hit');
		}
		else if (thePlayer.GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			teleport_fx.PlayEffect('disappear');
			thePlayer.SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (thePlayer.GetEquippedSign() == ST_Aard )
		{
			thePlayer.PlayEffect('trap_attack_smoke');
			thePlayer.StopEffect('trap_attack_smoke');
							
			thePlayer.PlayEffect('move_trail');
			thePlayer.StopEffect('move_trail');
							
			thePlayer.PlayEffect('roll_dettlaff_flesh');
			thePlayer.StopEffect('roll_dettlaff_flesh');
		}
		else if (thePlayer.GetEquippedSign() == ST_Yrden )
		{
			thePlayer.PlayEffect('special_attack_steps');
			thePlayer.StopEffect('special_attack_steps');
							
			thePlayer.PlayEffect('yrden_shock');
			thePlayer.StopEffect('yrden_shock');
		}
		else if (thePlayer.GetEquippedSign() == ST_Quen )
		{
			thePlayer.PlayEffect( 'special_attack_only_black_fx' );
			thePlayer.StopEffect( 'special_attack_only_black_fx' );
							
			thePlayer.PlayEffect('hit_electric');
			thePlayer.StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors = GetActorsInRange(thePlayer, 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Paralyzed ) )
						{
							npc.AddEffectDefault( EET_Paralyzed, npc, 'acs_dodge_buffs' );	
						}
					}
									
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Slowdown ) )
						{
							npc.AddEffectDefault( EET_Slowdown, npc, 'acs_dodge_buffs' );	
						}
					}
				}		
			}
		}
	}

	latent function ShadowDodge()
	{
		if (thePlayer.GetEquippedSign() == ST_Igni )
		{
			thePlayer.PlayEffect('fire_hit');
			thePlayer.StopEffect('fire_hit');
		}
		else if (thePlayer.GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			teleport_fx.PlayEffect('disappear');
			thePlayer.SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (thePlayer.GetEquippedSign() == ST_Aard )
		{
			thePlayer.PlayEffect('trap_attack_smoke');
			thePlayer.StopEffect('trap_attack_smoke');
							
			thePlayer.PlayEffect('move_trail');
			thePlayer.StopEffect('move_trail');
							
			thePlayer.PlayEffect('roll_dettlaff_flesh');
			thePlayer.StopEffect('roll_dettlaff_flesh');
		}
		else if (thePlayer.GetEquippedSign() == ST_Yrden )
		{
			thePlayer.PlayEffect('special_attack_steps');
			thePlayer.StopEffect('special_attack_steps');
							
			thePlayer.PlayEffect('yrden_shock');
			thePlayer.StopEffect('yrden_shock');
		}
		else if (thePlayer.GetEquippedSign() == ST_Quen )
		{
			thePlayer.PlayEffect( 'special_attack_only_black_fx' );
			thePlayer.StopEffect( 'special_attack_only_black_fx' );
							
			thePlayer.PlayEffect('hit_electric');
			thePlayer.StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors = GetActorsInRange(thePlayer, 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(thePlayer) == AIA_Hostile && npc.IsAlive() )
					{											
						if( !npc.HasBuff( EET_Confusion ) )
						{
							npc.AddEffectDefault( EET_Confusion, npc, 'acs_dodge_buffs' );	
						}
					}
				}		
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
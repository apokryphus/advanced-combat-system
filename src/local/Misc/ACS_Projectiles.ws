class SwordProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= 15;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) 
		|| hitCollisionsGroups.Contains( 'Water' )
		) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBladeProjectile extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot, chain_rot 									: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;
	private var eff_names													: array<CName>;
	private var chain_ent, marker_ent										: CEntity;
	private var chain_temp, marker_temp										: CEntityTemplate;
	private var animatedComponentA											: CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= RandRange(90, -90);
		rot.Yaw += 90;
		comp.SetRotation( rot );

		if (ACS_Armor_Alpha_Equipped_Check())
		{
			if (RandF() < 0.5)
			{
				this.SoundEvent("monster_cyclop_chain_move_heavy");
			}
			else
			{
				this.SoundEvent("monster_cyclop_chain_move_light");
			}

			AddTimer('chain_attach', 0.04, true);

			//PlayEffect('chain_glow_1');

			PlayEffect('hellspire_head_projectile_glow');
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			fill_effects_array();

			PlayEffect('red_fast_attack_buff');
			PlayEffect('red_fast_attack_buff_hit');

			PlayEffect('red_trail');
			PlayEffect('red_trail');
			PlayEffect('red_trail');
			PlayEffect('red_trail');
			PlayEffect('red_trail');

			PlayEffect('red_runeword_igni_1');
			PlayEffect('red_runeword_igni_2');

			PlayEffect(eff_names[RandRange(eff_names.Size())]);

			this.SoundEvent("monster_dracolizard_combat_fireball_flyby");
		}
	}

	timer function chain_attach( dt : float , optional id : int)
	{
		if (RandF() < 0.5)
		{
			this.SoundEvent("monster_cyclop_chain_move_heavy");
		}
		else
		{
			this.SoundEvent("monster_cyclop_chain_move_light");
		}

		chain_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

		chain_rot = this.GetWorldRotation();
		//chain_rot.Roll += 90;
		chain_rot.Pitch += 90;
		//chain_rot.Yaw += 90;

		chain_ent = (CEntity)theGame.CreateEntity( chain_temp, this.GetWorldPosition(), chain_rot );

		chain_ent.PlayEffect('chain_glow_1');

		chain_ent.DestroyAfter(7);
	}
	
	timer function sword_explode( dt : float , optional id : int)
	{
		RemoveTimers();

		DealDamageProjOmega();

		DestroyEffect('explode');
		PlayEffect('explode');
		this.SoundEvent("bomb_glue_explo");

		AddTimer('sword_destroy', 0.5);
	}

	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();

		DestroyEffect('red_runeword_igni_1');
		DestroyEffect('red_runeword_igni_2');

		DestroyEffect('red_trail');

		DestroyEffect('red_fast_attack_buff');
		DestroyEffect('red_fast_attack_buff_hit');

		PlayEffect('red_fast_attack_buff');
		PlayEffect('red_fast_attack_buff_hit');

		DestroyAfter(0.25);
	}

	function fill_effects_array()
	{
		eff_names.Clear();

		eff_names.PushBack('war_sword_projectile_glow');
		eff_names.PushBack('andurial_projectile_glow');
		eff_names.PushBack('doom_sword_projectile_glow');
		eff_names.PushBack('dsd_projectile_glow');
		eff_names.PushBack('pridefall_projectile_glow');
	}
	
	function DealDamageToTargetOmega( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.125; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.125; 
		} 
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			dmg = new W3DamageAction in theGame.damageMgr;

			dmg.Initialize(GetWitcherPlayer(), actortarget, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if (actortarget.UsesVitality()) 
			{
				if(actortarget.GetHealth() > actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * RandRangeF(0.25, 0.06125); 
				}
				else if(actortarget.GetHealth() <= actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * RandRangeF(0.25, 0.06125); 
				}
			} 
			else if (actortarget.UsesEssence()) 
			{
				if(actortarget.GetHealth() > actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
				
					damageMax = maxTargetEssence * RandRangeF(0.25, 0.06125); 
				}
				else if(actortarget.GetHealth() <= actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
				
					damageMax = maxTargetEssence * RandRangeF(0.25, 0.06125); 
				}
			}

			GetWitcherPlayer().SoundEvent("cmb_play_hit_light");

			dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

			dmg.AddEffectInfo( EET_Burning, 0.1 );

			dmg.SetForceExplosionDismemberment();

			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;
		}
	}

	function DealDamageToTargetAlpha( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			dmg = new W3DamageAction in theGame.damageMgr;

			dmg.Initialize(GetWitcherPlayer(), actortarget, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}

			if (actortarget.UsesVitality()) 
			{
				maxTargetVitality = actortarget.GetStat( BCS_Vitality );

				damageMax = maxTargetVitality * 0.030625; 
			} 
			else if (actortarget.UsesEssence()) 
			{
				maxTargetEssence = actortarget.GetStat( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.030625; 
			} 

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

			dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;

			GetWitcherPlayer().SoundEvent("cmb_play_hit_light");

			animatedComponentA = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );

			if (!animatedComponentA.HasFrozenPose())
			{
				marker_temp = (CEntityTemplate)LoadResource( "fx\characters\filippa\philippa_hit_marker.w2ent", true );

				marker_ent = (CEntity)theGame.CreateEntity( marker_temp, actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );

				marker_ent.PlayEffect('marker');

				marker_ent.DestroyAfter(7);
			}

			animatedComponentA.FreezePose();

			animatedComponentA.UnfreezePoseFadeOut(7.f);
		}
	}

	function DealDamageProjOmega()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 2.5, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTargetOmega( entities[i], effType, crit );
		}
	}

	function DealDamageProjAlpha()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 1, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTargetAlpha( entities[i], effType, crit );
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if (ACS_Armor_Alpha_Equipped_Check())
		{
			if(collidingComponent)
			{
				victim = (CGameplayEntity)collidingComponent.GetEntity();
			}
			
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{		
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
					{
						DealDamageProjAlpha();
					}
				}
			}
			if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			) 
			&& !stopped )
			{
				DealDamageProjAlpha();
				StopProjectile();

				RemoveTimer('chain_attach');
				AddTimer('sword_destroy', 7);

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
				
				arrowHitPos = pos;
				arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 

				meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
				if( meshComponent )
				{
					boundingBox = meshComponent.GetBoundingBox();
					arrowSize = boundingBox.Max - boundingBox.Min;
				}
				Teleport( arrowHitPos );
				
				res = true;
			}	
			else 
			{
				return false;
			}
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			if(collidingComponent)
			{
				victim = (CGameplayEntity)collidingComponent.GetEntity();
			}
			
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{		
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
					{
						bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);

						theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
						
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 
						
						stopped = true;

						DealDamageProjOmega();
						StopProjectile();
						PlayEffect('explode');
						this.SoundEvent("bomb_glue_explo");
						AddTimer('sword_explode', 7);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
					}
				}
			}
			else if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			) 
			&& !stopped )
			{
				DealDamageProjOmega();
				StopProjectile();
				PlayEffect('explode');
				this.SoundEvent("bomb_glue_explo");
				AddTimer('sword_explode', 7);

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
				
				arrowHitPos = pos;
				arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 

				meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
				if( meshComponent )
				{
					boundingBox = meshComponent.GetBoundingBox();
					arrowSize = boundingBox.Max - boundingBox.Min;
				}
				Teleport( arrowHitPos );
				
				res = true;
			}	
			else 
			{
				return false;
			}
		} 
	}
}

class ACSBowProjectile extends W3AdvancedProjectile
{
	private var bone 																																						: name;
	private var actor, actortarget																																			: CActor;
	private var target																																						: CNewNPC;	
	private var i	 																																						: int;
	private var victims																																						: array<CGameplayEntity>;
	private var comp, meshComponent																																			: CMeshComponent;
	private var rot, bone_rot 																																				: EulerAngles;
	private var res, stopped 																																				: bool;
	private var attAction																																					: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos, initpos, targetPosition, initpos_split, targetPosition_split, spawnPos, initpos_rain, targetPosition_rain,finalpos 		: Vector;
	private var boundingBox																																					: Box;
	private var rotMat																																						: Matrix;
	private var effType																																						: EEffectType;
	private var crit																																						: bool;
	private var giant_sword	 																																				: SwordProjectileGiant;
	private var split_arrow																																					: ACSBowProjectileSplit;
	private var meshcomp 																																					: CComponent;
	private var h 																																							: float;
	private var vfxEnt_1, vfxEnt_2 																																			: CEntity;
	private var actors																																						: array<CActor>;
	private var rain_arrow																																					: ACSBowProjectileRain;
	private var randAngle, randRange																																		: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}

	timer function arrow_rain( dt : float , optional id : int)
	{
		arrow_rain_actual();
	}

	timer function arrow_rain_stop( dt : float , optional id : int)
	{
		RemoveTimer('arrow_rain');
		RemoveTimer('arrow_rain_stop');
	}

	function arrow_rain_actual()
	{
		actortarget = (CActor)victim;

		initpos_rain = actortarget.PredictWorldPosition(0.7);	
		initpos_rain.Z += 50;

		targetPosition_rain = actortarget.PredictWorldPosition(0.7);
		targetPosition_rain.Z += 1.1;

		for( i = 0; i < 3; i += 1 )
		{
			randRange = 1.1 + 1.1 * RandF();
			randAngle = 1.1 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initpos_rain.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initpos_rain.Y;
			spawnPos.Z = initpos_rain.Z;

			finalpos = spawnPos;
			finalpos.Z -= 13;
			
			rain_arrow = (ACSBowProjectileRain)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_rain.w2ent", true ), spawnPos );

			rain_arrow.Init(GetWitcherPlayer());

			rain_arrow.PlayEffect('glow');
			rain_arrow.PlayEffect('arrow_trail_fire');
			rain_arrow.ShootProjectileAtPosition( 0, 45+RandRange(20,1), finalpos, 500 );
			rain_arrow.DestroyAfter(5);
		}

		for( i = 0; i < 3; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initpos_rain.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initpos_rain.Y;
			spawnPos.Z = initpos_rain.Z;
			
			rain_arrow = (ACSBowProjectileRain)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_rain.w2ent", true ), spawnPos );

			rain_arrow.Init(GetWitcherPlayer());

			rain_arrow.PlayEffect('glow');
			rain_arrow.PlayEffect('arrow_trail_fire');
			rain_arrow.ShootProjectileAtPosition( 0, 45+RandRange(20,1), targetPosition_rain, 500 );
			rain_arrow.DestroyAfter(5);
		}
	}

	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			((CActor)victim).AddAbility( 'DisableFinishers', true );

			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			if ( !GetWitcherPlayer().IsInInterior() )
			{
				AddTimer('arrow_rain', 0.25, true);

				AddTimer('arrow_rain_stop', 3, false);
			}
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;

			((CActor)victim).RemoveAbility( 'DisableFinishers' );

			collidedEntities.PushBack(victim);
		}
	}
	
	/*
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );

			initpos = actortarget.GetWorldPosition();	
			initpos.Z += 20;

			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPosition = actortarget.GetBoneWorldPosition('head');

			}
			else
			{
				targetPosition = actortarget.GetBoneWorldPosition('k_head_g');
			}
			
			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPosition );
				vfxEnt_1.PlayEffect('mutation_2_igni');
				vfxEnt_1.DestroyAfter(1.5);

				vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPosition );
				vfxEnt_2.PlayEffect('explode');
				vfxEnt_2.DestroyAfter(2.5);

				attAction.AddEffectInfo( EET_Burning, 1 );

				attAction.AddEffectInfo( EET_HeavyKnockdown, 1 );
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			{
				actors = actortarget.GetNPCsAndPlayersInRange( 10, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

				if( actors.Size() > 0 )
				{
					initpos_split = actors[i].GetWorldPosition();	

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if ( GetAttitudeBetween( actors[i], GetWitcherPlayer() ) == AIA_Hostile && actors[i].IsAlive() )
						{
							targetPosition_split = actors[i].PredictWorldPosition(0.1);
							targetPosition_split.Z += 1.1;

							split_arrow = (ACSBowProjectileSplit)theGame.CreateEntity( 
							(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_split.w2ent", true ), initpos_split );

							split_arrow.Init(GetWitcherPlayer());
							split_arrow.PlayEffect('glow');
							split_arrow.ShootProjectileAtPosition( 0, 15+RandRange(5,1), targetPosition_split, 500 );
							split_arrow.DestroyAfter(31);
						}
					}
				}
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			{
				for( i = 0; i < 3; i += 1 )
				{
					randRange = 2.5 + 2.5 * RandF();
					randAngle = 2 * Pi() * RandF();
					
					spawnPos.X = randRange * CosF( randAngle ) + initpos.X;
					spawnPos.Y = randRange * SinF( randAngle ) + initpos.Y;
					spawnPos.Z = initpos.Z;
					
					giant_sword = (SwordProjectileGiant)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );

					meshcomp = giant_sword.GetComponentByClassName('CMeshComponent');
					h = 3;
					meshcomp.SetScale(Vector(h,h,h,1));	

					giant_sword.Init(GetWitcherPlayer());

					giant_sword.PlayEffect('glow');
					giant_sword.ShootProjectileAtPosition( 0, 40, this.GetWorldPosition(), 500 );
					giant_sword.DestroyAfter(3);
				}
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			{
				AddTimer('arrow_rain', 0.25, true);

				AddTimer('arrow_rain_stop', 3, false);
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			{
				ACS_Giant_Lightning_Strike_Single();

				attAction.AddEffectInfo( EET_Paralyzed, 1 );
			}

			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			collidedEntities.PushBack(victim);
		}
	}
	*/


	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.5 ) 
					{
						if(victim.GetBoneIndex('torso') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
					else
					{
						if(victim.GetBoneIndex('torso3') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso3');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						if(victim.GetBoneIndex('torso2') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso2');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
					else
					{
						if(victim.GetBoneIndex('pelvis') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('pelvis');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
				}


				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileMoving extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		//PlayEffect( 'arrow_trail' );

		//PlayEffect( 'arrow_trail_underwater' );

		//PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		((CActor)victim).AddAbility( 'DisableFinishers', true );
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.025; 
				
				damageMin = maxTargetVitality * 0.01; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
				
				damageMin = maxTargetEssence * 0.025; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
			dmg.SetHitReactionType( EHRT_Light );

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 2 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 2 );

			if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
			{ 
				//dmg.AddEffectInfo( EET_Stagger, 0.1 );
			}

			if (
			!actortarget.HasTag('ACS_first_bow_moving_projectile')
			&& !actortarget.HasTag('ACS_second_bow_moving_projectile')
			)
			{
				actortarget.AddTag('ACS_first_bow_moving_projectile'); 
			}
			else if (
			actortarget.HasTag('ACS_first_bow_moving_projectile') 
			)
			{
				actortarget.RemoveTag('ACS_first_bow_moving_projectile'); 
				actortarget.AddTag('ACS_second_bow_moving_projectile');
			}
			else if (
			actortarget.HasTag('ACS_second_bow_moving_projectile')
			)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					dmg.AddEffectInfo( EET_Burning, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					dmg.AddEffectInfo( EET_Frozen, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{
					dmg.AddEffectInfo( EET_Slowdown, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					dmg.AddEffectInfo( EET_Paralyzed, 1 );
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) * 5 );

				dmg.SetHitReactionType( EHRT_Light );

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				actortarget.RemoveTag('ACS_second_bow_moving_projectile'); 
			}

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}

			((CActor)victim).RemoveAbility( 'DisableFinishers' );
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
				}

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSCrossbowProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= 15;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSCrossbowProjectileMoving extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= 15;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class SwordProjectileGiant extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var attAction													: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');

		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch += 90;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.35; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.35; 
		} 
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );

			attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );
			
			attAction.AddEffectInfo( EET_HeavyKnockdown, 1 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
		}
	}

	function DealDamageProj()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 3, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTarget( entities[i], effType, crit );
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			DealDamageProj();
			StopProjectile();
			AddTimer('sword_destroy', 2);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 2.5f; 
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileSplit extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		//PlayEffect( 'arrow_trail' );

		//PlayEffect( 'arrow_trail_underwater' );

		//PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.025; 
				
				damageMin = maxTargetVitality * 0.01; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
				
				damageMin = maxTargetEssence * 0.025; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
			//dmg.SetHitReactionType( EHRT_Light );

			//dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			//dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 2 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 2 );

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
				}

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileRain extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		//PlayEffect( 'arrow_trail' );

		//PlayEffect( 'arrow_trail_underwater' );

		//PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			((CActor)victim).AddAbility( 'DisableFinishers', true );

			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.0125; 
				
				damageMin = maxTargetVitality * 0.005; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.0125; 
				
				damageMin = maxTargetEssence * 0.005; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
			dmg.SetHitReactionType( EHRT_Light );

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			//dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 2 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 2 );

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	

			((CActor)victim).RemoveAbility( 'DisableFinishers' );
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 5);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 5);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
					}
				}

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 5);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class W3BatSwarmGather extends W3AdvancedProjectile
{
	var damage 						: Float; 
	var effect						: CEntity;
	var victims						: array<CGameplayEntity>;
	var comp						: CMeshComponent;
	var range						: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{		
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		comp.SetScale( Vector ( 0.f, 0.f, 0.f ) );
		
		range = 3;
	}
	
	event OnProjectileInit()
	{

	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( IsStopped() )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;

		
		if ( victim && victim.IsAlive() && !victims.Contains(victim) && victim != GetWitcherPlayer() )
		{
			DealDamageProj();
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) || hitCollisionsGroups.Contains( 'Water' ) || hitCollisionsGroups.Contains( 'Foliage' ) )
		{
			DealDamageProj();
		}
	}
	
	function DealDamageProj()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		var surface				: CGameplayFXSurfacePost;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), range, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictimProj( entities[i] );
		}
		StopProjectile();
		StopAllEffects();
		//PlayEffect('explode');
	}
	
	function DealDamageToVictimProj( victim : CGameplayEntity )
	{
		//var action 								: W3DamageAction;
		var damage_action 							: W3Action_Attack;
		var victimtarget						: CActor;
		var templatename 				: string;
		var targetpos		: Vector;
		var rotation		: EulerAngles;
		
		if ( !victim.HasTag('spells_custom_projs') )
		{
			victim.OnAardHit( NULL );
		}
		victimtarget = (CActor)victim;
		
		templatename = "dlc\magicspellsrev\data\entities\assassin_dodge.w2ent";
		
		if ( victimtarget && victimtarget != GetWitcherPlayer() && GetAttitudeBetween( victimtarget, GetWitcherPlayer() ) == AIA_Hostile && victimtarget.IsAlive() ) 
		{
			
		}
		victims.PushBack(victim);
	}
}

class W3BatSwarmAttack extends CProjectileTrajectory
{
	var damage 						: Float; 
	var effect						: CEntity;
	var victims						: array<CGameplayEntity>;
	var comp						: CMeshComponent;
	var range						: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{		
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		comp.SetScale( Vector ( 0.f, 0.f, 0.f ) );
		
		range = 3;
	}
	
	event OnProjectileInit()
	{

	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( IsStopped() )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;

		
		if ( victim && victim.IsAlive() && !victims.Contains(victim) && victim != GetWitcherPlayer() )
		{
			DealDamageProj();
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) || hitCollisionsGroups.Contains( 'Water' ) || hitCollisionsGroups.Contains( 'Foliage' ) )
		{
			DealDamageProj();
		}
	}
	
	function DealDamageProj()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		var surface				: CGameplayFXSurfacePost;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), range, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictimProj( entities[i] );
		}

		StopProjectile();

		StopAllEffects();

		PlayEffect('venom');

		PlayEffect('venom_hit');
	}
	
	function DealDamageToVictimProj( victim : CGameplayEntity )
	{
		var victimtarget								: CActor;
		var paramsKnockdown, paramsDrunkEffect 			: SCustomEffectParams;
		var settings_interrupt							: SAnimatedComponentSlotAnimationSettings;

		victimtarget = (CActor)victim;

		settings_interrupt.blendIn = 0.25f;
		settings_interrupt.blendOut = 0.75f;
		
		if ( victimtarget == GetWitcherPlayer() ) 
		{
			if(victimtarget.IsAlive()){victimtarget.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

			victimtarget.AddEffectDefault(EET_Stagger, victimtarget, 'console');

			victimtarget.DrainVitality((victimtarget.GetStat(BCS_Vitality) * 0.1) + 25);
			
			PlayEffect('venom_hit');
		}

		victims.PushBack(victim);
	}
}

class W3ACSEredinFrostLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
			
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );
			action.AddEffectInfo( projEfect, 2.0 );
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSFireLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, damage );		
			action.AddEffectInfo(EET_Burning, 1.0);
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSRockLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSGiantShockwave extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSSharleyShockwave extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSRootAttack extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		PlayEffect('ground_fx');
		AddTimer('effect', 0.3);
		AddTimer('attack', 0.4);
		AddTimer('stop_effect', 1.f);
	}

	timer function effect ( dt : float, optional id : int)
	{
		PlayEffect('attack_fx1');
	}

	timer function stop_effect ( dt : float, optional id : int)
	{
		StopEffect('ground_fx');
	}

	timer function attack ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 3, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			deal_damage( (CActor)entities[i] );
		}
	}
	
	function deal_damage( victimtarget : CActor )
	{
		var action 			: W3DamageAction;
		var damage 			: float;
		
		if ( victimtarget && victimtarget.IsAlive() && victimtarget != GetWitcherPlayer() ) 
		{
			if (((CActor)victimtarget).UsesEssence())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victimtarget).UsesVitality())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Vitality ) * 0.125;
			}

			if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
			{
				damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
			}
			
			action = new W3DamageAction in theGame.damageMgr;
			action.Initialize(GetWitcherPlayer(),victimtarget,this,GetWitcherPlayer().GetName(),EHRT_Heavy,CPS_Undefined,false, false, true, false );
			action.SetProcessBuffsIfNoDamage(true);
			action.SetCanPlayHitParticle( true );
			
			action.AddEffectInfo( EET_Bleeding, 3 );

			action.AddEffectInfo( EET_LongStagger );

			action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
			
			theGame.damageMgr.ProcessAction( action );
			delete action;
		}
	}
}

class W3WHMinionProjectile extends W3TraceGroundProjectile
{
	private var action : W3DamageAction;

	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{

		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, 200.f );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);
			
			delete action;
		}
	}
}

class W3ACSBearFireball extends W3AdvancedProjectile
{
	editable var initFxName 			: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityTemplate 	: CEntityTemplate;
	editable var decreasePlayerDmgBy	: float; default decreasePlayerDmgBy = 0.f;

	private var projectileHitGround : bool;
	
	default projDMG = 200.f;
	default projEfect = EET_Burning;

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}

		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		/*
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSFireBear() )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
		*/

		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSFireBear() )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}

	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageToVictim(victim);
		DeactivateProjectile(victim);
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
		
		if ( victim == GetWitcherPlayer() )
		{
			projDMG = projDMG - (projDMG * decreasePlayerDmgBy);
		}
		else if ( victim == ACSFireBear() )
		{
			projDMG = 0;
		}
	
		action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, projDMG );
		action.AddEffectInfo(EET_Burning, 2.0);
		action.AddEffectInfo(EET_HeavyKnockdown, 2);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == GetWitcherPlayer() && GetWitcherPlayer().GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)GetWitcherPlayer()).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		isActive = false;
		this.StopEffect(initFxName);
		this.DestroyAfter(0.25);
		PlayCollisionEffect ( victim );
	}
	
	protected function ProjectileHitGround()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var actorsAround	 	: array<CActor>;
		var i					: int;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				projectileHitGround = true;
			}
		}
		
		else
		{
			actorsAround = GetActorsInRange( this, 2, , , true );
			for( i = 0; i < actorsAround.Size(); i += 1 )
			{
				DealDamageToVictim( actorsAround[i] );
			}
		}
		DeactivateProjectile();

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 1.f, 60, 2.f, 30.f, 1);
	}
	
	event OnRangeReached()
	{
		this.DestroyAfter(2.f);
	}
	
	function SetProjectileHitGround( b : bool )
	{
		projectileHitGround = b;
	}
}

class W3BearSummonMeteorProjectile extends W3ACSBearFireball
{
	editable var explosionRadius 		: float;
	editable var markerEntityTemplate	: CEntityTemplate;
	editable var destroyMarkerAfter		: float;

	var markerEntity 			: CEntity;
	
	default projSpeed = 10;
	default projAngle = 0;
	
	default explosionRadius = 2;
	default destroyMarkerAfter = 2.f;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var createEntityHelper 												: W3BearSummonMeteorProjectile_CreateMarkerEntityHelper;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	
		//super.OnProjectileShot(targetCurrentPosition, target);
		
		//createEntityHelper = new W3BearSummonMeteorProjectile_CreateMarkerEntityHelper in theGame;
		//createEntityHelper.owner = this;
		//createEntityHelper.SetPostAttachedCallback( createEntityHelper, 'OnEntityCreated' );

		//theGame.CreateEntityAsync( createEntityHelper, markerEntityTemplate, TraceFloor(targetCurrentPosition), EulerAngles(0,0,0) );

		if (ACSFireBear())
		{
			if (ACSFireBear().IsAlive())
			{
				AddTimer('firebearteleport', 0.000001, true);

				//AddTimer('meteortrackingdelay', 1.75, false);
			}
		}

		AddTimer('meteortrackingdelay', 1.75, false);
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity)
	{
		if ( !isActive )
			return;
		
		Explode();
		
		
		if ( markerEntity )
		{
			markerEntity.StopAllEffects();
			markerEntity.DestroyAfter( destroyMarkerAfter );
		}
		
		super.DeactivateProjectile(victim);

		RemoveTimer('meteortracking');
	}
	
	protected function Explode()
	{
		var entities 														: array<CGameplayEntity>;
		var i																: int;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		RemoveTimer('meteortracking');
		
		FindGameplayEntitiesInCylinder( entities, this.GetWorldPosition(), explosionRadius, 2.f, 99 ,'',FLAG_ExcludeTarget, this );
		
		for( i = 0; i < entities.Size(); i += 1 )
		{
			if ( !collidedEntities.Contains(entities[i]) )
			{
				DealDamageToVictim(entities[i]);
			}
		}
		
		GCameraShake( 3, 5, GetWorldPosition() );

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 1.f, 60, 2.f, 30.f, 1);

		if (ACSFireBear())
		{
			if (ACSFireBear().IsAlive())
			{
				RemoveTimer('firebearteleport');

				ACSFireBear().EnableCharacterCollisions(true); 

				ACSFireBear().EnableCollisions(true);

				//ACSFireBear().TeleportWithRotation( this.GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

				ACSFireBear().SetVisibility(true);

				animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.UnfreezePose();

				movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Spawn_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Spawn_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Spawn_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				animatedComponentA.PlaySlotAnimationAsync ( 'bear_special_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				ACSFireBear().PlayEffect('burning_body');
				ACSFireBear().PlayEffect('flames');
				ACSFireBear().PlayEffect('critical_burning');
				ACSFireBear().PlayEffect('demonic_possession');

				ACSFireBear().AddEffectDefault( EET_FireAura, ACSFireBear(), 'acs_fire_bear_fire_aura' );

				((CNewNPC)ACSFireBear()).NoticeActor(GetWitcherPlayer());

				((CActor)ACSFireBear()).ActionMoveToNodeWithHeadingAsync(GetWitcherPlayer());

				GetACSWatcher().SetFireBearMeteorProcess(false);

				if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
				{
					GetACSWatcher().RemoveTimer('DropBearMeteorStart');
					GetACSWatcher().AddTimer('DropBearMeteorStart', 15, true);
				}
				else
				{
					GetACSWatcher().RemoveTimer('DropBearMeteorStart');
					GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
				}

				//SpawnStonePillarCircle_3();
			}
			else
			{
				acsfirebearspawntemp();

				SpawnStonePillarCircle_1();

				SpawnStonePillarCircle_2();

				GetACSWatcher().RemoveTimer('DropBearMeteorStart');
				GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
			}
		}
		else
		{
			acsfirebearspawntemp();

			SpawnStonePillarCircle_1();

			SpawnStonePillarCircle_2();

			GetACSWatcher().RemoveTimer('DropBearMeteorStart');
			GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
		}
	}
	
	protected function acsfirebearspawntemp()
	{
		var temp, temp_2, ent_1_temp, blade_temp							: CEntityTemplate;
		var ent, ent_2, ent_1, r_anchor, l_anchor, r_blade1, l_blade1		: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot										: EulerAngles;
		var playerRot														: EulerAngles;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		ACSFireBear().Destroy();

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\entities\monsters\fire_bear.w2ent"
		
		, true );

		playerRot = GetWitcherPlayer().GetWorldRotation();

		playerRot.Roll = 0;
		playerRot.Pitch = 0;
		playerRot.Yaw = 180;
		
		ent = theGame.CreateEntity( temp, this.GetWorldPosition(), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).NoticeActor(GetWitcherPlayer());

		((CActor)ent).ActionMoveToNodeWithHeadingAsync(GetWitcherPlayer());

		//ent.PlayEffect('ice');

		//ent.PlayEffectSingle('appear');
		//ent.StopEffect('appear');
		//ent.PlayEffectSingle('shadow_form');
		//ent.PlayEffectSingle('demonic_possession');

		//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
		//((CActor)ent).AddAbility( 'EtherealActive' );

		//((CActor)ent).RemoveBuffImmunity( EET_Stagger );
		//((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

		ent.PlayEffect('burning_body');
		ent.PlayEffect('flames');
		ent.PlayEffect('critical_burning');
		ent.PlayEffect('demonic_possession');

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 10);

		((CActor)ent).AddEffectDefault( EET_FireAura, ((CActor)ent), 'acs_fire_bear_fire_aura' );

		((CActor)ent).AddEffectDefault( EET_AutoEssenceRegen, ((CActor)ent), 'acs_fire_bear_essence_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoMoraleRegen, ((CActor)ent), 'acs_fire_bear_morale_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoStaminaRegen, ((CActor)ent), 'acs_fire_bear_stamina_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoPanicRegen, ((CActor)ent), 'acs_fire_bear_panic_regen_buff' );

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

		((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

		//((CActor)ent).AddBuffImmunity	( EET_Stagger,				'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_LongStagger,			'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_Knockdown,			'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_Ragdoll,				'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_HeavyKnockdown,		'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_Burning,				'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_Frozen,				'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_SlowdownFrost,		'acs_fire_bear_buff', false);

		ent.AddTag( 'ACS_Fire_Bear' );
		ent.AddTag( 'ACS_Big_Boi' );
		ent.AddTag( 'ContractTarget' );
		ent.AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		movementAdjustorNPC = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Spawn_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Spawn_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Spawn_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		animatedComponentA = (CAnimatedComponent)((CNewNPC)ent).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'bear_taunt02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
	}
	
	protected function ProjectileHitGround()
	{
		var entities 		: array<CGameplayEntity>;
		var i				: int;
		var landPos			: Vector;
		
		landPos = this.GetWorldPosition();
		
		FindGameplayEntitiesInSphere( entities, this.GetWorldPosition(), 4, 10, '', FLAG_ExcludeTarget, this );
		
		for( i = 0; i < entities.Size(); i += 1 )
		{
			entities[i].ApplyAppearance( "hole" );			
			if( theGame.GetWorld().GetWaterLevel( landPos ) > landPos.Z )
			{
				entities[i].StopEffect('explosion_water');	
				entities[i].PlayEffect('explosion_water');			
			}
			else
			{
				entities[i].StopEffect('explosion');
				entities[i].PlayEffect('explosion');
			}
		}
		
		super.ProjectileHitGround();
	}

	function SpawnStonePillarCircle_1()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = TraceFloor(playerPos);
		
		count = 50;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 10 + 10 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = GetWitcherPlayer().GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, TraceFloor(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	function SpawnStonePillarCircle_2()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = TraceFloor(playerPos);
		
		count = 25;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 7.5 + 7.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = GetWitcherPlayer().GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, TraceFloor(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	function SpawnStonePillarCircle_3()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = TraceFloor(playerPos);
		
		count = 25;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 10 + 10 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = GetWitcherPlayer().GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, TraceFloor(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	timer function firebearteleport( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = this.GetWorldPosition();

		pos.Z += 0.5;

		pos.Y -= 2;

		ACSFireBear().TeleportWithRotation(pos, ACSFireBear().GetWorldRotation());
	}

	timer function meteortracking( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z -= 1;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed*0.75,pos);
		}
	}

	timer function meteortrackingdelay( deltaTime : float , id : int)
	{
		AddTimer('meteortracking', 0.25, true);
	}
	
	event OnProjectileShot( targetCurrentPosition : Vector, optional target : CNode )
	{
		var createEntityHelper 												: W3BearSummonMeteorProjectile_CreateMarkerEntityHelper;
	
		super.OnProjectileShot(targetCurrentPosition, target);
		
		createEntityHelper = new W3BearSummonMeteorProjectile_CreateMarkerEntityHelper in theGame;
		createEntityHelper.owner = this;
		createEntityHelper.SetPostAttachedCallback( createEntityHelper, 'OnEntityCreated' );

		theGame.CreateEntityAsync( createEntityHelper, markerEntityTemplate, TraceFloor(targetCurrentPosition), EulerAngles(0,0,0) );
	}
}

class W3BearSummonMeteorProjectile_CreateMarkerEntityHelper extends CCreateEntityHelper
{
	var owner : W3BearSummonMeteorProjectile;
	
	event OnEntityCreated( entity : CEntity )
	{
		/*
		if ( owner )
		{
			owner.markerEntity = entity;
			theGame.GetBehTreeReactionManager().CreateReactionEvent( owner, 'MeteorMarker', owner.destroyMarkerAfter, owner.explosionRadius, 0.1f, 999, true );
			owner = NULL;
		}
		else
		{
			entity.StopAllEffects();
			entity.DestroyAfter(2.f);
		}
		*/
		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			entity.DestroyAfter(5);
		}
		else
		{
			entity.Destroy();
		}
	}
}

class W3BearDespawnMeteorProjectile extends W3ACSBearFireball
{	
	default projSpeed = 10;
	default projAngle = 0;

	private saved var angleIncrement	: int;

	default angleIncrement = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		var pos																: Vector;
	
		//super.OnProjectileShot(targetCurrentPosition, target);

		if (ACSFireBear().IsAlive())
		{
			//pos = GetWitcherPlayer().GetWorldPosition();

			//pos.Z += 150;

			//ACSFireBear().TeleportWithRotation(pos, GetWitcherPlayer().GetWorldRotation());

			AddTimer('firebearteleport', 0.000001, true);

			//AddTimer('firebearinvis', 1.5, false);

			GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');

			ACSFireBear().StopAllEffects();

			ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');

			ACSFireBear().SetVisibility(false);

			animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );

			animatedComponentA.FreezePose();

			AddTimer('meteortrackingdelay', 1, false);
		}
	}

	timer function firebearteleport( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = this.GetWorldPosition();

		pos.Z += 3;

		//ACSFireBear().TeleportWithRotation(pos, ACSFireBear().GetWorldRotation());

		ACSFireBear().Teleport(pos);
	}

	timer function firebearinvis( deltaTime : float , id : int)
	{
		ACSFireBear().SetVisibility(false);

		ACSFireBear().StopAllEffects();

		ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');
	}

	timer function meteortracking_first( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		pos = ACSFireBear().GetHeadingVector() + ACSFireBear().GetWorldForward() * -100;

		pos.Z += 200;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed,pos);
		}
	}

	timer function meteortracking_second( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		pos = ACSFireBear().GetHeadingVector() + ACSFireBear().GetWorldForward() * 200;

		pos.Z += 100;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed,pos);
		}
	}

	timer function meteortrackingswitch( deltaTime : float , id : int)
	{
		RemoveTimer('meteortracking_first');

		AddTimer('meteortracking_second', 0.0001, true);
	}

	timer function meteortrackingdelay( deltaTime : float , id : int)
	{
		AddTimer('meteortracking_first', 0.0001, true);

		AddTimer('meteortrackingswitch', 1.5, false);
	}
	
	event OnProjectileShot( targetCurrentPosition : Vector, optional target : CNode )
	{
		//AddTimer('meteortrackingdelay', 1, false);
	}

	event OnDestroyed()
	{
		RemoveTimer('meteortracking_second');
		RemoveTimer('firebearteleport');
	}
}

class W3ACSStonePillar extends W3DurationObstacle
{
	private editable var 		damageValue 			: float; 		default damageValue = 100;
	
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned( spawnData );
		
		AddTimer( 'Appear', 0.5f );
	}
	
	
	private timer function Appear( _Delta : float, optional id : int)
	{
		var i						: int;
		var l_entitiesInRange		: array <CGameplayEntity>;
		var l_range					: float;
		var l_actor					: CActor;
		var none					: SAbilityAttributeValue;
		var l_damage				: W3DamageAction;
		var l_summonedEntityComp 	: W3SummonedEntityComponent;
		var	l_summoner				: CActor;	
		
		l_summonedEntityComp = (W3SummonedEntityComponent) GetComponentByClassName('W3SummonedEntityComponent');
		
		if( !l_summonedEntityComp )
		{
			return;
		}
		
		l_summoner = l_summonedEntityComp.GetSummoner();
		
		l_range = 1;
		
		PlayEffect('circle_stone');
		
		FindGameplayEntitiesInRange( l_entitiesInRange, this, l_range, 1000);
		
		for	( i = 0; i < l_entitiesInRange.Size(); i += 1 )
		{
			l_actor = (CActor) l_entitiesInRange[i];
			if( !l_actor ) continue;
			
			if ( l_actor == ACSFireBear() ) continue;
			
			//l_damage = new W3DamageAction in this;
			//l_damage.Initialize( l_summoner, l_actor, l_summoner, l_summoner.GetName(), EHRT_Heavy, CPS_Undefined, false, false, false, true );
			//l_damage.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageValue );
			//l_damage.AddEffectInfo( EET_KnockdownTypeApplicator, 1);
			//theGame.damageMgr.ProcessAction( l_damage );
			//delete l_damage;
		}
	}
}

class W3ACSRedPlagueProjectile extends W3ACSLeshyRootProjectile
{
	default projExpired = false;
	default collisions = 0;
	
	var surface : CGameplayFXSurfacePost;
	
	private var damageAction 			: W3DamageAction;
	
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		surface = theGame.GetSurfacePostFX();
	
		super.OnSpawned(spawnData);
		AddTimer('SurfacePostFXTimer', 0.01f, true);
	}	

	timer function SurfacePostFXTimer( deltaTime : float, id : int )
	{
		var z : float;
		var position : Vector;
		
		position = this.GetWorldPosition();
		theGame.GetWorld().NavigationComputeZ( position, -5.0, 5.0, z );
		position.Z = z + 0.3;
		this.Teleport(position);
	
		surface.AddSurfacePostFXGroup(this.GetWorldPosition(),  0.3,  5,  2 ,  1,  1 );	
		this.PlayEffect('line_fx');
	}

	function SetOwner( actor : CActor )
	{
		owner = actor;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		var victim 			: CGameplayEntity;
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		if ( victim && victim == ((CActor)caster).GetTarget() )
		{
			collisions += 1;
			
			if ( collisions == 1 )
			{
				this.StopEffect( 'ground_fx' );
				projPos = this.GetWorldPosition();
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				projRot = this.GetWorldRotation();
				fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
				fxEntity.PlayEffect( 'attack_fx1', fxEntity );
				fxEntity.DestroyAfter( 10.0 );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
				DelayDamage( 0.01 );
				AddTimer('TimeDestroyNew', 5.0, false);
				projExpired = true;

				surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );
			}
		}
		RemoveTimer('SurfacePostFXTimer');
		
		delete damageAction;
	}
	
	function DelayDamage( time : float )
	{
		AddTimer('DelayDamageTimerNew',time,false);
	}
	
	timer function DelayDamageTimerNew( delta : float , id : int)
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = MaxF( RandRangeF(300,200) , CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName)) + 200.0  );
		
		damageAction = new W3DamageAction in this;
		damageAction.SetHitAnimationPlayType(EAHA_ForceYes);
		damageAction.attacker = owner;
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					damageAction.Initialize( (CGameplayEntity)caster, victims[i], this, caster.GetName()+"_"+"root_projectile", EHRT_Light, CPS_AttackPower, false, true, false, false);
					damageAction.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, rootDmg );
					theGame.damageMgr.ProcessAction( damageAction );
					victims[i].OnRootHit();
				}
			}
		}
		
		delete damageAction;
	}
	
	event OnRangeReached()
	{
		var normal : Vector;
		
		StopAllEffects();
		StopProjectile();
		
		if( !projExpired )
		{
			projExpired = true;
			projPos = this.GetWorldPosition();
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			projRot = this.GetWorldRotation();
			fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
			fxEntity.PlayEffect( 'attack_fx1', fxEntity );
			GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
			DelayDamage( 0.3 );
			fxEntity.DestroyAfter( 10.0 );
			AddTimer('TimeDestroyNew', 5.0, false);

			surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );	
		}
		RemoveTimer('SurfacePostFXTimer');
	}
	
	function Expired() : bool
	{
		return projExpired;
	}
	
	timer function TimeDestroyNew( deltaTime : float, id : int )
	{
		Destroy();
	}
}

class W3ACSLeshyRootProjectile extends CProjectileTrajectory
{
	editable var fxEntityTemplate 	: CEntityTemplate;
	protected var fxEntity 			: CEntity;
	
	
	private var action 				: W3Action_Attack;
	
	protected var owner 				: CActor;
	protected var projPos 			: Vector;
	protected var projRot 			: EulerAngles;
	protected var projExpired 		: bool;
	var collisions 					: int;
	
	default projExpired = false;
	default collisions = 0;
	
	function SetOwner( actor : CActor )
	{
		owner = actor;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		var victim 			: CGameplayEntity;
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		if ( victim && victim == ((CActor)caster).GetTarget() )
		{
			collisions += 1;
			
			if ( collisions == 1 )
			{
				this.StopEffect( 'ground_fx' );
				projPos = this.GetWorldPosition();
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				projRot = this.GetWorldRotation();
				fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
				fxEntity.PlayEffect( 'attack_fx1', fxEntity );
				fxEntity.DestroyAfter( 10.0 );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
				DelayDamage( 0.3 );
				AddTimer('TimeDestroy', 5.0, false);
				projExpired = true;
			}
		}
		delete action;
	}
	
	function DelayDamage( time : float )
	{
		AddTimer('DelayDamageTimer',time,false);
	}
	
	timer function DelayDamageTimer( delta : float , id : int)
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName));
		
		
		action = new W3Action_Attack in theGame.damageMgr;
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					
					action.Init( (CGameplayEntity)caster, victims[i], NULL, ((CGameplayEntity)caster).GetInventory().GetItemFromSlot( 'r_weapon' ), 'attack_heavy', ((CGameplayEntity)caster).GetName(), EHRT_Heavy, false, true, 'attack_heavy', AST_Jab, ASD_DownUp, false, false, false, true );
					theGame.damageMgr.ProcessAction( action );
					
					
					victims[i].OnRootHit();
				}
			}
		}
		
		delete action;
	}
	
	event OnRangeReached()
	{
		var normal : Vector;
		
		StopAllEffects();
		StopProjectile();
		
		if( !projExpired )
		{
			projExpired = true;
			projPos = this.GetWorldPosition();
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			projRot = this.GetWorldRotation();
			fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
			fxEntity.PlayEffect( 'attack_fx1', fxEntity );
			GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
			DelayDamage( 0.3 );
			fxEntity.DestroyAfter( 10.0 );
			AddTimer('TimeDestroy', 5.0, false);
		}
	}
	
	function Expired() : bool
	{
		return projExpired;
	}
	
	timer function TimeDestroy( deltaTime : float, id : int )
	{
		Destroy();
	}
}


class W3ACSArmorPhysxProjectile extends W3AardProjectile
{
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		var projectileVictim : CProjectileTrajectory;
		
		projectileVictim = (CProjectileTrajectory)collidingComponent.GetEntity();
		
		if( projectileVictim )
		{
			projectileVictim.OnAardHit( this );
		}
		
		super.OnProjectileCollision( pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex );
	}
	
	protected function ProcessCollision( collider : CGameplayEntity, pos, normal : Vector )
	{
		var dmgVal : float;
		var sp : SAbilityAttributeValue;
		var isMutation6 : bool;
		var victimNPC : CNewNPC;
	
		
		if ( hitEntities.FindFirst( collider ) != -1 )
		{
			return;
		}
		
		hitEntities.PushBack( collider );
	
		super.ProcessCollision( collider, pos, normal );
		
		victimNPC = (CNewNPC) collider;
		
		
		theGame.damageMgr.ProcessAction( action );
		
		collider.OnAardHit( this );
		
	}
	
	event OnAttackRangeHit( entity : CGameplayEntity )
	{
		entity.OnAardHit( this );
	}
}
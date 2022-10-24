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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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

			rain_arrow.Init(thePlayer);

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

			rain_arrow.Init(thePlayer);

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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			((CActor)victim).AddAbility( 'DisableFinishers', true );

			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			if ( !thePlayer.IsInInterior() )
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
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
			
			if (thePlayer.GetEquippedSign() == ST_Igni)
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
			else if (thePlayer.GetEquippedSign() == ST_Axii)
			{
				actors = actortarget.GetNPCsAndPlayersInRange( 10, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

				if( actors.Size() > 0 )
				{
					initpos_split = actors[i].GetWorldPosition();	

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if ( GetAttitudeBetween( actors[i], thePlayer ) == AIA_Hostile && actors[i].IsAlive() )
						{
							targetPosition_split = actors[i].PredictWorldPosition(0.1);
							targetPosition_split.Z += 1.1;

							split_arrow = (ACSBowProjectileSplit)theGame.CreateEntity( 
							(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_split.w2ent", true ), initpos_split );

							split_arrow.Init(thePlayer);
							split_arrow.PlayEffect('glow');
							split_arrow.ShootProjectileAtPosition( 0, 15+RandRange(5,1), targetPosition_split, 500 );
							split_arrow.DestroyAfter(31);
						}
					}
				}
			}
			else if (thePlayer.GetEquippedSign() == ST_Aard)
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

					giant_sword.Init(thePlayer);

					giant_sword.PlayEffect('glow');
					giant_sword.ShootProjectileAtPosition( 0, 40, this.GetWorldPosition(), 500 );
					giant_sword.DestroyAfter(3);
				}
			}
			else if (thePlayer.GetEquippedSign() == ST_Yrden)
			{
				AddTimer('arrow_rain', 0.25, true);

				AddTimer('arrow_rain_stop', 3, false);
			}
			else if (thePlayer.GetEquippedSign() == ST_Quen)
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
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
			
			dmg.Initialize(thePlayer, victim, thePlayer, thePlayer.GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
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
				if (thePlayer.GetEquippedSign() == ST_Igni)
				{
					dmg.AddEffectInfo( EET_Burning, 1 );
				}
				else if (thePlayer.GetEquippedSign() == ST_Axii)
				{
					dmg.AddEffectInfo( EET_Frozen, 1 );
				}
				else if (thePlayer.GetEquippedSign() == ST_Aard)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
				}
				else if (thePlayer.GetEquippedSign() == ST_Yrden)
				{
					dmg.AddEffectInfo( EET_Slowdown, 1 );
				}
				else if (thePlayer.GetEquippedSign() == ST_Quen)
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( thePlayer, victim, thePlayer, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, thePlayer.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
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
			
			dmg.Initialize(thePlayer, victim, thePlayer, thePlayer.GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
		&& actortarget != thePlayer 
		&& GetAttitudeBetween( actortarget, thePlayer ) == AIA_Hostile 
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
			
			dmg.Initialize(thePlayer, victim, thePlayer, thePlayer.GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
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
			&& victim != thePlayer 
			&& ( GetAttitudeBetween( victim, thePlayer ) == AIA_Hostile) 
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
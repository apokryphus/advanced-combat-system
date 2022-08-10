function ACS_Giant_Lightning_Strike_Single()
{
	var vACS_Giant_Lightning_Strike_Single : cACS_Giant_Lightning_Strike_Single;
	vACS_Giant_Lightning_Strike_Single = new cACS_Giant_Lightning_Strike_Single in theGame;
			
	vACS_Giant_Lightning_Strike_Single.Giant_Lightning_Strike_Single_Engage();
}

statemachine class cACS_Giant_Lightning_Strike_Single
{
    function Giant_Lightning_Strike_Single_Engage()
	{
		this.PushState('Giant_Lightning_Strike_Single_Engage');
	}
}

state Giant_Lightning_Strike_Single_Engage in cACS_Giant_Lightning_Strike_Single
{
	private var targetRotationNPC							: EulerAngles;
	private var actor										: CActor;
	private var lightning, markerNPC, vfxEnt				: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Lightning_Strike_Single();
	}
	
	entry function Giant_Lightning_Strike_Single()
	{
		Strike_Single();
	}
	
	latent function Strike_Single()
	{
		thePlayer.DrainStamina(ESAT_HeavyAttack);
															
		thePlayer.DrainStamina(ESAT_HeavyAttack);
													
		thePlayer.DrainStamina(ESAT_HeavyAttack);
												
		thePlayer.DrainStamina(ESAT_HeavyAttack);

		targetRotationNPC = actor.GetWorldRotation();
		targetRotationNPC.Yaw = RandRangeF(360,1);
		targetRotationNPC.Pitch = RandRangeF(45,-45);
		
		actor = (CActor)( thePlayer.GetTarget() );
		
		if (!actor.HasBuff(EET_HeavyKnockdown))
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			vfxEnt.CreateAttachment( actor, , Vector( 0, 0, 1.5 ) );	
			vfxEnt.PlayEffect('critical_quen');
			vfxEnt.DestroyAfter(2);
							
			lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			lightning.PlayEffect('pre_lightning');
			lightning.PlayEffect('lightning');
			lightning.DestroyAfter(1.5);
		
			actor.AddEffectDefault( EET_HeavyKnockdown, actor, 'ACS_Lightning_Strike' );
		}
							
		if (!actor.HasBuff(EET_Burning))
		{
			if (actor.IsOnGround())
			{
				markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( actor.GetWorldPosition() ), EulerAngles(0,0,0) );
				markerNPC.StopAllEffectsAfter(3);
				markerNPC.DestroyAfter(3);
			}
		
			actor.AddEffectDefault( EET_Burning, actor, 'ACS_Lightning_Strike' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Lightning_Strike_Mult()
{
	var vACS_Giant_Lightning_Strike_Mult : cACS_Giant_Lightning_Strike_Mult;
	vACS_Giant_Lightning_Strike_Mult = new cACS_Giant_Lightning_Strike_Mult in theGame;
			
	vACS_Giant_Lightning_Strike_Mult.Giant_Lightning_Strike_Mult_Engage();
}

statemachine class cACS_Giant_Lightning_Strike_Mult
{
    function Giant_Lightning_Strike_Mult_Engage()
	{
		this.PushState('Giant_Lightning_Strike_Mult_Engage');
	}
}

state Giant_Lightning_Strike_Mult_Engage in cACS_Giant_Lightning_Strike_Mult
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Lightning_Strike_Mult();
	}
	
	entry function Giant_Lightning_Strike_Mult()
	{
		Strike_Mult();
	}
	
	latent function Strike_Mult()
	{
		//actors = GetActorsInRange(thePlayer, 55, 20);

		actors = thePlayer.GetNPCsAndPlayersInRange( 55, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{		
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if( VecDistance2D( npc.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 8 ) 
					{
						if( RandF() < 0.75 ) 
						{
							if (!npc.HasBuff(EET_HeavyKnockdown))
							{
								npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
							}
								
							if (!npc.HasBuff(EET_Burning))
							{
								npc.AddEffectDefault( EET_Burning, npc, 'console' );
							}

							targetRotationNPC = npc.GetWorldRotation();
							targetRotationNPC.Yaw = RandRangeF(360,1);
							targetRotationNPC.Pitch = RandRangeF(45,-45);

							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
							vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
							vfxEnt.PlayEffect('critical_quen');
							vfxEnt.DestroyAfter(1.5);

							lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
							lightning.PlayEffect('pre_lightning');
							lightning.PlayEffect('lightning');
							lightning.DestroyAfter(1.5);
							
							if (npc.IsOnGround())
							{
								markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
								markerNPC.StopAllEffectsAfter(1.5);
								markerNPC.DestroyAfter(1.5);
							}
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_1()
{
	var vACS_Yrden_Lightning_LVL_1 : cACS_Yrden_Lightning_LVL_1;
	vACS_Yrden_Lightning_LVL_1 = new cACS_Yrden_Lightning_LVL_1 in theGame;
			
	vACS_Yrden_Lightning_LVL_1.ACS_Yrden_Lightning_LVL_1_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_1
{
    function ACS_Yrden_Lightning_LVL_1_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_1_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_1_Engage in cACS_Yrden_Lightning_LVL_1
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(thePlayer, 2.5, 3);

		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffect('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffect('pre_lightning');
				lightning.PlayEffect('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_2()
{
	var vACS_Yrden_Lightning_LVL_2 : cACS_Yrden_Lightning_LVL_2;
	vACS_Yrden_Lightning_LVL_2 = new cACS_Yrden_Lightning_LVL_2 in theGame;
			
	vACS_Yrden_Lightning_LVL_2.ACS_Yrden_Lightning_LVL_2_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_2
{
    function ACS_Yrden_Lightning_LVL_2_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_2_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_2_Engage in cACS_Yrden_Lightning_LVL_2
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(thePlayer, 5, 20);

		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffect('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffect('pre_lightning');
				lightning.PlayEffect('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_3()
{
	var vACS_Yrden_Lightning_LVL_3 : cACS_Yrden_Lightning_LVL_3;
	vACS_Yrden_Lightning_LVL_3 = new cACS_Yrden_Lightning_LVL_3 in theGame;
			
	vACS_Yrden_Lightning_LVL_3.ACS_Yrden_Lightning_LVL_3_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_3
{
    function ACS_Yrden_Lightning_LVL_3_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_3_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_3_Engage in cACS_Yrden_Lightning_LVL_3
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(thePlayer, 10, 20);

		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffect('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffect('pre_lightning');
				lightning.PlayEffect('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Lightning_Area()
{
	var vACS_Lightning_Area : cACS_Lightning_Area;
	vACS_Lightning_Area = new cACS_Lightning_Area in theGame;
			
	vACS_Lightning_Area.ACS_Lightning_Area_Engage();
}

statemachine class cACS_Lightning_Area
{
    function ACS_Lightning_Area_Engage()
	{
		this.PushState('ACS_Lightning_Area_Engage');
	}
}

state ACS_Lightning_Area_Engage in cACS_Lightning_Area
{
	private var lightning1, lightning2 				: CEntity;
	private var targetPositionNPC					: Vector;
	private var targetRotationNPC					: EulerAngles;
	private var actor								: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Lightning_Area();
	}
	
	entry function Lightning_Area()
	{
		Lighting_Area_Activate();
	}
	
	latent function Lighting_Area_Activate()
	{
		actor = (CActor)( thePlayer.GetTarget() );
		
		lightning1 = (CEntity)theGame.GetEntityByTag( 'lightning_area_1' );
		lightning1.Destroy();
		
		if (actor.IsOnGround())
		{
			lightning2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\quests\main_quests\quest_files\q704b_fairy_tale\entities\giant\q704_ft_lightning_area.w2ent", true ), TraceFloor( actor.GetWorldPosition() ), actor.GetWorldRotation() );
			lightning2.PlayEffect('lightning_area');
			lightning2.AddTag('lightning_area_1');
			lightning2.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rock_Pillar()
{
	var vACS_Rock_Pillar : cACS_Rock_Pillar;
	vACS_Rock_Pillar = new cACS_Rock_Pillar in theGame;
			
	vACS_Rock_Pillar.ACS_Rock_Pillar_Engage();
}

statemachine class cACS_Rock_Pillar
{
    function ACS_Rock_Pillar_Engage()
	{
		this.PushState('ACS_Rock_Pillar_Engage');
	}
}

state ACS_Rock_Pillar_Engage in cACS_Rock_Pillar
{
	private var actor										: CActor;
	private var npc     									: CNewNPC;
	private var actors    									: array<CActor>;
	private var rock_pillar_temp							: CEntityTemplate;
	private var targetRotationActor							: EulerAngles;
	private var markerNPC									: CEntity;
	private var actorPos, spawnPos							: Vector;
	private var randAngle, randRange						: float;
	private var i, PillarCount								: int;	

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Rock_Pillar();
	}
	
	entry function Rock_Pillar()
	{
		LockEntryFunction(true);
		Rock_Pillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Rock_Pillar_Activate()
	{
		actor = (CActor)( thePlayer.GetTarget() );

		rock_pillar_temp = (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_pillar.w2ent", true );
		actorPos = actor.GetWorldPosition();
			
		PillarCount = 10;

		targetRotationActor = actor.GetWorldRotation();
			
		for( i = 0; i < PillarCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;

			targetRotationActor.Yaw = RandRangeF(360,1);
			targetRotationActor.Pitch = RandRangeF(45,-45);
			
			if (actor.IsOnGround())
			{
				markerNPC = (CEntity)theGame.CreateEntity( rock_pillar_temp, TraceFloor(spawnPos), targetRotationActor );
				markerNPC.PlayEffect('marker_fx');
				markerNPC.PlayEffect('circle_stone');
				markerNPC.DestroyAfter(5);
			}
		}

		if (actor.IsOnGround())
		{
			//actors = GetActorsInRange(actor, 6, 20);

			actors = thePlayer.GetNPCsAndPlayersInRange( 6, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
				
				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
					{
						if (!npc.HasBuff(EET_HeavyKnockdown))
						{
							npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'ACS_Rock_Pillar' );
						}
					}
				}
			}
		}

		thePlayer.PlayEffect('stomp');
		thePlayer.StopEffect('stomp');

		thePlayer.PlayEffect('earthquake_fx');
		thePlayer.StopEffect('earthquake_fx');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_1()
{
	var vAOE_Ice_Spear_LVL_1 : cAOE_Ice_Spear_LVL_1;
	vAOE_Ice_Spear_LVL_1 = new cAOE_Ice_Spear_LVL_1 in theGame;
			
	vAOE_Ice_Spear_LVL_1.AOE_Ice_Spear_LVL_1_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_1
{
    function AOE_Ice_Spear_LVL_1_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_1_Engage');
	}
}

state AOE_Ice_Spear_LVL_1_Engage in cAOE_Ice_Spear_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_2()
{
	var vAOE_Ice_Spear_LVL_2 : cAOE_Ice_Spear_LVL_2;
	vAOE_Ice_Spear_LVL_2 = new cAOE_Ice_Spear_LVL_2 in theGame;
			
	vAOE_Ice_Spear_LVL_2.AOE_Ice_Spear_LVL_2_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_2
{
    function AOE_Ice_Spear_LVL_2_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_2_Engage');
	}
}

state AOE_Ice_Spear_LVL_2_Engage in cAOE_Ice_Spear_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_3()
{
	var vAOE_Ice_Spear_LVL_3 : cAOE_Ice_Spear_LVL_3;
	vAOE_Ice_Spear_LVL_3 = new cAOE_Ice_Spear_LVL_3 in theGame;
			
	vAOE_Ice_Spear_LVL_3.AOE_Ice_Spear_LVL_3_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_3
{
    function AOE_Ice_Spear_LVL_3_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_3_Engage');
	}
}

state AOE_Ice_Spear_LVL_3_Engage in cAOE_Ice_Spear_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_1()
{
	var vACS_AOE_Freeze_LVL_1 : cACS_AOE_Freeze_LVL_1;
	vACS_AOE_Freeze_LVL_1 = new cACS_AOE_Freeze_LVL_1 in theGame;
			
	vACS_AOE_Freeze_LVL_1.ACS_AOE_Freeze_LVL_1_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_1
{
    function ACS_AOE_Freeze_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_1_Engage');
	}
}

state ACS_AOE_Freeze_LVL_1_Engage in cACS_AOE_Freeze_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_2()
{
	var vACS_AOE_Freeze_LVL_2 : cACS_AOE_Freeze_LVL_2;
	vACS_AOE_Freeze_LVL_2 = new cACS_AOE_Freeze_LVL_2 in theGame;
			
	vACS_AOE_Freeze_LVL_2.ACS_AOE_Freeze_LVL_2_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_2
{
    function ACS_AOE_Freeze_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_2_Engage');
	}
}

state ACS_AOE_Freeze_LVL_2_Engage in cACS_AOE_Freeze_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_3()
{
	var vACS_AOE_Freeze_LVL_3 : cACS_AOE_Freeze_LVL_3;
	vACS_AOE_Freeze_LVL_3 = new cACS_AOE_Freeze_LVL_3 in theGame;
			
	vACS_AOE_Freeze_LVL_3.ACS_AOE_Freeze_LVL_3_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_3
{
    function ACS_AOE_Freeze_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_3_Engage');
	}
}

state ACS_AOE_Freeze_LVL_3_Engage in cACS_AOE_Freeze_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_1()
{
	var vACS_AOE_Sandstorm_LVL_1 : cACS_AOE_Sandstorm_LVL_1;
	vACS_AOE_Sandstorm_LVL_1 = new cACS_AOE_Sandstorm_LVL_1 in theGame;
			
	vACS_AOE_Sandstorm_LVL_1.ACS_AOE_Sandstorm_LVL_1_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_1
{
    function ACS_AOE_Sandstorm_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_1_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_1_Engage in cACS_AOE_Sandstorm_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffect('diagonal_up_right');
				markerNPC.PlayEffect('blood_diagonal_up_right');
				markerNPC.PlayEffect('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffect('diagonal_up_left');
				markerNPC.PlayEffect('blood_diagonal_up_left');
				markerNPC.PlayEffect('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_2()
{
	var vACS_AOE_Sandstorm_LVL_2 : cACS_AOE_Sandstorm_LVL_2;
	vACS_AOE_Sandstorm_LVL_2 = new cACS_AOE_Sandstorm_LVL_2 in theGame;
			
	vACS_AOE_Sandstorm_LVL_2.ACS_AOE_Sandstorm_LVL_2_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_2
{
    function ACS_AOE_Sandstorm_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_2_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_2_Engage in cACS_AOE_Sandstorm_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffect('diagonal_up_right');
				markerNPC.PlayEffect('blood_diagonal_up_right');
				markerNPC.PlayEffect('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffect('diagonal_up_left');
				markerNPC.PlayEffect('blood_diagonal_up_left');
				markerNPC.PlayEffect('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_3()
{
	var vACS_AOE_Sandstorm_LVL_3 : cACS_AOE_Sandstorm_LVL_3;
	vACS_AOE_Sandstorm_LVL_3 = new cACS_AOE_Sandstorm_LVL_3 in theGame;
			
	vACS_AOE_Sandstorm_LVL_3.ACS_AOE_Sandstorm_LVL_3_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_3
{
    function ACS_AOE_Sandstorm_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_3_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_3_Engage in cACS_AOE_Sandstorm_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffect('diagonal_up_right');
				markerNPC.PlayEffect('blood_diagonal_up_right');
				markerNPC.PlayEffect('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffect('diagonal_up_left');
				markerNPC.PlayEffect('blood_diagonal_up_left');
				markerNPC.PlayEffect('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_1()
{
	var vACS_AOE_Sandpillar_LVL_1 : cACS_AOE_Sandpillar_LVL_1;
	vACS_AOE_Sandpillar_LVL_1 = new cACS_AOE_Sandpillar_LVL_1 in theGame;
			
	vACS_AOE_Sandpillar_LVL_1.ACS_AOE_Sandpillar_LVL_1_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_1
{
    function ACS_AOE_Sandpillar_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_1_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_1_Engage in cACS_AOE_Sandpillar_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('up');
			markerNPC.PlayEffect('blood_up');
			markerNPC.PlayEffect('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_2()
{
	var vACS_AOE_Sandpillar_LVL_2 : cACS_AOE_Sandpillar_LVL_2;
	vACS_AOE_Sandpillar_LVL_2 = new cACS_AOE_Sandpillar_LVL_2 in theGame;
			
	vACS_AOE_Sandpillar_LVL_2.ACS_AOE_Sandpillar_LVL_2_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_2
{
    function ACS_AOE_Sandpillar_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_2_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_2_Engage in cACS_AOE_Sandpillar_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('up');
			markerNPC.PlayEffect('blood_up');
			markerNPC.PlayEffect('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_3()
{
	var vACS_AOE_Sandpillar_LVL_3 : cACS_AOE_Sandpillar_LVL_3;
	vACS_AOE_Sandpillar_LVL_3 = new cACS_AOE_Sandpillar_LVL_3 in theGame;
			
	vACS_AOE_Sandpillar_LVL_3.ACS_AOE_Sandpillar_LVL_3_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_3
{
    function ACS_AOE_Sandpillar_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_3_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_3_Engage in cACS_AOE_Sandpillar_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffect('up');
			markerNPC.PlayEffect('blood_up');
			markerNPC.PlayEffect('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_1()
{
	var vACS_AOE_Igni_Blast_LVL_1 : cACS_AOE_Igni_Blast_LVL_1;
	vACS_AOE_Igni_Blast_LVL_1 = new cACS_AOE_Igni_Blast_LVL_1 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_1.ACS_AOE_Igni_Blast_LVL_1_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_1
{
    function ACS_AOE_Igni_Blast_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_1_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_1_Engage in cACS_AOE_Igni_Blast_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffect('critical_igni');
			markerNPC.DestroyAfter(1.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_2()
{
	var vACS_AOE_Igni_Blast_LVL_2 : cACS_AOE_Igni_Blast_LVL_2;
	vACS_AOE_Igni_Blast_LVL_2 = new cACS_AOE_Igni_Blast_LVL_2 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_2.ACS_AOE_Igni_Blast_LVL_2_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_2
{
    function ACS_AOE_Igni_Blast_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_2_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_2_Engage in cACS_AOE_Igni_Blast_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffect('critical_igni');
			markerNPC.DestroyAfter(1.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_3()
{
	var vACS_AOE_Igni_Blast_LVL_3 : cACS_AOE_Igni_Blast_LVL_3;
	vACS_AOE_Igni_Blast_LVL_3 = new cACS_AOE_Igni_Blast_LVL_3 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_3.ACS_AOE_Igni_Blast_LVL_3_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_3
{
    function ACS_AOE_Igni_Blast_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_3_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_3_Engage in cACS_AOE_Igni_Blast_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffect('explode');
			markerNPC.DestroyAfter(2.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Magic_Missiles_LVL_1()
{
	var vACS_AOE_Magic_Missiles_LVL_1 : cACS_AOE_Magic_Missiles_LVL_1;
	vACS_AOE_Magic_Missiles_LVL_1 = new cACS_AOE_Magic_Missiles_LVL_1 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_1.ACS_AOE_Magic_Missiles_LVL_1_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_1
{
    function ACS_AOE_Magic_Missiles_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_1_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_1_Engage in cACS_AOE_Magic_Missiles_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode_copy');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Magic_Missiles_LVL_2()
{
	var vACS_AOE_Magic_Missiles_LVL_2 : cACS_AOE_Magic_Missiles_LVL_2;
	vACS_AOE_Magic_Missiles_LVL_2 = new cACS_AOE_Magic_Missiles_LVL_2 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_2.ACS_AOE_Magic_Missiles_LVL_2_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_2
{
    function ACS_AOE_Magic_Missiles_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_2_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_2_Engage in cACS_AOE_Magic_Missiles_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode_copy');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_AOE_Magic_Missiles_LVL_3()
{
	var vACS_AOE_Magic_Missiles_LVL_3 : cACS_AOE_Magic_Missiles_LVL_3;
	vACS_AOE_Magic_Missiles_LVL_3 = new cACS_AOE_Magic_Missiles_LVL_3 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_3.ACS_AOE_Magic_Missiles_LVL_3_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_3
{
    function ACS_AOE_Magic_Missiles_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_3_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_3_Engage in cACS_AOE_Magic_Missiles_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode_copy');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rend_Projectile_Switch()
{
	var maxAdrenaline								: float;
	var curAdrenaline								: float;

	maxAdrenaline = thePlayer.GetStatMax(BCS_Focus);
		
	curAdrenaline = thePlayer.GetStat(BCS_Focus);

	if ( ACS_ElementalRend_Enabled() )
	{
		if (curAdrenaline >= maxAdrenaline * 2/3)
		{
			if( thePlayer.GetEquippedSign() == ST_Igni && thePlayer.HasTag('igni_secondary_sword_equipped') && thePlayer.CanUseSkill(S_Sword_s02))
			{
				ACS_Ifrit_Fire_Projectile();
			}
			else if( thePlayer.GetEquippedSign() == ST_Axii && thePlayer.HasTag('axii_secondary_sword_equipped') && thePlayer.CanUseSkill(S_Sword_s02))
			{
				ACS_Eredin_Frost_Projectile();
			}
			else if( thePlayer.GetEquippedSign() == ST_Aard && thePlayer.HasTag('aard_secondary_sword_equipped') && thePlayer.CanUseSkill(S_Sword_s02))
			{
				ACS_Golem_Stone_Projectile();
			}
			else if( thePlayer.GetEquippedSign() == ST_Quen && thePlayer.HasTag('quen_secondary_sword_equipped') && thePlayer.CanUseSkill(S_Sword_s02))
			{
				ACS_Root_Projectile();
			}
			else if( thePlayer.GetEquippedSign() == ST_Yrden && thePlayer.HasTag('yrden_secondary_sword_equipped') && thePlayer.CanUseSkill(S_Sword_s02))
			{
				ACS_Giant_Shockwave_Mult();
			}
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Eredin_Frost_Projectile()
{
	var vACS_Eredin_Frost_Projectile : cACS_Eredin_Frost_Projectile;
	vACS_Eredin_Frost_Projectile = new cACS_Eredin_Frost_Projectile in theGame;
			
	vACS_Eredin_Frost_Projectile.ACS_Eredin_Frost_Projectile_Engage();
}

statemachine class cACS_Eredin_Frost_Projectile
{
    function ACS_Eredin_Frost_Projectile_Engage()
	{
		this.PushState('ACS_Eredin_Frost_Projectile_Engage');
	}
}

state ACS_Eredin_Frost_Projectile_Engage in cACS_Eredin_Frost_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3EredinFrostProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Eredin_Frost_Projectile();
	}
	
	entry function Eredin_Frost_Projectile()
	{
		LockEntryFunction(true);
		Eredin_Frost_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Eredin_Frost_Projectile_Activate()
	{
		//position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 2) + thePlayer.GetHeadingVector() * 1.7;
		position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 1.1) + thePlayer.GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_2 = position + (thePlayer.GetWorldRight() * -6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_3 = position + (thePlayer.GetWorldRight() * 6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_4 = position + (thePlayer.GetWorldRight() * -13) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_5 = position + (thePlayer.GetWorldRight() * 13) + thePlayer.GetHeadingVector() * 30;
		
		if (!thePlayer.HasTag('eredin_frost_proj_begin') && !thePlayer.HasTag('eredin_frost_proj_1st') && !thePlayer.HasTag('eredin_frost_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, actortarget, 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.10 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, actortarget, 'acs_weapon_effects' ); 
						}
					}
				}
			}		
			
			proj_1 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			thePlayer.AddTag('eredin_frost_proj_begin');
			thePlayer.AddTag('eredin_frost_proj_1st');
		}
		else if (thePlayer.HasTag('eredin_frost_proj_begin') && thePlayer.HasTag('eredin_frost_proj_1st'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, actortarget, 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.25 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, actortarget, 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			thePlayer.RemoveTag('eredin_frost_proj_1st');
			thePlayer.AddTag('eredin_frost_proj_2nd');
		}
		else if (thePlayer.HasTag('eredin_frost_proj_begin') && thePlayer.HasTag('eredin_frost_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, actortarget, 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.75 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, actortarget, 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_4.Init(thePlayer);
			proj_4.PlayEffect('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3EredinFrostProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\eredin\eredin_frost_proj.w2ent", true ), position );
			proj_5.Init(thePlayer);
			proj_5.PlayEffect('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			thePlayer.RemoveTag('eredin_frost_proj_begin');
			thePlayer.RemoveTag('eredin_frost_proj_1st');
			thePlayer.RemoveTag('eredin_frost_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Ifrit_Fire_Projectile()
{
	var vACS_Ifrit_Fire_Projectile : cACS_Ifrit_Fire_Projectile;
	vACS_Ifrit_Fire_Projectile = new cACS_Ifrit_Fire_Projectile in theGame;
			
	vACS_Ifrit_Fire_Projectile.ACS_Ifrit_Fire_Projectile_Engage();
}

statemachine class cACS_Ifrit_Fire_Projectile
{
    function ACS_Ifrit_Fire_Projectile_Engage()
	{
		this.PushState('ACS_Ifrit_Fire_Projectile_Engage');
	}
}

state ACS_Ifrit_Fire_Projectile_Engage in cACS_Ifrit_Fire_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ElementalIfrytProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ifrit_Fire_Projectile();
	}
	
	entry function Ifrit_Fire_Projectile()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		thePlayer.SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Ifrit_Fire_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ifrit_Fire_Projectile_Activate()
	{
		//position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 2) + thePlayer.GetHeadingVector() * 1.7;
		position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 1.5) + thePlayer.GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_2 = position + (thePlayer.GetWorldRight() * -6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_3 = position + (thePlayer.GetWorldRight() * 6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_4 = position + (thePlayer.GetWorldRight() * -13) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_5 = position + (thePlayer.GetWorldRight() * 13) + thePlayer.GetHeadingVector() * 30;
		
		if (!thePlayer.HasTag('ifrit_fire_proj_begin') && !thePlayer.HasTag('ifrit_fire_proj_1st') && !thePlayer.HasTag('ifrit_fire_proj_2nd'))
		{	
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			thePlayer.AddTag('ifrit_fire_proj_begin');
			thePlayer.AddTag('ifrit_fire_proj_1st');
		}
		else if (thePlayer.HasTag('ifrit_fire_proj_begin') && thePlayer.HasTag('ifrit_fire_proj_1st'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			thePlayer.RemoveTag('ifrit_fire_proj_1st');
			thePlayer.AddTag('ifrit_fire_proj_2nd');
		}
		else if (thePlayer.HasTag('ifrit_fire_proj_begin') && thePlayer.HasTag('ifrit_fire_proj_2nd'))
		{	
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_4.Init(thePlayer);
			proj_4.PlayEffect('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ElementalIfrytProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_ifryt_proj.w2ent", true ), position );
			proj_5.Init(thePlayer);
			proj_5.PlayEffect('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			thePlayer.RemoveTag('ifrit_fire_proj_begin');
			thePlayer.RemoveTag('ifrit_fire_proj_1st');
			thePlayer.RemoveTag('ifrit_fire_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Golem_Stone_Projectile()
{
	var vACS_Golem_Stone_Projectile : cACS_Golem_Stone_Projectile;
	vACS_Golem_Stone_Projectile = new cACS_Golem_Stone_Projectile in theGame;
			
	vACS_Golem_Stone_Projectile.ACS_Golem_Stone_Projectile_Engage();
}

statemachine class cACS_Golem_Stone_Projectile
{
    function ACS_Golem_Stone_Projectile_Engage()
	{
		this.PushState('ACS_Golem_Stone_Projectile_Engage');
	}
}

state ACS_Golem_Stone_Projectile_Engage in cACS_Golem_Stone_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ElementalDaoProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Golem_Stone_Projectile();
	}
	
	entry function Golem_Stone_Projectile()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		thePlayer.SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Golem_Stone_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Golem_Stone_Projectile_Activate()
	{
		position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 2.2) + thePlayer.GetHeadingVector() * 1.7;
		
		targetPosition_1 = position + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_2 = position + (thePlayer.GetWorldRight() * -6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_3 = position + (thePlayer.GetWorldRight() * 6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_4 = position + (thePlayer.GetWorldRight() * -13) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_5 = position + (thePlayer.GetWorldRight() * 13) + thePlayer.GetHeadingVector() * 30;
		
		if (!thePlayer.HasTag('golem_stone_proj_begin') && !thePlayer.HasTag('golem_stone_proj_1st') && !thePlayer.HasTag('golem_stone_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			thePlayer.AddTag('golem_stone_proj_begin');
			thePlayer.AddTag('golem_stone_proj_1st');
		}
		else if (thePlayer.HasTag('golem_stone_proj_begin') && thePlayer.HasTag('golem_stone_proj_1st'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			thePlayer.RemoveTag('golem_stone_proj_1st');
			thePlayer.AddTag('golem_stone_proj_2nd');
		}
		else if (thePlayer.HasTag('golem_stone_proj_begin') && thePlayer.HasTag('golem_stone_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_4.Init(thePlayer);
			proj_4.PlayEffect('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\elemental\elemental_dao_proj.w2ent", true ), position );
			proj_5.Init(thePlayer);
			proj_5.PlayEffect('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			thePlayer.RemoveTag('golem_stone_proj_begin');
			thePlayer.RemoveTag('golem_stone_proj_1st');
			thePlayer.RemoveTag('golem_stone_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Root_Projectile()
{
	var vACS_Root_Projectile : cACS_Root_Projectile;
	vACS_Root_Projectile = new cACS_Root_Projectile in theGame;
			
	vACS_Root_Projectile.ACS_Root_Projectile_Engage();
}

statemachine class cACS_Root_Projectile
{
    function ACS_Root_Projectile_Engage()
	{
		this.PushState('ACS_Root_Projectile_Engage');
	}
}

state ACS_Root_Projectile_Engage in cACS_Root_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5 																														: W3WitchBoilingWaterObstacle;
	private var position_1, position_2, position_3, position_4, position_5																									: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Root_Projectile();
	}
	
	entry function Root_Projectile()
	{
		LockEntryFunction(true);
		Root_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Root_Projectile_Activate()
	{
		position_1 = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 7.5;
		position_1 = TraceFloor(position_1);
		
		position_2 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 5 + thePlayer.GetWorldForward() * 7.5;
		position_2 = TraceFloor(position_2);
		
		position_3 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -5 + thePlayer.GetWorldForward() * 7.5;
		position_3 = TraceFloor(position_3);
		
		position_4 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 7.5 + thePlayer.GetWorldForward() * 7.5;
		position_4 = TraceFloor(position_4);
		
		position_5 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -7.5 + thePlayer.GetWorldForward() * 7.5;
		position_5 = TraceFloor(position_5);
		
		if (!thePlayer.HasTag('root_proj_begin') && !thePlayer.HasTag('root_proj_1st') && !thePlayer.HasTag('root_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);		
			
			thePlayer.AddTag('root_proj_begin');
			thePlayer.AddTag('root_proj_1st');
		}
		else if (thePlayer.HasTag('root_proj_begin') && thePlayer.HasTag('root_proj_1st'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_3) );
			proj_3.DestroyAfter(5);	
			
			thePlayer.RemoveTag('root_proj_1st');
			thePlayer.AddTag('root_proj_2nd');
		}
		else if (thePlayer.HasTag('root_proj_begin') && thePlayer.HasTag('root_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			proj_1 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_3) );
			proj_3.DestroyAfter(5);	
			
			proj_4 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_4) );
			proj_4.DestroyAfter(5);	
			
			proj_5 = (W3WitchBoilingWaterObstacle)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\sprigan\sprigan_root_attack.w2ent", true ), TraceFloor(position_5) );
			proj_5.DestroyAfter(5);	
			
			thePlayer.RemoveTag('root_proj_begin');
			thePlayer.RemoveTag('root_proj_1st');
			thePlayer.RemoveTag('root_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Shockwave_Mult()
{
	var vACS_Giant_Shockwave_Mult : cACS_Giant_Shockwave_Mult;
	vACS_Giant_Shockwave_Mult = new cACS_Giant_Shockwave_Mult in theGame;
			
	vACS_Giant_Shockwave_Mult.ACS_Giant_Shockwave_Mult_Engage();
}

statemachine class cACS_Giant_Shockwave_Mult
{
    function ACS_Giant_Shockwave_Mult_Engage()
	{
		this.PushState('ACS_Giant_Shockwave_Mult_Engage');
	}
}

state ACS_Giant_Shockwave_Mult_Engage in cACS_Giant_Shockwave_Mult
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																								: W3ElementalDaoProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position									: Vector;
	private var actors																																: array<CActor>;
	private var i         																															: int;
	private var actortarget					       																									: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Shockwave();
	}
	
	entry function Giant_Shockwave()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		thePlayer.SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 1.1) + thePlayer.GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_2 = position + (thePlayer.GetWorldRight() * -6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_3 = position + (thePlayer.GetWorldRight() * 6.5) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_4 = position + (thePlayer.GetWorldRight() * -13) + thePlayer.GetHeadingVector() * 30;
		
		targetPosition_5 = position + (thePlayer.GetWorldRight() * 13) + thePlayer.GetHeadingVector() * 30;
		
		if (!thePlayer.HasTag('giant_shockwave_proj_begin') && !thePlayer.HasTag('giant_shockwave_proj_1st') && !thePlayer.HasTag('giant_shockwave_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			thePlayer.AddTag('giant_shockwave_proj_begin');
			thePlayer.AddTag('giant_shockwave_proj_1st');

			actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (thePlayer.HasTag('giant_shockwave_proj_begin') && thePlayer.HasTag('giant_shockwave_proj_1st'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );

			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			thePlayer.RemoveTag('giant_shockwave_proj_1st');
			thePlayer.AddTag('giant_shockwave_proj_2nd');

			actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (thePlayer.HasTag('giant_shockwave_proj_begin') && thePlayer.HasTag('giant_shockwave_proj_2nd'))
		{
			Sleep(0.25 / thePlayer.GetAnimationTimeMultiplier() );
			
			actors = thePlayer.GetNPCsAndPlayersInCone(30, VecHeading(thePlayer.GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, actortarget, 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_2.Init(thePlayer);
			proj_2.PlayEffect('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_3.Init(thePlayer);
			proj_3.PlayEffect('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			proj_4 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_4.Init(thePlayer);
			proj_4.PlayEffect('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(2.5);
			
			proj_5 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
			proj_5.Init(thePlayer);
			proj_5.PlayEffect('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(2.5);
			
			thePlayer.RemoveTag('giant_shockwave_proj_begin');
			thePlayer.RemoveTag('giant_shockwave_proj_1st');
			thePlayer.RemoveTag('giant_shockwave_proj_2nd');

			actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Theft_Prevention_8()
{
	if (
	(ACS_SCAAR_1_Installed()
	|| ACS_SCAAR_2_Installed()
	|| ACS_SCAAR_3_Installed())
	&&( StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('Localization', 'Virtual_Localization_speech')) == 3
	|| StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('Localization', 'Virtual_Localization_speech')) == 17 )
	)
	{
		theGame.ChangePlayer( "Goodbye" );
	}
}

function ACS_Giant_Shockwave()
{
	var vACS_Giant_Shockwave : cACS_Giant_Shockwave;
	vACS_Giant_Shockwave = new cACS_Giant_Shockwave in theGame;
			
	vACS_Giant_Shockwave.ACS_Giant_Shockwave_Engage();
}

statemachine class cACS_Giant_Shockwave
{
    function ACS_Giant_Shockwave_Engage()
	{
		this.PushState('ACS_Giant_Shockwave_Engage');
	}
}

state ACS_Giant_Shockwave_Engage in cACS_Giant_Shockwave
{
	private var proj_1																					: W3ElementalDaoProjectile;
	private var targetPosition_1, position																: Vector;
	private var actors																					: array<CActor>;
	private var i         																				: int;
	private var actortarget					       														: CActor;
	private var dmg																						: W3DamageAction;
	private var maxTargetVitality, maxTargetEssence, damageMax											: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Shockwave();
	}
	
	entry function Giant_Shockwave()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		thePlayer.SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = thePlayer.GetWorldPosition() + (thePlayer.GetWorldForward() * 1.1) + thePlayer.GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + thePlayer.GetHeadingVector() * 30;

		actors = thePlayer.GetNPCsAndPlayersInCone(5, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );
			
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.05; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);

			dmg.SetForceExplosionDismemberment();
			
			dmg.SetHitReactionType( EHRT_Heavy, true);
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

			if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
			{ 
				dmg.AddEffectInfo( EET_HeavyKnockdown, 0.1 );
			}
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
		}
			
		proj_1 = (W3ElementalDaoProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_shockwave_proj.w2ent", true ), position );
		proj_1.Init(thePlayer);
		proj_1.PlayEffect('fire_line');
		proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_1.DestroyAfter(2.5);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawn_Shades()
{
	var vACS_Spawn_Shades : cACS_Spawn_Shades;
	vACS_Spawn_Shades = new cACS_Spawn_Shades in theGame;
			
	vACS_Spawn_Shades.ACS_Spawn_Shades_Engage();
}

statemachine class cACS_Spawn_Shades
{
    function ACS_Spawn_Shades_Engage()
	{
		this.PushState('ACS_Spawn_Shades_Engage');
	}
}

state ACS_Spawn_Shades_Engage in cACS_Spawn_Shades
{
	private var shadeTemplate													: CEntityTemplate;
	private var shadeEntity														: CEntity;
	private var i, shadesCount													: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange, curPlayerVitality, maxPlayerVitality		: float;
	private var playerVitality 													: EBaseCharacterStats;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Shades();
	}
	
	entry function Spawn_Shades()
	{	
		LockEntryFunction(true);
		
		thePlayer.StopEffect('summon');
		thePlayer.PlayEffect('summon');
	
		Spawn_Shades_Activate();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Shades_Activate()
	{
		shadeTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\quests\quest_files\q604_mansion\characters\q604_shade.w2ent", true );
		playerPos = thePlayer.GetWorldPosition();
		
		playerVitality = BCS_Vitality;
		curPlayerVitality = thePlayer.GetStat( BCS_Vitality );
		maxPlayerVitality = thePlayer.GetStatMax( BCS_Vitality );
		
		if ( thePlayer.GetLevel() <= 10 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 2;
			}
			else
			{
				shadesCount = 1;
			}
		}
		else if ( thePlayer.GetLevel() > 10 && thePlayer.GetLevel() <= 15 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 5;
			}
			else
			{
				shadesCount = 2;
			}
		}
		else if ( thePlayer.GetLevel() > 15 && thePlayer.GetLevel() <= 20 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 7;
			}
			else
			{
				shadesCount = 3;
			}
		}
		else if ( thePlayer.GetLevel() > 20 && thePlayer.GetLevel() <= 25 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 10;
			}
			else
			{
				shadesCount = 5;
			}
		}
		else if ( thePlayer.GetLevel() > 25 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 15;
			}
			else
			{
				shadesCount = 7;
			}
		}
			
		for( i = 0; i < shadesCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			shadeEntity = theGame.CreateEntity( shadeTemplate, spawnPos, thePlayer.GetWorldRotation() );
			shadeEntity.AddTag( 'ACS_caretaker_shade' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_SCAAR_7_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_geraltsuit');	
}

function ACS_SCAAR_8_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_netflixarmor');	
}

function ACS_SCAAR_9_Installed(): bool
{
	return theGame.
	GetDLCManager().
	IsDLCAvailable('dlc_windcloud');	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Beam_Attack()
{
	var vACS_Beam_Attack : cACS_Beam_Attack;
	vACS_Beam_Attack = new cACS_Beam_Attack in theGame;
			
	vACS_Beam_Attack.ACS_Beam_Attack_Engage();
}

statemachine class cACS_Beam_Attack
{
    function ACS_Beam_Attack_Engage()
	{
		if (thePlayer.GetStat( BCS_Stamina ) == thePlayer.GetStatMax( BCS_Stamina ))
		{
			thePlayer.ForceSetStat( BCS_Stamina,  thePlayer.GetStat( BCS_Stamina ) * 0 );
			this.PushState('ACS_Beam_Attack_Engage');
		}
	}
}

state ACS_Beam_Attack_Engage in cACS_Beam_Attack
{
	private var beam_anchor1																							: CEntity;
	private var actortarget, actor, pActor																				: CActor;
	private var anchor_temp_1, anchor_temp_2																			: CEntityTemplate;
	private var settings																								: SAnimatedComponentSlotAnimationSettings;
	private var dmg																										: W3DamageAction;
	private var movementAdjustor1																						: CMovementAdjustor;
	private var ticket1																									: SMovementAdjustmentRequestTicket;
	private var i																										: int;
	private var actors																									: array<CActor>;
	private var curTargetVitality, curTargetEssence, maxTargetVitality, maxTargetEssence, damage						: float;
	private var targetVitality, targetEssence 																			: EBaseCharacterStats;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Beam_Attack();
	}
	
	entry function Beam_Attack()
	{
		Beam_Attack_Activate();
	}
	
	latent function Beam_Attack_Activate()
	{	
		thePlayer.StopEffect('lightning_djinn');
		
		thePlayer.PlayEffect('hit_lightning');
		thePlayer.StopEffect('hit_lightning');
		
		pActor = thePlayer;
		
		actor = (CActor)( thePlayer.GetTarget() );
		
		anchor_temp_1 = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_6\glyphword_6.w2ent", true);
		
		anchor_temp_2 = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\runeword\runeword_1\runeword_1_aard.w2ent", true);
		
		settings.blendIn = 0.15;
		settings.blendOut = 1.0f;
		
		targetVitality = BCS_Vitality;
		
		targetEssence = BCS_Essence;
		
		curTargetVitality = actor.GetStat( BCS_Vitality );
		
		curTargetEssence = actor.GetStat( BCS_Essence );
		
		maxTargetVitality = actor.GetStatMax( BCS_Vitality );
		
		maxTargetEssence = actor.GetStatMax( BCS_Essence );
		
		if (actor.UsesEssence())
		{
			if ( curTargetEssence <= maxTargetEssence * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = curTargetEssence * 0.00625;
			}
		}
		else if (actor.UsesVitality())
		{
			if ( curTargetVitality <= maxTargetVitality * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = curTargetVitality * 0.00625;
			}
		}
		
		if (thePlayer.IsOnGround())
		{
			if( VecDistance2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 3.5 ) 
			{
				while (true) 
				{			
					actors = thePlayer.GetNPCsAndPlayersInCone( 3.5, VecHeading(thePlayer.GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', settings);
							
						beam_anchor1 = theGame.CreateEntity(anchor_temp_1, actortarget.GetWorldPosition());
						beam_anchor1.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
						beam_anchor1.AddTag('beam_anchor');
						beam_anchor1.DestroyAfter(1.5);
							
						//thePlayer.PlayEffect('shout', beam_anchor1);
						//thePlayer.StopEffect('shout');
						
						thePlayer.PlayEffect('toad_vomit', beam_anchor1);
						thePlayer.StopEffect('toad_vomit');
							
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
		
						dmg.AddDamage( theGame.params.DAMAGE_NAME_POISON, damage );
													
						dmg.AddEffectInfo( EET_Immobilized, 2 );
						dmg.AddEffectInfo( EET_Poison, 3 );
							
						theGame.damageMgr.ProcessAction( dmg );
												
						delete dmg;	
					}
					SleepOneFrame();			
				}
			}
			else if( VecDistance2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) > 3.5 && VecDistance2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 20)
			{
				while (true)
				{	
					thePlayer.StopEffect('lightning_djinn');
					thePlayer.StopEffect('lightning_djinn');
					
					movementAdjustor1 = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
					movementAdjustor1.CancelByName( 'turn' );
					ticket1 = movementAdjustor1.CreateNewRequest( 'turn' );
					movementAdjustor1.AdjustmentDuration( ticket1, 0.1 );
						
					movementAdjustor1.RotateTowards( ticket1, actor );
				
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', settings);

					actors = thePlayer.GetNPCsAndPlayersInCone( VecDistance2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) , VecHeading(thePlayer.GetHeadingVector()), 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
						
						dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage / 2 );
							
						//dmg.AddEffectInfo( EET_Stagger, 0.5 );
						
						if( RandF() < 0.1 ) 
						{
							dmg.AddEffectInfo( EET_Burning, 0.1 );
						}
								
						theGame.damageMgr.ProcessAction( dmg );
													
						delete dmg;	
					}
					
					beam_anchor1 = theGame.CreateEntity(anchor_temp_2, actor.GetWorldPosition());
					beam_anchor1.CreateAttachment( actor, , Vector( 0, 0, 1 ) );	
					beam_anchor1.AddTag('beam_anchor');
					beam_anchor1.DestroyAfter(1.5);
				
					thePlayer.StopEffect('lightning_djinn');
					thePlayer.StopEffect('lightning_djinn');
					thePlayer.PlayEffect('lightning_djinn', beam_anchor1);
					thePlayer.StopEffect('lightning_djinn');
					thePlayer.StopEffect('lightning_djinn');
								
					dmg = new W3DamageAction in theGame.damageMgr;
					dmg.Initialize(thePlayer, actor, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
					dmg.SetProcessBuffsIfNoDamage(true);
					
					dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage );
										
					dmg.AddEffectInfo( EET_HeavyKnockdown, 0.5 );
					
					if( RandF() < 0.1 ) 
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
								
					theGame.damageMgr.ProcessAction( dmg );
													
					delete dmg;
					
					SleepOneFrame();	
					
					thePlayer.StopEffect('lightning_djinn');
				}
			}
			else
			{
				thePlayer.RaiseEvent( 'CombatTaunt' );
			}
			
			thePlayer.StopEffect('lightning_djinn');
		}
		else
		{
			thePlayer.StopEffect('lightning_djinn');
			
			thePlayer.PlayEffect('djinn_default');
			thePlayer.StopEffect('djinn_default');
			
			if( VecDistance2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 20 ) 
			{
				while (true)
				{	
					//actors = GetActorsInRange(thePlayer, 20, 5);

					actors = thePlayer.GetNPCsAndPlayersInRange( 20, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if ( actors[i] == thePlayer || actors[i].HasTag('smokeman') )
						continue;

						actortarget = (CActor)actors[i];
						
						if( actors.Size() > 0 )
						{		
							if( ACS_AttitudeCheck ( actortarget ) && actortarget.IsAlive() )
							{
								beam_anchor1 = theGame.CreateEntity(anchor_temp_2, actortarget.GetWorldPosition());
								beam_anchor1.CreateAttachment( actortarget, , Vector( 0, 0, 1 ) );	
								beam_anchor1.AddTag('beam_anchor');
								beam_anchor1.DestroyAfter(0.1);
								
								thePlayer.StopEffect('lightning_djinn');
								thePlayer.StopEffect('lightning_djinn');
								thePlayer.PlayEffect('lightning_djinn', beam_anchor1);
								thePlayer.StopEffect('lightning_djinn');
								thePlayer.StopEffect('lightning_djinn');
								
								dmg = new W3DamageAction in theGame.damageMgr;
								dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
								dmg.SetProcessBuffsIfNoDamage(true);
								
								dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage );
													
								dmg.AddEffectInfo( EET_HeavyKnockdown, 0.5 );
								
								if( RandF() < 0.1 ) 
								{
									dmg.AddEffectInfo( EET_Burning, 0.5 );
								}
											
								theGame.damageMgr.ProcessAction( dmg );
																
								delete dmg;
							}
						}
					}
					
					SleepOneFrame();
				}
				thePlayer.StopEffect('lightning_djinn');
			}
			else
			{
				thePlayer.RaiseEvent( 'CombatTaunt' );
			}
			
			thePlayer.StopEffect('lightning_djinn');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Detonation_Weapon_Effects_Switch()
{
	var vACS_Detonation_Weapon_Effects_Switch : cACS_Detonation_Weapon_Effects_Switch;
	vACS_Detonation_Weapon_Effects_Switch = new cACS_Detonation_Weapon_Effects_Switch in theGame;
			
	vACS_Detonation_Weapon_Effects_Switch.ACS_Detonation_Weapon_Effects_Switch_Engage();
}

statemachine class cACS_Detonation_Weapon_Effects_Switch
{
    function ACS_Detonation_Weapon_Effects_Switch_Engage()
	{
		thePlayer.PlayBattleCry( 'BattleCryAttack', 1, true, false );	
		this.PushState('ACS_Detonation_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Detonation_Weapon_Effects_Switch_Engage in cACS_Detonation_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt_2		: CEntity;
	private var weaponSlotMatrix 					: Matrix;
	private var fxPos 								: Vector;
	private var fxRot 								: EulerAngles;
	private var targets 							: array<CGameplayEntity>;
	private var dist, ang							: float;
	private var pos, targetPos						: Vector;
	private var targetRot 							: EulerAngles;
	private var i									: int;
	private var npc 								: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Detonation_Weapon_Effects_Switch();
	}
	
	entry function Detonation_Weapon_Effects_Switch()
	{
		Detonation_Weapon_Effects_Switch_Activate();
	}
	
	/*
	latent function Detonation_Weapon_Effects_Switch_Activate()
	{	
		weaponEntity = thePlayer.GetInventory().GetItemEntityUnsafe(thePlayer.GetInventory().GetItemFromSlot('r_weapon'));
		weaponEntity.CalcEntitySlotMatrix('blood_fx_point', weaponSlotMatrix);
		
		fxPos = MatrixGetTranslation(weaponSlotMatrix);
		fxRot = weaponEntity.GetWorldRotation();
		
		if ( thePlayer.HasTag('aard_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\monsters\arachas\arachas_poison_cloud.w2ent", true ), fxPos, thePlayer.GetWorldRotation() );
			vfxEnt.PlayEffect('poison_cloud');
			vfxEnt.DestroyAfter(2.5);
		}
		else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffect('mutation_2_igni');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffect('mutation_2_aard_b');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( thePlayer.HasTag('igni_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffect('explode');
			vfxEnt.DestroyAfter(2.5);
		}
	}
	*/

	latent function Detonation_Weapon_Effects_Switch_Activate()
	{
		if (thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped'))
		{
			if ( thePlayer.HasBuff(EET_BlackBlood) )
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
			}
			else	
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_sword_equipped'))
		{
			if (thePlayer.HasTag('ACS_Shielded_Entity'))
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}	
			}
			else
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}	
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{ 
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if (!thePlayer.IsDoingSpecialAttack( false ))
			{
				dist = 2.5;
				ang = 60;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}	
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
		}
		else 
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
		}

		FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999 );
		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if ( npc == thePlayer || npc.HasTag('smokeman') )
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if ( thePlayer.HasTag('aard_sword_equipped') )
					{
						/*
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffect('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
						*/
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\monsters\arachas\arachas_poison_cloud.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('poison_cloud');
						vfxEnt.DestroyAfter(2.5);
					}
					else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffect('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
						
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('explode');
						vfxEnt.DestroyAfter(2.5);
					}
					else if ( thePlayer.HasTag('quen_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('axii_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('yrden_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffect('mutation_2_igni');
						vfxEnt.DestroyAfter(1.5);

						vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt_2.PlayEffect('explode');
						vfxEnt_2.DestroyAfter(2.5);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Passive_Weapon_Effects_Switch()
{
	var vACS_Passive_Weapon_Effects_Switch : cACS_Passive_Weapon_Effects_Switch;
	vACS_Passive_Weapon_Effects_Switch = new cACS_Passive_Weapon_Effects_Switch in theGame;
			
	vACS_Passive_Weapon_Effects_Switch.ACS_Passive_Weapon_Effects_Switch_Engage();
}

statemachine class cACS_Passive_Weapon_Effects_Switch
{
    function ACS_Passive_Weapon_Effects_Switch_Engage()
	{
		this.PushState('ACS_Passive_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Passive_Weapon_Effects_Switch_Engage in cACS_Passive_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2	: CEntity;
	private var weaponSlotMatrix 				: Matrix;
	private var fxPos 							: Vector;
	private var fxRot 							: EulerAngles;
	private var targets 						: array<CGameplayEntity>;
	private var dist, ang						: float;
	private var pos, targetPos					: Vector;
	private var targetRot 						: EulerAngles;
	private var i								: int;
	private var npc     						: CNewNPC;
	private var maxAdrenaline								: float;
	private var curAdrenaline								: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Passive_Weapon_Effects_Switch();
	}
	
	entry function Passive_Weapon_Effects_Switch()
	{
		Passive_Weapon_Effects_Switch_Activate();
	}

	latent function Passive_Weapon_Effects_Switch_Activate()
	{
		maxAdrenaline = thePlayer.GetStatMax(BCS_Focus);
		
		curAdrenaline = thePlayer.GetStat(BCS_Focus);

		if (thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped'))
		{
			if ( thePlayer.HasBuff(EET_BlackBlood) )
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
			}
			else	
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_sword_equipped'))
		{
			if (thePlayer.HasTag('ACS_Shielded_Entity'))
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}	
			}
			else
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}	
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{ 
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if (!thePlayer.IsDoingSpecialAttack( false ))
			{
				dist = 2.5;
				ang = 60;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}	
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
		}
		else 
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
		}

		FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999 );
		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if ( npc == thePlayer || npc.HasTag('smokeman') )
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if( ACS_OnHitEffects_Enabled() )
					{
						if ( ACS_GetWeaponMode() == 0 )
						{
							if ( !thePlayer.IsWeaponHeld( 'fist' ) )
							{
								if (thePlayer.GetEquippedSign() == ST_Igni)
								{
									if ( thePlayer.HasTag('yrden_sword_equipped')
									|| thePlayer.HasTag('axii_sword_equipped')
									|| thePlayer.HasTag('quen_sword_equipped')
									|| thePlayer.HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_1_hit_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									|| thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('critical_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (thePlayer.HasTag('aard_sword_equipped'))
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
										//vfxEnt.PlayEffect('hit');
										vfxEnt.PlayEffect('hit_refraction');
										vfxEnt.DestroyAfter(1.5);
									}
								}
								else if (thePlayer.GetEquippedSign() == ST_Quen)
								{
									if ( thePlayer.HasTag('yrden_sword_equipped')
									|| thePlayer.HasTag('axii_sword_equipped')
									|| thePlayer.HasTag('quen_sword_equipped')
									|| thePlayer.HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									|| thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (thePlayer.HasTag('aard_sword_equipped'))
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
										//vfxEnt.PlayEffect('hit');
										vfxEnt.PlayEffect('hit_refraction');
										vfxEnt.DestroyAfter(1.5);
									}
								}
								else if (thePlayer.GetEquippedSign() == ST_Aard)
								{
									if ( thePlayer.HasTag('yrden_sword_equipped')
									|| thePlayer.HasTag('axii_sword_equipped')
									|| thePlayer.HasTag('quen_sword_equipped')
									|| thePlayer.HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									|| thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (thePlayer.HasTag('aard_sword_equipped'))
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
										//vfxEnt.PlayEffect('hit');
										vfxEnt.PlayEffect('hit_refraction');
										vfxEnt.DestroyAfter(1.5);
									}
								}
								else if (thePlayer.GetEquippedSign() == ST_Axii)
								{
									if ( thePlayer.HasTag('yrden_sword_equipped')
									|| thePlayer.HasTag('axii_sword_equipped')
									|| thePlayer.HasTag('quen_sword_equipped')
									|| thePlayer.HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									|| thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (thePlayer.HasTag('aard_sword_equipped'))
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
										//vfxEnt.PlayEffect('hit');
										vfxEnt.PlayEffect('hit_refraction');
										vfxEnt.DestroyAfter(1.5);
									}
								}
								else if (thePlayer.GetEquippedSign() == ST_Yrden)
								{
									if ( thePlayer.HasTag('yrden_sword_equipped')
									|| thePlayer.HasTag('axii_sword_equipped')
									|| thePlayer.HasTag('quen_sword_equipped')
									|| thePlayer.HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('critical_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									|| thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffect('mutation_2_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (thePlayer.HasTag('aard_sword_equipped'))
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
										//vfxEnt.PlayEffect('hit');
										vfxEnt.PlayEffect('hit_refraction');
										vfxEnt.DestroyAfter(1.5);
									}
								}
							}
							else if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped') )
							{
								vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
								vfxEnt.PlayEffect('hit');
								vfxEnt.PlayEffect('hit_refraction');
								vfxEnt.DestroyAfter(1.5);

								if (thePlayer.HasBuff(EET_BlackBlood))
								{
									vfxEnt2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\lynx_rock_witch\lynx_rock_witch_slashes.w2ent", true ), targetPos, targetRot );
								
									if( RandF() < 0.5 ) 
									{
										if( RandF() < 0.5 ) 
										{
											if( RandF() < 0.5 ) 
											{
												vfxEnt2.PlayEffect('diagonal_up_left');
											}
											else
											{
												vfxEnt2.PlayEffect('diagonal_down_left');
											}
										}
										else
										{
											if( RandF() < 0.5 ) 
											{
												vfxEnt2.PlayEffect('down');
											}
											else
											{
												vfxEnt2.PlayEffect('up');
											}
										}
									}
									else
									{
										if( RandF() < 0.5 ) 
										{
											if( RandF() < 0.5 ) 
											{
												vfxEnt2.PlayEffect('diagonal_up_right');
											}
											else
											{
												vfxEnt2.PlayEffect('diagonal_down_right');
											}
										}
										else
										{
											if( RandF() < 0.5 ) 
											{
												vfxEnt2.PlayEffect('right');
											}
											else
											{
												vfxEnt2.PlayEffect('left');
											}
										}
									}
									
									vfxEnt2.DestroyAfter(1.5);
								}
							}	
						}
						else
						{
							if (thePlayer.IsAnyWeaponHeld()
							&& !thePlayer.IsWeaponHeld( 'fist' )
							)
							{
								if (
								npc.HasBuff(EET_Burning)
								|| npc.HasBuff(EET_Confusion)
								|| npc.HasBuff(EET_Stagger)
								|| npc.HasBuff(EET_Paralyzed)
								|| npc.HasBuff(EET_Slowdown)
								)
								{
									if ( thePlayer.HasTag('aard_sword_equipped') )
									{
										aard_blade_trail();
									}
									else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
									{
										aard_secondary_sword_trail();
									}
									else if ( thePlayer.HasTag('yrden_sword_equipped') )
									{
										yrden_sword_trail();
									}
									else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
									{
										yrden_secondary_sword_trail();
									}
									else if ( thePlayer.HasTag('axii_sword_equipped') )
									{
										axii_sword_trail();
									}
									else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
									{
										axii_secondary_sword_trail();
									}
									else if ( thePlayer.HasTag('quen_sword_equipped') )
									{
										quen_sword_glow();
										quen_sword_trail();
									}
									else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
									{
										quen_secondary_sword_trail();
									}
								}

								if ( thePlayer.GetEquippedSign() == ST_Igni )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if ( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if ( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( thePlayer.GetEquippedSign() == ST_Axii )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( thePlayer.GetEquippedSign() == ST_Aard )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( thePlayer.GetEquippedSign() == ST_Quen )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( thePlayer.GetEquippedSign() == ST_Yrden )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( thePlayer.HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_sword_equipped') )
												{
													quen_sword_glow();
													quen_sword_trail();
												}
												else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffect('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
							}
							else
							{
								if ( thePlayer.HasTag('vampire_claws_equipped') )
								{
									vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
									vfxEnt.PlayEffect('hit');
									vfxEnt.PlayEffect('hit_refraction');
									vfxEnt.DestroyAfter(1.5);

									if (thePlayer.HasBuff(EET_BlackBlood))
									{
										vfxEnt2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\lynx_rock_witch\lynx_rock_witch_slashes.w2ent", true ), targetPos, targetRot );
									
										if( RandF() < 0.5 ) 
										{
											if( RandF() < 0.5 ) 
											{
												if( RandF() < 0.5 ) 
												{
													vfxEnt2.PlayEffect('diagonal_up_left');
												}
												else
												{
													vfxEnt2.PlayEffect('diagonal_down_left');
												}
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													vfxEnt2.PlayEffect('down');
												}
												else
												{
													vfxEnt2.PlayEffect('up');
												}
											}
										}
										else
										{
											if( RandF() < 0.5 ) 
											{
												if( RandF() < 0.5 ) 
												{
													vfxEnt2.PlayEffect('diagonal_up_right');
												}
												else
												{
													vfxEnt2.PlayEffect('diagonal_down_right');
												}
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													vfxEnt2.PlayEffect('right');
												}
												else
												{
													vfxEnt2.PlayEffect('left');
												}
											}
										}
										
										vfxEnt2.DestroyAfter(1.5);
									}
								}
							}
						}
					}
					else
					{
						if ( thePlayer.HasTag('vampire_claws_equipped') )
						{
							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), targetPos, targetRot );
							vfxEnt.PlayEffect('hit');
							vfxEnt.PlayEffect('hit_refraction');
							vfxEnt.DestroyAfter(1.5);

							if (thePlayer.HasBuff(EET_BlackBlood))
							{
								vfxEnt2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\lynx_rock_witch\lynx_rock_witch_slashes.w2ent", true ), targetPos, targetRot );
									
								if( RandF() < 0.5 ) 
								{
									if( RandF() < 0.5 ) 
									{
										if( RandF() < 0.5 ) 
										{
											vfxEnt2.PlayEffect('diagonal_up_left');
										}
										else
										{
											vfxEnt2.PlayEffect('diagonal_down_left');
										}
									}
									else
									{
										if( RandF() < 0.5 ) 
										{
											vfxEnt2.PlayEffect('down');
										}
										else
										{
											vfxEnt2.PlayEffect('up');
										}
									}
								}
								else
								{
									if( RandF() < 0.5 ) 
									{
										if( RandF() < 0.5 ) 
										{
											vfxEnt2.PlayEffect('diagonal_up_right');
										}
										else
										{
											vfxEnt2.PlayEffect('diagonal_down_right');
										}
									}
									else
									{
										if( RandF() < 0.5 ) 
										{
											vfxEnt2.PlayEffect('right');
										}
										else
										{
											vfxEnt2.PlayEffect('left');
										}
									}
								}
								
								vfxEnt2.DestroyAfter(1.5);
							}
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Caretaker_Drain_Energy()
{
	var vACS_Caretaker_Drain_Energy : cACS_Caretaker_Drain_Energy;
	vACS_Caretaker_Drain_Energy = new cACS_Caretaker_Drain_Energy in theGame;
			
	vACS_Caretaker_Drain_Energy.ACS_Caretaker_Drain_Energy_Engage();
}

statemachine class cACS_Caretaker_Drain_Energy
{
    function ACS_Caretaker_Drain_Energy_Engage()
	{
		this.PushState('ACS_Caretaker_Drain_Energy_Engage');
	}
}

state ACS_Caretaker_Drain_Energy_Engage in cACS_Caretaker_Drain_Energy
{
	private var targets 						: array<CGameplayEntity>;
	private var dist, ang						: float;
	private var pos, targetPos					: Vector;
	private var targetRot 						: EulerAngles;
	private var i								: int;
	private var npc     						: CNewNPC;
	private var anchor							: CEntity;
	private var anchorTemplate					: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Caretaker_Drain_Energy_Entry();
	}
	
	entry function ACS_Caretaker_Drain_Energy_Entry()
	{
		ACS_Caretaker_Drain_Energy_Latent();
	}

	latent function ACS_Caretaker_Drain_Energy_Latent()
	{
		if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang =	60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.5;
				ang =	60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang =	60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.5;
				ang =	60;
			}	
		}

		FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999 );
		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();

			targetRot = npc.GetWorldRotation();

			if ( npc == thePlayer || npc.HasTag('smokeman') )
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if (ACS_GetItem_Caretaker_Shovel())
					{
						anchorTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );		
						anchor = (CEntity)theGame.CreateEntity( anchorTemplate, targetPos, targetRot );

						anchor.CreateAttachment( npc, 'head', Vector( 0, 0, -0.5 ) );

						thePlayer.PlayEffect('drain_energy', anchor);
						thePlayer.StopEffect('drain_energy');

						yrden_sword_effect_small();

						anchor.DestroyAfter(3);
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Marker_Switch()
{
	var vACS_Marker_Switch : cACS_Marker_Switch;
	vACS_Marker_Switch = new cACS_Marker_Switch in theGame;
	
	vACS_Marker_Switch.ACS_Marker_Switch_Engage();
}

statemachine class cACS_Marker_Switch
{
    function ACS_Marker_Switch_Engage()
	{
		this.PushState('ACS_Marker_Switch_Engage');
	}
}

state ACS_Marker_Switch_Engage in cACS_Marker_Switch
{
	private var markerNPC_1, markerNPC_2, markerNPC_3, markerNPC_4, markerNPC_5, markerNPC_6, markerNPC_7, markerNPC_8, markerNPC_9, markerNPC_10, markerNPC_11, markerNPC_12		: CEntity;
	private var markerTemplate 																		: CEntityTemplate;
	private var targets 																			: array<CGameplayEntity>;
	private var dist, ang																			: float;
	private var pos, targetPos, npcPos, attach_vec													: Vector;
	private var targetRot_1, attach_rot																: EulerAngles;
	private var i																					: int;
	private var npc     																			: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Passive_Weapon_Effects_Switch();
	}
	
	entry function Passive_Weapon_Effects_Switch()
	{
		GetACSWatcher().Remove_On_Hit_Tags();
		Passive_Weapon_Effects_Switch_Activate();
	}

	latent function Passive_Weapon_Effects_Switch_Activate()
	{
		if (thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('vampire_claws_equipped'))
		{
			if ( thePlayer.HasBuff(EET_BlackBlood) )
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang = 90;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang = 90;
				}
			}
			else	
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.25;
					ang = 60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.25;
					ang = 60;
				}
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_sword_equipped'))
		{
			if (thePlayer.HasTag('ACS_Shielded_Entity'))
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 5;
					ang =	135;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 5;
					ang =	135;
				}	
			}
			else
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 1.5;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 1.5;
					ang =	30;
				}	
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2.25;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2.25;
					ang =	30;
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{ 
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	30;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	30;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	90;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	90;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2;
				ang =	30;
			}	
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_sword_equipped'))
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.5;
				ang = 60;
			}
			else if (!thePlayer.IsDoingSpecialAttack( false ))
			{
				dist = 2.5;
				ang = 60;
			}
		}
		else if (!thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			if ( ACS_GetWeaponMode() == 0|| ACS_GetWeaponMode() == 1|| ACS_GetWeaponMode() == 2)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 3.5;
					ang =	180;
				}	
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				if ( thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( true ) )
				{
					dist = 2;
					ang =	60;
				}
				else if ( !thePlayer.IsDoingSpecialAttack( false ) )
				{
					dist = 2;
					ang =	60;
				}
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.5;
				ang =	30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.5;
				ang =	30;
			}
		}
		else if ( !thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 2.25;
				ang =	40;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 2.25;
				ang =	40;
			}
		}
		else 
		{
			if ( thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( true ) )
			{
				dist = 1.25;
				ang = 30;
			}
			else if ( !thePlayer.IsDoingSpecialAttack( false ) )
			{
				dist = 1.25;
				ang = 30;
			}
		}

		FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999 );
		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot_1 = npc.GetWorldRotation();

			if ( npc == thePlayer || npc.HasTag('smokeman') )
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if ( thePlayer.HasTag('aard_sword_equipped') 
					|| thePlayer.HasTag('aard_secondary_sword_equipped')
					|| thePlayer.HasTag('yrden_sword_equipped')
					|| thePlayer.HasTag('yrden_secondary_sword_equipped')
					|| thePlayer.HasTag('axii_sword_equipped') 
					|| thePlayer.HasTag('axii_secondary_sword_equipped') 
					|| thePlayer.HasTag('quen_sword_equipped') 
					|| thePlayer.HasTag('quen_secondary_sword_equipped') 
					|| thePlayer.HasTag('igni_sword_equipped_TAG') )
					{
						markerTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\quest\q702\702_08_vampire_vision\q702_magical_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() > 2.25
						|| npc.GetRadius() > 0.7
						)
						{
							attach_vec.Z = 2.75;
						}
						else
						{
							attach_vec.Z = 1.875;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_1.PlayEffect('glow');
						markerNPC_1.AddTag('PrimerMark');

						markerNPC_2 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Yaw = 30;

						markerNPC_2.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_2.PlayEffect('glow');
						markerNPC_2.AddTag('PrimerMark');

						markerNPC_3 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Yaw = 60;

						markerNPC_3.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_3.PlayEffect('glow');
						markerNPC_3.AddTag('PrimerMark');

						markerNPC_4 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 90;

						markerNPC_4.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_4.PlayEffect('glow');
						markerNPC_4.AddTag('PrimerMark');

						markerNPC_5 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 120;

						markerNPC_5.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_5.PlayEffect('glow');
						markerNPC_5.AddTag('PrimerMark');

						markerNPC_6 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 150;

						markerNPC_6.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_6.PlayEffect('glow');
						markerNPC_6.AddTag('PrimerMark');

						markerNPC_7 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 180;

						markerNPC_7.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_7.PlayEffect('glow');
						markerNPC_7.AddTag('PrimerMark');

						markerNPC_8 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 210;

						markerNPC_8.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_8.PlayEffect('glow');
						markerNPC_8.AddTag('PrimerMark');

						markerNPC_9 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 240;

						markerNPC_9.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_9.PlayEffect('glow');
						markerNPC_9.AddTag('PrimerMark');

						markerNPC_10 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 270;

						markerNPC_10.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_10.PlayEffect('glow');
						markerNPC_10.AddTag('PrimerMark');

						markerNPC_11 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 300;

						markerNPC_11.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_11.PlayEffect('glow');
						markerNPC_11.AddTag('PrimerMark');

						markerNPC_12 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 330;

						markerNPC_12.CreateAttachment( npc, , attach_vec, attach_rot );
						markerNPC_12.PlayEffect('glow');
						markerNPC_12.AddTag('PrimerMark');
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Sword_Array()
{
	var vACS_Sword_Array : cACS_Sword_Array;
	vACS_Sword_Array = new cACS_Sword_Array in theGame;
			
	vACS_Sword_Array.Switch();
}

function ACS_Sword_Array_Destroy()
{
	var sword_torso_anchor_1, static_torso_sword_1, static_torso_sword_2, static_torso_sword_3, static_torso_sword_4, static_torso_sword_5 : CEntity;	
	var i													: int;
	
	sword_torso_anchor_1 = (CEntity)theGame.GetEntityByTag( 'sword_torso_anchor_1' );
	//sword_torso_anchor_1.BreakAttachment();
	sword_torso_anchor_1.Destroy();
				
	static_torso_sword_1 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_1' );
	//static_torso_sword_1.BreakAttachment();
	static_torso_sword_1.StopEffect('glow');
	static_torso_sword_1.PlayEffect('disappear');
	static_torso_sword_1.DestroyAfter(0.4);

	static_torso_sword_2 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_2' );
	//static_torso_sword_2.BreakAttachment();
	static_torso_sword_2.StopEffect('glow');
	static_torso_sword_2.PlayEffect('disappear');
	static_torso_sword_2.DestroyAfter(0.4);

	static_torso_sword_3 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_3' );
	//static_torso_sword_3.BreakAttachment();
	static_torso_sword_3.StopEffect('glow');
	static_torso_sword_3.PlayEffect('disappear');
	static_torso_sword_3.DestroyAfter(0.4);

	static_torso_sword_4 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_4' );
	//static_torso_sword_4.BreakAttachment();
	static_torso_sword_4.StopEffect('glow');
	static_torso_sword_4.PlayEffect('disappear');
	static_torso_sword_4.DestroyAfter(0.4);

	static_torso_sword_5 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_5' );
	//static_torso_sword_5.BreakAttachment();
	static_torso_sword_5.StopEffect('glow');
	static_torso_sword_5.PlayEffect('disappear');
	static_torso_sword_5.DestroyAfter(0.4);

}

statemachine class cACS_Sword_Array
{
    function Switch()
	{
		if ( !thePlayer.HasTag('Swords_Ready') )
		{
			this.PushState('Ready');

			thePlayer.AddTag('Swords_Ready');
		}
		else if ( thePlayer.HasTag('Swords_Ready') )
		{
			this.PushState('Fire');

			thePlayer.RemoveTag('Swords_Ready');
		}
	}
}

state Ready in cACS_Sword_Array
{
	private var anchor_temp, sword_temp																													: CEntityTemplate;
	private var bonePosition, attach_vec																												: Vector;
	private var boneRotation, attach_rot																												: EulerAngles;
	private var sword_torso_anchor_1, static_torso_sword_1, static_torso_sword_2, static_torso_sword_3, static_torso_sword_4, static_torso_sword_5 		: CEntity;	
	private var movementAdjustor																														: CMovementAdjustor;
	private var ticket 																																	: SMovementAdjustmentRequestTicket;
	private var actor																																	: CActor;
	private var settings																																: SAnimatedComponentSlotAnimationSettings;
	private var action 																																	: W3DamageAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ready_Swords();
	}
	
	entry function Ready_Swords()
	{
		//thePlayer.ForceSetStat( BCS_Focus,  thePlayer.GetStat( BCS_Focus ) - (thePlayer.GetStat( BCS_Focus ) * 0.3) );

		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actor = (CActor)( thePlayer.GetTarget() );

		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene()
			&& !thePlayer.IsUsingHorse()
			&& !thePlayer.IsUsingVehicle()
			)
			{
				movementAdjustor.RotateTowards( ticket, actor );
			}
			
			if ( thePlayer.GetEquippedSign() == ST_Aard)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				if (thePlayer.IsAnyWeaponHeld())
				{
					if (thePlayer.IsWeaponHeld( 'fist' ))
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
					}
					else
					{
						if (RandRange(10) < 5) 
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_f_loop_ACS', 'PLAYER_SLOT', settings);
							}
							else
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_b_loop_ACS', 'PLAYER_SLOT', settings);
							}
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
						}
					}
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}

		ACS_Sword_Array_Destroy();
		Swords();
	}
	
	latent function Swords()
	{	
		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\items\quest_items\q604\q604_item__chalk.w2ent", true );
		
		sword_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\aerondight_proj_static.w2ent", true );

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'Trajectory' ), bonePosition, boneRotation );
		sword_torso_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		sword_torso_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'Trajectory', bonePosition, boneRotation );
		sword_torso_anchor_1.AddTag('sword_torso_anchor_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		static_torso_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_3 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_4 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_5 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// + down/ - up
		attach_rot.Roll = 0;

		attach_rot.Pitch = -110;
		
		// + left/ - right
		attach_rot.Yaw = 0;
		
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+up/-down
		attach_vec.Z = 3;
				
		static_torso_sword_1.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );

		thePlayer.PlayEffect('hit_lightning');
		thePlayer.StopEffect('hit_lightning');

		static_torso_sword_1.PlayEffect('glow');
		static_torso_sword_1.AddTag('static_torso_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 100;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 110;
		
		//+Up/-Down
		attach_vec.X = 1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 2;
				
		static_torso_sword_2.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_2.PlayEffect('glow');
		static_torso_sword_2.AddTag('static_torso_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 100;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 70;
		
		//+Up/-Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 2;
				
		static_torso_sword_3.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_3.PlayEffect('glow');
		static_torso_sword_3.AddTag('static_torso_sword_3');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 80;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 110;
		
		//+Up/-Down
		attach_vec.X = 1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 1;
				
		static_torso_sword_4.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_4.PlayEffect('glow');
		static_torso_sword_4.AddTag('static_torso_sword_4');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 80;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 70;
		
		//+Up/-Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 1;
				
		static_torso_sword_5.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_5.PlayEffect('glow');
		static_torso_sword_5.AddTag('static_torso_sword_5');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Fire in cACS_Sword_Array
{
	private var initpos					: Vector;
	private var sword 					: SwordProjectile;
	private var actor, pActor       	: CActor;
	private var targetPosition			: Vector;
	private var meshcomp 				: CComponent;
	private var h 						: float;
	private var movementAdjustor		: CMovementAdjustor;
	private var ticket 					: SMovementAdjustmentRequestTicket;
	private var settings				: SAnimatedComponentSlotAnimationSettings;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Swords_Fire();
	}
	
	entry function Swords_Fire()
	{
		thePlayer.ForceSetStat( BCS_Focus,  thePlayer.GetStat( BCS_Focus ) - (thePlayer.GetStat( BCS_Focus ) * 2/3 ) );

		settings.blendIn = 0.3f;
		settings.blendOut = 0.3f;

		actor = (CActor)( thePlayer.GetTarget() );

		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene()
			&& !thePlayer.IsUsingHorse()
			&& !thePlayer.IsUsingVehicle()
			)
			{
				movementAdjustor.RotateTowards( ticket, actor );
			}
			
			if ( thePlayer.GetEquippedSign() == ST_Aard)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				if (thePlayer.IsAnyWeaponHeld())
				{
					if (thePlayer.IsWeaponHeld( 'fist' ))
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
					}
					else
					{
						if (RandRange(10) < 5) 
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_f_loop_ACS', 'PLAYER_SLOT', settings);
							}
							else
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_b_loop_ACS', 'PLAYER_SLOT', settings);
							}
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
						}
					}
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{
			if ( thePlayer.GetEquippedSign() == ST_Aard)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				if (thePlayer.IsAnyWeaponHeld())
				{
					if (thePlayer.IsWeaponHeld( 'fist' ))
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
					}
					else
					{
						if (RandRange(10) < 5) 
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_f_loop_ACS', 'PLAYER_SLOT', settings);
							}
							else
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'strafe_walk_b_loop_ACS', 'PLAYER_SLOT', settings);
							}
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
						}
					}
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', settings);
				}
			}
		}

		ACS_Sword_Array_Destroy();
		Projectile_1();
		Projectile_2();
		Projectile_3();
		Projectile_4();
		Projectile_5();
	}
	
	latent function Projectile_1()
	{	
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			initpos = thePlayer.GetWorldPosition();				
			initpos.Z += 3;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = thePlayer.GetWorldPosition();				
			initpos.Z += 3;
								
			targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_2()
	{	
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.5;				
			initpos.Z += 2;
								
			targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_3()
	{	
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.5;				
			initpos.Z += 2;
								
			targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_4()
	{	
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1.5;				
			initpos.Z += 1;
								
			targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_5()
	{	
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1.5;				
			initpos.Z += 1;
								
			targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(thePlayer);
			sword.PlayEffect('appear');
			sword.PlayEffect('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function shoot_sword()
{
	var initpos					: Vector;
	var sword 					: SwordProjectile;
	var actor       			: CActor;
	var targetPosition			: Vector;
	var meshcomp 				: CComponent;
	var h 						: float;
		
	actor = (CActor)( thePlayer.GetTarget() );
		
	if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
	{	
		initpos = thePlayer.GetWorldPosition();				
		initpos.Z += 5;
					
		targetPosition = actor.PredictWorldPosition( 0.1 );
		targetPosition.Z += 1.1;
			
		sword = (SwordProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
			
		meshcomp = sword.GetComponentByClassName('CMeshComponent');
		h = 3;
		meshcomp.SetScale(Vector(h,h,h,1));	
			
		sword.Init(thePlayer);
		sword.PlayEffect('appear');
		sword.PlayEffect('glow');
		sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
		sword.DestroyAfter(31);
	}		
	else
	{
		initpos = thePlayer.GetWorldPosition();				
		initpos.Z += 5;
							
		targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;
			
		sword = (SwordProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
			
		meshcomp = sword.GetComponentByClassName('CMeshComponent');
		h = 3;
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		sword.Init(thePlayer);
		sword.PlayEffect('appear');
		sword.PlayEffect('glow');
		sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
		sword.DestroyAfter(31);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bats_Summon()
{
	var vACS_Bats_Summon : cACS_Bats_Summon;
	vACS_Bats_Summon = new cACS_Bats_Summon in theGame;
				
	vACS_Bats_Summon.ACS_Bats_Summon_Engage();
}

function ACS_Bat_Damage()
{
	var actortarget																										: CActor;
	var actors    																										: array<CActor>;
	var damage																											: float;
	var i																												: int;
	var dmg 																											: W3DamageAction;
	var targetVitality, targetEssence 																					: EBaseCharacterStats;

	//actors = GetActorsInRange(thePlayer, 7, 100, ,true);

	actors = thePlayer.GetNPCsAndPlayersInRange( 7, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

	//thePlayer.DrainStamina( ESAT_FixedValue, 0.046875 );

	//thePlayer.DrainStamina( ESAT_FixedValue, 0.0625 );

	thePlayer.DrainStamina( ESAT_FixedValue, 0.125 );

	for( i = 0; i < actors.Size(); i += 1 )
	{
		actortarget = (CActor)actors[i];

		if (actortarget.UsesEssence())
		{
			if ( actortarget.GetStat( BCS_Essence ) <= actortarget.GetStatMax( BCS_Essence ) * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = actortarget.GetStat( BCS_Essence ) * 0.000625;
			}
		}
		else if (actortarget.UsesVitality())
		{
			if ( actortarget.GetStat( BCS_Vitality ) <= actortarget.GetStatMax( BCS_Vitality ) * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = actortarget.GetStat( BCS_Vitality ) * 0.000625;
			}
		}

		if ( actortarget == thePlayer || actortarget.HasTag('smokeman') )
			continue;
			
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(NULL, actortarget, theGame, 'ACS_Bats_Damage', EHRT_None, CPS_Undefined, false, false, true, false);
		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(false);
		dmg.SetSuppressHitSounds(true);

		dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage );
					
		//dmg.AddEffectInfo( EET_Bleeding, 10 );
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;	
	}
}

statemachine class cACS_Bats_Summon
{
	function ACS_Bats_Summon_Engage()
	{
		this.PushState('ACS_Bats_Summon_Engage');
	}
}

state ACS_Bats_Summon_Engage in cACS_Bats_Summon
{
	private var playerRot																										: EulerAngles;
	private var markerNPC																										: CEntity;
	private var playerPos, spawnPos																								: Vector;
	private var i, markerCount																									: int;
	private var randRange, randAngle, dist																						: float;
	private var actortarget																										: CActor;
	private var actors    																										: array<CActor>;
	private var movementAdjustor																								: CMovementAdjustor;
	private var ticket																											: SMovementAdjustmentRequestTicket;
	
	event OnEnterState(prevStateName : name)
	{
		ACS_Bats_Summon_Entry();
	}
		
	entry function ACS_Bats_Summon_Entry()
	{
		ACS_Bats_Summon_Latent();

		BlindOrBleed();
	}

	latent function BlindOrBleed()
	{
		//actors = GetActorsInRange(thePlayer, 10, 100, ,true);

		actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			if ( actortarget == thePlayer || actortarget.HasTag('smokeman') )
			continue;

			dist = (((CMovingPhysicalAgentComponent)actortarget.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 1.75;

			movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor.CancelByName( 'ACS_AardPull' );
			ticket = movementAdjustor.CreateNewRequest( 'ACS_AardPull' );
			movementAdjustor.AdjustmentDuration( ticket, 1 );
			movementAdjustor.ShouldStartAt(ticket, actortarget.GetWorldPosition());
			movementAdjustor.AdjustLocationVertically( ticket, true );
			movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5 );

			movementAdjustor.SlideTowards( ticket, thePlayer, dist, dist );	

			if ( RandF() < 0.75 )
			{
				if( RandF() < 0.025 ) 
				{
					if( actortarget.HasBuff( EET_Bleeding ) ) 
					{ 	
						actortarget.RemoveBuff( EET_Bleeding, true, 'acs_bat_effect' ); 						
					}

					if( !actortarget.IsImmuneToBuff( EET_Blindness ) && !actortarget.HasBuff( EET_Blindness ) ) 
					{ 	
						actortarget.AddEffectDefault( EET_Blindness, actortarget, 'acs_bat_effect' ); 						
					}
				}
				else
				{
					if( actortarget.HasBuff( EET_Blindness ) ) 
					{ 	
						actortarget.RemoveBuff( EET_Blindness, true, 'acs_bat_effect' ); 						
					}

					if( !actortarget.IsImmuneToBuff( EET_Bleeding ) && !actortarget.HasBuff( EET_Bleeding ) ) 
					{ 	
						actortarget.AddEffectDefault( EET_Bleeding, actortarget, 'acs_bat_effect' ); 						
					}
				}
			}
		}
	}
		
	latent function ACS_Bats_Summon_Latent()
	{
		playerPos = thePlayer.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();
	
		markerCount = 6;

		for( i = 0; i < markerCount; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			spawnPos.Z -= 1;

			playerRot.Yaw = RandRangeF(360,1);
			playerRot.Pitch = RandRangeF(45,-45);

			if( RandF() < 0.75 ) 
			{
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_01.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_02.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_03.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
		
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_04.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_05.w2ent"
						
						, true ), spawnPos, playerRot );
				}
				else 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_06.w2ent"
						
						, true ), spawnPos, playerRot );
				}
			}
			markerNPC.PlayEffect('bat_swarm');
			markerNPC.DestroyAfter(3);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_bruxa_blood_resource()
{
	var vACS_bruxa_blood_resource : cACS_bruxa_blood_resource;
	vACS_bruxa_blood_resource = new cACS_bruxa_blood_resource in theGame;
			
	vACS_bruxa_blood_resource.ACS_bruxa_blood_resource_Engage();
}

statemachine class cACS_bruxa_blood_resource
{
    function ACS_bruxa_blood_resource_Engage()
	{
		this.PushState('ACS_bruxa_blood_resource_Engage');
	}
}

state ACS_bruxa_blood_resource_Engage in cACS_bruxa_blood_resource
{
	private var npc 																																						: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var vfxEnt																																						: CEntity;
	private var targetRotationNPC																																			: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		ACS_bruxa_blood_resource_ENTRY();
	}
	
	entry function ACS_bruxa_blood_resource_ENTRY()
	{
		ACS_bruxa_blood_resource_LATENT();
	}
	
	latent function ACS_bruxa_blood_resource_LATENT()
	{
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			targetRotationNPC = npc.GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			if( actors.Size() > 0 )
			{	
				if 
				(
				!((CNewNPC)npc).IsFlying()
				&& !npc.HasAbility('mon_garkain')
				&& !npc.HasAbility('mon_sharley_base')
				&& !npc.HasAbility('mon_bies_base')
				&& !npc.HasAbility('mon_golem_base')
				&& !npc.HasAbility('mon_endriaga_base')
				&& !npc.HasAbility('mon_arachas_base')
				&& !npc.HasAbility('mon_kikimore_base')
				&& !npc.HasAbility('mon_black_spider_base')
				&& !npc.HasAbility('mon_black_spider_ep2_base')
				&& !npc.HasAbility('mon_ice_giant')
				&& !npc.HasAbility('mon_cyclops')
				&& !npc.HasAbility('mon_knight_giant')
				&& !npc.HasAbility('mon_cloud_giant')
				&& !npc.HasAbility('mon_troll_base')
				)
				{
					vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_9\mutation_9_hit.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
					vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
					vfxEnt.PlayEffect('hit');
					vfxEnt.DestroyAfter(1);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Hijack_Marker_Create()
{
	var vACS_Hijack_Marker_Create : cACS_Hijack_Marker_Create;
	vACS_Hijack_Marker_Create = new cACS_Hijack_Marker_Create in theGame;
			
	vACS_Hijack_Marker_Create.ACS_Hijack_Marker_Create_Engage();
}

statemachine class cACS_Hijack_Marker_Create
{
    function ACS_Hijack_Marker_Create_Engage()
	{
		this.PushState('ACS_Hijack_Marker_Create_Engage');
	}
}

state ACS_Hijack_Marker_Create_Engage in cACS_Hijack_Marker_Create
{
	private var npc 																																						: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var vfxEnt																																						: CEntity;
	private var targetRotationNPC																																			: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		ACS_Hijack_Marker_Create_ENTRY();
	}
	
	entry function ACS_Hijack_Marker_Create_ENTRY()
	{
		ACS_Hijack_Marker_Create_LATENT();
	}
	
	latent function ACS_Hijack_Marker_Create_LATENT()
	{
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim', true);

		ACS_Hijack_Marker_2_Destroy();

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			targetRotationNPC = npc.GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			if( actors.Size() > 0 )
			{	
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\quest\q604\604_11_cellar\ground_smoke_ent.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );

				vfxEnt.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

				vfxEnt.StopEffect('ground_smoke');

				vfxEnt.PlayEffect('ground_smoke');

				vfxEnt.AddTag('Hijack_Marker_2');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Arrow_Create()
{
	var vACS_Arrow_Create : cACS_Arrow_Create;
	vACS_Arrow_Create = new cACS_Arrow_Create in theGame;
			
	vACS_Arrow_Create.ACS_Arrow_Create_Engage();
}

function ACS_Arrow_Create_Ready()
{
	var vACS_Arrow_Create : cACS_Arrow_Create;
	vACS_Arrow_Create = new cACS_Arrow_Create in theGame;
			
	vACS_Arrow_Create.ACS_Arrow_Create_Ready_Engage();
}

statemachine class cACS_Arrow_Create
{
    function ACS_Arrow_Create_Engage()
	{
		this.PushState('ACS_Arrow_Create_Engage');
	}

	function ACS_Arrow_Create_Ready_Engage()
	{
		this.PushState('ACS_Arrow_Create_Ready_Engage');
	}
}

state ACS_Arrow_Create_Engage in cACS_Arrow_Create
{
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var arrow1									: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Arrow_Create_Entry();
	}
	
	entry function Arrow_Create_Entry()
	{
		Arrow_Create_Latent();
	}
	
	latent function Arrow_Create_Latent()
	{
		if (thePlayer.HasTag('acs_bow_active'))
		{
			//ACS_Bow_Arrow().Destroy();
			ACS_Bow_Arrow().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), thePlayer.GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffect('glow');

			if (thePlayer.GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffect( 'fire' );
			}

			arrow1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');
		}	
	}
}

state ACS_Arrow_Create_Ready_Engage in cACS_Arrow_Create
{
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var arrow1, vfxEnt							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Arrow_Create_Ready_Entry();
	}
	
	entry function Arrow_Create_Ready_Entry()
	{
		Arrow_Create_Ready_Latent();
	}
	
	latent function Arrow_Create_Ready_Latent()
	{
		if (thePlayer.HasTag('acs_bow_active'))
		{
			ACS_Bow_Arrow().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), thePlayer.GetWorldPosition() );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffect('glow');

			if (thePlayer.GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffect( 'fire' );
			}

			arrow1.CreateAttachment( thePlayer, 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');

			if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), thePlayer.GetWorldPosition() );

				vfxEnt.CreateAttachment( thePlayer, 'r_weapon' );
				
				vfxEnt.PlayEffect('diagonal_up_left');
				vfxEnt.PlayEffect('diagonal_down_left');
				vfxEnt.PlayEffect('down');
				vfxEnt.PlayEffect('up');
				vfxEnt.PlayEffect('diagonal_up_right');
				vfxEnt.PlayEffect('diagonal_down_right');
				vfxEnt.PlayEffect('right');
				vfxEnt.PlayEffect('left');
				vfxEnt.PlayEffect('lightning_fx');
				vfxEnt.PlayEffect('shock');

				vfxEnt.AddTag('ACS_Bow_Arrow_Stationary_Effect');

				vfxEnt.DestroyAfter(2);
			}
		}	
	}
}

function ACS_Bow_Arrow() : CEntity
{
	var arrow 			 : CEntity;
	
	arrow = (CEntity)theGame.GetEntityByTag( 'ACS_Bow_Arrow' );
	return arrow;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoot_Bow()
{
	var vACS_Shoot_Bow : cACS_Shoot_Bow;
	vACS_Shoot_Bow = new cACS_Shoot_Bow in theGame;
			
	vACS_Shoot_Bow.ACS_Shoot_Bow_Engage();
}

statemachine class cACS_Shoot_Bow
{
    function ACS_Shoot_Bow_Engage()
	{
		this.PushState('ACS_Shoot_Bow_Engage');
	}
}

state ACS_Shoot_Bow_Engage in cACS_Shoot_Bow
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: ACSBowProjectileMoving;
	private var proj_2	 																																					: ACSBowProjectile;
	private var initpos, targetPositionNPC, targetPosition																													: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
	private var targetDistance																																				: float;
	private var meshcomp 																																					: CComponent;
	private var h 																																							: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ShootBowEntry();
	}
	
	entry function ShootBowEntry()
	{
		LockEntryFunction(true);
		ShootBowLatent();
		LockEntryFunction(false);
	}
	
	latent function ShootBowLatent()
	{	
		ACS_Bow_Arrow().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACS_Bow_Arrow().DestroyAfter(0.0125);

		actortarget = (CActor)( thePlayer.GetTarget() );	

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actortarget.GetWorldPosition() ) ;

		initpos = thePlayer.GetBoneWorldPosition('r_hand');		
		//initpos.Z += 0.5;

		if( targetDistance <= 3 * 3 ) 
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				//targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				//targetPositionNPC.Z += RandRangeF(0.1,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
		}
		else if( targetDistance > 3 * 3 && targetDistance <= 7.5*7.5 ) 
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.25);
				targetPositionNPC.X += RandRangeF(0.15,-0.15);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				targetPositionNPC.Z += RandRangeF(0,-0.25);
				targetPositionNPC.X += RandRangeF(0.15,-0.15);
			}
		}
		else
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
		}

		targetPosition =  thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 20;
		targetPosition.Z += 1.5;

		if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{		
			proj_2 = (ACSBowProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\bow_projectile.w2ent"
				, true ), initpos );
			
			meshcomp = proj_2.GetComponentByClassName('CMeshComponent');
			h = 2;
			meshcomp.SetScale(Vector(h,h,h,1));	

			proj_2.Init(thePlayer);

			if (thePlayer.GetEquippedSign() == ST_Igni)
			{
				proj_2.PlayEffect( 'fire' );
			}

			proj_2.PlayEffect('glow');

			if( ACS_AttitudeCheck ( actortarget ) && thePlayer.IsInCombat() && actortarget.IsAlive() )
			{
				proj_2.PlayEffect('arrow_trail_fire');
				proj_2.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPositionNPC, 500  );
			}
			else
			{
				proj_2.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPosition, 500  );
			}

			proj_2.DestroyAfter(31);
		}
		else
		{
			proj_1 = (ACSBowProjectileMoving)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				, true ), initpos );

			proj_1.Init(thePlayer);

			if (thePlayer.GetEquippedSign() == ST_Igni)
			{
				proj_1.PlayEffect( 'fire' );
			}

			proj_1.PlayEffect('glow');

			if( ACS_AttitudeCheck ( actortarget ) && thePlayer.IsInCombat() && actortarget.IsAlive() )
			{
				if ( actortarget.HasTag('ACS_second_bow_moving_projectile'))
				{
					proj_1.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPositionNPC, 500  );
					proj_1.PlayEffect('arrow_trail_fire');
				}
				else
				{
					proj_1.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPositionNPC, 500  );
				}
			}
			else
			{
				proj_1.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500  );
			}

			proj_1.DestroyAfter(31);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoot_Bow_Stationary()
{
	var vACS_Shoot_Bow_Stationary : cACS_Shoot_Bow_Stationary;
	vACS_Shoot_Bow_Stationary = new cACS_Shoot_Bow_Stationary in theGame;
			
	vACS_Shoot_Bow_Stationary.ACS_Shoot_Bow_Stationary_Engage();
}

statemachine class cACS_Shoot_Bow_Stationary
{
    function ACS_Shoot_Bow_Stationary_Engage()
	{
		this.PushState('ACS_Shoot_Bow_Stationary_Engage');
	}
}

state ACS_Shoot_Bow_Stationary_Engage in cACS_Shoot_Bow_Stationary
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3IceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffect('fire_fx');
			proj_1.PlayEffect('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
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
	private var targetRotationNPC												: EulerAngles;
	private var actor															: CActor;
	private var lightning, lightning_2, markerNPC, vfxEnt						: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var actorPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

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
		GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax( BCS_Stamina )/2, 1 );

		targetRotationNPC = actor.GetWorldRotation();
		targetRotationNPC.Yaw = RandRangeF(360,1);
		targetRotationNPC.Pitch = RandRangeF(45,-45);
		
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		if (!actor.HasBuff(EET_HeavyKnockdown)
		&& !actor.HasBuff(EET_Burning) )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			vfxEnt.CreateAttachment( actor, , Vector( 0, 0, 1.5 ) );	
			vfxEnt.PlayEffectSingle('critical_quen');
			vfxEnt.DestroyAfter(2);
							
			lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			lightning.PlayEffectSingle('pre_lightning');
			lightning.PlayEffectSingle('lightning');
			lightning.DestroyAfter(1.5);

			lightning_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\sq209\sq209_lightning_scene.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			lightning_2.PlayEffectSingle('lighgtning');
			lightning_2.DestroyAfter(1.5);
		
			actor.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'console' );

			actor.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'console' );

			if (actor.IsOnGround())
			{
				temp = (CEntityTemplate)LoadResourceAsync( 

				"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
					
				, true );

				actorPos = actor.GetWorldPosition();
				
				count = 6;
					
				for( i = 0; i < count; i += 1 )
				{
					randRange = 2.5 + 2.5 * RandF();
					randAngle = 2 * Pi() * RandF();
					
					spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
					spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
					spawnPos.Z = actorPos.Z;
					
					markerNPC = theGame.CreateEntity( temp, TraceFloor( spawnPos ), actor.GetWorldRotation() );

					markerNPC.PlayEffectSingle('explosion');
					markerNPC.DestroyAfter(7);
				}

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( actor.GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 2.5f, 1);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Marker_Fire()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Fire_Engage();
}

function ACS_Marker_Smoke()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Smoke_Engage();
}

function ACS_Marker_Lightning()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Lightning_Engage();
}

statemachine class cACS_Marker
{
    function ACS_Marker_Fire_Engage()
	{
		this.PushState('ACS_Marker_Fire_Engage');
	}

	function ACS_Marker_Lightning_Engage()
	{
		this.PushState('ACS_Marker_Lightning_Engage');
	}

	function ACS_Marker_Smoke_Engage()
	{
		this.PushState('ACS_Marker_Smoke_Engage');
	}
}

state ACS_Marker_Smoke_Engage in cACS_Marker
{
	private var markerNPC, markerNPC_2											: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Smoke_Entry();
	}
	
	entry function ACS_Marker_Smoke_Entry()
	{
		ACS_Marker_Smoke_Latent();
	}
	
	latent function ACS_Marker_Smoke_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q604\604_11_cellar\ground_smoke_ent.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();

		markerNPC = theGame.CreateEntity( temp, TraceFloor( playerPos ), GetWitcherPlayer().GetWorldRotation() );

		markerNPC.PlayEffectSingle('ground_smoke');
		markerNPC.DestroyAfter(3);

		markerNPC_2 = theGame.CreateEntity( temp, TraceFloor( playerPos ), GetWitcherPlayer().GetWorldRotation() );

		markerNPC_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, -1 ) );	

		markerNPC_2.PlayEffectSingle('ground_smoke');
		markerNPC_2.DestroyAfter(3.5);
		
		/*
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 1.5 + 1.5 * RandF();
			randAngle = 0.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC_2 = theGame.CreateEntity( temp, TraceFloor( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC_2.PlayEffectSingle('ground_smoke');
			markerNPC_2.DestroyAfter(7);
		}
		*/

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Marker_Fire_Engage in cACS_Marker
{
	private var markerNPC, markerNPC_2											: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, playerPosLower, spawnPos								: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Fire_Entry();
	}
	
	entry function ACS_Marker_Fire_Entry()
	{
		ACS_Marker_Fire_Latent();
	}
	
	latent function ACS_Marker_Fire_Latent()
	{
		playerPosLower = GetWitcherPlayer().GetWorldPosition();
		playerPosLower.Z -= 6;

		markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\quest\q701\q701_02_roof_fire.w2ent"

			"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_hut_fire.w2ent"
			
			, true ), playerPosLower, EulerAngles(0,0,0) );

		markerNPC.PlayEffectSingle('fire_01');
		//markerNPC.PlayEffectSingle('fire_02');
		markerNPC.DestroyAfter(5);

		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC_2 = theGame.CreateEntity( temp, TraceFloor( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC_2.PlayEffectSingle('explosion');
			markerNPC_2.DestroyAfter(7);
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 5.5f, 5.f, 1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Marker_Lightning_Engage in cACS_Marker
{
	private var markerNPC														: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Lightning_Entry();
	}
	
	entry function ACS_Marker_Lightning_Entry()
	{
		ACS_Marker_Lightning_Latent();
	}
	
	latent function ACS_Marker_Lightning_Latent()
	{
		/*
		markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			//"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_hut_fire.w2ent"
			, true ), TraceFloor( GetWitcherPlayer().GetWorldPosition() ), EulerAngles(0,0,0) );
		markerNPC.PlayEffectSingle('explosion');
		//markerNPC.PlayEffectSingle('fire_01');
		markerNPC.StopAllEffectsAfter(3);
		markerNPC.DestroyAfter(3);
		*/

		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC = theGame.CreateEntity( temp, TraceFloor( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC.PlayEffectSingle('explosion');
			markerNPC.DestroyAfter(7);
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 5.f, 1);
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
	private var npc     														: CNewNPC;
	private var actors    														: array<CActor>;
	private var lightning, markerNPC, vfxEnt									: CEntity;
	private var targetRotationNPC												: EulerAngles;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var actorPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

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
		//actors = GetActorsInRange(GetWitcherPlayer(), 55, 20);
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 55, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{		
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if( VecDistance2D( npc.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 8 ) 
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
							vfxEnt.PlayEffectSingle('critical_quen');
							vfxEnt.DestroyAfter(1.5);

							lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
							lightning.PlayEffectSingle('pre_lightning');
							lightning.PlayEffectSingle('lightning');
							lightning.DestroyAfter(1.5);
							
							if (npc.IsOnGround())
							{
								temp = (CEntityTemplate)LoadResource( 

								"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
									
								, true );

								actorPos = npc.GetWorldPosition();
								
								count = 6;
									
								for( i = 0; i < count; i += 1 )
								{
									randRange = 2.5 + 2.5 * RandF();
									randAngle = 2 * Pi() * RandF();
									
									spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
									spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
									spawnPos.Z = actorPos.Z;
									
									markerNPC = theGame.CreateEntity( temp, TraceFloor( spawnPos ), npc.GetWorldRotation() );

									markerNPC.PlayEffectSingle('explosion');
									markerNPC.DestroyAfter(7);
								}

								theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( npc.GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 5.f, 1);
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
		//actors = GetActorsInRange(GetWitcherPlayer(), 2.5, 3);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

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
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
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
		//actors = GetActorsInRange(GetWitcherPlayer(), 5, 20);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

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
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
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
		//actors = GetActorsInRange(GetWitcherPlayer(), 10, 20);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

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
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), TraceFloor( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
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
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		lightning1 = (CEntity)theGame.GetEntityByTag( 'lightning_area_1' );
		lightning1.Destroy();
		
		if (actor.IsOnGround())
		{
			lightning2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\quests\main_quests\quest_files\q704b_fairy_tale\entities\giant\q704_ft_lightning_area.w2ent", true ), TraceFloor( actor.GetWorldPosition() ), actor.GetWorldRotation() );
			lightning2.PlayEffectSingle('lightning_area');
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
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		rock_pillar_temp = (CEntityTemplate)LoadResource( "gameplay\abilities\elemental\elemental_dao_pillar.w2ent", true );
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
				markerNPC.PlayEffectSingle('marker_fx');
				markerNPC.PlayEffectSingle('circle_stone');
				markerNPC.DestroyAfter(5);
			}
		}

		if (actor.IsOnGround())
		{
			//actors = GetActorsInRange(actor, 6, 20);

			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 6, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
				
				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
					{
						if (!npc.HasBuff(EET_HeavyKnockdown))
						{
							npc.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'ACS_Rock_Pillar' );
						}
					}
				}
			}
		}

		GetWitcherPlayer().PlayEffectSingle('stomp');
		GetWitcherPlayer().StopEffect('stomp');

		GetWitcherPlayer().PlayEffectSingle('earthquake_fx');
		GetWitcherPlayer().StopEffect('earthquake_fx');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), TraceFloor (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterarc_LVL_1()
{
	var vACS_AOE_Waterarc_LVL_1 : cACS_AOE_Waterarc_LVL_1;
	vACS_AOE_Waterarc_LVL_1 = new cACS_AOE_Waterarc_LVL_1 in theGame;
			
	vACS_AOE_Waterarc_LVL_1.ACS_AOE_Waterarc_LVL_1_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_1
{
    function ACS_AOE_Waterarc_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_1_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_1_Engage in cACS_AOE_Waterarc_LVL_1
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
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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

function ACS_AOE_Waterarc_LVL_2()
{
	var vACS_AOE_Waterarc_LVL_2 : cACS_AOE_Waterarc_LVL_2;
	vACS_AOE_Waterarc_LVL_2 = new cACS_AOE_Waterarc_LVL_2 in theGame;
			
	vACS_AOE_Waterarc_LVL_2.ACS_AOE_Waterarc_LVL_2_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_2
{
    function ACS_AOE_Waterarc_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_2_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_2_Engage in cACS_AOE_Waterarc_LVL_2
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
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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

function ACS_AOE_Waterarc_LVL_3()
{
	var vACS_AOE_Waterarc_LVL_3 : cACS_AOE_Waterarc_LVL_3;
	vACS_AOE_Waterarc_LVL_3 = new cACS_AOE_Waterarc_LVL_3 in theGame;
			
	vACS_AOE_Waterarc_LVL_3.ACS_AOE_Waterarc_LVL_3_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_3
{
    function ACS_AOE_Waterarc_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_3_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_3_Engage in cACS_AOE_Waterarc_LVL_3
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
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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


function ACS_AOE_Waterpillar_LVL_1()
{
	var vACS_AOE_Waterpillar_LVL_1 : cACS_AOE_Waterpillar_LVL_1;
	vACS_AOE_Waterpillar_LVL_1 = new cACS_AOE_Waterpillar_LVL_1 in theGame;
			
	vACS_AOE_Waterpillar_LVL_1.ACS_AOE_Waterpillar_LVL_1_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_1
{
    function ACS_AOE_Waterpillar_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_1_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_1_Engage in cACS_AOE_Waterpillar_LVL_1
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
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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

function ACS_AOE_Waterpillar_LVL_2()
{
	var vACS_AOE_Waterpillar_LVL_2 : cACS_AOE_Waterpillar_LVL_2;
	vACS_AOE_Waterpillar_LVL_2 = new cACS_AOE_Waterpillar_LVL_2 in theGame;
			
	vACS_AOE_Waterpillar_LVL_2.ACS_AOE_Waterpillar_LVL_2_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_2
{
    function ACS_AOE_Waterpillar_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_2_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_2_Engage in cACS_AOE_Waterpillar_LVL_2
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
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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

function ACS_AOE_Waterpillar_LVL_3()
{
	var vACS_AOE_Waterpillar_LVL_3 : cACS_AOE_Waterpillar_LVL_3;
	vACS_AOE_Waterpillar_LVL_3 = new cACS_AOE_Waterpillar_LVL_3 in theGame;
			
	vACS_AOE_Waterpillar_LVL_3.ACS_AOE_Waterpillar_LVL_3_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_3
{
    function ACS_AOE_Waterpillar_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_3_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_3_Engage in cACS_AOE_Waterpillar_LVL_3
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
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
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

function ACS_AOE_Bloodarc_LVL_1()
{
	var vACS_AOE_Bloodarc_LVL_1 : cACS_AOE_Bloodarc_LVL_1;
	vACS_AOE_Bloodarc_LVL_1 = new cACS_AOE_Bloodarc_LVL_1 in theGame;
			
	vACS_AOE_Bloodarc_LVL_1.ACS_AOE_Bloodarc_LVL_1_Engage();
}

statemachine class cACS_AOE_Bloodarc_LVL_1
{
    function ACS_AOE_Bloodarc_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_1_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_1_Engage in cACS_AOE_Bloodarc_LVL_1
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
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Bloodarc_LVL_2()
{
	var vACS_AOE_Bloodarc_LVL_2 : cACS_AOE_Bloodarc_LVL_2;
	vACS_AOE_Bloodarc_LVL_2 = new cACS_AOE_Bloodarc_LVL_2 in theGame;
			
	vACS_AOE_Bloodarc_LVL_2.ACS_AOE_Bloodarc_LVL_2_Engage();
}

statemachine class cACS_AOE_Bloodarc_LVL_2
{
    function ACS_AOE_Bloodarc_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_2_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_2_Engage in cACS_AOE_Bloodarc_LVL_2
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
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_AOE_Bloodarc_LVL_3
{
    function ACS_AOE_Bloodarc_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_3_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_3_Engage in cACS_AOE_Bloodarc_LVL_3
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
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');

			markerNPC.PlayEffect('blood_diagonal_up_right');

			markerNPC.PlayEffect('blood_diagonal_up_left');

			markerNPC.PlayEffect('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('critical_igni');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('critical_igni');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
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
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
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

	maxAdrenaline = GetWitcherPlayer().GetStatMax(BCS_Focus);
		
	curAdrenaline = GetWitcherPlayer().GetStat(BCS_Focus);

	GetACSWatcher().RemoveTimer('RendProjectileSwitchDelay');

	if ( ACS_ElementalRend_Enabled() )
	{
		if (curAdrenaline >= maxAdrenaline * 2/3)
		{
			if( GetWitcherPlayer().GetEquippedSign() == ST_Igni && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Ifrit_Fire_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Axii && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Eredin_Frost_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Aard && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Golem_Stone_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Quen && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Root_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Yrden && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
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
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSEredinFrostLine;
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
		//position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && !GetWitcherPlayer().HasTag('eredin_frost_proj_1st') && !GetWitcherPlayer().HasTag('eredin_frost_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.10 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}		
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('eredin_frost_proj_begin');
			GetWitcherPlayer().AddTag('eredin_frost_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && GetWitcherPlayer().HasTag('eredin_frost_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.25 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_1st');
			GetWitcherPlayer().AddTag('eredin_frost_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && GetWitcherPlayer().HasTag('eredin_frost_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.75 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_begin');
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_1st');
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_2nd');
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
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSFireLine;
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
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Ifrit_Fire_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ifrit_Fire_Projectile_Activate()
	{
		//position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && !GetWitcherPlayer().HasTag('ifrit_fire_proj_1st') && !GetWitcherPlayer().HasTag('ifrit_fire_proj_2nd'))
		{	
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('ifrit_fire_proj_begin');
			GetWitcherPlayer().AddTag('ifrit_fire_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && GetWitcherPlayer().HasTag('ifrit_fire_proj_1st'))
		{
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_1st');
			GetWitcherPlayer().AddTag('ifrit_fire_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && GetWitcherPlayer().HasTag('ifrit_fire_proj_2nd'))
		{	
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_begin');
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_1st');
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_2nd');
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
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSRockLine;
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
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Golem_Stone_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Golem_Stone_Projectile_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2.2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('golem_stone_proj_begin') && !GetWitcherPlayer().HasTag('golem_stone_proj_1st') && !GetWitcherPlayer().HasTag('golem_stone_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('golem_stone_proj_begin');
			GetWitcherPlayer().AddTag('golem_stone_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('golem_stone_proj_begin') && GetWitcherPlayer().HasTag('golem_stone_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('golem_stone_proj_1st');
			GetWitcherPlayer().AddTag('golem_stone_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('golem_stone_proj_begin') && GetWitcherPlayer().HasTag('golem_stone_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('golem_stone_proj_begin');
			GetWitcherPlayer().RemoveTag('golem_stone_proj_1st');
			GetWitcherPlayer().RemoveTag('golem_stone_proj_2nd');
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
	private var proj_1, proj_2, proj_3, proj_4, proj_5 																														: W3ACSRootAttack;
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
		position_1 = GetWitcherPlayer().GetTarget().GetWorldPosition();
		position_1 = TraceFloor(position_1);
		
		position_2 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * 2.5;
		position_2 = TraceFloor(position_2);
		
		position_3 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * -2.5;
		position_3 = TraceFloor(position_3);
		
		position_4 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * 5.5;
		position_4 = TraceFloor(position_4);
		
		position_5 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * -5.5;
		position_5 = TraceFloor(position_5);
		
		if (!GetWitcherPlayer().HasTag('root_proj_begin') && !GetWitcherPlayer().HasTag('root_proj_1st') && !GetWitcherPlayer().HasTag('root_proj_2nd'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);		
			
			GetWitcherPlayer().AddTag('root_proj_begin');
			GetWitcherPlayer().AddTag('root_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('root_proj_begin') && GetWitcherPlayer().HasTag('root_proj_1st'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_3) );
			proj_3.DestroyAfter(5);	
			
			GetWitcherPlayer().RemoveTag('root_proj_1st');
			GetWitcherPlayer().AddTag('root_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('root_proj_begin') && GetWitcherPlayer().HasTag('root_proj_2nd'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_3) );
			proj_3.DestroyAfter(5);	
			
			proj_4 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_4) );
			proj_4.DestroyAfter(5);	
			
			proj_5 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), TraceFloor(position_5) );
			proj_5.DestroyAfter(5);	
			
			GetWitcherPlayer().RemoveTag('root_proj_begin');
			GetWitcherPlayer().RemoveTag('root_proj_1st');
			GetWitcherPlayer().RemoveTag('root_proj_2nd');
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
	private var proj_1 																																: W3ACSGiantShockwave;
	private var proj_2, proj_3, proj_4, proj_5																										: W3ACSSharleyShockwave;
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
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && !GetWitcherPlayer().HasTag('giant_shockwave_proj_1st') && !GetWitcherPlayer().HasTag('giant_shockwave_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			GetWitcherPlayer().AddTag('giant_shockwave_proj_begin');
			GetWitcherPlayer().AddTag('giant_shockwave_proj_1st');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && GetWitcherPlayer().HasTag('giant_shockwave_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_1st');
			GetWitcherPlayer().AddTag('giant_shockwave_proj_2nd');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && GetWitcherPlayer().HasTag('giant_shockwave_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			proj_4 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(2.5);
			
			proj_5 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(2.5);
			
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_begin');
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_1st');
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_2nd');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
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
	return;
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
	private var proj_1																					: W3ACSSharleyShockwave;
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
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );
			
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
			
			dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
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
			
		proj_1 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent"

			"dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent"
			
			, true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
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
		
		GetWitcherPlayer().StopEffect('summon');
		GetWitcherPlayer().PlayEffectSingle('summon');
	
		Spawn_Shades_Activate();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Shades_Activate()
	{
		shadeTemplate = (CEntityTemplate)LoadResource( "dlc\ep1\data\quests\quest_files\q604_mansion\characters\q604_shade.w2ent", true );
		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		playerVitality = BCS_Vitality;
		curPlayerVitality = GetWitcherPlayer().GetStat( BCS_Vitality );
		maxPlayerVitality = GetWitcherPlayer().GetStatMax( BCS_Vitality );
		
		if ( GetWitcherPlayer().GetLevel() <= 10 )
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
		else if ( GetWitcherPlayer().GetLevel() > 10 && GetWitcherPlayer().GetLevel() <= 15 )
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
		else if ( GetWitcherPlayer().GetLevel() > 15 && GetWitcherPlayer().GetLevel() <= 20 )
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
		else if ( GetWitcherPlayer().GetLevel() > 20 && GetWitcherPlayer().GetLevel() <= 25 )
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
		else if ( GetWitcherPlayer().GetLevel() > 25 )
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
			
			shadeEntity = theGame.CreateEntity( shadeTemplate, spawnPos, GetWitcherPlayer().GetWorldRotation() );
			shadeEntity.AddTag( 'ACS_caretaker_shade' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
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
		if (GetWitcherPlayer().GetStat( BCS_Stamina ) == GetWitcherPlayer().GetStatMax( BCS_Stamina ))
		{
			GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax( BCS_Stamina ), 1 );
			this.PushState('ACS_Beam_Attack_Engage');
		}
	}
}

state ACS_Beam_Attack_Engage in cACS_Beam_Attack
{
	private var beam_anchor1																							: CEntity;
	private var actortarget, actor, pActor																				: CActor;
	private var anchor_temp_1, anchor_temp_2																			: CEntityTemplate;
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
		GetWitcherPlayer().StopEffect('lightning_djinn');
		
		GetWitcherPlayer().PlayEffectSingle('hit_lightning');
		GetWitcherPlayer().StopEffect('hit_lightning');
		
		pActor = GetWitcherPlayer();
		
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		anchor_temp_1 = (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\glyphword\glyphword_6\glyphword_6.w2ent", true);
		
		anchor_temp_2 = (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\runeword\runeword_1\runeword_1_aard.w2ent", true);
		
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
		
		if (GetWitcherPlayer().IsOnGround())
		{
			if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 3.5 ) 
			{
				while (true) 
				{
					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInCone( 3.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.15f, 1.0f));
							
						beam_anchor1 = theGame.CreateEntity(anchor_temp_1, actortarget.GetWorldPosition());
						beam_anchor1.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
						beam_anchor1.AddTag('beam_anchor');
						beam_anchor1.DestroyAfter(1.5);
							
						//GetWitcherPlayer().PlayEffectSingle('shout', beam_anchor1);
						//GetWitcherPlayer().StopEffect('shout');
						
						GetWitcherPlayer().PlayEffectSingle('toad_vomit', beam_anchor1);
						GetWitcherPlayer().StopEffect('toad_vomit');
							
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
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
			else if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) > 3.5 && VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 20)
			{
				while (true)
				{	
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
					
					movementAdjustor1 = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
					movementAdjustor1.CancelByName( 'turn' );
					ticket1 = movementAdjustor1.CreateNewRequest( 'turn' );
					movementAdjustor1.AdjustmentDuration( ticket1, 0.1 );
						
					if (!GetWitcherPlayer().IsUsingHorse() && !GetWitcherPlayer().IsUsingVehicle()) {movementAdjustor1.RotateTowards( ticket1, actor );}  
				
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.15f, 1.0f));

					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInCone( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) , VecHeading(GetWitcherPlayer().GetHeadingVector()), 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
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
				
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().PlayEffectSingle('lightning_djinn', beam_anchor1);
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
								
					dmg = new W3DamageAction in theGame.damageMgr;
					dmg.Initialize(GetWitcherPlayer(), actor, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
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
					
					GetWitcherPlayer().StopEffect('lightning_djinn');
				}
			}
			else
			{
				GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			}
			
			GetWitcherPlayer().StopEffect('lightning_djinn');
		}
		else
		{
			GetWitcherPlayer().StopEffect('lightning_djinn');
			
			GetWitcherPlayer().PlayEffectSingle('djinn_default');
			GetWitcherPlayer().StopEffect('djinn_default');
			
			if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 20 ) 
			{
				while (true)
				{	
					//actors = GetActorsInRange(GetWitcherPlayer(), 20, 5);

					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if 
						( 
						actors[i] == GetWitcherPlayer() 
						|| actors[i].HasTag('smokeman') 
						|| ((CNewNPC)(actors[i])).IsHorse() 
						|| actors[i].HasTag('ACS_Rat_Mage_Rat')
						
						)
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
								
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().PlayEffectSingle('lightning_djinn', beam_anchor1);
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().StopEffect('lightning_djinn');
								
								dmg = new W3DamageAction in theGame.damageMgr;
								dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
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
				GetWitcherPlayer().StopEffect('lightning_djinn');
			}
			else
			{
				GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			}
			
			GetWitcherPlayer().StopEffect('lightning_djinn');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Detonation_Weapon_Effects_Switch
{
    function ACS_Detonation_Weapon_Effects_Switch_Engage()
	{
		GetWitcherPlayer().PlayBattleCry( 'BattleCryAttack', 1, true, false );	
		this.PushState('ACS_Detonation_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Detonation_Weapon_Effects_Switch_Engage in cACS_Detonation_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt_2, vfxEnt3		: CEntity;
	private var weaponSlotMatrix 							: Matrix;
	private var fxPos 										: Vector;
	private var fxRot 										: EulerAngles;
	private var targets 									: array<CGameplayEntity>;
	private var dist, ang									: float;
	private var pos, targetPos								: Vector;
	private var targetRot 									: EulerAngles;
	private var i											: int;
	private var npc 										: CNewNPC;
	
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
		weaponEntity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(GetWitcherPlayer().GetInventory().GetItemFromSlot('r_weapon'));
		weaponEntity.CalcEntitySlotMatrix('blood_fx_point', weaponSlotMatrix);
		
		fxPos = MatrixGetTranslation(weaponSlotMatrix);
		fxRot = weaponEntity.GetWorldRotation();
		
		if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\monsters\arachas\arachas_poison_cloud.w2ent", true ), fxPos, GetWitcherPlayer().GetWorldRotation() );
			vfxEnt.PlayEffectSingle('poison_cloud');
			vfxEnt.DestroyAfter(2.5);
		}
		else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('mutation_2_igni');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('mutation_2_aard_b');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('explode');
			vfxEnt.DestroyAfter(2.5);
		}
	}
	*/

	latent function Detonation_Weapon_Effects_Switch_Activate()
	{
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	45;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	45;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	45;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999 );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_igni');
						vfxEnt.DestroyAfter(1.5);

						vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt_2.PlayEffectSingle('explode');
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

statemachine class cACS_Passive_Weapon_Effects_Switch
{
    function ACS_Passive_Weapon_Effects_Switch_Engage()
	{
		this.PushState('ACS_Passive_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Passive_Weapon_Effects_Switch_Engage in cACS_Passive_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2, vfxEnt3, vfxEnt4			: CEntity;
	private var weaponSlotMatrix 										: Matrix;
	private var fxPos 													: Vector;
	private var fxRot 													: EulerAngles;
	private var targets 												: array<CGameplayEntity>;
	private var dist, ang												: float;
	private var pos, targetPos											: Vector;
	private var targetRot 												: EulerAngles;
	private var i														: int;
	private var npc     												: CNewNPC;
	private var maxAdrenaline											: float;
	private var curAdrenaline											: float;
	
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
		maxAdrenaline = GetWitcherPlayer().GetStatMax(BCS_Focus);
		
		curAdrenaline = GetWitcherPlayer().GetStat(BCS_Focus);

		targets.Clear();

		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	45;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	45;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	45;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999 );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if( ACS_OnHitEffects_Enabled() )
					{
						if ( ACS_GetWeaponMode() == 0 )
						{
							if ( !GetWitcherPlayer().IsWeaponHeld( 'fist' ) )
							{
								if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffect('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffect('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffect('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffect('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffect('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffect('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffect('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffect('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffect('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffect('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffect('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffect('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_2_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffect('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffect('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffect('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
							}
							else if ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('vampire_claws_equipped') )
							{
								if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
								{
									vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
									vfxEnt.PlayEffectSingle('hit_red');
									vfxEnt.PlayEffectSingle('hit_refraction_red');
									vfxEnt.PlayEffectSingle('crawl_blood_red');
									vfxEnt.DestroyAfter(1.5);
								}
								else
								{
									npc.PlayEffect('blood');
									npc.StopEffect('blood');

									npc.PlayEffect('death_blood');
									npc.StopEffect('death_blood');

									npc.PlayEffect('heavy_hit');
									npc.StopEffect('heavy_hit');

									npc.PlayEffect('light_hit');
									npc.StopEffect('light_hit');

									npc.PlayEffect('blood_spill');
									npc.StopEffect('blood_spill');
								}

								/*
								vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
								vfxEnt3.PlayEffect('blood_explode_red');
								vfxEnt3.DestroyAfter(1.5);
								*/

								if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
								{
									targetPos.Z += RandRangeF( 0.5, -0.4 );
								
									targetPos.Y += RandRangeF( 0.4, -0.4 );
									
									targetRot.Roll = RandRange( 360, 0 );

									vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

									vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

									vfxEnt4.DestroyAfter(1);
								}
							}	
						}
						else
						{
							if (GetWitcherPlayer().IsAnyWeaponHeld()
							&& !GetWitcherPlayer().IsWeaponHeld( 'fist' )
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
									if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
									{
										aard_blade_trail();
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
									{
										aard_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
									{
										yrden_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
									{
										yrden_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
									{
										axii_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
									{
										axii_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
									{
										//quen_sword_glow();
										quen_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
									{
										quen_secondary_sword_trail();
									}
								}

								if ( GetWitcherPlayer().GetEquippedSign() == ST_Igni )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
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
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if ( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Axii )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
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
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Aard )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
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
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Quen )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
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
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
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
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
							}
							else
							{
								if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
								{
									if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('hit_red');
										vfxEnt.PlayEffectSingle('hit_refraction_red');
										vfxEnt.PlayEffectSingle('crawl_blood_red');
										vfxEnt.DestroyAfter(1.5);
									}
									else
									{
										npc.PlayEffect('blood');
										npc.StopEffect('blood');

										npc.PlayEffect('death_blood');
										npc.StopEffect('death_blood');

										npc.PlayEffect('heavy_hit');
										npc.StopEffect('heavy_hit');

										npc.PlayEffect('light_hit');
										npc.StopEffect('light_hit');

										npc.PlayEffect('blood_spill');
										npc.StopEffect('blood_spill');
									}

									/*
									vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
									vfxEnt3.PlayEffect('blood_explode_red');
									vfxEnt3.DestroyAfter(1.5);
									*/

									if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
									{
										targetPos.Z += RandRangeF( 0.5, -0.4 );
									
										targetPos.Y += RandRangeF( 0.4, -0.4 );
										
										targetRot.Roll = RandRange( 360, 0 );

										vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

										vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

										vfxEnt4.DestroyAfter(1);
									}
								}
							}
						}
					}
					else
					{
						if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
						{
							if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
							{
								vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
								vfxEnt.PlayEffectSingle('hit_red');
								vfxEnt.PlayEffectSingle('hit_refraction_red');
								vfxEnt.PlayEffectSingle('crawl_blood_red');
								vfxEnt.DestroyAfter(1.5);
							}
							else
							{
								npc.PlayEffect('blood');
								npc.StopEffect('blood');

								npc.PlayEffect('death_blood');
								npc.StopEffect('death_blood');

								npc.PlayEffect('heavy_hit');
								npc.StopEffect('heavy_hit');

								npc.PlayEffect('light_hit');
								npc.StopEffect('light_hit');

								npc.PlayEffect('blood_spill');
								npc.StopEffect('blood_spill');
							}

							/*
							vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
							vfxEnt3.PlayEffect('blood_explode_red');
							vfxEnt3.DestroyAfter(1.5);
							*/

							if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
							{
								targetPos.Z += RandRangeF( 0.5, -0.4 );
							
								targetPos.Y += RandRangeF( 0.4, -0.4 );
								
								targetRot.Roll = RandRange( 360, 0 );

								vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

								vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

								vfxEnt4.DestroyAfter(1);
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

statemachine class cACS_Blood_Spatter_Switch
{
    function ACS_Blood_Spatter_Switch_Engage()
	{
		this.PushState('ACS_Blood_Spatter_Switch_Engage');
	}
}

state ACS_Blood_Spatter_Switch_Engage in cACS_Blood_Spatter_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2, vfxEnt3, vfxEnt4			: CEntity;
	private var temp													: CEntityTemplate;
	private var targets 												: array<CGameplayEntity>;
	private var dist, ang												: float;
	private var pos, targetPos											: Vector;
	private var targetRot 												: EulerAngles;
	private var i														: int;
	private var npc     												: CNewNPC;
	private var tmpBool 												: bool;
	private var mc 														: EMonsterCategory;
	private var tmpName 												: name;
	
	event OnEnterState(prevStateName : name)
	{
		Blood_Spatter_Switch_Entry();
	}
	
	entry function Blood_Spatter_Switch_Entry()
	{
		Blood_Spatter_Switch_Latent();
	}

	latent function Blood_Spatter_Switch_Latent()
	{
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	45;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	45;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	45;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999 );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) 
				&& npc.IsAlive() 
				)
				{
					if ( ACS_Armor_Equipped_Check()
					&& GetWitcherPlayer().IsAnyWeaponHeld()
					&& !GetWitcherPlayer().IsWeaponHeld( 'fist' ))
					{
						targetPos.Z += RandRangeF( 0.5, -0.4 );
						
						targetPos.Y += RandRangeF( 0.4, -0.4 );
						
						targetRot.Roll = RandRange( 360, 0 );

						vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

						vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

						vfxEnt4.DestroyAfter(0.5);

						if ((GetWitcherPlayer().HasTag('igni_sword_equipped')
						|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
						&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
						&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina)
						)
						{
							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
							vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
							vfxEnt.DestroyAfter(1.5);
						}	
					}

					if( RandF() < 0.5)
					{
						temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true );

						vfxEnt = theGame.CreateEntity( temp, targetPos, targetRot );
						vfxEnt.DestroyAfter(1.5);

						theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

						if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
						{
							if (npc.HasAbility('mon_lessog_base')
							|| npc.HasAbility('mon_sprigan_base')
							)
							{						
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							} 
							else
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
						{
							if (npc.HasAbility('mon_kikimore_base')
							|| npc.HasAbility('mon_black_spider_base')
							|| npc.HasAbility('mon_black_spider_ep2_base')
							)
							{						
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							} 
							else 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_green');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
						{
							if (npc.HasAbility('mon_archespor_base'))
							{
								vfxEnt.PlayEffectSingle('blood_spatter_yellow');
							} 
							else 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Black) 
						{
							if ( mc == MC_Vampire ) 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
							else if ( mc == MC_Magicals ) 
							{
								if (npc.HasAbility('mon_golem_base')
								|| npc.HasAbility('mon_djinn')
								|| npc.HasAbility('mon_gargoyle')
								)
								{
									vfxEnt.PlayEffectSingle('blood_spatter_black');
								}
								else
								{
									vfxEnt.PlayEffectSingle('blood_spatter_red');
								}
							}
							else
							{
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							}
						}
						else
						{
							vfxEnt.PlayEffectSingle('blood_spatter_red');
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
		if ( !GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') )
		{
			if ( ACS_GetWeaponMode() == 0 )
			{
				if (ACS_GetArmigerModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 1 )
			{
				if (ACS_GetFocusModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 2 )
			{
				if (ACS_GetHybridModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{
				dist = 2.5;
				ang = 60;
			}	
		}

		if (ACS_Player_Scale() > 1)
		{
			dist += ACS_Player_Scale() * 0.5;
		}
		else if (ACS_Player_Scale() < 1)
		{
			dist -= ACS_Player_Scale() * 0.5;
		}

		if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
		&& !thePlayer.HasTag('igni_sword_equipped') 
		&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
		&& !ACS_Armor_Equipped_Check())
		{
			dist += 1;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999 );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();

			targetRot = npc.GetWorldRotation();

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if (ACS_GetItem_Caretaker_Shovel())
					{
						anchorTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );		
						anchor = (CEntity)theGame.CreateEntity( anchorTemplate, targetPos, targetRot );

						anchor.CreateAttachment( npc, 'head', Vector( 0, 0, -0.5 ) );

						GetWitcherPlayer().PlayEffectSingle('drain_energy', anchor);
						GetWitcherPlayer().StopEffect('drain_energy');

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Drain_Energy
{
    function ACS_Drain_Energy_Engage()
	{
		this.PushState('ACS_Drain_Energy_Engage');
	}
}

state ACS_Drain_Energy_Engage in cACS_Drain_Energy
{
	private var actors 							: array<CActor>;
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
		ACS_Drain_Energy_Entry();
	}
	
	entry function ACS_Drain_Energy_Entry()
	{
		ACS_Drain_Energy_Latent();
	}

	latent function ACS_Drain_Energy_Latent()
	{
		if( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus)/3
			&& GetWitcherPlayer().GetStat(BCS_Focus) < GetWitcherPlayer().GetStatMax(BCS_Focus) * 2/3)
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}	
		else if( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus) * 2/3
		&& GetWitcherPlayer().GetStat(BCS_Focus) < GetWitcherPlayer().GetStatMax(BCS_Focus))
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}
		else if( GetWitcherPlayer().GetStat(BCS_Focus) == GetWitcherPlayer().GetStatMax(BCS_Focus))
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z += 0.8;

		actors.Clear();

		for( i = actors.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)actors[i];

			targetPos = npc.GetWorldPosition();

			targetRot = npc.GetWorldRotation();

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			
			)
				continue;

			if( actors.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					anchorTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );		
					anchor = (CEntity)theGame.CreateEntity( anchorTemplate, targetPos, targetRot );

					anchor.CreateAttachment( npc, , Vector( 0, 0, 0.5 ) );

					GetWitcherPlayer().PlayEffectSingle('drain_energy', anchor);
					GetWitcherPlayer().StopEffect('drain_energy');

					anchor.DestroyAfter(3);
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
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	45;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	45;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	45;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	45;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	45;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999 );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot_1 = npc.GetWorldRotation();
				
			if( targets.Size() > 0 )
			{				
				if( 
				ACS_AttitudeCheck ( (CActor)targets[i] ) 
				&& npc != GetWitcherPlayer() 
				&& GetACSWatcher().ACS_Rage_Process == false
				&& !npc.HasTag('smokeman') 
				&& !npc.HasTag('ACS_Tentacle_1') 
				&& !npc.HasTag('ACS_Tentacle_2') 
				&& !npc.HasTag('ACS_Tentacle_3') 
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Rat_Mage_Rat') 
				&& npc.IsAlive()
				)
				{
					ACS_ElementalComboSystem_Tutorial();
					
					if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_blood');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_figure');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_gate');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_goat_ring');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_snake');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_winged');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_knife');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_goat');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('igni_sword_equipped_TAG') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_black_circle');

						markerNPC_1.AddTag('PrimerMark');
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

function ACS_Sword_Array_Fire_Override()
{
	var vACS_Sword_Array : cACS_Sword_Array;
	vACS_Sword_Array = new cACS_Sword_Array in theGame;
			
	vACS_Sword_Array.Swords_Fire_Override();
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
	static_torso_sword_1.PlayEffectSingle('disappear');
	static_torso_sword_1.DestroyAfter(0.4);

	static_torso_sword_2 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_2' );
	//static_torso_sword_2.BreakAttachment();
	static_torso_sword_2.StopEffect('glow');
	static_torso_sword_2.PlayEffectSingle('disappear');
	static_torso_sword_2.DestroyAfter(0.4);

	static_torso_sword_3 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_3' );
	//static_torso_sword_3.BreakAttachment();
	static_torso_sword_3.StopEffect('glow');
	static_torso_sword_3.PlayEffectSingle('disappear');
	static_torso_sword_3.DestroyAfter(0.4);

	static_torso_sword_4 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_4' );
	//static_torso_sword_4.BreakAttachment();
	static_torso_sword_4.StopEffect('glow');
	static_torso_sword_4.PlayEffectSingle('disappear');
	static_torso_sword_4.DestroyAfter(0.4);

	static_torso_sword_5 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_5' );
	//static_torso_sword_5.BreakAttachment();
	static_torso_sword_5.StopEffect('glow');
	static_torso_sword_5.PlayEffectSingle('disappear');
	static_torso_sword_5.DestroyAfter(0.4);
}

statemachine class cACS_Sword_Array
{
    function Switch()
	{
		if ( !GetWitcherPlayer().HasTag('Swords_Ready') 
		&& (GetWitcherPlayer().GetStat(BCS_Focus) == GetWitcherPlayer().GetStatMax(BCS_Focus) ) )
		{
			this.PushState('Ready');

			GetWitcherPlayer().AddTag('Swords_Ready');
		}
		else if ( GetWitcherPlayer().HasTag('Swords_Ready') )
		{
			this.PushState('Fire');

			GetWitcherPlayer().RemoveTag('Swords_Ready');
		}
	}

	function Swords_Fire_Override()
	{
		if ( GetWitcherPlayer().HasTag('Swords_Ready') )
		{
			this.PushState('Fire');

			GetWitcherPlayer().RemoveTag('Swords_Ready');
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
	private var action 																																	: W3DamageAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ready_Swords();
	}
	
	entry function Ready_Swords()
	{
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().RemoveTimer('ACS_Shout');

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
			{	
				movementAdjustor.RotateTowards( ticket, actor );
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}

			GetACSWatcher().PlayerPlayAnimationInterrupt( '' );
		}

		ACS_Sword_Array_Destroy();
		Swords();
	}
	
	latent function Swords()
	{	
		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		sword_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\aerondight_proj_static.w2ent", true );

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'Trajectory' ), bonePosition, boneRotation );
		sword_torso_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		sword_torso_anchor_1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'Trajectory', bonePosition, boneRotation );
		sword_torso_anchor_1.AddTag('sword_torso_anchor_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		static_torso_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_3 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_4 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_5 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

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

		GetWitcherPlayer().PlayEffectSingle('hit_lightning');
		GetWitcherPlayer().StopEffect('hit_lightning');

		static_torso_sword_1.PlayEffectSingle('glow');
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
		static_torso_sword_2.PlayEffectSingle('glow');
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
		static_torso_sword_3.PlayEffectSingle('glow');
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
		static_torso_sword_4.PlayEffectSingle('glow');
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
		static_torso_sword_5.PlayEffectSingle('glow');
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
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Swords_Fire();
	}
	
	entry function Swords_Fire()
	{
		GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStat( BCS_Focus ) * 2/3 );

		GetACSWatcher().RemoveTimer('ACS_Shout');

		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
			{	
				movementAdjustor.RotateTowards( ticket, actor );
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}

			GetACSWatcher().PlayerPlayAnimationInterrupt( '' );
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
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition();				
			initpos.Z += 3;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition();				
			initpos.Z += 3;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_2()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 2;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_3()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 2;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_4()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 1;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_5()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 1;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
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
		
	actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
	if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
	{	
		initpos = GetWitcherPlayer().GetWorldPosition();				
		initpos.Z += 5;
					
		targetPosition = actor.PredictWorldPosition( 0.1 );
		targetPosition.Z += 1.1;
			
		sword = (SwordProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
			
		meshcomp = sword.GetComponentByClassName('CMeshComponent');
		h = 3;
		meshcomp.SetScale(Vector(h,h,h,1));	
			
		sword.Init(GetWitcherPlayer());
		sword.PlayEffectSingle('appear');
		sword.PlayEffectSingle('glow');
		sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
		sword.DestroyAfter(31);
	}		
	else
	{
		initpos = GetWitcherPlayer().GetWorldPosition();				
		initpos.Z += 5;
							
		//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
		targetPosition = GetWitcherPlayer().GetLookAtPosition();
		//targetPosition.Z += 1.1;
			
		sword = (SwordProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
			
		meshcomp = sword.GetComponentByClassName('CMeshComponent');
		h = 3;
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		sword.Init(GetWitcherPlayer());
		sword.PlayEffectSingle('appear');
		sword.PlayEffectSingle('glow');
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

	//actors = GetActorsInRange(GetWitcherPlayer(), 7, 100, ,true);

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 7, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

	//GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.046875 );

	//GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.0625 );

	GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.5 );

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

		if 
		( 
		actortarget == GetWitcherPlayer() 
		|| actortarget.HasTag('smokeman') 
		|| ((CNewNPC)(actortarget)).IsHorse() 
		|| actortarget.HasTag('ACS_Rat_Mage_Rat')
		
		)
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
		//actors = GetActorsInRange(GetWitcherPlayer(), 10, 100, ,true);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			if 
			( 
			actortarget == GetWitcherPlayer() 
			|| actortarget.HasTag('smokeman') 
			|| ((CNewNPC)(actortarget)).IsHorse() 
			|| actortarget.HasTag('ACS_Rat_Mage_Rat')
			
			)
			continue;

			dist = (((CMovingPhysicalAgentComponent)actortarget.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 1.75;

			movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor.CancelByName( 'ACS_AardPull' );
			ticket = movementAdjustor.CreateNewRequest( 'ACS_AardPull' );
			movementAdjustor.AdjustmentDuration( ticket, 1 );
			movementAdjustor.ShouldStartAt(ticket, actortarget.GetWorldPosition());
			movementAdjustor.AdjustLocationVertically( ticket, true );
			movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5 );

			movementAdjustor.SlideTowards( ticket, GetWitcherPlayer(), dist, dist );	

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
						actortarget.AddEffectDefault( EET_Blindness, GetWitcherPlayer(), 'acs_bat_effect' ); 						
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
						actortarget.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_bat_effect' ); 						
					}
				}
			}
		}
	}
		
	latent function ACS_Bats_Summon_Latent()
	{
		playerPos = GetWitcherPlayer().GetWorldPosition();

		playerRot = GetWitcherPlayer().GetWorldRotation();
	
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
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_01.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_02.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_03.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_04.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_05.w2ent"
						
						, true ), spawnPos, playerRot );
				}
				else 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_06.w2ent"
						
						, true ), spawnPos, playerRot );
				}
			}
			markerNPC.PlayEffectSingle('bat_swarm');
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
	private var vfxEnt, vfxEnt2, vfxEnt3																																	: CEntity;
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
		actors.Clear();

		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

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
					if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
						vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ), EulerAngles(0, RandRangeF(45,-45), RandRangeF(360,1)) );	
						vfxEnt.PlayEffect('blood_explode_red');
						vfxEnt.DestroyAfter(1.5);

						vfxEnt2 = theGame.CreateEntity( (CEntityTemplate)LoadResource('finisher_blood', true), npc.GetWorldPosition(), targetRotationNPC);
						vfxEnt2.CreateAttachment( npc, , Vector( 0, 0, 1.5 ), EulerAngles(0, RandRangeF(45,-45), RandRangeF(360,1)) );	
						vfxEnt2.PlayEffect('crawl_blood');
						vfxEnt2.DestroyAfter(1.5);

						vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
						vfxEnt3.CreateAttachment( npc, , Vector( 0, 0, 1.5 ), EulerAngles(0, RandRangeF(45,-45), RandRangeF(360,1)) );	
						vfxEnt3.PlayEffectSingle('hit');
						vfxEnt3.PlayEffectSingle('hit_refraction');
						vfxEnt3.DestroyAfter(1.5);
					}
					else
					{
						npc.PlayEffect('blood');
						npc.StopEffect('blood');

						npc.PlayEffect('death_blood');
						npc.StopEffect('death_blood');

						npc.PlayEffect('heavy_hit');
						npc.StopEffect('heavy_hit');

						npc.PlayEffect('light_hit');
						npc.StopEffect('light_hit');

						npc.PlayEffect('blood_spill');
						npc.StopEffect('blood_spill');
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
		actors.Clear();

		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

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

				vfxEnt.PlayEffectSingle('ground_smoke');

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
		if (GetWitcherPlayer().HasTag('acs_bow_active'))
		{
			//ACS_Bow_Arrow().Destroy();
			ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffectSingle('glow');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffectSingle( 'fire' );
			}

			arrow1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
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
		if (GetWitcherPlayer().HasTag('acs_bow_active'))
		{
			ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffectSingle('glow');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffectSingle( 'fire' );
			}

			arrow1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');

			if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

				vfxEnt.CreateAttachment( GetWitcherPlayer(), 'r_weapon' );
				
				vfxEnt.PlayEffectSingle('diagonal_up_left');
				vfxEnt.PlayEffectSingle('diagonal_down_left');
				vfxEnt.PlayEffectSingle('down');
				vfxEnt.PlayEffectSingle('up');
				vfxEnt.PlayEffectSingle('diagonal_up_right');
				vfxEnt.PlayEffectSingle('diagonal_down_right');
				vfxEnt.PlayEffectSingle('right');
				vfxEnt.PlayEffectSingle('left');
				vfxEnt.PlayEffectSingle('lightning_fx');
				vfxEnt.PlayEffectSingle('shock');

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
	private var movementAdjustor																																			: CMovementAdjustor;
	private var ticket 																																						: SMovementAdjustmentRequestTicket;
	
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
		ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACS_Bow_Arrow().DestroyAfter(0.0125);

		actortarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Shoot_Arrow_Rotate' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.01 );

		movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 5000000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5000000 );

		movementAdjustor.RotateTowards( ticket, actortarget );

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actortarget.GetWorldPosition() ) ;

		initpos = GetWitcherPlayer().GetBoneWorldPosition('r_hand');		
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

		//targetPosition =  GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 20;
		//targetPosition.Z += 1.5;

		//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
		targetPosition = GetWitcherPlayer().GetLookAtPosition();
		//targetPosition.Z += 1.1;

		if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{		
			proj_2 = (ACSBowProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\bow_projectile.w2ent"
				, true ), initpos );
			
			meshcomp = proj_2.GetComponentByClassName('CMeshComponent');
			h = 2;
			meshcomp.SetScale(Vector(h,h,h,1));	

			proj_2.Init(GetWitcherPlayer());

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				proj_2.PlayEffectSingle( 'fire' );
			}

			proj_2.PlayEffectSingle('glow');

			if( ACS_AttitudeCheck ( actortarget ) && GetWitcherPlayer().IsInCombat() && actortarget.IsAlive() )
			{
				proj_2.PlayEffectSingle('arrow_trail_fire');
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

			proj_1.Init(GetWitcherPlayer());

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				proj_1.PlayEffectSingle( 'fire' );
			}

			proj_1.PlayEffectSingle('glow');

			if( ACS_AttitudeCheck ( actortarget ) && GetWitcherPlayer().IsInCombat() && actortarget.IsAlive() )
			{
				if ( actortarget.HasTag('ACS_second_bow_moving_projectile'))
				{
					proj_1.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPositionNPC, 500  );
					proj_1.PlayEffectSingle('arrow_trail_fire');
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
		Shoot_Bow_Stationary_Entry();
	}
	
	entry function Shoot_Bow_Stationary_Entry()
	{
		LockEntryFunction(true);
		Shoot_Bow_Stationary_Latent();
		LockEntryFunction(false);
	}
	
	latent function Shoot_Bow_Stationary_Latent()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.7);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3IceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "gameplay\abilities\wh_mage\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
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

function ACS_Umbral_Slash_Single()
{
	var vACS_Umbral_Slash_Single : cACS_Umbral_Slash_Single;
	vACS_Umbral_Slash_Single = new cACS_Umbral_Slash_Single in theGame;
			
	vACS_Umbral_Slash_Single.ACS_Umbral_Slash_Single_Engage();
}

statemachine class cACS_Umbral_Slash_Single
{
    function ACS_Umbral_Slash_Single_Engage()
	{
		this.PushState('ACS_Umbral_Slash_Single_Engage');
	}
}

state ACS_Umbral_Slash_Single_Engage in cACS_Umbral_Slash_Single
{
	private var ent, ent__2, ent__3, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6                         									: CEntity;
	private var playerRot, playerRot_1, playerRot_2, playerRot_3, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6                         : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6							: Vector;
	private var dmg 																													: W3DamageAction;
	private var damageMax																												: float;
	private var attAction																												: W3Action_Attack;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Umbral_Slash_Single();
	}
	
	entry function Umbral_Slash_Single()
	{
		LockEntryFunction(true);
		Umbral_Slash_Single_Activate();
		LockEntryFunction(false);
	}
	
	latent function Umbral_Slash_Single_Activate()
	{
		rot = GetWitcherPlayer().GetDisplayTarget().GetWorldRotation();

		pos = GetWitcherPlayer().GetDisplayTarget().GetWorldPosition();

		pos.Z += 1.5;

		playerPos = GetWitcherPlayer().GetWorldPosition();

		playerRot = GetWitcherPlayer().GetWorldRotation();


		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), pos, rot );

		ent.CreateAttachment( GetWitcherPlayer().GetDisplayTarget(), , Vector( 0, -0.5, 1.5 ) );

		ent.PlayEffectSingle('sword_slash_orb');

		ent.DestroyAfter(1);

		/*
		playerRot_1 = playerRot;

		playerRot_1.Yaw = RandRangeF(360,1);

		playerRot_1.Pitch = RandRangeF(45,-45);

		playerRot_1.Roll = RandRange( 360, 0 );

		playerPos_1 = playerPos;

		playerPos_1.Z += RandRangeF( 0.5, -0.4 );

		playerPos_1.Y += RandRangeF( 0.4, -0.4 );

		playerPos_1.X += RandRangeF( 0.4, -0.4 );

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_1, playerRot_1 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent.PlayEffectSingle('sword_slash_orb_big');

		ent.DestroyAfter(5);

		

		playerRot_2 = playerRot;

		playerRot_2.Yaw = RandRangeF(360,1);

		playerRot_2.Pitch = RandRangeF(45,-45);

		playerRot_2.Roll = RandRange( 360, 0 );

		playerPos_2 = playerPos;

		playerPos_2.Z += RandRangeF( 0.5, -0.4 );

		playerPos_2.Y += RandRangeF( 0.4, -0.4 );

		playerPos_2.X += RandRangeF( 0.4, -0.4 );


		ent__2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_2, playerRot_2 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent__2.PlayEffectSingle('sword_slash_orb_big');

		ent__2.DestroyAfter(5);

		playerRot_3 = playerRot;

		playerRot_3.Yaw = RandRangeF(360,1);

		playerRot_3.Pitch = RandRangeF(45,-45);

		playerRot_3.Roll = RandRange( 360, 0 );

		playerPos_3 = playerPos;

		playerPos_3.Z += RandRangeF( 0.5, -0.4 );

		playerPos_3.Y += RandRangeF( 0.4, -0.4 );

		playerPos_3.X += RandRangeF( 0.4, -0.4 );


		ent__3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_3, playerRot_3 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent__3.PlayEffectSingle('sword_slash_orb_big');

		ent__3.DestroyAfter(5);
		*/

		rot_1 = rot;

		rot_1.Yaw = RandRangeF(360,1);

		rot_1.Pitch = RandRangeF(45,-45);

		rot_1.Roll = RandRange( 360, 0 );

		pos_1 = pos;

		pos_1.Z += RandRangeF( 0.5, -0.4 );

		pos_1.Y += RandRangeF( 0.4, -0.4 );

		pos_1.X += RandRangeF( 0.4, -0.4 );



		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_1, rot_1 );

		ent_1.PlayEffectSingle('sword_slash_medium');

		ent_1.DestroyAfter(0.5);



		rot_2 = rot;

		rot_2.Yaw = RandRangeF(360,1);

		rot_2.Pitch = RandRangeF(45,-45);

		rot_2.Roll = RandRange( 360, 0 );

		pos_2 = pos;

		pos_2.Z += RandRangeF( 0.5, -0.4 );

		pos_2.Y += RandRangeF( 0.4, -0.4 );

		pos_2.X += RandRangeF( 0.4, -0.4 );


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_2, rot_2 );

		ent_2.PlayEffectSingle('sword_slash_medium');

		ent_2.DestroyAfter(0.5);





		rot_3 = rot;

		rot_3.Yaw = RandRangeF(360,1);

		rot_3.Pitch = RandRangeF(45,-45);

		rot_3.Roll = RandRange( 360, 0 );

		pos_3 = pos;

		pos_3.Z += RandRangeF( 0.5, -0.4 );

		pos_3.Y += RandRangeF( 0.4, -0.4 );

		pos_3.X += RandRangeF( 0.4, -0.4 );




		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_3, rot_3 );

		ent_3.PlayEffectSingle('sword_slash_medium');

		ent_3.DestroyAfter(0.5);




		rot_4 = rot;

		rot_4.Yaw = RandRangeF(360,1);

		rot_4.Pitch = RandRangeF(45,-45);

		rot_4.Roll = RandRange( 360, 0 );

		pos_4 = pos;

		pos_4.Z += RandRangeF( 0.5, -0.4 );

		pos_4.Y += RandRangeF( 0.4, -0.4 );

		pos_4.X += RandRangeF( 0.4, -0.4 );




		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_4, rot_4 );

		ent_4.PlayEffectSingle('sword_slash_medium');

		ent_4.DestroyAfter(0.5);





		rot_5 = rot;

		rot_5.Yaw = RandRangeF(360,1);

		rot_5.Pitch = RandRangeF(45,-45);

		rot_5.Roll = RandRange( 360, 0 );

		pos_5 = pos;

		pos_5.Z += RandRangeF( 0.5, -0.4 );

		pos_5.Y += RandRangeF( 0.4, -0.4 );

		pos_5.X += RandRangeF( 0.4, -0.4 );



		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_5, rot_5 );

		ent_5.PlayEffectSingle('sword_slash');

		ent_5.DestroyAfter(0.5);




		rot_6 = rot;

		rot_6.Yaw = RandRangeF(360,1);

		rot_6.Pitch = RandRangeF(45,-45);

		rot_6.Roll = RandRange( 360, 0 );

		pos_6 = pos;

		pos_6.Z += RandRangeF( 0.5, -0.4 );

		pos_6.Y += RandRangeF( 0.4, -0.4 );

		pos_6.X += RandRangeF( 0.4, -0.4 );



		ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_6, rot_6 );

		ent_6.PlayEffectSingle('sword_slash');

		ent_6.DestroyAfter(0.5);

		/*
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(NULL, GetWitcherPlayer().GetDisplayTarget(), theGame, 'ACS_Umbral_Slash_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(true);

		if (GetWitcherPlayer().GetDisplayTarget().UsesVitality()) 
		{ 
			damageMax = GetWitcherPlayer().GetDisplayTarget().GetStat( BCS_Vitality ) * 0.25; 
		} 
		else if (GetWitcherPlayer().GetDisplayTarget().UsesEssence()) 
		{ 
			damageMax = GetWitcherPlayer().GetDisplayTarget().GetStat( BCS_Essence ) * 0.25; 
		} 

		dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageMax );

		dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, damageMax );
					
		//dmg.AddEffectInfo( EET_Stagger, 0.5 );

		dmg.SetForceExplosionDismemberment();
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;
		*/
		if( (CActor)GetWitcherPlayer().GetDisplayTarget() && ACS_AttitudeCheck ( (CActor)GetWitcherPlayer().GetDisplayTarget() ) )
		{
			((CActor)GetWitcherPlayer().GetDisplayTarget()).AddAbility( 'DisableFinishers', true );

			attAction = new W3Action_Attack in theGame.damageMgr;

			attAction.Init( GetWitcherPlayer(), GetWitcherPlayer().GetDisplayTarget(), GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_HEAVY, GetWitcherPlayer().GetName(), EHRT_None, true, true, theGame.params.ATTACK_NAME_HEAVY, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Heavy);
			attAction.SetHitAnimationPlayType(EAHA_Default);

			if (((CActor)GetWitcherPlayer().GetDisplayTarget()).UsesVitality()) 
			{ 
				damageMax = ((CActor)GetWitcherPlayer().GetDisplayTarget()).GetStat( BCS_Vitality ) * 0.1; 
			} 
			else if (((CActor)GetWitcherPlayer().GetDisplayTarget()).UsesEssence()) 
			{ 
				damageMax = ((CActor)GetWitcherPlayer().GetDisplayTarget()).GetStat( BCS_Essence ) * 0.1; 
			}

			attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( EET_Stagger, 1 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)GetWitcherPlayer().GetDisplayTarget()).IsShielded( NULL ) )
			{
				( (CNewNPC)GetWitcherPlayer().GetDisplayTarget()).ProcessShieldDestruction();
			}

			delete attAction;

			((CActor)GetWitcherPlayer().GetDisplayTarget()).RemoveAbility( 'DisableFinishers' );

			if( GetWitcherPlayer().GetStat( BCS_Focus ) >= GetWitcherPlayer().GetStatMax( BCS_Focus )/3
			&& GetWitcherPlayer().GetStat( BCS_Focus ) < GetWitcherPlayer().GetStatMax( BCS_Focus ) * 2/3) 
			{	
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
			}
			else if( GetWitcherPlayer().GetStat( BCS_Focus ) >= GetWitcherPlayer().GetStatMax( BCS_Focus ) * 2/3
			&& GetWitcherPlayer().GetStat( BCS_Focus ) < GetWitcherPlayer().GetStatMax( BCS_Focus )) 
			{	
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 1/3);
			}
			else if( GetWitcherPlayer().GetStat( BCS_Focus ) == GetWitcherPlayer().GetStatMax(BCS_Focus) ) 
			{
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 1/3);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Umbral_Slash_End_Damage_Actual()
{
	var dmg 																																							: W3DamageAction;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var marks																																							: array< CEntity >;
	var mark       																																						: CEntity;
	var attAction																																						: W3Action_Attack;

	marks.Clear();
			
	theGame.GetEntitiesByTag( 'Umbral_Slash_End_Mark', marks );

	for( i=0; i<marks.Size(); i+=1 )
	{	
		mark = (CEntity)marks[i];	
		mark.Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -100) );
		mark.Destroy();
	}

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actortarget = (CActor)actors[i];
		/*
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Umbral_Slash_End_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(true);

		if (actortarget.UsesVitality()) 
		{ 
			damageMax = actortarget.GetStatMax( BCS_Vitality ) * 0.75; 
		} 
		else if (GetWitcherPlayer().GetDisplayTarget().UsesEssence()) 
		{ 
			damageMax = actortarget.GetStatMax( BCS_Essence ) * 0.75; 
		} 

		dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					
		dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

		//dmg.SetForceExplosionDismemberment();
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;
		*/

		((CActor)actortarget).AddAbility( 'DisableFinishers', true );

		attAction = new W3Action_Attack in theGame.damageMgr;

		attAction.Init( GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
		theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, true, true, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
		attAction.SetHitReactionType(EHRT_Light);
		attAction.SetHitAnimationPlayType(EAHA_Default);

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.45; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.45; 
		} 

		attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );
		
		attAction.SetSoundAttackType( 'wpn_slice' );
		
		attAction.AddEffectInfo( EET_Stagger, 1 );
		
		theGame.damageMgr.ProcessAction( attAction );	
		
		if ( ( (CNewNPC)actortarget).IsShielded( NULL ) )
		{
			( (CNewNPC)actortarget).ProcessShieldDestruction();
		}

		delete attAction;

		((CActor)actortarget).RemoveAbility( 'DisableFinishers' );
	}

	GetWitcherPlayer().StopEffect('olgierd_energy_blast');
	
	GetWitcherPlayer().PlayEffect('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffect('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffect('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffect('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffect('olgierd_energy_blast');
	GetWitcherPlayer().StopEffect('olgierd_energy_blast');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Umbral_Slash_End_Effect()
{
	var vACS_Umbral_Slash_End : cACS_Umbral_Slash_End;
	vACS_Umbral_Slash_End = new cACS_Umbral_Slash_End in theGame;
			
	vACS_Umbral_Slash_End.ACS_Umbral_Slash_End_Engage();
}

statemachine class cACS_Umbral_Slash_End
{
    function ACS_Umbral_Slash_End_Engage()
	{
		this.PushState('ACS_Umbral_Slash_End_Engage');
	}
}

state ACS_Umbral_Slash_End_Engage in cACS_Umbral_Slash_End
{
	private var ent, ent__1, ent__2, ent__3, ent__4, ent__5, ent__6, ent__7, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6                         									: CEntity;
	private var playerRot, playerRot_1, playerRot_2, playerRot_3, playerRot_4, playerRot_5, playerRot_6, playerRot_7, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6             : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, playerPos_4, playerPos_5, playerPos_6, playerPos_7, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6				: Vector;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Umbral_Slash_End();
	}
	
	entry function Umbral_Slash_End()
	{
		LockEntryFunction(true);
		Umbral_Slash_End_Activate();
		LockEntryFunction(false);
	}
	
	latent function Umbral_Slash_End_Activate()
	{
		playerRot = GetWitcherPlayer().GetWorldRotation();

		playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5;

		playerPos.Z += 1.5;

		playerRot_1 = playerRot;

		playerRot_1.Yaw = RandRangeF(360,1);

		playerRot_1.Pitch = RandRangeF(45,-45);

		playerRot_1.Roll = RandRange( 360, 0 );

		playerPos_1 = playerPos;

		playerPos_1.Z += RandRangeF( 0.5, -0.4 );

		playerPos_1.Y += RandRangeF( 0.4, -0.4 );

		playerPos_1.X += RandRangeF( 0.4, -0.4 );

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_1, playerRot_1 );

		ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0.5 ) );

		ent.PlayEffectSingle('sword_slash_orb_big');

		ent.DestroyAfter(5);


		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			actortarget.AddEffectDefault( EET_Immobilized, GetWitcherPlayer(), 'ACS_Umbral_Slash_End' );

			actortarget.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'ACS_Umbral_Slash_End' );

				
			rot = actortarget.GetWorldRotation();

			pos = actortarget.GetWorldPosition();

			pos.Z += 1.5;

			rot_1 = rot;

			rot_1.Yaw = RandRangeF(360,1);

			rot_1.Pitch = RandRangeF(45,-45);

			rot_1.Roll = RandRange( 360, 0 );

			pos_1 = pos;

			pos_1.Z += RandRangeF( 0.5, 0 );

			pos_1.Y += RandRangeF( 1.4, -1.4 );

			pos_1.X += RandRangeF( 2.4, -2.4 );



			ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_1, rot_1 );

			ent_1.AddTag('Umbral_Slash_End_Mark');


			ent_1.PlayEffectSingle('sword_slash_red_large');

			ent_1.DestroyAfter(2.5);



			rot_2 = rot;

			rot_2.Yaw = RandRangeF(360,1);

			rot_2.Pitch = RandRangeF(45,-45);

			rot_2.Roll = RandRange( 360, 0 );

			pos_2 = pos;

			pos_2.Z += RandRangeF( 0.5, 0 );

			pos_2.Y += RandRangeF( 1.4, -1.4 );

			pos_2.X += RandRangeF( 2.4, -2.4 );


			ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_2, rot_2 );

			ent_2.AddTag('Umbral_Slash_End_Mark');


			ent_2.PlayEffectSingle('sword_slash_red_large');

			ent_2.DestroyAfter(5);





			rot_3 = rot;

			rot_3.Yaw = RandRangeF(360,1);

			rot_3.Pitch = RandRangeF(45,-45);

			rot_3.Roll = RandRange( 360, 0 );

			pos_3 = pos;

			pos_3.Z += RandRangeF( 0.5, 0 );

			pos_3.Y += RandRangeF( 1.4, -1.4 );

			pos_3.X += RandRangeF( 2.4, -2.4 );




			ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_3, rot_3 );
			
			ent_3.AddTag('Umbral_Slash_End_Mark');


			ent_3.PlayEffectSingle('sword_slash_red_large');

			ent_3.DestroyAfter(5);


			rot_4 = rot;

			rot_4.Yaw = RandRangeF(360,1);

			rot_4.Pitch = RandRangeF(45,-45);

			rot_4.Roll = RandRange( 360, 0 );

			pos_4 = pos;

			pos_4.Z += RandRangeF( 0.5, 0 );

			pos_4.Y += RandRangeF( 1.4, -1.4 );

			pos_4.X += RandRangeF( 1.4, -1.4 );




			ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_4, rot_4 );

			ent_4.AddTag('Umbral_Slash_End_Mark');


			ent_4.PlayEffectSingle('sword_slash_red_large');

			ent_4.DestroyAfter(5);





			rot_5 = rot;

			rot_5.Yaw = RandRangeF(360,1);

			rot_5.Pitch = RandRangeF(45,-45);

			rot_5.Roll = RandRange( 360, 0 );

			pos_5 = pos;

			pos_5.Z += RandRangeF( 0.5, 0 );

			pos_5.Y += RandRangeF( 1.4, -1.4 );

			pos_5.X += RandRangeF( 2.4, -2.4 );



			ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_5, rot_5 );

			ent_5.AddTag('Umbral_Slash_End_Mark');


			ent_5.PlayEffectSingle('sword_slash_red_large');

			ent_5.DestroyAfter(5);


			rot_6 = rot;

			rot_6.Yaw = RandRangeF(360,1);

			rot_6.Pitch = RandRangeF(45,-45);

			rot_6.Roll = RandRange( 360, 0 );

			pos_6 = pos;

			pos_6.Z += RandRangeF( 0.5, 0 );

			pos_6.Y += RandRangeF( 1.4, -1.4 );

			pos_6.X += RandRangeF( 2.4, -2.4 );

			ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_6, rot_6 );

			ent_6.AddTag('Umbral_Slash_End_Mark');

			ent_6.PlayEffectSingle('sword_slash_red_large');

			ent_6.DestroyAfter(5);

		}

		playerRot_2 = playerRot;

		playerRot_2.Yaw = RandRangeF(360,1);

		playerRot_2.Pitch = RandRangeF(45,-45);

		playerRot_2.Roll = RandRange( 360, 0 );

		playerPos_2 = playerPos;

		playerPos_2.Z += RandRangeF( 0.5, 0 );

		playerPos_2.Y += RandRangeF( 1.4, -0.4 );

		playerPos_2.X += RandRangeF( 2.4, -2.4 );



		ent__1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_2, playerRot_2 );

		ent__1.AddTag('Umbral_Slash_End_Mark');


		ent__1.PlayEffectSingle('sword_slash_red_large');

		ent__1.DestroyAfter(5);



		playerRot_3 = playerRot;

		playerRot_3.Yaw = RandRangeF(360,1);

		playerRot_3.Pitch = RandRangeF(45,-45);

		playerRot_3.Roll = RandRange( 360, 0 );

		playerPos_3 = playerPos;

		playerPos_3.Z += RandRangeF( 0.5, 0 );

		playerPos_3.Y += RandRangeF( 1.4, -1.4 );

		playerPos_3.X += RandRangeF( 2.4, -2.4 );


		ent__2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_3, playerRot_3 );

		ent__2.AddTag('Umbral_Slash_End_Mark');

		ent__2.PlayEffectSingle('sword_slash_red_large');

		ent__2.DestroyAfter(5);





		playerRot_4 = playerRot;

		playerRot_4.Yaw = RandRangeF(360,1);

		playerRot_4.Pitch = RandRangeF(45,-45);

		playerRot_4.Roll = RandRange( 360, 0 );

		playerPos_4 = playerPos;

		playerPos_4.Z += RandRangeF( 0.5, 0 );

		playerPos_4.Y += RandRangeF( 1.4, -0.4 );

		playerPos_4.X += RandRangeF( 2.4, -2.4 );




		ent__3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_4, playerRot_4 );
		
		ent__3.AddTag('Umbral_Slash_End_Mark');


		ent__3.PlayEffectSingle('sword_slash_red_large');

		ent__3.DestroyAfter(5);


		playerRot_5 = playerRot;

		playerRot_5.Yaw = RandRangeF(360,1);

		playerRot_5.Pitch = RandRangeF(45,-45);

		playerRot_5.Roll = RandRange( 360, 0 );

		playerPos_5 = playerPos;

		playerPos_5.Z += RandRangeF( 0.5, 0 );

		playerPos_5.Y += RandRangeF( 1.4, -0.4 );

		playerPos_5.X += RandRangeF( 1.4, -1.4 );




		ent__4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_5, playerRot_5 );
		
		ent__4.AddTag('Umbral_Slash_End_Mark');


		ent__4.PlayEffectSingle('sword_slash_red_large');

		ent__4.DestroyAfter(5);





		playerRot_6 = playerRot;

		playerRot_6.Yaw = RandRangeF(360,1);

		playerRot_6.Pitch = RandRangeF(45,-45);

		playerRot_6.Roll = RandRange( 360, 0 );

		playerPos_6 = playerPos;

		playerPos_6.Z += RandRangeF( 0.5, 0 );

		playerPos_6.Y += RandRangeF( 1.4, -0.4 );

		playerPos_6.X += RandRangeF( 2.4, -2.4 );



		ent__5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_6, playerRot_6 );
		
		ent__5.AddTag('Umbral_Slash_End_Mark');


		ent__5.PlayEffectSingle('sword_slash_red_large');

		ent__5.DestroyAfter(5);




		playerRot_7 = playerRot;

		playerRot_7.Yaw = RandRangeF(360,1);

		playerRot_7.Pitch = RandRangeF(45,-45);

		playerRot_7.Roll = RandRange( 360, 0 );

		playerPos_7 = playerPos;

		playerPos_7.Z += RandRangeF( 0.5, 0 );

		playerPos_7.Y += RandRangeF( 1.4, -0.4 );

		playerPos_7.X += RandRangeF( 2.4, -2.4 );


		ent__6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_7, playerRot_7 );
		
		ent__6.AddTag('Umbral_Slash_End_Mark');

		ent__6.PlayEffectSingle('sword_slash_red_large');

		ent__6.DestroyAfter(5);

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Sparagmos_Effect()
{
	var vACS_Sparagmos : cACS_Sparagmos;
	vACS_Sparagmos = new cACS_Sparagmos in theGame;
			
	vACS_Sparagmos.ACS_Sparagmos_Engage();
}

function ACS_Sparagmos_Damage()
{
	var vACS_Sparagmos : cACS_Sparagmos;
	vACS_Sparagmos = new cACS_Sparagmos in theGame;
			
	vACS_Sparagmos.ACS_Sparagmos_Damage_Engage();
}

statemachine class cACS_Sparagmos
{
    function ACS_Sparagmos_Engage()
	{
		this.PushState('ACS_Sparagmos_Engage');
	}

	function ACS_Sparagmos_Damage_Engage()
	{
		this.PushState('ACS_Sparagmos_Damage_Engage');
	}
}

state ACS_Sparagmos_Engage in cACS_Sparagmos
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7                         																					: CEntity;
	private var playerRot, playerRot_1, playerRot_2, playerRot_3, playerRot_4, playerRot_5, playerRot_6, playerRot_7, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6             : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, playerPos_4, playerPos_5, playerPos_6, playerPos_7, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6				: Vector;
	private var euler_sword																																						: EulerAngles;
	private var vector_sword																																					: Vector;
	private var eff_names																																						: array<CName>;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sparagmos();
	}
	
	entry function Sparagmos()
	{
		Sparagmos_Activate();
	}

	function fill_lightning_array()
	{
		eff_names.Clear();

		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('down');
		eff_names.PushBack('up');
		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');
		eff_names.PushBack('left');
	}
	
	latent function Sparagmos_Activate()
	{
		fill_lightning_array();

		//GetACSWatcher().RemoveTimer('ACS_Sparagmos_Electric_Effect');

		//GetACSSparagmosEffect_2().Destroy();

		playerRot = GetWitcherPlayer().GetWorldRotation();

		playerPos = GetWitcherPlayer().GetWorldPosition();


		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos, playerRot );

		euler_sword.Roll = 0;
		euler_sword.Pitch = 0;
		euler_sword.Yaw = 0;
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 5.25;

		ent.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword );

		//ent.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent.AddTag('ACS_Sparagmos_Effect');

		ent.DestroyAfter(2);



		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			
			"gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent"
			
			, true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 0.25;

		ent_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword );
		
		//ent.PlayEffectSingle('diagonal_up_left');
		//ent.PlayEffectSingle('diagonal_down_left');
		//ent.PlayEffectSingle('down');
		//ent.PlayEffectSingle('up');
		//ent.PlayEffectSingle('diagonal_up_right');
		//ent.PlayEffectSingle('diagonal_down_right');
		//ent.PlayEffectSingle('right');
		//ent.PlayEffectSingle('left');

		ent_1.PlayEffect(eff_names[RandRange(eff_names.Size())]);
		ent_1.PlayEffect(eff_names[RandRange(eff_names.Size())]);
		ent_1.PlayEffect(eff_names[RandRange(eff_names.Size())]);

		ent_1.PlayEffect('shock');
		ent_1.PlayEffect('shock');
		ent_1.PlayEffect('shock');
		ent_1.PlayEffect('shock');
		ent_1.PlayEffect('shock');

		ent_1.StopEffect('shock');

		ent_1.DestroyAfter(2);

		ent_1.AddTag('ACS_Sparagmos_Effect_1');


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 2;

		ent_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_2.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_2.AddTag('ACS_Sparagmos_Effect_2');

		ent_2.DestroyAfter(2);



		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 6;

		ent_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_3.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_3.AddTag('ACS_Sparagmos_Effect_3');

		ent_3.DestroyAfter(2);


		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 10;

		ent_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_4.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_4.AddTag('ACS_Sparagmos_Effect_4');

		ent_4.DestroyAfter(2);




		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 14;

		ent_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_5.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_5.AddTag('ACS_Sparagmos_Effect_5');

		ent_5.DestroyAfter(2);

		//ACS_Heavy_Attack_Extended_Trail();

		GetACSWatcher().AddTimer('ACS_Sparagmos_Electric_Effect', 0.1, true);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sparagmos_Damage_Engage in cACS_Sparagmos
{
	private var ent_6                       																																	: CEntity;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var attAction																																						: W3Action_Attack;
	private var eff_names																																						: array<CName>;
	private var targetPos																																						: Vector;
	private var targetRot																																						: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sparagmos_Damage();
	}
	
	entry function Sparagmos_Damage()
	{
		LockEntryFunction(true);
		Sparagmos_Damage_Activate();
		LockEntryFunction(false);
	}

	function fill_lightning_array()
	{
		eff_names.Clear();

		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('down');
		eff_names.PushBack('up');
		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');
		eff_names.PushBack('left');
	}
	
	latent function Sparagmos_Damage_Activate()
	{
		fill_lightning_array();

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				targetPos = actortarget.GetWorldPosition();

				targetRot = actortarget.GetWorldRotation();

				ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), actortarget.GetWorldPosition() );

				ent_6.CreateAttachment( actortarget, , Vector(0,0,1), EulerAngles(RandRangeF(360,0), RandRangeF(360,0), RandRangeF(360,0)) );
				
				ent_6.PlayEffect(eff_names[RandRange(eff_names.Size())]);

				/*
				ent_6.PlayEffectSingle('diagonal_up_left');
				ent_6.PlayEffectSingle('diagonal_up_left');
				ent_6.PlayEffectSingle('diagonal_down_left');
				ent_6.PlayEffectSingle('down');
				ent_6.PlayEffectSingle('up');
				ent_6.PlayEffectSingle('diagonal_up_right');
				ent_6.PlayEffectSingle('diagonal_down_right');
				ent_6.PlayEffectSingle('right');
				ent_6.PlayEffectSingle('left');
				*/

				//ent_6.PlayEffectSingle('lightning_fx');
				ent_6.PlayEffectSingle('shock');

				ent_6.DestroyAfter(1);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSSparagmosEffect() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect' );
	return ent;
}

function GetACSSparagmosEffect_1() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_1' );
	return ent;
}

function GetACSSparagmosEffect_2() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_2' );
	return ent;
}

function GetACSSparagmosEffect_3() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_3' );
	return ent;
}

function GetACSSparagmosEffect_4() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_4' );
	return ent;
}

function GetACSSparagmosEffect_5() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_5' );
	return ent;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bruxa_Scream()
{
	var vACS_Bruxa_Scream : cACS_Bruxa_Scream;
	vACS_Bruxa_Scream = new cACS_Bruxa_Scream in theGame;
			
	vACS_Bruxa_Scream.ACS_Bruxa_Scream_Engage();
}

statemachine class cACS_Bruxa_Scream
{
    function ACS_Bruxa_Scream_Engage()
	{
		this.PushState('ACS_Bruxa_Scream_Engage');
	}
}

state ACS_Bruxa_Scream_Engage in cACS_Bruxa_Scream
{
	private var ent, ent_2, ent_3                   : CEntity;
	private var rot                        			: EulerAngles;
    private var pos									: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bruxa_Scream();
	}
	
	entry function Bruxa_Scream()
	{
		LockEntryFunction(true);
		Bruxa_Scream_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bruxa_Scream_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

		if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
			{
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_voice_taunt_claws");

				ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
					"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
					, true ), pos, rot );
				
				ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, 0 ), EulerAngles(0,0,0) );

				ent_2.PlayEffectSingle('swarm_attack');

				ent_2.DestroyAfter(7);

				ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
					"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
					, true ), pos, rot );
				
				ent_3.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, -5 ), EulerAngles(0,0,0) );

				ent_3.PlayEffectSingle('swarm_attack');

				ent_3.DestroyAfter(7);

				GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 4.5, false);
			}
			else	
			{
				GetWitcherPlayer().SoundEvent("monster_bruxa_voice_scream");

				ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\bob\data\gameplay\abilities\bruxa\bruxa_scream_attack.w2ent"
				, true ), pos, rot );

				ent.AddTag('ACS_Bruxa_Scream');

				ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

				ent.PlayEffectSingle('cone');

				ent.DestroyAfter(3);

				GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 2, false);
			}
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_voice_taunt_claws");

			ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
				, true ), pos, rot );
			
			ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, 0 ), EulerAngles(0,0,0) );

			ent_2.PlayEffectSingle('swarm_attack');

			ent_2.DestroyAfter(7);

			ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
				, true ), pos, rot );
			
			ent_3.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, -5 ), EulerAngles(0,0,0) );

			ent_3.PlayEffectSingle('swarm_attack');

			ent_3.DestroyAfter(7);

			GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 4.5, false);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function Get_ACS_Bruxa_Scream() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bruxa_Scream' );
	return ent;
}

function ACS_Bruxa_Scream_Release()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			dmg = new W3DamageAction in theGame.damageMgr;
			dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Bruxa_Scream_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

			dmg.SetProcessBuffsIfNoDamage(true);
			dmg.SetCanPlayHitParticle(true);
			
			if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
			{
				if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
				{
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

					dmg.AddEffectInfo( EET_Bleeding, 10 );

					dmg.AddEffectInfo( EET_Confusion, 1 );
				}
				else
				{
					Get_ACS_Bruxa_Scream().StopEffect('cone');

					Get_ACS_Bruxa_Scream().PlayEffectSingle('fx_push');

					if (actortarget.UsesVitality()) 
					{ 
						maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

						damageMax = maxTargetVitality * 0.15; 
					} 
					else if (actortarget.UsesEssence()) 
					{ 
						maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
						
						damageMax = maxTargetEssence * 0.15; 
					} 

					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
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

				dmg.AddEffectInfo( EET_Bleeding, 10 );

				dmg.AddEffectInfo( EET_Confusion, 1 );
			}

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );

			//dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
									
			delete dmg;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bat_Teleport_FX()
{
	var vACS_Bat_Teleport_FX : cACS_Bat_Teleport_FX;
	vACS_Bat_Teleport_FX = new cACS_Bat_Teleport_FX in theGame;
			
	vACS_Bat_Teleport_FX.ACS_Bat_Teleport_FX_Engage();
}

statemachine class cACS_Bat_Teleport_FX
{
    function ACS_Bat_Teleport_FX_Engage()
	{
		this.PushState('ACS_Bat_Teleport_FX_Engage');
	}
}

state ACS_Bat_Teleport_FX_Engage in cACS_Bat_Teleport_FX
{
	private var ent                         : CEntity;
	private var rot                         : EulerAngles;
    private var pos							: Vector;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bat_Teleport_FX_Entry();
	}
	
	entry function Bat_Teleport_FX_Entry()
	{
		Bat_Teleport_FX_Latent();
	}
	
	latent function Bat_Teleport_FX_Latent()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

			, true ), pos, rot );

		ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 90, 0 ) );

		ent.PlayEffectSingle('swarm_attack');

		ent.DestroyAfter(2);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Water_Aard()
{
	var vACS_Water_Aard : cACS_Water_Aard;
	vACS_Water_Aard = new cACS_Water_Aard in theGame;
			
	vACS_Water_Aard.ACS_Water_Aard_Engage();
}

statemachine class cACS_Water_Aard
{
    function ACS_Water_Aard_Engage()
	{
		this.PushState('ACS_Water_Aard_Engage');
	}
	
	function ACS_Water_Aard_Release_Engage()
	{
		this.PushState('ACS_Water_Aard_Release_Engage');
	}
}

state ACS_Water_Aard_Engage in cACS_Water_Aard
{
	private var ent, ent_2, ent_3                   : CEntity;
	private var rot                        			: EulerAngles;
    private var pos									: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Water_Aard();
	}
	
	entry function Water_Aard()
	{
		LockEntryFunction(true);
		Water_Aard_Activate();
		LockEntryFunction(false);
	}
	
	latent function Water_Aard_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.1;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"
		, true ), pos, rot );

		ent.AddTag('ACS_Water_Aard');

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.DestroyAfter(3);

		GetACSWatcher().AddTimer('ACS_Water_Aard_Release_Delay', 0.5, false);
	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Water_Aard_Release_Engage in cACS_Water_Aard
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent, ent_2, ent_3                  																																: CEntity;
	private var rot                        																																		: EulerAngles;
    private var pos																																								: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Water_Aard_Release();
	}
	
	entry function Water_Aard_Release()
	{
		LockEntryFunction(true);
		Water_Aard_Release_Activate();
		LockEntryFunction(false);
	}
	
	latent function Water_Aard_Release_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.1;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"
		, true ), pos, rot );

		ent.AddTag('ACS_Water_Aard');

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.PlayEffectSingle('blast');

		ent.DestroyAfter(3);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Water_Aard_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStatMax( BCS_Vitality ) * 0.03; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStatMax( BCS_Essence ) * 0.03; 
				} 

				if (
				!actortarget.HasTag('ACS_First_Water_Wave_Hit')
				&& !actortarget.HasTag('ACS_Second_Water_Wave_Hit')
				)
				{
					actortarget.AddTag('ACS_First_Water_Wave_Hit'); 
				}
				else if (
				actortarget.HasTag('ACS_First_Water_Wave_Hit') 
				)
				{
					actortarget.RemoveTag('ACS_First_Water_Wave_Hit'); 
					actortarget.AddTag('ACS_Second_Water_Wave_Hit');
				}
				else if (
				actortarget.HasTag('ACS_Second_Water_Wave_Hit')
				)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

					actortarget.RemoveTag('ACS_Second_Water_Wave_Hit'); 
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

				//dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function Get_ACS_Water_Aard() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Water_Aard' );
	return ent;
}

function ACS_Water_Aard_Release()
{
	var vACS_Water_Aard : cACS_Water_Aard;
	vACS_Water_Aard = new cACS_Water_Aard in theGame;
			
	vACS_Water_Aard.ACS_Water_Aard_Release_Engage();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Stomp()
{
	var vACS_Giant_Stomp : cACS_Giant_Stomp;
	vACS_Giant_Stomp = new cACS_Giant_Stomp in theGame;
			
	vACS_Giant_Stomp.ACS_Giant_Stomp_Engage();
}

statemachine class cACS_Giant_Stomp
{
    function ACS_Giant_Stomp_Engage()
	{
		this.PushState('ACS_Giant_Stomp_Engage');
	}
}

state ACS_Giant_Stomp_Engage in cACS_Giant_Stomp
{
	private var ent_1, ent_2                																																	: CEntity;
	private var rot                        																																		: EulerAngles;
    private var pos																																								: Vector;
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax, maxTargetVitality, maxTargetEssence																													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Stomp_Entry();
	}
	
	entry function Giant_Stomp_Entry()
	{
		Giant_Stomp_Latent();
	}
	
	latent function Giant_Stomp_Latent()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_monster_ground.w2ent"

			"dlc\dlc_acs\data\fx\stomp_prer_ground.w2ent"

			, true ), pos, rot );

		//ent_1.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 1, 0 ), EulerAngles(0,0,0) );

		ent_1.PlayEffectSingle('impact');

		ent_1.PlayEffectSingle('warning');

		ent_1.DestroyAfter(5);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\monsters\dettlaff\blast.w2ent"
			
			"dlc\dlc_acs\data\fx\stomp_blast.w2ent"

			, true ), pos, rot );

		//ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 1, 0 ), EulerAngles(0,0,0) );

		ent_2.PlayEffectSingle('blast_lv1');

		ent_2.DestroyAfter(1);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Giant_Stomp_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.25; 
				} 

				if (
				!actortarget.HasTag('ACS_First_Giant_Stomp_Hit')
				&& !actortarget.HasTag('ACS_Second_Giant_Stomp_Hit')
				)
				{
					dmg.AddEffectInfo( EET_Stagger, 0.5 );

					actortarget.AddTag('ACS_First_Giant_Stomp_Hit'); 
				}
				else if (
				actortarget.HasTag('ACS_First_Giant_Stompe_Hit') 
				)
				{
					dmg.AddEffectInfo( EET_Stagger, 0.5 );

					actortarget.RemoveTag('ACS_First_Giant_Stomp_Hit'); 
					actortarget.AddTag('ACS_Second_Giant_Stomp_Hit');
				}
				else if (
				actortarget.HasTag('ACS_Second_Giant_Stomp_Hit')
				)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

					actortarget.RemoveTag('ACS_Second_Giant_Stomp_Hit'); 
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );

				//dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Storm_Spear_Effect()
{
	var vACS_Storm_Spear : cACS_Storm_Spear;
	vACS_Storm_Spear = new cACS_Storm_Spear in theGame;
			
	vACS_Storm_Spear.ACS_Storm_Spear_Engage();
}

function ACS_Storm_Spear_Damage()
{
	var vACS_Storm_Spear : cACS_Storm_Spear;
	vACS_Storm_Spear = new cACS_Storm_Spear in theGame;
			
	vACS_Storm_Spear.ACS_Storm_Spear_Damage_Engage();
}

statemachine class cACS_Storm_Spear
{
    function ACS_Storm_Spear_Engage()
	{
		this.PushState('ACS_Storm_Spear_Engage');
	}

	 function ACS_Storm_Spear_Damage_Engage()
	{
		this.PushState('ACS_Storm_Spear_Damage_Engage');
	}
}

state ACS_Storm_Spear_Damage_Engage in cACS_Storm_Spear
{
	private var ent_6                       																																	: CEntity;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var attAction																																						: W3Action_Attack;
	private var eff_names																																						: array<CName>;
	private var targetPos																																						: Vector;
	private var targetRot																																						: EulerAngles;
	private var meshcomp																																						: CComponent;
	private var animcomp 																																						: CAnimatedComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Storm_Spear_Damage();
	}
	
	entry function Storm_Spear_Damage()
	{
		LockEntryFunction(true);
		Storm_Spear_Damage_Activate();
		LockEntryFunction(false);
	}
	
	latent function Storm_Spear_Damage_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 30, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				targetPos = actortarget.GetWorldPosition();

				targetRot = actortarget.GetWorldRotation();

				ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\tornado_custom_2.w2ent", true ), actortarget.GetWorldPosition() );

				animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_6.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.5, 0.5, 0.5, 1 ));

				meshcomp.SetScale(Vector( 0.5, 0.5, 0.5, 1 ));	

				animcomp.SetAnimationSpeedMultiplier( 3  ); 

				ent_6.CreateAttachment( actortarget, , Vector( 0, 0, 0 ) );

				ent_6.PlayEffectSingle('tornado');

				ent_6.DestroyAfter(1.5);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Storm_Spear_Engage in cACS_Storm_Spear
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	private var rot, attach_rot                        						 	: EulerAngles;
   	private var pos, attach_vec													: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Storm_Spear_Entry();
	}
	
	entry function Storm_Spear_Entry()
	{
		Storm_Spear_Latent();
	}
	
	latent function Storm_Spear_Latent()
	{
		ACS_Storm_Spear_Array_Destroy_Immediate();

		GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_start");

		GetWitcherPlayer().SoundEvent("magic_man_sand_gust");

		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.25, 0.25, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.25, 0.25, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 8  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent.PlayEffectSingle('tornado');


		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_1.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.225, 0.225, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.225, 0.225, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 4  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_1.PlayEffectSingle('tornado');


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_2.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.2, 0.2, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.2, 0.2, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 2  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_2.PlayEffectSingle('tornado');


		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_3.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.175, 0.175, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.175, 0.175, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 1 ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_3.PlayEffectSingle('tornado');

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_4.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_4.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_4.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.15, 0.15, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.15, 0.15, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0.5  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_4.PlayEffectSingle('tornado');


		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_5.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_5.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_5.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.125, 0.125, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.125, 0.125, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0.25  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_5.PlayEffectSingle('tornado');

		ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_6.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_6.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0 ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_6.PlayEffectSingle('tornado');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Storm_Spear_Array_Destroy_Immediate()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	

	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

function ACS_Storm_Spear_Array_Destroy()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		//ents[i].Destroy();
		ents[i].StopAllEffects();
		ents[i].BreakAttachment(); 
		ents[i].Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ents[i].DestroyAfter(0.00125);
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

function ACS_Storm_Spear_Array_Stop_Effects()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].StopAllEffects();
		ents[i].DestroyAfter(3);
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Sword_Fall()
{
	var vACS_Giant_Sword_Fall : cACS_Giant_Sword_Fall;
	vACS_Giant_Sword_Fall = new cACS_Giant_Sword_Fall in theGame;
			
	vACS_Giant_Sword_Fall.ACS_Giant_Sword_Fall_Engage();
}

statemachine class cACS_Giant_Sword_Fall
{
    function ACS_Giant_Sword_Fall_Engage()
	{
		this.PushState('ACS_Giant_Sword_Fall_Engage');
	}
}

state ACS_Giant_Sword_Fall_Engage in cACS_Giant_Sword_Fall
{
	private var initpos					: Vector;
	private var sword 					: SwordProjectileGiant;
	private var actor       			: CActor;
	private var targetPosition			: Vector;
	private var meshcomp 				: CComponent;
	private var h 						: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Sword_Fall_Entry();
	}
	
	entry function Giant_Sword_Fall_Entry()
	{
		Giant_Sword_Fall_Latent();
	}
	
	latent function Giant_Sword_Fall_Latent()
	{
		actor = ( CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = actor.GetWorldPosition();				
			initpos.Z += 40;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectileGiant)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 10;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 50, targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;				
			initpos.Z += 40;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
				
			sword = (SwordProjectileGiant)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 10;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 50, targetPosition, 500 );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Dagger_Summon()
{
	var vACS_Dagger_Summon : cACS_Dagger_Summon;
	vACS_Dagger_Summon = new cACS_Dagger_Summon in theGame;
			
	vACS_Dagger_Summon.ACS_Dagger_Summon_Engage();
}

statemachine class cACS_Dagger_Summon
{
    function ACS_Dagger_Summon_Engage()
	{
		this.PushState('ACS_Dagger_Summon_Engage');
	}
}

state ACS_Dagger_Summon_Engage in cACS_Dagger_Summon
{
	private var attach_vec				: Vector;
	private var dagger_1 				: CEntity;
	private var attach_rot				: EulerAngles;
	private var meshcomp 				: CComponent;
	private var h 						: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		GetACSWatcher().RemoveTimer('ACS_Dagger_Destroy_Timer');
		//ACS_Dagger().Destroy();

		if(!GetWitcherPlayer().HasTag('ACS_Dagger_Summoned'))
		{
			Dagger_Summon_Entry();
		}

		GetACSWatcher().AddTimer('ACS_Dagger_Destroy_Timer', 1.25, false);
	}
	
	entry function Dagger_Summon_Entry()
	{
		Dagger_Summon_Latent();
	}
	
	latent function Dagger_Summon_Latent()
	{
		GetWitcherPlayer().AddTag('ACS_Dagger_Summoned');

		if ( !theSound.SoundIsBankLoaded("mq_nml_1035.bnk") )
		{
			theSound.SoundLoadBank( "mq_nml_1035.bnk", false );
		}

		GetWitcherPlayer().SoundEvent("scene_weapon_sword_unsheat_fast");

		dagger_1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
		"dlc\dlc_acs\data\entities\swords\baron_dagger.w2ent" 

		//"items\quest_items\q105\q105_item__ritual_dagger.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = 30;
		attach_rot.Pitch = 30;
		attach_rot.Yaw = 30;
		attach_vec.X = 0.025;
		attach_vec.Y = 0;
		attach_vec.Z = 0.0125;
			
		dagger_1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		dagger_1.AddTag('acs_dagger_1');

		//GetACSWatcher().AddTimer('ACS_Dagger_Summon_Delay', 0.125, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Dagger() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_dagger_1' );
	return sword;
}

function ACS_Dagger_Destroy()
{
	ACS_Dagger().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Dagger().BreakAttachment(); 
	ACS_Dagger().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Dagger().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('ACS_Dagger_Summoned');
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Sidearm_Summon()
{
	var vACS_Yrden_Sidearm_Summon : cACS_Yrden_Sidearm_Summon;
	vACS_Yrden_Sidearm_Summon = new cACS_Yrden_Sidearm_Summon in theGame;
			
	vACS_Yrden_Sidearm_Summon.ACS_Yrden_Sidearm_Summon_Engage();
}

statemachine class cACS_Yrden_Sidearm_Summon
{
    function ACS_Yrden_Sidearm_Summon_Engage()
	{
		this.PushState('ACS_Yrden_Sidearm_Summon_Engage');
	}
}

state ACS_Yrden_Sidearm_Summon_Engage in cACS_Yrden_Sidearm_Summon
{
	private var anchor_temp, blade_temp 					: CEntityTemplate;
	private var l_blade1, l_blade2, l_blade3, l_anchor		: CEntity;
	private var attach_vec, bone_vec						: Vector;
	private var attach_rot, bone_rot						: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');

		GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');

		if(!GetWitcherPlayer().HasTag('ACS_Yrden_Sidearm_Summoned'))
		{
			Dagger_Summon_Entry();
		}

		GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Destroy_Timer', 4, false);
	}
	
	entry function Dagger_Summon_Entry()
	{
		Dagger_Summon_Latent();
	}
	
	latent function Dagger_Summon_Latent()
	{
		GetWitcherPlayer().AddTag('ACS_Yrden_Sidearm_Summoned');

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_forearm' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_forearm', bone_vec, bone_rot );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
				
				, true );
		}
		else
		{
			blade_temp = (CEntityTemplate)LoadResource( 
				"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
				
				, true );
		}
				
		l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		
		l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		
		l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = -0.005;
		
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = 0.045;
		
		l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = -0.05;
		
		l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

		l_anchor.AddTag('acs_yrden_sidearm_anchor');

		l_blade1.AddTag('acs_yrden_sidearm_1');

		l_blade2.AddTag('acs_yrden_sidearm_2');

		l_blade3.AddTag('acs_yrden_sidearm_3');

		GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Summon_Delay', 0.125, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Yrden_Sidearm_Anchor() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_anchor' );
	return sword;
}

function ACS_Yrden_Sidearm_1() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_1' );
	return sword;
}

function ACS_Yrden_Sidearm_2() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_2' );
	return sword;
}

function ACS_Yrden_Sidearm_3() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_3' );
	return sword;
}

function ACS_Yrden_Sidearm_Destroy()
{
	ACS_Yrden_Sidearm_1().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_1().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_1().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Yrden_Sidearm_2().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_2().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_2().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Yrden_Sidearm_3().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_3().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_3().PlayEffectSingle('fast_attack_buff_hit');

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');

	GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer', 0.125, false);
}

function ACS_Yrden_Sidearm_DestroyActual()
{
	ACS_Yrden_Sidearm_Anchor().BreakAttachment(); 
	ACS_Yrden_Sidearm_Anchor().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_Anchor().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_1().BreakAttachment(); 
	ACS_Yrden_Sidearm_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_1().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_2().BreakAttachment(); 
	ACS_Yrden_Sidearm_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_2().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_3().BreakAttachment(); 
	ACS_Yrden_Sidearm_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_3().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('ACS_Yrden_Sidearm_Summoned');
}

function ACS_Yrden_Sidearm_DestroyIMMEDIATE()
{
	ACS_Yrden_Sidearm_Anchor().BreakAttachment(); 
	ACS_Yrden_Sidearm_Anchor().Destroy();

	ACS_Yrden_Sidearm_1().BreakAttachment(); 
	ACS_Yrden_Sidearm_1().Destroy();

	ACS_Yrden_Sidearm_2().BreakAttachment(); 
	ACS_Yrden_Sidearm_2().Destroy();

	ACS_Yrden_Sidearm_3().BreakAttachment(); 
	ACS_Yrden_Sidearm_3().Destroy();

	GetWitcherPlayer().RemoveTag('ACS_Yrden_Sidearm_Summoned');
}

function ACS_Yrden_Sidearm_UpdateEnhancements()
{
	var steelID, silverID 						: SItemUniqueId;
	var enhancements 							: array<name>;
	var runeCount 								: int;

	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

	enhancements.Clear();

	if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
	{
		GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

		runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
	}
	else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
	{
		GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

		runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
	}

	if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
	{
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_1().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().PlayEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_2().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().PlayEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_3().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().PlayEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
	}
	else if ( 3 == runeCount && 1 == enhancements.Size() )
	{
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_1().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().PlayEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_2().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().PlayEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_3().PlayEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().PlayEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
	}

	ACS_Yrden_Sidearm_1().PlayEffect('rune_blast_loop');

	ACS_Yrden_Sidearm_2().PlayEffect('rune_blast_loop');

	ACS_Yrden_Sidearm_3().PlayEffect('rune_blast_loop');
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Remove_Monster_Fear()
{
	var actors															: array<CActor>;
	var i																: int;
	var npc 															: CNewNPC;
	var actor 															: CActor;
	var targetDistance													: float;

	actors.Clear();
	
	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( npc.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (!npc.HasAbility('IsNotScaredOfMonsters'))
			{
				npc.AddAbility('IsNotScaredOfMonsters');
			}

			if ( targetDistance <= 10 * 10 )
			{
				if 
				(
					!npc.HasAbility('EtherealActive') 
					&& npc.HasTag('ACS_Knighmare_Eternum')
				)
				{
					npc.SoundEvent("qu_209_two_sirens_sing_loop_stop");
					npc.SoundEvent("magic_olgierd_ethereal_wake");

					npc.PlayEffectSingle('demonic_possession');

					npc.PlayEffectSingle('ethereal_buff');
					npc.StopEffect('ethereal_buff');

					npc.AddAbility('EtherealActive');
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rage_Marker_Manager()
{
	if (ACS_can_spawn_rage_marker() 
	&& ACS_RageMechanic_Enabled())
	{
		ACS_refresh_rage_marker_cooldown();

		Rage_Marker_Player();

		GetACSWatcher().RemoveTimer('ACS_Rage_Delay');

		GetACSWatcher().AddTimer('ACS_Rage_Delay', 1, false);
	}	
}

function Rage_Marker_Player()
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var npcRot, rot, attach_rot                        					: EulerAngles;
	var npcPos, pos, attach_vec											: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var actors															: array<CActor>;
	var i, num 															: int;
	var npc 															: CNewNPC;
	var actor 															: CActor;
	var markerTemplate 													: CEntityTemplate;

	if (
	GetWitcherPlayer().IsInCombat()
	)
	{
		actors.Clear();

		if ( theGame.GetDifficultyLevel() == EDM_Easy
		|| theGame.GetDifficultyLevel() == EDM_Medium
		|| theGame.GetDifficultyLevel() == EDM_Hard)
		{
			num = 1;
		}
		else if ( theGame.GetDifficultyLevel() == EDM_Hardcore)
		{
			num = 2;
		}
		else
		{
			num = 1;
		}
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, num, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsFlying()
				&& !npc.IsSwimming()
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.GetCharacterStats().HasAbilityWithTag('Boss')
				&& !npc.HasAbility( 'SkillBoss' )
				&& !npc.HasAbility( 'Boss' )
				&& !npc.HasAbility( 'MonsterMHBoss' )
				&& npc.GetNPCType() != ENGT_Guard
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				//&& npc.GetNPCType() != ENGT_Guard
				//&& !((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).IsLeavingStyle()
				//&& !npc.HasBuff(EET_Knockdown)
				//&& !npc.HasBuff(EET_Stagger)
				//&& !npc.HasBuff(EET_HeavyKnockdown)
				//&& !npc.HasBuff(EET_Ragdoll)
				//&& !npc.IsInHitAnim()
				)
				{
					if (npc.HasTag('ACS_Vampire_Monster')
					&& GetACSWatcher().ACS_Vampire_Monster_Flying_Process == true)
					{
						continue;
					}

					GetACSWatcher().Remove_On_Hit_Tags();
					
					attach_vec.X = 0;
					attach_vec.Y = 0;

					attach_vec.Z = 2.25;

					markerTemplate = (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

					ACS_Rage_Markers_Destroy();

					ACS_Rage_Markers_Player_Destroy();

					ent_1 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_1.AddTag('ACS_Rage_Marker_Player_1');

					ent_1.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					//ent_1.CreateAttachment( GetWitcherPlayer(), 'head', Vector(0,0,1), EulerAngles(0,0,0) );

					ent_1.PlayEffectSingle('marker');

					ent_1.PlayEffect('rune');

					//ent_1.PlayEffect('rune_2');

					ent_1.DestroyAfter(1.5);
					
					if( actors.Size() >= 2 )
					{
						GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
						GetWitcherPlayer().SoundEvent("sign_axii_ready");
					}
					else
					{
						GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
						GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
						GetWitcherPlayer().SoundEvent("sign_axii_ready");
						GetWitcherPlayer().SoundEvent("sign_axii_ready");
					}

					npc.RemoveTag('ACS_Pre_Rage');

					npc.RemoveTag('ACS_In_Rage');

					npc.AddTag('ACS_Pre_Rage');

					GetACSWatcher().SetRageProcess(true);

					ACS_Rage_Tutorial();
				}
			}
		}

		/*
		ent_2 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_2.AddTag('ACS_Rage_Marker_Player_2');

		ent_2.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_2.PlayEffectSingle('marker');

		ent_2.DestroyAfter(3);


		ent_3 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_3.AddTag('ACS_Rage_Marker_Player_3');

		ent_3.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_3.PlayEffectSingle('marker');

		ent_3.DestroyAfter(3);

		ent_4 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_4.AddTag('ACS_Rage_Marker_Player_4');

		ent_4.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_4.PlayEffectSingle('marker');

		ent_4.DestroyAfter(4);

		ent_5 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_5.AddTag('ACS_Rage_Marker_Player_5');

		ent_5.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_5.PlayEffectSingle('marker');

		ent_5.DestroyAfter(4);


		ent_6 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_6.AddTag('ACS_Rage_Marker_Player_6');

		ent_6.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_6.PlayEffectSingle('marker');

		ent_6.DestroyAfter(4);


		ent_7 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_7.AddTag('ACS_Rage_Marker_Player_7');

		ent_7.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_7.PlayEffectSingle('marker');

		ent_7.DestroyAfter(4);
		*/
	}
}

function ACS_Rage_Marker()
{
	var vACS_Rage_Marker : cACS_Rage_Marker;
	vACS_Rage_Marker = new cACS_Rage_Marker in theGame;

	vACS_Rage_Marker.ACS_Rage_Marker_Engage();
}

statemachine class cACS_Rage_Marker
{
    function ACS_Rage_Marker_Engage()
	{
		this.PushState('ACS_Rage_Marker_Engage');
	}

	function ACS_Rage_Marker_Player_Engage()
	{
		this.PushState('ACS_Rage_Marker_Player_Engage');
	}
}

state ACS_Rage_Marker_Engage in cACS_Rage_Marker
{
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, markerNPC, markerNPC_1     : CEntity;
	private var npcRot, rot, attach_rot                        								: EulerAngles;
	private var npcPos, pos, attach_vec														: Vector;
	private var meshcomp																	: CComponent;
	private var animcomp 																	: CAnimatedComponent;
	private var h 																			: float;
	private var actors																		: array<CActor>;
	private var i 																			: int;
	private var npc 																		: CNewNPC;
	private var actor 																		: CActor;
	private var markerTemplate_1, markerTemplate_2 											: CEntityTemplate;
	private var movementAdjustorNPC															: CMovementAdjustor;
	private var ticket 																		: SMovementAdjustmentRequestTicket;
	private var l_aiTree																	: CAIExecuteAttackAction;
	private var animatedComponentA 															: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		Rage_Marker_Entry();
	}
	
	entry function Rage_Marker_Entry()
	{
		Rage_Marker_Latent();
	}
	
	latent function Rage_Marker_Latent()
	{
		actors.Clear();
		
		//actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		theGame.GetActorsByTag( 'ACS_Pre_Rage', actors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Katakan')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('ACS_Vampire_Monster') 
				&& npc.GetNPCType() != ENGT_Guard
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				//&& !npc.HasBuff(EET_Knockdown)
				//&& !npc.HasBuff(EET_Stagger)
				//&& !npc.HasBuff(EET_HeavyKnockdown)
				//&& !npc.HasBuff(EET_Ragdoll)
				//&& !npc.IsInHitAnim()
				)
				{
					GetACSWatcher().Remove_On_Hit_Tags();

					npcRot = npc.GetWorldRotation();

					npcPos = npc.GetWorldPosition();

					attach_vec.X = 0;
					attach_vec.Y = 0;

					if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() > 2.25
					|| npc.GetRadius() > 0.7
					)
					{
						attach_vec.Z = 4.25;
					}
					else
					{
						attach_vec.Z = 2.5;
					}

					markerTemplate_1 = (CEntityTemplate)LoadResource( 
						
						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

					markerTemplate_2 = (CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\fx\vulnerable_marker.w2ent"
					
					, true );


					ent_1 = theGame.CreateEntity( markerTemplate_1, pos, rot );

					ent_1.AddTag('ACS_Rage_Marker_1');

					ent_1.CreateAttachment( npc, , attach_vec, EulerAngles(0,0,0) );

					ent_1.PlayEffectSingle('rune_2');

					ent_1.PlayEffectSingle('ground_smoke');

					ent_1.DestroyAfter(2);


					ent_2 = theGame.CreateEntity( markerTemplate_2, pos, rot );

					ent_2.AddTag('ACS_Rage_Marker_2');

					ent_2.CreateAttachment( npc, , attach_vec, EulerAngles(0,0,0) );

					ent_2.DestroyAfter(2);


					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );

					if (
					!npc.HasAbility('ImlerithSecondStage')
					)
					{
						npc.SetAnimationSpeedMultiplier(1 + RandRangeF(0.5, 0.25));
					}

					movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

					npc.RemoveTag('ACS_Pre_Rage');
					npc.AddTag('ACS_In_Rage');

					npc.AddBuffImmunity_AllNegative('ACS_Rage', true); 

					npc.AddBuffImmunity_AllCritical('ACS_Rage', true);

					npc.SetCanPlayHitAnim(false); 

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Rage_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Rage_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Rage_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

					((CNewNPC)actor).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

					if (
					!npc.HasAbility('mon_wyvern_base') 
					&& !npc.HasAbility('mon_draco_base')
					)
					{
						l_aiTree = new CAIExecuteAttackAction in actor;
						l_aiTree.OnCreated();

						if (actor.HasAbility('mon_golem_base')
						|| actor.HasAbility('mon_werewolf_base')
						)
						{
							l_aiTree.attackParameter = EAT_Attack3;
						}
						else
						{
							l_aiTree.attackParameter = EAT_Attack1;
						}
						
						actor.ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

						theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( actor, 'AttackAction', 1.0, 1.0f, 999.0f, 1, true); 
					}

					((CNewNPC)actor).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

					GetACSWatcher().RemoveTimer('ACS_Rage_Remove');

					GetACSWatcher().AddTimer('ACS_Rage_Remove', 2, false);
				}
			}
		}
		else
		{
			GetACSWatcher().RemoveTimer('ACS_Rage_Remove');
			GetACSWatcher().AddTimer('ACS_Rage_Remove', 0, false);

			ACS_Rage_Markers_Destroy();

			ACS_Rage_Markers_Player_Destroy();
		}
	}
}

state ACS_Rage_Marker_Player_Engage in cACS_Rage_Marker
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	private var npcRot, rot, attach_rot                        					: EulerAngles;
	private var npcPos, pos, attach_vec											: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var actors															: array<CActor>;
	private var i 																: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var markerTemplate 													: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		Rage_Marker_Player_Entry();
	}
	
	entry function Rage_Marker_Player_Entry()
	{
		Rage_Marker_Player_Latent();
	}
	
	latent function Rage_Marker_Player_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& npc.GetNPCType() != ENGT_Guard
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				)
				{
					attach_vec.X = 0;
					attach_vec.Y = 0;

					attach_vec.Z = 2.5;

					markerTemplate = (CEntityTemplate)LoadResource( 

						//"dlc\dlc_acs\data\fx\vulnerable_marker.w2ent"

						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

					ACS_Rage_Markers_Destroy();

					ACS_Rage_Markers_Player_Destroy();

					ent_1 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_1.AddTag('ACS_Rage_Marker_Player_1');

					ent_1.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_1.PlayEffectSingle('marker');

					ent_1.PlayEffectSingle('glow');

					ent_1.DestroyAfter(3);

					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");

					ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\wolf_decal.w2ent", true ), pos, rot );

					ent_2.AddTag('ACS_Rage_Marker_Player_2');

					ent_2.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_2.PlayEffectSingle('glow');

					ent_2.DestroyAfter(3);

					/*
					ent_3 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_3.AddTag('ACS_Rage_Marker_Player_3');

					ent_3.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_3.PlayEffectSingle('marker');

					ent_3.DestroyAfter(3);

					ent_4 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_4.AddTag('ACS_Rage_Marker_Player_4');

					ent_4.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_4.PlayEffectSingle('marker');

					ent_4.DestroyAfter(4);

					ent_5 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_5.AddTag('ACS_Rage_Marker_Player_5');

					ent_5.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_5.PlayEffectSingle('marker');

					ent_5.DestroyAfter(4);


					ent_6 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_6.AddTag('ACS_Rage_Marker_Player_6');

					ent_6.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_6.PlayEffectSingle('marker');

					ent_6.DestroyAfter(4);


					ent_7 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_7.AddTag('ACS_Rage_Marker_Player_7');

					ent_7.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_7.PlayEffectSingle('marker');

					ent_7.DestroyAfter(4);
					*/
				}
			}
		}
	}
}

function ACS_Rage_Markers_Destroy()
{	
	var markers 										: array<CEntity>;
	var i												: int;
	
	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_1', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_2', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_3', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_4', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_5', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_6', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_7', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}
}

function ACS_Rage_Markers_Player_Destroy()
{	
	var markers 										: array<CEntity>;
	var i												: int;
	
	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_1', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_2', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_3', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_4', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_5', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_6', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_7', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}
}

function ACS_Rage_Marker_1_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_1' );
	return marker;
}

function ACS_Rage_Marker_2_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_2' );
	return marker;
}

function ACS_Rage_Marker_3_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_3' );
	return marker;
}

function ACS_Rage_Marker_4_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_4' );
	return marker;
}

function ACS_Rage_Marker_5_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_5' );
	return marker;
}

function ACS_Rage_Marker_6_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_6' );
	return marker;
}

function ACS_Rage_Marker_7_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_7' );
	return marker;
}

function ACS_Rage_Marker_Player_1_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_1' );
	return marker;
}

function ACS_Rage_Marker_Player_2_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_2' );
	return marker;
}

function ACS_Rage_Marker_Player_3_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_3' );
	return marker;
}

function ACS_Rage_Marker_Player_4_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_4' );
	return marker;
}

function ACS_Rage_Marker_Player_5_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_5' );
	return marker;
}

function ACS_Rage_Marker_Player_6_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_6' );
	return marker;
}

function ACS_Rage_Marker_Player_7_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_7' );
	return marker;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Ghoul_Venom
{
	function ACS_Ghoul_Venom_Start_Engage()
	{
		this.PushState('ACS_Ghoul_Venom_Start_Engage');
	}

    function ACS_Ghoul_Venom_Engage()
	{
		this.PushState('ACS_Ghoul_Venom_Engage');
	}
}

state ACS_Ghoul_Venom_Start_Engage in cACS_Ghoul_Venom
{
	private var actors															: array<CActor>;
	private var i, num 															: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_1, proj_2, proj_3	 										: PoisonProjectile;
	private var initpos, targetPosition											: Vector;
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var targetDistance													: float;
	private var ghoulAnimatedComponent 											: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Ghoul_Venom_Start_Entry();
	}
	
	entry function ACS_Ghoul_Venom_Start_Entry()
	{
		ACS_Ghoul_Venom_Start_Latent();
	}
	
	latent function ACS_Ghoul_Venom_Start_Latent()
	{
		if (theGame.GetDifficultyLevel() == EDM_Easy)
		{
			num = 1;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Medium)
		{
			num = 2;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Hard)
		{
			num = 3;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
		{
			num = 4;
		}
		else
		{
			num = 1;
		}

		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, num, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				npc.HasAbility('mon_ghoul_base')
				&& (npc.GetStat(BCS_Stamina) >= npc.GetStatMax(BCS_Stamina) * 0.25)
				)
				{
					if (
					npc.HasBuff(EET_Knockdown)
					|| npc.HasBuff(EET_HeavyKnockdown)
					|| npc.HasBuff(EET_Ragdoll)
					|| npc.HasBuff(EET_Burning)
					|| npc.HasBuff(EET_Frozen)
					|| npc.HasBuff(EET_LongStagger)
					|| npc.HasBuff(EET_Stagger)
					|| npc.HasBuff(EET_Weaken)
					|| npc.HasBuff(EET_Confusion)
					|| npc.HasBuff(EET_AxiiGuardMe)
					|| npc.HasBuff(EET_Hypnotized)
					|| npc.HasBuff(EET_Immobilized)
					|| npc.HasBuff(EET_Paralyzed)
					|| npc.HasBuff(EET_Blindness)
					|| npc.HasBuff(EET_Choking)
					|| npc.HasBuff(EET_Swarm)
					)			
					{
						return;
					}
					
					if( targetDistance >= 4.5 * 4.5 ) 
					{
						if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
						{
							theSound.SoundLoadBank( "monster_toad.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
						{
							theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
						{
							theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
						}

						movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

						ghoulAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

						ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_1');
						movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_1' );
						movementAdjustor.CancelAll();
						ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_1' );
						movementAdjustor.AdjustmentDuration( ticket, 1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

						ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

						npc.AddBuffImmunity(EET_Poison, 'ACS_Ghoul_Proj_Poison_Negate', true);

						npc.AddBuffImmunity(EET_PoisonCritical , 'ACS_Ghoul_Proj_Poison_Negate', true);

						npc.AddTag('ACS_Ghoul_Venom_Init');

						npc.PlayEffect('morph_fx');
						npc.StopEffect('morph_fx');

						npc.SoundEvent('monster_ghoul_morph_loop_stop');

						npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) * 0.25, 4 );

						npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
						npc.SetCanPlayHitAnim(false); 
						npc.AddBuffImmunity_AllNegative('acs_ghoul_immune', true); 
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

state ACS_Ghoul_Venom_Engage in cACS_Ghoul_Venom
{
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var proj_1, proj_2, proj_3	 															: PoisonProjectile;
	private var ice_proj_1, ice_proj_2, ice_proj_3  												: W3WHMinionProjectile;
	private var initpos, targetPosition, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Ghoul_Venom_Entry();
	}
	
	entry function ACS_Ghoul_Venom_Entry()
	{
		ACS_Ghoul_Venom_Latent();
	}
	
	latent function ACS_Ghoul_Venom_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				npc.HasAbility('mon_ghoul_base')
				&& npc.HasTag('ACS_Ghoul_Venom_Init')
				)
				{
					npc.SetImmortalityMode( AIM_None, AIC_Combat ); 
					npc.SetCanPlayHitAnim(true); 
					npc.RemoveBuffImmunity_AllNegative('acs_ghoul_immune'); 

					npc.RemoveTag('ACS_Ghoul_Venom_Init');

					npc.PlayEffect('morph_fx');
					npc.StopEffect('morph_fx');

					npc.SoundEvent('monster_ghoul_morph_loop_stop');

					ghoulAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

					movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

					ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_2');
					movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_2' );
					movementAdjustor.CancelAll();
					ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_2' );
					movementAdjustor.AdjustmentDuration( ticket, 1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

					//ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

					npc.AddBuffImmunity(EET_Poison, 'ACS_Ghoul_Proj_Poison_Negate', true);

					npc.AddBuffImmunity(EET_PoisonCritical , 'ACS_Ghoul_Proj_Poison_Negate', true);

					//initpos = npc.GetWorldPosition() + npc.GetWorldForward() * 0.5 ;

					initpos = npc.GetBoneWorldPosition('head');	

					initpos.Y += 0.25;
							
					targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
					targetPosition.Z += 0.5;

					targetPosition_1 = GetWitcherPlayer().PredictWorldPosition(0.1f);
					targetPosition_1.Z += 0.5;

					targetPosition_2 = GetWitcherPlayer().PredictWorldPosition(0.5f);
					targetPosition_2.Z += 0.5;

					targetPosition_3 = GetWitcherPlayer().PredictWorldPosition(1.0f);
					targetPosition_3.Z += 0.5;

					if ( npc.HasAbility('mon_ghoul_lesser')
					|| npc.HasAbility('mon_ghoul')
					|| npc.HasAbility('mon_ghoul_stronger')
					|| npc.HasAbility('mon_EP2_ghouls')
					|| npc.HasAbility('ghoul_hardcore')
					)
					{ 	
						proj_1 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffect('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						proj_1.DestroyAfter(10);
					}
					else if ( 
					npc.HasAbility('mon_alghoul')
					)
					{ 	
						proj_1 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffect('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_1, 500 );
						proj_1.DestroyAfter(10);

						Sleep(0.375);

						proj_2 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_2.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_2.PlayEffect('spit_travel');

						proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_2, 500 );
						proj_2.DestroyAfter(10);

						Sleep(0.375);

						proj_3 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_3.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_3, 500 );
						proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_greater_miscreant')
					)
					{ 	
						proj_1 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);
						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffect('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						proj_1.DestroyAfter(10);

						proj_2 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_2.Init(npc);

						//proj_2.PlayEffect('spit_travel');

						proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5, 500 );
						proj_2.DestroyAfter(10);


						proj_3 = (PoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_3.Init(npc);

						//proj_3.PlayEffect('spit_travel');

						//proj_3.PlayEffectSingle('spit_hit');
						proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5, 500 );
						proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_wild_hunt_minionMH')
					)
					{
						npc.PlayEffect('rift_fx_special');
						npc.PlayEffect('rift_fx_special');
						npc.PlayEffect('rift_fx_special');
						npc.StopEffect('rift_fx_special');

						npc.PlayEffect('morph_fx_copy');
						npc.PlayEffect('morph_fx_copy');
						npc.PlayEffect('morph_fx_copy');
						npc.StopEffect('morph_fx_copy');

						npc.StopEffect('r_trail_snow');
						npc.PlayEffect('r_trail_snow');
						npc.PlayEffect('r_trail_snow');
						npc.PlayEffect('r_trail_snow');

						npc.StopEffect('l_trail_snow');
						npc.PlayEffect('l_trail_snow');
						npc.PlayEffect('l_trail_snow');
						npc.PlayEffect('l_trail_snow');

						npc.StopEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');
						npc.PlayEffect('ice_armor');

						npc.PlayEffect('marker');
						npc.PlayEffect('marker');
						npc.PlayEffect('marker');
						npc.StopEffect('marker');

						npc.SoundEvent('monster_wildhunt_minion_ice_spike_out');
						GetWitcherPlayer().SoundEvent('monster_wildhunt_minion_ice_spike_out');

						ice_proj_1 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_1.Init(npc);
						ice_proj_1.PlayEffect('fire_line');
						ice_proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						ice_proj_1.DestroyAfter(10);

						ice_proj_2 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_2.Init(npc);
						ice_proj_2.PlayEffect('fire_line');
						ice_proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3, 500 );
						ice_proj_2.DestroyAfter(10);

						ice_proj_3 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_3.Init(npc);
						ice_proj_3.PlayEffect('fire_line');
						ice_proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3, 500 );
						ice_proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_wild_hunt_minion')
					)
					{
						npc.PlayEffect('rift_fx_special');
						npc.StopEffect('rift_fx_special');

						npc.PlayEffect('morph_fx_copy');
						npc.StopEffect('morph_fx_copy');

						npc.StopEffect('r_trail_snow');
						npc.PlayEffect('r_trail_snow');

						npc.StopEffect('l_trail_snow');
						npc.PlayEffect('l_trail_snow');

						npc.PlayEffect('marker');
						npc.StopEffect('marker');

						npc.SoundEvent('monster_wildhunt_minion_ice_spike_out');
						GetWitcherPlayer().SoundEvent('monster_wildhunt_minion_ice_spike_out');

						ice_proj_1 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_1.Init(npc);
						ice_proj_1.PlayEffect('fire_line');
						ice_proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						ice_proj_1.DestroyAfter(10);
					}

					/*
					proj_2 = (PoisonProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
						
						, true ), initpos );
									
					proj_2.Init(npc);
					proj_2.PlayEffect('spit_travel');
					proj_2.PlayEffectSingle('spit_hit');
					proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(5 , 0), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3, 500 );
					proj_2.DestroyAfter(10);


					proj_3 = (PoisonProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
						
						, true ), initpos );
									
					proj_3.Init(npc);
					proj_3.PlayEffect('spit_travel');
					proj_3.PlayEffectSingle('spit_hit');
					proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(5 , 0), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3, 500 );
					proj_3.DestroyAfter(10);
					*/
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Witch_Hunter_Throw_Bomb
{
	function ACS_Witch_Hunter_Throw_Bomb_Engage()
	{
		this.PushState('ACS_Witch_Hunter_Throw_Bomb_Engage');
	}

	function ACS_Witch_Hunter_Throw_Bomb_Actual_Engage()
	{
		this.PushState('ACS_Witch_Hunter_Throw_Bomb_Actual_Engage');
	}
}

state ACS_Witch_Hunter_Throw_Bomb_Engage in cACS_Witch_Hunter_Throw_Bomb
{
	private var actors															: array<CActor>;
	private var i 																: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_1															: W3Dimeritium;
	private var initpos, targetPosition											: Vector;
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var targetDistance, chance											: float;
	private var witchHunterAnimatedComponent, animatedComponentA 				: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Witch_Hunter_Throw_Bomb_Entry();
	}
	
	entry function ACS_Witch_Hunter_Throw_Bomb_Entry()
	{
		ACS_Witch_Hunter_Throw_Bomb_Latent();
	}
	
	latent function ACS_Witch_Hunter_Throw_Bomb_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 3, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				if (
				npc.IsHuman()
				&& npc.IsMan()
				&& npc.IsAnyWeaponHeld()
				&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
				&& !npc.HasTag( 'ethereal' )
				&& !npc.HasBuff(EET_Burning)
				&& !npc.HasBuff(EET_HeavyKnockdown)
				&& !npc.HasBuff(EET_Knockdown)
				&& !npc.HasBuff(EET_LongStagger)
				&& !npc.HasBuff(EET_Stagger)
				&& !npc.HasBuff(EET_Weaken)
				&& !npc.HasBuff(EET_WeakeningAura)
				&& !npc.HasBuff(EET_Confusion)
				&& !npc.HasBuff(EET_AxiiGuardMe)
				&& !npc.HasBuff(EET_Hypnotized)
				&& !npc.HasBuff(EET_Immobilized)
				&& !npc.HasBuff(EET_Paralyzed)
				&& !npc.HasBuff(EET_Blindness)
				&& !npc.HasBuff(EET_Choking)
				&& !npc.HasBuff(EET_Swarm)
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.GetInventory().HasItem('crossbow')
				&& !npc.GetInventory().HasItem('bow')
				&& !npc.GetInventory().HasItemByTag('crossbow')
				&& !npc.GetInventory().HasItemByTag('bow')
				&& !npc.HasAbility( 'q604_shades' )
				&& !npc.HasTag('ACS_Final_Bomb_Thrown')
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& GetACSWatcher().ACS_Rage_Process == false
				&& !animatedComponentA.HasFrozenPose()
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				)
				{
					if (!npc.HasTag('ACS_Bomber'))
					{ 
						npc.AddTag('ACS_Bomber');
					}

					if( 
					targetDistance >= 3.5 * 3.5
					//&& Bomb_Obstruct_Check()
					) 
					{
						if (StrContains( npc.GetReadableName(), "witch_hunter" ) 
						|| StrContains( npc.GetReadableName(), "inq_" ))
						{
							if (theGame.GetDifficultyLevel() == EDM_Easy)
							{
								chance = 0.3;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Medium)
							{
								chance = 0.4;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Hard)
							{
								chance = 0.5;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
							{
								chance = 0.75;
							}
							else
							{
								chance = 0.5;
							}
						}
						else
						{
							if (theGame.GetDifficultyLevel() == EDM_Easy)
							{
								chance = 0.2;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Medium)
							{
								chance = 0.3;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Hard)
							{
								chance = 0.4;
							}
							else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
							{
								chance = 0.5;
							}
							else
							{
								chance = 0.5;
							}
						}

						if( RandF() < chance ) 
						{
							npc.AddBuffImmunity_AllNegative('ACS_Bomber', true);

							npc.AddBuffImmunity_AllCritical('ACS_Bomber', true);

							movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

							ticket = movementAdjustor.GetRequest( 'ACS_Witch_Hunter_Proj_Rotate_1');
							movementAdjustor.CancelByName( 'ACS_Witch_Hunter_Proj_Rotate_1' );
							movementAdjustor.CancelAll();
							ticket = movementAdjustor.CreateNewRequest( 'ACS_Witch_Hunter_Proj_Rotate_1' );
							movementAdjustor.AdjustmentDuration( ticket, 0.5 );
							movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

							movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

							witchHunterAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

							witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_throw_bomb_01_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

							GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay_Timer');
							GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay_Timer', 0.5, false);

							/*
							if (RandF() < 0.5)
							{
								if (RandF() < 0.5)
								{
									witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_longsword_petard_aim_shoot_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
									
									GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
									GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.25, false);
								}
								else
								{
									witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_petard_aim_shoot_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

									GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
									GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.25, false);
								}
							}
							else
							{
								witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_throw_bomb_01_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

								GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
								GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.5, false);
							}
							*/
							
							npc.AddTag('ACS_Throw_Bomb_Init');
						}
					}
				}
			}
		}
	}

	function Bomb_Obstruct_Check(): bool
	{
		var tempEndPoint_1, tempEndPoint_2, normal_1, normal_2, bomberPos			: Vector;
		var collisionGroupsNames													: array<name>;	

		collisionGroupsNames.Clear();

		collisionGroupsNames.PushBack( 'Terrain');
		//collisionGroupsNames.PushBack( 'Static');
		collisionGroupsNames.PushBack( 'Water'); 
        //collisionGroupsNames.PushBack( 'Door' );
        //collisionGroupsNames.PushBack( 'Dangles' );
        //collisionGroupsNames.PushBack( 'Foliage' );
        //collisionGroupsNames.PushBack( 'Destructible' );
        //collisionGroupsNames.PushBack( 'RigidBody' );
        //collisionGroupsNames.PushBack( 'Boat' );
        //collisionGroupsNames.PushBack( 'BoatDocking' );
        //collisionGroupsNames.PushBack( 'Platforms' );
        //collisionGroupsNames.PushBack( 'Corpse' );
        //collisionGroupsNames.PushBack( 'Ragdoll' ); 

		bomberPos = ACSGetBomber().GetWorldPosition();

		//bomberPos.Z += 1.25;

		if ( theGame.GetWorld().StaticTrace( bomberPos, bomberPos + ACSGetBomber().GetHeadingVector() * 2.25, tempEndPoint_1, normal_1, collisionGroupsNames )
		//|| theGame.GetWorld().StaticTrace( bomberPos, bomberPos + ACSGetBomber().GetWorldRight() * -1.5, tempEndPoint_2, normal_2, collisionGroupsNames)	
		)
		{
			return false;
		}
		
		return true;
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witch_Hunter_Throw_Bomb_Actual_Engage in cACS_Witch_Hunter_Throw_Bomb
{
	private var actors															: array<CActor>;
	private var i, num 															: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_Dimeritium													: W3ACSEnemyDimeritium;
	private var proj_Shrapnel													: W3ACSPetard;
	private var chance															: float;
	private var animatedComponentA 												: CAnimatedComponent;
	private var initpos, targetPosition											: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Witch_Hunter_Throw_Bomb_Actual_Entry();
	}
	
	entry function ACS_Witch_Hunter_Throw_Bomb_Actual_Entry()
	{
		ACS_Witch_Hunter_Throw_Bomb_Actual_Latent();
	}
	
	latent function ACS_Witch_Hunter_Throw_Bomb_Actual_Latent()
	{
		actors.Clear();
		
		//actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 30, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		theGame.GetActorsByTag( 'ACS_Throw_Bomb_Init', actors );	

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				npc.RemoveTag('ACS_Bomber');

				npc.RemoveBuffImmunity_AllNegative('ACS_Bomber');

				npc.RemoveBuffImmunity_AllCritical('ACS_Bomber');

				if (npc.IsHuman()
				&& GetACSWatcher().ACS_Rage_Process == false
				&& npc.HasTag('ACS_Throw_Bomb_Init')
				&& !npc.HasBuff(EET_Burning)
				&& !npc.HasBuff(EET_HeavyKnockdown)
				&& !npc.HasBuff(EET_Knockdown)
				&& !npc.HasBuff(EET_LongStagger)
				&& !npc.HasBuff(EET_Stagger)
				&& !npc.HasBuff(EET_WeakeningAura)
				&& !npc.HasBuff(EET_Weaken)
				&& !npc.HasBuff(EET_Confusion)
				&& !npc.HasBuff(EET_AxiiGuardMe)
				&& !npc.HasBuff(EET_Hypnotized)
				&& !npc.HasBuff(EET_Immobilized)
				&& !npc.HasBuff(EET_Paralyzed)
				&& !npc.HasBuff(EET_Blindness)
				&& !npc.HasBuff(EET_Choking)
				&& !npc.HasBuff(EET_Swarm)
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.GetInventory().HasItem('crossbow')
				&& !npc.GetInventory().HasItem('bow')
				&& !npc.GetInventory().HasItemByTag('crossbow')
				&& !npc.GetInventory().HasItemByTag('bow')
				&& !npc.HasTag('ACS_Final_Bomb_Thrown')
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !animatedComponentA.HasFrozenPose()
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				)
				{
					initpos = npc.GetWorldPosition() + npc.GetHeadingVector() + npc.GetWorldForward();	

					initpos.Y += 1;
					initpos.Z += 1.1;
					//initpos.X -= 1;
							
					targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
					targetPosition.Z += 0.5;

					if (StrContains( npc.GetReadableName(), "witch_hunter" ) 
					|| StrContains( npc.GetReadableName(), "inq_" ))
					{
						if (!npc.HasTag('ACS_1st_Bomb_Thrown')
						&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.25;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.5;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.75;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
						&& npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.95;
						}
						
						if( RandF() < chance ) 
						{
							proj_Dimeritium = (W3ACSEnemyDimeritium)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_dimeritium_bomb.w2ent"
							
							, true ), initpos );
											
							proj_Dimeritium.Init(npc);

							proj_Dimeritium.Initialize(npc);

							proj_Dimeritium.PlayEffect('activate');

							proj_Dimeritium.PlayEffect('activate_cluster');

							proj_Dimeritium.ThrowProjectile(targetPosition);
						}
						else
						{
							proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_shrapnel_bomb.w2ent"
							
							, true ), initpos );
											
							proj_Shrapnel.Init(npc);

							proj_Shrapnel.Initialize(npc);

							proj_Shrapnel.ThrowProjectile(targetPosition);

							/*
							proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_grapeshot.w2ent"
							
							, true ), initpos );
											
							proj_Shrapnel.Init(npc);

							proj_Shrapnel.Initialize(npc);

							proj_Shrapnel.ThrowProjectile(targetPosition);
							*/
						}
					}
					else
					{
						proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
						(CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_shrapnel_bomb.w2ent"

						, true ), initpos );
										
						proj_Shrapnel.Init(npc);

						proj_Shrapnel.Initialize(npc);

						proj_Shrapnel.ThrowProjectile(targetPosition);

						/*
						proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
						(CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_grapeshot.w2ent"
						
						, true ), initpos );
										
						proj_Shrapnel.Init(npc);

						proj_Shrapnel.Initialize(npc);

						proj_Shrapnel.ThrowProjectile(targetPosition);
						*/
					}

					npc.RemoveTag('ACS_Throw_Bomb_Init');

					if (!npc.HasTag('ACS_1st_Bomb_Thrown')
					&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_1st_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_2nd_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_3rd_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
					&& npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						if (!npc.HasTag('ACS_Final_Bomb_Thrown'))
						{
							npc.AddTag('ACS_Final_Bomb_Thrown');
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

function ACSGetBomber() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Bomber' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Tentacle
{
	function ACS_Tentacle_Start_Engage()
	{
		this.PushState('ACS_Tentacle_Start_Engage');
	}

    function ACS_Tentacle_Engage()
	{
		this.PushState('ACS_Tentacle_Engage');
	}
}

state ACS_Tentacle_Start_Engage in cACS_Tentacle
{
	private var actors, victims																		: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var drownerAnimatedComponent 															: CAnimatedComponent;
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    							: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchor_temp, ent_1_temp, ent_2_temp													: CEntityTemplate;

	private var dmg																					: W3DamageAction;

	private var l_aiTree																			: CAIExecuteAttackAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Tentacle_Start_Entry();
	}
	
	entry function ACS_Tentacle_Start_Entry()
	{
		ACS_Tentacle_Start_Latent();
	}
	
	latent function ACS_Tentacle_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				(npc.HasAbility('mon_drowner_base')
				|| npc.HasAbility('mon_rotfiend')
				|| npc.HasAbility('mon_rotfiend_large')
				|| npc.HasAbility('mon_gravier'))
				)			
				{
					if (
					npc.HasBuff(EET_Knockdown)
					|| npc.HasBuff(EET_HeavyKnockdown)
					|| npc.HasBuff(EET_Ragdoll)
					|| npc.HasBuff(EET_Burning)
					|| npc.HasBuff(EET_Frozen)
					|| npc.HasBuff(EET_LongStagger)
					|| npc.HasBuff(EET_Stagger)
					|| npc.HasBuff(EET_Weaken)
					|| npc.HasBuff(EET_Confusion)
					|| npc.HasBuff(EET_AxiiGuardMe)
					|| npc.HasBuff(EET_Hypnotized)
					|| npc.HasBuff(EET_Immobilized)
					|| npc.HasBuff(EET_Paralyzed)
					|| npc.HasBuff(EET_Blindness)
					|| npc.HasBuff(EET_Choking)
					|| npc.HasBuff(EET_Swarm)
					)			
					{
						return;
					}

					if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
					{
						theSound.SoundLoadBank( "monster_toad.bnk", false );
					}

					npc.AddTag('ACS_Tentacle_Init');

					l_aiTree = new CAIExecuteAttackAction in npc;
					l_aiTree.OnCreated();

					l_aiTree.attackParameter = EAT_Attack5;

					//npc.ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

					movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

					drownerAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

					ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Rotate_1');
					movementAdjustor.CancelByName( 'ACS_Tentacle_Rotate_1' );
					movementAdjustor.CancelAll();
					ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Rotate_1' );
					movementAdjustor.AdjustmentDuration( ticket, 1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

					//npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
					//npc.SetCanPlayHitAnim(false); 
					//npc.AddBuffImmunity_AllNegative('acs_tentacle_immune', true); 

					GetACSTentacle_1().Destroy();

					GetACSTentacle_2().Destroy();

					GetACSTentacle_3().Destroy();

					GetACSTentacleAnchor().Destroy();

					rot = npc.GetWorldRotation();

					pos = npc.GetWorldPosition() + npc.GetWorldForward() * 5;

					anchor_temp = (CEntityTemplate)LoadResourceAsync( 
						
					"dlc\dlc_acs\data\fx\drowner_warning.w2ent"
					
					, true );


					npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bone_vec, bone_rot );

					anchor = (CEntity)theGame.CreateEntity( anchor_temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

					anchor.PlayEffect('marker');

					anchor.AddTag('acs_tentacle_anchor');

					anchor.CreateAttachmentAtBoneWS( npc, 'head', bone_vec, bone_rot );

					((CActor)anchor).EnableCollisions(false);
					((CActor)anchor).EnableCharacterCollisions(false);

					ent_1_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

					ent_2_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );

					ent_1 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_1.AddTag('ACS_Tentacle_1');

					((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_1).EnableCharacterCollisions(false);
					((CNewNPC)ent_1).EnableCollisions(false);
					((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
					((CActor)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_1).EnableCollisions(false);
					((CActor)ent_1).EnableCharacterCollisions(false);
					((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

					npc.EnableCharacterCollisions(false);

					animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = 90;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.4;
					attach_vec.Y = 0.15;
					attach_vec.Z = 0;

					ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );
					
					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					//animcomp.FreezePoseFadeIn(7.5f);

					ent_2 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_2.AddTag('ACS_Tentacle_2');

					((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_2).EnableCharacterCollisions(false);
					((CNewNPC)ent_2).EnableCollisions(false);
					((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
					((CActor)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_2).EnableCollisions(false);
					((CActor)ent_2).EnableCharacterCollisions(false);
					((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

					animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = -30;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = -0.3;
					attach_vec.Y = 0.15;
					attach_vec.Z = -0.35;

					ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					//animcomp.FreezePoseFadeIn(7.5f);

					ent_3 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_3.AddTag('ACS_Tentacle_3');

					((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_3).EnableCharacterCollisions(false);
					((CNewNPC)ent_3).EnableCollisions(false);
					((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
					((CActor)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_3).EnableCollisions(false);
					((CActor)ent_3).EnableCharacterCollisions(false);
					((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

					animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = -150;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = -0.3;
					attach_vec.Y = 0.15;
					attach_vec.Z = 0.35;

					ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					GetACSWatcher().RemoveTimer('ACS_Tentacle_Damage_Delay');
					GetACSWatcher().AddTimer('ACS_Tentacle_Damage_Delay', 1, false);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Tentacle_Damage_Actual()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;
	var l_aiTree						: CAIExecuteAttackAction;
	
	npc = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_Init' );
	
	if ( npc.GetCurrentHealth() <= 0 
	|| !npc.IsAlive())
	{
		GetACSTentacleAnchor().BreakAttachment(); 
		GetACSTentacleAnchor().Destroy();

		GetACSTentacle_1().BreakAttachment(); 
		GetACSTentacle_1().Destroy();

		GetACSTentacle_2().BreakAttachment(); 
		GetACSTentacle_2().Destroy();

		GetACSTentacle_3().BreakAttachment(); 
		GetACSTentacle_3().Destroy();

		npc.RemoveTag('ACS_Tentacle_Init');

		npc.EnableCharacterCollisions(true);

		return;
	}

	GetACSWatcher().RemoveTimer('ACS_Tentacle_Remove');
	GetACSWatcher().AddTimer('ACS_Tentacle_Remove', 0.5, false);

	victims.Clear();

	victims = npc.GetNPCsAndPlayersInCone(3, VecHeading(npc.GetHeadingVector()), 15, 20, , FLAG_OnlyAliveActors );

	if( victims.Size() > 0)
	{
		for( i = 0; i < victims.Size(); i += 1 )
		{
			actortarget = (CActor)victims[i];

			if (actortarget != npc
			&& actortarget != GetACSTentacle_1()
			&& actortarget != GetACSTentacle_2()
			&& actortarget != GetACSTentacle_3()
			&& actortarget != GetACSTentacleAnchor()
			)
			{
				if 
				(
					GetWitcherPlayer().IsInGuardedState()
					|| GetWitcherPlayer().IsGuarded()
				)
				{
					GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
					GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
				}
				else if 
				(
					GetWitcherPlayer().IsAnyQuenActive()
				)
				{
					GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else if 
				(
					GetWitcherPlayer().IsCurrentlyDodging()
				)
				{
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else
				{
					movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

					ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Hit_Rotate');
					movementAdjustor.CancelByName( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, npc );

					actortarget.SoundEvent("cmb_play_hit_heavy");

					if (actortarget == GetWitcherPlayer())
					{
						AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

						AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

						if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
						{
							GetACSWatcher().Grow_Geralt_Immediate_Fast();

							GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
						}

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
					}

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "ACS_Tentacle_Knockdown";
					params.duration = 1;

					actortarget.AddEffectCustom( params );	
				}
			}
		}
	}

	npc.RemoveTag('ACS_Tentacle_Init');

	npc.EnableCharacterCollisions(true);
}

function GetACSTentacle_1() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_1' );
	return entity;
}

function GetACSTentacle_2() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_2' );
	return entity;
}

function GetACSTentacle_3() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_3' );
	return entity;
}

function GetACSTentacleAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_tentacle_anchor' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Nekker_Guardian
{
	function ACS_Nekker_Guardian_Start_Engage()
	{
		this.PushState('ACS_Nekker_Guardian_Start_Engage');
	}

	function ACS_Nekker_Guardian_Heal_Engage()
	{
		this.PushState('ACS_Nekker_Guardian_Heal_Engage');
	}
}

state ACS_Nekker_Guardian_Start_Engage in cACS_Nekker_Guardian
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor  																		: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var temp, anchorTemplate																: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Nekker_Guardian_Start_Entry();
	}
	
	entry function ACS_Nekker_Guardian_Start_Entry()
	{
		ACS_Nekker_Guardian_Start_Latent();
	}
	
	latent function ACS_Nekker_Guardian_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() >= 3 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.HasAbility('mon_nekker')
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& npc.IsInCombat()
				&& !npc.HasTag('ACS_Has_Summoned_Nekker_Guardian')
				)			
				{
					if (!GetACSNekkerGuardian() || !GetACSNekkerGuardian().IsAlive())
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\nekker_nekker.w2ent"
						
						, true );

						randRange = 1.5 + 1.5 * RandF();
						randAngle = 1.5 * Pi() * RandF();

						playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;
						
						spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
						spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
						spawnPos.Z = playerPos.Z;

						GetACSNekkerGuardian().Destroy();
						
						ent = theGame.CreateEntity( temp, spawnPos, GetWitcherPlayer().GetWorldRotation() );

						animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
						meshcomp = ent.GetComponentByClassName('CMeshComponent');
						h = 1.75;
						//animcomp.SetScale(Vector(h,h,h,1));
						//meshcomp.SetScale(Vector(h,h,h,1));	

						((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 7);
						((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

						((CNewNPC)ent).SetCanPlayHitAnim(false); 

						//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
						((CActor)ent).SetAnimationSpeedMultiplier(0.375);

						((CActor)ent).AddBuffImmunity_AllNegative('ACS_Nekker_Guardian', true);

						((CActor)ent).AddBuffImmunity_AllCritical('ACS_Nekker_Guardian', true);

						((CActor)ent).GetInventory().RemoveItemByName('Devine', -1);

						ent.AddTag( 'ACS_Nekker_Guardian' );
					}

					npc.SetAttitude(GetACSNekkerGuardian(), AIA_Friendly);

					npc.AddTag('ACS_Has_Summoned_Nekker_Guardian');
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Nekker_Guardian_Heal_Engage in cACS_Nekker_Guardian
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor, anchor_2  																: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchorTemplate																		: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Nekker_Guardian_Heal_Entry();
	}
	
	entry function ACS_Nekker_Guardian_Heal_Entry()
	{
		ACS_Nekker_Guardian_Heal_Latent();
	}
	
	latent function ACS_Nekker_Guardian_Heal_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.HasAbility('mon_nekker')
				&& npc.IsInCombat()
				&& !npc.HasTag('ACS_Nekker_Guardian')
				)			
				{
					if (GetACSNekkerGuardian().IsAlive())
					{
						npc.SetAttitude(GetACSNekkerGuardian(), AIA_Friendly);

						if (
						npc.GetStat(BCS_Essence) <= (npc.GetStatMax(BCS_Essence) * 0.75)
						)
						{
							if (GetACSNekkerGuardian().GetStat(BCS_Essence) >= GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.25)
							{
								GetACSNekkerGuardian().DrainEssence( GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.0125 );
							}

							npc.Heal(GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.05);

							npc.SoundEvent("monster_dettlaff_vampire_combat_magic_regeneration");

							GetACSNekkerGuardian().SoundEvent("monster_nekker_vo_scream");

							anchorTemplate = (CEntityTemplate)LoadResourceAsync( 
							
							"dlc\dlc_acs\data\fx\nekker_share_life_force.w2ent"
							
							, true );


							GetACSNekkerGuardian().GetBoneWorldPositionAndRotationByIndex( GetACSNekkerGuardian().GetBoneIndex( 'k_torso_g' ), bone_vec, bone_rot );

							anchor = (CEntity)theGame.CreateEntity( anchorTemplate, GetACSNekkerGuardian().GetWorldPosition() + Vector( 0, 0, -10 ) );

							anchor.CreateAttachmentAtBoneWS( GetACSNekkerGuardian(), 'k_torso_g', bone_vec, bone_rot );


							//anchor = (CEntity)theGame.CreateEntity( anchorTemplate, GetACSNekkerGuardian().GetWorldPosition(), GetACSNekkerGuardian().GetWorldRotation() );

							//anchor.CreateAttachment( GetACSNekkerGuardian(), , Vector(0,0,2) );

							anchor.AddTag('ACS_Nekker_Life_Force');

							anchor.DestroyAfter(5);




							npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'k_torso_g' ), bone_vec, bone_rot );

							anchor_2 = (CEntity)theGame.CreateEntity( anchorTemplate, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

							anchor_2.CreateAttachmentAtBoneWS( npc, 'k_torso_g', bone_vec, bone_rot );


							//anchor_2 = (CEntity)theGame.CreateEntity( anchorTemplate, ent.GetWorldPosition(), ent.GetWorldRotation() );

							//anchor_2.CreateAttachment( npc, , Vector( 0, 0, 1 ) );

							anchor_2.AddTag('ACS_Nekker_Life_Force_Anchor');

							anchor_2.DestroyAfter(5);









							GetACSNekkerGuardianShareLifeForce().StopEffect('drain_energy_1');
							GetACSNekkerGuardianShareLifeForce().PlayEffect('drain_energy_1', anchor_2);

							anchor_2.PlayEffect('drain_energy');
							anchor_2.PlayEffect('drain_energy');
							anchor_2.PlayEffect('drain_energy');
							anchor_2.StopEffect('drain_energy');
							
							anchor_2.StopEffect('drain_energy_1');
							anchor_2.PlayEffect('drain_energy_1', anchor);
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

function GetACSNekkerGuardian() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Nekker_Guardian' );
	return entity;
}

function GetACSNekkerGuardianShareLifeForce() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Nekker_Life_Force' );
	return entity;
}

function ACS_NekkerGuardianShareLifeForce_Destroy()
{
	var ents 												: array<CEntity>;
	var i													: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Nekker_Life_Force', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_NekkerGuardianShareLifeForceAnchor_Destroy()
{
	var ents 												: array<CEntity>;
	var i													: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Nekker_Life_Force_Anchor', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Katakan_Summon
{
	function ACS_Katakan_Summon_Start_Engage()
	{
		this.PushState('ACS_Katakan_Summon_Start_Engage');
	}
}

state ACS_Katakan_Summon_Start_Engage in cACS_Katakan_Summon
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor  																		: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var temp, anchorTemplate																: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Katakan_Summon_Start_Entry();
	}
	
	entry function ACS_Katakan_Summon_Start_Entry()
	{
		ACS_Katakan_Summon_Start_Latent();
	}
	
	latent function ACS_Katakan_Summon_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.IsAlive()
				&& npc.HasTag('novigrad_underground_vampire')
				//&& !npc.HasTag('ACS_Has_Summoned_Katakan')
				)			
				{
					if (!GetACSKatakan() || !GetACSKatakan().IsAlive())
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent"
						
						, true );

						playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5;

						GetACSKatakan().Destroy();
						
						ent = theGame.CreateEntity( temp, playerPos, npc.GetWorldRotation() );

						animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
						meshcomp = ent.GetComponentByClassName('CMeshComponent');
						h = 1;
						//animcomp.SetScale(Vector(h,h,h,1));
						//meshcomp.SetScale(Vector(h,h,h,1));

						((CActor)ent).SetAnimationSpeedMultiplier(0.75);

						((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel()/2);

						((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

						((CNewNPC)ent).SetAttitude(npc, AIA_Friendly);

						//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

						ent.AddTag( 'ACS_Katakan' );
					}

					npc.SetAttitude(GetACSKatakan(), AIA_Friendly);

					//npc.AddTag('ACS_Has_Summoned_Katakan');
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSKatakan() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Katakan' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Unseen_Blade_Summon_Start()
{
	var vACS_Unseen_Blade_Summon 		: cACS_Unseen_Blade_Summon;

	vACS_Unseen_Blade_Summon = new cACS_Unseen_Blade_Summon in theGame;

	vACS_Unseen_Blade_Summon.ACS_Unseen_Blade_Summon_Start_Engage();
}

function ACS_Unseen_Monster_Summon_Start()
{
	var vACS_Unseen_Blade_Summon 		: cACS_Unseen_Blade_Summon;

	vACS_Unseen_Blade_Summon = new cACS_Unseen_Blade_Summon in theGame;

	vACS_Unseen_Blade_Summon.ACS_Unseen_Monster_Summon_Start_Engage();
}

statemachine class cACS_Unseen_Blade_Summon
{
	function ACS_Unseen_Blade_Summon_Start_Engage()
	{
		this.PushState('ACS_Unseen_Blade_Summon_Start_Engage');
	}

	function ACS_Unseen_Monster_Summon_Start_Engage()
	{
		this.PushState('ACS_Unseen_Monster_Summon_Start_Engage');
	}
}

state ACS_Unseen_Blade_Summon_Start_Engage in cACS_Unseen_Blade_Summon
{
	private var temp, anchor_temp, ent_1_temp, blade_temp						: CEntityTemplate;
	private var ent, anchor, ent_1, r_anchor, l_anchor, r_blade1, l_blade1		: CEntity;
	private var i, count, j														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	private var actors															: array<CActor>;
	private var npc																: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Unseen_Blade_Summon_Start_Entry();
	}
	
	entry function ACS_Unseen_Blade_Summon_Start_Entry()
	{
		ACS_Unseen_Blade_Summon_Start_Latent();

		UnseenBladeSetAttitude();
	}
	
	latent function ACS_Unseen_Blade_Summon_Start_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\blade_of_the_unseen.w2ent"
		
		, true );

		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\swords\wildhunt_sword_lvl4.w2ent", true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ACS_Blade_Of_The_Unseen().Destroy();

			GetACS_Blade_Of_The_Unseen_L_Blade().Destroy();

			GetACS_Blade_Of_The_Unseen_L_Anchor().Destroy();

			GetACS_Blade_Of_The_Unseen_R_Blade().Destroy();

			GetACS_Blade_Of_The_Unseen_R_Anchor().Destroy();

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().DisplayHudMessage( "I am the blade in the darkness." );
			}
			else
			{
				GetWitcherPlayer().DisplayHudMessage( "The unseen blade is the deadliest." );
			}
	
			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 7);
			((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Blade_Of_The_Unseen' );

			ent.PlayEffectSingle('shadowdash');

			ent.PlayEffect('demonic_possession');

			ent.PlayEffect('him_smoke_red');
			ent.PlayEffect('him_smoke_red');
			ent.PlayEffect('him_smoke_red');
			ent.PlayEffect('him_smoke_red');

			ent.PlayEffect('special_attack_tell_r_leg');

			ent.PlayEffect('special_attack_tell_l_leg');

			ent.PlayEffect('hym_spawn');

			((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
			r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

			r_anchor.CreateAttachment( ((CActor)ent), 'r_hand',  );

			r_anchor.AddTag('ACS_Unseen_Blade_R_Anchor');
			
			ent.GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
			l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

			l_anchor.CreateAttachment( ((CActor)ent), 'l_hand',  );

			l_anchor.AddTag('ACS_Unseen_Blade_L_Anchor');

			r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );
			l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );

			attach_rot.Roll = 90;
			attach_rot.Pitch = 270;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.05;
			attach_vec.Y = -0.05;
			attach_vec.Z = -0.005;
			
			l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

			l_blade1.PlayEffect('runeword_igni');

			//l_blade1.PlayEffectSingle('red_runeword_igni_1');

			//l_blade1.PlayEffectSingle('red_runeword_igni_2');

			l_blade1.PlayEffect('runeword1_fire_trail');

			l_blade1.PlayEffect('fire_sparks_trail');

			l_blade1.PlayEffect('weapon_blood_stage2');

			l_blade1.PlayEffect('weapon_blood_stage1');

			attach_rot.Roll = 90;
			attach_rot.Pitch = 270;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.05;
			attach_vec.Y = -0.05;
			attach_vec.Z = -0.005;
			
			r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

			r_blade1.PlayEffect('runeword_igni');

			//r_blade1.PlayEffectSingle('red_runeword_igni_1');

			//r_blade1.PlayEffectSingle('red_runeword_igni_2');

			r_blade1.PlayEffect('runeword1_fire_trail');

			r_blade1.PlayEffect('fire_sparks_trail');

			r_blade1.PlayEffect('weapon_blood_stage2');

			r_blade1.PlayEffect('weapon_blood_stage1');

			l_blade1.AddTag('ACS_Blade_Of_The_Unseen_L_Blade');

			r_blade1.AddTag('ACS_Blade_Of_The_Unseen_R_Blade');
		}
	}

	latent function UnseenBladeSetAttitude()
	{
		actors.Clear();
		
		actors = ACS_Blade_Of_The_Unseen().GetNPCsAndPlayersInRange( 20, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( j = 0; j < actors.Size(); j += 1 )
			{
				npc = (CNewNPC)actors[j];

				if (
				npc.IsAlive()
				&& npc.HasAbility('mon_vampiress_base')
				)			
				{
					((CNewNPC)ACS_Blade_Of_The_Unseen()).SetAttitude(npc, AIA_Friendly);

					((CNewNPC)npc).SetAttitude(ACS_Blade_Of_The_Unseen(), AIA_Friendly);
				}
			}
		}
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Unseen_Monster_Summon_Start_Engage in cACS_Unseen_Blade_Summon
{
	private var temp, temp_bossbar												: CEntityTemplate;
	private var ent, ent_bossbar												: CEntity;
	private var i, count, j														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp, meshcomp_bossbar										: CComponent;
	private var animcomp, animcomp_bossbar 										: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	private var actors															: array<CActor>;
	private var npc																: CNewNPC;
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Unseen_Monster_Summon_Start_Entry();
	}
	
	entry function ACS_Unseen_Monster_Summon_Start_Entry()
	{
		ACS_Unseen_Monster_Summon_Start_Latent();

		UnseenMonsterSetAttitude();

		UnseenMonsterSpawnRotate();

		UnseenMonsterSpawnAnim();
	}
	
	latent function ACS_Unseen_Monster_Summon_Start_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\vampire_monster.w2ent"
			
		, true );

		temp_bossbar = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\vampire_monster_bossbar_dummy.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = 1;

		ACSVampireMonster().Destroy();

		ACSVampireMonsterBossBar().Destroy();
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().DisplayHudMessage( "I WILL TEAR YOU LIMB FROM LIMB" );
			}
			else
			{
				GetWitcherPlayer().DisplayHudMessage( "I SHALL FEAST UPON YOUR CORPSE AND BATHE IN YOUR BLOOD" );
			}

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//((CNewNPC)ent).SetCanPlayHitAnim(false);

			ent.PlayEffect('dive_shape');
			ent.StopEffect('dive_shape');

			ent.PlayEffect('smoke_explosion');
			ent.StopEffect('smoke_explosion');

			ent.PlayEffect('third_teleport_out');
			ent.StopEffect('third_teleport_out');

			ent.AddTag( 'ACS_Vampire_Monster' );

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			((CActor)ent).SetImmortalityMode( AIM_None, AIC_Default ); 

			ent_bossbar = theGame.CreateEntity( temp_bossbar, playerPos, GetWitcherPlayer().GetWorldRotation() );

			((CActor)ent_bossbar).SetCanPlayHitAnim(false); 

			((CNewNPC)ent_bossbar).SetCanPlayHitAnim(false); 

			((CActor)ent_bossbar).EnableCharacterCollisions(false);

			((CActor)ent_bossbar).EnableCollisions(false);	

			((CNewNPC)ent_bossbar).EnableCharacterCollisions(false);

			((CNewNPC)ent_bossbar).EnableCollisions(false);	

			((CNewNPC)ent_bossbar).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)ent_bossbar).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent_bossbar).SetAnimationSpeedMultiplier(0);

			((CActor)ent_bossbar).SetVisibility(false);

			((CActor)ent_bossbar).AddBuffImmunity_AllNegative('ACS_Vampire_Boss_Bar', true); 

			((CActor)ent_bossbar).AddBuffImmunity_AllCritical('ACS_Vampire_Boss_Bar', true); 

			((CActor)ent_bossbar).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

			((CNewNPC)ent_bossbar).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

			ent_bossbar.CreateAttachment(ent,,Vector(0,0,1),EulerAngles(0,0,0));

			animcomp_bossbar = (CAnimatedComponent)ent_bossbar.GetComponentByClassName('CAnimatedComponent');
			animcomp_bossbar.FreezePoseFadeIn(0.1);

			meshcomp_bossbar = ent_bossbar.GetComponentByClassName('CMeshComponent');
			meshcomp_bossbar.SetScale(Vector(0,0,0,0));	
			
			ent_bossbar.AddTag( 'ACS_Vampire_Monster_Boss_Bar' );

			((CNewNPC)ent_bossbar).SetAttitude(((CActor)ent), AIA_Friendly);
			((CNewNPC)ent).SetAttitude(((CActor)ent_bossbar), AIA_Friendly);
		}
	}

	latent function UnseenMonsterSetAttitude()
	{
		actors.Clear();
		
		actors = ACSVampireMonster().GetNPCsAndPlayersInRange( 20, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( j = 0; j < actors.Size(); j += 1 )
			{
				npc = (CNewNPC)actors[j];

				if (
				npc.IsAlive()
				&& npc.HasAbility('mon_vampiress_base')
				)			
				{
					((CNewNPC)ACSVampireMonster()).SetAttitude(npc, AIA_Friendly);

					((CNewNPC)npc).SetAttitude(ACSVampireMonster(), AIA_Friendly);

				}
			}
		}
	}

	latent function UnseenMonsterSpawnRotate()
	{
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Unseen_Monster_Spawn_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Unseen_Monster_Spawn_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Unseen_Monster_Spawn_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );
		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );
	}

	latent function UnseenMonsterSpawnAnim()
	{
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_diving', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

		GetACSWatcher().SetVampireMonsterSpawnProcess(true);
		
		GetACSWatcher().AddTimer('VampireMonsterDiveCancel', 3, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_VampireMonsterManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;
	var wing_temp_1, wing_temp_2, wing_temp_3																				: CEntityTemplate;
	var p_comp 																												: CComponent;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSVampireMonster().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSVampireMonster()
	&& ACSVampireMonster().IsAlive()
	&& ACSVampireMonster().IsInCombat())
	{
		if (ACS_vampire_monster_abilities()
		&& GetACSWatcher().ACS_Vampire_Monster_Flying_Process == false
		&& GetACSWatcher().ACS_Vampire_Monster_Spawn_Process == false )
		{
			ACS_refresh_vampire_monster_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
			movementAdjustorNPC.CancelAll();

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.Continuous(ticketNPC);

			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			ACSVampireMonster().StopEffect('swarm_light');
			ACSVampireMonster().PlayEffect('swarm_light');

			if ( targetDistance < 2 * 2 )
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_phase2_start', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));
				ACS_VampireMonsterFlyingStartDamage();

				ACSVampireMonster().StopEffect('shadowdash');
				ACSVampireMonster().PlayEffect('shadowdash');

				GetACSWatcher().RemoveTimer('VampireMonsterCancel');

				GetACSWatcher().AddTimer('VampireMonsterCancel', 1, false);
			}
			else if ( targetDistance >= 2 * 2 )
			{
				GetWitcherPlayer().SetFlyingBossCamera( true );

				GetACSWatcher().SetVampireMonsterFlyingProcess(true);

				p_comp = ACSVampireMonster().GetComponentByClassName( 'CAppearanceComponent' );

				wing_temp_1 = (CEntityTemplate)LoadResource(
				"dlc\bob\data\characters\models\monsters\detlaff_monster\detlaff_wings.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_1);

				wing_temp_2 = (CEntityTemplate)LoadResource(
				"dlc\dlc_acs\data\models\vampire_monster\wings_bloody_large.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_2);

				wing_temp_3 = (CEntityTemplate)LoadResource(
				"dlc\dlc_acs\data\models\vampire_monster\wings_large.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_3);

				animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_phase2_start', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

				ACS_VampireMonsterFlyingStartDamage();

				ACSVampireMonster().StopEffect('swarm_attack');
				ACSVampireMonster().PlayEffect('swarm_attack');
				
				GetACSWatcher().RemoveTimer('VampireMonsterFlyAttack');

				GetACSWatcher().AddTimer('VampireMonsterFlyAttack', 3, false);
			}
		}
	}
}

function ACS_VampireMonsterFlyingStartDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	ACSVampireMonster().PlayEffect('shadowdash');
	ACSVampireMonster().StopEffect('shadowdash');

	ACSVampireMonster().PlayEffect('smoke_explosion');
	ACSVampireMonster().StopEffect('smoke_explosion');

	ACSVampireMonster().PlayEffect('third_teleport_out');
	ACSVampireMonster().StopEffect('third_teleport_out');

	ACSVampireMonster().PlayEffect('third_dash');
	ACSVampireMonster().StopEffect('third_dash');

	victims.Clear();

	//victims = ACSVampireMonster().GetNPCsAndPlayersInCone(5, VecHeading(ACSVampireMonster().GetHeadingVector()), 360, 20, , FLAG_OnlyAliveActors );

	victims = ACSVampireMonster().GetNPCsAndPlayersInRange( 5, 5, , FLAG_OnlyAliveActors);

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterFlyAttackActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var rot																													: EulerAngles;
	var swarmattackent_1, swarmattackent_2, swarmattackent_3																: CEntity;
	var distAttack, distSwarmAttack																							: float;

	rot = GetWitcherPlayer().GetWorldRotation();

	rot.Yaw += 180;

	//ACSVampireMonster().PlayEffectSingle('shadowdash_body_blood');
	//ACSVampireMonster().StopEffect('shadowdash_body_blood');

	ACSVampireMonster().PlayEffectSingle('shadowdash');
	ACSVampireMonster().StopEffect('shadowdash');

	ACSVampireMonster().PlayEffectSingle('smoke_explosion');
	ACSVampireMonster().StopEffect('smoke_explosion');

	ACSVampireMonster().PlayEffectSingle('third_teleport_out');
	ACSVampireMonster().StopEffect('third_teleport_out');

	ACSVampireMonster().PlayEffectSingle('third_dash');
	ACSVampireMonster().StopEffect('third_dash');

	ACSVampireMonster().StopEffect('swarm_light');
	ACSVampireMonster().PlayEffect('swarm_light');

	ACSVampireMonster().StopEffect('swarm_gathers');
	ACSVampireMonster().PlayEffect('swarm_gathers');
	ACSVampireMonster().PlayEffect('swarm_gathers');
	ACSVampireMonster().PlayEffect('swarm_gathers');
	ACSVampireMonster().PlayEffect('swarm_gathers');
	ACSVampireMonster().PlayEffect('swarm_gathers');

	distAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 1.5;

	distSwarmAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 20;

	ACSVampireMonster().AddTag('ACS_Fly_Attack_Started');

	if (!ACSVampireMonster().HasTag('ACS_Fly_Attack_1'))
	{
		ACSVampireMonster().PlayEffectSingle('teleport');
		ACSVampireMonster().StopEffect('teleport');

		//ACSVampireMonster().TeleportWithRotation(TraceFloor(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 8), rot);

		GetACSWatcher().RemoveTimer('VampireMonsterTeleport');
		GetACSWatcher().AddTimer('VampireMonsterTeleport', 1.25, false);
	
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
		
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards(ticketNPC, GetWitcherPlayer() );

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_attack_split_a', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

		GetACSWatcher().RemoveTimer('VampireMonsterFlyAttackDamage');
		GetACSWatcher().AddTimer('VampireMonsterFlyAttackDamage', 3, false);

		GetACSWatcher().RemoveTimer('VampireMonsterDive');
		GetACSWatcher().AddTimer('VampireMonsterDive', 4, false);

		ACSVampireMonster().AddTag('ACS_Fly_Attack_1');
	}
	else if (ACSVampireMonster().HasTag('ACS_Fly_Attack_1'))
	{
		//ACSVampireMonster().StopEffect('swarm_attack');
		//ACSVampireMonster().PlayEffect('swarm_attack');

		ACSVampireMonster().PlayEffect('shadowdash_body_blood');
		ACSVampireMonster().StopEffect('shadowdash_body_blood');

		//ACSVampireMonster().TeleportWithRotation(TraceFloor(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 15), rot);
	
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
		
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards(ticketNPC, GetWitcherPlayer() );

		movementAdjustorNPC.SlideTowards(ticketNPC, GetWitcherPlayer(), distSwarmAttack, distSwarmAttack);

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_swarm_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

		swarmattackent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_1.CreateAttachment( ACSVampireMonster(), , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

		swarmattackent_1.PlayEffectSingle('swarm_attack');

		swarmattackent_1.DestroyAfter(7);

		swarmattackent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_2.CreateAttachment( ACSVampireMonster(), , Vector( 6, 0, 0 ), EulerAngles(0,45,0) );

		swarmattackent_2.PlayEffectSingle('swarm_attack');

		swarmattackent_2.DestroyAfter(7);

		swarmattackent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_3.CreateAttachment( ACSVampireMonster(), , Vector( -6, 0, 0 ), EulerAngles(0,-45,0) );

		swarmattackent_3.PlayEffectSingle('swarm_attack');

		swarmattackent_3.DestroyAfter(7);

		GetACSWatcher().RemoveTimer('VampireMonsterSwarmAttackDamage');
		GetACSWatcher().AddTimer('VampireMonsterSwarmAttackDamage', 4.5, false);

		GetACSWatcher().RemoveTimer('VampireMonsterDive');
		GetACSWatcher().AddTimer('VampireMonsterDive', 7, false);

		ACSVampireMonster().RemoveTag('ACS_Fly_Attack_1');
	}
}

function ACS_VampireMonsterTeleportActual()
{
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var distAttack, targetDistance																							: float;

	distAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 2 ;

	movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
	movementAdjustorNPC.CancelAll();

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );

	movementAdjustorNPC.AdjustLocationVertically(ticketNPC, true);

	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

	targetDistance = VecDistanceSquared2D( ACSVampireMonster().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (targetDistance <= 40 * 40)
	{
		movementAdjustorNPC.MaxLocationAdjustmentSpeed( ticketNPC, 12.5 );
	}
	else
	{
		movementAdjustorNPC.MaxLocationAdjustmentSpeed( ticketNPC, 50 );
	}
	
	movementAdjustorNPC.Continuous( ticketNPC );

	movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

	movementAdjustorNPC.SlideTowards( ticketNPC, GetWitcherPlayer(), distAttack, distAttack );
}

function ACS_VampireMonsterSwarmAttackDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSVampireMonster().GetNPCsAndPlayersInCone(30, VecHeading(ACSVampireMonster().GetHeadingVector()), 90, 20, , FLAG_OnlyAliveActors );

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						if (actortarget.UsesVitality())
						{
							actortarget.DrainVitality(actortarget.GetStat(BCS_Vitality) * 0.3);
						}
						else if (actortarget.UsesEssence())
						{
							actortarget.DrainEssence(actortarget.GetStat(BCS_Essence) * 0.3);
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Bleeding;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Bleeding";
						params.duration = 10;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterFlyAttackDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSVampireMonster().GetNPCsAndPlayersInCone(5, VecHeading(ACSVampireMonster().GetHeadingVector()), 90, 20, , FLAG_OnlyAliveActors );

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						if (actortarget.UsesVitality())
						{
							actortarget.DrainVitality(actortarget.GetStat(BCS_Vitality) * 0.3);
						}
						else if (actortarget.UsesEssence())
						{
							actortarget.DrainEssence(actortarget.GetStat(BCS_Essence) * 0.3);
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Bleeding;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Bleeding";
						params.duration = 10;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterDiveActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor;
	var rot																													: EulerAngles;
	var position 																											: Vector;
	var wing_temp_1, wing_temp_2, wing_temp_3																				: CEntityTemplate;
	var p_comp 																												: CComponent;

	GetWitcherPlayer().SetFlyingBossCamera( false );

	rot = GetWitcherPlayer().GetWorldRotation();

	rot.Yaw += 180;

	ACSVampireMonster().PlayEffect('shadowdash_body_blood');
	ACSVampireMonster().StopEffect('shadowdash_body_blood');

	ACSVampireMonster().StopEffect('shadowdash');
	ACSVampireMonster().PlayEffect('shadowdash');

	ACSVampireMonster().StopEffect('smoke_explosion');
	ACSVampireMonster().PlayEffect('smoke_explosion');

	ACSVampireMonster().StopEffect('third_teleport_out');
	ACSVampireMonster().PlayEffect('third_teleport_out');

	ACSVampireMonster().StopEffect('third_dash');
	ACSVampireMonster().PlayEffect('third_dash');

	ACSVampireMonster().StopEffect('swarm_attack');
	ACSVampireMonster().PlayEffect('swarm_attack');

	ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	position = TraceFloor(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 3);

	theGame.GetWorld().NavigationFindSafeSpot(position, 0.5f, 20.f, position);

	ACSVampireMonster().TeleportWithRotation(TraceFloor(position), rot);
	
	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	
	animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_diving', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0));

	p_comp = ACSVampireMonster().GetComponentByClassName( 'CAppearanceComponent' );
		
	wing_temp_1 = (CEntityTemplate)LoadResource(
	"dlc\bob\data\characters\models\monsters\detlaff_monster\detlaff_wings.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_1);

	wing_temp_2 = (CEntityTemplate)LoadResource(
	"dlc\dlc_acs\data\models\vampire_monster\wings_bloody_large.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_2);

	wing_temp_3 = (CEntityTemplate)LoadResource(
	"dlc\dlc_acs\data\models\vampire_monster\wings_large.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_3);

	ACSVampireMonster().RemoveTag('ACS_Fly_Attack_Started');

	GetACSWatcher().RemoveTimer('VampireMonsterDiveCancel');
	GetACSWatcher().AddTimer('VampireMonsterDiveCancel', 3, false);
}

function ACS_VampireMonsterDiveCancelActual()
{
	ACS_VampireMonsterCancelActual();

	GetACSWatcher().RemoveTimer('VampireMonsterSetFlyingProcessFalse');
	GetACSWatcher().AddTimer('VampireMonsterSetFlyingProcessFalse', 20, false);

	GetACSWatcher().RemoveTimer('VampireMonsterSetSpawnProcessFalse');
	GetACSWatcher().AddTimer('VampireMonsterSetSpawnProcessFalse', 3, false);
}

function ACS_VampireMonsterCancelActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 

	ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

	if (!ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_1');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_2');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_03', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_3');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_04', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_1');
		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_2');
		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_3');
	}
}

class CACSVampireMonster extends CNewNPC
{
	var numberOfHits 						: int;
	var destroyCalled						: bool;
	var percLife							: float;
	var chunkLife							: float;
	var healthBarPerc						: float;
	var lastHitTimestamp					: float;
	var testedHitTimestamp					: float;
	var l_temp								: float;
	
	editable var timeBetweenHits			: float;
	editable var timeBetweenFireDamage		: float;
	editable var baseStat					: EBaseCharacterStats;
	editable var requiredHits				: int;
	editable var effectOnTakeDamage			: name;
	editable var timeToDestroy				: float;

	default destroyCalled = false;
	default timeBetweenHits = 0.5f;
	default timeBetweenFireDamage = 1.0f;
	default baseStat = BCS_Vitality;
	default requiredHits = 30;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned( spawnData );
		SoundSwitch( "dettlaff_monster", "dettlaff_construct", 'Head' );
		requiredHits = 30;
	}
	
	function AddHit()
	{
		lastHitTimestamp = theGame.GetEngineTimeAsSeconds();
		numberOfHits+=1;
		RaiseEvent('AdditiveHit');
		SoundEvent("cmd_heavy_hit");
		percLife = (100/requiredHits)*0.01;	
		chunkLife = ( GetStatMax( BCS_Essence ) )* percLife;
		ForceSetStat( BCS_Essence, ( GetStat( BCS_Essence ) - chunkLife ));
		CheckHitsCounter();

		if (ACSVampireMonster().IsAlive() && !ACSVampireMonster().HasTag('acs_vampire_monster_not_alive_state'))
		{
			if (ACSVampireMonsterBossBar().UsesEssence())
			{
				ACSVampireMonsterBossBar().DrainEssence(ACSVampireMonsterBossBar().GetStatMax( BCS_Essence ) * 0.0125);
			}
			else if (ACSVampireMonsterBossBar().UsesVitality())
			{
				ACSVampireMonsterBossBar().DrainVitality(ACSVampireMonsterBossBar().GetStatMax( BCS_Vitality ) * 0.0125);
			}

			StopEffect('vampire_monster_on_hit');
			PlayEffectSingle('vampire_monster_on_hit');
			//SoundEvent("monster_dettlaff_monster_construct_death");
		}
	}
	
	function CheckHitsCounter()
	{
		if( numberOfHits >= requiredHits )
		{
			if( !destroyCalled )
			{
				DestroyEntity();
			}
		}
	}
	
	function DestroyEntity()
	{
		destroyCalled = true;
	}
	
	event OnTakeDamage( action : W3DamageAction )
	{	
		testedHitTimestamp = theGame.GetEngineTimeAsSeconds();
		if( action.attacker == GetWitcherPlayer() && action.DealsAnyDamage() && ( testedHitTimestamp > lastHitTimestamp + timeBetweenHits ) && !action.HasDealtFireDamage() )
		{
			AddHit();
		}
		else if( action.attacker == GetWitcherPlayer() && action.DealsAnyDamage() && ( testedHitTimestamp > lastHitTimestamp + timeBetweenFireDamage ) && action.HasDealtFireDamage())
		{
			AddHit();
			PlayEffectSingle('critical_burning');
			AddTimer('StopBurningFX', 2.0f, false );
		}
		
		if( destroyCalled )
		{
			numberOfHits = 0;
			destroyCalled = false;
			OnDeath(action);
		}
	}
	
	timer function StopBurningFX(dt : float, id : int)
	{
		StopEffect('critical_burning');
	}
}

function ACS_Blade_Of_The_Unseen() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen' );
	return entity;
}

function ACSVampireMonster() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Vampire_Monster' );
	return entity;
}

function ACSVampireMonsterBossBar() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Vampire_Monster_Boss_Bar' );
	return entity;
}

function ACS_Novigrad_Underground_Vampire() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'novigrad_underground_vampire' );
	return entity;
}

function ACS_Hubert_Rejk_Vampire() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'hubert_rejk_vampire' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_L_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen_L_Blade' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_R_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen_R_Blade' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_R_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Unseen_Blade_R_Anchor' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_L_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Unseen_Blade_L_Anchor' );
	return entity;
}

function ACS_BladeOfTheUnseenDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Blade_Of_The_Unseen().GetWorldPosition(), ACS_Blade_Of_The_Unseen().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_VampireMonsterDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );

	ent.PlayEffect('swarm_attack');
	ent.PlayEffect('swarm_attack');
	ent.PlayEffect('swarm_attack');
	ent.PlayEffect('swarm_attack');
	ent.PlayEffect('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_NovigradUndergroundVampireDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Novigrad_Underground_Vampire().GetWorldPosition(), ACS_Novigrad_Underground_Vampire().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_HubertRejkVampireDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Hubert_Rejk_Vampire().GetWorldPosition(), ACS_Hubert_Rejk_Vampire().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bat_Projectile_Manager()
{
	if (ACS_can_shoot_bat_projectile())
	{
		ACS_refresh_bat_projectile_cooldown();

		ACS_Bat_Projectile_Start();
	}	
}

function ACS_Bat_Projectile_Start()
{
	var vACS_Bat_Projectile 		: cACS_Bat_Projectile;
	var vW3ACSWatcher				: W3ACSWatcher;

	vACS_Bat_Projectile = new cACS_Bat_Projectile in vW3ACSWatcher;

	vACS_Bat_Projectile.ACS_Bat_Projectile_Start_Engage();
}

statemachine class cACS_Bat_Projectile
{
	function ACS_Bat_Projectile_Start_Engage()
	{
		this.PushState('ACS_Bat_Projectile_Start_Engage');
	}
}

state ACS_Bat_Projectile_Start_Engage in cACS_Bat_Projectile
{
	private var initpos											: Vector;
	private var rotation										: EulerAngles;
	private var bat_projectile 									: W3BatSwarmAttack;
	private var effect_entity, main_effect  					: CEntity;
	private var i         										: int;
	private var actor       									: CActor;
	private var actors    										: array<CActor>;
	private var targetPosition									: Vector;
	private var npc												: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Bat_Projectile_Start_Entry();
	}
	
	entry function ACS_Bat_Projectile_Start_Entry()
	{
		ACS_Bat_Projectile_Start_Latent();
	}
	
	latent function ACS_Bat_Projectile_Start_Latent()
	{
		initpos = ACS_Blade_Of_The_Unseen().GetWorldPosition();
				
		initpos.Z += 1.5;
				
		rotation = ACS_Blade_Of_The_Unseen().GetWorldRotation();
				
		targetPosition = GetWitcherPlayer().PredictWorldPosition( 0.7 );
		
		bat_projectile = (W3BatSwarmAttack)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\bat_swarm_attack_2.w2ent", true ), initpos, rotation );
		bat_projectile.Init(ACS_Blade_Of_The_Unseen());
		bat_projectile.PlayEffect( 'venom' );
		bat_projectile.ShootProjectileAtPosition( 0, 10, targetPosition, 500 );
		bat_projectile.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fire_Bear_Flames_Manager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSFireBear().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSFireBear() 
	&& ACSFireBear().IsAlive()
	&& !animatedComponentA.HasFrozenPose())
	{
		if (ACS_bear_can_flame_on()
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			if (ACS_FireBearBuffCheck()
			&& !ACSFireBear().IsEffectActive('flames', false)
			)
			{
				ACS_refresh_bear_flame_on_cooldown();

				GetACSWatcher().SetFireBearFlameOnProcess(true);

				if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
				{
					flameOnChance = 0.95;
				}
				else
				{
					flameOnChance = 0.5;
				}

				if( RandF() < flameOnChance )
				{
					ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_FlameOn_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_Fire_FlameOn_Rotate' );

					ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_FlameOn_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

					movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

					animatedComponentA.PlaySlotAnimationAsync ( 'bear_special_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');

					ACSFireBear().AddEffectDefault( EET_FireAura, ACSFireBear(), 'acs_fire_bear_fire_aura' );

					ACSFireBear().PlayEffectSingle('flames');

					GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');
					GetACSWatcher().AddTimer('ACSFireBearFlameOnDelay', 1.5, false);
				}
				else
				{
					GetACSWatcher().SetFireBearFlameOnProcess(false);
				}
			}
		}

		if (ACS_bear_can_throw_fireball()
		&& GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			ACS_refresh_bear_fireball_cooldown();

			GetACSWatcher().SetFireBearFireballProcess(true);

			if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
			{
				fireballChance = 0.25;

				fireballDistance = 5;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.25;

					fireballDistance -= 2;
				}
			}
			else
			{
				fireballChance = 0.125;

				fireballDistance = 7;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.125;

					fireballDistance -= 2;
				}
			}

			if( RandF() < fireballChance )
			{
				if ( ACS_FireBearBuffCheck()
				//&& ACSFireBear().IsInCombat()
				)
				{
					if ( targetDistance > fireballDistance * fireballDistance && targetDistance < 35 * 35 )
					{
						ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Fireball_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Fireball_Rotate' );

						ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Fireball_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

						movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

						//animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_bite', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

						//Fireball();

						if( RandF() < 0.5 )
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_swing_left_move', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');
							GetACSWatcher().AddTimer('ACSFireBearFireballLeftDelay', 0.75, false);
						}
						else
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_swing_right_move', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');
							GetACSWatcher().AddTimer('ACSFireBearFireballRightDelay', 0.75, false);
						}
					}
					else if (targetDistance > 35 * 35)
					{
						GetACSWatcher().SetFireBearFireballProcess(false);

						ACS_dropbearmeteorstart();
					}
					else
					{
						GetACSWatcher().SetFireBearFireballProcess(false);
					}
				}
			}
			else
			{
				GetACSWatcher().SetFireBearFireballProcess(false);
			}
		}

		if (ACS_bear_can_throw_fireline()
		&& GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			ACS_refresh_bear_fireline_cooldown();

			GetACSWatcher().SetFireBearFireLineProcess(true);

			if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
			{
				firelineChance = 0.5;

				firelineDistance = 5;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.25;

					firelineDistance -= 2;
				}
			}
			else
			{
				firelineChance = 0.25;

				firelineDistance = 7;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					firelineChance += 0.25;

					firelineDistance -= 2;
				}
			}

			if( RandF() < firelineChance )
			{
				if (ACS_FireBearBuffCheck()
				//&& ACSFireBear().IsInCombat()
				)
				{
					if ( targetDistance > firelineDistance * firelineDistance && targetDistance < 25 * 25 )
					{
						ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Fireball_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Fireball_Rotate' );

						ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Fireball_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.75 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

						movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

						animatedComponentA.PlaySlotAnimationAsync ( 'bear_taunt02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

						GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');
						GetACSWatcher().AddTimer('ACSFireBearFireLineDelay', 2, false);
					}
					else if ( targetDistance > 25 * 25 )
					{
						GetACSWatcher().SetFireBearFireLineProcess(false);

						ACS_dropbearmeteorstart();
					}
					else
					{
						GetACSWatcher().SetFireBearFireLineProcess(false);
					}
				}
			}
			else
			{
				GetACSWatcher().SetFireBearFireLineProcess(false);
			}
		}
	}	
}


statemachine class cACS_Fire_Bear_Projectiles
{
	function ACS_Fire_Bear_FireballLeft_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireballLeft_Start_Engage');
	}

	function ACS_Fire_Bear_FireballRight_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireballRight_Start_Engage');
	}

	function ACS_Fire_Bear_FireLines_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireLines_Start_Engage');
	}
}

state ACS_Fire_Bear_FireballLeft_Start_Engage in cACS_Fire_Bear_Projectiles
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireballLeft_Start_Entry();
	}
	
	entry function Fire_Bear_FireballLeft_Start_Entry()
	{
		FireballLeft();

		GetACSWatcher().SetFireBearFireballProcess(false);
	}

	latent function FireballLeft()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3FireballProjectile;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		collisionGroups.Clear();
		collisionGroups.PushBack('Terrain');
		collisionGroups.PushBack('Static');

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.7);

		//userPosition.Z += 1.5;

		userRotation = GetWitcherPlayer().GetWorldRotation();

		meteorPosition = ACSFireBear().GetBoneWorldPosition('l_frontpaw');

		meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffect('fire_fx');
		//meteorEntity.PlayEffect('explosion');
		//meteorEntity.decreasePlayerDmgBy = 0.75;
		meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, userPosition, 500, collisionGroups );
	}
}

state ACS_Fire_Bear_FireballRight_Start_Engage in cACS_Fire_Bear_Projectiles
{
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	private var targetDistance													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireballRight_Start_Entry();
	}
	
	entry function Fire_Bear_FireballRight_Start_Entry()
	{
		FireballRight();

		GetACSWatcher().SetFireBearFireballProcess(false);
	}

	latent function FireballRight()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3FireballProjectile;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		collisionGroups.Clear();
		collisionGroups.PushBack('Terrain');
		collisionGroups.PushBack('Static');

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.7);
		//userPosition.Z += 1.5;

		userRotation = GetWitcherPlayer().GetWorldRotation();

		meteorPosition = ACSFireBear().GetBoneWorldPosition('r_frontpaw');

		meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffect('fire_fx');
		//meteorEntity.PlayEffect('explosion');
		//meteorEntity.decreasePlayerDmgBy = 0.75;
		meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, userPosition, 500, collisionGroups );
	}
}

state ACS_Fire_Bear_FireLines_Start_Engage in cACS_Fire_Bear_Projectiles
{
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	private var targetDistance													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireLines_Start_Entry();
	}
	
	entry function Fire_Bear_FireLines_Start_Entry()
	{
		FireLinesLeft();

		FireLinesRight();

		GetACSWatcher().SetFireBearFireLineProcess(false);
	}

	latent function FireLinesLeft()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3ACSFireLine;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent"

		"dlc\dlc_acs\data\entities\projectiles\elemental_bear_fire_line.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.7);

		//userPosition.Z += 1.5;

		userRotation = GetWitcherPlayer().GetWorldRotation();

		meteorPosition = ACSFireBear().GetBoneWorldPosition('l_frontpaw') + (ACSFireBear().GetWorldForward() * 1.5) + (ACSFireBear().GetWorldRight() * -1.25);

		meteorPosition = TraceFloor(meteorPosition);

		meteorEntity = (W3ACSFireLine)theGame.CreateEntity(meteorEntityTemplate, TraceFloor(meteorPosition), userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffect('fire_line');
		//meteorEntity.PlayEffect('explosion');
		meteorEntity.ShootProjectileAtPosition( 0, 10, userPosition, 500 );
	}

	latent function FireLinesRight()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3ACSFireLine;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent"

		"dlc\dlc_acs\data\entities\projectiles\elemental_bear_fire_line.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.7);
		//userPosition.Z += 1.5;

		userRotation = GetWitcherPlayer().GetWorldRotation();

		meteorPosition = ACSFireBear().GetBoneWorldPosition('r_frontpaw') + (ACSFireBear().GetWorldForward() * 1.5) + (ACSFireBear().GetWorldRight() * 1.25);

		meteorPosition = TraceFloor(meteorPosition);

		meteorEntity = (W3ACSFireLine)theGame.CreateEntity(meteorEntityTemplate, TraceFloor(meteorPosition), userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffect('fire_line');
		//meteorEntity.PlayEffect('explosion');
		meteorEntity.ShootProjectileAtPosition( 0, 10, userPosition, 500 );
	}
}

function ACS_FireBearDespawnEffect()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	meteorEntity2Template = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_despawn_meteor.w2ent"
	
	, true );

	userPosition = ACSFireBear().GetWorldPosition();

	userPosition.Z += 50;

	userRotation = ACSFireBear().GetWorldRotation();

	meteorPosition = ACSFireBear().GetWorldPosition();

	meteorPosition.Z += 3;

	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity.DestroyAfter(10);

	meteorEntity2 = (W3BearDespawnMeteorProjectile)theGame.CreateEntity(meteorEntity2Template, meteorPosition, userRotation);
	meteorEntity2.Init(ACSFireBear());
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity2.DestroyAfter(6);
}

function ACS_FireBearSpawnEffect()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBearAltarEntity().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = ACSFireBearAltarEntity().GetWorldPosition();

	userPosition.Z += 50;

	userRotation = ACSFireBearAltarEntity().GetWorldRotation();

	meteorPosition = ACSFireBearAltarEntity().GetWorldPosition();

	meteorPosition.Z += 3;

	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBearAltarEntity());
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed , userPosition, 500, collisionGroups );

	meteorEntity.DestroyAfter(5);
}

function ACS_FireBearMeteorAscend()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	ACSFireBear().EnableCharacterCollisions(false); 

	ACSFireBear().EnableCollisions(false);

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	/*
	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );
	*/

	meteorEntity2Template = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_despawn_meteor.w2ent"
	
	, true );

	userPosition = GetWitcherPlayer().GetWorldPosition() + theCamera.GetCameraDirection() * 50;

	userPosition.Z += 200;

	userRotation = ACSFireBear().GetWorldRotation();

	meteorPosition = ACSFireBear().GetWorldPosition();

	meteorPosition.Z += 2;
	
	/*
	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('fire_fx');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.CreateAttachment(meteorEntity2);

	meteorEntity.DestroyAfter(6.95);
	*/

	meteorEntity2 = (W3BearDespawnMeteorProjectile)theGame.CreateEntity(meteorEntity2Template, meteorPosition, userRotation);
	meteorEntity2.Init(ACSFireBear());
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.PlayEffect('explosion_cutscene');
	meteorEntity2.PlayEffect('explosion');
	meteorEntity2.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity2.DestroyAfter(8.95);

	GetACSWatcher().AddTimer('DropBearMeteor', 9, false);
}

function ACSFireBear() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Bear' );
	return entity;
}

function ACS_FireBearBuffCheck() : bool
{
	if ( ACSFireBear().HasBuff(EET_HeavyKnockdown) 
	|| ACSFireBear().HasBuff( EET_Knockdown ) 
	|| ACSFireBear().HasBuff( EET_Ragdoll ) 
	|| ACSFireBear().HasBuff( EET_Stagger )
	|| ACSFireBear().HasBuff( EET_LongStagger )
	|| ACSFireBear().HasBuff( EET_Pull )
	|| ACSFireBear().HasBuff( EET_Immobilized )
	|| ACSFireBear().HasBuff( EET_Hypnotized )
	|| ACSFireBear().HasBuff( EET_WitchHypnotized )
	|| ACSFireBear().HasBuff( EET_Blindness )
	|| ACSFireBear().HasBuff( EET_WraithBlindness )
	|| ACSFireBear().HasBuff( EET_Frozen )
	|| ACSFireBear().HasBuff( EET_Paralyzed )
	|| ACSFireBear().HasBuff( EET_Confusion )
	|| ACSFireBear().HasBuff( EET_Tangled )
	|| ACSFireBear().HasBuff( EET_Tornado )
	|| ACSFireBear().HasBuff( EET_Swarm )
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function ACS_dropbearbossfight()
{	
	var ent        													   : CEntity;
	var rot                       						 				: EulerAngles;
    var pos																: Vector;

	GetACSFireSkyEnt().Destroy();

	rot = ACSFireBearAltarEntity().GetWorldRotation();

    pos = ACSFireBearAltarEntity().GetWorldPosition();

	pos.Z -= 100;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\fire_conjunction.w2ent"

		, true ), pos, rot );

	ent.AddTag('ACS_Fire_Sky_Ent');

	ent.PlayEffectSingle('conjunction');

	GetACSWatcher().AddTimer('DropBearSummon', 8.5, false);
}

function GetACSFireSkyEnt() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Fire_Sky_Ent' );
	return entity;
}

function ACS_dropbearsummon()
{
	var collisionGroups 						: array<name>;
	var firesky_ent, meteorEntityTemplate 		: CEntityTemplate;
	var userPosition 							: Vector;
	var meteorPosition 							: Vector;
	var userRotation 							: EulerAngles;
	var meteorEntity 							: W3BearSummonMeteorProjectile;

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	//userPosition = GetWitcherPlayer().PredictWorldPosition(0.7) + theCamera.GetCameraDirection() * 5;

	userPosition = TraceFloor(userPosition);

	userRotation = GetWitcherPlayer().GetWorldRotation();

	//meteorPosition = userPosition;
	meteorPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	meteorPosition.Z += 100;

	meteorEntity = (W3BearSummonMeteorProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(NULL);
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	//meteorEntity.decreasePlayerDmgBy = 0.25;
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, TraceFloor(userPosition), 500, collisionGroups );
}

function ACS_dropbearmeteorstart()
{
	var animatedComponentA						: CAnimatedComponent;
	var movementAdjustorNPC						: CMovementAdjustor;
	var ticketNPC 								: SMovementAdjustmentRequestTicket; 

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(
		GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
	)
	{
		GetACSWatcher().SetFireBearMeteorProcess(true);

		GetACSWatcher().RemoveTimer('DropBearMeteorStart');

		GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Meteor_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Meteor_Rotate' );

		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Meteor_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		animatedComponentA.PlaySlotAnimationAsync ( 'bear_counter_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

		GetACSWatcher().AddTimer('DropBearMeteorAscend', 1, false);
	}
}

function ACS_dropbearmeteor()
{
	var collisionGroups 						: array<name>;
	var firesky_ent, meteorEntityTemplate 		: CEntityTemplate;
	var userPosition 							: Vector;
	var meteorPosition 							: Vector;
	var userRotation 							: EulerAngles;
	var meteorEntity 							: W3BearSummonMeteorProjectile;

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	//userPosition = GetWitcherPlayer().PredictWorldPosition(0.7) + theCamera.GetCameraDirection() * 10;

	userPosition = TraceFloor(userPosition);

	userRotation = GetWitcherPlayer().GetWorldRotation();

	//meteorPosition = userPosition;
	meteorPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	meteorPosition.Z += 100;

	meteorEntity = (W3BearSummonMeteorProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	meteorEntity.PlayEffect('explosion_cutscene');
	meteorEntity.PlayEffect('explosion');
	//meteorEntity.decreasePlayerDmgBy = 0.25;
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, TraceFloor(userPosition), 500, collisionGroups );
}

function ACS_Fire_Bear_Altar_Static_Spawner()
{
	var vACS_Fire_Bear_Spawner : cACS_Fire_Bear_Spawner;
	vACS_Fire_Bear_Spawner = new cACS_Fire_Bear_Spawner in theGame;

	ACSFireBearAltar().Destroy();

	ACSFireBearAltarEntity().Destroy();

	vACS_Fire_Bear_Spawner.ACS_Fire_Bear_Static_Spawner_Engage();
}

statemachine class cACS_Fire_Bear_Spawner
{
    function ACS_Fire_Bear_Static_Spawner_Engage()
	{
		this.PushState('ACS_Fire_Bear_Static_Spawner_Engage');
	}
}

state ACS_Fire_Bear_Static_Spawner_Engage in cACS_Fire_Bear_Spawner
{
	var temp, temp2														: CEntityTemplate;
	var ent, ent2														: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot										: EulerAngles;
	var comp 															: CComponent;
		

	event OnEnterState(prevStateName : name)
	{
		Spawn_Altar_Entry();
	}
	
	entry function Spawn_Altar_Entry()
	{	
		Spawn_Altar_Latent();
	}

	latent function Spawn_Altar_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\chaos_flame_altar_mesh.w2ent"
		
		, true );

		temp2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\chaos_flame_altar_entity.w2ent"
		
		, true );

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			spawnPos = Vector(-203.508453, 80.339691, 10.792603, 1);

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );

			ent2 = theGame.CreateEntity( temp2, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			spawnPos = Vector(1107.765381, -253.113007, 0.957805, 1);

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );

			ent2 = theGame.CreateEntity( temp2, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			spawnPos = Vector(-201.472031, 186.004318, 5.699091, 1);

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );

			ent2 = theGame.CreateEntity( temp2, TraceFloor(spawnPos), GetWitcherPlayer().GetWorldRotation() );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		comp = ent.GetComponentByClassName('CGameplayLightComponent');

		((CGameplayLightComponent)comp).SetInteractive(false);

		ent.PlayEffect('fire_old');

		ent.PlayEffect('fire');

		ent.AddTag('ACS_Fire_Bear_Altar');


		animcomp = (CAnimatedComponent)ent2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent2.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		animcomp.FreezePose();

		((CNewNPC)ent2).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent2).SetAttitude(GetWitcherPlayer(), AIA_Neutral);
		((CActor)ent2).SetAnimationSpeedMultiplier(0);

		((CNewNPC)ent2).EnableCharacterCollisions(false);
		((CNewNPC)ent2).EnableCollisions(false);

		((CActor)ent2).AddBuffImmunity_AllNegative('ACS_Altar_Entity', true);

		((CActor)ent2).AddBuffImmunity_AllCritical('ACS_Altar_Entity', true);

		((CActor)ent2).SetUnpushableTarget(GetWitcherPlayer());

		((CActor)ent2).SetVisibility( false );

		ent2.AddTag('ACS_Fire_Bear_Altar_Entity');

		ent2.AddTag('ACS_Big_Boi');

		//ent2.CreateAttachment( ent, , Vector( -0.25, -0.5, -0.75 ), EulerAngles(0,0,0) );
	}
}

function ACSFireBearAltarEntity() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Bear_Altar_Entity' );
	return entity;
}

function ACSFireBearAltar() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Fire_Bear_Altar' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_KnightmareEternumManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSKnightmareEternum()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSKnightmareEternum().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSKnightmareEternum().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive()
	&& ACS_KnightmareEternumBuffCheck())
	{
		if (ACS_knightmare_shout()
		//&& GetACSWatcher().ACS_Knightmare_Igni_Process == false
		)
		{
			ACS_refresh_knightmare_shout_cooldown();

			//GetACSWatcher().SetKnightmareShoutProcess(true);

			if ( targetDistance <= 5 * 5 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Knightmare_Eternum_Shout_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Knightmare_Eternum_Shout_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Knightmare_Eternum_Shout_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetACSKnightmareEternum().GetTarget() );

				GetACSKnightmareEternum().PlayEffect('olgierd_energy_blast');

				GetACSKnightmareEternum().PlayEffect('special_attack_fx');

				GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

				GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

				GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

				GetACSKnightmareEternum().SetParryEnabled(false);

				GetACSKnightmareEternum().SetGuarded(false);

				if( GetACSWatcher().ACS_Knightmare_Igni_Process == false )
				{
					GetACSWatcher().SetKnightmareIgniProcess(true);

					animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_shout', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					GetACSWatcher().AddTimer('KnightmareEternumShout', 1.75, false);

					//GetACSWatcher().AddTimer('ResetKnightmareEternumShoutProcess', 1.5, false);
				}
				else
				{
					GetACSWatcher().SetKnightmareIgniProcess(false);

					animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_with_shout_001', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					GetACSWatcher().AddTimer('KnightmareEternumIgni', 1, false);

					//GetACSWatcher().AddTimer('ResetKnightmareEternumIgniProcess',2, false);
				}
			}
			else
			{
				//GetACSWatcher().SetKnightmareShoutProcess(false);
			}
		}

		/*
		if (ACS_knightmare_igni()
		&& GetACSWatcher().ACS_Knightmare_Shout_Process == false
		)
		{
			ACS_refresh_knightmare_igni_cooldown();

			GetACSWatcher().SetKnightmareIgniProcess(true);

			if ( targetDistance <= 5 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Knightmare_Eternum_Igni_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Knightmare_Eternum_Igni_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Knightmare_Eternum_Igni_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_with_shout_001', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				GetACSWatcher().AddTimer('KnightmareEternumIgni', 1, false);

				GetACSWatcher().AddTimer('ResetKnightmareEternumIgniProcess', 1.5, false);
			}
			else
			{
				GetACSWatcher().SetKnightmareIgniProcess(false);
			}
		}
		*/
	}
}

function ACS_KnightmareEternumShoutActual()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var ent, ent_2																																								: CEntity;

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive())
	{
		//GetACSKnightmareEternum().PlayEffect('shout');
		//GetACSKnightmareEternum().StopEffect('shout');

		GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

		GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

		GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

		GetACSKnightmareEternum().SetParryEnabled(false);

		GetACSKnightmareEternum().SetGuarded(false);

		GetACSKnightmareEternum().StopEffect('olgierd_energy_blast');

		GetACSKnightmareEternum().StopEffect('special_attack_fx');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\knightmare_scream_attack.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');

		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');

		ent.DestroyAfter(0.75);


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent_2.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');

		//ent_2.PlayEffect('cone_ground');

		//ent_2.PlayEffect('cone_ground');

		//ent_2.PlayEffect('cone_ground');

		//ent_2.PlayEffect('cone_ground');

		//ent_2.PlayEffect('cone_ground');

		ent_2.DestroyAfter(5);


		actors.Clear();

		actors = GetACSKnightmareEternum().GetNPCsAndPlayersInCone(10, VecHeading(GetACSKnightmareEternum().GetHeadingVector()), 60, 50, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetACSKnightmareEternum(), actortarget, theGame, 'ACS_Knightmare_Eternum_Shout_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.15; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.15; 
				} 

				dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function ACS_KnightmareEternumIgniActual()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var ent																																								: CEntity;

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive())
	{
		GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

		GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

		GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

		GetACSKnightmareEternum().SetParryEnabled(false);

		GetACSKnightmareEternum().SetGuarded(false);

		GetACSKnightmareEternum().StopEffect('shout');

		GetACSKnightmareEternum().StopEffect('olgierd_energy_blast');

		GetACSKnightmareEternum().StopEffect('special_attack_fx');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_igni_mq1060.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 1, 1 ), EulerAngles(0,90,0) );

		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');

		ent.DestroyAfter(3);

		actors.Clear();

		actors = GetACSKnightmareEternum().GetNPCsAndPlayersInCone(10, VecHeading(GetACSKnightmareEternum().GetHeadingVector()), 90, 50, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetACSKnightmareEternum(), actortarget, theGame, 'ACS_Knightmare_Eternum_Igni_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.15; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.15; 
				} 

				dmg.AddEffectInfo( EET_Burning, 3 );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function ACS_KnightmareEternumBuffCheck() : bool
{
	if ( GetACSKnightmareEternum().HasBuff(EET_HeavyKnockdown) 
	|| GetACSKnightmareEternum().HasBuff( EET_Knockdown ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Ragdoll ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Stagger )
	|| GetACSKnightmareEternum().HasBuff( EET_LongStagger )
	|| GetACSKnightmareEternum().HasBuff( EET_Pull )
	|| GetACSKnightmareEternum().HasBuff( EET_Hypnotized )
	|| GetACSKnightmareEternum().HasBuff( EET_WitchHypnotized )
	|| GetACSKnightmareEternum().HasBuff( EET_Blindness )
	|| GetACSKnightmareEternum().HasBuff( EET_WraithBlindness )
	|| GetACSKnightmareEternum().HasBuff( EET_Frozen )
	|| GetACSKnightmareEternum().HasBuff( EET_Paralyzed )
	|| GetACSKnightmareEternum().HasBuff( EET_Confusion )
	|| GetACSKnightmareEternum().HasBuff( EET_Tangled )
	|| GetACSKnightmareEternum().HasBuff( EET_Tornado ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Swarm ) 
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function ACS_knightmaresummon()
{
	var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	var i, count																														: int;
	var playerPos, spawnPos																												: Vector;
	var randAngle, randRange																											: float;
	var meshcomp																														: CComponent;
	var animcomp 																														: CAnimatedComponent;
	var h 																																: float;
	var bone_vec, pos, attach_vec																										: Vector;
	var bone_rot, rot, attach_rot																										: EulerAngles;

	GetACSKnightmareEternum().Destroy();

	GetACSKnightmareSwordTrail().Destroy();

	GetACSKnightmareQuen().Destroy();

	GetACSKnightmareQuenHit().Destroy();

	GetACSKnightmareChestBlade4().Destroy();

	GetACSKnightmareChestBlade3().Destroy();

	GetACSKnightmareChestBlade2().Destroy();

	GetACSKnightmareChestBlade1().Destroy();

	temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
		
		, true );

	trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

	quen_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

	quen_hit_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

	anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

	playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 20;

	rot = GetWitcherPlayer().GetWorldRotation();

	rot.Yaw += 180;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		theGame.GetWorld().NavigationFindSafeSpot(playerPos, 0.5f, 20.f, playerPos);

		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), rot );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, playerPos + Vector( 0, 0, -20 ) );

		chestblade_1 = (CEntity)theGame.CreateEntity( trail_temp, playerPos + Vector( 0, 0, -20 ) );

		chestblade_2 = (CEntity)theGame.CreateEntity( trail_temp, playerPos + Vector( 0, 0, -20 ) );

		chestblade_3 = (CEntity)theGame.CreateEntity( trail_temp, playerPos + Vector( 0, 0, -20 ) );

		chestblade_4 = (CEntity)theGame.CreateEntity( trail_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_ent = (CEntity)theGame.CreateEntity( quen_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, playerPos + Vector( 0, 0, -20 ) );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		//((CNewNPC)ent).AddAbility('EtherealActive');

		ent.PlayEffect('smokeman');
		ent.PlayEffect('smokeman');
		ent.PlayEffect('smokeman');

		//ent.PlayEffect('demonic_possession');

		ent.PlayEffect('red_electricity_r_arm');
		ent.PlayEffect('red_electricity_r_arm');

		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');

		ent.SoundEvent("qu_sk_209_two_sirens_sings_loop");

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Knightmare_Eternum_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Knightmare_Eternum_Buff', true);

		ent.AddTag( 'ACS_Knighmare_Eternum' );

		sword_trail_1.CreateAttachment( ent, 'r_weapon');

		sword_trail_1.AddTag( 'ACS_knightmare_sword_trail' );

		sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_2');

		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_knightmare_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_knightmare_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');

		attach_rot.Roll = 45;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;

		attach_vec.X = -0.5;
		// - go down, + go up

		attach_vec.Y = 0.25;

		attach_vec.Z = -0.4;
		// - go left, + go right

		chestblade_1.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_1.AddTag('ACS_knightmare_chest_blade_1');

		attach_rot.Roll = 30;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.4;

		attach_vec.Y = 0.35;

		attach_vec.Z = -0.4;

		chestblade_2.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_2.AddTag('ACS_knightmare_chest_blade_2');

		attach_rot.Roll = 15;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.3;

		attach_vec.Y = 0.45;

		attach_vec.Z = -0.4;

		chestblade_3.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_3.AddTag('ACS_knightmare_chest_blade_3');

		attach_rot.Roll = -45;
		attach_rot.Pitch = -120;
		attach_rot.Yaw = 0;

		attach_vec.X = 0.85;
		// - go down, + go up

		attach_vec.Y = -0.75;

		attach_vec.Z = 0.5;
		// - go left, + go right

		chestblade_4.CreateAttachment( ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_4.AddTag('ACS_knightmare_chest_blade_4');
	}
}

function ACS_Knightmare_Static_Spawner()
{
	var vACS_Knightmare_Spawner: cACS_Knightmare_Spawner;
	vACS_Knightmare_Spawner = new cACS_Knightmare_Spawner in theGame;

	GetACSKnightmareEternum().Destroy();

	GetACSKnightmareSwordTrail().Destroy();

	GetACSKnightmareQuen().Destroy();

	GetACSKnightmareQuenHit().Destroy();

	GetACSKnightmareChestBlade4().Destroy();

	GetACSKnightmareChestBlade3().Destroy();

	GetACSKnightmareChestBlade2().Destroy();

	GetACSKnightmareChestBlade1().Destroy();

	vACS_Knightmare_Spawner.ACS_Knightmare_Static_Spawner_Engage();
}

statemachine class cACS_Knightmare_Spawner
{
    function ACS_Knightmare_Static_Spawner_Engage()
	{
		this.PushState('ACS_Knightmare_Static_Spawner_Engage');
	}
}

state ACS_Knightmare_Static_Spawner_Engage in cACS_Knightmare_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Knightmare_Entry();
	}
	
	entry function Spawn_Knightmare_Entry()
	{	
		Spawn_Knightmare_Latent();
	}

	latent function Spawn_Knightmare_Latent()
	{
		if ( !theSound.SoundIsBankLoaded("sq_sk_209.bnk") )
		{
			theSound.SoundLoadBank( "sq_sk_209.bnk", false );
		}

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
		
		, true );

		trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

		quen_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

		quen_hit_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			spawnPos = Vector(269.988220, -2141.231934, 63.465191, 1);

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos) );

			sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

			chestblade_1 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

			chestblade_2 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

			chestblade_3 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

			chestblade_4 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

			quen_ent = (CEntity)theGame.CreateEntity( quen_temp, spawnPos + Vector( 0, 0, -20 ) );

			quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, spawnPos + Vector( 0, 0, -20 ) );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		//((CNewNPC)ent).AddAbility('EtherealActive');

		ent.PlayEffect('smokeman');
		ent.PlayEffect('smokeman');
		ent.PlayEffect('smokeman');

		//ent.PlayEffect('demonic_possession');

		ent.PlayEffect('red_electricity_r_arm');
		ent.PlayEffect('red_electricity_r_arm');

		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');
		ent.PlayEffect('default_fx');

		ent.SoundEvent("qu_sk_209_two_sirens_sings_loop");

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Knightmare_Eternum_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Knightmare_Eternum_Buff', true);

		ent.AddTag( 'ACS_Knighmare_Eternum' );

		sword_trail_1.CreateAttachment( ent, 'r_weapon');

		sword_trail_1.AddTag( 'ACS_knightmare_sword_trail' );

		sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_2');

		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_knightmare_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_knightmare_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');

		attach_rot.Roll = 45;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;

		attach_vec.X = -0.5;
		// - go down, + go up

		attach_vec.Y = 0.25;

		attach_vec.Z = -0.4;
		// - go left, + go right

		chestblade_1.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_1.AddTag('ACS_knightmare_chest_blade_1');

		attach_rot.Roll = 30;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.4;

		attach_vec.Y = 0.35;

		attach_vec.Z = -0.4;

		chestblade_2.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_2.AddTag('ACS_knightmare_chest_blade_2');

		attach_rot.Roll = 15;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.3;

		attach_vec.Y = 0.45;

		attach_vec.Z = -0.4;

		chestblade_3.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_3.AddTag('ACS_knightmare_chest_blade_3');

		attach_rot.Roll = -45;
		attach_rot.Pitch = -120;
		attach_rot.Yaw = 0;

		attach_vec.X = 0.85;
		// - go down, + go up

		attach_vec.Y = -0.75;

		attach_vec.Z = 0.5;
		// - go left, + go right

		chestblade_4.CreateAttachment( ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_4.AddTag('ACS_knightmare_chest_blade_4');
	}
}

function GetACSKnightmareEternum() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Knighmare_Eternum' );
	return entity;
}

function GetACSKnightmareSwordTrail() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_sword_trail' );
	return entity;
}

function GetACSKnightmareQuen() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_quen' );
	return entity;
}

function GetACSKnightmareQuenHit() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_quen_hit' );
	return entity;
}

function GetACSKnightmareChestBlade1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_1' );
	return entity;
}

function GetACSKnightmareChestBlade2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_2' );
	return entity;
}

function GetACSKnightmareChestBlade3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_3' );
	return entity;
}

function GetACSKnightmareChestBlade4() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_4' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rat_Mage_Static_Spawner()
{
	var vACS_Rat_Mage_Spawner: cACS_Rat_Mage_Spawner;
	vACS_Rat_Mage_Spawner = new cACS_Rat_Mage_Spawner in theGame;

	vACS_Rat_Mage_Spawner.ACS_Rat_Mage_Static_Spawner_Engage();
}

statemachine class cACS_Rat_Mage_Spawner
{
	function ACS_Rat_Mage_Rat_Spawner_Engage()
	{
		this.PushState('ACS_Rat_Mage_Rat_Spawner_Engage');
	}

    function ACS_Rat_Mage_Static_Spawner_Engage()
	{
		this.PushState('ACS_Rat_Mage_Static_Spawner_Engage');
	}
}

state ACS_Rat_Mage_Static_Spawner_Engage in cACS_Rat_Mage_Spawner
{
	private var temp, quen_temp, quen_hit_temp									: CEntityTemplate;
	private var ent, quen_ent, quen_hit_ent										: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var playerRot, rot													: EulerAngles;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Rat_Mage_Entry();
	}
	
	entry function Spawn_Rat_Mage_Entry()
	{	
		Spawn_Rat_Mage_Latent();
	}

	latent function Spawn_Rat_Mage_Latent()
	{
		GetACSRatMage().Destroy();

		GetACSRatMageQuen().Destroy();

		GetACSRatMageQuenHit().Destroy();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			spawnPos = Vector(522.843079, -1120.510742, 4.593603, 1);




			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\mages\rat_mage.w2ent"
				
			, true );

			quen_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

			quen_hit_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos) );

			quen_ent = (CEntity)theGame.CreateEntity( quen_temp, spawnPos + Vector( 0, 0, -20 ) );

			quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, spawnPos + Vector( 0, 0, -20 ) );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffect('black_smoke');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('smoke');
		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Rat_Mage' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Rat_Mage', true);



		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_rat_mage_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_rat_mage_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');
	}
}

state ACS_Rat_Mage_Rat_Spawner_Engage in cACS_Rat_Mage_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var playerRot														: EulerAngles;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Rat_Mage_Rats_Entry();
	}
	
	entry function Spawn_Rat_Mage_Rats_Entry()
	{	
		Spawn_Rat_Mage_Rats_Latent();
	}

	latent function Spawn_Rat_Mage_Rats_Latent()
	{
		if (GetACSRatMage()
		&& GetACSRatMage().IsAlive())
		{	
			GetACSRatMage().SoundEvent("magic_olgierd_ethereal_death");

			temp = (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\mages\rat_mage_rats.w2ent"
				
			, true );

			playerPos = GetACSRatMage().GetWorldPosition();

			playerRot = GetACSRatMage().GetWorldRotation();

			//playerRot.Yaw += 180;
			
			count = RandRange(10,5);
				
			for( i = 0; i < count; i += 1 )
			{
				randRange = 2.5 + 2.5 * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
				spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
				spawnPos.Z = playerPos.Z;

				ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

				animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent.GetComponentByClassName('CMeshComponent');
				h = 1;
				animcomp.SetScale(Vector(h,h,h,1));
				meshcomp.SetScale(Vector(h,h,h,1));	

				((CNewNPC)ent).SetLevel(GetACSRatMage().GetLevel()/4);

				((CNewNPC)ent).SetAttitude(GetACSRatMage(), AIA_Friendly);

				((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
				
				((CActor)ent).SetAnimationSpeedMultiplier(1);

				ent.PlayEffect('demonic_possession');

				ent.AddTag( 'ACS_Rat_Mage_Rat' );
			}
		}
	}
}

function ACS_RatMageManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSRatMage()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSRatMage().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSRatMage().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (GetACSRatMage()
	&& GetACSRatMage().IsAlive()
	&& ACS_RatMageBuffCheck())
	{
		if (ACS_rat_mage_abilities()
		)
		{
			ACS_refresh_rat_mage_abilities_cooldown();

			if ( targetDistance >= 5 * 5 && targetDistance < 15 * 15 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Rat_Mage_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Rat_Mage_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Rat_Mage_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, thePlayer );

				if( !GetACSRatMage().HasTag('ACS_Summoned_Rats') )
				{
					GetACSRatMage().AddTag('ACS_Summoned_Rats');

					animatedComponentA.PlaySlotAnimationAsync ( 'man_mage_root_attack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageSummonRats', 1, false);
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'man_mage_fireball_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageProjectile', 1, false);

					GetACSRatMage().RemoveTag('ACS_Summoned_Rats');
				}
			}
		}
	}
}

function ACS_RatMageSummonRatsActual()
{
	var vACS_Rat_Mage_Spawner: cACS_Rat_Mage_Spawner;
	vACS_Rat_Mage_Spawner = new cACS_Rat_Mage_Spawner in theGame;

	vACS_Rat_Mage_Spawner.ACS_Rat_Mage_Rat_Spawner_Engage();
}

function ACS_RatMageProjectileActual()
{
	var proj_1								: W3ACSRedPlagueProjectile;
	var initpos, newpos, targetPosition		: Vector;

	if ( !theSound.SoundIsBankLoaded("mq_nml_1060.bnk") )
	{
		theSound.SoundLoadBank( "mq_nml_1060.bnk", false );
	}

	initpos = GetACSRatMage().GetWorldPosition();	
	initpos.Z += 0.5;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	proj_1 = (W3ACSRedPlagueProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\red_plague_proj.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(GetACSRatMage());

	proj_1.ShootProjectileAtPosition( 0, 5, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_RatMageBuffCheck() : bool
{
	if ( GetACSRatMage().HasBuff(EET_HeavyKnockdown) 
	|| GetACSRatMage().HasBuff( EET_Knockdown ) 
	|| GetACSRatMage().HasBuff( EET_Ragdoll ) 
	|| GetACSRatMage().HasBuff( EET_Stagger )
	|| GetACSRatMage().HasBuff( EET_LongStagger )
	|| GetACSRatMage().HasBuff( EET_Pull )
	|| GetACSRatMage().HasBuff( EET_Hypnotized )
	|| GetACSRatMage().HasBuff( EET_WitchHypnotized )
	|| GetACSRatMage().HasBuff( EET_Blindness )
	|| GetACSRatMage().HasBuff( EET_WraithBlindness )
	|| GetACSRatMage().HasBuff( EET_Frozen )
	|| GetACSRatMage().HasBuff( EET_Paralyzed )
	|| GetACSRatMage().HasBuff( EET_Confusion )
	|| GetACSRatMage().HasBuff( EET_Tangled )
	|| GetACSRatMage().HasBuff( EET_Tornado ) 
	|| GetACSRatMage().HasBuff( EET_Swarm ) 
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function ACS_spawnratmage()
{
	var temp, quen_temp, quen_hit_temp									: CEntityTemplate;
	var ent, quen_ent, quen_hit_ent										: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var playerRot														: EulerAngles;	

	GetACSRatMage().Destroy();

	GetACSRatMageQuen().Destroy();

	GetACSRatMageQuenHit().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\mages\rat_mage.w2ent"
		
	, true );

	quen_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

	quen_hit_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

	playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffect('black_smoke');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('smoke');
		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Rat_Mage' );






		quen_ent = (CEntity)theGame.CreateEntity( quen_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_rat_mage_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_rat_mage_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');
	}
}

function GetACSRatMage() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Rat_Mage' );
	return entity;
}

function GetACSRatMageQuen() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_rat_mage_quen' );
	return entity;
}

function GetACSRatMageQuenHit() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_rat_mage_quen_hit' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Mage_Static_Spawner()
{
	var vACS_Mage_Spawner: cACS_Mage_Spawner;
	vACS_Mage_Spawner = new cACS_Mage_Spawner in theGame;

	vACS_Mage_Spawner.ACS_Mage_Static_Spawner_Engage();
}

statemachine class cACS_Mage_Spawner
{
	function ACS_Mage_Static_Spawner_Engage()
	{
		this.PushState('ACS_Mage_Static_Spawner_Engage');
	}
}

state ACS_Mage_Static_Spawner_Engage in cACS_Mage_Spawner
{
	private var temp												: CEntityTemplate;
	private var ent													: CEntity;
	private var i, count											: int;
	private var playerPos, spawnPos									: Vector;
	private var randAngle, randRange								: float;
	private var meshcomp											: CComponent;
	private var animcomp 											: CAnimatedComponent;
	private var h 													: float;
	private var pos													: Vector;
	private var playerRot, rot										: EulerAngles;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Mage_Entry();
	}
	
	entry function Spawn_Mage_Entry()
	{	
		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			Spawn_Mage_Pos_1_Latent();

			Spawn_Mage_Pos_2_Latent();

			Spawn_Mage_Pos_3_Latent();

			Spawn_Mage_Pos_4_Latent();

			Spawn_Mage_Pos_5_Latent();

			Spawn_Mage_Pos_6_Latent();

			Spawn_Mage_Pos_7_Latent();
		}
	}

	latent function Spawn_Mage_Pos_1_Latent()
	{
		playerPos = Vector(-33.535828, 368.284454, 15.516759, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_2_Latent()
	{
		playerPos = Vector(-4.271485, 723.641541, 12.635901, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_3_Latent()
	{
		playerPos = Vector(-640.648071, 381.257263, 0.528113, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_4_Latent()
	{
		playerPos = Vector(-752.968201, 182.820084, 2.477805, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_5_Latent()
	{
		playerPos = Vector(-737.226868, -569.517212, 0.451547, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_6_Latent()
	{
		playerPos = Vector(-169.419769, -1120.828491, 9.378743, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}

	latent function Spawn_Mage_Pos_7_Latent()
	{
		playerPos = Vector(-463.316956, -895.156433, 3.258704, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(3,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );
		}
	}
}

function GetACSMageInCombatCheck()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Mage', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (
			actors[i].IsInCombat()
		)
		{
			if (!actors[i].HasTag('ACS_Mage_In_Combat'))
			{
				actors[i].AddTag('ACS_Mage_In_Combat');
			}
		}
	}
}

function GetACSMageIdleAction()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Mage', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (
			!actors[i].HasTag('ACS_Mage_In_Combat')
		)
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)actors[i]).GetComponentByClassName( 'CAnimatedComponent' );	
			
			animatedComponentA.PlaySlotAnimationAsync ( 'vanilla_sitting_on_ground_loop01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Cloak_Vamp_Static_Spawner()
{
	var vACS_Cloak_Vamp_Spawner: cACS_Cloak_Vamp_Spawner;
	vACS_Cloak_Vamp_Spawner = new cACS_Cloak_Vamp_Spawner in theGame;

	vACS_Cloak_Vamp_Spawner.ACS_Cloak_Vamp_Static_Spawner_Engage();
}

statemachine class cACS_Cloak_Vamp_Spawner
{
	function ACS_Cloak_Vamp_Static_Spawner_Engage()
	{
		this.PushState('ACS_Cloak_Vamp_Static_Spawner_Engage');
	}
}

state ACS_Cloak_Vamp_Static_Spawner_Engage in cACS_Cloak_Vamp_Spawner
{
	private var temp												: CEntityTemplate;
	private var ent													: CEntity;
	private var i, count											: int;
	private var playerPos, spawnPos									: Vector;
	private var randAngle, randRange								: float;
	private var meshcomp											: CComponent;
	private var animcomp 											: CAnimatedComponent;
	private var h 													: float;
	private var pos													: Vector;
	private var playerRot, rot										: EulerAngles;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Cloak_Vamp_Entry();
	}
	
	entry function Spawn_Cloak_Vamp_Entry()
	{	
		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			Spawn_Cloak_Vamp_Pos_1_Latent();

			Spawn_Cloak_Vamp_Pos_2_Latent();

			Spawn_Cloak_Vamp_Pos_3_Latent();

			Spawn_Cloak_Vamp_Pos_4_Latent();

			Spawn_Cloak_Vamp_Pos_5_Latent();

			Spawn_Cloak_Vamp_Pos_6_Latent();

			Spawn_Cloak_Vamp_Pos_7_Latent();
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_1_Latent()
	{
		playerPos = Vector(383.835297, -786.881592, 25.523346, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_2_Latent()
	{
		playerPos = Vector(1.683741, -745.764832, 3.888556, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_3_Latent()
	{
		playerPos = Vector(-463.699371, -612.664246, 24.718271, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_4_Latent()
	{
		playerPos = Vector(-1170.926758, -905.084045, 114.828140, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_5_Latent()
	{
		playerPos = Vector(-503.869019, -1256.736938, 84.032448, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_6_Latent()
	{
		playerPos = Vector(-598.496948, -1305.905640, 100.997940, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}

	latent function Spawn_Cloak_Vamp_Pos_7_Latent()
	{
		playerPos = Vector(-900.160461, -1051.603638, 107.347839, 1);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak.w2ent"
			
		, true );

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		count = RandRange(2,1);
	
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Cloak_Vamp' );
		}
	}
}

function GetACSCloakVampInCombatCheck()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cloak_Vamp', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		targetDistance = VecDistanceSquared2D( actors[i].GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if (
			actors[i].IsInCombat()
		)
		{
			if (!actors[i].HasTag('ACS_Cloak_Vamp_In_Combat'))
			{
				actors[i].AddTag('ACS_Cloak_Vamp_In_Combat');
			}
		}

		if (!actors[i].HasTag('ACS_Cloak_Vamp_In_Combat'))
		{
			((CActor)actors[i]).GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[i].GetWorldPosition()));

			if (targetDistance <= 15 * 15)
			{
				((CActor)actors[i]).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SheWhoKnows_Static_Spawner()
{
	var vACS_SheWhoKnows_Spawner: cACS_SheWhoKnows_Spawner;
	vACS_SheWhoKnows_Spawner = new cACS_SheWhoKnows_Spawner in theGame;

	ACSSheWhoKnows().Destroy();

	vACS_SheWhoKnows_Spawner.ACS_SheWhoKnows_Spawner_Engage();
}

statemachine class cACS_SheWhoKnows_Spawner
{
    function ACS_SheWhoKnows_Spawner_Engage()
	{
		this.PushState('ACS_SheWhoKnows_Spawner_Engage');
	}
}

state ACS_SheWhoKnows_Spawner_Engage in cACS_SheWhoKnows_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Mother_Entry();
	}
	
	entry function Spawn_Mother_Entry()
	{	
		Spawn_Mother_Latent();
	}

	latent function Spawn_Mother_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\the_mother.w2ent"
		
		, true );

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			spawnPos = Vector(1712.061768, -472.764587, 0.223357, 1);

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos) );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');

		ent.AddTag( 'ACS_She_Who_Knows' );

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_She_Who_Knows', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_She_Who_Knows', true);
	}
}

function ACS_SheWhoKnowsManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSSheWhoKnows().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSSheWhoKnows()
	&& ACSSheWhoKnows().IsAlive()
	&& ACSSheWhoKnows().IsInCombat())
	{
		ACSSheWhoKnows().DisableLookAt();

		if (ACS_she_who_knows_abilities()
		)
		{
			ACS_refresh_she_who_knows_abilities_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_She_Who_Knows_Abilities_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_She_Who_Knows_Abilities_Rotate' );

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_She_Who_Knows_Abilities_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			if ( targetDistance <= 5 * 5)
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'water_dodge_to_submerge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				ACSSheWhoKnows().StopEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffect('spawn_disappear');

				GetACSWatcher().RemoveTimer('SheWhoKnowsHide');
				GetACSWatcher().AddTimer('SheWhoKnowsHide', 0.5, false);

				GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');
				GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1.25, false);
			}
			else if ( targetDistance > 5 * 5 && targetDistance <= 20 * 20 )
			{
				if( GetACSWatcher().ACS_She_Who_Knows_Throw_Projectile_Process == false )
				{
					GetACSWatcher().SetSheWhoKnowsProjectileProcess(true);

					if(!ACSSheWhoKnows().HasTag('ACS_SheWhoKnowsVolleyContinuous'))
					{
						movementAdjustorNPC.Continuous(ticketNPC);

						animatedComponentA.PlaySlotAnimationAsync ( 'witch_hypno_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingleStop');

						GetACSWatcher().AddTimer('SheWhoKnowsProjectileSingle', 0.5, true);

						GetACSWatcher().AddTimer('SheWhoKnowsProjectileSingleStop', 4.5, false);

						ACSSheWhoKnows().AddTag('ACS_SheWhoKnowsVolleyContinuous');
					}
					else
					{
						ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnowsVolleyContinuous');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley1');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley2');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley3');

						if (!ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley')
						)
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'water_attack_throw_mud_faster', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 0.875, false,,,false);

							ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_1st_Volley');
						}
						else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley'))
						{
							if (RandF() < 0.5)
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'water_emerge_throw_mud_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley3', 1.125, false,,,false);
							}
							else
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'water_attack_throw_mud_faster', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley1', 0.875, false,,,false);

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);
							}

							ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_2nd_Volley');
						}
						else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley')) 
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'water_emerge_throw_mud_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley1', 0.875, false,,,false);

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley3', 1.125, false,,,false);

							ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_1st_Volley');
							ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_2nd_Volley');
						}
					}	
				}
				else
				{
					GetACSWatcher().SetSheWhoKnowsProjectileProcess(false);

					animatedComponentA.PlaySlotAnimationAsync ( 'water_submerge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					ACSSheWhoKnows().StopEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffect('spawn_disappear');

					GetACSWatcher().RemoveTimer('SheWhoKnowsHide');
					GetACSWatcher().AddTimer('SheWhoKnowsHide', 1.125, false);

					GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');
					GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1.25, false);
				}
			}
		}
	}
}

function ACS_SheWhoKnowsTeleportStartActual()
{
	((CActor)ACSSheWhoKnows()).SetVisibility( false );

	GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1, false);
}

function ACS_SheWhoKnowsHideActual()
{
	ACSSheWhoKnows().SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
	
	ACSSheWhoKnows().SetCanPlayHitAnim(false); 
	
	ACSSheWhoKnows().EnableCharacterCollisions(false);
	
	ACSSheWhoKnows().AddBuffImmunity_AllNegative('ACS_She_Who_Knows_Dodge', true); 
	
	ACSSheWhoKnows().SetVisibility(false);
}

function ACS_SheWhoKnowsShowActual()
{
	ACS_SheWhoKnowsTeleportDamage(); 
	
	ACSSheWhoKnows().SetImmortalityMode( AIM_None, AIC_Combat ); 
	
	ACSSheWhoKnows().SetCanPlayHitAnim(true); 
	
	ACSSheWhoKnows().EnableCharacterCollisions(true); 
	
	ACSSheWhoKnows().RemoveBuffImmunity_AllNegative('ACS_She_Who_Knows_Dodge'); 
	
	ACSSheWhoKnows().SetVisibility(true);
}

function ACS_SheWhoKnowsTeleportActual()
{
	var rot																													: EulerAngles;
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket;
	var dist																												: float;
	var spawnPos																											: Vector;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();

	rot = GetWitcherPlayer().GetWorldRotation();

	rot.Yaw += 180;

	spawnPos = TraceFloor(GetWitcherPlayer().PredictWorldPosition(0.7f));

	theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

	ACSSheWhoKnows().TeleportWithRotation(TraceFloor(spawnPos), rot);

	dist = ((((CMovingPhysicalAgentComponent)ACSSheWhoKnows().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) );

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_She_Who_Knows_Abilities_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_She_Who_Knows_Abilities_Rotate' );
	movementAdjustorNPC.CancelAll();

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_She_Who_Knows_Abilities_Rotate' );
	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 1 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );
	movementAdjustorNPC.AdjustLocationVertically( ticketNPC, true );
	movementAdjustorNPC.ScaleAnimationLocationVertically( ticketNPC, true );

	movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

	movementAdjustorNPC.SlideTowards( ticketNPC, GetWitcherPlayer(), dist, dist ); 

	if (!ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
		ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_1st_Sneak_Attack');
	}
	else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack'))
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
		ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_2nd_Sneak_Attack');
	}
	else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack')) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_03', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
		ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_1st_Sneak_Attack');
		ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_2nd_Sneak_Attack');
	}

	ACSSheWhoKnows().StopEffect('spawn_disappear');
	ACSSheWhoKnows().StopEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffect('death_dissapear');

	GetACSWatcher().RemoveTimer('SheWhoKnowsShow');
	GetACSWatcher().AddTimer('SheWhoKnowsShow', 1, false);
}

function ACS_SheWhoKnowsProjectileLaunchSingleStop()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 

	GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();
	movementAdjustorNPC.CancelAll();

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );	

	animatedComponentA.PlaySlotAnimationAsync ( 'witch_hypno_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
}

function ACS_SheWhoKnowsProjectileLaunchSingle()
{
	var proj_1								: PoisonProjectile;
	var initpos, newpos, targetPosition		: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos = ACSSheWhoKnows().GetWorldPosition();	
	initpos.Z += 6;

	newpos = initpos;
	newpos.Z += RandRangeF(2, -2);
	newpos.X += RandRangeF(5, -5);
	newpos.Y -= 2;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	proj_1 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), newpos );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffect('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_SheWhoKnowsProjectileLaunch()
{
	var proj_1, proj_2, proj_3, proj_4, proj_5	 																				: PoisonProjectile;
	var initpos, targetPosition, targetPosition_left, targetPosition_right, targetPosition_forward, targetPosition_back			: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos = ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldRight() * 1.5;	

	initpos.Z += 5;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	targetPosition_left = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldRight() * -2.5;
	targetPosition_left.Z += 0.5;

	targetPosition_right = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldRight() * 2.5;
	targetPosition_right.Z += 0.5;

	targetPosition_forward = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldForward() * 2.5;
	targetPosition_forward.Z += 0.5;

	targetPosition_back = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldForward() * -2.5;
	targetPosition_back.Z += 0.5;


	proj_1 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffect('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
	proj_1.DestroyAfter(10);


	proj_2 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_2.Init(ACSSheWhoKnows());

	//proj_2.PlayEffect('spit_travel');

	proj_2.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_left, 500 );
	proj_2.DestroyAfter(10);


	proj_3 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_3.Init(ACSSheWhoKnows());

	//proj_3.PlayEffect('spit_travel');

	proj_3.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_right, 500 );
	proj_3.DestroyAfter(10);


	proj_4 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_4.Init(ACSSheWhoKnows());

	//proj_4.PlayEffect('spit_travel');

	proj_4.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_forward, 500 );
	proj_4.DestroyAfter(10);


	proj_5 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_5.Init(ACSSheWhoKnows());

	//proj_5.PlayEffect('spit_travel');

	proj_5.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_back, 500 );
	proj_5.DestroyAfter(10);
}

function ACS_SheWhoKnowsProjectileLaunchArea()
{
	var proj_1, proj_2, proj_3, proj_4, proj_5	 																							: PoisonProjectile;
	var initpos_1, initpos_2, initpos_3, initpos_4, initpos_5, targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4		: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos_1 = TraceFloor(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * 2.5 + ACSSheWhoKnows().GetWorldRight() * 2.5);

	//initpos_1.Z -= 0.5;

	initpos_2 = TraceFloor(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * -2.5 + ACSSheWhoKnows().GetWorldRight() * 2.5);

	//initpos_2.Z -= 0.5;

	initpos_3 = TraceFloor(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * 2.5 + ACSSheWhoKnows().GetWorldRight() * -2.5);

	//initpos_3.Z -= 0.5;

	initpos_4 = TraceFloor(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * -2.5 + ACSSheWhoKnows().GetWorldRight() * -2.5);

	//initpos_4.Z -= 0.5;
			
	targetPosition_1 = initpos_1;
	targetPosition_1.Z += 10;
	targetPosition_1.X += 10;
	targetPosition_1.Y += 10;

	targetPosition_2 = initpos_2;
	targetPosition_2.Z += 10;
	targetPosition_2.X += 10;
	targetPosition_2.Y -= 10;

	targetPosition_3 = initpos_3;
	targetPosition_3.Z += 10;
	targetPosition_3.X -= 10;
	targetPosition_3.Y += 10;

	targetPosition_4 = initpos_4;
	targetPosition_4.Z += 10;
	targetPosition_4.X -= 10;
	targetPosition_4.Y -= 10;

	proj_1 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), TraceFloor(initpos_1) );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffect('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10, targetPosition_1, 500 );
	proj_1.DestroyAfter(10);


	proj_2 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), TraceFloor(initpos_2) );
					
	proj_2.Init(ACSSheWhoKnows());

	//proj_2.PlayEffect('spit_travel');

	proj_2.ShootProjectileAtPosition( 0, 10, targetPosition_2, 500 );
	proj_2.DestroyAfter(10);


	proj_3 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), TraceFloor(initpos_3) );
					
	proj_3.Init(ACSSheWhoKnows());

	//proj_3.PlayEffect('spit_travel');

	proj_3.ShootProjectileAtPosition( 0, 10, targetPosition_3, 500 );
	proj_3.DestroyAfter(10);


	proj_4 = (PoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), TraceFloor(initpos_4) );
					
	proj_4.Init(ACSSheWhoKnows());

	//proj_4.PlayEffect('spit_travel');

	proj_4.ShootProjectileAtPosition( 0, 10, targetPosition_4, 500 );
	proj_4.DestroyAfter(10);
}

function ACS_SheWhoKnowsTeleportDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSSheWhoKnows().GetNPCsAndPlayersInCone(5, VecHeading(ACSSheWhoKnows().GetHeadingVector()), 360, 20, , FLAG_OnlyAliveActors );

	if (ACSSheWhoKnows().IsAlive())
	{
		ACS_SheWhoKnowsProjectileLaunchArea();

		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSSheWhoKnows()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_She_Who_Knows_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_She_Who_Knows_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_She_Who_Knows_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSSheWhoKnows() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSSheWhoKnows();
						params.sourceName = "ACS_She_Who_Knows_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Poison;
						params.creator = ACSSheWhoKnows();
						params.sourceName = "ACS_She_Who_Knows_Poison";
						params.duration = 5;

						actortarget.AddEffectCustom( params );	
					}
				}
			}
		}
	}
}

function ACSSheWhoKnows() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_She_Who_Knows' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////

function ACS_BigLizard_Spawner()
{
	var vACS_BigLizard_Spawner: cACS_BigLizard_Spawner;
	vACS_BigLizard_Spawner = new cACS_BigLizard_Spawner in theGame;

	ACSBigLizard().Destroy();

	vACS_BigLizard_Spawner.ACS_BigLizard_Spawner_Engage();
}

function ACS_BigLizard_Static_Spawner()
{
	var vACS_BigLizard_Spawner: cACS_BigLizard_Spawner;
	vACS_BigLizard_Spawner = new cACS_BigLizard_Spawner in theGame;

	ACSBigLizard().Destroy();

	vACS_BigLizard_Spawner.ACS_BigLizard_Static_Spawner_Engage();
}

statemachine class cACS_BigLizard_Spawner
{
    function ACS_BigLizard_Spawner_Engage()
	{
		this.PushState('ACS_BigLizard_Spawner_Engage');
	}

	function ACS_BigLizard_Static_Spawner_Engage()
	{
		this.PushState('ACS_BigLizard_Static_Spawner_Engage');
	}
}

state ACS_BigLizard_Spawner_Engage in cACS_BigLizard_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Big_Lizard_Entry();
	}
	
	entry function Spawn_Big_Lizard_Entry()
	{	
		Spawn_Big_Lizard_Latent();
	}

	latent function Spawn_Big_Lizard_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\fire_oszluzg.w2ent"
		
		, true );

		spawnPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 50;

		rot = GetWitcherPlayer().GetWorldRotation();

		rot.Yaw += 180;

		theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

		ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(2,h,1.625,1));
		meshcomp.SetScale(Vector(2,h,1.625,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		//((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).GetInventory().RemoveItemByName('EP2 Silver sword 1R', -1);

		((CActor)ent).GetInventory().RemoveItemByName('mq7010_dracolizard_trophy', -1);

		ent.PlayEffect('flames');

		ent.PlayEffect('embers_red');

		ent.AddTag( 'ACS_Big_Lizard' );

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Burning, 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Big_Lizard', true);
	}
}

state ACS_BigLizard_Static_Spawner_Engage in cACS_BigLizard_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Static_Spawn_Big_Lizard_Entry();
	}
	
	entry function Static_Spawn_Big_Lizard_Entry()
	{	
		Static_Spawn_Big_Lizard_Latent();
	}

	latent function Static_Spawn_Big_Lizard_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\fire_oszluzg.w2ent"
		
		, true );

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			spawnPos = Vector(627.695984, -863.526184, 7.658407, 1);

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			spawnPos = Vector(149.465164, 67.219673, -0.071147, 1);

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			spawnPos = Vector(-597.852112, -669.305786, 1.309426, 1);

			rot = GetWitcherPlayer().GetWorldRotation();

			rot.Yaw += 180;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), rot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(2,h,1.625,1));
		meshcomp.SetScale(Vector(2,h,1.625,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		//((CNewNPC)ent).SetCanPlayHitAnim(false);

		ent.PlayEffect('flames');

		ent.PlayEffect('embers_red');

		ent.AddTag( 'ACS_Big_Lizard' );

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Burning, 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Big_Lizard', true);
	}
}

function ACSBigLizard() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Big_Lizard' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////

class ACSShieldSpawner extends CEntity
{
	var actor															: CActor;
	var shield_temp														: CEntityTemplate;
	var shield															: CEntity;
	var ents  															: array<CGameplayEntity>;
	var i																: int;
	var progres, targetDistance 										: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('ShieldCheckTimer', 0.0000000000001, true);
	}
	
	timer function ShieldCheckTimer ( dt : float, id : int)
	{ 
		shieldcheck();
	}

	timer function DropShield ( dt : float, id : int)
	{ 
		if(this.GetWorldPosition() != TraceFloor(this.GetWorldPosition()) )
		{
			this.Teleport( LerpV(this.GetWorldPosition(), TraceFloor(this.GetWorldPosition()), progres) );
			progres += 0.00075/theGame.GetTimeScale();
		
			if(progres >= 1)
			{
				RemoveTimer( 'DropShield' );
			}
		}
	}

	function shieldcheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 10, ,FLAG_ExcludePlayer, ,);
		
		for( i = 0; i < ents.Size(); i += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;

				if (actor.IsAlive()
				&& actor.HasTag('ACS_Swapped_To_Shield')
				&& !actor.HasTag('ACS_Shield_Attached'))
				{
					if (StrContains( actor.GetReadableName(), "novigrad" ) )
					{
						if( RandF() < 0.5 )
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\novigrad_shield_01.w2ent"
							
							, true );
						}
						else
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\novigrad_shield_02.w2ent"
							
							, true );
						}	
					}
					else if (StrContains( actor.GetReadableName(), "redania" ) 
					|| StrContains( actor.GetReadableName(), "witch_hunter" ) 
					|| StrContains( actor.GetReadableName(), "inq_" ) 
					)
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\redanian_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "nilfgaard" ) )
					{
						if( RandF() < 0.5 )
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\nilfgaard_shield_01.w2ent"
							
							, true );
						}
						else
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\nilfgaard_shield_02.w2ent"
							
							, true );
						}	
					}
					else if (StrContains( actor.GetReadableName(), "brokvar" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_brokvar_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "craite" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_craite_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "dimun" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_dimun_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "drummond" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_drummond_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "heymaey" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_heymaey_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "tuiseach" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_tuiseach_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "temeria" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\temeria_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "knight" ) )
					{
						if (StrContains( actor.GetReadableName(), "nilfgaard" ) )
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\nilfgaard_shield_01.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\nilfgaard_shield_02.w2ent"
								
								, true );
							}	
						}
						else
						{
							if( RandF() < 0.5 )
							{
								if( RandF() < 0.5 )
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_01_5_toussaint.w2ent"
									
									, true );
								}
								else
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_02_6_toussaint.w2ent"
									
									, true );
								}
							}
							else
							{
								if( RandF() < 0.5 )
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_03_7_dun_tynne.w2ent"
									
									, true );
								}
								else
								{
									if( RandF() < 0.5 )
									{
										shield_temp = (CEntityTemplate)LoadResource( 

										"dlc\bob\data\items\weapons\shields\toussaint_shield_01_6_flat_color.w2ent"
										
										, true );
									}
									else
									{
										if( RandF() < 0.5 )
										{
											shield_temp = (CEntityTemplate)LoadResource( 

											"dlc\bob\data\items\weapons\shields\toussaint_shield_02_7_flat_color.w2ent"
											
											, true );
										}
										else
										{
											shield_temp = (CEntityTemplate)LoadResource( 

											"dlc\bob\data\items\weapons\shields\toussaint_shield_03_6_flat_color.w2ent"
											
											, true );
										}
									}
								}
							}
						}
					}
					else if (StrContains( actor.GetReadableName(), "wildhunt" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\unique\imlerith_shield\imlerith_shield_intact.w2ent"
						
						, true );
					}
					else 
					{
						if( RandF() < 0.5 )
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\bandit_shield_01.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\bandit_shield_02.w2ent"
								
								, true );
							}	
						}
						else
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 
						
								"items\weapons\shields\bandit_shield_03.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 
					
								"items\weapons\shields\bandit_shield_04.w2ent"
								
								, true );
							}
						}
					}
					
					shield = (CEntity)theGame.CreateEntity( shield_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					//shield.CreateAttachment( actor, 'l_weapon', Vector(0,0,-0.5), EulerAngles(0,0,0) );

					shield.CreateAttachment( this, , Vector(0,0.0125,0), EulerAngles(0,0,0) );

					shield.PlayEffectSingle('aard_cone_hit');
					shield.PlayEffectSingle('igni_cone_hit');
					shield.PlayEffectSingle('heavy_block');
					shield.PlayEffectSingle('light_block');

					shield.DestroyAfter(300);

					actor.AddTag('ACS_Shield_Attached');
				}
				else if (
				( !actor.IsAlive() || ( !ACS_AttitudeCheck ( actor ) && targetDistance >= 30 * 30 ) )
				&& actor.HasTag('ACS_Shield_Attached')
				&& !actor.HasTag('ACS_Lost_Shield') )
				{
					actor.AddTag('ACS_Lost_Shield');

					actor.RemoveTag('ACS_Swapped_To_Shield');

					this.BreakAttachment();

					AddTimer( 'DropShield', 0.0001, true );

					this.DestroyAfter(3);

					RemoveTimer('ShieldCheckTimer');
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Human_Death_Controller
{
    function ACS_Human_Death_Controller_Engage()
	{
		this.PushState('ACS_Human_Death_Controller_Engage');
	}
}

state ACS_Human_Death_Controller_Engage in cACS_Human_Death_Controller
{
	var crawl_temp								: CEntityTemplate;
	var crawl_controller						: CEntity;
	var deathactors		    					: array<CActor>;
	var i										: int;
	var actor									: CActor;
	var npc										: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Human_Death_Controller_Entry();
	}
	
	entry function Human_Death_Controller_Entry()
	{	
		Human_Death_Controller_Latent();
	}

	latent function Human_Death_Controller_Latent()
	{
		deathactors.Clear();

		deathactors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile );

		if( deathactors.Size() > 0 )
		{
			for( i = 0; i < deathactors.Size(); i += 1 )
			{
				npc = (CNewNPC)deathactors[i];

				actor = deathactors[i];
				
				if(
				npc.IsHuman()
				&& !npc.HasTag('ACS_Rat_Mage')
				)
				{
					if (!npc.HasTag('ACS_Crawl_Controller_Attached'))
					{
						crawl_temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\other\human_death_crawl_controller.w2ent"
						
						, true );

						crawl_controller = (CEntity)theGame.CreateEntity( crawl_temp, npc.GetWorldPosition() + Vector( 0, 0, -20 ) );

						crawl_controller.CreateAttachment( npc, 'blood_point', Vector(0,0,0), EulerAngles(0,0,0) );

						npc.AddTag('ACS_Crawl_Controller_Attached');
					}
				}	
			}
		}
	}
}

class ACSHumanDeathCrawlController extends CEntity
{
	var actor															: CActor;
	var shield_temp														: CEntityTemplate;
	var shield															: CEntity;
	var ents  															: array<CGameplayEntity>;
	var i, j, k, l														: int;
	var dismembermentComp 												: CDismembermentComponent;
	var wounds															: array< name >;
	var usedWound														: name;
	var movementAdjustorNPCCrawl										: CMovementAdjustor;
	var ticketNPCCrawl													: SMovementAdjustmentRequestTicket;
	var animatedComponentA												: CAnimatedComponent;
	var soundComponentA													: CSoundEmitterComponent;
	var drawableComponents 												: array < CComponent >;
	var drawableComponent 												: CDrawableComponent;
	
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('AliveCheckTimer', 0.1, true);
	}
	
	timer function AliveCheckTimer ( dt : float, id : int)
	{ 
		AliveCheck();
	}

	timer function HumanDeathCrawlLoopTimer ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoop();
	}

	timer function HumanDeathCrawlLoopTimerStop ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoopStop();
	}

	timer function HumanDeathCrawlLoopTimerSelfDestruct ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoopSelfDestruct();
	}

	function AliveCheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 1, ,FLAG_ExcludePlayer, ,);

		//FindGameplayEntitiesInRange(ents, this, 0.01, 1, ,FLAG_ExcludePlayer );
		
		for( i = 0; i < ents.Size(); i += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[i];

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& !actor.HasTag('ACS_caretaker_shade') 
				&& actor.GetImmortalityMode() != AIM_Invulnerable
				&& actor.GetImmortalityMode() != AIM_Immortal
				&& !actor.HasTag('acs_was_dismembered')
				)
				{
					actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Death );

					animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

					movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

					GetACSWatcher().Fear_Stack();

					actor.StopEffect('demonic_possession');
					
					actor.DropItemFromSlot('r_weapon'); 

					if( RandF() < 0.25 ) 
					{
						actor.StopEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
						actor.PlayEffect('pee');
					}

					if( RandF() < 0.5 ) 
					{
						actor.StopEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
						actor.PlayEffect('puke');
					}

					actor.StopAllEffectsAfter(5);

					if( actor.HasTag('ACS_One_Hand_Swap_Stage_1') )
					{
						actor.RemoveTag('ACS_One_Hand_Swap_Stage_1');
					}

					if( actor.HasTag('ACS_One_Hand_Swap_Stage_2') )
					{
						actor.RemoveTag('ACS_One_Hand_Swap_Stage_2');
					}

					if( actor.HasTag('ACS_sword2h_npc') )
					{
						if( actor.HasTag('ACS_Swapped_To_Witcher') )
						{
							actor.RemoveTag('ACS_Swapped_To_Witcher');
						}

						if( actor.HasTag('ACS_Swapped_To_1h_Sword') )
						{
							actor.RemoveTag('ACS_Swapped_To_1h_Sword');
						}

						actor.RemoveTag('ACS_sword2h_npc');
					}
					else if( actor.HasTag('ACS_sword1h_npc') )
					{
						if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
						{
							actor.RemoveTag('ACS_Swapped_To_2h_Sword');
						}

						if( actor.HasTag('ACS_Swapped_To_Witcher') )
						{
							actor.RemoveTag('ACS_Swapped_To_Witcher');
						}

						actor.RemoveTag('ACS_sword1h_npc');
					}
					else if( actor.HasTag('ACS_shield_npc') )
					{
						if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
						{
							actor.RemoveTag('ACS_Swapped_To_2h_Sword');
						}

						if( actor.HasTag('ACS_Swapped_To_Witcher') )
						{
							actor.RemoveTag('ACS_Swapped_To_Witcher');
						}

						actor.RemoveTag('ACS_shield_npc');
					}
					else if( actor.HasTag('ACS_witcher_npc') )
					{
						if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
						{
							actor.RemoveTag('ACS_Swapped_To_2h_Sword');
						}

						if( actor.HasTag('ACS_Swapped_To_1h_Sword') )
						{
							actor.RemoveTag('ACS_Swapped_To_1h_Sword');
						}

						actor.RemoveTag('ACS_witcher_npc');
					}

					if (GetWitcherPlayer().HasTag('vampire_claws_equipped')
					|| GetWitcherPlayer().HasTag('aard_sword_equipped')
					|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
					|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
					else
					{
						if (actor.HasTag('ACS_Final_Fear_Stack'))
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f ) );
						}
					}

					AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
					AddTimer('HumanDeathCrawlLoopTimerStop', RandRangeF(30, 15), false);
					AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 31, false);

					RemoveTimer('AliveCheckTimer');

					actor.AddTag('acs_was_dismembered');

					actor.SoundEvent( "grunt_vo_death_stop", 'head' );
				}
			}
		}
	}

	function HumanDeathCrawlLoop()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( j = 0; j < ents.Size(); j += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[j];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				soundComponentA = (CSoundEmitterComponent)actor.GetComponentByClassName( 'CSoundEmitterComponent' );

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor != GetWitcherPlayer().GetFinisherVictim()
				&& !actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffect('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffect('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffect('blood_spill');  

					dismembermentComp = (CDismembermentComponent)(actor.GetComponentByClassName( 'CDismembermentComponent' ));

					if( StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "cut_head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "doppler_trophy_head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "none" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "torso" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "explode" ) 
					|| dismembermentComp.GetMainCurveName(dismembermentComp.GetVisibleWoundName()) == 'head'
					)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
						
						RemoveTimer('HumanDeathCrawlLoopTimerStop');
						RemoveTimer('HumanDeathCrawlLoopTimerSelfDestruct');
						AddTimer('HumanDeathCrawlLoopTimerStop', 1, false);
						AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 2, false);

						RemoveTimer('HumanDeathCrawlLoopTimer');
						return;
					}

					ticketNPCCrawl = movementAdjustorNPCCrawl.GetRequest( 'ACS_NPC_Crawl_Rotate');
					movementAdjustorNPCCrawl.CancelByName( 'ACS_NPC_Crawl_Rotate' );
					movementAdjustorNPCCrawl.CancelAll();

					ticketNPCCrawl = movementAdjustorNPCCrawl.CreateNewRequest( 'ACS_NPC_Crawl_Rotate' );
					movementAdjustorNPCCrawl.AdjustmentDuration( ticketNPCCrawl, RandRangeF(4, 2) );
					movementAdjustorNPCCrawl.MaxRotationAdjustmentSpeed( ticketNPCCrawl, 500000 );
					
					//actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Death );
					
					if (RandF() < 0.5)
					{
						movementAdjustorNPCCrawl.RotateTo( ticketNPCCrawl, VecHeading( actor.GetHeadingVector() +  actor.GetWorldRight() * 10 ) );

						actor.PlayMimicAnimationAsync('geralt_neutral_gesture_death_longer_face');
					}
					else
					{
						movementAdjustorNPCCrawl.RotateTo( ticketNPCCrawl, VecHeading( actor.GetHeadingVector() +  actor.GetWorldRight() * -10 ) );

						actor.PlayMimicAnimationAsync('geralt_neutral_gesture_death_shorter_face');
					}

					if (RandF() < 0.75)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
				}
			}
		}
	}

	function HumanDeathCrawlLoopStop()
	{
		var dismembermentComp 						: CDismembermentComponent;
		var wounds									: array< name >;
		var usedWound								: name;
		var movementAdjustorNPCCrawl				: CMovementAdjustor;
		var ticketNPCCrawl							: SMovementAdjustmentRequestTicket;

		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( k = 0; k < ents.Size(); k += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[k];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor.HasTag('acs_was_dismembered')
				&& !actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffect('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffect('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffect('blood_spill'); 

					movementAdjustorNPCCrawl.CancelAll();

					if (RandF() < 0.5)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

						animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_killed_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

						animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
					}

					actor.AddTag('ACS_Crawling_Disable');

					actor.StopAllEffectsAfter(1);
				}
			}
		}
	}

	function HumanDeathCrawlLoopSelfDestruct()
	{
		var dismembermentComp 						: CDismembermentComponent;
		var wounds									: array< name >;
		var usedWound								: name;
		var movementAdjustorNPCCrawl				: CMovementAdjustor;
		var ticketNPCCrawl							: SMovementAdjustmentRequestTicket;

		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 5, ,FLAG_ExcludePlayer, ,);
		
		for( l = 0; l < ents.Size(); l += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[l];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor.HasTag('acs_was_dismembered')
				&& actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.TurnOnRagdoll();

					this.DestroyAfter(10);
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Ciri_Special_Attack extends CEntity
{
    function ACS_Ciri_Special_Attack_Engage()
	{
		GotoState('ACS_Ciri_Special_Attack_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Attack_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Attack_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Front_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Front_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Back_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Back_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Left_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Left_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Right_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Right_Engage', true, true);
	}
}

function ACSCiriSpecialSphere() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Ciri_Special_Attack_Sphere' );
	return entity;
}

state ACS_Ciri_Special_Attack_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp, specialAttackEffectTemplate									: CEntityTemplate;
	private var dummy_ent, specialAttackSphereEnt										: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;
	private var specialAttackSphere 													: CMeshComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Special_Attack_Entry();
	}
	
	entry function Ciri_Special_Attack_Entry()
	{
		ACS_Ciri_Special_Attack_Sphere_Destroy();

		specialAttackEffectTemplate = (CEntityTemplate)LoadResourceAsync('special_attack_ciri');

		specialAttackSphereEnt = theGame.CreateEntity( specialAttackEffectTemplate, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		specialAttackSphereEnt.AddTag('ACS_Ciri_Special_Attack_Sphere');

		GetACSWatcher().ResetCiriSpecialSphereSize();

		GetACSWatcher().RemoveTimer('GrowCiriSpecialSphereTimer');

		GetACSWatcher().AddTimer('GrowCiriSpecialSphereTimer', 0.001, true);

		actorVictims.Clear();
		
		actorVictims = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile );

		if( actorVictims.Size() > 0 )
		{
			GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

			last_enemy = false;

			GetWitcherPlayer().EnableCharacterCollisions(false);
			GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
			GetWitcherPlayer().SetCanPlayHitAnim(false);
			GetWitcherPlayer().AddBuffImmunity_AllNegative('acs_ciri_special', true);

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

			GetWitcherPlayer().SetAnimationSpeedMultiplier( 4 );

			GetWitcherPlayer().BlockAction( EIAB_Crossbow, 			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_CallHorse,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Signs, 				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_DrawWeapon, 		'acs_ciri_special_attack'); 
			GetWitcherPlayer().BlockAction( EIAB_FastTravel, 		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Fists, 				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_InteractionAction, 	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_UsableItem,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_ThrowBomb,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SwordAttack,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Jump,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_LightAttacks,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_HeavyAttacks,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SpecialAttackLight,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SpecialAttackHeavy,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Dodge,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Roll,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Parry,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Interactions, 		'acs_ciri_special_attack');

			GetWitcherPlayer().AddTag('ACS_In_Ciri_Special_Attack');

			theGame.SetTimeScale( 0.25, theGame.GetTimescaleSource( ETS_ThrowingAim ), theGame.GetTimescalePriority( ETS_ThrowingAim ), false, true );

			for( j = 0; j < actorVictims.Size(); j += 1 )
			{
				if ( j == actorVictims.Size() - 1 )
				{
					last_enemy = true;
				}

				if (actorVictims[j] && actorVictims[j].IsAlive())
				{
					//GetWitcherPlayer().StopEffect('disappear_ciri');
					//GetWitcherPlayer().PlayEffectSingle('disappear_ciri');

					GetWitcherPlayer().StopEffect('dodge_ciri_trail');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri_trail');

					GetWitcherPlayer().DestroyEffect('teleport_glow_ciri');
					GetWitcherPlayer().PlayEffectSingle('teleport_glow_ciri');

					movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

					dist = (((CMovingPhysicalAgentComponent)actorVictims[j].GetMovingAgentComponent()).GetCapsuleRadius() 
					+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 2;

					ticket = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack');
					movementAdjustor.CancelByName( 'ACS_Ciri_Speical_Attack' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Ciri_Speical_Attack' );
					movementAdjustor.AdjustmentDuration( ticket, 0.125 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

					victimPos = actorVictims[j].PredictWorldPosition(0.7) + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 2;

					if( !theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 0.3 , newVictimPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 4 , newVictimPos );
						victimPos = newVictimPos;
					}

					movementAdjustor.RotateTowards(ticket, actorVictims[j]);

					if ( ((CNewNPC)actorVictims[j]).IsShielded( NULL )
					|| actorVictims[j].IsGuarded()
					)
					{
						movementAdjustor.SlideTo( ticket, TraceFloor(victimPos) );
					}
					else
					{
						movementAdjustor.SlideTowards( ticket, actorVictims[j], dist, dist );
					}

					attack_anim_names.Clear();

					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_lp_50ms');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_rp_50ms');
					attack_anim_names.PushBack('man_geralt_sword_attack_strong_far_forward_1_rp_80ms');
					attack_anim_names.PushBack('man_geralt_sword_attack_strong_far_forward_1_lp_80ms');

					GetACSWatcher().PlayerPlayAnimation( attack_anim_names[RandRange(attack_anim_names.Size())] );

					GetWitcherPlayer().ClearAnimationSpeedMultipliers();

					GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

					GetWitcherPlayer().SetAnimationSpeedMultiplier( 4 );

					GetWitcherPlayer().EnableCharacterCollisions(false);
					GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
					GetWitcherPlayer().SetCanPlayHitAnim(false);
					GetWitcherPlayer().AddBuffImmunity_AllNegative('acs_ciri_special', true);

					spawn_ciri_phantom(actorVictims[j]);

					Sleep( 0.25 );
				}
			}

			if ( last_enemy == true ) 
			{
				GetWitcherPlayer().DestroyEffect('teleport_glow_ciri');

				GetWitcherPlayer().StopEffect('dodge_ciri_trail');

				GetWitcherPlayer().RemoveTag('ACS_In_Ciri_Special_Attack');

				theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_ThrowingAim) );

				if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}

				GetWitcherPlayer().EnableCharacterCollisions(true);
				GetWitcherPlayer().SetImmortalityMode( AIM_None, AIC_Combat );
				GetWitcherPlayer().SetCanPlayHitAnim(true);
				GetWitcherPlayer().RemoveBuffImmunity_AllNegative('acs_ciri_special');

				GetWitcherPlayer().UnblockAction( EIAB_Crossbow, 			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_CallHorse,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Signs, 				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_DrawWeapon, 			'acs_ciri_special_attack'); 
				GetWitcherPlayer().UnblockAction( EIAB_FastTravel, 			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Fists, 				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_InteractionAction, 	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_UsableItem,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_ThrowBomb,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SwordAttack,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Jump,					'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_LightAttacks,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_HeavyAttacks,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SpecialAttackLight,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SpecialAttackHeavy,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Dodge,				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Roll,					'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Parry,				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_MeditationWaiting,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_OpenMeditation,		'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_RadialMenu,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Interactions, 		'acs_ciri_special_attack');

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetWitcherPlayer().PlayEffectSingle('teleport_glow_ciri');

				movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack');
				movementAdjustor.CancelByName( 'ACS_Ciri_Speical_Attack' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Ciri_Speical_Attack' );
				movementAdjustor.AdjustmentDuration( ticket, 0.125 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.SlideTo( ticket, TraceFloor(specialAttackSphereEnt.GetWorldPosition()) );

				if (GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetTarget())
				{
					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer().GetTarget() );
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}

				GetACSWatcher().PlayerPlayAnimation ( 'man_mage_teleport_in_ACS');

				specialAttackSphereEnt.PlayEffect('fade');
				specialAttackSphereEnt.DestroyAfter(1);
			}
		}
		else
		{
			attack_anim_names.Clear();

			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_lp_50ms');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_rp_50ms');
			attack_anim_names.PushBack('man_geralt_sword_attack_strong_far_forward_1_rp_80ms');
			attack_anim_names.PushBack('man_geralt_sword_attack_strong_far_forward_1_lp_80ms');

			GetACSWatcher().PlayerPlayAnimation( attack_anim_names[RandRange(attack_anim_names.Size())] );

			GetACSWatcher().RemoveTimer('GrowCiriSpecialSphereTimer');

			GetACSWatcher().ResetCiriSpecialSphereSize();

			specialAttackSphereEnt.PlayEffect('fade');
			specialAttackSphereEnt.DestroyAfter(1);
		}
	}

	latent function spawn_ciri_phantom( victim : CActor )
	{
		actorPos = victim.PredictWorldPosition(0.7);

		actorRot = victim.GetWorldRotation();

		actorRot.Yaw += RandRange(180,0);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_count = RandRange(3,1);

		for( k = 0; k < dummy_count; k += 1 )
		{
			randRange = 1.125 + 1.125 * RandF();
			randAngle = 1.125 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;
			
			dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(spawnPos), actorRot );
			animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
			((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
			((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

			((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

			dummy_ent.PlayEffectSingle('dodge');

			dummy_ent.PlayEffectSingle('fury');

			dummy_ent.PlayEffectSingle('fury_403');
		
			dummy_ent.PlayEffectSingle('teleport_glow');

			dummy_ent.PlayEffectSingle('appear');
			
			dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

			movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

			ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
			movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
			movementAdjustorDummy.CancelAll();

			ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
			movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
			movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

			movementAdjustorDummy.RotateTowards( ticketDummy, victim);
			movementAdjustorDummy.SlideTowards( ticketDummy, victim, dist, dist );

			ciri_attack_anim_names.Clear();

			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_5_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_rp');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_lp');

			animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

			dummy_ent.DestroyAfter(0.75);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Ciri_Spectre_Attack_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims, actors													: array<CActor>;
	private var actortarget																: CActor;
	private var i, j, k, dummy_count 													: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Attack_Entry();
	}
	
	entry function Ciri_Spectre_Attack_Entry()
	{
		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_start_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_start_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		/*

		Sleep(0.5);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_lp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_rp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_5_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_lp_40ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_lp_50ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_lp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_lp_40ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_lp_50ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
		
		*/
	}
}

state ACS_Ciri_Spectre_Dodge_Front_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Front_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Front_Entry()
	{
		//Sleep(0.25);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_attack_end_disappear_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_attack_end_disappear_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Back_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Back_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Back_Entry()
	{
		//Sleep(0.25);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_disappear');
		//ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_back_lp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Left_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Left_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Left_Entry()
	{
		actorRot = GetWitcherPlayer().GetWorldRotation();

		actorRot.Yaw -= 45;

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), actorRot );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_left_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_left_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Right_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Right_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Right_Entry()
	{
		actorRot = GetWitcherPlayer().GetWorldRotation();

		actorRot.Yaw += 45;

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, TraceFloor(GetWitcherPlayer().GetWorldPosition() ), actorRot );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_right_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_right_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

function ACS_Ciri_Special_Attack_Sphere_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ciri_Special_Attack_Sphere', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Spawn_Transformation_Werewolf
{
    function Spawn_Transformation_Werewolf_Engage()
	{
		this.PushState('Spawn_Transformation_Werewolf_Engage');
	}
}

state Spawn_Transformation_Werewolf_Engage in cACS_Spawn_Transformation_Werewolf
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransfomrationWerewolf().Destroy();
		Spawn_Transformation_Werewolf_Entry();
	}
	
	entry function Spawn_Transformation_Werewolf_Entry()
	{
		Spawn_Transformation_Werewolf_Latent();
	}
	
	latent function Spawn_Transformation_Werewolf_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_werewolf.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		//p_comp = ent.GetComponentByClassName( 'CAppearanceComponent' );

		//apptemp = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\models\transformation_werewolf\t_03__werewolf.w2ent"
			
		//, true);
		
		//((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(apptemp);

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1875;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Werewolf_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Werewolf_Immunity_Critical', true); 

		ent.AddTag('ACS_Transformation_Werewolf');

		ent.PlayEffectSingle('sonar');
		ent.StopEffect('sonar');

		ent.PlayEffectSingle('blood');
		ent.StopEffect('blood');

		ent.PlayEffectSingle('morph_fx');
		ent.StopEffect('morph_fx');

		//ent.PlayEffectSingle('shadow_disappear');
		//ent.StopEffect('shadow_disappear');

		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');
		ent.PlayEffect('him_smoke_red');

		ent.PlayEffect('him_smoke_swirl');
		ent.StopEffect('him_smoke_swirl');

		//ent.PlayEffectSingle('smash_ground');
		//ent.StopEffect('smash_ground');

		ent.PlayEffectSingle('attack_special');
		ent.StopEffect('attack_special');

		GetACSWatcher().ACSTransformWerewolfPlayAnim('monster_werewolf_taunt_02', 1, 1);

		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");

		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");

		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSTransfomrationWerewolf() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Werewolf' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Werewolf_Spawn_Adds
{
	function ACS_Werewolf_Spawn_Adds_Engage()
	{
		this.PushState('ACS_Werewolf_Spawn_Adds_Engage');
	}
}

state ACS_Werewolf_Spawn_Adds_Engage in cACS_Werewolf_Spawn_Adds
{
	private var actors, victims																		: array<CActor>;
	private var i, count, j 																		: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var spawnPos, playerPos, newPlayerPos													: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent_1, ent_2, ent_3, vfxEnt_1, vfxEnt_2												: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var playerRot																			: EulerAngles;
	private var temp, ent_1_temp, ent_2_temp														: CEntityTemplate;

	private var randAngle, randRange																: float;

	private var animatedComponentA																	: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Werewolf_Spawn_Adds_Entry();
	}
	
	entry function ACS_Werewolf_Spawn_Adds_Entry()
	{
		ACS_Werewolf_Spawn_Adds_Latent();
	}
	
	latent function ACS_Werewolf_Spawn_Adds_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				(
				(npc.HasAbility('mon_werewolf_lesser')
				|| npc.HasAbility('mon_werewolf')
				|| npc.HasAbility('mon_lycanthrope')
				)
				&& npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.5
				&& npc.IsAlive()
				)
				)			
				{
					if (targetDistance > 5 * 5 && targetDistance <= 20 * 20)
					{
						if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
						{
							theSound.SoundLoadBank( "animals_wolf.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
						{
							theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
						}

						if (!npc.HasTag('ACS_Werewolf_Has_Summoned_Adds'))
						{
							npc.AddTag('ACS_Werewolf_Has_Summoned_Adds');





							vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
							"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
							, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_1.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

							vfxEnt_1.PlayEffect('sonar_mesh');

							vfxEnt_1.PlayEffect('sonar');

							vfxEnt_1.PlayEffect('fx_sonar');

							vfxEnt_1.DestroyAfter(2);



							vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
								"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
								, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_2.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );


							vfxEnt_2.PlayEffect('sonar_mesh');

							vfxEnt_2.PlayEffect('sonar');

							vfxEnt_2.PlayEffect('fx_sonar');

							vfxEnt_2.DestroyAfter(2);




							movementAdjustor = ((CActor)npc).GetMovingAgentComponent().GetMovementAdjustor();

							ticket = movementAdjustor.GetRequest( 'ACS_Werewolf_Smmmon_Rotate');
							movementAdjustor.CancelByName( 'ACS_Werewolf_Smmmon_Rotate' );
							movementAdjustor.CancelAll();

							ticket = movementAdjustor.CreateNewRequest( 'ACS_Werewolf_Smmmon_Rotate' );
							movementAdjustor.AdjustmentDuration( ticket, 0.5 );
							movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

							movementAdjustor.RotateTowards(ticket, ((CActor)(npc.GetTarget())));

							((CAnimatedComponent)((CNewNPC)npc).GetComponentByClassName( 'CAnimatedComponent' )).RaiseBehaviorForceEvent('Howl');

							if ( npc.IsInInterior() )
							{
								((CActor)npc).SetCanPlayHitAnim(false); 

								npc.AddBuffImmunity(EET_Stagger, 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_LongStagger, 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_Knockdown , 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_HeavyKnockdown , 'acs_werewolf_howl_interior', true);
							}
							else
							{
								npc.SoundEvent("animals_wolf_howl");

								npc.SoundEvent("monster_wild_dog_howl");

								temp = (CEntityTemplate)LoadResourceAsync( 

								"characters\npc_entities\monsters\wolf_lvl1__summon.w2ent"
									
								, true );

								playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -10;

								if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
								{
									theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.5f, 10 , newPlayerPos );
									playerPos = newPlayerPos;
								}

								playerRot = GetWitcherPlayer().GetWorldRotation();

								//playerRot.Yaw += 180;

								ent_1 = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

								((CNewNPC)ent_1).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_1).SetLevel(npc.GetLevel() - 3);

								((CNewNPC)ent_1).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								ent_2 = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

								((CNewNPC)ent_2).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_2).SetLevel( npc.GetLevel() - 3 );

								((CNewNPC)ent_2).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								ent_3 = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

								((CNewNPC)ent_3).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_3).SetLevel(npc.GetLevel() - 3);

								((CNewNPC)ent_3).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								/*
								
								count = 3;
									
								for( j = 0; j < count; j += 1 )
								{
									randRange = 2.5 + 2.5 * RandF();
									randAngle = 2.5 * Pi() * RandF();
									
									spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
									spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
									spawnPos.Z = playerPos.Z;
									
									theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 5.f, spawnPos);

									ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

									((CNewNPC)ent).SetLevel(npc.GetLevel()/2);

									((CNewNPC)ent).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);
									((CActor)ent).SetAnimationSpeedMultiplier(1);

									ent.AddTag( 'ACS_Werewolf_Summoned_Wolves' );
								}
								*/
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Human_Ice_Breathe_Controller
{
    function ACS_Human_Ice_Breathe_Controller_Engage()
	{
		this.PushState('ACS_Human_Ice_Breathe_Controller_Engage');
	}
}

state ACS_Human_Ice_Breathe_Controller_Engage in cACS_Human_Ice_Breathe_Controller
{
	private var temp									: CEntityTemplate;
	private var controller								: CEntity;
	private var actors									: array<CActor>;
	private var npc										: CActor;
	private var i										: int;
	private var voiceTagName 							: name;
	private var voiceTagStr								: string;
	private var appearanceName 							: name;
	private var appearanceStr							: string;
	private var bonePosition							: Vector;
	private var boneRotation							: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Human_Ice_Breathe_Controller_Entry();
	}
	
	entry function Human_Ice_Breathe_Controller_Entry()
	{	
		if (thePlayer.HasTag('ACS_Wild_Hunt_Pursuit')
		&& ACSWildHuntRiders_CheckDistance())
		{
			if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
			}
		}
		else if (GetACSEredin())
		{
			if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
			}
		}
		else
		{
			if (!thePlayer.IsInInterior())
			{
				Snow_Controller();
			}
			else
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_low_fx');
				GetACSSnowEntity().StopEffect('snow_med_fx');
				GetACSSnowEntity().StopEffect('snow_low_fx_2');
			}
		}
		
		Human_Ice_Breathe_Controller_Latent();
	}

	latent function Snow_Controller()
	{
		if (
		GetWeatherConditionName() == 'WT_Snow' 
		)
		{
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('slow_snow', false))
			{
				GetACSSnowEntity().PlayEffectSingle('slow_snow');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_dust', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_dust');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_Blizzard' 
		)
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('snow_low_fx');
			GetACSSnowEntity().StopEffect('snow_low_fx_2');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_Battle' 
		)
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_Battle_Forest'
		)
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_Wild_Hunt'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
		)
		{
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('slow_snow', false))
			{
				GetACSSnowEntity().PlayEffectSingle('slow_snow');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_dust', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_dust');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
			}

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_q604_Snow'
		)
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_low_fx_2');
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
			}
		}
		else if (
		GetWeatherConditionName() == 'WT_Fog_Snow'
		)
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_low_fx');
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_high_fx');

			if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
			{
				GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
			}
		}
		else
		{
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_low_fx');
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_low_fx_2');
			GetACSSnowEntity().StopEffect('snow_high_fx');
		}
	}

	latent function Human_Ice_Breathe_Controller_Latent()
	{
		if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Island_of_Myst 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village_Winter 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
		|| GetWeatherConditionName() == 'WT_Snow' 
		|| GetWeatherConditionName() == 'WT_Blizzard' 
		|| GetWeatherConditionName() == 'WT_Battle' 
		|| GetWeatherConditionName() == 'WT_Battle_Forest'
		|| GetWeatherConditionName() == 'WT_Mid_Clouds_Fog'
		|| GetWeatherConditionName() == 'WT_Wild_Hunt'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard'
		|| GetWeatherConditionName() == 'WT_q501_Storm'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
		|| GetWeatherConditionName() == 'WT_q604_Snow'
		|| GetWeatherConditionName() == 'WT_Fog'
		|| GetWeatherConditionName() == 'WT_Light_Fog' 
		|| GetWeatherConditionName() == 'WT_Fog_Windy' 
		|| GetWeatherConditionName() == 'WT_Fog_Snow' 
		|| GetWeatherConditionName() == 'WT_Fog_Heavy' 
		|| GetWeatherConditionName() == 'WT_Cold' 
		|| GetWeatherConditionName() == 'WT_Cold_Clouds'
		|| GetWeatherConditionName() == 'WT_Cold_BOB'
		|| GetWeatherConditionName() == 'fog1' 
		|| GetWeatherConditionName() == 'fog2' 
		|| GetWeatherConditionName() == 'flurry1' 
		|| GetWeatherConditionName() == 'flurry2' 
		|| GetWeatherConditionName() == 'flurry3' 
		|| GetWeatherConditionName() == 'flurry4' 
		|| GetWeatherConditionName() == 'snow1' 
		|| GetWeatherConditionName() == 'snow2' 
		|| GetWeatherConditionName() == 'snow3' 
		|| GetWeatherConditionName() == 'snow4' 
		|| GetWeatherConditionName() == 'snow5' 
		|| GetWeatherConditionName() == 'snow6'
		|| GetWeatherConditionName() == 'blizzard'
		|| GetWeatherConditionName() == 'LightSnow' 
		|| GetWeatherConditionName() == 'MidCloudsSnow' 
		|| GetWeatherConditionName() == 'Snow' 
		|| GetWeatherConditionName() == 'SnowWhite' 
		|| GetWeatherConditionName() == 'Blizzard'
		)
		{
			if (thePlayer.GetVisibility())
			{
				if (thePlayer.IsInInterior())
				{
					if (ACS_FireSourceCheck(thePlayer))
					{
						thePlayer.DestroyEffect('ice_breath_gameplay_indoor');
					}
					else
					{
						if (!thePlayer.IsEffectActive('ice_breath_gameplay_indoor', false))
						{
							thePlayer.PlayEffectSingle('ice_breath_gameplay_indoor');
						}
					}
				}
				else
				{
					if (!thePlayer.IsEffectActive('ice_breath_gameplay', false))
					{
						thePlayer.PlayEffectSingle('ice_breath_gameplay');
					}
				}
			}

			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 100, , FLAG_ExcludePlayer );

			if( actors.Size() > 0 )
			{
				for( i = 0; i < actors.Size(); i += 1 )
				{
					npc = (CNewNPC)actors[i];

					voiceTagName =  npc.GetVoicetag();
					voiceTagStr = NameToString( voiceTagName );
					
					appearanceName =  npc.GetAppearance();
					appearanceStr = NameToString( appearanceName );
					
					if(
					npc.IsMan()
					|| npc.IsWoman()
					|| StrFindFirst(voiceTagStr, "BOY") >= 0
					|| StrFindFirst(voiceTagStr, "GIRL") >= 0
					|| StrFindFirst(appearanceStr, "BOY") >= 0
					|| StrFindFirst(appearanceStr, "GIRL") >= 0
					)
					{
						if (!npc.HasTag('ACS_Ice_Breathe_Controller_Added'))
						{
							npc.AddTag('ACS_Ice_Breathe_Controller_Added');

							temp = (CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\fx\acs_ice_breathe.w2ent"
							
							, true );

							npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bonePosition, boneRotation );
							controller = (CEntity)theGame.CreateEntity( temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );
							controller.CreateAttachmentAtBoneWS( npc, 'head', bonePosition, boneRotation );

							controller.AddTag('ACS_Ice_Breathe_Controller');
						}
						
						if (npc.IsAlive()
						&& npc.GetVisibility())
						{
							if (((CNewNPC)npc).IsInInterior())
							{
								if (ACS_FireSourceCheck(npc))
								{
									controller.DestroyEffect('ice_breath_gameplay_indoor');
								}
								else
								{
									if (!controller.IsEffectActive('ice_breath_gameplay_indoor', false))
									{
										controller.PlayEffectSingle('ice_breath_gameplay_indoor');
									}
								}
							}
							else
							{
								if (!controller.IsEffectActive('ice_breath_gameplay', false))
								{
									controller.PlayEffectSingle('ice_breath_gameplay');
								}
							}
						}
						else
						{
							controller.DestroyEffect('ice_breath_gameplay_indoor');
							controller.DestroyEffect('ice_breath_gameplay');
						}
					}
					else if (((CNewNPC)npc).IsHorse())
					{
						if (npc.IsAlive()
						&& npc.GetVisibility())
						{
							if (!npc.IsEffectActive('breath_fx_cutscene', false))
							{
								npc.PlayEffectSingle('breath_fx_cutscene');
							}
						}
						else
						{
							npc.DestroyEffect('breath_fx_cutscene');
						}
					}
				}
			}
		}
		else
		{
			if (!theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene() 
			&& !theGame.IsCurrentlyPlayingNonGameplayScene())
			{
				thePlayer.DestroyEffect('ice_breath_gameplay_indoor');
				thePlayer.DestroyEffect('ice_breath_gameplay');

				actors.Clear();

				actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 100, , FLAG_ExcludePlayer );

				if( actors.Size() > 0 )
				{
					for( i = 0; i < actors.Size(); i += 1 )
					{
						npc = (CNewNPC)actors[i];

						if (((CNewNPC)npc).IsHorse()
						&& npc.IsAlive()
						&& npc.IsEffectActive('breath_fx_cutscene', false))
						{
							npc.DestroyEffect('breath_fx_cutscene');
						}
					}
				}
			}
			
			ACS_Ice_Breathe_Destroy();

			ACS_Ice_Breathe_Entity_RemoveTag();
		}
	}
}

function ACS_FireSourceCheck ( checkedActor: CActor ): bool 
{
    var entities: array<CGameplayEntity>;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, checkedActor, 10, 1, , FLAG_ExcludePlayer, , 'W3FireSource');
	{
		if (entities.Size()>0)
		{
			return true;
		}
	}

    return false;
}

function ACS_Ice_Breathe_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ice_Breathe_Controller', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_Ice_Breathe_Entity_RemoveTag()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ice_Breathe_Controller_Added', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].RemoveTag('ACS_Ice_Breathe_Controller_Added');
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_WildHunt_Rider_Area_Check() : bool
{
	if (
	theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
	)
	{
		return true;
	}

	return false;
}

function ACS_Wild_Hunt_Riders_Spawner_Exec()
{
	var vACS_Wild_Hunt_Riders: cACS_Wild_Hunt_Riders;
	vACS_Wild_Hunt_Riders = new cACS_Wild_Hunt_Riders in theGame;

	if (!theGame.IsDialogOrCutscenePlaying() 
	&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
	&& !GetWitcherPlayer().IsInGameplayScene()
	&& GetWitcherPlayer().IsOnGround()
	)
	{
		vACS_Wild_Hunt_Riders.ACS_Wild_Hunt_Riders_Engage();
	}
}

function ACS_Wild_Hunt_Riders_Spawner()
{
	var vACS_Wild_Hunt_Riders: cACS_Wild_Hunt_Riders;
	vACS_Wild_Hunt_Riders = new cACS_Wild_Hunt_Riders in theGame;

	if (!theGame.IsDialogOrCutscenePlaying() 
	&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
	&& !GetWitcherPlayer().IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& GetWitcherPlayer().IsOnGround()
	&& ACS_WildHunt_Rider_Area_Check()
	&& !GetWitcherPlayer().IsInInterior()
	)
	{
		if (RandF() < 0.5)
		{
			vACS_Wild_Hunt_Riders.ACS_Wild_Hunt_Riders_Engage();
		}
		else
		{
			vACS_Wild_Hunt_Riders.ACS_Eredin_Spawn_Engage();
		}
	}
}

statemachine class cACS_Wild_Hunt_Riders
{
    function ACS_Wild_Hunt_Riders_Engage()
	{
		this.PushState('ACS_Wild_Hunt_Riders_Engage');
	}

	function ACS_Eredin_Spawn_Engage()
	{
		this.PushState('ACS_Eredin_Spawn_Engage');
	}
}

state ACS_Wild_Hunt_Riders_Engage in cACS_Wild_Hunt_Riders
{
	private var temp, temp_2, temp_3											: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIHorseDoNothingAction;			
	private var horseTag 														: array<name>;	
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;

	event OnEnterState(prevStateName : name)
	{
		Wild_Hunt_Riders_Entry();
	}
	
	entry function Wild_Hunt_Riders_Entry()
	{	
		Wild_Hunt_Riders_Latent();
	}

	latent function Wild_Hunt_Riders_Latent()
	{
		thePlayer.AddTag('ACS_Wild_Hunt_Pursuit');

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_Spawn');

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\enemy_rider_wildhunt.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_vehicle_wild_hunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * RandRangeF(50,10) + thePlayer.GetWorldRight() * RandRangeF(25,-25);

		//playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + (thePlayer.GetHeadingVector() * RandRangeF(50,10)) + thePlayer.GetWorldRight() * RandRangeF(25,-25);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = RandRange(7,5);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			ent_3 = theGame.CreateEntity( temp_3, TraceFloor(spawnPos), playerRot );

			ent_3.PlayEffect('teleport_fx');

			ent_3.DestroyAfter(3);

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.15;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(GetACSEredin(), AIA_Friendly);

			((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.PlayEffect('critical_frozen');

			horseTag.Clear();
			
			horseTag.PushBack('enemy_horse');

			ent_2 = theGame.CreateEntity(temp_2, TraceFloor(spawnPos), playerRot,true,false,false,PM_DontPersist,horseTag);

			ent_2.PlayEffect('ice_armor_no_smoke');

			//((CNewNPC)ent_2).EnableCollisions(false);

			//((CNewNPC)ent_2).EnableCharacterCollisions(false);

			//((CNewNPC)ent).SetAttitude(((CNewNPC)ent_2), AIA_Friendly);

			//((CNewNPC)ent_2).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			ent.AddTag( 'ACS_Wild_Hunt_Rider' );

			ent_2.AddTag( 'ACS_Wild_Hunt_Rider_Horse' );

			movementAdjustor = ((CActor)ent_2).GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustor.GetRequest( 'ACS_Wild_Hunt_Smmmon_Rotate');
			movementAdjustor.CancelByName( 'ACS_Wild_Hunt_Smmmon_Rotate' );
			movementAdjustor.CancelAll();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Wild_Hunt_Smmmon_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.5 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

			movementAdjustor.RotateTowards(ticket, thePlayer);


			l_aiTree = new CAIHorseDoNothingAction in ent;
			l_aiTree.OnCreated();
			((CActor)ent).ForceAIBehavior( l_aiTree, BTAP_Emergency, 'AI_Rider_Load_Forced' );

			((CActor)ent).SignalGameplayEventParamInt( 'RidingManagerMountHorse', MT_instant | MT_fromScript );
		}

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_DeactivateFrostEffect');

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_Destroy');

		GetACSWatcher().AddTimer('ACS_WildHuntRiders_DeactivateFrostEffect', 30, false);

		GetACSWatcher().AddTimer('ACS_WildHuntRiders_Destroy', 60, false);
	}
}

state ACS_Eredin_Spawn_Engage in cACS_Wild_Hunt_Riders
{
	event OnEnterState(prevStateName : name)
	{
		Eredin_Spawn_Entry();
	}
	
	entry function Eredin_Spawn_Entry()
	{	
		Eredin_Spawn_Latent();
	}

	latent function Eredin_Spawn_Latent()
	{
		var temp, portal_temp												: CEntityTemplate;
		var ent, portal_ent													: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var playerRot														: EulerAngles;	

		GetACSEredin().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\enemy_eredin_miniboss.w2ent"
			
		, true );

		portal_temp = (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetVisibility( false );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag( 'ACS_Eredin' );

		GetACSWatcher().RemoveTimer('ACS_Eredin_SetVisibility');

		GetACSWatcher().AddTimer('ACS_Eredin_SetVisibility', 1, false);

		GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

		GetACSWatcher().AddTimer('ACS_Eredin_Kill_Timer', 90, false);



		portal_ent = theGame.CreateEntity( portal_temp, TraceFloor(playerPos), playerRot );

		portal_ent.PlayEffect('teleport_fx');

		portal_ent.DestroyAfter(3);

		ent.AddTag( 'ACS_Eredin_Portal' );

		//ent.PlayEffectSingle('rift_fx_special');
		//ent.StopEffect('rift_fx_special');

		//ent.PlayEffectSingle('disappear');
		//ent.StopEffect('disappear');

		//animcomp.PlaySlotAnimationAsync ( 'attack_ready_furycombo_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
	}
}

function ACSWildHuntRiders_CheckDistance() : bool
{	
	var actors		    				: array<CActor>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 15, 5, 'ACS_Wild_Hunt_Rider', FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACSWildHuntRiders_DeactivateFrostEffect_Actual()
{	
	var actors 											: array<CActor>;
	var i, j											: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].StopEffect('critical_frozen');
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		actors[j].StopEffect('ice_armor_no_smoke');
	}
}

function ACSWildHuntRidersRideTowardsPlayer()
{	
	var actors 															: array<CActor>;
	var i, j															: int;
	var targetDistance_1, targetDistance_2 								: float;
	var movementAdjustor												: CMovementAdjustor;
	var ticket 															: SMovementAdjustmentRequestTicket;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		targetDistance_1 = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actors[i].GetWorldPosition() ) ;

		if (targetDistance_1 > 5 * 5)
		{
			actors[i].GetMovingAgentComponent().ForceSetRelativeMoveSpeed( 2 );

			actors[i].GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[i].GetWorldPosition()));
		}
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		targetDistance_2 = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actors[j].GetWorldPosition() ) ;

		movementAdjustor = actors[j].GetMovingAgentComponent().GetMovementAdjustor();

		if( (actors[j].GetMovingAgentComponent()).IsOnNavigableSpace() )
		{
			(actors[j].GetMovingAgentComponent()).SnapToNavigableSpace( true );
		}		

		if (targetDistance_2 > 7.5  * 7.5
		&& ((CNewNPC)actors[j]).GetHorseComponent().IsFullyMounted() )
		{
			actors[j].GetMovingAgentComponent().SetGameplayRelativeMoveSpeed( 2 );

			actors[j].GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[j].GetWorldPosition()));

			//actors[j].SetBehaviorVariable( 'direction', VecHeading(thePlayer.GetWorldPosition() - actors[j].GetWorldPosition()) );

			movementAdjustor = actors[j].GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustor.GetRequest( 'ACS_Wild_Hunt_Horse_Rotate');
			movementAdjustor.CancelByName( 'ACS_Wild_Hunt_Horse_Rotate' );
			movementAdjustor.CancelAll();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Wild_Hunt_Horse_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 1 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

			movementAdjustor.RotateTowards(ticket, thePlayer);
		}
		else
		{
			actors[j].GetMovingAgentComponent().SetGameplayRelativeMoveSpeed( 0 );

			movementAdjustor.CancelAll();

			actors[j].SetBehaviorVariable( 'direction',  VecHeading(actors[j].GetWorldPosition()) );
		}
	}
}

function ACSWildHuntRiders_Destroy()
{	
	var actors 											: array<CActor>;
	var i, j											: int;
	var temp											: CEntityTemplate;
	var ent												: CEntity;
	var animatedComponentRider							: CAnimatedComponent;
	var animatedComponentHorse							: CAnimatedComponent;

	thePlayer.RemoveTag('ACS_Wild_Hunt_Pursuit');

	temp = (CEntityTemplate)LoadResource( 

	"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
		
	, true );
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		animatedComponentRider = (CAnimatedComponent)actors[i].GetComponentByClassName( 'CAnimatedComponent' );

		if (actors[i].IsAlive())
		{
			if (!actors[i].IsUsingHorse())
			{
				animatedComponentRider.PlaySlotAnimationAsync ( 'sq701_knight_sword_drawn_gesture_hailing', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}

			actors[i].PlayEffect('critical_frozen');

			ent = theGame.CreateEntity( temp, actors[i].GetWorldPosition(), actors[i].GetWorldRotation() );

			ent.CreateAttachment( actors[i], , Vector( 0, 0, 1 ), EulerAngles(0,0,0) );

			ent.PlayEffect('teleport_fx');

			ent.DestroyAfter(3);

			actors[i].DestroyAfter(2);
		}
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		animatedComponentHorse = (CAnimatedComponent)actors[j].GetComponentByClassName( 'CAnimatedComponent' );

		if (thePlayer.GetUsedVehicle() == actors[j])
		{
			thePlayer.AddEffectDefault( EET_HeavyKnockdown, thePlayer, "ACS_Wild_Hunt_Horse_Knockdown" );
		}
		else
		{
			if (actors[j].IsAlive())
			{
				animatedComponentHorse.PlaySlotAnimationAsync ( 'horse_rearing01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}
		}

		actors[j].PlayEffect('ice_armor_no_smoke');

		ent = theGame.CreateEntity( temp, actors[j].GetWorldPosition(), actors[j].GetWorldRotation() );

		ent.CreateAttachment( actors[j], , Vector( 0, 0, 0.75 ), EulerAngles(0,0,0) );

		ent.PlayEffect('teleport_fx');

		ent.DestroyAfter(3);

		actors[j].DestroyAfter(2);
	}
}

function GetACSSnowEntity() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_snow_entity' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////

function ACSArmorEtherSwordSummon()
{
	var trail_temp													: CEntityTemplate;
	var sword_trail_1												: CEntity;
	var i, count																														: int;
	var playerPos, spawnPos																												: Vector;
	var randAngle, randRange																											: float;
	var meshcomp																														: CComponent;
	var animcomp 																														: CAnimatedComponent;
	var h 																																: float;
	var bone_vec, pos, attach_vec																										: Vector;
	var bone_rot, rot, attach_rot																										: EulerAngles;

	GetACSArmorEtherSword().Destroy();

	if (!GetACSArmorEtherSword())
	{
		ACS_HideSwordWitoutScabbardStuff();

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_1.CreateAttachment( thePlayer, 'r_weapon');

		sword_trail_1.AddTag( 'ACS_Armor_Ether_Sword' );

		sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

		//sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

		//sword_trail_1.PlayEffectSingle('red_runeword_igni_2');

		sword_trail_1.PlayEffectSingle('runeword1_fire_trail');

		sword_trail_1.PlayEffectSingle('runeword1_fire_trail_2');

		sword_trail_1.PlayEffectSingle('fire_sparks_trail');

		sword_trail_1.PlayEffectSingle('red_fast_attack_buff');

		sword_trail_1.PlayEffectSingle('red_fast_attack_buff_hit');

		if (ACS_Armor_Omega_Equipped_Check())
		{
			if(GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				sword_trail_1.PlayEffectSingle('soul_edge_glow');
			}
			else if(GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				sword_trail_1.PlayEffectSingle('war_sword_glow');
			}
		}
		else if (ACS_Armor_Alpha_Equipped_Check())
		{
			if(GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				sword_trail_1.PlayEffectSingle('doomsword_amasii_glow');
			}
			else if(GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				sword_trail_1.PlayEffectSingle('dsd_closed_glow');
			}
		} 

		//sword_trail_1.PlayEffectSingle('arrow_trail_fire');

		//sword_trail_1.PlayEffectSingle('arrow_trail_fire_2');

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_start");
	}

	//sword_trail_1.DestroyAfter(10);
}

function GetACSArmorEtherSword() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Armor_Ether_Sword' );
	return entity;
}

function ACSMeditationCampfire() : W3Campfire
{
	var entity 			 : W3Campfire;
	
	entity = (W3Campfire)theGame.GetEntityByTag( 'ACS_Meditation_Campfire' );
	return entity;
}

function ACS_GPS_Entity() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_GPS_Entity' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_spawneredin()
{
	var temp, portal_temp												: CEntityTemplate;
	var ent, portal_ent													: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var playerRot														: EulerAngles;	

	GetACSEredin().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\enemy_eredin_miniboss.w2ent"
		
	, true );

	portal_temp = (CEntityTemplate)LoadResource( 

	"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
		
	, true );

	playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 1;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

	((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

	((CActor)ent).SetAnimationSpeedMultiplier(1);

	((CNewNPC)ent).SetVisibility( false );

	((CActor)ent).AddTag( 'ContractTarget' );

	((CActor)ent).AddTag('IsBoss');

	((CActor)ent).AddAbility('Boss');

	((CActor)ent).AddAbility('BounceBoltsWildhunt');

	ent.AddTag( 'ACS_Eredin' );

	GetACSWatcher().RemoveTimer('ACS_Eredin_SetVisibility');

	GetACSWatcher().AddTimer('ACS_Eredin_SetVisibility', 1, false);

	GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

	GetACSWatcher().AddTimer('ACS_Eredin_Kill_Timer', 90, false);



	portal_ent = theGame.CreateEntity( portal_temp, TraceFloor(playerPos), playerRot );

	portal_ent.PlayEffect('teleport_fx');

	portal_ent.DestroyAfter(3);

	ent.AddTag( 'ACS_Eredin_Portal' );

	//ent.PlayEffectSingle('rift_fx_special');
	//ent.StopEffect('rift_fx_special');

	//ent.PlayEffectSingle('disappear');
	//ent.StopEffect('disappear');

	//animcomp.PlaySlotAnimationAsync ( 'attack_ready_furycombo_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
}

function GetACSEredin() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Eredin' );
	return entity;
}

function GetACSEredinPortal() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Portal' );
	return entity;
}

function GetACSEredin_CheckDistance() : bool
{	
	var actors		    				: array<CActor>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 15, 1, 'ACS_Eredin', FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_NightStalkerAreaCheck() : bool
{
	if (
	theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Dlc_Bob
	)
	{
		return true;
	}

	return false;
}

function GetACSNightStalker() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Night_Stalker' );
	return entity;
}

function ACS_SpawnNightStalker()
{
	var vACS_Night_Stalker					: cACS_Night_Stalker;

	vACS_Night_Stalker = new cACS_Night_Stalker in theGame;

	vACS_Night_Stalker.ACS_Night_Stalker_Engage();
}

statemachine class cACS_Night_Stalker
{
    function ACS_Night_Stalker_Engage()
	{
		this.PushState('ACS_Night_Stalker_Engage');
	}
}

state ACS_Night_Stalker_Engage in cACS_Night_Stalker
{
	private var temp, temp2, ent_1_temp, trail_temp							: CEntityTemplate;
	var ent, ent2, ent_1, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;			
	var p_comp															: CComponent;
	var apptemp															: CEntityTemplate;	

	event OnEnterState(prevStateName : name)
	{
		Night_Stalker_Entry();
	}
	
	entry function Night_Stalker_Entry()
	{	
		Night_Stalker_Latent();
	}

	latent function Night_Stalker_Latent()
	{
		GetACSNightStalker().Destroy();

		GetACSWatcher().RemoveTimer('ACS_NightStalker_Kill_Timer');

		GetACSWatcher().RemoveTimer('NightStalkerCamo');
		GetACSWatcher().RemoveTimer('NightStalkerVisibility');

		GetACSWatcher().RemoveTimer('NightStalkerDeathCamo');
		GetACSWatcher().RemoveTimer('NightStalkerDeathTeleport');

		GetACSWatcher().AddTimer('NightStalkerCamo', 7, true);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\nightstalker.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		p_comp = ent.GetComponentByClassName( 'CAppearanceComponent' );



		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		//((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		//((CNewNPC)ent).EnableCharacterCollisions(false); 

		//((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('demonic_possession');


		//ent2 = theGame.CreateEntity( temp2, ent.GetWorldPosition(), ent.GetWorldRotation() );

		//ent2.CreateAttachment(ent, 'head_fx' , Vector( -2, 0.55, 0 ), EulerAngles(-180,0,90));

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).SetCanPlayHitAnim(false); 

		ent.AddTag( 'ACS_Night_Stalker' );


		GetACSWatcher().AddTimer('ACS_NightStalker_Kill_Timer', 90, false);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Red_Blade_Projectile_Fire
{
    function ACS_Red_Blade_Projectile_Engage()
	{
		this.PushState('ACS_Red_Blade_Projectile_Engage');
	}
}

state ACS_Red_Blade_Projectile_Engage in cACS_Red_Blade_Projectile_Fire
{
	private var proj_1								: ACSBladeProjectile;
	private var initpos, newpos, targetPosition		: Vector;
	private var portal_ent							: CEntity;
	private var actor								: CActor; 
	private var actors		    					: array<CActor>;
	private var i									: int;
	private var npc									: CNewNPC;
	private var blade_temp, portal_temp				: CEntityTemplate;

	event OnEnterState(prevStateName : name)
	{
		Red_Blade_Projectile_Entry();
	}
	
	entry function Red_Blade_Projectile_Entry()
	{	
		Red_Blade_Projectile_Latent();
	}

	latent function Red_Blade_Projectile_Latent()
	{
		thePlayer.SoundEvent("fx_rune_activate_igni");

		portal_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\portal.w2ent", true );
		
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetHeadingVector() * RandRangeF(2, -2)) + (GetWitcherPlayer().GetWorldRight() * RandRangeF(7, -7)) ;	
		initpos.Z += RandRangeF(7, 2.25);

		portal_ent = (CEntity)theGame.CreateEntity( portal_temp, initpos, thePlayer.GetWorldRotation() );

		portal_ent.PlayEffect('teleport');

		proj_1 = (ACSBladeProjectile)theGame.CreateEntity( blade_temp, initpos );
								
		proj_1.Init(thePlayer);

		if (ACS_Armor_Alpha_Equipped_Check())
		{
			portal_ent.DestroyAfter(7);
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			portal_ent.DestroyAfter(2);
		}

		if(thePlayer.IsInCombat())
		{
			if ( thePlayer.IsHardLockEnabled() )
			{
				targetPosition = ((CActor)( thePlayer.GetDisplayTarget() )).PredictWorldPosition(0.7);

				if (ACS_Armor_Alpha_Equipped_Check())
				{
					targetPosition.Z += 0.75;
				}
				else if (ACS_Armor_Omega_Equipped_Check())
				{
					targetPosition.Z += 1.1;
				}
			}
			else
			{
				targetPosition = ((CActor)( thePlayer.moveTarget )).PredictWorldPosition(0.7);
				
				if (ACS_Armor_Alpha_Equipped_Check())
				{
					targetPosition.Z += 0.75;
				}
				else if (ACS_Armor_Omega_Equipped_Check())
				{
					targetPosition.Z += 1.1;
				}

				/*
				actors.Clear();

				actors = thePlayer.GetNPCsAndPlayersInRange( 50, 1, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer + FLAG_Attitude_Hostile);

				if( actors.Size() > 0 )
				{
					for( i = 0; i < actors.Size(); i += 1 )
					{
						npc = (CNewNPC)actors[i];

						actor = actors[i];

						targetPosition = actor.PredictWorldPosition(0.7);
						
						if (ACS_Armor_Alpha_Equipped_Check())
						{
							targetPosition.Z += 0.25;
						}
						else if (ACS_Armor_Omega_Equipped_Check())
						{
							targetPosition.Z += 1.1;
						}
					}
				}
				*/
			}
		}
		else
		{
			targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 30;
			targetPosition.Z -= 5;
		}

		proj_1.ShootProjectileAtPosition( 0, RandRangeF(25,10), targetPosition, 500 );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSGuidingLightMarker() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Guiding_Light_Marker' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_XenoSwarm_Spawner
{
    function ACS_XenoTyrant_Spawner_Engage()
	{
		this.PushState('ACS_XenoTyrant_Spawner_Engage');
	}

	function ACS_XenoTyrantEgg_Static_Spawner_Engage()
	{
		if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Dlc_Bob
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Wyzima
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Island_of_Myst
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Spiral
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village_Winter
		)
		{
			this.PushState('ACS_XenoTyrantEgg_Static_Spawner_Engage');
		}
	}

	function ACS_XenoSoldiers_Spawn_Engage()
	{
		this.PushState('ACS_XenoSoldiers_Spawn_Engage');
	}

	function ACS_XenoWorkers_Spawn_Engage()
	{
		this.PushState('ACS_XenoWorkers_Spawn_Engage');
	}
}

state ACS_XenoTyrant_Spawner_Engage in cACS_XenoSwarm_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_XenoSwarm_Entry();
	}
	
	entry function Spawn_XenoSwarm_Entry()
	{	
		Spawn_XenoSwarm_Latent();
	}

	latent function Spawn_XenoSwarm_Latent()
	{
		ACS_spawnxenotyrant();
	}

	latent function ACS_spawnxenotyrant()
	{
		var temp															: CEntityTemplate;
		var ent 															: CEntity;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot							: EulerAngles;

		GetACSXenoTyrant().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_tyrant.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = 1;
			
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.75;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetCanPlayHitAnim(false); 

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Xeno_Tyrant_Buff', true);

		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Xeno_Tyrant_Buff', true);

		ent.AddTag( 'ACS_Xeno_Tyrant' );

		GetACSWatcher().RemoveTimer('ACS_Spawn_XenoSoldiers_Swarm');
		GetACSWatcher().AddTimer('ACS_Spawn_XenoSoldiers_Swarm', 1, false);
	}
}

state ACS_XenoTyrantEgg_Static_Spawner_Engage in cACS_XenoSwarm_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		Static_Spawn_XenoSwarm_Entry();
	}
	
	entry function Static_Spawn_XenoSwarm_Entry()
	{	
		Static_Spawn_XenoSwarm_Latent();
	}

	latent function Static_Spawn_XenoSwarm_Latent()
	{
		ACS_spawnxenotyrantstatic();
	}

	latent function ACS_spawnxenotyrantstatic()
	{
		var temp, temp2														: CEntityTemplate;
		var ent, ent2 														: CEntity;
		var playerPos, spawnPos, newPlayerPos, newSpawnPos					: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var rot, playerRot													: EulerAngles;
		var i, count														: int;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_egg_tyrant.w2ent"
			
		, true );

		if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
		)
		{
			playerPos = Vector(190.299957, 190.045547, 22.075409, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
		)
		{
			playerPos = Vector(1752.351074, 518.808289, 3.625612, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
		)
		{
			playerPos = Vector(-91.659164, 793.199951, 48.489071, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Dlc_Bob
		)
		{
			playerPos = Vector(387.123108, -709.767944, 10.444670, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Wyzima
		)
		{
			playerPos = Vector(146.306946, -64.951698, 37.446629, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Island_of_Myst
		)
		{
			playerPos = Vector(52.411758, 257.636658, 7.797175, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Spiral
		)
		{
			playerPos = Vector(-710.308411, -2296.816406, 85.194946, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village
		)
		{
			playerPos = Vector(-270.139099, -238.222488, 13.170625, 1);
		}
		else if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village_Winter
		)
		{
			playerPos = Vector(-334.244812, -201.047256, 7.126178, 1);
		}

		playerRot = thePlayer.GetWorldRotation();

		if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
		{
			theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 7 , newPlayerPos );
			playerPos = newPlayerPos;
		}

		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		ent.AddTag( 'ACS_Xeno_Tyrant_Egg' );



		temp2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_egg_normal.w2ent"
			
		, true );

		count = 20;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 15 + 15 * RandF();
			randAngle = 10 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 7 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent2 = theGame.CreateEntity( temp2, TraceFloor(spawnPos), playerRot );

			((CNewNPC)ent2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent2).SetAttitude(thePlayer, AIA_Hostile);

			ent2.AddTag( 'ACS_Xeno_Egg' );
		}
	}
}

state ACS_XenoSoldiers_Spawn_Engage in cACS_XenoSwarm_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		XenoSoldiers_Spawn_Entry();
	}
	
	entry function XenoSoldiers_Spawn_Entry()
	{	
		XenoSoldiers_Spawn_Latent();
	}

	latent function XenoSoldiers_Spawn_Latent()
	{
		ACS_spawnxenosoldiers();
	}

	latent function ACS_spawnxenosoldiers()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, newSpawnPos								: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
		var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
		var l_aiTree														: CAIMoveToAction;			

		//GetACSXenoSoldiersDestroyAll();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_small.w2ent"
			
		, true );

		playerPos = GetACSXenoTyrant().GetWorldPosition();

		playerRot = GetACSXenoTyrant().GetWorldRotation();
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 3 + 3 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 7 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag( 'ACS_Xeno_Soldiers' );
		}
	}
}

state ACS_XenoWorkers_Spawn_Engage in cACS_XenoSwarm_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		XenoWorkers_Spawn_Entry();
	}
	
	entry function XenoWorkers_Spawn_Entry()
	{	
		XenoWorkers_Spawn_Latent();
	}

	latent function XenoWorkers_Spawn_Latent()
	{
		ACS_spawnxenoworkers();
	}

	latent function ACS_spawnxenoworkers()
	{
		var temp_1, temp_2													: CEntityTemplate;
		var ent_1, ent_2, ent_3												: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, newSpawnPos								: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		//GetACSXenoWorkersDestroyAll();

		//GetACSXenoArmoredWorkersDestroyAll();

		temp_1 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_workers.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_workers_normal.w2ent"
			
		, true );

		playerPos = GetACSXenoTyrant().GetWorldPosition();

		playerRot = GetACSXenoTyrant().GetWorldRotation();
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 7 + 7 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 7 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent_1 = theGame.CreateEntity( temp_1, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_1).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_1).SetAnimationSpeedMultiplier(1);

			((CActor)ent_1).AddTag( 'ContractTarget' );

			((CActor)ent_1).AddAbility('BounceBoltsWildhunt');

			ent_1.AddTag( 'ACS_Xeno_Workers' );


			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent_2 = theGame.CreateEntity( temp_2, TraceFloor(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddTag( 'ContractTarget' );

			((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

			((CActor)ent_2).AddAbility('mon_arachas');

			ent_2.AddTag( 'ACS_Xeno_Armored_Workers' );
		}
	}
}

function GetACSXenoTyrant() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Xeno_Tyrant' );
	return entity;
}

function ACSXenoTyrantAddAbility()
{
	if (!GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
	{
		GetACSXenoTyrant().AddAbility('mon_kikimore_small');
	}
}

function ACSXenoTyrantnRemoveAbility()
{
	if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
	{
		GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
	}
}

function GetACSXenoSoldiersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSXenoSoldiersAddAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].HasAbility('mon_kikimore_small'))
		{
			actors[i].RemoveAbility('mon_kikimore_small');
		}

		if (actors[i].HasAbility('Burrow'))
		{
			actors[i].RemoveAbility('Burrow');
		}

		if (actors[i].HasAbility('mon_kikimora_worker'))
		{
			actors[i].RemoveAbility('mon_kikimora_worker');
		}

		if (!actors[i].HasAbility('mon_kikimore_big'))
		{
			actors[i].AddAbility('mon_kikimore_big');
		}

		if (!actors[i].HasAbility('mon_kikimora_warrior'))
		{
			actors[i].AddAbility('mon_kikimora_warrior');
		}
	}
}

function ACSXenoSoldiersRemoveAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].HasAbility('mon_kikimore_big'))
		{
			actors[i].RemoveAbility('mon_kikimore_big');
		}

		if (actors[i].HasAbility('mon_kikimora_warrior'))
		{
			actors[i].RemoveAbility('mon_kikimora_warrior');
		}

		if (!actors[i].HasAbility('mon_kikimore_small'))
		{
			actors[i].AddAbility('mon_kikimore_small');
		}

		if (!actors[i].HasAbility('Burrow'))
		{
			actors[i].AddAbility('Burrow');
		}

		if (!actors[i].HasAbility('mon_kikimora_worker'))
		{
			actors[i].AddAbility('mon_kikimora_worker');
		}
	}
}

function GetACSXenoWorkersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Workers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function GetACSXenoArmoredWorkersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Armored_Workers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSXenoArmoredWorkersSwapAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Armored_Workers', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (RandF() < 0.5)
		{
			if (RandF() < 0.5)
			{
				if (!actors[i].HasAbility('Venom'))
				{
					actors[i].AddAbility('Venom');
				}

				if (!actors[i].HasAbility('mon_endriaga_worker'))
				{
					actors[i].AddAbility('mon_endriaga_worker');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!actors[i].HasAbility('Charge'))
				{
					actors[i].AddAbility('Charge');
				}

				if (!actors[i].HasAbility('mon_endriaga_soldier_spikey'))
				{
					actors[i].AddAbility('mon_endriaga_soldier_spikey');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
		}
		else
		{
			if (RandF() < 0.5)
			{
				if (!actors[i].HasAbility('Block'))
				{
					actors[i].AddAbility('Block');
				}

				if (!actors[i].HasAbility('mon_arachas'))
				{
					actors[i].AddAbility('mon_arachas');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!actors[i].HasAbility('Spikes'))
				{
					actors[i].AddAbility('Spikes');
				}

				if (!actors[i].HasAbility('mon_endriaga_soldier_spikey'))
				{
					actors[i].AddAbility('mon_endriaga_soldier_spikey');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}
			}
		}
	}
}
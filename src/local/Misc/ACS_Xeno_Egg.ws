statemachine class W3ACSXenoEggCustom extends W3MonsterClue
{
	editable var morphTimeIgni : float;
	editable var morphTimeAard : float;
	editable var burnoutTime   : float;
	
	saved var destroyed : bool;
	
	editable var igniReactionEffect : name;
	editable var aardReactionEffect : name;
	
	editable var onDestroyedFact : array<name>;
	
	var morphManager : CMorphedMeshManagerComponent;
	var morphTime : float;
	var allowFactAdding : bool;
	
	private const var APPEARANCE_INTACT : name;
	private const var APPEARANCE_DESTROYED : name;
	
	default APPEARANCE_INTACT = 'intact';
	default APPEARANCE_DESTROYED = 'destroyed';
	
	default morphTimeIgni = 3.0;
	default morphTimeAard = 0.1;
	default burnoutTime = 20.0;
	default allowFactAdding = true;	
	
	var pos : Vector;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();

		morphManager = (CMorphedMeshManagerComponent) this.GetComponentByClassName('CMorphedMeshManagerComponent');
		
		if(destroyed)
		{
			morphManager.SetMorphBlend( 1.0, 0.0 );
			ApplyAppearance( APPEARANCE_DESTROYED );
		}
		else
		{
			ApplyAppearance( APPEARANCE_INTACT );
		}
		
		super.OnSpawned( spawnData );

		AddTimer('DetectLife', 0.0001, true);
	}

	timer function DetectLife( time : float, optional id : int)
	{
		var actors    														: array<CGameplayEntity>;
		var i																: int;
		var actor															: CActor;

		actors.Clear();

		FindGameplayEntitiesInSphere( actors, this.GetWorldPosition(), 5, 10, , FLAG_OnlyAliveActors, ,);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			if( actors.Size() > 0 )
			{
				actor = (CActor) actors[i];

				if (actor)
				{
					if(!destroyed)
					{
						ArachasEggSignReaction( morphTimeAard, aardReactionEffect );
					}

					RemoveTimer('DetectLife');
				}
			}
		}
	}
	
	event OnIgniHit( sign : W3IgniProjectile )
	{
		if(!destroyed)
		{
			//ArachasEggSignReaction( morphTimeIgni, igniReactionEffect );
		}
		
	}	
	
	event OnAardHit( sign : W3AardProjectile )
	{
		if(!destroyed)
		{
			//ArachasEggSignReaction( morphTimeAard, aardReactionEffect );
		}
	}	

	
	private function ArachasEggSignReaction( selectedMorphTime : float, reactionEffect : name )
	{
		destroyed = true;
		PlayEffectSingle( reactionEffect );
		
		morphTime = selectedMorphTime;
		
		AddTimer('MorphEgg', 0.1f, false);
		
		this.SetAttributes(FCAA_ForceSet, false, false, false, false, false, false);
		
	}
	
	timer function DestroyedFinalizeTimer( time : float, optional id : int)
	{
		var i													: int;

		ApplyAppearance( APPEARANCE_DESTROYED );
		
		if( allowFactAdding )
		{
			for( i=0; i < onDestroyedFact.Size(); i+=1 )
			{
				FactsAdd( onDestroyedFact[i], 1 );
			}
		}

		this.PushState('SpawnXeno');
	}
	
	timer function TurnEffectsOffTimer( time : float, optional id : int)
	{
		this.StopAllEffects();
	}
	
	timer function MorphEgg( time : float, optional id : int)
	{
		morphManager.SetMorphBlend( 1.0, morphTime );
		
		AddTimer('TurnEffectsOffTimer', burnoutTime, false);
		AddTimer('DestroyedFinalizeTimer', morphTime + 0.1, false);
		
	}
	
	public function ManualEggDestruction( addFact : bool )
	{
		allowFactAdding = addFact;
		ArachasEggSignReaction( 0.1f, '' );	
	}
}

state SpawnXeno in W3ACSXenoEggCustom 
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
		var temp_1, temp_2, temp_3											: CEntityTemplate;
		var ent_1, ent_2, ent_3												: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		if (RandF() < 0.5)
		{
			temp_3 = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_small.w2ent"
				
			, true );

			ent_3 = theGame.CreateEntity( temp_3, TraceFloor(parent.pos), playerRot );

			animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_3.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddTag( 'ContractTarget' );

			((CActor)ent_3).AddAbility('BounceBoltsWildhunt');

			ent_3.AddTag( 'ACS_Xeno_Soldiers' );
		}
		else
		{
			if (RandF() < 0.5)
			{
				temp_1 = (CEntityTemplate)LoadResourceAsync( 

				"dlc\dlc_acs\data\entities\monsters\xeno_workers.w2ent"
					
				, true );

				ent_1 = theGame.CreateEntity( temp_1, TraceFloor(parent.pos), playerRot );

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
			}
			else
			{
				temp_2 = (CEntityTemplate)LoadResourceAsync( 

				"dlc\dlc_acs\data\entities\monsters\xeno_workers_normal.w2ent"
					
				, true );

				ent_2 = theGame.CreateEntity( temp_2, TraceFloor(parent.pos), playerRot );

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
}

statemachine class W3ACSXenoTyrantEggCustom extends W3MonsterClue
{
	editable var morphTimeIgni : float;
	editable var morphTimeAard : float;
	editable var burnoutTime   : float;
	
	saved var destroyed : bool;
	
	editable var igniReactionEffect : name;
	editable var aardReactionEffect : name;
	
	editable var onDestroyedFact : array<name>;
	
	var morphManager : CMorphedMeshManagerComponent;
	var morphTime : float;
	var allowFactAdding : bool;
	
	private const var APPEARANCE_INTACT : name;
	private const var APPEARANCE_DESTROYED : name;
	
	default APPEARANCE_INTACT = 'intact';
	default APPEARANCE_DESTROYED = 'destroyed';
	
	default morphTimeIgni = 3.0;
	default morphTimeAard = 0.1;
	default burnoutTime = 20.0;
	default allowFactAdding = true;	
	
	var pos : Vector;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();

		morphManager = (CMorphedMeshManagerComponent) this.GetComponentByClassName('CMorphedMeshManagerComponent');
		
		if(destroyed)
		{
			morphManager.SetMorphBlend( 1.0, 0.0 );
			ApplyAppearance( APPEARANCE_DESTROYED );
		}
		else
		{
			ApplyAppearance( APPEARANCE_INTACT );
		}
		
		super.OnSpawned( spawnData );

		AddTimer('DetectLife', 0.0001, true);
	}
	
	timer function DetectLife( time : float, optional id : int)
	{
		var actors    														: array<CGameplayEntity>;
		var i																: int;
		var actor															: CActor;

		actors.Clear();

		FindGameplayEntitiesInSphere( actors, this.GetWorldPosition(), 5, 10, , FLAG_OnlyAliveActors, ,);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			if( actors.Size() > 0 )
			{
				actor = (CActor) actors[i];

				if (actor)
				{
					if(!destroyed)
					{
						ArachasEggSignReaction( morphTimeAard, aardReactionEffect );
					}

					RemoveTimer('DetectLife');
				}
			}
		}
	}

	event OnIgniHit( sign : W3IgniProjectile )
	{
		if(!destroyed)
		{
			//ArachasEggSignReaction( morphTimeIgni, igniReactionEffect );
		}
		
	}	
	
	event OnAardHit( sign : W3AardProjectile )
	{
		if(!destroyed)
		{
			//ArachasEggSignReaction( morphTimeAard, aardReactionEffect );
		}
		
	}	
	
	private function ArachasEggSignReaction( selectedMorphTime : float, reactionEffect : name )
	{
		destroyed = true;
		PlayEffectSingle( reactionEffect );
		
		morphTime = selectedMorphTime;
		
		AddTimer('MorphEgg', 0.1f, false);
		
		this.SetAttributes(FCAA_ForceSet, false, false, false, false, false, false);
		
	}
	
	timer function DestroyedFinalizeTimer( time : float, optional id : int)
	{
		var i 																: int;
		var temp															: CEntityTemplate;
		var ent 															: CEntity;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;
		
		ApplyAppearance( APPEARANCE_DESTROYED );
		
		if( allowFactAdding )
		{
			for( i=0; i < onDestroyedFact.Size(); i+=1 )
			{
				FactsAdd( onDestroyedFact[i], 1 );
			}
		}

		this.PushState('SpawnXenoTyrant');
	}
	
	timer function TurnEffectsOffTimer( time : float, optional id : int)
	{
		this.StopAllEffects();
	}
	
	timer function MorphEgg( time : float, optional id : int)
	{
		morphManager.SetMorphBlend( 1.0, morphTime );
		
		AddTimer('TurnEffectsOffTimer', burnoutTime, false);
		AddTimer('DestroyedFinalizeTimer', morphTime + 0.1, false);
		
	}
	
	public function ManualEggDestruction( addFact : bool )
	{
		allowFactAdding = addFact;
		ArachasEggSignReaction( 0.1f, '' );	
	}
}

state SpawnXenoTyrant in W3ACSXenoTyrantEggCustom 
{
	event OnEnterState(prevStateName : name)
	{
		XenoTyrant_Spawn_Entry();
	}
	
	entry function XenoTyrant_Spawn_Entry()
	{	
		XenoTyrant_Spawn_Latent();
	}

	latent function XenoTyrant_Spawn_Latent()
	{
		ACS_spawnxenotyrant();
	}

	latent function ACS_spawnxenotyrant()
	{
		var i 																: int;
		var temp															: CEntityTemplate;
		var ent 															: CEntity;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		GetACSXenoTyrant().Destroy();

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_tyrant.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

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
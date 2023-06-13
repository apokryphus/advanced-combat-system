statemachine class ACSMeditationCamera extends CStaticCamera
{
	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetMeditationCamera(this);
	
		AddTimer('DelayStart', 0.0000000016, false);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		
	}
	
	var targetPos : Vector;
	var targetRot : EulerAngles;

	timer function DelayStart( deltaTime : float , id : int)	
	{	
		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);
		

		targetPos = thePlayer.GetWorldPosition();
		targetPos.Z += 1;

		if (thePlayer.IsInInterior())
		{
			targetPos += VecConeRand(currentHeading, 0, -3, -3);
		}
		else
		{
			targetPos += VecConeRand(currentHeading, 0, -5, -5);
		}

		targetRot = thePlayer.GetWorldRotation();
		
		
		AddTimer('IntoTick',0.0016,true);
	}
	
	timer function IntoTick( deltaTime : float , id : int)	{		
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), targetPos, 0.07);
		rot.Pitch = AngleApproach( targetRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( targetRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( targetRot.Yaw, currentRot.Yaw, 1 );
		
		
		
		if(VecDistance(pos, targetPos) < 0.01 )
		{
			AddTimer('Tick',0.0000000016,true);
			RemoveTimer('IntoTick');
		}
	
		this.TeleportWithRotation(pos,rot);	
	}
	
	public function getHeading() : float{
		return this.currentHeading;
	}
	
	public function getPitch() : float{
		return this.currentPitch;
	}
	
	var currentHeading : float;
	var currentPitch : float;
	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	{	
		
		vampPos = thePlayer.GetWorldPosition();
		vampPos.Z += 1;

		if(theInput.GetActionValue( 'GI_MouseDampX' )!=0){
			currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
		} 

		if(theInput.GetActionValue( 'GI_MouseDampY' )!=0){
		
			currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
			
			if(AbsF(currentPitch) > maxPitch ){
				currentPitch = maxPitch * SignF(currentPitch);
			}
		} 	

		if (thePlayer.IsInInterior())
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -3, -3);
		}
		else
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -5, -5);
		}

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/20;

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	
	
	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;
	
	public function GoBack()
	{
		var rr : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;
	
		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		AddTimer('EndTick',0.0016, true);		
	}

	timer function EndTick( deltaTime : float , id : int)	
	{	
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), originalCamPos, 0.07);
		rot.Pitch = AngleApproach( originalCamRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( originalCamRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( originalCamRot.Yaw, currentRot.Yaw, 1 );
		
		if(VecDistance(pos, originalCamPos) < 0.01 )
		{
			this.Stop();
			this.Destroy();			
		}
	
		this.TeleportWithRotation(pos,rot);
	}
}

statemachine class ACSTransformationCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetTransformationCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		

		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);

		targetPos = thePlayer.GetWorldPosition();

		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			targetPos.Z += 0.75;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);
		}
		else
		{
			targetPos.Z += 7;
			targetPos += VecConeRand(currentHeading, 0, -10, -10);
		}

		targetRot = thePlayer.GetWorldRotation();
		
		AddTimer('Tick',0.000000000001,true);
	}
	
	public function getHeading() : float
	{
		return this.currentHeading;
	}
	
	public function getPitch() : float
	{
		return this.currentPitch;
	}
	
	var currentHeading : float;
	var currentPitch : float;
	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	
	{	
		
		vampPos = thePlayer.GetWorldPosition();

		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			vampPos.Z += 0.75;
		}

		if(theInput.GetActionValue( 'GI_MouseDampX' )!=0){
			currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
		} 

		if(theInput.GetActionValue( 'GI_MouseDampY' )!=0){
		
			currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
			
			if(AbsF(currentPitch) > maxPitch ){
				currentPitch = maxPitch * SignF(currentPitch);
			}
		} 	
		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);
		}

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/20;

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	

	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;

	public function GoBack()
	{
		var rr : EulerAngles;
		var pos : Vector;
		var rot, currentRot : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;

		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		
		this.Stop();
		this.Destroy();			
	
		this.TeleportWithRotation(pos,rot);	
	}
}

statemachine class ACSFocusModeCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetFocusModeCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		

		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);
		
		
		AddTimer('Tick',0.0000000016,true);
	}
	
	public function getHeading() : float{
		return this.currentHeading;
	}
	
	public function getPitch() : float{
		return this.currentPitch;
	}
	
	var currentHeading : float;
	var currentPitch : float;
	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	{	
		
		vampPos = thePlayer.GetWorldPosition();
		vampPos.Z += 1.5;

		if(theInput.GetActionValue( 'GI_MouseDampX' )!=0){
			currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
		} 

		if(theInput.GetActionValue( 'GI_MouseDampY' )!=0){
		
			currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
			
			if(AbsF(currentPitch) > maxPitch ){
				currentPitch = maxPitch * SignF(currentPitch);
			}
		} 	

		cameraPos = vampPos + VecConeRand(currentHeading, 0, -4, -4);

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/20;

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	
	
	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;
	
	public function GoBack()
	{
		var rr : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;
	
		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		AddTimer('EndTick',0.0016, true);		
	}

	timer function EndTick( deltaTime : float , id : int)	
	{	
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), originalCamPos, 0.07);
		rot.Pitch = AngleApproach( originalCamRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( originalCamRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( originalCamRot.Yaw, currentRot.Yaw, 1 );
		
		if(VecDistance(pos, originalCamPos) < 0.01 )
		{
			this.Stop();
			this.Destroy();			
		}
	
		this.TeleportWithRotation(pos,rot);
	}
}
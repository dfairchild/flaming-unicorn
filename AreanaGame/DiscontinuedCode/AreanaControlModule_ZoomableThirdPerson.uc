class AreanaControlModule_ZoomableThirdPerson extends AreanaControlModule;

//Calculate Pawn aim rotation
simulated singular function Rotator GetBaseAimRotation()
{
   local rotator   POVRot;

   //aim where Pawn is facing - lock pitch
      POVRot = Controller.Pawn.Rotation;
      POVRot.Pitch = 0;

      return POVRot;
}

//Handle custom player movement
function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
{
   if( Controller.Pawn == None )
    {
       return;
    }

    if (Controller.Role == ROLE_Authority)
    {
       // Update ViewPitch for remote clients
        Controller.Pawn.SetRemoteViewPitch( Controller.Rotation.Pitch );
    }

    Controller.Pawn.Acceleration = NewAccel;


   Controller.CheckJumpOrDuck();
}

//Calculate controller rotation
function UpdateRotation(float DeltaTime)
{
   local Rotator   DeltaRot, NewRotation, ViewRotation;

      ViewRotation = Controller.Rotation;

   //rotate pawn to face cursor
      if (Controller.Pawn!=none)
      Controller.Pawn.SetDesiredRotation(ViewRotation);

      DeltaRot.Yaw   = Controller.PlayerInput.aTurn;
      DeltaRot.Pitch   = 0;

      Controller.ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
      Controller.SetRotation(ViewRotation);

      NewRotation = ViewRotation;
      NewRotation.Roll = Controller.Rotation.Roll;

      if ( Controller.Pawn != None )
         Controller.Pawn.FaceRotation(NewRotation, DeltaTime);
}

defaultproperties
{
}
//This is an example from http://udn.epicgames.com/Three/BasicGameQuickStart.html 
//http://udn.epicgames.com/Three/CameraTechnicalGuide.html
class AreanaPlayerController extends GamePlayerController;

//stolen from http://udn.epicgames.com/Three/CameraTechnicalGuide.html
// function UpdateRotation( float DeltaTime )
// {
   // local Rotator   DeltaRot, newRotation, ViewRotation;

   // ViewRotation = Rotation;
   // if (Pawn!=none)
   // {
      // Pawn.SetDesiredRotation(ViewRotation);
   // }

  // Calculate Delta to be applied on ViewRotation
   // DeltaRot.Yaw   = PlayerInput.aTurn;
   // DeltaRot.Pitch   = PlayerInput.aLookUp;

   // ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   // SetRotation(ViewRotation);

   // NewRotation = ViewRotation;
   // NewRotation.Roll = Rotation.Roll;

   // if ( Pawn != None )
      // Pawn.FaceRotation(NewRotation, deltatime);
// }   


exec function ZoomIn()
{
	`Log("Zoom In!");
	AreanaPlayerCamera(PlayerCamera).ZoomIn();
}

exec function ZoomOut()
{
	`Log("Zoom In!");
	AreanaPlayercamera(PlayerCamera).ZoomOut();
}

defaultproperties
{
   //CameraClass=class'AreanaGame.AreanaPlayerCamera'
}
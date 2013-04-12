//This is an example from http://udn.epicgames.com/Three/BasicGameQuickStart.html 
//Third person camera, self modified to zoom.

//PROBLEM : With this camera when you are very close but in front, you rotate more
//looking down points you straight at ground

class AreanaPlayerCamera extends GamePlayerCamera;

var Vector CamOffset;
var float CameraXOffset, CameraYOffset, CameraZOffset;
var float CameraScale, CurrentCameraScale; /** multiplier to default camera distance */
var float CameraScaleMin, CameraScaleMax;

//Custom Variables
var float EyeHeightOnCollision;

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
   local vector     	 HitLocation, HitNormal;
   local CameraActor  	 CamActor;
   local Pawn         	 TPawn;
   
   local vector CamStart, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

 // DEBUG -- Don't know exactly why this is here, but I guess for "blending" we don't want to change
 // ViewTarget during this time.
 // Don't update outgoing viewtarget during an interpolation 
   if( PendingViewTarget.Target != None && OutVT == ViewTarget && BlendParams.bLockOutgoing )
   {
	  return;
   }

 // Default FOV on viewtarget
   OutVT.POV.FOV = DefaultFOV; //Camera set parameter.

  //Viewing through a camera actor.
   CamActor = CameraActor(OutVT.Target);
   if( CamActor != None )
   {
	  CamActor.GetCameraView(DeltaTime, OutVT.POV);

	//  Grab aspect ratio from the CameraActor.
	  bConstrainAspectRatio   = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
	  OutVT.AspectRatio      = CamActor.AspectRatio;

	 // See if the CameraActor wants to override the PostProcess settings used.
	  CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
	  CamPostProcessSettings = CamActor.CamOverridePostProcess;
   }
   else
   {
	  TPawn = Pawn(OutVT.Target);
	 // Give Pawn Viewtarget a chance to dictate the camera position.
	 // If Pawn doesn't override the camera view, then we proceed with our own defaults
	  if( TPawn == None || !TPawn.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV) )
	  {   

		 OutVT.POV.Rotation = PCOwner.Rotation;                                                   
		 CamStart = TPawn.Location; //"feet" of pawn
		 CurrentCamOffset = CamOffset; //applies the offset from our variable below
		 
		 DesiredCameraZOffset = EyeHeightOnCollision * TPawn.GetCollisionHeight() + TPawn.Mesh.Translation.Z; //Z offset of "eyes" of Pawn
		 
		 //CameraZOffset = (DeltaTime < 0.2) ? DesiredCameraZOffset * 5 * DeltaTime + (1 - 5*DeltaTime) * CameraZOffset : DesiredCameraZOffset;
		 CameraZOffset = DesiredCameraZOffset; //the other function allows less rigidity I am assuming
		 
		 //GetAxes(OutVT.POV.Rotation, CamDirX, CamDirY, CamDirZ);
	  
		//main points of camera - Update OutVT.POV.Location and OutVT.POV.Rotation
		OutVT.POV.Rotation = TPawn.Rotation; //rotation locked to the pawn the camera is the "eyes" of
		OutVT.POV.Location.X = CamStart.X + CameraXOffset;
		OutVT.POV.Location.Y = CamStart.Y + CameraYOffset;
		OutVT.POV.Location.Z = CamStart.Z + CameraZOffset;
		
		OutVT.POV.Rotation.Pitch = PCOwner.Rotation.Pitch; //up and down
		//3 options - Yaw, Pitch, Roll
			
		/*Notes:
			Camera Rotation is based off of the base of the camera (where you would hope it would be)
			so this won't work for third person (because you will rotate with your pawn, not always look at him)
			
			Cannot look up and down!
		*/
		
	  }
   }

  //Apply camera modifiers at the end (view shakes for example)
   ApplyCameraModifiers(DeltaTime, OutVT.POV);
}


function ZoomIn()
{

	CameraXOffset -= 1;
	`Log(CameraXOffset);
}
function ZoomOut()
{

	CameraXOffset += 1;
	`Log(CameraXOffset);
}


defaultproperties
{
	CameraXOffset = 0.0;
	CameraYOffset = 10.0;
	CameraZOffset = 0.0;
	
	EyeHeightOnCollision = 0.8;
}













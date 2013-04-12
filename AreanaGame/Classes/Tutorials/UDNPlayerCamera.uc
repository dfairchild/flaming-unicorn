


class UDNPlayerCamera extends Camera
   config(Camera);

var UDNPlayerController PlayerOwner; //player controller owning this camera
var UDNCameraModule CurrentCamera; //Current camera mode in use
var config string DefaultCameraClass; //class for default camera mdoe

function PostBeginPlay()
{
   local class<UDNCameraModule> NewClass;

   Super.PostBeginPlay();

   // Setup camera mode
   if ( (CurrentCamera == None) && (DefaultCameraClass != "") )
   {
      //get the default camera class to use
      NewClass = class<UDNCameraModule>( DynamicLoadObject( DefaultCameraClass, class'Class' ) );
      
      //create default camera
      CurrentCamera = CreateCamera(NewClass);
   }
}

//Initialize the PlayerCamera for the owning PlayerController
function InitializeFor(PlayerController PC)
{
   //do parent initialization
   Super.InitializeFor(PC);

   //set PlayerOwner to player controller
   PlayerOwner = UDNPlayerController(PC);
}

/**
 * Internal. Creates and initializes a new camera of the specified class, returns the object ref.
 */
function UDNCameraModule CreateCamera(class<UDNCameraModule> CameraClass)
{
   local UDNCameraModule NewCam;

   //create new camera and initialize
   NewCam = new(Outer) CameraClass;
   NewCam.PlayerCamera = self;
   NewCam.Init();

   //call active/inactive functions on new/old cameras
   if(CurrentCamera != none)
   {
      CurrentCamera.OnBecomeInactive(NewCam);
      NewCam.OnBecomeActive(CurrentCamera);
   }
   else
   {
      NewCam.OnBecomeActive(None);
   }

   //set new camera as current
   CurrentCamera = NewCam;

   return NewCam;
}

/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param   OutVT      ViewTarget to use.
 * @param   DeltaTime   Delta Time since last camera update (in seconds).
 */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
   local CameraActor   CamActor;
   local TPOV OrigPOV;
   local Vector Loc, Pos, HitLocation, HitNormal;
   local Rotator Rot;
   local Actor HitActor;

   // Don't update outgoing viewtarget during an interpolation
   if( PendingViewTarget.Target != None && OutVT == ViewTarget && BlendParams.bLockOutgoing )
   {
      return;
   }

   OrigPOV = OutVT.POV;

   // Default FOV on viewtarget
   OutVT.POV.FOV = DefaultFOV;

   // Viewing through a camera actor.
   CamActor = CameraActor(OutVT.Target);
   if( CamActor != None )
   {
      CamActor.GetCameraView(DeltaTime, OutVT.POV);

      // Grab aspect ratio from the CameraActor.
      bConstrainAspectRatio   = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
      OutVT.AspectRatio      = CamActor.AspectRatio;

      // See if the CameraActor wants to override the PostProcess settings used.
      CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
      CamPostProcessSettings = CamActor.CamOverridePostProcess;
   }
   else
   {
      // Give Pawn Viewtarget a chance to dictate the camera position.
      // If Pawn doesn't override the camera view, then we proceed with our own defaults
      if( Pawn(OutVT.Target) == None ||
         !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV) )
      {
         //Pawn didn't want control and we have a custom mode
         if(CurrentCamera != none)
         {
            //allow mode to handle camera update
            CurrentCamera.UpdateCamera(Pawn(OutVT.Target), self, DeltaTime, OutVT);
         }
         //no custom mode - use default camera styles
         else
         {
            switch( CameraStyle )
            {
               case 'Fixed'      :   // do not update, keep previous camera position by restoring
                                 // saved POV, in case CalcCamera changes it but still returns false
                                 OutVT.POV = OrigPOV;
                                 break;
   
               case 'ThirdPerson'   : // Simple third person view implementation
               case 'FreeCam'      :
               case 'FreeCam_Default':
                                 Loc = OutVT.Target.Location;
                                 Rot = OutVT.Target.Rotation;
   
                                 //OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
                                 if( CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default' )
                                 {
                                    Rot = PCOwner.Rotation;
                                 }
                                 Loc += FreeCamOffset >> Rot;
   
                                 Pos = Loc - Vector(Rot) * FreeCamDistance;
                                 // @fixme, respect BlockingVolume.bBlockCamera=false
                                 HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12));
                                 OutVT.POV.Location = (HitActor == None) ? Pos : HitLocation;
                                 OutVT.POV.Rotation = Rot;
                                 break;
   
               case 'FirstPerson'   : // Simple first person, view through viewtarget's 'eyes'
               default            :   OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
                                 break;
   
            }
         }
      }
   }

   ApplyCameraModifiers(DeltaTime, OutVT.POV);

   // set camera's location and rotation, to handle cases where we are not locked to view target
   SetRotation(OutVT.POV.Rotation);
   SetLocation(OutVT.POV.Location);
}

//pass view target initialization through to camera mode
simulated function BecomeViewTarget( PlayerController PC )
{
   CurrentCamera.BecomeViewTarget(UDNPlayerController(PC));
}

//pass zoom in through to camera mode
function ZoomIn()
{
   CurrentCamera.ZoomIn();
}

//pass zoom out through to camera mode
function ZoomOut()
{
   CurrentCamera.ZoomOut();
}

defaultproperties
{
}

















class UDNPlayerController extends UTPlayerController;

var UDNControlModule ControlModule; //player control module to use
var config string DefaultControlModuleClass; //default class for player control module

//exec function for switching to a different camera by class
exec function ChangeControls( string ClassName )
{
   local class<UDNControlModule> ControlClass;
   local UDNControlModule NewControlModule;

   ControlClass = class<UDNControlModule>( DynamicLoadObject( DefaultControlModuleClass, class'Class' ) );
   
   if(ControlClass != none)
   {
      // Associate module with PlayerController
      NewControlModule = new(Outer) ControlClass;
      NewControlModule.Controller = self;
      NewControlModule.Init();

      //call active/inactive functions on new/old modules
      if(ControlModule != none)
      {
         ControlModule.OnBecomeInactive(NewControlModule);
         NewControlModule.OnBecomeActive(ControlModule);
      }
      else
      {
         NewControlModule.OnBecomeActive(None);
      }

      ControlModule = NewControlModule;
   }
   else
   {
      `log("Couldn't get control module class!");
      // not having a Control Class is fine.  PlayerController will use default controls.
   }
}

//exec function for switching to a different camera by class
exec function ChangeCamera( string ClassName )
{
   local class<UDNCameraModule> NewClass;

   NewClass = class<UDNCameraModule>( DynamicLoadObject( ClassName, class'Class' ) );

   if(NewClass != none && UDNPlayerCamera(PlayerCamera) != none)
   {
      UDNPlayerCamera(PlayerCamera).CreateCamera(NewClass);
   }
}

//zoom in exec
exec function ZoomIn()
{
   if(UDNPlayerCamera(PlayerCamera) != none)
   {
      UDNPlayerCamera(PlayerCamera).ZoomIn();
   }
}

//zoom out exec
exec function ZoomOut()
{
   if(UDNPlayerCamera(PlayerCamera) != none)
   {
      UDNPlayerCamera(PlayerCamera).ZoomOut();
   }
}

simulated function PostBeginPlay()
{
   local class<UDNControlModule> ControlClass;
   local UDNControlModule NewControlModule;

   Super.PostBeginPlay();

   ControlClass = class<UDNControlModule>( DynamicLoadObject( DefaultControlModuleClass, class'Class' ) );
   
   if(ControlClass != none)
   {
      // Associate module with PlayerController
      NewControlModule = new(Outer) ControlClass;
      NewControlModule.Controller = self;
      NewControlModule.Init();

      //call active/inactive functions on new/old modules
      if(ControlModule != none)
      {
         ControlModule.OnBecomeInactive(NewControlModule);
         NewControlModule.OnBecomeActive(ControlModule);
      }
      else
      {
         NewControlModule.OnBecomeActive(None);
      }

      ControlModule = NewControlModule;
   }
   else
   {
      `log("Couldn't get control module class!");
      // not having a Control Class is fine.  PlayerController will use default controls.
   }
}

state PlayerWalking
{
   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      //Controller has a UDNPlayerCamera
      if(ControlModule != none)
      {
         //allow custom camera to override player movement
         ControlModule.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
      }
        else
        {
         Super.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
        }
      }
}

function UpdateRotation( float DeltaTime )
{
   //Controller has a UDNPlayerCamera
   if(ControlModule != none)
   {
      //allow custom camera to update our rotation
      ControlModule.UpdateRotation(DeltaTime);
   }
    else
    {
         Super.UpdateRotation(DeltaTime);
   }
}


/* GetPlayerViewPoint: Returns Player's Point of View
   For the AI this means the Pawn's Eyes ViewPoint
   For a Human player, this means the Camera's ViewPoint */
simulated event GetPlayerViewPoint( out vector POVLocation, out Rotator POVRotation )
{
   local float DeltaTime;
   local UTPawn P;

   P = IsLocalPlayerController() ? UTPawn(CalcViewActor) : None;

   DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
   LastCameraTimeStamp = WorldInfo.TimeSeconds;

   // support for using CameraActor views
   if ( CameraActor(ViewTarget) != None )
   {
      if ( PlayerCamera == None )
      {
         super.ResetCameraMode();
         SpawnCamera();
      }
      super.GetPlayerViewPoint( POVLocation, POVRotation );
   }
   else
   {
      //do not destroy our camera!!!
      /* if ( PlayerCamera != None )
      {
         PlayerCamera.Destroy();
         PlayerCamera = None;
      } */

      //no camera, we have view target - let view target be in control
      if ( PlayerCamera == None && ViewTarget != None )
      {
         POVRotation = Rotation;
         if ( (PlayerReplicationInfo != None) && PlayerReplicationInfo.bOnlySpectator && (UTVehicle(ViewTarget) != None) )
         {
            UTVehicle(ViewTarget).bSpectatedView = true;
            ViewTarget.CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
            UTVehicle(ViewTarget).bSpectatedView = false;
         }
         else
         {
            ViewTarget.CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
         }

         if ( bFreeCamera )
         {
            POVRotation = Rotation;
         }
      }
      //no camera, no view target - we are in control
      else if(PlayerCamera == None)
      {
         CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
         return;
      }
      //we have a camera - let camera be in control
      else
      {
         POVLocation = PlayerCamera.ViewTarget.POV.Location;
         POVRotation = PlayerCamera.ViewTarget.POV.Rotation;
         FOVAngle = PlayerCamera.ViewTarget.POV.FOV;
      }
   }

   // apply view shake
   POVRotation = Normalize(POVRotation + ShakeRot);
   POVLocation += ShakeOffset >> Rotation;

   if( CameraEffect != none )
   {
      CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
   }


   // cache result
   CalcViewActor = ViewTarget;
   CalcViewActorLocation = ViewTarget.Location;
   CalcViewActorRotation = ViewTarget.Rotation;
   CalcViewLocation = POVLocation;
   CalcViewRotation = POVRotation;

   if ( P != None )
   {
      CalcEyeHeight = P.EyeHeight;
      CalcWalkBob = P.WalkBob;
   }
}

defaultproperties
{
   CameraClass=class'UDNExamples.UDNPlayerCamera'
   MatineeCameraClass=class'UDNExamples.UDNPlayerCamera'
}
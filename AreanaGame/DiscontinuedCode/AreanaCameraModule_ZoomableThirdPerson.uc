
class AreanaCameraModule_ZoomableThirdPerson extends AreanaCameraModule;

var float CamAltitude;
var float DesiredCamAltitude;
var float MaxCamAltitude;
var float MinCamAltitude;
var float CamZoomIncrement;

//Calculate new camera location and rotation
function UpdateCamera(Pawn P, AreanaPlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
   //interpolate to new camera offest if not there
   if(CamAltitude != DesiredCamAltitude)
   {
      CamAltitude += (DesiredCamAltitude - CamAltitude) * DeltaTime * 3;
   }

   //align camera to player with height (Z) offset
   OutVT.POV.Location = OutVT.Target.Location;
   OutVT.POV.Location.Z += CamAltitude;
   
   //set camera rotation - face down
   OutVT.POV.Rotation.Pitch = -16384;
   OutVT.POV.Rotation.Yaw = 0;
   OutVT.POV.Rotation.Roll = 0;
}

//initialize new view target
simulated function BecomeViewTarget( AreanaPlayerController PC )
{
   if (LocalPlayer(PC.Player) != None)
      {
      //Set player mesh visible
        PC.SetBehindView(true);
        AreanaPawn(PC.Pawn).SetMeshVisibility(PC.bBehindView);
        PC.bNoCrosshair = true;
      }
}

function ZoomIn()
{
   //decrease camera height
   DesiredCamAltitude -= CamZoomIncrement;
   
   //lock camera height to limits
   DesiredCamAltitude = FMin(MaxCamAltitude, FMax(MinCamAltitude, DesiredCamAltitude));
}

function ZoomOut()
{
   //increase camera height
   DesiredCamAltitude += CamZoomIncrement;

   //lock camera height to limits
   DesiredCamAltitude = FMin(MaxCamAltitude, FMax(MinCamAltitude, DesiredCamAltitude));
}

defaultproperties
{
   CamAltitude=384.0
   DesiredCamAltitude=384.0
   MaxCamAltitude=1024.0
   MinCamAltitude=160.0
   CamZoomIncrement=96.0
}
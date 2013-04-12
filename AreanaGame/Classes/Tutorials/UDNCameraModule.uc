class UDNCameraModule extends Object
   abstract
   config(Camera);

//owning camera
var transient UDNPlayerCamera   PlayerCamera;

//mode-specific initialization
function Init();

/** Called when the camera becomes active */
function OnBecomeActive( UDNCameraModule OldCamera );
/** Called when the camera becomes inactive */
function OnBecomeInActive( UDNCameraModule NewCamera );

//Calculate new camera location and rotation
function UpdateCamera(Pawn P, UDNPlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT);

//initialize new view target
simulated function BecomeViewTarget( UDNPlayerController PC );

//handle zooming in
function ZoomIn();

//handle zooming in
function ZoomOut();

defaultproperties
{
}
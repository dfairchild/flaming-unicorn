class AreanaCameraModule extends Object
	abstract
	config(Camera);
	
//owning camera
var transient AreanaPlayerCamera PlayerCamera;

//mode-specific initialization
function Init();

//Called when the camera becomes active
function OnBecomeActive( AreanaCameraModule OldCamera );

//Called when the camera becomes inactive
function OnBecomeInactive( AreanaCameraModule NewCamera );

//Calculate new camera location and rotation
function UpdateCamera( Pawn P, AreanaPlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT );

//initialize new view target
simulated function BecomeViewTarget( AreanaPlayerController PC );

//handle zooming in
function ZoomIn();

//handle zooming out
function ZoomOut();

defaultproperties
{
}


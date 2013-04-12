class AreanaControlModule extends Object
	abstract
	config(Control);
	
//reference to the owning controller
var AreanaPlayerController Controller;

//mode-specific initialization
function Init();

//Called when the camera becomes active
function OnBecomeActive( AreanaControlModule OldModule );
//Called when the camera becomes inactive
function OnBecomeInactive( AreanaControlModule NewModule );

//Calculate Pawn aim rotation
simulated singular function Rotator GetBaseAimRotation();

//Handle custom player movement
function ProcessMove( float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot );

//calculate controller rotation
function UpdateRotation( float DeltaTime );

defaultproperties
{
}

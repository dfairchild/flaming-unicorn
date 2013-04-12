class UDNControlModule extends Object
   abstract
   config(Control);
   
//reference to the owning controller
var UDNPlayerController Controller;

//mode-specific initialization
function Init();

/** Called when the camera becomes active */
function OnBecomeActive( UDNControlModule OldModule );
/** Called when the camera becomes inactive */
function OnBecomeInActive( UDNControlModule NewModule );

//Calculate Pawn aim rotation
simulated singular function Rotator GetBaseAimRotation();

//Handle custom player movement
function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

//Calculate controller rotation
function UpdateRotation(float DeltaTime);

defaultproperties
{
}
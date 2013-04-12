//This is an example from http://udn.epicgames.com/Three/BasicGameQuickStart.html 
//http://udn.epicgames.com/Three/CameraTechnicalGuide.html
class AreanaPlayerController extends GamePlayerController;



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
   CameraClass=class'AreanaGame.AreanaPlayerCamera'
}
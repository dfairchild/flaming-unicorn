//This is an example from http://udn.epicgames.com/Three/BasicGameQuickStart.html 
//Gametype - determines rules of the game and conditions under which it progresses or ends
//tells engine which classes to use for PlayerControllers Pawns HUD etc. 
//this simply specifies which classes to use

class AreanaGame extends FrameworkGame;

defaultproperties
{
   PlayerControllerClass=class'AreanaGame.AreanaPlayerController'
   DefaultPawnClass=class'AreanaGame.AreanaPawn'
   HUDType=class'AreanaGame.AreanaHUD'
   bDelayedStart=false
}
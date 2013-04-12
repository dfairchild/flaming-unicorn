//This is an example from http://udn.epicgames.com/Three/BasicGameQuickStart.html 
//Pawn controlls how player interacts with world (visuals)

class AreanaPawn extends Pawn;

class UDNPawn extends UTPawn;

/* BecomeViewTarget
   Called by Camera when this actor becomes its ViewTarget */
simulated event BecomeViewTarget( PlayerController PC )
{
   local UDNPlayerController UDNPC;

   UDNPC = UDNPlayerController(PC);

   //Pawn is controlled by a UDNPlayerController and has a UDNPlayerCamera
      if(UDNPC != none && UDNPlayerCamera(UDNPC.PlayerCamera) != none)
      {
      //allow custom camera to control mesh visibility, etc.
      UDNPlayerCamera(UDNPC.PlayerCamera).BecomeViewTarget(UDNPC);
      }
      else
      {
      Super.BecomeViewTarget(PC);
   }
}

/**
 *   Calculate camera view point, when viewing this pawn.
 *
 * @param   fDeltaTime   delta time seconds since last update
 * @param   out_CamLoc   Camera Location
 * @param   out_CamRot   Camera Rotation
 * @param   out_FOV      Field of View
 *
 * @return   true if Pawn should provide the camera point of view.
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   //return false to allow custom camera to control its location and rotation
      return false;
}

/**
 * returns base Aim Rotation without any adjustment (no aim error, no autolock, no adhesion.. just clean initial aim rotation!)
 *
 * @return   base Aim rotation.
 */
simulated singular event Rotator GetBaseAimRotation()
{
      local vector   POVLoc;
      local rotator   POVRot;
      local UDNPlayerController PC;

   PC = UDNPlayerController(Controller);

   //Pawn is controlled by a UDNPlayerController and has a UDNPlayerCamera
      if(PC != none && PC.ControlModule != none)
      {
      //allow custom camera to control aim rotation
      return PC.ControlModule.GetBaseAimRotation();
      }
      else
      {
         if( Controller != None && !InFreeCam() )
         {
            Controller.GetPlayerViewPoint(POVLoc, POVRot);
            return POVRot;
         }
         else
         {
            POVRot = Rotation;

            if( POVRot.Pitch == 0 )
            {
               POVRot.Pitch = RemoteViewPitch << 8;
            }

            return POVRot;
         }
      }
}


defaultproperties
{
}

// defaultproperties
// {
   // WalkingPct=+0.4
   // CrouchedPct=+0.4
   // BaseEyeHeight=38.0
   // EyeHeight=38.0
   // GroundSpeed=440.0
   // AirSpeed=440.0
   // WaterSpeed=220.0
   // AccelRate=2048.0
   // JumpZ=322.0
   // CrouchHeight=29.0
   // CrouchRadius=21.0
   // WalkableFloorZ=0.78
   
   // Components.Remove(Sprite)

   // Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
      // bSynthesizeSHLight=TRUE
      // bIsCharacterLightEnvironment=TRUE
      // bUseBooleanEnvironmentShadowing=FALSE
   // End Object
   // Components.Add(MyLightEnvironment)
   // LightEnvironment=MyLightEnvironment

   // Begin Object Class=SkeletalMeshComponent Name=WPawnSkeletalMeshComponent
      // Your Mesh Properties
      // SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
      // AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
      // PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
      // AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
      // Translation=(Z=8.0)
      // Scale=1.075
     // General Mesh Properties
      // bCacheAnimSequenceNodes=FALSE
      // AlwaysLoadOnClient=true
      // AlwaysLoadOnServer=true
      // bOwnerNoSee=false
      // CastShadow=true
      // BlockRigidBody=TRUE
      // bUpdateSkelWhenNotRendered=false
      // bIgnoreControllersWhenNotRendered=TRUE
      // bUpdateKinematicBonesFromAnimation=true
      // bCastDynamicShadow=true
      // RBChannel=RBCC_Untitled3
      // RBCollideWithChannels=(Untitled3=true)
      // LightEnvironment=MyLightEnvironment
      // bOverrideAttachmentOwnerVisibility=true
      // bAcceptsDynamicDecals=FALSE
      // bHasPhysicsAssetInstance=true
      // TickGroup=TG_PreAsyncWork
      // MinDistFactorForKinematicUpdate=0.2
      // bChartDistanceFactor=true
      // RBDominanceGroup=20
      // bUseOnePassLightingOnTranslucency=TRUE
      // bPerBoneMotionBlur=true
   // End Object
   // Mesh=WPawnSkeletalMeshComponent
   // Components.Add(WPawnSkeletalMeshComponent)

   // Begin Object Name=CollisionCylinder
      // CollisionRadius=+0021.000000
      // CollisionHeight=+0044.000000
   // End Object
   // CylinderComponent=CollisionCylinder
// }
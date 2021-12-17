program animation_test;

{$MODE objfpc}

uses cmem, raylib, rlgl;

const
	screenWidth = 800;
	screenHeight = 450;

var
  cam: TCamera;
  model : TModel;
  texture : TTexture2D;
  position : TVector3;
  animsCount, animFrameCounter : Integer;
  anims : PModelAnimation;
  i : Integer;

procedure DrawModelFx(AModel:TModel; APosition:TVector3; AAxis:TVector3; AAngle:Single; AScale:Single; ATint:TColor);
var
  Scale:TVector3;
begin
  Scale:=Vector3Create(AScale,AScale,AScale);
  DrawModelEx(AModel, APosition, AAxis, AAngle, Scale, ATint);
end;

begin

	InitWindow(screenWidth, screenHeight, 'Animation Test');	

	cam.position := Vector3Create(15.0, 15.0, 15.0);
	cam.target := Vector3Create(0.0,0.0,0.0);
	cam.up := Vector3Create(0.0, 1.0, 0.0);
	cam.fovy := 45.0;
	cam.projection := CAMERA_PERSPECTIVE;

	model := LoadModel('resources/models/iqm/guy.iqm');
	texture := LoadTexture('resources/models/iqm/guytex.png');
	SetMaterialTexture(@model.materials[0], MATERIAL_MAP_DIFFUSE, texture);

	position := Vector3Create(0.0,0.0,0.0);

	// Load Animation Data
	animsCount := 0;
	anims := LoadModelAnimations('resources/models/iqm/guy.iqm', @animsCount);
	animFrameCounter := 0;

	WriteLn('animsCount: ', animsCount);

	SetCameraMode(cam, CAMERA_FREE);

	SetTargetFPS(60);

	while not WindowShouldClose() do
	begin
		// Test that we are receiving the Struct data back correctly (YES)
		//mousePos := GetMousePosition();
		//WriteLn('Mouse Pos: ', FloatToStr(mousePos.x), ', ', FloatToStr(mousePos.y));

		UpdateCamera(@cam);

		if IsKeyDown(KEY_SPACE) then
		begin
			inc(animFrameCounter);
			UpdateModelAnimation(model, anims[0], animFrameCounter);
			if animFrameCounter >= anims[0].frameCount then
				animFrameCounter := 0;
		end;

		BeginDrawing();
			ClearBackground(RAYWHITE);
			BeginMode3d(cam);
		                DrawModelFx(model, position, Vector3Create(1.0, 0.0, 0.0), -90, 1, WHITE); //fix for wondows tnx realmworksxyz
				for i := 0 to model.boneCount - 1 do
				begin
				  DrawCube(anims[0].framePoses[animFrameCounter][i].translation, 0.2, 0.2, 0.2, RED);
				end;
				DrawGrid(10, 1.0);
                       EndMode3D();
			DrawFPS(10, 10);
		EndDrawing();
	end;
	UnloadTexture(texture);
	for i := 0 to animsCount - 1 do
		UnloadModelAnimation(anims[i]);
	
        Free(anims);
	UnloadModel(model);
	CloseWindow();
end.

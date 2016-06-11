program MarioAtUni;
uses SwinGame, sgTypes, SysUtils, sgGraphics, DateUtils, 
	//Mario specific libraries	
	LoadResources, Score;

const 
	//Set values for level grid
	COLUMNS = 3000; 	//across
	ROWS = 25;		//down
	//Cell size is width and height
	CELL_WIDTH = 20;	

type 
	// g = ground1 r = ground2 s = smash block i = itemBox n = normalBlock
	ObjectKind = (cloud, ground, ground2, smash, item, normalBlock, nothing, pipe1, pipe2, pipe3, pipe4, pipe5, pipe6);
	Characterkind = (player, gumba, turtle);
	
	objectData = record
		kind: ObjectKind;
		bmp: bitmap;
		xPos, yPos: integer;
		width, height: integer; 
	end;
	
	//Level Data for populating Mario level
	type levelObjects = array [0..COLUMNS-1, 0.. ROWS-1] of ObjectKind;	

	marioData = record
		kind: Characterkind;
		bmp: bitmap;
		xPos, yPos: double;
		jumpedY: boolean;
		movingX: boolean;
		pipeTravelled: boolean;
		speedX, speedY: double;
		enhanceMoving: double;

	end;	

procedure ReadFile(var level: levelObjects; var levelLoadNumber: integer);
var
	tfIn: TextFile;
	s: string;
	i, x, y: integer;	
	xPos, width, yPos, height: string;
	fileRead: objectData;
begin	
	  // Give some feedback
	  writeln('Loading text file');
 
	 // Set the name of the file that will be read
	if (levelLoadNumber = 1) then
	begin 
		AssignFile(tfIn, 'levelLoad.txt');
		reset(tfIn); 
	end
	else if (levelLoadNumber = 2) then
	begin 
		AssignFile(tfIn, 'levelLoad2.txt');
		reset(tfIn); 
	end
	else if (levelLoadNumber = 3) then
	begin 
		AssignFile(tfIn, 'levelLoad3.txt');
		reset(tfIn); 
	end;
	// Keep reading lines until the end of the file is reached
	while not eof(tfIn) do
	begin 
		readln(tfIn, s);
		for i := 0 to (length(s)-1) do
		begin
			if (s[i] = '*') then
			begin
				//Read through (doing nothing) until end of Notes				
			end
			else if (s[i] = '/') then
			begin
				if(s[i+1] = 'g') then
				begin
					fileRead.kind	:= ground;
				end
				else if(s[i+1] = 'c') then
				begin
					fileRead.kind	:= cloud;
				end
				else if (s[i+1] = 'r') then
				begin
					fileRead.kind	:= ground2;
				end
				else if (s[i+1] = '1') then
				begin
					fileRead.kind	:= pipe1;
				end
				else if (s[i+1] = '2') then
				begin
					fileRead.kind	:= pipe2;
				end
				else if (s[i+1] = '3') then
				begin
					fileRead.kind	:= pipe3;
				end
				else if (s[i+1] = '4') then
				begin
					fileRead.kind	:= pipe4;
				end
				else if(s[i+1] = 's') then
				begin
					fileRead.kind	:= smash;
				end
				else if (s[i+1] = 'i') then
				begin
					fileRead.kind	:= item;
				end
				else if (s[i+1] = 'n') then
				begin
					fileRead.kind	:= normalBlock;
				end;
				//Read in integer ranges from their exact position within data segment e.g - /g, 12, 12, 12, 12/
				xPos := ConCat(s[i+3], s[i+4], s[i+5]);
				width := ConCat(s[i+7], s[i+8], s[i+9]);
				yPos := ConCat(s[i+11], s[i+12], s[i+13]);
				height := ConCat(s[i+15], s[i+16], s[i+17]);
				
				//Convert text string data to integers
				fileRead.xPos := StrToInt(xPos);
				fileRead.width := StrToInt(width);				
				fileRead.yPos := StrToInt(yPos);
				fileRead.height := StrToInt(height);

				//using ranges read in, assign block kinds to level data
				for x := fileRead.xPos to fileRead.width do
				begin
					for y := fileRead.yPos to fileRead.height do
					begin
						level[x,y] := fileRead.kind;
					end;
				end;
			end;
			if (s[i] = '#') then
			begin
				SeekEOF;
			end;		
		end;	
	end;
	CloseFile(tfIn); 
	levelLoadNumber += 1;
end;

//Level array is populated as 'nothing' kind prior to recieving fileRead blocks

procedure populateLevelArray(var level: levelObjects);
var
	x, y: integer;

begin
	for x := 0 to high(level) do
	begin
		for y := 0 to high(level[x]) do
		begin
			level[x,y] := nothing;
		end;
	end;
end;

//Populate number of levels needed with the above function

procedure populateLevel(var level: levelObjects; var level2: levelObjects);
begin	
	populateLevelArray(level);
	populateLevelArray(level2);	
end;

//Populate with nothing then read from text files to fill them

procedure LoadLevels(var level: levelObjects; var level2: levelObjects; var level3: levelObjects);
var
	//Set the number of leavels to load
	levelLoadNumber: integer;

begin
	levelLoadNumber := 1;
	//Needed for level with 2 in one
	populateLevel(level,level2);

	populateLevelArray(level3);
	ReadFile(level, levelLoadNumber);
	ReadFile(level2, levelLoadNumber);	
	ReadFile(level3, levelLoadNumber);

end;

//Character starting data

procedure LoadCharacters(var mario: marioData);
begin	
	mario.bmp := BitmapNamed('marioWalkRight');
	mario.kind := player;
	mario.jumpedY := false;
	mario.pipeTravelled := false;
	mario.xPos := 200;
	mario.yPos := 360;
	mario.speedX := 0;
	mario.speedY := 0;	 	
	mario.enhanceMoving := 1;
end;

//Load Monserts - Randomly generated pos's and speed

procedure LoadMonsters(var monster: marioData);
begin	
	monster.bmp := BitmapNamed('turtle');
	monster.kind := turtle;
	monster.jumpedY := false;
	monster.xPos := (Round((Random(170)))*20)+640;
	monster.yPos := Round(Random(21)*20); //21 to avoid spawning below ground
	monster.speedX := (Random(3) mod 3)-1;
	if monster.speedX = 0 then 
	begin
		monster.speedX := -1;
	end;
	monster.speedY := -1;	 	
end;

//Array of monsters is iterated through and populated

procedure LoadMonsterGroup(var monsters: array of marioData);
var 
	i: integer;

begin
	for i:= 0 to high(monsters) do
	begin
		LoadMonsters(monsters[i]);
	end;
end;


//Changes bmp depending on which way he is facing

procedure MarioAnimation(var mario: marioData);
var
	stanceSet: boolean;

begin
	if AnyKeyPressed() then
	begin
		stanceSet := false;
	end;

	if not(stanceSet) then
	begin
		if KeyTyped(RightKey) then
		begin
			mario.bmp := BitMapNamed('marioWalkRight');
			stanceSet := true;
		end	
		else  if KeyTyped(LeftKey) then
		begin
			mario.bmp := BitMapNamed('marioWalkLeft');	
			stanceSet := true;
		end;
	end;
end;

//Conversion of speed data changes to changes in xPos

procedure ChangeSpeed(var mario: marioData);
begin
	mario.xPos := round(mario.xPos + mario.speedX);
	mario.yPos := round(mario.yPos - mario.speedY);
end;

//Control player inputs relative to game data

procedure ControlPlayerInputX(var mario: marioData);
begin
	if (mario.speedX < 5) and (mario.speedX > -5) then
	begin
		if (mario.jumpedY) then 
		begin
			if (mario.speedX > 0) then
			begin
				if KeyDown(RightKey) then
				begin
					mario.speedX := mario.speedX+0.2;				
				end
				else 
				if KeyDown(LeftKey) then
				begin
					mario.speedX := mario.speedX-0.2;				
				end;
				if (mario.speedX <= 0) then
				begin
					mario.speedX := mario.speedX -0.1;						
				end;
			end
			else if (mario.speedX < 0) then
			begin			
				if KeyDown(LeftKey) then		
				begin
					mario.speedX := mario.speedX - 0.2;
				end;
				if KeyDown(RightKey) then
				begin
					mario.speedX := mario.speedX+0.2;				
				end;
				if (mario.speedX >= 0) then
				begin
					mario.speedX := mario.speedX +0.1;						
				end;
			end;			
		end;

		if not(mario.jumpedY) then
		begin
			if KeyDown(RightKey) then
			begin			
					mario.speedX := mario.speedX + 0.2*(mario.enhanceMoving);			
			end;
			if KeyDown(LeftKey) then
			begin
				mario.speedX := mario.speedX - 0.2*(mario.enhanceMoving);
				
			end;		
		end;
	end;			
end;

//Control player inputs relative to game data

procedure ControlPlayerInputY(var mario: marioData);
begin
	if not(mario.jumpedY) then
	begin
		if KeyTyped(spaceKey) and (mario.yPos > 0) then
		begin
			mario.speedY := 6*(mario.enhanceMoving);
			mario.jumpedY := true;			
		end;
	end;
end; 

//Checking if close to pipe and changing location

procedure checkForPipe(var levelSelect: integer; var mario: marioData);
begin
	if KeyTyped(DownKey) then
	begin
		if (mario.xPos > 2000) then
		begin
			if (levelSelect = 1) then
			begin	
				PlaySoundEffect('pipe.wav');
				Delay(2000);
				levelSelect := levelSelect + 1;		
				repeat
				until (SoundEffectPlaying('pipe.wav'));
				mario.xPos := 280;
				mario.yPos := 360;				
				mario.pipeTravelled := true;
			end
			else if (levelSelect = 2) then
			begin	
				PlaySoundEffect('pipe.wav');
				Delay(2000);
				levelSelect := levelSelect + 1;	

				mario.xPos := 40;
				mario.yPos := 420;	
				repeat
				until (SoundEffectPlaying('pipe.wav'));
				mario.pipeTravelled := true;
			end
			else if (levelSelect = 3) then
			begin	
				PlaySoundEffect('pipe.wav');
				Delay(2000);
				levelSelect := levelSelect + 1;		
				repeat
				until (SoundEffectPlaying('pipe.wav'));
				mario.xPos := 270;
				mario.yPos := 380;				
				mario.pipeTravelled := true;
			end;			
		end;	
	end;
end;

//Collision check for intersection between monster and x-dimension blocks

procedure CheckForcollisionMonsterX(var mario: marioData; var monster: marioData; var die: boolean); 
begin	
	begin
		if(mario.speedX >= 0) then
		begin
			if ((round(mario.xPos + BitMapWidth(mario.bmp))) >= (monster.xPos+2)) then 			
			begin
				if(round(mario.xPos + BitMapWidth(mario.bmp))) <= (round(monster.xPos+CELL_WIDTH-2)) then
				begin
					if((round(mario.yPos + BitMapHeight(mario.bmp))) >= (monster.yPos+2)) and ((round(mario.yPos) <= (monster.yPos+ CELL_WIDTH-2))) then
					begin
						die := true;						
					end; 
				end;
			end
		end;
		if (mario.speedX < 0) then
		begin
			if (round(mario.xPos) <= (round(monster.xPos+CELL_WIDTH-2))) then			
			begin
				if ((round(mario.xPos + BitMapWidth(mario.bmp))) >= (monster.xPos+2)) then
				begin
					if((round(mario.yPos + BitMapHeight(mario.bmp))) >= (monster.yPos+2)) and ((round(mario.yPos) <= (monster.yPos+ CELL_WIDTH-2))) then
					begin
						die := true;
					end;
				end; 
			end;
		end;
	end;
end;

//Collision check for intersection between monster and y-dimension blocks
		
procedure CheckForcollisionMonster(var mario: marioData; var monster: marioData; var hit: boolean; var die: boolean);		
begin
	if (mario.speedY <= 0) then	
	begin
		if ((round(mario.yPos + BitMapHeight(mario.bmp))) >= (monster.yPos)) and ((round(mario.yPos + BitMapHeight(mario.bmp))) <= (round(monster.yPos+CELL_WIDTH))) then
		begin
			if((round(mario.xPos + BitMapWidth(mario.bmp))) >= (monster.xPos)) and ((round(mario.xPos) <= (monster.xPos + CELL_WIDTH))) then
			begin
				if (KeyDown(spaceKey)) then
				begin
					mario.speedY := 8;
				end
				else
				begin
					mario.speedY := 4;
				end;
				mario.yPos := (monster.yPos)-round(BitMapHeight(mario.bmp));
				mario.jumpedY := true;	
				hit := true;				
			end; 
		end;
	end
	else if (mario.speedY > 0) then	
	begin
		if((round(mario.xPos + BitMapWidth(mario.bmp))) >= (monster.xPos)) and ((round(mario.xPos) <= (monster.xPos+ CELL_WIDTH))) then		
		begin
			if ((round(mario.yPos) <= (monster.yPos))) and (round(mario.yPos) >= round(monster.yPos)) then			
			begin	
				die := true;			
			end; 
		end;
	end;
end;

//Collision check for intersection between mario and x-dimension blocks

procedure CheckForcollisionX(var mario: marioData; x,y: integer); 
begin	
	begin
		if(mario.speedX >= 0) then
		begin
			if ((round(mario.xPos + BitMapWidth(mario.bmp))) >= (x*CELL_WIDTH)) then 			
			begin
				if(round(mario.xPos + BitMapWidth(mario.bmp))) <= (round(x*CELL_WIDTH+5)) then
				begin
					if((round(mario.yPos + BitMapHeight(mario.bmp))) >= (y*CELL_WIDTH+5)) and ((round(mario.yPos) <= (y*CELL_WIDTH + CELL_WIDTH))) then
					begin
						if (mario.kind = turtle) then
						begin
							mario.speedX := mario.speedX*1; 
							mario.jumpedY := true;
						end;
						if not(mario.jumpedY) then 
						begin
							mario.speedX := 0;
						end;					
						mario.xPos := x*CELL_WIDTH-round(BitMapWidth(mario.bmp)+1);
						
					end; 
				end;
			end
		end;
		if (mario.speedX < 0) then
		begin
			if (round(mario.xPos) <= (round(x*CELL_WIDTH+CELL_WIDTH))) then			
			begin
				if ((round(mario.xPos + BitMapWidth(mario.bmp))) >= (x*CELL_WIDTH+15)) then
				begin
					if((round(mario.yPos + BitMapHeight(mario.bmp))) >= (y*CELL_WIDTH+10)) and ((round(mario.yPos) <= (y*CELL_WIDTH + CELL_WIDTH))) then
					begin
						
						if (mario.kind = turtle) then
						begin
							mario.speedX := mario.speedX*-1; 
							mario.jumpedY := true;
						end;
						if not(mario.jumpedY) then 
						begin
							mario.speedX := 0;
						end;												
						mario.xPos := (x*CELL_WIDTH)+CELL_WIDTH+1;
						
					end;
				end; 
			end;
		end;
	end;
end;

//Collision check for intersection between mario and y-dimension blocks
		
procedure CheckForcollision(var mario: marioData; x,y: integer; var hit: boolean; var levelSelect: integer; var cloudChange1: boolean; var cloudChange2: boolean; var cloudCheck: boolean);		
begin
	if (mario.speedY <= 0) then	
	begin
		if ((round(mario.yPos + BitMapHeight(mario.bmp))) >= (y*CELL_WIDTH)) and ((round(mario.yPos + BitMapHeight(mario.bmp))) <= (round(y*CELL_WIDTH+10))) then
		begin
			if((round(mario.xPos + BitMapWidth(mario.bmp))) >= (x*CELL_WIDTH)) and ((round(mario.xPos) <= (x*CELL_WIDTH + CELL_WIDTH))) then
			begin
				mario.speedY := 0;
				mario.yPos := (y*CELL_WIDTH)-round(BitMapHeight(mario.bmp));
				mario.jumpedY := false;	
				if (cloudCheck) and KeyDown(RightKey) then
				begin
					cloudChange1 := true; 
				end
				else if (cloudCheck) and KeyTyped(DownKey) then
				begin
					cloudChange2 := true;
				end;
			end; 
		end;
	end
	else if (mario.speedY > 0) then	
	begin
		if((round(mario.xPos + BitMapWidth(mario.bmp))) >= (x*CELL_WIDTH+2)) and ((round(mario.xPos) <= (x*CELL_WIDTH + CELL_WIDTH-2))) then		
		begin
			if ((round(mario.yPos) <= (y*CELL_WIDTH + CELL_WIDTH))) and (round(mario.yPos) >= round(y*CELL_WIDTH)) then			
			begin	
				mario.speedY := -1;
				mario.yPos := (y*CELL_WIDTH) + CELL_WIDTH+1;
				mario.jumpedY := false;
				hit := true;			
			end; 
		end;
	end;

	//Check that If Mario walks off a ledge we still set that he 'has jumped'
	if not(mario.speedY = 0) then
	begin
		mario.jumpedY := true;
	end;
end;

//Check which 'kind' a block is and draw it's corresponding bitmap

procedure DrawBlocks(level: levelObjects);
var 
	i, j: integer;

begin
	for i := 0 to high(level) do
	begin
		for j := 0 to high(level[i]) do
		begin
			if (level[i,j] = ground) then
			begin
				DrawBitmap(BitmapNamed('ground'), i*CELL_WIDTH, j*CELL_WIDTH);
			end			
			else if (level[i,j] = ground2) then
			begin
				DrawBitmap(BitmapNamed('ground2'), i*CELL_WIDTH, j*CELL_WIDTH);
			end			
			else if (level[i,j] = smash) then
			begin
				DrawBitmap(BitmapNamed('smash'), i*CELL_WIDTH, j*CELL_WIDTH);
			end			
			else if (level[i,j] = item) then
			begin
				DrawBitmap(BitmapNamed('item'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = normalBlock) then
			begin
				DrawBitmap(BitmapNamed('normalBlock'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = pipe1) then
			begin
				DrawBitmap(BitmapNamed('pipe1'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = pipe2) then
			begin
				DrawBitmap(BitmapNamed('pipe2'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = pipe3) then
			begin
				DrawBitmap(BitmapNamed('pipe3'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = pipe4) then
			begin
				DrawBitmap(BitmapNamed('pipe4'), i*CELL_WIDTH, j*CELL_WIDTH);
			end
			else if (level[i,j] = cloud) then
			begin
				DrawBitmap(BitmapNamed('cloud'), i*CELL_WIDTH, j*CELL_WIDTH);
			end;				
		end;	
	end;
end;

//Applying gravity and wind/ground friction in both the y and x dimensions respecitvely

procedure Deceleration(var mario: marioData);
begin
	begin	
		begin
			if(mario.speedX > 0) and (mario.kind = player) then
			begin
				mario.speedX -= 0.1;			
			end
			else if (mario.speedX < 0) and (mario.kind = player) then
			begin
				mario.speedX += 0.1;
			end;
		end;
		
		if (mario.speedY <= 0) then
		begin
			if not(mario.speedY < -7.25) then //If mario falling long distance, it will cap (-)speedY to same as max 
			begin							  // (+)speedY in jumping
				mario.speedY -= 0.25;
			end;
		end;
		
		if (mario.speedY > 0) then 
		begin
			if (mario.speedY > 0) then
			begin
				mario.speedY -= 0.25;			
			end;
		end;
	end;
end;

//Called for both speedchange and gravity etc.

procedure Physics(var mario: marioData);
begin
	Deceleration(mario);
	ChangeSpeed(mario);
end;

//Jump sound when jumping in game

procedure PlayJump(mario: marioData);
begin
	if (KeyTyped(spaceKey)) and (mario.jumpedY = false) then
	begin
		PlaySoundEffect('marioJump.wav');
	end;
end;

//Checking through 2d array of level data and checking character against any potential collisions

procedure CheckForcollisionLevel(var level: levelObjects; var mario: marioData; var hit: boolean; var levelSelect: integer);
var 
	x,y,
	marioWidth: integer;
	marioHeight: integer;
	cloudCheck, cloudChange1, cloudChange2: boolean;

begin					
	marioWidth := round(BitMapWidth(mario.bmp));
	marioHeight := round(BitMapHeight(mario.bmp));	
	cloudCheck := false;		
	cloudChange1 := false;		 
	cloudChange2 := false;	


	for x := 0 to high(level) do
	begin
		for y := 0 to high(level[x]) do
		begin
			if not(level[x,y] = nothing) then
			begin				
				//Check if x or y 2D kind array data (expanded to blocksize 20) is within the immediate surroundings of the character position	
				if (x*20 > (mario.xPos-30)) and (x*20 < mario.xPos + marioWidth+10) then
				begin
					if (y*20 > (mario.yPos-10)) and (y*20 <	 mario.yPos + (marioHeight+10)) then
					begin
						//Check if cloud to access hidden cloud on level 3
						if (level[x,y] = cloud) then
						begin
							cloudCheck := true;
						end;

						//DrawRectangle(colorRed, (x*20), y*20, 20, 20);
						CheckForcollision(mario, x, y, hit, levelSelect, cloudChange1, cloudChange2, cloudCheck);
						CheckForcollisionX(mario, x, y);
						if (level[x,y] = pipe1) then
						begin
							checkForPipe(levelSelect, mario);
						end;	
					end;
					
					//Allows access to hidden cloud in level 3
					if (cloudChange1 = true) then
					begin
						level[x+1,y] := cloud; 
						level[x-1,y] := nothing;
					end;
					if (cloudChange2 = true) then
					begin
						mario.yPos -= 10;
						level[x,y-1] := cloud; 
						level[x,y] := nothing;   
					end;
					cloudCheck := false;		
					cloudChange1 := false;		 
					cloudChange2 := false;		
				end;
				//Check for smash block contact and change type				
				if(hit)then
				begin
					if (level[x,y] = smash) then
					begin
						level[x,y] := nothing;
						hit := false;
						PlaySoundEffect('brickBreak.wav');
					end;					
				end;
				hit := false;				
			end;
		end;		
	end;
end;

//Perform checks for all monster chracters

procedure MonsterData(var mario: marioData; var monsters: array of marioData; var level: levelObjects; var hit: boolean; var levelSelect: integer;  var die: boolean);
var 
	i: integer;
begin

	for i := 0 to high(monsters) do
		begin
			CheckForcollisionLevel(level, monsters[i], hit, levelSelect);
			if (monsters[i].xPos > CameraX()) and (monsters[i].xPos < CameraX() + ScreenWidth() + 350) then
			begin				
				Physics(monsters[i]);
				DrawBitmap(monsters[i].bmp, monsters[i].xPos, monsters[i].yPos);
				CheckForcollisionMonster(mario, monsters[i], hit, die);	
				CheckForcollisionMonsterX(mario, monsters[i], die);
				if (hit) then
				begin
					monsters[i].xPos := 0;
					monsters[i].yPos := 490;					
					hit := false;
					PlaySoundEffect('koopaDeath.wav');
				end;
	
			end;
		end;
end;

//Different level backgrounds

procedure DrawBackground(levelSelect: integer);
begin
	case(levelSelect) of
	1:	begin
			DrawBitmap(BitmapNamed('blockBackground'), CameraX(), 0);
		end;
	2:	begin
			DrawBitmap(BitmapNamed('undergroundMap'), CameraX(), 0);
		end;
	3:	begin
			DrawBitmap(BitmapNamed('marioBackground'), CameraX(), 0);	
		end;
	4:	begin
			DrawBitmap(BitmapNamed('finish'), CameraX(), 0);
			DrawBitmap(BitmapNamed('HD'), CameraX()+200, 200);
		end;
	end;
end;



//Check if he falls off edge if true, return dead

procedure EndGame(mario: marioData; var die: boolean);	
begin	
	if (mario.yPos > 480) then
	begin
		die := true;
	end;
end;

//Following a death, used to reset position and slowly load game

procedure Restart(var die: boolean; var mario: marioData; var life: integer; var levelSelect: integer);
var
	deathTimer: Timer;
    ticks: Integer;

begin
	deathTimer := CreateTimer();
	if (die) then
	begin
		//Waits some time before re-spawning
	    StartTimer(deathTimer);
	    repeat 
	    	ticks := TimerTicks(deathTimer);   	
	   	until (ticks < 600); 
		LoadCharacters(mario);
		die := false;
		life := life - 1;

		//Travelling through pipes is our ending and starting of each level - by attaching this data to Mario it can easily be checked throughout the program
		mario.pipeTravelled := true;
	end;
end;

//Checks for end of game and executes required functions

procedure CheckForEndOfGame(var mario: marioData; var die: boolean; var life: integer; var levelSelect: integer);
begin
	EndGame(mario, die); 

	if (die) then
	begin
		StopSoundEffect('soundtrack.wav');
		PlaySoundEffect('death.wav', 1);
		while SoundEffectPlaying('death.wav') do
		begin
			//wait until sound effect finished	
		end;
	end;
	//Keep Lives updated
	DrawScore(life);

	//Reset position and important data when Mario dies
	Restart(die, mario, life, levelSelect);
end;

//Play Sound Track indefinetely!

procedure PlaySoundtrack();
begin
	if not(SoundEffectPlaying('soundtrack.wav')) then
	begin
		PlaySoundEffect('soundtrack.wav');
	end;
end;

//Combining the player control checkers

procedure PlayerInputs(var mario: marioData);
begin	
	ControlPlayerInputY(mario);	
	ControlPlayerInputX(mario);	
end;

//Combining Mario data requirements

procedure MarioChanges(var mario: marioData);
begin
	if (KeyDown(AltKey)) then
	begin
		mario.enhanceMoving := 1.2;
	end;			
	PlayerInputs(mario);
	MarioAnimation(mario);
	Physics(mario);	
	DrawBitmap(mario.bmp, mario.xPos, mario.yPos);
end;

//Position Camera to follow Mario or for level 3 in which it is timed to move quickly through the level (scanning cam)

procedure SetCamera(var mario: marioData; levelSelect: integer);
begin
	if (levelSelect = 3) then
	begin	
		if (mario.pipeTravelled) then
		begin
			//Used to reset camera to beginning of level before the scanning cam begins
			SetCameraX(round(mario.xPos-ScreenWidth()/2));
		end;
		MoveCameraBy((mario.xPos-mario.xPos+1), 0);			
	end
	else
	begin
		//Standard camera that follows Mario
		SetCameraX(round(mario.xPos-ScreenWidth()/2));		
	end;
	mario.pipeTravelled := false;
end;

//Populates the window with diffeent data sets depending on levelSelect (i.e. 1 or 2)

procedure LevelData(var level:levelObjects; var level2:levelObjects; var mario: marioData; monsters: array of marioData; hit: boolean; var levelSelect: integer);
begin		
	SetCamera(mario, levelSelect);

	//Data relative to Level is 
	if (levelSelect = 1) then
	begin
		DrawBackground(levelSelect);	
		CheckForcollisionLevel(level, mario, hit, levelSelect);		
		DrawBlocks(level);
		if (mario.pipeTravelled) then
		begin			
			LoadMonsterGroup(monsters);
		end;
	end
	else if(levelSelect = 2) then
	begin	
		DrawBackground(levelSelect);			
		CheckForcollisionLevel(level2, mario, hit, levelSelect);
		DrawBlocks(level2);
		if (mario.pipeTravelled) then
		begin			
			LoadMonsterGroup(monsters);
		end;
	end
	else if(levelSelect = 3) then
	begin	
		DrawBackground(levelSelect);			
		CheckForcollisionLevel(level2, mario, hit, levelSelect);
		DrawBlocks(level2);
		if (mario.pipeTravelled) then
		begin			
			LoadMonsterGroup(monsters);
		end;
	end;	
		
	//Update Mario is the same constant regardless of which level is chosen	
	MarioChanges(mario);	
end;

procedure Sounds(mario: marioData);
begin
	PlaySoundtrack();
	PlayJump(mario);
end;

procedure LoadLevelData(var level: levelObjects; var level2: levelObjects; var level3: levelObjects; var mario: marioData; var monsters: array of marioData);
begin	
	LoadLevels(level, level2, level3);	
	LoadCharacters(mario);
	LoadMonsterGroup(monsters);
end;

procedure Main();
var 	
	mario: marioData;
	monsters: array [0..40] of marioData;
	life, levelSelect: integer;
	die, hit, sound: boolean;
	blocks: objectData;
	level, level2, level3: levelObjects;

begin
	life := 5;
	levelSelect:= 1;
	sound := true;
	die := false;
	hit := false;
	//Populates all level blocks, mario and monsters
	LoadLevelData(level, level2, level3, mario, monsters);

	OpenGraphicsWindow('Mario World', 640, 480);
	repeat
		ProcessEvents();
		ClearScreen(ColorWhite);
		if not(levelSelect = 4) then
		begin
			Sounds(mario);
		end;
		case(levelSelect) of
			1:	begin
					LevelData(level, level2, mario, monsters, hit, levelSelect);
					MonsterData(mario, monsters, level, hit, levelSelect, die);					
				end;
			2:	begin
					LevelData(level, level2, mario, monsters, hit, levelSelect);					
					MonsterData(mario, monsters, level2, hit, levelSelect, die);							
				end;
			3:	begin
					LevelData(level, level3, mario, monsters, hit, levelSelect);					
					MonsterData(mario, monsters, level3, hit, levelSelect, die);							
				end;
			4:	begin	
					StopSoundEffect('soundtrack.wav');				
					DrawBackground(levelSelect);						
					if not(SoundEffectPlaying('finishMusic.wav')) then
					begin
						PlaySoundEffect('finishMusic.wav');
					end;
				end;
		end;
		//Checks for mario or level changes
		CheckForEndOfGame(mario, die,  life, levelSelect);

		RefreshScreen(60);	
	until WindowCloseRequested();		
end;

begin
	main();
end.

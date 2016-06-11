unit Physics;

interface

const 
	//Set values for level grid
	COLUMNS = 3000; 	//across
	ROWS = 24;		//down
	//Cell size is width and height
	CELL_WIDTH = 20;	
type 
	// g = ground1 r = ground2 s = smash block i = itemBox n = normalBlock
	ObjectKind = (ground, ground2, smash, item, normalBlock, nothing, pipe1, pipe2, pipe3, pipe4, pipe5, pipe6);
	Characterkind = (player, gumba, turtle);

	
	objectData = record
		kind: ObjectKind;
		bmp: bitmap;
		xPos, yPos: integer;
		width, height: integer; 
		objectColor: color;
		isHit: boolean;
	end;
	
type levelObjects = array [0..COLUMNS-1, 0.. ROWS-1] of ObjectKind;

///
/// Uses gravity on mario character
procedure Deceleration(var mario: marioData);

/// Uses Speed affected by change in location data on mario character
procedure ChangeSpeed(var mario: marioData);


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;


	

	marioData = record
		kind: Characterkind;
		bmp: bitmap;
		xPos, yPos: double;
		jumpedY: boolean;
		movingX: boolean;
		speedX, speedY: double;
		enhanceMoving: double;
	end;	

procedure Deceleration(var mario: marioData);
begin
	begin	
		begin
			if(mario.speedX > 0) then
			begin
				mario.speedX -= 0.1;			
			end
			else if (mario.speedX < 0) then
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

procedure ChangeSpeed(var mario: marioData);
begin
	mario.xPos := round(mario.xPos + mario.speedX);
	mario.yPos := round(mario.yPos - mario.speedY);
end;


begin
	Deceleration();
	ChangeSpeed();

end.
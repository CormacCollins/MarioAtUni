unit Collision;

interface

///
/// Controlling mario in the x dimension
procedure CheckForcollisionX();

//
//Controlling mario in the y dimension
procedure CheckForcollision();


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;

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

		
procedure CheckForcollision(var mario: marioData; x,y: integer; var hit: boolean; var levelSelect: integer);		
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
			end; 
		end;
	end
	else if (mario.speedY > 0) then	
	begin
		if((round(mario.xPos + BitMapWidth(mario.bmp))) >= (x*CELL_WIDTH+2)) and ((round(mario.xPos) <= (x*CELL_WIDTH + CELL_WIDTH-2))) then		
		begin
			if ((round(mario.yPos) <= (y*CELL_WIDTH + CELL_WIDTH))) and (round(mario.yPos) >= round(y*CELL_WIDTH)) then			
			begin
				mario.speedY := 0;
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

begin
	CheckForcollisionX();
	CheckForcollision();
end.
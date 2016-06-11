unit PlayerControl;

interface

///
/// Controlling mario in the x dimension
procedure ControlPlayerInputX();

//
//Controlling mario in the y dimension
procedure ControlPlayerInputY();


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;


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


procedure ControlPlayerInputY(var mario: marioData);
begin
	if not(mario.jumpedY) then
	begin
		if KeyTyped(UpKey) and (mario.yPos > 0) then
		begin
			mario.speedY := 6*(mario.enhanceMoving);
			mario.jumpedY := true;			
		end;
	end;
end; 

begin
	ControlPlayerInputX();
	ControlPlayerInputY();

end.
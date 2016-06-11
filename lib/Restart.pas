unit Restart;

interface




///
/// Resets mario pos and minus life
//procedure Restart(var die: boolean; var mario: marioData; var life: integer; var levelSelect: integer);


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;

	type 
		marioData = record
				kind: Characterkind;
				bmp: bitmap;
				xPos, yPos: double;
				jumpedY: boolean;
				movingX: boolean;
				speedX, speedY: double;
				enhanceMoving: double;
	end;	


procedure Restart(var die: boolean; var mario: marioData; var life: integer; var levelSelect: integer);
var
	//timer
	deathTimer: Timer;
    ticks: Integer;

begin

	deathTimer := CreateTimer();
	if (die) then
	begin

	    StartTimer(deathTimer);
	    repeat 

	    	ticks := TimerTicks(deathTimer);
			//RefreshScreen(60);	
	    	//ClearScreen(ColorGreen);	    	
	   	until (ticks < 600); 

		LoadCharacters(mario);
		die := false;
		life := life - 1;
		levelSelect := 1;
	end;
end;
begin
	Restart(die; mario; life; levelSelect);

end.
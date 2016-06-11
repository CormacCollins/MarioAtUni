unit Score;

interface

///
/// Loads current amount of lives
procedure DrawScore(life: integer);


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;

	procedure DrawScore(life: integer);
	var
		lives: string;
		textColor: Color;
		//location: Point2D;
	begin
		lives := IntToStr(life);
		textColor := colorRed;
		DrawText(lives, colorRed, (round(CameraX())+40), 10);
		DrawText('M x ', textColor, (round(CameraX())+10), 10);
	end;

end.
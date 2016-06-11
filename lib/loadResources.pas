unit LoadResources;

interface

///
/// Loads the required bitmap images
procedure LoadResources();


implementation
uses  SwinGame, sgTypes, SysUtils, sgGraphics;

procedure LoadResources();
begin
	LoadBitmapNamed('marioWalkRight', 'marioWalkRight.png');
	LoadBitmapNamed('marioWalkLeft', 'marioWalkLeft.png');
	//Level background
	LoadBitmapNamed('marioBackground', 'marioBackground.jpeg');
	LoadBitmapNamed('undergroundMap', 'undergroundMap.png');	
	LoadBitmapNamed('blockBackground', 'blockBackground.png');	
	LoadBitmapNamed('finish', 'finish.png');	
	LoadBitmapNamed('HD', 'HD.png');


	LoadBitmapNamed('ground', 'ground1.jpeg');
	LoadBitmapNamed('ground2', 'ground2.jpeg');
	LoadBitmapNamed('smash', 'smashBlock.jpeg');
	LoadBitmapNamed('item', 'itemBlock.jpeg');
	LoadBitmapNamed('normalBlock', 'smashBlock.jpeg');
	LoadBitmapNamed('cloud', 'cloudBlock.png');

	LoadBitmapNamed('pipe1', 'pipe1.png');
	LoadBitmapNamed('pipe2', 'pipe2.png');
	LoadBitmapNamed('pipe3', 'pipe3.png');
	LoadBitmapNamed('pipe4', 'pipe4.png');


	LoadBitmapNamed('turtle', 'turtle.png');
end;

procedure LoadMusic();
begin
	LoadSoundEffect('marioJump.wav');
	LoadSoundEffect('brickBreak.wav');
	LoadSoundEffect('soundtrack.wav');
	LoadSoundEffect('death.wav');	
	LoadSoundEffect('pipe.wav');	
	LoadSoundEffect('koopaDeath.wav');			
	LoadSoundEffect('finishMusic.wav');		
end;

begin
	LoadMusic();
	LoadResources();

end.
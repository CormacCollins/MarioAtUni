procedure ReadFile(var level: levelObjects; var levelLoadNumber: integer);
var
	tfIn: TextFile;
	s: string;
	i, x, y: integer;	
	xPos, width, yPos, height: string;
	fileRead: objectData;
	//commaIdx1, commaIdx2, commaIdx3, commaIdx4 : Integer;
	//comPos: integer;
begin	
	  // Give some feedback
	  writeln('Reading the contents of file: ', 'levelLoad.txt');
	  writeln('=========================================');
 
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
				xPos := ConCat(s[i+3], s[i+4], s[i+5]);
				width := ConCat(s[i+7], s[i+8], s[i+9]);
				yPos := ConCat(s[i+11], s[i+12], s[i+13]);
				height := ConCat(s[i+15], s[i+16], s[i+17]);
				//g,xstart,xfin,ystart,yfin//
				//commaIdx1 commaIdx2 commaIdx3 commaIdx4
				//


				//for 0 to length
				//if i = ',' then compos = i
				//for 0 to compos -1 do 
				//for compos + 1 to compos2
				
				fileRead.xPos := StrToInt(xPos);
				fileRead.width := StrToInt(width);				
				fileRead.yPos := StrToInt(yPos);
				fileRead.height := StrToInt(height);
				//writeln(' ', fileRead.xPos);

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
		//writeLn('', (length(s)-1));	
	end;
	CloseFile(tfIn); 
	levelLoadNumber += 1;
end;
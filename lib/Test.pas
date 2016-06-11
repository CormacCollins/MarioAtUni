unit Test;
interface

//Reads from a textfile
procedure ReadFile();

implementation
// RESOURCE: http://wiki.freepascal.org/File_Handling_In_Pascal

objectData = record
		kind: ObjectKind;
		bmp: bitmap;
		xPos, yPos: integer;
		width, height: integer; 
		objectColor: color;
	end;


function ReadFile(): objectData;
 var
	tfIn: TextFile;
	s: string;
	i: integer;
	returnObject: objectData;

begin
  // Give some feedback
  writeln('Reading the contents of file: ', 'levelLoad.txt');
  writeln('=========================================');
 
  // Set the name of the file that will be read
  AssignFile(tfIn, 'levelLoad.txt');

	reset(tfIn);
 
	// Keep reading lines until the end of the file is reached
	while not eof(tfIn) do
	begin
	  readln(tfIn, s);
	  for i = 0 to eof(tfIn) do
	  begin 
		  if (s[i] == '/') then
		  begin
		  		if(s[i+1] == 'g')
		  		begin
		  			returnObject := 'g';
		  		end
		  		else if (s[i+1] == 'r')
		  		begin
		  		begin
		  			returnObject := 'r';
		  		end
		  		else if(s[i+1] == 's')
		  		begin
		  			returnObject := 's';
		  		end
		  		else if (s[i+1] == 'i')
		  		begin
		  			returnObject := 'i';
		  		end
		  		else if (s[i+1] == 'n')
		  		begin
		  		begin
		  			returnObject := 'n';
		  		end;
		  end;
	  end;

	  writeln(s);
	end;
 
	// Done so close the file
	CloseFile(tfIn); 
end;


begin
	ReadFile();
end.

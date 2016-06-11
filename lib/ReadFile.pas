unit ReadFiles;

interface


///
///
///
procedure ReadFile(var files: TextFile);


implementation 
uses
 Sysutils;

const
  TXT = 'TXT';

procedure ReadFile(var files: TextFile);
 var
    tfIn: TextFile;
    s: string;
begin
  // Give some feedback
  writeln('Reading the contents of file: ', 'TXT');
  writeln('=========================================');
 
  // Set the name of the file that will be read
  AssignFile(tfIn, 'TXT');

    // Open the file for reading
    reset(tfIn);
 
    // Keep reading lines until the end of the file is reached
    while not eof(tfIn) do
    begin
      readln(tfIn, s);
      writeln(s);
    end;
 
    // Done so close the file
    CloseFile(tfIn); 
end;

end.
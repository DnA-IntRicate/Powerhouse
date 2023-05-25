unit Powerhouse.FileStream;

interface

uses
  System.SysUtils, System.StrUtils, System.Math, System.Hash,
  Powerhouse.Appliance, Powerhouse.Database, Powerhouse.Logger;

type
  PhWriteMode = (Append = 0, Overwrite);

type
  PhFileStream = class
  public
    class function ReadAllText(const path: string): string; static;
    class procedure WriteAllText(const path, text: string;
      writeMode: PhWriteMode); static;

    class procedure CreateFile(const path: string); static;

    class function IsFile(const path: string): boolean; static;
    class function IsDir(const dir: string): boolean; static;

  private
    class procedure OpenFile(const path: string);
    class procedure CloseFile();

  private
    class var s_File: TextFile;
  end;

implementation

class function PhFileStream.ReadAllText(const path: string): string;
var
  buf, text: string;
begin
  OpenFile(path);

  text := '';
  while not Eof(s_File) do
  begin
    Readln(s_File, buf);
    text := text + buf + #13#10;
  end;

  CloseFile();
  Result := text;
end;

class procedure PhFileStream.WriteAllText(const path, text: string;
  writeMode: PhWriteMode);
begin
  if not IsFile(path) then
    CreateFile(path);

  OpenFile(path);

  case writeMode of
    Append:
      System.Append(s_File);
    Overwrite:
      System.Rewrite(s_File);
  end;

  Write(s_File, text);
  CloseFile();
end;

class procedure PhFileStream.CreateFile(const path: string);
var
  fileHandle: THandle;
begin
  fileHandle := FileCreate(path);

  if fileHandle = INVALID_HANDLE_VALUE then
    PhLogger.Error('Failed to create file: ' + path);

  FileClose(fileHandle);
end;

class function PhFileStream.IsFile(const path: string): boolean;
begin
  Result := FileExists(path);
end;

class function PhFileStream.IsDir(const dir: string): boolean;
begin
  Result := DirectoryExists(dir);
end;

class procedure PhFileStream.OpenFile(const path: string);
begin
  AssignFile(s_File, path);
  Reset(s_File);
end;

class procedure PhFileStream.CloseFile();
begin
  Close(s_File);
end;

end.

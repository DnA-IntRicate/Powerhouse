{ ----------------------------------------------------------------------------
  MIT License

  Copyright (c) 2023 Adam Foflonker

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ---------------------------------------------------------------------------- }

unit Powerhouse.FileStream;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Powerhouse.Types, Powerhouse.Logger;

type
  /// <summary>
  /// Specifies the write mode for file operations.
  /// </summary>
  PhWriteMode = (Append = 0, Overwrite);

type
  /// <summary>
  /// Provides basic utility methods for working with text files.
  /// </summary>
  PhFileStream = class
  public
    /// <summary>
    /// Reads all text from a file and returns its content as a string.
    /// </summary>
    /// <param name="path">
    /// The path of the file to read.
    /// </param>
    class function ReadAllText(const path: string): string;

    /// <summary>
    /// Writes the specified text to a file.
    /// </summary>
    /// <param name="path">
    /// The path of the file to write to.
    /// </param>
    /// <param name="text">
    /// The text to write to the file.
    /// </param>
    /// <param name="writeMode">
    /// The write mode for the file operation.
    /// </param>
    class procedure WriteAllText(const path, text: string;
      const writeMode: PhWriteMode);

    /// <summary>
    /// Creates a new file at the specified path.
    /// </summary>
    /// <param name="path">
    /// The path of the file to create.
    // </param>
    /// <returns>
    /// True if the file was successfully created, otherwise false.
    /// </returns>
    class function CreateFile(const path: string): bool; static;

    /// <summary>
    /// Checks if the specified path points to a file.
    /// </summary>
    /// <param name="path">
    /// The path to check.
    /// </param>
    class function IsFile(const path: string): bool; static;

    /// <summary>
    /// Checks if the specified path points to a directory.
    /// </summary>
    /// <param name="dir">
    /// The path to check.
    /// </param>
    class function IsDir(const dir: string): bool; static;

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
  const writeMode: PhWriteMode);
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

class function PhFileStream.CreateFile(const path: string): bool;
var
  fileHandle: THandle;
begin
  fileHandle := FileCreate(path);
  Result := fileHandle = INVALID_HANDLE_VALUE;

  if Result then
    PhLogger.Error('Failed to create file: ' + path);

  FileClose(fileHandle);
end;

class function PhFileStream.IsFile(const path: string): bool;
begin
  Result := FileExists(path);
end;

class function PhFileStream.IsDir(const dir: string): bool;
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

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

unit Powerhouse.Logger;

interface

uses
  System.SysUtils, System.StrUtils, System.UITypes, Vcl.Dialogs;

type
  PhMessageType = (Trace = 0, Information, Warning, Error);

type
  PhLogger = class
  public
    class function LogMessage(const msg: string;
      msgType: PhMessageType): integer;

    class procedure Trace(const msg: string; out Result: integer); overload;
    class procedure Trace(const msg: string); overload;
    class procedure Trace(const fmt: string; out Result: integer;
      const args: array of const); overload;
    class procedure Trace(const fmt: string;
      const args: array of const); overload;

    class procedure Info(const msg: string; out Result: integer); overload;
    class procedure Info(const msg: string); overload;
    class procedure Info(const fmt: string; out Result: integer;
      const args: array of const); overload;
    class procedure Info(const fmt: string;
      const args: array of const); overload;

    class procedure Warn(const msg: string; out Result: integer); overload;
    class procedure Warn(const msg: string); overload;
    class procedure Warn(const fmt: string; out Result: integer;
      const args: array of const); overload;
    class procedure Warn(const fmt: string;
      const args: array of const); overload;

    class procedure Error(const msg: string; out Result: integer); overload;
    class procedure Error(const msg: string); overload;
    class procedure Error(const fmt: string; out Result: integer;
      const args: array of const); overload;
    class procedure Error(const fmt: string;
      const args: array of const); overload;
  end;

implementation

class function PhLogger.LogMessage(const msg: string;
  msgType: PhMessageType): integer;
begin
  Result := -1;

  case msgType of
    PhMessageType.Trace:
      begin
        ShowMessage(msg);
        Result := 1;
      end;
    PhMessageType.Information:
      begin
        Result := MessageDlg(msg, mtInformation, mbOKCancel, 0);
      end;
    PhMessageType.Warning:
      begin
        Result := MessageDlg(msg, mtWarning, mbOKCancel, 0);
      end;
    PhMessageType.Error:
      begin
        Result := MessageDlg(msg, mtError, mbOKCancel, 0);
      end;
  end;
end;

class procedure PhLogger.Trace(const msg: string; out Result: integer);
begin
  Result := LogMessage(msg, PhMessageType.Trace);
end;

class procedure PhLogger.Trace(const msg: string);
begin
  LogMessage(msg, PhMessageType.Trace);
end;

class procedure PhLogger.Trace(const fmt: string; out Result: integer;
  const args: array of const);
begin
  Result := LogMessage(Format(fmt, args), PhMessageType.Trace);
end;

class procedure PhLogger.Trace(const fmt: string; const args: array of const);
begin
  LogMessage(Format(fmt, args), PhMessageType.Trace);
end;

class procedure PhLogger.Info(const msg: string; out Result: integer);
begin
  Result := LogMessage(msg, PhMessageType.Information);
end;

class procedure PhLogger.Info(const msg: string);
begin
  LogMessage(msg, PhMessageType.Information);
end;

class procedure PhLogger.Info(const fmt: string; out Result: integer;
  const args: array of const);
begin
  Result := LogMessage(Format(fmt, args), PhMessageType.Information);
end;

class procedure PhLogger.Info(const fmt: string; const args: array of const);
begin
  LogMessage(Format(fmt, args), PhMessageType.Information);
end;

class procedure PhLogger.Warn(const msg: string; out Result: integer);
begin
  Result := LogMessage(msg, PhMessageType.Warning);
end;

class procedure PhLogger.Warn(const msg: string);
begin
  LogMessage(msg, PhMessageType.Warning);
end;

class procedure PhLogger.Warn(const fmt: string; out Result: integer;
  const args: array of const);
begin
  Result := LogMessage(Format(fmt, args), PhMessageType.Warning);
end;

class procedure PhLogger.Warn(const fmt: string; const args: array of const);
begin
  LogMessage(Format(fmt, args), PhMessageType.Warning);
end;

class procedure PhLogger.Error(const msg: string; out Result: integer);
begin
  Result := LogMessage(msg, PhMessageType.Error);
end;

class procedure PhLogger.Error(const msg: string);
begin
  LogMessage(msg, PhMessageType.Error);
end;

class procedure PhLogger.Error(const fmt: string; out Result: integer;
  const args: array of const);
begin
  Result := LogMessage(Format(fmt, args), PhMessageType.Error);
end;

class procedure PhLogger.Error(const fmt: string; const args: array of const);
begin
  LogMessage(Format(fmt, args), PhMessageType.Error);
end;

end.

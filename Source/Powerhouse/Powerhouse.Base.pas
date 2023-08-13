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

unit Powerhouse.Base;

interface

uses
  System.SysUtils,
  Powerhouse.Types;

type
  PhBase = class(TInterfacedObject)
  end;

type
  PhDatabaseObjectBase = class(PhBase)
  public
    constructor Create(const guid: PhGUID); virtual;

    procedure Push(); virtual; abstract;
    procedure Pull(); virtual; abstract;
    procedure Sync(); virtual;

    function GetGUID(): PhGUID;

  protected
    m_GUID: PhGUID;
  end;

implementation

constructor PhDatabaseObjectBase.Create(const guid: PhGUID);
begin
  m_GUID := guid;

  Pull();
end;

procedure PhDatabaseObjectBase.Sync();
begin
  Push();
  Pull();
end;

function PhDatabaseObjectBase.GetGUID(): PhGUID;
begin
  Result := m_GUID;
end;

end.

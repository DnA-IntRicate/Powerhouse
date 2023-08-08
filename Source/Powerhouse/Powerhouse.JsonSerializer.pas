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

unit Powerhouse.JsonSerializer;

interface

uses
  System.SysUtils, System.StrUtils, System.Math, System.Hash, System.JSON,
  Data.DBXJSON, Data.DBXJSONReflect, Powerhouse.Types;

type
  PhJsonSerializer = class
  public
    constructor Create();
    destructor Destroy(); override;

    function SerializeJson(obj: TObject): string;
    function DeserializeJson(const jsonStr: string): TObject;

  private
    m_Marshal: TJSONMarshal;
    m_Unmarshal: TJSONUnMarshal;
  end;

implementation

constructor PhJsonSerializer.Create();
begin
  m_Marshal := TJSONMarshal.Create(TJSONConverter.Create());
  m_Unmarshal := TJSONUnMarshal.Create();
end;

destructor PhJsonSerializer.Destroy();
begin
  inherited;

  m_Marshal.Free();
  m_Unmarshal.Free();
end;

function PhJsonSerializer.SerializeJson(obj: TObject): string;
begin
  Result := m_Marshal.Marshal(obj).ToString();
end;

function PhJsonSerializer.DeserializeJson(const jsonStr: string): TObject;
begin
  Result := m_Unmarshal.Unmarshal(TJSONObject.ParseJSONValue(jsonStr))
    as TObject;
end;

end.

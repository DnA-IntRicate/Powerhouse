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
  Data.DBXJSON, Data.DBXJSONReflect, Powerhouse.Appliance, Powerhouse.User;

type
  PhJsonSerializer = class
  public
    constructor Create();
    destructor Destroy(); override;

    function SerializeJson(obj: TObject): string;
    function DeserializeJson(jsonStr: string): TObject;

  private
    m_Marshal: TJSONMarshal;
    m_Unmarshal: TJSONUnMarshal;
  end;

const
  PH_SAVEFILE_NAME: string = 'PowerhouseSave.json';

implementation

constructor PhJsonSerializer.Create();
begin
  m_Marshal := TJSONMarshal.Create(TJSONConverter.Create());
  m_Unmarshal := TJSONUnMarshal.Create();

  // PhAppliances
  m_Marshal.RegisterConverter(PhSerializableAppliances, 'Appliances',
    function(data: TObject; field: string): TListOfObjects
    var
      appliance: PhAppliance;
      i: integer;
    begin
      SetLength(Result, Length(PhSerializableAppliances(data).Appliances));
      i := Low(Result);

      for appliance in PhSerializableAppliances(data).Appliances do
      begin
        Result[i] := appliance;
        Inc(i);
      end;
    end);

  // TODO: This will only work if PhUser.m_Appliances is of type PhSerializableAppliances
  // PhUsers
  m_Marshal.RegisterConverter(PhSerializableUsers, 'Users',
    function(data: TObject; field: string): TListOfObjects
    var
      user: PhUser;
      i: integer;
    begin
      SetLength(Result, Length(PhSerializableUsers(data).Users));
      i := Low(Result);

      for user in PhSerializableUsers(data).Users do
      begin
        Result[i] := user;
        Inc(i);
      end;
    end);

  // PhAppliances
  m_Unmarshal.RegisterReverter(PhSerializableAppliances, 'Appliances',
    procedure(data: TObject; field: string; args: TListOfObjects)
    var
      obj: TObject;
      i: integer;
    begin
      i := Low(PhSerializableAppliances(data).Appliances);

      for obj in args do
      begin
        PhSerializableAppliances(data).Appliances[i] := PhAppliance(obj);
        Inc(i);
      end;
    end);

  // TODO: This will only work if PhUser.m_Appliances is of type PhSerializableAppliances
  // PhUsers
  m_Unmarshal.RegisterReverter(PhSerializableUsers, 'Users',
    procedure(data: TObject; field: string; args: TListOfObjects)
    var
      obj: TObject;
      i: integer;
    begin
      i := Low(PhSerializableUsers(data).Users);

      for obj in args do
      begin
        PhSerializableUsers(data).Users[i] := PhUser(obj);
        Inc(i);
      end;
    end);
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

function PhJsonSerializer.DeserializeJson(jsonStr: string): TObject;
begin
  Result := m_Unmarshal.Unmarshal(TJSONObject.ParseJSONValue(jsonStr))
    as TObject;
end;

end.

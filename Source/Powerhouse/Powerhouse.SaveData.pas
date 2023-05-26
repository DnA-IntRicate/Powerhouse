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

unit Powerhouse.SaveData;

interface

uses
  System.SysUtils, System.StrUtils, System.Math, Powerhouse.Appliance,
  Powerhouse.User;

type
  PhUserData = record
    GUID: string;
    Appliances: TArray<uint32>;
  end;

type
  PhSaveData = class
  public
    constructor Create(var _users: PhUsers);

    procedure ToPhUsers(out result: PhUsers);

  public
    Users: TArray<PhUserData>;
  end;

implementation

constructor PhSaveData.Create(var _users: PhUsers);
var
  user: PhUser;
  userIdx, applianceIdx: integer;
  appliances: PhAppliances;
  appliance: PhAppliance;
begin
  SetLength(Users, Length(_users));
  userIdx := 0;

  for user in _users do
  begin
    Users[userIdx].GUID := user.GetGUID();
    user.GetAppliances(appliances);

    SetLength(Users[userIdx].Appliances, Length(appliances));
    applianceIdx := 0;

    for appliance in appliances do
    begin
      Users[userIdx].Appliances[applianceIdx] := appliance.GetID();
      Inc(applianceIdx);
    end;

    Inc(userIdx);
  end;
end;

procedure PhSaveData.ToPhUsers(out result: PhUsers);
var
  userIdx, applianceIdx: integer;
  data: PhUserData;
  appliances: PhAppliances;
  applianceID: uint32;
begin
  SetLength(result, Length(Users));
  userIdx := 0;

  for data in Users do
  begin
    result[userIdx] := PhUser.Create(data.GUID);

    SetLength(appliances, Length(data.Appliances));
    applianceIdx := 0;

    for applianceID in data.Appliances do
    begin
      appliances[applianceIdx] := PhAppliance.Create(applianceID);
      Inc(applianceIdx);
    end;

    result[userIdx].SetAppliances(appliances);
    Inc(userIdx);
  end;
end;

end.

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
  System.SysUtils, System.StrUtils, System.Math, Powerhouse.Types,
  Powerhouse.Vector, Powerhouse.Appliance, Powerhouse.User;

type
  PhUserData = record
    GUID: string;
    Appliances: TArray<string>;
  end;

type
  PhSaveData = class
  public
    constructor Create(var refUsers: PhUsers);

    function ToPhUsers(): PhUsers;

  public
    Users: TArray<PhUserData>;
  end;

implementation

constructor PhSaveData.Create(var refUsers: PhUsers);
var
  user: PhUser;
  userIdx, applianceIdx: int;
  appliances: PhAppliances;
  appliance: PhAppliance;
begin
  SetLength(Users, refUsers.Size());
  userIdx := 0;

  for user in refUsers do
  begin
    Users[userIdx].GUID := user.GetGUID();
    appliances := user.GetAppliances();

    SetLength(Users[userIdx].Appliances, appliances.Size());
    applianceIdx := 0;

    for appliance in appliances do
    begin
      Users[userIdx].Appliances[applianceIdx] := appliance.GetGUID();
      Inc(applianceIdx);
    end;

    Inc(userIdx);
  end;
end;

function PhSaveData.ToPhUsers(): PhUsers;
var
  userIdx, applianceIdx: int;
  data: PhUserData;
  appliances: PhAppliances;
  applianceGUID: PhGUID;
begin
  Result := PhUsers.Create(Length(Users));
  userIdx := 0;

  for data in Users do
  begin
    Result[userIdx] := PhUser.Create(data.GUID);

    appliances := PhAppliances.Create(Length(data.Appliances));
    applianceIdx := 0;

    for applianceGUID in data.Appliances do
    begin
      appliances[applianceIdx] := PhAppliance.Create(applianceGUID);
      Inc(applianceIdx);
    end;

    Result[userIdx].SetAppliances(appliances);
    Inc(userIdx);
  end;
end;

end.

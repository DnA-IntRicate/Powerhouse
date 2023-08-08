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
  Powerhouse.Vector, Powerhouse.JsonSerializer, Powerhouse.FileStream,
  Powerhouse.Logger, Powerhouse.Appliance, Powerhouse.User;

type
  PhSaveData = class
  public
    constructor Create(const path: string);

    procedure AddOrUpdateUser(const user: PhUser);

    function GetUserAppliances(const userGUID: PhGUID): PhVector<PhGUID>;

    function GetPath(): string;

  private
    function CreateSaveFile(const path: string): bool;
    procedure OverwriteSaveFile(const path: string);

  private type
    UserData = record
      GUID: string;
      Appliances: PhVector<string>;
    end;

  private type
    StagingStruct = class
    public
      constructor Create();

    public
      Data: TArray<PhSaveData.UserData>;
    end;

  private
    m_Data: PhVector<UserData>;
    m_Path: string;
  end;

var
  g_SaveData: PhSaveData;

implementation

constructor PhSaveData.StagingStruct.Create();
begin
  inherited Create();
end;

constructor PhSaveData.Create(const path: string);
var
  jsonSrc: string;
  json: PhJsonSerializer;
  stagingStruct: PhSaveData.StagingStruct;
  user: UserData;
begin
  m_Path := path;
  m_Data := PhVector<UserData>.Create();

  if not PhFileStream.IsFile(m_Path) then
  begin
    CreateSaveFile(m_Path);
    Exit();
  end;

  jsonSrc := PhFileStream.ReadAllText(m_Path);
  if jsonSrc = String.Empty then
  begin
    PhLogger.Error('Error reading save data!');
    Exit();
  end;

  json := PhJsonSerializer.Create();
  stagingStruct := json.DeserializeJson(jsonSrc) as PhSaveData.StagingStruct;

  m_Data.Reserve(Length(stagingStruct.Data));
  for user in stagingStruct.Data do
    m_Data.PushBack(user);
end;

procedure PhSaveData.AddOrUpdateUser(const user: PhUser);
var
  i: int;
  appliance: PhAppliance;
  updatedUser: bool;
  newData: UserData;
begin
  updatedUser := false;

  for i := m_Data.First() to m_Data.Last() do
  begin
    if m_Data[i].GUID = user.GetGUID() then
    begin
      m_Data[i].Appliances.Clear();

      for appliance in user.GetAppliances() do
        m_Data[i].Appliances.PushBack(appliance.GetGUID());

      m_Data[i].Appliances.ShrinkToFit();
      updatedUser := true;

      break;
    end;
  end;

  if not updatedUser then
  begin
    newData.GUID := user.GetGUID();
    newData.Appliances := PhVector<string>.Create(user.GetAppliances().Size());

    for appliance in user.GetAppliances() do
      newData.Appliances.PushBack(appliance.GetGUID());

    m_Data.PushBack(newData);
  end;

  OverwriteSaveFile(m_Path);
end;

function PhSaveData.GetUserAppliances(const userGUID: PhGUID): PhVector<PhGUID>;
var
  i: int;
  guidStr: string;
begin
  for i := m_Data.First() to m_Data.Last() do
  begin
    if m_Data[i].GUID = userGUID then
    begin
      Result := PhVector<PhGUID>.Create(m_Data[i].Appliances.Size());
      for guidStr in m_Data[i].Appliances do
        Result.PushBack(PhGUID(guidStr));

      Exit();
    end;
  end;

  Result := PhVector<PhGUID>.Create();
end;

function PhSaveData.GetPath(): string;
begin
  Result := m_Path;
end;

function PhSaveData.CreateSaveFile(const path: string): bool;
begin
  Result := PhFileStream.CreateFile(path) and PhFileStream.IsFile(path);
end;

procedure PhSaveData.OverwriteSaveFile(const path: string);
var
  stagingStruct: PhSaveData.StagingStruct;
  i: int;
  json: PhJsonSerializer;
  jsonSrc: string;
begin
  if m_Data.Empty() then
    Exit();

  stagingStruct := PhSaveData.StagingStruct.Create();
  SetLength(stagingStruct.Data, m_Data.Size());

  for i := m_Data.First() to m_Data.Last() do
    stagingStruct.Data[i] := m_Data[i];

  json := PhJsonSerializer.Create();
  jsonSrc := json.SerializeJson(stagingStruct);

  PhFileStream.WriteAllText(path, jsonSrc, PhWriteMode.Overwrite);
end;

end.

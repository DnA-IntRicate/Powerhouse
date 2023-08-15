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
  System.SysUtils, System.StrUtils,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.JsonSerializer,
  Powerhouse.Logger, Powerhouse.FileStream, Powerhouse.Appliance,
  Powerhouse.User;

type
  /// <summary>
  /// Manages saving and loading user data to and from a JSON file.
  /// </summary>
  PhSaveData = class
  public
    /// <summary>
    /// Creates a new instance of the <c>PhSaveData</c> class.
    /// </summary>
    /// <param name="path">
    /// The path to the save data file.
    /// </param>
    constructor Create(const path: string);

    /// <summary>
    /// Adds or updates user data in the save file.
    /// </summary>
    /// <param name="user">
    /// The user data to add or update.
    /// </param>
    procedure AddOrUpdateUser(const user: PhUser);

    /// <summary>
    /// Retrieves the electricity tariff associated with a user.
    /// </summary>
    /// <param name="userGUID">
    /// The GUID of the user.
    /// </param>
    /// <returns>
    /// An electricity tariff in c/kWh.
    /// </returns>
    function GetUserElectricityTariff(const userGUID: PhGUID): float;

    /// <summary>
    /// Retrieves the list of appliances associated with a user.
    /// </summary>
    /// <param name="userGUID">
    /// The GUID of the user.
    /// </param>
    /// <returns>
    /// A vector containing appliances.
    /// </returns>
    function GetUserAppliances(const userGUID: PhGUID): PhAppliances;

    /// <summary>
    /// Returns the path to the save data file.
    /// </summary>
    function GetPath(): string;

  private
    function CreateSaveFile(const path: string): bool;
    procedure OverwriteSaveFile(const path: string);

  private type
    ApplianceData = record
      GUID: string;
      DailyUsage: int;
    end;

    UserData = record
      GUID: string;
      ElectricityTariff: float;
      Appliances: PhVector<ApplianceData>;
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
  data: ApplianceData;
  currentData, newData: UserData;
begin
  updatedUser := false;

  for i := m_Data.First() to m_Data.Last() do
  begin
    if m_Data[i].GUID = user.GetGUID() then
    begin
      currentData := m_Data[i];

      currentData.ElectricityTariff := user.GetElectricityTariff();
      currentData.Appliances.Clear();

      for appliance in user.GetAppliances() do
      begin
        data.GUID := appliance.GetGUID();
        data.DailyUsage := appliance.GetDailyUsage();

        currentData.Appliances.PushBack(data);
      end;

      currentData.Appliances.ShrinkToFit();
      m_Data[i] := currentData;
      updatedUser := true;

      break;
    end;
  end;

  if not updatedUser then
  begin
    newData.GUID := user.GetGUID();
    newData.ElectricityTariff := user.GetElectricityTariff();
    newData.Appliances := PhVector<ApplianceData>.Create
      (user.GetAppliances().Size());

    for appliance in user.GetAppliances() do
    begin
      data.GUID := appliance.GetGUID();
      data.DailyUsage := appliance.GetDailyUsage();

      newData.Appliances.PushBack(data);
    end;

    m_Data.PushBack(newData);
  end;

  OverwriteSaveFile(m_Path);
end;

function PhSaveData.GetUserElectricityTariff(const userGUID: PhGUID): float;
var
  i: uint64;
begin
  if not m_Data.Empty() then
  begin
    for i := m_Data.First() to m_Data.Last() do
    begin
      if m_Data[i].GUID = userGUID then
        Exit(m_Data[i].ElectricityTariff);
    end;
  end;

  Result := 0.0;
end;

function PhSaveData.GetUserAppliances(const userGUID: PhGUID): PhAppliances;
var
  i: uint64;
  data: ApplianceData;
  appliance: PhAppliance;
begin
  if not m_Data.Empty() then
  begin
    for i := m_Data.First() to m_Data.Last() do
    begin
      if m_Data[i].GUID = userGUID then
      begin
        Result := PhAppliances.Create(m_Data[i].Appliances.Size());

        for data in m_Data[i].Appliances do
        begin
          appliance := PhAppliance.Create(PhGUID(data.GUID));
          appliance.SetDailyUsage(data.DailyUsage);

          Result.PushBack(appliance);
        end;

        Exit();
      end;
    end;
  end;

  Result := PhAppliances.Create();
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

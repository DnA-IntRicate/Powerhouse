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

unit Powerhouse.Appliance;

interface

uses
  System.SysUtils, System.StrUtils, System.Math, System.Variants,
  Powerhouse.Types, Powerhouse.Database, Powerhouse.Logger;

type
  PhAppliance = class
  public
    constructor Create(id: PhIDType); overload;

    class function CreateAppliance(const name, manufacturer,
      batteryKind: string; const voltage, amperage, activePower, standbyPower,
      inputPower, outputPower, frequency, powerFactor, batterySize: float;
      const energyRating: int; const surgeProtection: bool): PhAppliance;

    function CalculateCostPerHour(): float;

    function GetID(): PhIDType;

    function GetName(): string;
    procedure SetName(name: string);

    function GetManufacturer(): string;
    procedure SetManufacturer(manufacturer: string);

    function GetVoltage(): float;
    procedure SetVoltage(voltage: float);

    function GetAmperage(): float;
    procedure SetAmperage(amperage: float);

    function GetActivePower(): float;
    procedure SetActivePower(activePower: float);

    function GetStandbyPower(): float;
    procedure SetStandbyPower(standbyPower: float);

    function GetInputPower(): float;
    procedure SetInputPower(inputPower: float);

    function GetOutputPower(): float;
    procedure SetOutputPower(outputPower: float);

    function GetFrequency(): float;
    procedure SetFrequency(frequency: float);

    function GetEnergyRating(): int;
    procedure SetEnegeryRating(rating: int);

    function GetPowerFactor(): float;
    procedure SetPowerfactor(factor: float);

    function GetBatterySize(): float;
    procedure SetBatterySize(size: float);

    function GetBatteryKind(): string;
    procedure SetBatteryKind(kind: string);

    function GetSurgeProtection(): bool;
    procedure SetSurgeProtection(surgeProtection: bool);

  private
    class function FindAppliance(id: PhIDType): bool;
    class function FromDatabase(field: string): Variant;

    procedure UpdateInDatabase();

  private
    m_ID: PhIDType;
    m_Name: string;
    m_Manufacturer: string;
    m_Voltage: float;
    m_Amperage: float;
    m_ActivePower: float;
    m_StandbyPower: float;
    m_InputPower: float;
    m_OutputPower: float;
    m_Frequency: float;
    m_EnergyRating: int;
    m_PowerFactor: float;
    m_BatterySize: float;
    m_BatteryKind: string; // TODO: Use an enumerated type
    m_SurgeProtection: bool;
  end;

type
  PhAppliances = TArray<PhAppliance>;

const
  PH_TBL_FIELD_NAME_APPLIANCES_PK = 'ApplianceID';
  PH_TBL_FIELD_NAME_APPLIANCES_NAME = 'ApplianceName';
  PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER = 'Manufacturer';
  PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE = 'Voltage';
  PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE = 'Amperage';
  PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER = 'ActivePowerConsumption';
  PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER = 'StandbyPowerConsumption';
  PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER = 'InputPower';
  PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER = 'OutputPower';
  PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY = 'Frequency';
  PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING = 'EnergyEfficiencyRating';
  PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR = 'PowerFactor';
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE = 'BatterySize';
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND = 'BatteryKind';
  PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION = 'SurgeProtection';

implementation

constructor PhAppliance.Create(id: PhIDType);
var
  v: Variant;
begin
  m_ID := id;

  if FindAppliance(id) then
  begin
    m_Name := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_NAME);
    m_Manufacturer := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER);
    m_Voltage := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE);
    m_Amperage := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE);
    m_ActivePower := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER);
    m_StandbyPower := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER);
    m_InputPower := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER);
    m_Frequency := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY);
    m_EnergyRating := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING);
    m_PowerFactor := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR);
    m_SurgeProtection :=
      FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION);

    v := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER);
    if not VarIsNull(v) then
      m_OutputPower := v
    else
      m_OutputPower := -1.0;

    v := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE);
    if not VarIsNull(v) then
      m_BatterySize := v
    else
      m_BatterySize := -1.0;

    v := FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND);
    if not VarIsNull(v) then
      m_BatteryKind := v
    else
      m_BatteryKind := '';
  end
  else
  begin
    m_Name := '';
    m_Manufacturer := '';
    m_Voltage := 0.0;
    m_Amperage := 0.0;
    m_ActivePower := 0.0;
    m_StandbyPower := 0.0;
    m_InputPower := 0.0;
    m_OutputPower := 0.0;
    m_Frequency := 0.0;
    m_EnergyRating := 0;
    m_PowerFactor := 0.0;
    m_BatterySize := 0.0;
    m_BatteryKind := '';
    m_SurgeProtection := false;
  end;

  g_Database.TblAppliances.First();
end;

class function PhAppliance.CreateAppliance(const name, manufacturer,
  batteryKind: string; const voltage, amperage, activePower, standbyPower,
  inputPower, outputPower, frequency, powerFactor, batterySize: float;
  const energyRating: int; const surgeProtection: bool): PhAppliance;
var
  query: string;
  id: PhIDType;
  e: Exception;
begin
  g_Database.TblAppliances.Last();
  id := g_Database.TblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_PK] + 1;
  g_Database.TblAppliances.First();

  query := Format('INSERT INTO %s (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, ' +
    '%s, %s, %s, %s) VALUES (%d, ''%s'', ''%s'', %f, %f, %f, %f, %f, %f, %f, ' +
    '%d, %f, ''%s'', %s);', [PH_TBL_NAME_APPLIANCES,
    PH_TBL_FIELD_NAME_APPLIANCES_PK, PH_TBL_FIELD_NAME_APPLIANCES_NAME,
    PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER,
    PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE, PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE,
    PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY,
    PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING,
    PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND,
    PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION, id, name, manufacturer,
    voltage, amperage, activePower, standbyPower, inputPower, outputPower,
    frequency, energyRating, powerFactor, batterySize, batteryKind,
    BoolToStr(surgeProtection, true)]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error adding new appliance to database: %s', [e.Message]);

  Result := Create(id);
end;

function PhAppliance.CalculateCostPerHour(): float;
begin
  // TODO: Implement this.
  Result := 0;
end;

function PhAppliance.GetID(): PhIDType;
begin
  Result := m_ID;
end;

function PhAppliance.GetName(): string;
begin
  Result := m_Name;
end;

procedure PhAppliance.SetName(name: string);
begin
  m_Name := name;

  UpdateInDatabase();
end;

function PhAppliance.GetManufacturer(): string;
begin
  Result := m_Manufacturer;
end;

procedure PhAppliance.SetManufacturer(manufacturer: string);
begin
  m_Manufacturer := manufacturer;

  UpdateInDatabase();
end;

function PhAppliance.GetVoltage(): float;
begin
  Result := m_Voltage;
end;

procedure PhAppliance.SetVoltage(voltage: float);
begin
  m_Voltage := voltage;

  UpdateInDatabase();
end;

function PhAppliance.GetAmperage(): float;
begin
  Result := m_Amperage;
end;

procedure PhAppliance.SetAmperage(amperage: float);
begin
  m_Amperage := amperage;

  UpdateInDatabase();
end;

function PhAppliance.GetActivePower(): float;
begin
  Result := m_ActivePower;
end;

procedure PhAppliance.SetActivePower(activePower: float);
begin
  m_ActivePower := activePower;

  UpdateInDatabase();
end;

function PhAppliance.GetStandbyPower(): float;
begin
  Result := m_StandbyPower;
end;

procedure PhAppliance.SetStandbyPower(standbyPower: float);
begin
  m_StandbyPower := standbyPower;

  UpdateInDatabase();
end;

function PhAppliance.GetInputPower(): float;
begin
  Result := m_InputPower;
end;

procedure PhAppliance.SetInputPower(inputPower: float);
begin
  m_InputPower := inputPower;

  UpdateInDatabase();
end;

function PhAppliance.GetOutputPower(): float;
begin
  Result := m_OutputPower;
end;

procedure PhAppliance.SetOutputPower(outputPower: float);
begin
  m_OutputPower := outputPower;

  UpdateInDatabase();
end;

function PhAppliance.GetFrequency(): float;
begin
  Result := m_Frequency;
end;

procedure PhAppliance.SetFrequency(frequency: float);
begin
  m_Frequency := frequency;

  UpdateInDatabase();
end;

function PhAppliance.GetEnergyRating(): int;
begin
  Result := m_EnergyRating;
end;

procedure PhAppliance.SetEnegeryRating(rating: int);
begin
  m_EnergyRating := rating;

  UpdateInDatabase();
end;

function PhAppliance.GetPowerFactor(): float;
begin
  Result := m_PowerFactor;
end;

procedure PhAppliance.SetPowerfactor(factor: float);
begin
  m_PowerFactor := factor;

  UpdateInDatabase();
end;

function PhAppliance.GetBatterySize(): float;
begin
  Result := m_BatterySize;
end;

procedure PhAppliance.SetBatterySize(size: float);
begin
  m_BatterySize := size;

  UpdateInDatabase();
end;

function PhAppliance.GetBatteryKind(): string;
begin
  Result := m_BatteryKind;
end;

procedure PhAppliance.SetBatteryKind(kind: string);
begin
  m_BatteryKind := kind;

  UpdateInDatabase();
end;

function PhAppliance.GetSurgeProtection(): bool;
begin
  Result := m_SurgeProtection;
end;

procedure PhAppliance.SetSurgeProtection(surgeProtection: bool);
begin
  m_SurgeProtection := surgeProtection;

  UpdateInDatabase();
end;

class function PhAppliance.FindAppliance(id: PhIDType): bool;
begin
  Result := false;

  with g_Database do
  begin
    TblAppliances.First();

    while not TblAppliances.Eof do
    begin
      Result := id = FromDatabase(PH_TBL_FIELD_NAME_APPLIANCES_PK);
      if Result then
        break;

      TblAppliances.Next();
    end;
  end;
end;

class function PhAppliance.FromDatabase(field: string): Variant;
begin
  Result := g_Database.TblAppliances[field];
end;

procedure PhAppliance.UpdateInDatabase();
var
  sQuery: string;
  e: Exception;
begin
  sQuery := Format('UPDATE %s' + #13#10 +
    'SET %s = ''%s'', %s = ''%s'', %s = %f, %s = %f, %s = %f, %s = %f, %s = %f, '
    + '%s = %f, %s = %f, %s = %d, %s = %f, %s = %f, %s = ''%s'', %s = %s' +
    #13#10 + 'WHERE %s = %d', [PH_TBL_NAME_APPLIANCES,
    PH_TBL_FIELD_NAME_APPLIANCES_NAME, m_Name,
    PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER, m_Manufacturer,
    PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE, m_Voltage,
    PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE, m_Amperage,
    PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER, m_ActivePower,
    PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER, m_StandbyPower,
    PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER, m_InputPower,
    PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER, m_OutputPower,
    PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY, m_Frequency,
    PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING, m_EnergyRating,
    PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR, m_PowerFactor,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE, m_BatterySize,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND, m_BatteryKind,
    PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION, BoolToStr(m_SurgeProtection,
    true), PH_TBL_FIELD_NAME_APPLIANCES_PK, m_ID]);

  e := g_Database.RunQuery(sQuery);

  if e <> nil then
    PhLogger.Error('Error updating database: %s', [e.Message]);
end;

end.

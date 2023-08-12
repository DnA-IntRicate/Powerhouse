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
  System.Generics.Defaults,
  Data.DB,
  Data.Win.ADODB,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Logger, Powerhouse.Database;

type
  PhAppliance = class(TInterfacedObject, IEquatable<PhAppliance>)
  public
    constructor Create(const guid: PhGUID);

    class function CreateAppliance(const name, manufacturer,
      batteryKind: string; const voltage, amperage, activePower, standbyPower,
      inputPower, outputPower, frequency, powerFactor, batterySize: float;
      const energyRating: int; const surgeProtection: bool): PhAppliance;

    procedure Push();
    procedure Pull();
    procedure Sync();

    function CalculateCostPerHour(): float;

    function Equals(other: PhAppliance): bool; reintroduce;

    function GetGUID(): PhGUID;

    function GetName(): string;
    procedure SetName(const name: string);

    function GetManufacturer(): string;
    procedure SetManufacturer(const manufacturer: string);

    function GetVoltage(): float;
    procedure SetVoltage(const voltage: float);

    function GetAmperage(): float;
    procedure SetAmperage(const amperage: float);

    function GetActivePower(): float;
    procedure SetActivePower(const activePower: float);

    function GetStandbyPower(): float;
    procedure SetStandbyPower(const standbyPower: float);

    function GetInputPower(): float;
    procedure SetInputPower(const inputPower: float);

    function GetOutputPower(): float;
    procedure SetOutputPower(const outputPower: float);

    function GetFrequency(): float;
    procedure SetFrequency(const frequency: float);

    function GetEnergyRating(): int;
    procedure SetEnegeryRating(const rating: int);

    function GetPowerFactor(): float;
    procedure SetPowerFactor(const factor: float);

    function GetBatterySize(): float;
    procedure SetBatterySize(const size: float);

    function GetBatteryKind(): string;
    procedure SetBatteryKind(const kind: string);

    function GetSurgeProtection(): bool;
    procedure SetSurgeProtection(const surgeProtection: bool);

  private
    m_GUID: PhGUID;
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
    m_BatteryKind: string;
    // TODO: Use an enumerated type
    m_SurgeProtection: bool;
  end;

type
  PhAppliancePtr = ^PhAppliance;
  PhAppliances = PhVector<PhAppliance>;

const
  PH_TBL_FIELD_NAME_APPLIANCES_PK = 'ApplianceGUID';
  PH_TBL_FIELD_NAME_APPLIANCES_NAME = 'ApplianceName';
  PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER = 'Manufacturer';
  PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE = 'Voltage';
  PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE = 'Amperage';
  PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER = 'ActivePowerConsumption';
  PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER = 'InputPower';
  PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER = 'OutputPower';
  PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER = 'StandbyPowerConsumption';
  PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR = 'PowerFactor';
  PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY = 'Frequency';
  PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING = 'EnergyEfficiencyRating';
  PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION = 'SurgeProtection';
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE = 'BatterySize';
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND = 'BatteryKind';

implementation

constructor PhAppliance.Create(const guid: PhGUID);
begin
  m_GUID := guid;

  Pull();
end;

class function PhAppliance.CreateAppliance(const name, manufacturer,
  batteryKind: string; const voltage, amperage, activePower, standbyPower,
  inputPower, outputPower, frequency, powerFactor, batterySize: float;
  const energyRating: int; const surgeProtection: bool): PhAppliance;
var
  query: string;
  fmtSettings: TFormatSettings;
  guid: PhGUID;
  myVoltage, myAmperage, myActivePower, myInputPower, myOutputPower,
    myStandbyPower, myPowerFactor, myFrequency, mySurgeProtection,
    myBatterySize: string;
  e: Exception;
begin
  fmtSettings := TFormatSettings.Create();
  fmtSettings.DecimalSeparator := '.';
  fmtSettings.ThousandSeparator := char(0);

  guid := PhGUID.Create();

  myVoltage := FormatFloat('#,##0.00', voltage, fmtSettings);
  myAmperage := FormatFloat('#,##0.00', amperage, fmtSettings);
  myActivePower := FormatFloat('#,##0.00', activePower, fmtSettings);
  myInputPower := FormatFloat('#,##0.00', inputPower, fmtSettings);
  myOutputPower := IfThen(outputPower = -1.0, 'Null',
    FormatFloat('#,##0.00', outputPower, fmtSettings));

  myStandbyPower := FormatFloat('#,##0.00', standbyPower, fmtSettings);
  myPowerFactor := FormatFloat('#,##0.00', powerFactor, fmtSettings);
  myFrequency := FormatFloat('#,##0.00', frequency, fmtSettings);
  mySurgeProtection := BoolToStr(surgeProtection, true);
  myBatterySize := IfThen(batterySize = -1.0, 'Null',
    FormatFloat('#,##0.00', batterySize, fmtSettings));

  query := Format('INSERT INTO %s (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, ' +
    '%s, %s, %s, %s, %s) VALUES (''%s'', ''%s'', ''%s'', %s, %s, %s, %s, %s, %s, '
    + '%s, %s, %d, %s, %s, ''%s'');', [PH_TBL_NAME_APPLIANCES,
    PH_TBL_FIELD_NAME_APPLIANCES_PK, PH_TBL_FIELD_NAME_APPLIANCES_NAME,
    PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER,
    PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE, PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE,
    PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER,
    PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR,
    PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY,
    PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING,
    PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND, guid.ToString(), name,
    manufacturer, myVoltage, myAmperage, myActivePower, myInputPower,
    myOutputPower, myStandbyPower, myPowerFactor, myFrequency, energyRating,
    mySurgeProtection, myBatterySize, batteryKind]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error adding new appliance to database: %s', [e.Message]);

  Result := Create(guid);
end;

procedure PhAppliance.Push();
var
  query: string;
  fmtSettings: TFormatSettings;
  voltage, amperage, activePower, inputPower, outputPower, standbyPower,
    powerFactor, frequency, surgeProtection, batterySize: string;
  e: Exception;
begin
  fmtSettings := TFormatSettings.Create();
  fmtSettings.DecimalSeparator := '.';
  fmtSettings.ThousandSeparator := char(0);

  voltage := FormatFloat('#,##0.00', m_Voltage, fmtSettings);
  amperage := FormatFloat('#,##0.00', m_Amperage, fmtSettings);
  activePower := FormatFloat('#,##0.00', m_ActivePower, fmtSettings);
  inputPower := FormatFloat('#,##0.00', m_InputPower, fmtSettings);
  outputPower := IfThen(m_OutputPower = -1.0, 'Null',
    FormatFloat('#,##0.00', m_OutputPower, fmtSettings));

  standbyPower := FormatFloat('#,##0.00', m_StandbyPower, fmtSettings);
  powerFactor := FormatFloat('#,##0.00', m_PowerFactor, fmtSettings);
  frequency := FormatFloat('#,##0.00', m_Frequency, fmtSettings);
  surgeProtection := BoolToStr(m_SurgeProtection, true);
  batterySize := IfThen(m_BatterySize = -1.0, 'Null',
    FormatFloat('#,##0.00', m_BatterySize, fmtSettings));

  query := Format('UPDATE %s ' +
    'SET %s = ''%s'', %s = ''%s'', %s = %s, %s = %s, %s = %s, %s = %s, ' +
    '%s = %s, %s = %s, %s = %s, %s = %s, %s = %d, %s = %s, %s = %s, ' +
    '%s = ''%s'' WHERE %s = ''%s'';', [PH_TBL_NAME_APPLIANCES,
    PH_TBL_FIELD_NAME_APPLIANCES_NAME, m_Name,
    PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER, m_Manufacturer,
    PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE, voltage,
    PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE, amperage,
    PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER, activePower,
    PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER, inputPower,
    PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER, outputPower,
    PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER, standbyPower,
    PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR, powerFactor,
    PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY, frequency,
    PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING, m_EnergyRating,
    PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION, surgeProtection,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE, batterySize,
    PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND, m_BatteryKind,
    PH_TBL_FIELD_NAME_APPLIANCES_PK, m_GUID.ToString()]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error updating database: %s', [e.Message]);
end;

procedure PhAppliance.Pull();
var
  v: Variant;
begin
  with g_Database do
  begin
    if TblAppliances.Locate(PH_TBL_FIELD_NAME_APPLIANCES_PK,
      m_GUID.ToString(), []) then
    begin
      m_Name := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_NAME];
      m_Manufacturer := tblAppliances
        [PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER];

      m_Voltage := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE];
      m_Amperage := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE];
      m_ActivePower := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER];
      m_InputPower := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER];
      m_StandbyPower := tblAppliances
        [PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER];

      m_PowerFactor := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR];
      m_Frequency := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY];
      m_EnergyRating := tblAppliances
        [PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING];

      m_SurgeProtection := tblAppliances
        [PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION];

      v := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER];
      m_OutputPower := IfThen(VarIsNull(v), -1.0, v);

      v := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE];
      m_BatterySize := IfThen(VarIsNull(v), -1.0, v);

      v := tblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND];
      m_BatteryKind := IfThen(VarIsNull(v), '', v);
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

    TblAppliances.First();
  end;
end;

procedure PhAppliance.Sync();
begin
  Push();
  Pull();
end;

function PhAppliance.CalculateCostPerHour(): float;
begin
  // TODO: Implement this.
  Result := 0;
end;

function PhAppliance.Equals(other: PhAppliance): bool;
begin
  if other = nil then
    Result := false
  else
    Result := m_GUID = other.m_GUID;
end;

function PhAppliance.GetGUID(): PhGUID;
begin
  Result := m_GUID;
end;

function PhAppliance.GetName(): string;
begin
  Result := m_Name;
end;

procedure PhAppliance.SetName(const name: string);
begin
  m_Name := name;
end;

function PhAppliance.GetManufacturer(): string;
begin
  Result := m_Manufacturer;
end;

procedure PhAppliance.SetManufacturer(const manufacturer: string);
begin
  m_Manufacturer := manufacturer;
end;

function PhAppliance.GetVoltage(): float;
begin
  Result := m_Voltage;
end;

procedure PhAppliance.SetVoltage(const voltage: float);
begin
  m_Voltage := voltage;
end;

function PhAppliance.GetAmperage(): float;
begin
  Result := m_Amperage;
end;

procedure PhAppliance.SetAmperage(const amperage: float);
begin
  m_Amperage := amperage;
end;

function PhAppliance.GetActivePower(): float;
begin
  Result := m_ActivePower;
end;

procedure PhAppliance.SetActivePower(const activePower: float);
begin
  m_ActivePower := activePower;
end;

function PhAppliance.GetStandbyPower(): float;
begin
  Result := m_StandbyPower;
end;

procedure PhAppliance.SetStandbyPower(const standbyPower: float);
begin
  m_StandbyPower := standbyPower;
end;

function PhAppliance.GetInputPower(): float;
begin
  Result := m_InputPower;
end;

procedure PhAppliance.SetInputPower(const inputPower: float);
begin
  m_InputPower := inputPower;
end;

function PhAppliance.GetOutputPower(): float;
begin
  Result := m_OutputPower;
end;

procedure PhAppliance.SetOutputPower(const outputPower: float);
begin
  m_OutputPower := outputPower;
end;

function PhAppliance.GetFrequency(): float;
begin
  Result := m_Frequency;
end;

procedure PhAppliance.SetFrequency(const frequency: float);
begin
  m_Frequency := frequency;
end;

function PhAppliance.GetEnergyRating(): int;
begin
  Result := m_EnergyRating;
end;

procedure PhAppliance.SetEnegeryRating(const rating: int);
begin
  m_EnergyRating := rating;
end;

function PhAppliance.GetPowerFactor(): float;
begin
  Result := m_PowerFactor;
end;

procedure PhAppliance.SetPowerFactor(const factor: float);
begin
  m_PowerFactor := factor;
end;

function PhAppliance.GetBatterySize(): float;
begin
  Result := m_BatterySize;
end;

procedure PhAppliance.SetBatterySize(const size: float);
begin
  m_BatterySize := size;
end;

function PhAppliance.GetBatteryKind(): string;
begin
  Result := m_BatteryKind;
end;

procedure PhAppliance.SetBatteryKind(const kind: string);
begin
  m_BatteryKind := kind;
end;

function PhAppliance.GetSurgeProtection(): bool;
begin
  Result := m_SurgeProtection;
end;

procedure PhAppliance.SetSurgeProtection(const surgeProtection: bool);
begin
  m_SurgeProtection := surgeProtection;
end;

end.

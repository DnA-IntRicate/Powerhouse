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
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Base, Powerhouse.Logger,
  Powerhouse.Database;

type
  /// <summary>
  /// Object used to interact with appliances in the Powerhouse databaase.
  /// </summary>
  PhAppliance = class(PhDatabaseObjectBase, IEquatable<PhAppliance>)
  public
    /// <summary>
    /// Creates a new appliance in the database.
    /// </summary>
    /// <param name="name">
    /// The name of the appliance.
    /// </param>
    /// <param name="manufacturer">
    /// The manufacturer of the appliance.
    /// </param>
    /// <param name="batteryKind">
    /// The battery kind of the appliance. Set this to an empty string if the
    /// battery kind is not applicable for this appliance.
    /// </param>
    /// <param name="voltage">
    /// The voltage of the appliance.
    /// </param>
    /// <param name="amperage">
    /// The amperage of the appliance.
    /// </param>
    /// <param name="activePower">
    /// The active power of the appliance.
    /// </param>
    /// <param name="standbyPower">
    /// The standby power of the appliance.
    /// </param>
    /// <param name="inputPower">
    /// The input power of the appliance.
    /// </param>
    /// <param name="outputPower">
    /// The output power of the appliance. Set this to -1.0 if it is not
    /// applicable for this appliance.
    /// </param>
    /// <param name="frequency">
    /// The operating frequency of the appliance.
    /// </param>
    /// <param name="powerFactor">
    /// The power factor of the appliance.
    /// </param>
    /// <param name="batterySize">
    /// The battery size of the appliance. Set this to -1.0 if it is not
    /// applicable for this appliance.
    /// </param>
    /// <param name="energyRating">
    /// The energy efficiency rating of the appliance.
    /// </param>
    /// <param name="surgeProtection">
    /// Does this appliance have surge protection or not?
    /// </param>
    /// <returns>
    /// The newly created appliance
    /// </returns>
    class function CreateAppliance(const name, manufacturer,
      batteryKind: string; const voltage, amperage, activePower, standbyPower,
      inputPower, outputPower, frequency, powerFactor, batterySize: float;
      const energyRating: int; const surgeProtection: bool): PhAppliance;

    /// <summary>
    /// Pushes the current state of this appliance to the database by
    /// overwriting it with the current values of this instance.
    /// </summary>
    procedure Push(); override;

    /// <summary>
    /// Pulls the state of this appliance from the database and overwrites this
    /// instance with the values from the database.
    /// </summary>
    procedure Pull(); override;

    /// <summary>
    /// TODO: Implement this function.
    /// </summary>
    function CalculateCostPerHour(): float;

    /// <summary>
    /// Compares the GUIDs of this appliance and 'other' to check for equality.
    /// <param name="other">
    /// The appliance to check for equality against.
    /// </param>
    /// </summary>
    function Equals(other: PhAppliance): bool; reintroduce;

    /// <summary>
    /// Returns the name of the appliance.
    /// </summary>
    function GetName(): string;

    /// <summary>
    /// Sets the name of the appliance.
    /// </summary>
    procedure SetName(const name: string);

    /// <summary>
    /// Returns the manufacturer name of the appliance.
    /// </summary>
    function GetManufacturer(): string;

    /// <summary>
    /// Sets the manufacturer name of the appliance.
    /// </summary>
    procedure SetManufacturer(const manufacturer: string);

    /// <summary>
    /// Returns the voltage of the appliance.
    /// </summary>
    function GetVoltage(): float;

    /// <summary>
    /// Sets the voltage of the appliance.
    /// </summary>
    procedure SetVoltage(const voltage: float);

    /// <summary>
    /// Returns the amperage of the appliance.
    /// </summary>
    function GetAmperage(): float;

    /// <summary>
    /// Sets the amperage of the appliance.
    /// </summary>
    procedure SetAmperage(const amperage: float);

    /// <summary>
    /// Returns the active power of the appliance.
    /// </summary>
    function GetActivePower(): float;

    /// <summary>
    /// Sets the active power of the appliance.
    /// </summary>
    procedure SetActivePower(const activePower: float);

    /// <summary>
    /// Returns the standby power of the appliance.
    /// </summary>
    function GetStandbyPower(): float;

    /// <summary>
    /// Sets the standby power of the appliance.
    /// </summary>
    procedure SetStandbyPower(const standbyPower: float);

    /// <summary>
    /// Returns the input power of the appliance.
    /// </summary>
    function GetInputPower(): float;

    /// <summary>
    /// Sets the input power of the appliance.
    /// </summary>
    procedure SetInputPower(const inputPower: float);

    /// <summary>
    /// Returns the output power of the appliance.
    /// </summary>
    function GetOutputPower(): float;

    /// <summary>
    /// Sets the output power of the appliance. Set this to -1.0 if it is not
    /// applicable for this appliance.
    /// </summary>
    procedure SetOutputPower(const outputPower: float);

    /// <summary>
    /// Returns the operating frequency of the appliance.
    /// </summary>
    function GetFrequency(): float;

    /// <summary>
    /// Sets the operating frequency of the appliance.
    /// </summary>
    procedure SetFrequency(const frequency: float);

    /// <summary>
    /// Returns the energy efficiency rating of the appliance.
    /// </summary>
    function GetEnergyRating(): int;

    /// <summary>
    /// Sets the energy efficiency rating of the appliance.
    /// </summary>
    procedure SetEnegeryRating(const rating: int);

    /// <summary>
    /// Returns the power factor of the appliance.
    /// </summary>
    function GetPowerFactor(): float;

    /// <summary>
    /// Sets the power factor of the appliance.
    /// </summary>
    procedure SetPowerFactor(const factor: float);

    /// <summary>
    /// Returns the battery size of the appliance.
    /// </summary>
    function GetBatterySize(): float;

    /// <summary>
    /// Returns the battery size of the appliance. Set this to -1.0 if it is not
    /// applicable for this appliance.
    /// </summary>
    procedure SetBatterySize(const size: float);

    /// <summary>
    /// Returns the battery kind of the appliance.
    /// </summary>
    function GetBatteryKind(): string;

    /// <summary>
    /// Sets the battery kind of the appliance. Set this to an empty string if
    /// it is not applicable for this appliance.
    /// </summary>
    procedure SetBatteryKind(const kind: string);

    /// <summary>
    /// Returns the surge protection state of the appliance.
    /// </summary>
    function GetSurgeProtection(): bool;

    /// <summary>
    /// Set the surge protection state of the appliance.
    /// </summary>
    procedure SetSurgeProtection(const surgeProtection: bool);

  private
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
    m_SurgeProtection: bool;
  end;

type
  /// <summary>
  /// Typedef for a pointer to a <c>PhAppliance</c> object.
  /// </summary>
  PhAppliancePtr = ^PhAppliance;

  /// <summary>
  /// Typedef for a vector of <c>PhAppliance</c>.
  /// </summary>
  PhAppliances = PhVector<PhAppliance>;

const
  /// <summary>
  /// The name of the primary key field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_PK = 'ApplianceGUID';

  /// <summary>
  /// The name of the appliance name field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_NAME = 'ApplianceName';

  /// <summary>
  /// The name of the manufacturer name field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_MANUFACTURER = 'Manufacturer';

  /// <summary>
  /// The name of the voltage field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_VOLTAGE = 'Voltage';

  /// <summary>
  /// The name of the amperage field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_AMPERAGE = 'Amperage';

  /// <summary>
  /// The name of the active power field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>s
  PH_TBL_FIELD_NAME_APPLIANCES_ACTIVE_POWER = 'ActivePowerConsumption';

  /// <summary>
  /// The name of the input power field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_INPUT_POWER = 'InputPower';

  /// <summary>
  /// The name of the output power field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_OUTPUT_POWER = 'OutputPower';

  /// <summary>
  /// The name of the standby power field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_STANDBY_POWER = 'StandbyPowerConsumption';

  /// <summary>
  /// The name of the power factor field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_POWER_FACTOR = 'PowerFactor';

  /// <summary>
  /// The name of the operating frequency field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_FREQUENCY = 'Frequency';

  /// <summary>
  /// The name of the energy efficiency rating field in the 'appliances' table
  /// in the Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_ENERGY_RATING = 'EnergyEfficiencyRating';

  /// <summary>
  /// The name of the surge protection field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_SURGE_PROTECTION = 'SurgeProtection';

  /// <summary>
  /// The name of the battery size field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_SIZE = 'BatterySize';

  /// <summary>
  /// The name of the battery kind field in the 'appliances' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_APPLIANCES_BATTERY_KIND = 'BatteryKind';

implementation

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

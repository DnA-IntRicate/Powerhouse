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
  System.SysUtils, System.StrUtils, System.Math, Powerhouse.Database;

type
  PhAppliance = class
  public
    constructor Create(id: uint32); overload;
    constructor Create(name: string; watt, ic, iv, cph: real); overload;

    function CalculateCostPerHour(): real;

    function GetID(): integer;
    function GetName(): string;

    function GetWattage(): real;
    procedure SetWattage(newWatt: real);

    function GetInputCurrent(): real;
    procedure SetInputCurrent(newIc: real);

    function GetInputVoltage(): real;
    procedure SetInputVoltage(newIv: real);

  private
    procedure UpdateInDatabase();

  private
    m_ID: uint32;
    m_Name: string;

    m_Wattage: real;
    m_InputCurrent: real;
    m_InputVoltage: real;
    m_CostPerHour: real;
  end;

type
  PhAppliances = TArray<PhAppliance>;

const
  TBL_FIELD_NAME_APPLIANCES_PK: string = 'ApplianceID';
  TBL_FIELD_NAME_APPLIANCES_NAME: string = 'ApplianceName';
  TBL_FIELD_NAME_APPLIANCES_WATTAGE: string = 'Wattage';
  TBL_FIELD_NAME_APPLIANCES_INPUT_CURRENT: string = 'InputCurrent';
  TBL_FIELD_NAME_APPLIANCES_INPUT_VOLTAGE: string = 'InputVoltage';
  TBL_FIELD_NAME_APPLIANCES_COST_PER_HOUR: string = 'CostPerHour';

implementation

constructor PhAppliance.Create(id: uint32);
begin
  m_ID := id;

  with g_Database do
  begin
    TblAppliances.First();

    // Find the record in the table where ApplianceID = m_ID.
    while not Eof do
    begin
      if m_ID = TblAppliances[TBL_FIELD_NAME_APPLIANCES_PK] then
        break;

      TblAppliances.Next();
    end;

    m_Name := TblAppliances[TBL_FIELD_NAME_APPLIANCES_NAME];
    m_Wattage := TblAppliances[TBL_FIELD_NAME_APPLIANCES_WATTAGE];
    m_InputCurrent := TblAppliances[TBL_FIELD_NAME_APPLIANCES_INPUT_CURRENT];
    m_InputVoltage := TblAppliances[TBL_FIELD_NAME_APPLIANCES_INPUT_VOLTAGE];
    m_CostPerHour := TblAppliances[TBL_FIELD_NAME_APPLIANCES_COST_PER_HOUR];
  end;
end;

constructor PhAppliance.Create(name: string; watt, ic, iv, cph: real);
begin
  // If this constructor is invoked it is assumed that the program is attempting to create a new
  // appliance to be inserted into the database, therefore the id of this instance is being set
  // to the next valid id, i.e: ApplianceID of the last record in tblAppliances + 1, so as to not
  // cause any insert anomalies.

  g_Database.TblAppliances.Last();
  m_ID := g_Database.TblAppliances[TBL_FIELD_NAME_APPLIANCES_PK] + 1;
  g_Database.TblAppliances.First();

  m_Name := name;
  m_Wattage := watt;
  m_InputCurrent := ic;
  m_InputVoltage := iv;
  m_CostPerHour := cph;
end;

function PhAppliance.CalculateCostPerHour(): real;
begin
  // TODO: Implement this.
end;

function PhAppliance.GetID(): integer;
begin
  Result := m_ID;
end;

function PhAppliance.GetName(): string;
begin
  Result := m_Name;
end;

function PhAppliance.GetWattage(): real;
begin
  Result := m_Wattage;
end;

procedure PhAppliance.SetWattage(newWatt: real);
begin
  m_Wattage := newWatt;

  UpdateInDatabase();
end;

function PhAppliance.GetInputCurrent(): real;
begin
  Result := m_InputCurrent;
end;

procedure PhAppliance.SetInputCurrent(newIc: real);
begin
  m_InputCurrent := newIc;

  UpdateInDatabase();
end;

function PhAppliance.GetInputVoltage(): real;
begin
  Result := m_InputVoltage;
end;

procedure PhAppliance.SetInputVoltage(newIv: real);
begin
  m_InputVoltage := newIv;

  UpdateInDatabase();
end;

procedure PhAppliance.UpdateInDatabase();
var
  sQuery: string;
  e: Exception;
begin
  sQuery := Format('UPDATE %s' + #13#10 +
    'SET %s = ''%s'', %s = %f, %s = %f, %s = %f, %s = %f' + #13#10 +
    'WHERE %s = %d', [TBL_NAME_APPLIANCES, TBL_FIELD_NAME_APPLIANCES_NAME,
    m_Name, TBL_FIELD_NAME_APPLIANCES_WATTAGE, m_Wattage,
    TBL_FIELD_NAME_APPLIANCES_INPUT_CURRENT, m_InputCurrent,
    TBL_FIELD_NAME_APPLIANCES_INPUT_VOLTAGE, m_InputVoltage,
    TBL_FIELD_NAME_APPLIANCES_COST_PER_HOUR, m_CostPerHour,
    TBL_FIELD_NAME_APPLIANCES_PK, m_ID]);

  e := g_Database.RunQuery(sQuery);

  // TODO: Handle exceptions better and display the message somewhere.
  if e <> nil then
    raise e;
end;

end.

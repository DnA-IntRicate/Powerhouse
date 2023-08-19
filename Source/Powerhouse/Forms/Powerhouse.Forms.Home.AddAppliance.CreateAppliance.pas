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

unit Powerhouse.Forms.Home.AddAppliance.CreateAppliance;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.StrUtils, System.Math, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  Powerhouse.Types, Powerhouse.Defines, Powerhouse.Vector, Powerhouse.Form,
  Powerhouse.Validator, Powerhouse.Logger, Powerhouse.Database,
  Powerhouse.Appliance, Powerhouse.User;

type
  TPhfCreateAppliance = class(PhForm)
    btnCreate: TButton;
    pnlModifyAppliance: TPanel;
    edtName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtManufacturer: TEdit;
    Label3: TLabel;
    edtVoltage: TEdit;
    edtActivePower: TEdit;
    Label4: TLabel;
    edtAmperage: TEdit;
    Label5: TLabel;
    edtStandbyPower: TEdit;
    Label6: TLabel;
    edtInputPower: TEdit;
    Label7: TLabel;
    edtOutputPower: TEdit;
    Label8: TLabel;
    edtFrequency: TEdit;
    Label9: TLabel;
    sedEfficiencyRating: TSpinEdit;
    Label10: TLabel;
    edtPowerFactor: TEdit;
    Label11: TLabel;
    edtBatteryKind: TEdit;
    Label12: TLabel;
    edtBatterySize: TEdit;
    Label13: TLabel;
    cbxSurgeProtection: TCheckBox;
    btnCancel: TButton;
    Label14: TLabel;
    procedure btnCreateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure edtManufacturerExit(Sender: TObject);
    procedure edtVoltageExit(Sender: TObject);
    procedure edtAmperageExit(Sender: TObject);
    procedure edtActivePowerExit(Sender: TObject);
    procedure edtStandbyPowerExit(Sender: TObject);
    procedure edtInputPowerExit(Sender: TObject);
    procedure edtOutputPowerExit(Sender: TObject);
    procedure edtPowerFactorExit(Sender: TObject);
    procedure edtFrequencyExit(Sender: TObject);
    procedure edtBatterySizeExit(Sender: TObject);
    procedure edtBatteryKindExit(Sender: TObject);

  public
    procedure EnableModal(); override;

    function Cancelled(): bool;

    function GetNewAppliance(): PhAppliance;

  private
    function ValidateName(const name: string): bool;
    function ValidateManufacturer(const manufacturer: string): bool;
    function ValidateVoltage(const voltageStr: string): bool;
    function ValidateAmperage(const amperageStr: string): bool;
    function ValidateActivePower(const activePowerStr: string): bool;
    function ValidateInputPower(const inputPowerStr: string): bool;
    function ValidateOutputPower(const outputPowerStr: string): bool;
    function ValidateStandbyPower(const standbyPowerStr: string): bool;
    function ValidatePowerFactor(const powerFactorStr: string): bool;
    function ValidateFrequency(const frequencyStr: string): bool;
    function ValidateBatterySize(const batterySizeStr: string): bool;
    function ValidateBatteryKind(const batteryKind: string): bool;

    procedure TryEnableBtnCreate();

  private
    m_NewAppliance: PhAppliance;
    m_Cancelled: bool;

    m_ValidName: bool;
    m_ValidManufacturer: bool;
    m_ValidVoltage: bool;
    m_ValidAmperage: bool;
    m_ValidActivePower: bool;
    m_ValidInputPower: bool;
    m_ValidOutputPower: bool;
    m_ValidStandbyPower: bool;
    m_ValidPowerFactor: bool;
    m_ValidFrequency: bool;
    m_ValidBatterySize: bool;
    m_ValidBatteryKind: bool;
  end;

implementation

{$R *.dfm}

procedure TPhfCreateAppliance.btnCreateClick(Sender: TObject);
var
  name, manufacturer, batteryKind: string;
  voltage, amperage, activePower, inputPower, outputPower, standbyPower,
    powerFactor, frequency, batterySize: float;
  efficiencyRating: int;
begin
  name := edtName.Text;
  manufacturer := edtManufacturer.Text;
  batteryKind := IfThen(edtBatteryKind.Text <> 'N/A', edtBatteryKind.Text, '');

  voltage := StrToFloat(edtVoltage.Text);
  amperage := StrToFloat(edtAmperage.Text);
  activePower := StrToFloat(edtActivePower.Text);
  inputPower := StrToFloat(edtInputPower.Text);

  if edtOutputPower.Text <> 'N/A' then
    outputPower := StrToFloat(edtOutputPower.Text)
  else
    outputPower := -1.0;

  standbyPower := StrToFloat(edtStandbyPower.Text);
  powerFactor := StrToFloat(edtPowerFactor.Text);
  frequency := StrToFloat(edtFrequency.Text);

  if edtBatterySize.Text <> 'N/A' then
    batterySize := StrToFloat(edtBatterySize.Text)
  else
    batterySize := -1.0;

  efficiencyRating := sedEfficiencyRating.Value;

  m_NewAppliance := PhAppliance.CreateAppliance(name, manufacturer, batteryKind,
    voltage, amperage, activePower, standbyPower, inputPower, outputPower,
    frequency, powerFactor, batterySize, efficiencyRating,
    cbxSurgeProtection.Checked);

  DisableModal();
end;

procedure TPhfCreateAppliance.btnCancelClick(Sender: TObject);
begin
  m_NewAppliance := nil;
  m_Cancelled := true;

  DisableModal();
end;

procedure TPhfCreateAppliance.edtNameExit(Sender: TObject);
begin
  m_ValidName := ValidateName(edtName.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtManufacturerExit(Sender: TObject);
begin
  m_ValidManufacturer := ValidateManufacturer(edtManufacturer.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtVoltageExit(Sender: TObject);
begin
  m_ValidVoltage := ValidateVoltage(edtVoltage.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtAmperageExit(Sender: TObject);
begin
  m_ValidAmperage := ValidateAmperage(edtAmperage.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtActivePowerExit(Sender: TObject);
begin
  m_ValidActivePower := ValidateActivePower(edtActivePower.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtStandbyPowerExit(Sender: TObject);
begin
  m_ValidStandbyPower := ValidateStandbyPower(edtStandbyPower.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtInputPowerExit(Sender: TObject);
begin
  m_ValidInputPower := ValidateInputPower(edtInputPower.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtOutputPowerExit(Sender: TObject);
begin
  if (edtOutputPower.Text = '') or (UpperCase(edtOutputPower.Text) = 'N/A') then
    edtOutputPower.Text := 'N/A';

  m_ValidOutputPower := ValidateOutputPower(edtOutputPower.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtPowerFactorExit(Sender: TObject);
begin
  m_ValidPowerFactor := ValidatePowerFactor(edtPowerFactor.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtFrequencyExit(Sender: TObject);
begin
  m_ValidFrequency := ValidateFrequency(edtFrequency.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtBatterySizeExit(Sender: TObject);
begin
  if (edtBatterySize.Text = '') or (UpperCase(edtBatterySize.Text) = 'N/A') then
    edtBatterySize.Text := 'N/A';

  m_ValidBatterySize := ValidateBatterySize(edtBatterySize.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.edtBatteryKindExit(Sender: TObject);
begin
  if (edtBatteryKind.Text = '') or (UpperCase(edtBatteryKind.Text) = 'N/A') then
    edtBatteryKind.Text := 'N/A';

  m_ValidBatteryKind := ValidateBatteryKind(edtBatteryKind.Text);

  TryEnableBtnCreate();
end;

procedure TPhfCreateAppliance.EnableModal();
begin
  Self.Caption := Format('Create Appliance - %s',
    [g_CurrentUser.GetUsername()]);

  btnCreate.Enabled := false;

  m_Cancelled := false;
  m_ValidName := false;
  m_ValidManufacturer := false;
  m_ValidVoltage := false;
  m_ValidAmperage := false;
  m_ValidActivePower := false;
  m_ValidInputPower := false;
  m_ValidStandbyPower := false;
  m_ValidPowerFactor := false;
  m_ValidFrequency := false;

  m_ValidOutputPower := true;
  m_ValidBatterySize := true;
  m_ValidBatteryKind := true;

  inherited EnableModal();
end;

function TPhfCreateAppliance.Cancelled(): bool;
begin
  Result := m_Cancelled;
end;

function TPhfCreateAppliance.GetNewAppliance(): PhAppliance;
begin
  Result := m_NewAppliance;
end;

function TPhfCreateAppliance.ValidateName(const name: string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  validation := PhValidator.ValidateString(name, [Letters, Numbers], 0,
    PH_MAX_LENGTH_APPLIANCE_STR);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Appliance name cannot be left empty!');
      Exit();
    end;

    if PhValidationFlag.TooLong in validation.Flags then
    begin
      PhLogger.Warn('Appliance name cannot exceed %d characters!',
        [PH_MAX_LENGTH_APPLIANCE_STR]);
    end;

    if PhValidationFlag.InvalidFormat in validation.Flags then
      PhLogger.Warn('Appliance name cannot contain symbols!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Appliance name contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateManufacturer(const manufacturer
  : string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  validation := PhValidator.ValidateString(manufacturer, [Letters, Numbers], 0,
    PH_MAX_LENGTH_APPLIANCE_STR);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Manufacturer name cannot be left empty!');
      Exit();
    end;

    if PhValidationFlag.TooLong in validation.Flags then
    begin
      PhLogger.Warn('Manufacturer name cannot exceed %d characters!',
        [PH_MAX_LENGTH_APPLIANCE_STR]);
    end;

    if PhValidationFlag.InvalidFormat in validation.Flags then
      PhLogger.Warn('Manufacturer name cannot contain symbols!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Manufacturer name contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateVoltage(const voltageStr: string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(voltageStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Voltage cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(voltageStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Voltage is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Voltage contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateAmperage(const amperageStr: string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(amperageStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Amperage cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(amperageStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Amperage is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Amperage contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateActivePower(const activePowerStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(activePowerStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Active Power cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(activePowerStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Active Power is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Active Power contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateInputPower(const inputPowerStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(inputPowerStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Input Power cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(inputPowerStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Input Power is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Input Power contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateOutputPower(const outputPowerStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  if outputPowerStr = 'N/A' then
    Exit(true);

  validation := PhValidator.ValidateString(outputPowerStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    convertible := TryStrToFloat(outputPowerStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Output Power is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Output Power contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateStandbyPower(const standbyPowerStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(standbyPowerStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Standby Power cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(standbyPowerStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Standby Power is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Standby Power contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidatePowerFactor(const powerFactorStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(powerFactorStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Power Factor cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(powerFactorStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Power Factor is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Power Factor contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateFrequency(const frequencyStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  validation := PhValidator.ValidateString(frequencyStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Operating Frequency cannot be left empty!');
      Exit();
    end;

    convertible := TryStrToFloat(frequencyStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Operating Frequency is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Operating Frequency contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateBatterySize(const batterySizeStr
  : string): bool;
var
  validation: PhValidation;
  f: float;
  convertible: bool;
begin
  Result := false;

  if batterySizeStr = 'N/A' then
    Exit(true);

  validation := PhValidator.ValidateString(batterySizeStr, [Numbers]);

  if validation.Valid then
    Result := true
  else
  begin
    convertible := TryStrToFloat(batterySizeStr, f);
    if (PhValidationFlag.InvalidFormat in validation.Flags) or convertible then
      PhLogger.Warn('Battery Size is in an incorrect format!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Battery Size contains forbidden characters!');
  end;
end;

function TPhfCreateAppliance.ValidateBatteryKind(const batteryKind
  : string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  if batteryKind = 'N/A' then
    Exit(true);

  validation := PhValidator.ValidateString(batteryKind, [Letters], 0,
    PH_MAX_LENGTH_APPLIANCE_STR_BATTERY_KIND);

  if validation.Valid then
    Result := true
  else
  begin
    if PhValidationFlag.TooLong in validation.Flags then
    begin
      PhLogger.Warn('Battery type cannot exceed %d characters.',
        [PH_MAX_LENGTH_APPLIANCE_STR]);
    end;

    if PhValidationFlag.InvalidFormat in validation.Flags then
      PhLogger.Warn('Battery type cannot contain any numbers or symbols!');

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Battery type contains forbidden characters!');
  end;
end;

procedure TPhfCreateAppliance.TryEnableBtnCreate();
begin
  btnCreate.Enabled := m_ValidName and m_ValidManufacturer and
    m_ValidVoltage and m_ValidAmperage and m_ValidActivePower and
    m_ValidInputPower and m_ValidOutputPower and m_ValidStandbyPower and
    m_ValidPowerFactor and m_ValidFrequency and m_ValidBatterySize and
    m_ValidBatteryKind;
end;

end.

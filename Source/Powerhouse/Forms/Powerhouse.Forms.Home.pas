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

unit Powerhouse.Forms.Home;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.StrUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Form, Powerhouse.Logger,
  Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User,
  Powerhouse.SaveData,
  Powerhouse.Forms.Home.AddAppliance;

type
  TPhfHome = class(PhForm)
    lstAppliances: TListBox;
    pnlApplianceInformation: TPanel;
    Label1: TLabel;
    btnModifyAppliance: TButton;
    pnlHomeForm: TPanel;
    Label3: TLabel;
    pgcHome: TPageControl;
    tabAppliances: TTabSheet;
    tabInsights: TTabSheet;
    tabCalculator: TTabSheet;
    tabAccount: TTabSheet;
    tabHelp: TTabSheet;
    btnAddAppliance: TButton;
    lblApplianceInformation2: TLabel;
    lblManufacturer: TLabel;
    lblApplianceName: TLabel;
    lblApplianceInformation1: TLabel;
    lblVoltage: TLabel;
    lblApplianceInformation3: TLabel;
    lblAmperage: TLabel;
    lblApplianceInformation4: TLabel;
    lblActivePowerConsumption: TLabel;
    lblApplianceInformation5: TLabel;
    lblInputPower: TLabel;
    lblApplianceInformation6: TLabel;
    lblOutputPower: TLabel;
    lblApplianceInformation7: TLabel;
    lblStandbyPowerConsumption: TLabel;
    lblApplianceInformation8: TLabel;
    lblPowerFactor: TLabel;
    lblApplianceInformation9: TLabel;
    lblFrequency: TLabel;
    lblApplianceInformation10: TLabel;
    lblEnergyEfficiencyRating: TLabel;
    lblApplianceInformation11: TLabel;
    lblSurgeProtection: TLabel;
    lblApplianceInformation12: TLabel;
    lblApplianceInformation13: TLabel;
    lblBatterySize: TLabel;
    lblApplianceInformation14: TLabel;
    lblBatteryKind: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddApplianceClick(Sender: TObject);
    procedure lstAppliancesClick(Sender: TObject);
    procedure lstAppliancesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  public
    procedure Enable(); override;

  private
    procedure ShowApplianceInformationLabels(const show: bool);
    procedure AddAppliance();
  end;

var
  g_HomeForm: TPhfHome;

implementation

{$R *.dfm}

procedure TPhfHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Quit();
end;

procedure TPhfHome.btnAddApplianceClick(Sender: TObject);
begin
  AddAppliance();
end;

procedure TPhfHome.lstAppliancesClick(Sender: TObject);
var
  currentApplianceName: string;
  appliance: PhAppliance;

  voltage, amperage, activePower, inputPower, outputPower, standbyPower,
    powerFactor, frequency, energyRating, surgeProtection, batterySize,
    batteryKind: string;
begin
  if lstAppliances.ItemIndex = -1 then
  begin
    ShowApplianceInformationLabels(false);
    Exit();
  end;

  currentApplianceName := lstAppliances.Items[lstAppliances.ItemIndex];
  appliance := g_CurrentUser.GetApplianceByName(currentApplianceName);

  voltage := Format('%fV', [appliance.GetVoltage()]);
  amperage := Format('%fA', [appliance.GetAmperage()]);
  activePower := Format('%fW', [appliance.GetActivePower()]);
  inputPower := Format('%fW', [appliance.GetInputPower()]);
  outputPower := IfThen(appliance.GetOutputPower() <> -1.0,
    Format('%fW', [appliance.GetOutputPower()]), 'N/A');
  standbyPower := Format('%fW', [appliance.GetStandbyPower()]);
  powerFactor := Format('%f', [appliance.GetPowerFactor()]);
  frequency := Format('%fHz', [appliance.GetFrequency()]);
  energyRating := Format('%d', [appliance.GetEnergyRating()]);
  surgeProtection := Ifthen(appliance.GetSurgeProtection(), 'Yes', 'No');
  batterySize := IfThen(appliance.GetBatterySize() <> -1.0,
    Format('%fmAH', [appliance.GetBatterySize()]), 'N/A');
  batteryKind := IfThen(appliance.GetBatteryKind() <> '',
    appliance.GetBatteryKind(), 'N/A');

  lblApplianceName.Caption := appliance.GetName();
  lblManufacturer.Caption := appliance.GetManufacturer();
  lblVoltage.Caption := voltage;
  lblAmperage.Caption := amperage;
  lblActivePowerConsumption.Caption := activePower;
  lblInputPower.Caption := inputPower;
  lblOutputPower.Caption := outputPower;
  lblStandbyPowerConsumption.Caption := standbyPower;
  lblPowerFactor.Caption := powerFactor;
  lblFrequency.Caption := frequency;
  lblEnergyEfficiencyRating.Caption := energyRating;
  lblSurgeProtection.Caption := surgeProtection;
  lblBatterySize.Caption := batterySize;
  lblBatteryKind.Caption := batteryKind;

  ShowApplianceInformationLabels(true);
end;

procedure TPhfHome.lstAppliancesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> TMouseButton.mbLeft then
    Exit();

  if lstAppliances.ItemAtPos(TPoint.Create(X, Y), true) = -1 then
    lstAppliances.ItemIndex := -1;
end;

procedure TPhfHome.Enable();
var
  appliance: PhAppliance;
  appliances: PhAppliances;
begin
  inherited Enable();

  appliances := g_CurrentUser.GetAppliances();
  for appliance in appliances do
    lstAppliances.Items.Add(appliance.GetName());

  ShowApplianceInformationLabels(false);

  GetParentForm(
    procedure(parentPtr: PhFormPtr)
    begin
      ShowMessage(parentPtr.Caption);
    end);
end;

procedure TPhfHome.ShowApplianceInformationLabels(const show: bool);
begin
  lblApplianceInformation1.Visible := show;
  lblApplianceInformation2.Visible := show;
  lblApplianceInformation3.Visible := show;
  lblApplianceInformation4.Visible := show;
  lblApplianceInformation5.Visible := show;
  lblApplianceInformation6.Visible := show;
  lblApplianceInformation7.Visible := show;
  lblApplianceInformation8.Visible := show;
  lblApplianceInformation9.Visible := show;
  lblApplianceInformation10.Visible := show;
  lblApplianceInformation11.Visible := show;
  lblApplianceInformation12.Visible := show;
  lblApplianceInformation13.Visible := show;
  lblApplianceInformation14.Visible := show;

  lblApplianceName.Visible := show;
  lblManufacturer.Visible := show;
  lblVoltage.Visible := show;
  lblAmperage.Visible := show;
  lblActivePowerConsumption.Visible := show;
  lblInputPower.Visible := show;
  lblOutputPower.Visible := show;
  lblStandbyPowerConsumption.Visible := show;
  lblPowerFactor.Visible := show;
  lblFrequency.Visible := show;
  lblEnergyEfficiencyRating.Visible := show;
  lblSurgeProtection.Visible := show;
  lblBatterySize.Visible := show;
  lblBatteryKind.Visible := show;
end;

procedure TPhfHome.AddAppliance();
var
  addApplianceForm: TPhfAddAppliance;
  newAppliance: PhAppliance;
begin
  addApplianceForm := TPhfAddAppliance.Create(Self);
  addApplianceForm.EnableModal();
  newAppliance := addApplianceForm.GetNewAppliance();
  addApplianceForm.Free();

  if newAppliance <> nil then
  begin
    g_CurrentUser.AddAppliance(newAppliance);
    lstAppliances.Items.Add(newAppliance.GetName());

    g_SaveData.AddOrUpdateUser(g_CurrentUser);
  end;
end;

end.

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
  Powerhouse.Forms.Home.ModifyAppliance, Powerhouse.Forms.Home.AddAppliance;

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
    btnRemoveAppliance: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddApplianceClick(Sender: TObject);
    procedure lstAppliancesClick(Sender: TObject);
    procedure lstAppliancesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnModifyApplianceClick(Sender: TObject);
    procedure btnRemoveApplianceClick(Sender: TObject);

  public
    procedure Enable(); override;

  private
    procedure DisplayAppliances();

    procedure ShowApplianceInformationLabels(const show: bool);
    procedure ShowApplianceInformation(const show: bool);

    procedure AddAppliance();
    procedure RemoveAppliance();
  end;

var
  g_HomeForm: TPhfHome;
  g_Appliance: PhAppliance;

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
begin
  ShowApplianceInformation(lstAppliances.ItemIndex <> -1);
end;

procedure TPhfHome.lstAppliancesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> TMouseButton.mbLeft then
    Exit();

  if lstAppliances.ItemAtPos(TPoint.Create(X, Y), true) = -1 then
    lstAppliances.ItemIndex := -1;
end;

procedure TPhfHome.btnModifyApplianceClick(Sender: TObject);
var
  modifyApplianceForm: TPhfModifyAppliance;
begin
  modifyApplianceForm := TPhfModifyAppliance.Create(Self);
  modifyApplianceForm.SetContext(@g_Appliance);
  modifyApplianceForm.EnableModal();
  modifyApplianceForm.Free();

  DisplayAppliances();
  ShowApplianceInformation(true);
end;

procedure TPhfHome.btnRemoveApplianceClick(Sender: TObject);
begin
  RemoveAppliance();
end;

procedure TPhfHome.Enable();
begin
  inherited Enable();

  Self.Caption := Format('Powerhouse - %s', [g_CurrentUser.GetUsername()]);

  DisplayAppliances();
  ShowApplianceInformation(false);
end;

procedure TPhfHome.DisplayAppliances();
var
  appliances: PhAppliances;
  appliance: PhAppliance;
  backupIdx: int;
begin
  backupIdx := lstAppliances.ItemIndex;
  lstAppliances.Clear();

  appliances := g_CurrentUser.GetAppliances();
  for appliance in appliances do
    lstAppliances.Items.Add(appliance.GetName());

  lstAppliances.ItemIndex := backupIdx;
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

  btnModifyAppliance.Enabled := show;
  btnRemoveAppliance.Enabled := show;
end;

procedure TPhfHome.ShowApplianceInformation(const show: bool);
var
  currentApplianceName: string;
  voltage, amperage, activePower, inputPower, outputPower, standbyPower,
    powerFactor, frequency, energyRating, surgeProtection, batterySize,
    batteryKind: string;
begin
  g_Appliance := nil;

  if show then
  begin
    currentApplianceName := lstAppliances.Items[lstAppliances.ItemIndex];
    g_Appliance := g_CurrentUser.GetApplianceByName(currentApplianceName);

    if g_Appliance <> nil then
    begin
      voltage := Format('%fV', [g_Appliance.GetVoltage()]);
      amperage := Format('%fA', [g_Appliance.GetAmperage()]);
      activePower := Format('%fW', [g_Appliance.GetActivePower()]);
      inputPower := Format('%fW', [g_Appliance.GetInputPower()]);
      outputPower := IfThen(g_Appliance.GetOutputPower() <> -1.0,
        Format('%fW', [g_Appliance.GetOutputPower()]), 'N/A');

      standbyPower := Format('%fW', [g_Appliance.GetStandbyPower()]);
      powerFactor := Format('%f', [g_Appliance.GetPowerFactor()]);
      frequency := Format('%fHz', [g_Appliance.GetFrequency()]);
      energyRating := Format('%d', [g_Appliance.GetEnergyRating()]);
      surgeProtection := Ifthen(g_Appliance.GetSurgeProtection(), 'Yes', 'No');
      batterySize := IfThen(g_Appliance.GetBatterySize() <> -1.0,
        Format('%fmAH', [g_Appliance.GetBatterySize()]), 'N/A');

      batteryKind := IfThen(g_Appliance.GetBatteryKind() <> '',
        g_Appliance.GetBatteryKind(), 'N/A');

      lblApplianceName.Caption := g_Appliance.GetName();
      lblManufacturer.Caption := g_Appliance.GetManufacturer();
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
    end;
  end;

  ShowApplianceInformationLabels(show);
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

    g_Appliance := newAppliance;
    lstAppliances.ItemIndex := lstAppliances.Count - 1;
    lstAppliancesClick(nil);
  end;
end;

procedure TPhfHome.RemoveAppliance();
var
  applianceName: string;
  dlgResult: int;
  appliance: PhAppliance;
begin
  applianceName := lstAppliances.Items[lstAppliances.ItemIndex];

  PhLogger.Warn('Are you sure you want to remove ''%s'' from your appliances?',
    dlgResult, [applianceName]);

  if dlgResult <> mrOk then
    Exit();

  appliance := g_CurrentUser.GetApplianceByName(applianceName);
  g_CurrentUser.RemoveAppliance(appliance);
  g_SaveData.AddOrUpdateUser(g_CurrentUser);

  PhLogger.Info('''%s'' has been removed from your appliances.',
    [applianceName]);

  lstAppliances.ItemIndex := -1;

  DisplayAppliances();
  ShowApplianceInformation(false);
end;

end.

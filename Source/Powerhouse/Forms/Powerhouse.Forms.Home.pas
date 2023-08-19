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
  Vcl.Samples.Spin,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Form, Powerhouse.Logger,
  Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User,
  Powerhouse.SaveData,
  Powerhouse.Forms.Home.ModifyAppliance, Powerhouse.Forms.Home.AddAppliance,
  Powerhouse.Forms.Home.ModifyUser;

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
    lblAccount1: TLabel;
    pnlUserInformation: TPanel;
    Label2: TLabel;
    lblUsername: TLabel;
    lblEmailAddress: TLabel;
    lblAccount2: TLabel;
    lblAccount3: TLabel;
    lblName: TLabel;
    lblSurname: TLabel;
    lblAccount4: TLabel;
    lblApplianceCount: TLabel;
    lblAccount5: TLabel;
    btnModifyUser: TButton;
    pnlCalculator: TPanel;
    edtTariff: TEdit;
    lblCalculator1: TLabel;
    lblCalculator2: TLabel;
    lstAppliances2: TListBox;
    lblCalculator3: TLabel;
    lblCalculator4: TLabel;
    sedUsage: TSpinEdit;
    redInsights: TRichEdit;
    lblInsights1: TLabel;
    lblOverallDailyCost: TLabel;
    lblInsights2: TLabel;
    lblOverallActiveDailyCost: TLabel;
    lblInsights3: TLabel;
    lblOverallStandbyDailyCost: TLabel;
    lblHelp1: TLabel;
    pnlCostInsights: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddApplianceClick(Sender: TObject);
    procedure lstAppliancesClick(Sender: TObject);
    procedure lstAppliancesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnModifyApplianceClick(Sender: TObject);
    procedure btnRemoveApplianceClick(Sender: TObject);
    procedure btnModifyUserClick(Sender: TObject);
    procedure pgcHomeChange(Sender: TObject);
    procedure lstAppliances2Click(Sender: TObject);
    procedure sedUsageExit(Sender: TObject);
    procedure edtTariffExit(Sender: TObject);

  public
    procedure Enable(); override;

  private
    procedure DisplayAppliances();
    procedure DisplayInsights();
    procedure DisplayCalculator();
    procedure DisplayUserInformation();

    procedure ShowApplianceInformationLabels(const show: bool);
    procedure ShowApplianceInformation(const show: bool);

    procedure AddAppliance();
    procedure RemoveAppliance();
  end;

var
  g_HomeForm: TPhfHome;

implementation

type
  InsightData = record
  public
    ActiveRunningCost: float;
    StandbyRunningCost: float;
    DailyUsage: float;
  end;

var
  g_AppliancesTabAppliance: PhAppliance;
  g_CalculatorTabAppliance: PhAppliance;
  g_ApplianceInsights: PhVector<PhPair<string, InsightData>>;

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
  modifyApplianceForm.SetContext(@g_AppliancesTabAppliance);
  modifyApplianceForm.EnableModal();
  modifyApplianceForm.Free();

  DisplayAppliances();
  ShowApplianceInformation(true);
end;

procedure TPhfHome.btnRemoveApplianceClick(Sender: TObject);
begin
  RemoveAppliance();
end;

procedure TPhfHome.btnModifyUserClick(Sender: TObject);
var
  modifyUserForm: TPhfModifyUser;
begin
  modifyUserForm := TPhfModifyUser.Create(Self);
  modifyUserForm.SetContext(@g_CurrentUser);
  modifyUserForm.EnableModal();
  modifyUserForm.Free();

  DisplayUserInformation();
end;

procedure TPhfHome.pgcHomeChange(Sender: TObject);
begin
  if pgcHome.Pages[pgcHome.ActivePageIndex] = tabCalculator then
    DisplayCalculator()
  else if pgcHome.Pages[pgcHome.ActivePageIndex] = tabInsights then
    DisplayInsights();
end;

procedure TPhfHome.lstAppliances2Click(Sender: TObject);
var
  currentApplianceName: string;
begin
  currentApplianceName := lstAppliances2.Items[lstAppliances2.ItemIndex];
  g_CalculatorTabAppliance := g_CurrentUser.GetApplianceByName
    (currentApplianceName);

  if g_CalculatorTabAppliance <> nil then
  begin
    sedUsage.Value := Round(g_CalculatorTabAppliance.GetDailyUsage() * 60.0);

    sedUsage.Enabled := true;
    lblCalculator3.Enabled := true;
    lblCalculator4.Enabled := true;
  end;
end;

procedure TPhfHome.sedUsageExit(Sender: TObject);
const
  MINUTE_TO_HOUR = 0.0166667;
begin
  g_CalculatorTabAppliance.SetDailyUsage(sedUsage.Value * MINUTE_TO_HOUR);
  g_SaveData.AddOrUpdateUser(g_CurrentUser);
end;

procedure TPhfHome.edtTariffExit(Sender: TObject);
begin
  // TODO: Validation

  // IF IT IS NOT EMPTY, VALIDATE!!!
  g_CurrentUser.SetElectricityTariff(StrToFloat(edtTariff.Text));
  g_SaveData.AddOrUpdateUser(g_CurrentUser);
end;

procedure TPhfHome.Enable();
const
  TAB_SIZE_INITIAL = 100;
  TAB_SIZE = 50;
var
  i: int;
begin
  inherited Enable();

  Self.Caption := Format('Powerhouse - %s', [g_CurrentUser.GetUsername()]);

  g_AppliancesTabAppliance := nil;
  g_CalculatorTabAppliance := nil;
  g_ApplianceInsights := PhVector < PhPair < string, InsightData >>.Create();

  redInsights.ReadOnly := true;
  redInsights.Paragraph.TabCount := 4;
  redInsights.Paragraph.Tab[0] := TAB_SIZE_INITIAL;

  for i := 1 to redInsights.Paragraph.TabCount do
    redInsights.Paragraph.Tab[i] := TAB_SIZE_INITIAL + (i * TAB_SIZE);

  DisplayAppliances();
  ShowApplianceInformation(false);

  DisplayInsights();
  DisplayCalculator();
  DisplayUserInformation();
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

procedure TPhfHome.DisplayInsights();
const
  TAB = #9;
  CRLF = #13#10;
  CENT_TO_RAND = 0.01;
var
  i, j: int;
  appliances: PhAppliances;
  appliance: PhAppliance;
  it: PhPair<string, InsightData>;
  overallDailyCost, overallActiveDailyCost, overallStandbyDailyCost: float;
  activeCost, standbyCost, dailyUsage, lineBuf: string;
begin
  redInsights.Clear();
  redInsights.Lines.Add('Appliance Name' + TAB + 'Daily Usage' + TAB +
    'Daily Cost' + TAB + 'Standby Cost' + CRLF);

  redInsights.SelStart := 0;
  redInsights.SelLength := Length(redInsights.Lines[0]);
  redInsights.SelAttributes.Style := [TFontStyle.fsBold];

  appliances := g_CurrentUser.GetAppliances();
  g_ApplianceInsights.Clear();

  for appliance in appliances do
  begin
    it.First := appliance.GetName();
    it.Second.DailyUsage := appliance.GetDailyUsage();
    it.Second.ActiveRunningCost := appliance.CalculateActiveRunningCost
      (g_CurrentUser.GetElectricityTariff(), appliance.GetDailyUsage()) *
      CENT_TO_RAND;

    it.Second.StandbyRunningCost := appliance.CalculateStandbyRunningCost
      (g_CurrentUser.GetElectricityTariff(), 24 - appliance.GetDailyUsage()) *
      CENT_TO_RAND;

    g_ApplianceInsights.PushBack(it);
  end;

  // Sort in descending order of Active Running Cost
  for i := g_ApplianceInsights.First() to g_ApplianceInsights.Last() - 1 do
  begin
    for j := g_ApplianceInsights.First() to g_ApplianceInsights.Last() - 1 do
    begin
      if g_ApplianceInsights[j].Second.ActiveRunningCost < g_ApplianceInsights
        [j + 1].Second.ActiveRunningCost then
      begin
        it := g_ApplianceInsights[j];
        g_ApplianceInsights[j] := g_ApplianceInsights[j + 1];
        g_ApplianceInsights[j + 1] := it;
      end;
    end;
  end;

  g_ApplianceInsights.ShrinkToFit();

  overallDailyCost := 0.0;
  overallActiveDailyCost := 0.0;
  overallStandbyDailyCost := 0.0;

  for it in g_ApplianceInsights do
  begin
    overallDailyCost := overallDailyCost + it.Second.ActiveRunningCost +
      it.Second.StandbyRunningCost;

    overallActiveDailyCost := overallActiveDailyCost +
      it.Second.ActiveRunningCost;

    overallStandbyDailyCost := overallStandbyDailyCost +
      it.Second.StandbyRunningCost;

    activeCost := FloatToStrF(it.Second.ActiveRunningCost, ffCurrency, 8, 2);
    standbyCost := FloatToStrF(it.Second.StandbyRunningCost, ffCurrency, 8, 2);
    dailyUsage := FloatToStrF(it.Second.DailyUsage, ffFixed, 2, 2);

    lineBuf := it.First + TAB + Format('%s Hour(s)', [dailyUsage]) + TAB +
      activeCost + TAB + standbyCost;

    redInsights.Lines.Add(lineBuf);
  end;

  redInsights.SelStart := Length(redInsights.Lines[0]);
  redInsights.SelLength := MaxInt;
  redInsights.SelAttributes.Style := [];
  redInsights.ScrollPosition := TPoint.Create(0, 0);

  lblOverallDailyCost.Caption := FloatToStrF(overallDailyCost,
    ffCurrency, 8, 2);

  lblOverallActiveDailyCost.Caption := FloatToStrF(overallActiveDailyCost,
    ffCurrency, 8, 2);

  lblOverallStandbyDailyCost.Caption := FloatToStrF(overallStandbyDailyCost,
    ffCurrency, 8, 2);
end;

procedure TPhfHome.DisplayCalculator();
begin
  g_CalculatorTabAppliance := nil;

  lstAppliances2.Items := lstAppliances.Items;
  lstAppliances2.ItemIndex := -1;

  sedUsage.Enabled := false;
  lblCalculator3.Enabled := false;
  lblCalculator4.Enabled := false;

  edtTariff.Text := FloatToStrF(g_CurrentUser.GetElectricityTariff(),
    ffGeneral, 6, 2);
end;

procedure TPhfHome.DisplayUserInformation();
begin
  lblUsername.Caption := g_CurrentUser.GetUsername();
  lblEmailAddress.Caption := g_CurrentUser.GetEmailAddress();
  lblName.Caption := g_CurrentUser.GetForenames();
  lblSurname.Caption := g_CurrentUser.GetSurname();
  lblApplianceCount.Caption := IntToStr(g_CurrentUser.GetAppliances().Size());
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
  g_AppliancesTabAppliance := nil;

  if show then
  begin
    currentApplianceName := lstAppliances.Items[lstAppliances.ItemIndex];
    g_AppliancesTabAppliance := g_CurrentUser.GetApplianceByName
      (currentApplianceName);

    if g_AppliancesTabAppliance <> nil then
    begin
      voltage := Format('%fV', [g_AppliancesTabAppliance.GetVoltage()]);
      amperage := Format('%fA', [g_AppliancesTabAppliance.GetAmperage()]);
      activePower := Format('%fW', [g_AppliancesTabAppliance.GetActivePower()]);
      inputPower := Format('%fW', [g_AppliancesTabAppliance.GetInputPower()]);
      outputPower := IfThen(g_AppliancesTabAppliance.GetOutputPower() <> -1.0,
        Format('%fW', [g_AppliancesTabAppliance.GetOutputPower()]), 'N/A');

      standbyPower := Format('%fW',
        [g_AppliancesTabAppliance.GetStandbyPower()]);

      powerFactor := Format('%f', [g_AppliancesTabAppliance.GetPowerFactor()]);
      frequency := Format('%fHz', [g_AppliancesTabAppliance.GetFrequency()]);
      energyRating := Format('%d',
        [g_AppliancesTabAppliance.GetEnergyRating()]);

      surgeProtection := IfThen(g_AppliancesTabAppliance.GetSurgeProtection(),
        'Yes', 'No');

      batterySize := IfThen(g_AppliancesTabAppliance.GetBatterySize() <> -1.0,
        Format('%fmAH', [g_AppliancesTabAppliance.GetBatterySize()]), 'N/A');

      batteryKind := IfThen(g_AppliancesTabAppliance.GetBatteryKind() <> '',
        g_AppliancesTabAppliance.GetBatteryKind(), 'N/A');

      lblApplianceName.Caption := g_AppliancesTabAppliance.GetName();
      lblManufacturer.Caption := g_AppliancesTabAppliance.GetManufacturer();
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

    g_AppliancesTabAppliance := newAppliance;
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

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

unit Powerhouse.Forms.Home.AddAppliance;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.StrUtils, System.Math, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Powerhouse.Types, Powerhouse.Defines, Powerhouse.Vector, Powerhouse.Form,
  Powerhouse.Logger, Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User,
  Powerhouse.Forms.Home.AddAppliance.CreateAppliance;

type
  TPhfAddAppliance = class(PhForm)
    lstAvailableAppliances: TListBox;
    btnAdd: TButton;
    pnlAddAppliance: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    pnlApplianceInformation: TPanel;
    Label3: TLabel;
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
    lblCreateNewAppliance: TLabel;
    btnCancel: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure lstAvailableAppliancesClick(Sender: TObject);
    procedure lstAvailableAppliancesMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstAvailableAppliancesDblClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lblCreateNewApplianceClick(Sender: TObject);

  public
    procedure EnableModal(); override;

    function GetNewAppliance(): PhAppliance;

  private
    procedure ShowApplianceInformationLabels(const show: bool);
    procedure ShowApplianceInformation(const show: bool);

    function CreateNewAppliance(): PhAppliance;

    procedure AddNewAppliance();

  private
    m_NewAppliance: PhAppliance;
    m_AvailableAppliances: PhVector<PhAppliance>;
  end;

implementation

var
  g_SelectedAppliance: PhAppliance;

{$R *.dfm}

procedure TPhfAddAppliance.EnableModal();
var
  userAppliances: PhAppliances;
  numAvailable, i, j: uint64;
  guid: PhGUID;
  guids: PhVector<PhGUID>;
  appliance: PhAppliance;
begin
  Self.Caption := Format('Add Appliance - %s', [g_CurrentUser.GetUsername()]);

  with g_Database do
  begin
    userAppliances := g_CurrentUser.GetAppliances();
    numAvailable := uint64(TblAppliances.RecordCount) - userAppliances.Size();

    m_AvailableAppliances := PhVector<PhAppliance>.Create(numAvailable);
    guids := PhVector<PhGUID>.Create(numAvailable);

    TblAppliances.First();
    while not TblAppliances.Eof do
    begin
      guids.PushBack(TblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_PK]);
      TblAppliances.Next();
    end;

    TblAppliances.First();
  end;

  for guid in guids do
  begin
    appliance := PhAppliance.Create(guid);

    if not userAppliances.Contains(appliance) then
      m_AvailableAppliances.PushBack(appliance);
  end;

  // Sort available appliances in alphabetical order.
  for i := m_AvailableAppliances.First() to m_AvailableAppliances.Last() - 1 do
  begin
    for j := m_AvailableAppliances.First()
      to m_AvailableAppliances.Last() - 1 do
    begin
      if m_AvailableAppliances[j].GetName() > m_AvailableAppliances[j + 1]
        .GetName() then
      begin
        appliance := m_AvailableAppliances[j];
        m_AvailableAppliances[j] := m_AvailableAppliances[j + 1];
        m_AvailableAppliances[j + 1] := appliance;
      end;
    end;
  end;

  for appliance in m_AvailableAppliances do
    lstAvailableAppliances.Items.Add(appliance.GetName());

  ShowApplianceInformation(false);
  inherited EnableModal();
end;

procedure TPhfAddAppliance.btnAddClick(Sender: TObject);
begin
  AddNewAppliance();
end;

procedure TPhfAddAppliance.lstAvailableAppliancesClick(Sender: TObject);
begin
  ShowApplianceInformation(lstAvailableAppliances.ItemIndex <> -1);
end;

procedure TPhfAddAppliance.lstAvailableAppliancesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> TMouseButton.mbLeft then
    Exit();

  if lstAvailableAppliances.ItemAtPos(TPoint.Create(X, Y), true) = -1 then
    lstAvailableAppliances.ItemIndex := -1;
end;

procedure TPhfAddAppliance.lstAvailableAppliancesDblClick(Sender: TObject);
begin
  AddNewAppliance();
end;

procedure TPhfAddAppliance.btnCancelClick(Sender: TObject);
begin
  m_NewAppliance := nil;

  DisableModal();
end;

procedure TPhfAddAppliance.lblCreateNewApplianceClick(Sender: TObject);
begin
  m_NewAppliance := CreateNewAppliance();

  if m_NewAppliance <> nil then
    DisableModal();
end;

function TPhfAddAppliance.GetNewAppliance(): PhAppliance;
begin
  Result := m_NewAppliance;
end;

procedure TPhfAddAppliance.ShowApplianceInformationLabels(const show: bool);
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

procedure TPhfAddAppliance.ShowApplianceInformation(const show: bool);
var
  currentApplianceName: string;
  i: uint64;
  voltage, amperage, activePower, inputPower, outputPower, standbyPower,
    powerFactor, frequency, energyRating, surgeProtection, batterySize,
    batteryKind: string;
begin
  g_SelectedAppliance := nil;

  if show then
  begin
    currentApplianceName := lstAvailableAppliances.Items
      [lstAvailableAppliances.ItemIndex];

    for i := m_AvailableAppliances.First() to m_AvailableAppliances.Last() do
    begin
      if currentApplianceName = m_AvailableAppliances[i].GetName() then
      begin
        g_SelectedAppliance := m_AvailableAppliances[i];
        break;
      end;
    end;

    if g_SelectedAppliance <> nil then
    begin
      voltage := Format('%fV', [g_SelectedAppliance.GetVoltage()]);
      amperage := Format('%fA', [g_SelectedAppliance.GetAmperage()]);
      activePower := Format('%fW', [g_SelectedAppliance.GetActivePower()]);
      inputPower := Format('%fW', [g_SelectedAppliance.GetInputPower()]);
      outputPower := IfThen(g_SelectedAppliance.GetOutputPower() <> -1.0,
        Format('%fW', [g_SelectedAppliance.GetOutputPower()]), 'N/A');

      standbyPower := Format('%fW', [g_SelectedAppliance.GetStandbyPower()]);
      powerFactor := Format('%f', [g_SelectedAppliance.GetPowerFactor()]);
      frequency := Format('%fHz', [g_SelectedAppliance.GetFrequency()]);
      energyRating := Format('%d', [g_SelectedAppliance.GetEnergyRating()]);
      surgeProtection := IfThen(g_SelectedAppliance.GetSurgeProtection(),
        'Yes', 'No');

      batterySize := IfThen(g_SelectedAppliance.GetBatterySize() <> -1.0,
        Format('%fmAH', [g_SelectedAppliance.GetBatterySize()]), 'N/A');

      batteryKind := IfThen(g_SelectedAppliance.GetBatteryKind() <> '',
        g_SelectedAppliance.GetBatteryKind(), 'N/A');

      lblApplianceName.Caption := g_SelectedAppliance.GetName();
      lblManufacturer.Caption := g_SelectedAppliance.GetManufacturer();
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

function TPhfAddAppliance.CreateNewAppliance(): PhAppliance;
var
  createApplianceForm: TPhfCreateAppliance;
begin
  createApplianceForm := TPhfCreateAppliance.Create(Self);
  createApplianceForm.EnableModal();

  if createApplianceForm.GetNewAppliance() = nil then
  begin
    if not createApplianceForm.Cancelled() then
      PhLogger.Error('There was an error creating your appliance!');

    createApplianceForm.Free();
    Exit(nil);
  end;

  Result := createApplianceForm.GetNewAppliance();
  PhLogger.Info('Your appliance was created successfully.');

  createApplianceForm.Free();
end;

procedure TPhfAddAppliance.AddNewAppliance();
begin
  m_NewAppliance := m_AvailableAppliances[lstAvailableAppliances.ItemIndex];

  DisableModal();
end;

end.

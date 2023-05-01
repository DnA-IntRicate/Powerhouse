unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, DataModuleUnit;

type
  TMainForm = class(TForm)
    ApplianceGroupBox: TGroupBox;
    ApplianceTypeLabel: TLabel;
    WattageLabel: TLabel;
    HoursPerDayLabel: TLabel;
    ApplianceTypeComboBox: TComboBox;
    WattageEdit: TEdit;
    HoursPerDayEdit: TEdit;
    EnergyUsageGroupBox: TGroupBox;
    TotalEnergyUsageLabel: TLabel;
    TotalEnergyUsageValueLabel: TLabel;
    TipsGroupBox: TGroupBox;
    TipsListBox: TListBox;
    CalculateButton: TButton;
    SaveButton: TButton;
    CancelButton: TButton;
    procedure CalculateButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDataModule: TDataModule;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CalculateButtonClick(Sender: TObject);
var
  ApplianceType: string;
  Wattage: Integer;
  HoursPerDay: Integer;
  EnergyUsage: Integer;
begin
  ApplianceType := ApplianceTypeComboBox.Text;
  Wattage := StrToIntDef(WattageEdit.Text, 0);
  HoursPerDay := StrToIntDef(HoursPerDayEdit.Text, 0);
  EnergyUsage := Wattage * HoursPerDay;
  TotalEnergyUsageValueLabel.Caption := IntToStr(EnergyUsage) + ' Wh';
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
begin
  FDataModule.AddAppliance(ApplianceTypeComboBox.Text, StrToInt(WattageEdit.Text), StrToInt(HoursPerDayEdit.Text));
  ShowMessage('Appliance saved successfully.');
end;

procedure TMainForm.CancelButtonClick(Sender: TObject);
begin
  ApplianceTypeComboBox.ItemIndex := -1;
  WattageEdit.Clear;
  HoursPerDayEdit.Clear;
  TotalEnergyUsageValueLabel.Caption := '0 Wh';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FDataModule := TDataModule.Create(Self);
end;

end.
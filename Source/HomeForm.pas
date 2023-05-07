unit HomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    tbcHome: TTabControl;
    lstAppliances: TListBox;
    pnlApplianceInformation: TPanel;
    Label1: TLabel;
    btnModifyAppliance: TButton;
    pnlHomeForm: TPanel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

end.

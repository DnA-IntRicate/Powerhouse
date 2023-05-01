unit MainForm_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnGUID: TButton;
    edtGUID: TEdit;
    procedure btnGUIDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnGUIDClick(Sender: TObject);
var
  newGUID: TGUID;
  sHexGUID: string;
begin
  CreateGUID(newGUID);
  sHexGUID := GUIDToString(newGUID);

  sHexGUID := StringReplace(sHexGUID, '{', '', [rfReplaceAll]);
  sHexGUID := StringReplace(sHexGUID, '}', '', [rfReplaceAll]);
  sHexGUID := StringReplace(sHexGUID, '-', '', [rfReplaceAll]);

  edtGUID.Text := sHexGUID;
end;

end.

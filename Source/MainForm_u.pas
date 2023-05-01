unit MainForm_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Hash;

type
  TForm1 = class(TForm)
    btnGUID: TButton;
    edtGUID: TEdit;
    edtPassword: TEdit;
    edtHash: TEdit;
    btnHash: TButton;
    procedure btnGUIDClick(Sender: TObject);
    procedure btnHashClick(Sender: TObject);
    function StringToSaltedMD5Hash(const text: string): string;
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

  edtGUID.text := sHexGUID;
end;

procedure TForm1.btnHashClick(Sender: TObject);
begin
  edtHash.text := StringToSaltedMD5Hash(edtPassword.text);
end;

function TForm1.StringToSaltedMD5Hash(const text: string): string;
var
  MD5: THashMD5;
  sHash: string;
begin
  MD5 := THashMD5.Create();
  // Hashing password and then salting it
  sHash := MD5.GetHashString(text);

  // Dynamic salt
  sHash := sHash.Insert(Length(text),
    MD5.GetHashString(IntToStr(Length(text))));
  sHash := MD5.GetHashString(sHash) + '==';

  Result := sHash;
end;

end.

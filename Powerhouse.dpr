program Powerhouse;

uses
  Vcl.Forms,
  MainForm_u in 'Source/MainForm_u.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

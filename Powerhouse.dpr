program Powerhouse;

uses
  Vcl.Forms,
  MainForm_u in 'Source\MainForm_u.pas' {Form1},
  LoginForm in 'Source\LoginForm.pas' {Form2},
  HomeForm in 'Source\HomeForm.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

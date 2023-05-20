program Powerhouse;

uses
  Vcl.Forms,
  Powerhouse.Forms.Main in 'Source\Powerhouse\Forms\Powerhouse.Forms.Main.pas' {MainForm},
  Powerhouse.Forms.Login in 'Source\Powerhouse\Forms\Powerhouse.Forms.Login.pas' {LoginForm},
  Powerhouse.Forms.Home in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.pas' {HomeForm},
  Powerhouse.Database in 'Source\Powerhouse\Powerhouse.Database.pas',
  Powerhouse.Appliance in 'Source\Powerhouse\Powerhouse.Appliance.pas',
  Powerhouse.User in 'Source\Powerhouse\Powerhouse.User.pas',
  Powerhouse.JsonSerializer in 'Source\Powerhouse\Powerhouse.JsonSerializer.pas';

{$R *.res}

begin
  Application.Initialize();
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(THomeForm, HomeForm);
  Application.Run();
end.

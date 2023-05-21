program Powerhouse;

uses
  Vcl.Forms,
  Powerhouse.Forms.Main in 'Source\Powerhouse\Forms\Powerhouse.Forms.Main.pas' {g_MainForm},
  Powerhouse.Forms.Login in 'Source\Powerhouse\Forms\Powerhouse.Forms.Login.pas' {g_LoginForm},
  Powerhouse.Forms.Home in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.pas' {g_HomeForm},
  Powerhouse.Database in 'Source\Powerhouse\Powerhouse.Database.pas',
  Powerhouse.Appliance in 'Source\Powerhouse\Powerhouse.Appliance.pas',
  Powerhouse.User in 'Source\Powerhouse\Powerhouse.User.pas',
  Powerhouse.JsonSerializer in 'Source\Powerhouse\Powerhouse.JsonSerializer.pas',
  Powerhouse.FormManager in 'Source\Powerhouse\Powerhouse.FormManager.pas';

{$R *.res}

begin
  Application.Initialize();
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPhfMain, g_MainForm);
  Application.CreateForm(TPhfLogin, g_LoginForm);
  Application.CreateForm(TPhfHome, g_HomeForm);
  Application.Run();
end.

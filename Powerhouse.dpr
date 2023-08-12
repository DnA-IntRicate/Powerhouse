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

program Powerhouse;

uses
  Vcl.Forms,
  Powerhouse.Forms.Main
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Main.pas' {g_MainForm} ,
  Powerhouse.Forms.Login
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Login.pas' {g_LoginForm} ,
  Powerhouse.Forms.Home
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.pas' {g_HomeForm} ,
  Powerhouse.Forms.Login.Registration
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Login.Registration.pas' {g_RegistrationForm} ,
  Powerhouse.Forms.Home.AddAppliance
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.AddAppliance.pas' {g_AddApplianceForm} ,
  Powerhouse.Forms.Home.ModifyAppliance
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.ModifyAppliance.pas' {g_ModifyApplianceForm} ,
  Powerhouse.Forms.Home.AddAppliance.CreateAppliance
    in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.AddAppliance.CreateAppliance.pas' {g_CreateApplianceForm} ,
  Powerhouse.Database in 'Source\Powerhouse\Powerhouse.Database.pas',
  Powerhouse.Appliance in 'Source\Powerhouse\Powerhouse.Appliance.pas',
  Powerhouse.User in 'Source\Powerhouse\Powerhouse.User.pas',
  Powerhouse.JsonSerializer
    in 'Source\Powerhouse\Powerhouse.JsonSerializer.pas',
  Powerhouse.Logger in 'Source\Powerhouse\Powerhouse.Logger.pas',
  Powerhouse.Form in 'Source\Powerhouse\Powerhouse.Form.pas',
  Powerhouse.FileStream in 'Source\Powerhouse\Powerhouse.FileStream.pas',
  Powerhouse.SaveData in 'Source\Powerhouse\Powerhouse.SaveData.pas',
  Powerhouse.Validator in 'Source\Powerhouse\Powerhouse.Validator.pas',
  Powerhouse.Types in 'Source\Powerhouse\Powerhouse.Types.pas',
  Powerhouse.Vector in 'Source\Powerhouse\Powerhouse.Vector.pas';

{$R *.res}

begin
  Application.Initialize();
  Application.MainFormOnTaskbar := true;

  // Note: Only the main form is being created here because the main form acts
  // as the parent form for all other forms associated with the application.
  // Normally all other forms would be created here, but instead they are dynamically
  // created by the main form so that it can directly handle them by itself.

  Application.CreateForm(TPhfMain, g_MainForm);
  Application.Run();

end.

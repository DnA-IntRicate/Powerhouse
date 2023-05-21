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
  Powerhouse.Forms.Main in 'Source\Powerhouse\Forms\Powerhouse.Forms.Main.pas' {g_MainForm},
  Powerhouse.Forms.Login in 'Source\Powerhouse\Forms\Powerhouse.Forms.Login.pas' {g_LoginForm},
  Powerhouse.Forms.Home in 'Source\Powerhouse\Forms\Powerhouse.Forms.Home.pas' {g_HomeForm},
  Powerhouse.Database in 'Source\Powerhouse\Powerhouse.Database.pas',
  Powerhouse.Appliance in 'Source\Powerhouse\Powerhouse.Appliance.pas',
  Powerhouse.User in 'Source\Powerhouse\Powerhouse.User.pas',
  Powerhouse.JsonSerializer in 'Source\Powerhouse\Powerhouse.JsonSerializer.pas',
  Powerhouse.FormManager in 'Source\Powerhouse\Powerhouse.FormManager.pas',
  Powerhouse.Logger in 'Source\Powerhouse\Powerhouse.Logger.pas';

{$R *.res}

begin
  Application.Initialize();
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPhfLogin, g_LoginForm);
  Application.CreateForm(TPhfMain, g_MainForm);
  Application.CreateForm(TPhfHome, g_HomeForm);
  Application.Run();

end.

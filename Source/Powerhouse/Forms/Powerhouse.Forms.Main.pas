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

unit Powerhouse.Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Powerhouse.Form, Powerhouse.Forms.Home,
  Powerhouse.Forms.Login, Powerhouse.Forms.Registration, Powerhouse.Database;

type
  TPhfMain = class(PhForm)
    procedure FormCreate(Sender: TObject);

  public
    procedure Enable(); override;
    procedure Disable(); override;

  private
    procedure SetFormStyle(const formPtr: PhFormPtr);
  end;

var
  g_MainForm: TPhfMain;

implementation

{$R *.dfm}

procedure TPhfMain.FormCreate(Sender: TObject);
begin
  g_Database := PhDatabase.Create('Assets/PowerhouseDb.mdb');

  Application.CreateForm(TPhfLogin, g_LoginForm);
  Application.CreateForm(TPhfHome, g_HomeForm);

  SetFormStyle(@g_LoginForm);
  SetFormStyle(@g_HomeForm);

  g_HomeForm.Disable();

  TransitionForms(@g_LoginForm);
end;

procedure TPhfMain.Enable();
begin
  inherited;

  Self.Show();
end;

procedure TPhfMain.Disable();
begin
  inherited;

  Self.Hide();
end;

procedure TPhfMain.SetFormStyle(const formPtr: PhFormPtr);
var
  oldStyle, newStyle: integer;
begin
  formPtr.BorderStyle := bsSingle;
  formPtr.FormStyle := fsNormal;

  oldStyle := GetWindowLong(formPtr.Handle, GWL_EXSTYLE);
  newStyle := oldStyle or WS_EX_APPWINDOW;

  SetWindowLong(formPtr.Handle, GWL_EXSTYLE, newStyle);
end;

end.

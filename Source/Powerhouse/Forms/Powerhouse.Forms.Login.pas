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

unit Powerhouse.Forms.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Powerhouse.Types, Powerhouse.Vector,
  Powerhouse.Form, Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User,
  Powerhouse.JsonSerializer, Powerhouse.Logger, Powerhouse.Forms.Home,
  Powerhouse.Forms.Registration, Powerhouse.FileStream, Powerhouse.SaveData;

type
  TPhfLogin = class(PhForm)
    edtUsername: TEdit;
    pnlLogin: TPanel;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnLogin: TButton;
    lblRegister: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblRegisterClick(Sender: TObject);

  private
    // TODO: If the logged in user has no save data, add them to the save.
    procedure LoadUserAppliances(var refUser: PhUser; const savePath: string);
    procedure LoginUser(var refUser: PhUser);
    procedure CreateSaveFile(const user: PhUser; const savePath: string);
  end;

var
  g_LoginForm: TPhfLogin;

implementation

{$R *.dfm}

procedure TPhfLogin.btnLoginClick(Sender: TObject);
var
  userName, pswd: string;
  userFound: bool;
  newUser: PhUser;
begin
  userName := edtUsername.Text;
  pswd := edtPassword.Text;
  userFound := false;

  with g_Database do
  begin
    TblUsers.First();

    while not TblUsers.Eof do
    begin
      userFound := (userName = TblUsers[PH_TBL_FIELD_NAME_USERS_USERNAME]) or
        (userName = TblUsers[PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS]);
      if userFound then
        break;

      TblUsers.Next();
    end;

    if userFound then
    begin
      newUser := PhUser.Create(TblUsers[PH_TBL_FIELD_NAME_USERS_PK]);

      if newUser.CheckPassword(pswd) then
      begin
        if PhFileStream.IsFile(PH_SAVEFILE_NAME) then
          LoadUserAppliances(newUser, PH_SAVEFILE_NAME)
        else
          CreateSaveFile(newUser, PH_SAVEFILE_NAME);

        LoginUser(newUser);
      end
      else
      begin
        PhLogger.Error('Incorrect password!');
        edtPassword.SetFocus();
      end;
    end
    else
    begin
      PhLogger.Error('Username or email address not found!');
      edtUsername.SetFocus();
    end;

    TblUsers.First();
  end;
end;

procedure TPhfLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Quit();
end;

procedure TPhfLogin.lblRegisterClick(Sender: TObject);
var
  regForm: TPhfRegistration;
  newUser: PhUser;
begin
  regForm := TPhfRegistration.Create(Self);
  regForm.EnableModal();

  newUser := regForm.GetNewUser();

  if newUser <> nil then
  begin
    edtUsername.Text := newUser.GetUsername();
    edtPassword.Text := '••••••••';

    Sleep(750);

    LoginUser(newUser);
  end;

  regForm.Free();
end;

procedure TPhfLogin.LoadUserAppliances(var refUser: PhUser;
  const savePath: string);
var
  jsonSrc: string;
  json: PhJsonSerializer;
  saveData: PhSaveData;
  users: PhUsers;
  user: PhUser;
  appliances: PhAppliances;
begin
  jsonSrc := PhFileStream.ReadAllText(savePath);
  json := PhJsonSerializer.Create();
  saveData := PhSaveData(json.DeserializeJson(jsonSrc));
  users := saveData.ToPhUsers();

  for user in users do
  begin
    if user.GetGUID() = refUser.GetGUID() then
    begin
      appliances := user.GetAppliances();
      refUser.SetAppliances(appliances);

      break;
    end;
  end;
end;

procedure TPhfLogin.LoginUser(var refUser: PhUser);
begin
  g_CurrentUser := refUser;

  PhLogger.Info('Welcome %s %s!', [g_CurrentUser.GetForenames(),
    g_CurrentUser.GetSurname()]);

  TransitionForms(@g_HomeForm);
end;

procedure TPhfLogin.CreateSaveFile(const user: PhUser; const savePath: string);
var
  users: PhUsers;
  saveData: PhSaveData;
  json: PhJsonSerializer;
  jsonSrc: string;
begin
  users := PhUsers.Create(1);
  users[0] := user;

  saveData := PhSaveData.Create(users);

  json := PhJsonSerializer.Create();
  jsonSrc := json.SerializeJson(saveData);

  PhFileStream.WriteAllText(savePath, jsonSrc, PhWriteMode.Overwrite);
end;

end.

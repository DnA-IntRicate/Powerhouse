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

unit Powerhouse.Forms.Home.ModifyUser;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.StrUtils, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Form, Powerhouse.Validator,
  Powerhouse.Logger, Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User,
  System.Classes;

type
  TPhfModifyUser = class(PhForm)
    pnlRegistration: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtUsername: TEdit;
    edtEmailAddress: TEdit;
    edtName: TEdit;
    edtSurname: TEdit;
    btnCancel: TButton;
    btnSave: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtUsernameExit(Sender: TObject);
    procedure edtEmailAddressExit(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure edtSurnameExit(Sender: TObject);

  public
    procedure EnableModal(); override;
    procedure SetContext(const userPtr: PhUserPtr);

  private
    function UsernameExists(const username: string): bool;
    function EmailAddressExists(const email: string): bool;

    function ValidateUsername(const username: string): bool;
    function ValidateEmailAddress(const email: string): bool;
    function ValidateName(const name: string): bool;

    procedure TryEnableBtnSave();

  private
    m_UserPtr: PhUserPtr;

    m_ValidUsername: bool;
    m_ValidEmailAddress: bool;
    m_ValidForename: bool;
    m_ValidSurname: bool;
  end;

const
  PH_MIN_LENGTH_USERNAME = 6;
  // PH_MIN_LENGTH_PASSWORD = 8;

  PH_MAX_LENGTH_USERNAME = 18;
  // PH_MAX_LENGTH_PASSWORD = 26;

implementation

{$R *.dfm}

procedure TPhfModifyUser.btnSaveClick(Sender: TObject);
begin
  m_UserPtr.SetUsername(edtUsername.Text);
  m_UserPtr.SetEmailAddress(edtEmailAddress.Text);
  m_UserPtr.SetForenames(edtName.Text);
  m_UserPtr.SetSurname(edtSurname.Text);

  m_UserPtr.Sync();
  PhLogger.Info('Your account has been successfully updated.');

  DisableModal();
end;

procedure TPhfModifyUser.btnCancelClick(Sender: TObject);
begin
  DisableModal();
end;

procedure TPhfModifyUser.edtUsernameExit(Sender: TObject);
begin
  m_ValidUsername := ValidateUsername(edtUsername.Text);

  TryEnableBtnSave();
end;

procedure TPhfModifyUser.edtEmailAddressExit(Sender: TObject);
begin
  m_ValidEmailAddress := ValidateEmailAddress(edtEmailAddress.Text);

  TryEnableBtnSave();
end;

procedure TPhfModifyUser.edtNameExit(Sender: TObject);
begin
  m_ValidForename := ValidateName(edtName.Text);

  TryEnableBtnSave();
end;

procedure TPhfModifyUser.edtSurnameExit(Sender: TObject);
begin
  m_ValidSurname := ValidateName(edtSurname.Text);

  TryEnableBtnSave();
end;

procedure TPhfModifyUser.EnableModal();
begin
  Self.Caption := Format('User Account Modification - %s',
    [m_UserPtr.GetUsername()]);

  m_ValidUsername := true;
  edtUsername.Text := m_UserPtr.GetUsername();

  m_ValidEmailAddress := true;
  edtEmailAddress.Text := m_UserPtr.GetEmailAddress();

  m_ValidForename := true;
  edtName.Text := m_UserPtr.GetForenames();

  m_ValidSurname := true;
  edtSurname.Text := m_UserPtr.GetSurname();

  inherited EnableModal();
end;

procedure TPhfModifyUser.SetContext(const userPtr: PhUserPtr);
begin
  m_UserPtr := userPtr;
end;

function TPhfModifyUser.UsernameExists(const username: string): bool;
begin
  if username = m_UserPtr.GetUsername() then
    Exit(false);

  with g_Database do
  begin
    Result := TblUsers.Locate(PH_TBL_FIELD_NAME_USERS_USERNAME, username, []);
    TblUsers.First();
  end;
end;

function TPhfModifyUser.EmailAddressExists(const email: string): bool;
begin
  if email = m_UserPtr.GetEmailAddress() then
    Exit(false);

  with g_Database do
  begin
    Result := TblUsers.Locate(PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS, email, []);
    TblUsers.First();
  end;
end;

function TPhfModifyUser.ValidateUsername(const username: string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  validation := PhValidator.ValidateString(username, [All],
    PH_MIN_LENGTH_USERNAME, PH_MAX_LENGTH_USERNAME);

  if validation.Valid then
  begin
    Result := true;

    if UsernameExists(username) then
    begin
      PhLogger.Warn('Username ''%s'' already exists! ' + #13#10 +
        'Please choose a different username.', [username]);

      Result := false;
    end;
  end
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Username cannot be left empty!');
      Exit();
    end;

    if PhValidationFlag.TooShort in validation.Flags then
    begin
      PhLogger.Warn('Username must be longer than %d characters.',
        [PH_MIN_LENGTH_USERNAME]);
    end
    else if PhValidationFlag.TooLong in validation.Flags then
    begin
      PhLogger.Warn('Username must be shorter than %d characters.',
        [PH_MAX_LENGTH_USERNAME]);
    end;

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Username contains one or more forbidden characters!');
  end;
end;

function TPhfModifyUser.ValidateEmailAddress(const email: string): bool;
var
  validation: PhValidation;
  myEmail: string;
begin
  Result := false;
  myEmail := LowerCase(email);

  validation := PhValidator.ValidateEmailAddress(myEmail);

  if validation.Valid then
  begin
    Result := true;

    if EmailAddressExists(myEmail) then
    begin
      PhLogger.Warn('An account already exists for ''%s''.' + #13#10 + #13#10 +
        'If you would like to login with this account, please return to the ' +
        'login page.', [myEmail]);

      Result := false;
    end;
  end
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Email address cannot be left empty!');
      Exit();
    end;

    if PhValidationFlag.InvalidFormat in validation.Flags then
      PhLogger.Warn('Invalid email address entered!');
  end;
end;

function TPhfModifyUser.ValidateName(const name: string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  validation := PhValidator.ValidateString(name, [Letters]);

  if validation.Valid then
  begin
    Result := true;
  end
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Name cannot be left empty!');
      Exit();
    end;

    if (PhValidationFlag.InvalidFormat in validation.Flags) or
      (PhValidationFlag.ForbiddenCharacter in validation.Flags) then
      PhLogger.Warn('A name cannot contain any numbers or symbols!');
  end;
end;

procedure TPhfModifyUser.TryEnableBtnSave();
begin
  btnSave.Enabled := m_ValidUsername and m_ValidEmailAddress and
    m_ValidForename and m_ValidSurname;
end;

end.

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

unit Powerhouse.Forms.Login.Registration;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.StrUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Powerhouse.Types, Powerhouse.Form, Powerhouse.Validator, Powerhouse.Logger,
  Powerhouse.Database, Powerhouse.Appliance, Powerhouse.User;

type
  TPhfRegistration = class(PhForm)
    pnlRegistration: TPanel;
    Label1: TLabel;
    edtUsername: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtConfirmPassword: TEdit;
    Label5: TLabel;
    edtEmailAddress: TEdit;
    edtName: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtSurname: TEdit;
    btnRegister: TButton;
    procedure btnRegisterClick(Sender: TObject);
    procedure edtUsernameExit(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
    procedure edtConfirmPasswordExit(Sender: TObject);
    procedure edtEmailAddressExit(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure edtSurnameExit(Sender: TObject);

  public
    procedure EnableModal(); override;

    function GetNewUser(): PhUser;

  private
    function UsernameExists(const username: string): bool;
    function EmailAddressExists(const email: string): bool;

    function ValidateUsername(const username: string): bool;
    function ValidatePassword(const password: string): bool;
    function ValidateEmailAddress(const email: string): bool;
    function ValidateName(const name: string): bool;

    procedure TryEnableBtnRegister();

    procedure CreateAccount(const username, password, email, name,
      surname: string);

  private
    m_NewUser: PhUser;

    m_ValidUsername: bool;
    m_ValidPassword: bool;
    m_PasswordConfirmed: bool;
    m_ValidEmailAddress: bool;
    m_ValidName: bool;
    m_ValidSurname: bool;
  end;

const
  PH_MIN_LENGTH_USERNAME = 6;
  PH_MIN_LENGTH_PASSWORD = 8;

  PH_MAX_LENGTH_USERNAME = 18;
  PH_MAX_LENGTH_PASSWORD = 26;

implementation

{$R *.dfm}

procedure TPhfRegistration.btnRegisterClick(Sender: TObject);
var
  username, password, email, name, surname: string;
begin
  username := edtUsername.Text;
  password := edtPassword.Text;
  email := edtEmailAddress.Text;
  name := edtName.Text;
  surname := edtSurname.Text;

  CreateAccount(username, password, email, name, surname);
  DisableModal();
end;

procedure TPhfRegistration.edtUsernameExit(Sender: TObject);
begin
  m_ValidUsername := ValidateUsername(edtUsername.Text);

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.edtPasswordExit(Sender: TObject);
begin
  m_ValidPassword := ValidatePassword(edtPassword.Text);

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.edtConfirmPasswordExit(Sender: TObject);
begin
  m_PasswordConfirmed := edtPassword.Text = edtConfirmPassword.Text;
  if not m_PasswordConfirmed then
    PhLogger.Warn('Passwords do not match!');

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.edtEmailAddressExit(Sender: TObject);
begin
  m_ValidEmailAddress := ValidateEmailAddress(edtEmailAddress.Text);

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.edtNameExit(Sender: TObject);
begin
  m_ValidName := ValidateName(edtName.Text);

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.edtSurnameExit(Sender: TObject);
begin
  m_ValidSurname := ValidateName(edtSurname.Text);

  TryEnableBtnRegister();
end;

procedure TPhfRegistration.EnableModal();
begin
  btnRegister.Enabled := false;

  m_NewUser := nil;

  m_ValidUsername := false;
  m_ValidPassword := false;
  m_PasswordConfirmed := false;
  m_ValidEmailAddress := false;
  m_ValidName := false;
  m_ValidSurname := false;

  inherited EnableModal();
end;

function TPhfRegistration.GetNewUser(): PhUser;
begin
  Result := m_NewUser;
end;

function TPhfRegistration.UsernameExists(const username: string): bool;
var
  exists: bool;
begin
  exists := false;

  with g_Database do
  begin
    TblUsers.First();

    while not TblUsers.Eof do
    begin
      exists := username = TblUsers[PH_TBL_FIELD_NAME_USERS_USERNAME];
      if exists then
        break;

      TblUsers.Next();
    end;

    TblUsers.First();
  end;

  Result := exists;
end;

function TPhfRegistration.EmailAddressExists(const email: string): bool;
var
  exists: bool;
begin
  exists := false;

  with g_Database do
  begin
    TblUsers.First();

    while not TblUsers.Eof do
    begin
      exists := email = TblUsers[PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS];
      if exists then
        break;

      TblUsers.Next();
    end;

    TblUsers.First();
  end;

  Result := exists;
end;

function TPhfRegistration.ValidateUsername(const username: string): bool;
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

function TPhfRegistration.ValidatePassword(const password: string): bool;
var
  validation: PhValidation;
begin
  Result := false;

  validation := PhValidator.ValidateString(password, [All],
    PH_MIN_LENGTH_PASSWORD, PH_MAX_LENGTH_PASSWORD);

  if validation.Valid then
  begin
    Result := true;
  end
  else
  begin
    if PhValidationFlag.Empty in validation.Flags then
    begin
      PhLogger.Warn('Password cannot be left empty!');
      Exit();
    end;

    if PhValidationFlag.TooShort in validation.Flags then
    begin
      PhLogger.Warn('Password must be longer than %d characters.',
        [PH_MIN_LENGTH_PASSWORD]);
    end
    else if PhValidationFlag.TooLong in validation.Flags then
    begin
      PhLogger.Warn('Password must be shorter than %d characters.',
        [PH_MAX_LENGTH_PASSWORD]);
    end;

    if PhValidationFlag.ForbiddenCharacter in validation.Flags then
      PhLogger.Warn('Password contains one or more forbidden characters!');
  end;
end;

function TPhfRegistration.ValidateEmailAddress(const email: string): bool;
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

function TPhfRegistration.ValidateName(const name: string): bool;
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

procedure TPhfRegistration.TryEnableBtnRegister();
begin
  btnRegister.Enabled := m_ValidUsername and m_ValidPassword and
    m_PasswordConfirmed and m_ValidEmailAddress and m_ValidName and
    m_ValidSurname;
end;

procedure TPhfRegistration.CreateAccount(const username, password, email, name,
  surname: string);
begin
  m_NewUser := PhUser.CreateUserAccount(username, password, email,
    name, surname);

  PhLogger.Info('Your account has been created.');
end;

end.

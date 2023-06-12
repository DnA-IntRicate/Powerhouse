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

unit Powerhouse.User;

interface

uses
  System.SysUtils, System.StrUtils, System.Math, System.Hash, Powerhouse.Types,
  Powerhouse.Appliance, Powerhouse.Database, Powerhouse.Logger;

type
  PhUser = class
  public
    constructor Create(const guid: PhGUID);

    class function CreateUserAccount(const usr, pswd, email, names,
      surname: string): PhUser;

    function CheckPassword(pswd: string): boolean;

    function GetGUID(): PhGUID;

    function GetUsername(): string;
    procedure SetUsername(newUsrName: string);

    function GetEmailAddress(): string;
    procedure SetEmailAddress(newAddress: string);

    function GetForenames(): string;
    procedure SetForenames(newNames: string);

    function GetSurname(): string;
    procedure SetSurname(newSurname: string);

    function GetPasswordHash(): string;
    procedure SetPassword(newPswd: string);

    procedure GetAppliances(out result: PhAppliances);
    procedure SetAppliances(appliances: PhAppliances);

    procedure GetApplianceByName(name: string; out result: PhAppliance);
    procedure GetApplianceByGUID(const guid: PhGUID; out result: PhAppliance);

  private
    class function HashPassword(pswd: string): string;

    procedure UpdateInDatabase();

  private
    m_GUID: PhGUID;
    m_Username: string;
    m_EmailAddress: string;
    m_Forenames: string;
    m_Surname: string;
    m_PasswordHash: string;

    m_Appliances: PhAppliances;
  end;

type
  PhUsers = TArray<PhUser>;

const
  PH_TBL_FIELD_NAME_USERS_PK: string = 'UserGUID';
  PH_TBL_FIELD_NAME_USERS_USERNAME: string = 'Username';
  PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS: string = 'EmailAddress';
  PH_TBL_FIELD_NAME_USERS_FORENAMES: string = 'Forenames';
  PH_TBL_FIELD_NAME_USERS_SURNAME: string = 'Surname';
  PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH: string = 'PasswordHash';

var
  g_CurrentUser: PhUser;

implementation

constructor PhUser.Create(const guid: PhGUID);
var
  foundGUID: boolean;
begin
  m_GUID := guid;
  foundGUID := false;

  with g_Database do
  begin
    TblUsers.First();

    while not TblUsers.Eof do
    begin
      foundGUID := m_GUID.Equals(TblUsers[PH_TBL_FIELD_NAME_USERS_PK]);
      if foundGUID then
        break;

      TblUsers.Next();
    end;

    if foundGUID then
    begin
      m_Username := TblUsers[PH_TBL_FIELD_NAME_USERS_USERNAME];
      m_EmailAddress := TblUsers[PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS];
      m_Forenames := TblUsers[PH_TBL_FIELD_NAME_USERS_FORENAMES];
      m_Surname := TblUsers[PH_TBL_FIELD_NAME_USERS_SURNAME];
      m_PasswordHash := TblUsers[PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH];
    end
    else
    begin
      m_Username := '';
      m_EmailAddress := '';
      m_Forenames := '';
      m_Surname := '';
      m_PasswordHash := '';
    end;

    TblUsers.First();
  end;
end;

class function PhUser.CreateUserAccount(const usr, pswd, email, names,
  surname: string): PhUser;
var
  query, passwordHash, myEmail: string;
  guid: PhGUID;
  e: Exception;
begin
  guid := PhGUID.Create();
  passwordHash := HashPassword(pswd);
  myEmail := LowerCase(email);

  query := Format('INSERT INTO %s (%s, %s, %s, %s, %s, %s)' +
    'VALUES (''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'');',
    [PH_TBL_NAME_USERS, PH_TBL_FIELD_NAME_USERS_PK,
    PH_TBL_FIELD_NAME_USERS_USERNAME, PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS,
    PH_TBL_FIELD_NAME_USERS_FORENAMES, PH_TBL_FIELD_NAME_USERS_SURNAME,
    PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH, guid.ToString(), usr, myEmail, names,
    surname, passwordHash]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error creating new user in database: %s', [e.Message]);

  Result := Create(guid);
end;

function PhUser.CheckPassword(pswd: string): boolean;
begin
  Result := HashPassword(pswd) = m_PasswordHash;
end;

function PhUser.GetGUID(): PhGUID;
begin
  Result := m_GUID;
end;

function PhUser.GetUsername(): string;
begin
  Result := m_Username;
end;

procedure PhUser.SetUsername(newUsrName: string);
begin
  m_Username := newUsrName;

  UpdateInDatabase();
end;

function PhUser.GetEmailAddress(): string;
begin
  Result := m_EmailAddress;
end;

procedure PhUser.SetEmailAddress(newAddress: string);
begin
  m_EmailAddress := newAddress;

  UpdateInDatabase();
end;

function PhUser.GetForenames(): string;
begin
  Result := m_Forenames;
end;

procedure PhUser.SetForenames(newNames: string);
begin
  m_Forenames := newNames;

  UpdateInDatabase();
end;

function PhUser.GetSurname(): string;
begin
  Result := m_Surname;
end;

procedure PhUser.SetSurname(newSurname: string);
begin
  m_Surname := newSurname;

  UpdateInDatabase();
end;

function PhUser.GetPasswordHash(): string;
begin
  Result := m_PasswordHash;
end;

procedure PhUser.SetPassword(newPswd: string);
begin
  m_PasswordHash := HashPassword(newPswd);

  UpdateInDatabase();
end;

procedure PhUser.GetAppliances(out Result: PhAppliances);
begin
  Result := m_Appliances;
end;

procedure PhUser.SetAppliances(appliances: PhAppliances);
begin
  m_Appliances := appliances;
end;

procedure PhUser.GetApplianceByName(name: string; out result: PhAppliance);
var
  i: integer;
begin
  for i := Low(m_Appliances) to High(m_Appliances) do
  begin
    if m_Appliances[i].GetName() = name then
    begin
      result := m_Appliances[i];
      break;
    end;
  end;
end;

procedure PhUser.GetApplianceByGUID(const guid: PhGUID; out result: PhAppliance);
var
  i: integer;
begin
  for i := Low(m_Appliances) to High(m_Appliances) do
  begin
    if m_Appliances[i].GetGUID().Equals(guid) then
    begin
      result := m_Appliances[i];
      break;
    end;
  end;
end;

class function PhUser.HashPassword(pswd: string): string;
var
  MD5: THashMD5;
  sHash, sDynamicSalt: string;
begin
  MD5 := THashMD5.Create();

  sHash := MD5.GetHashString(pswd);
  sDynamicSalt := MD5.GetHashString(IntToStr(Length(pswd)));
  sHash := sHash.Insert(Length(pswd), sDynamicSalt);
  sHash := MD5.GetHashString(sHash) + '==';

  Result := sHash;
end;

procedure PhUser.UpdateInDatabase();
var
  query: string;
  e: Exception;
begin
  query := Format('UPDATE %s' + #13#10 +
    'SET %s = ''%s'', %s = ''%s'', %s = ''%s'', %s = ''%s'', %s = ''%s''' +
    #13#10 + 'WHERE %s = %s', [PH_TBL_NAME_USERS,
    PH_TBL_FIELD_NAME_USERS_USERNAME, m_Username,
    PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS, m_EmailAddress,
    PH_TBL_FIELD_NAME_USERS_FORENAMES, m_Forenames,
    PH_TBL_FIELD_NAME_USERS_SURNAME, m_Surname,
    PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH, m_PasswordHash,
    PH_TBL_FIELD_NAME_USERS_PK, m_GUID.ToString()]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error updating database: %s', [e.Message]);
end;

end.

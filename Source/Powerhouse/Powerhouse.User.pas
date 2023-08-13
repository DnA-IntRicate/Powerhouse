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
  System.SysUtils, System.StrUtils, System.Math, System.Hash,
  Powerhouse.Types, Powerhouse.Vector, Powerhouse.Base, Powerhouse.Logger,
  Powerhouse.Database, Powerhouse.Appliance;

type
  PhUser = class(PhDatabaseObjectBase, IEquatable<PhUser>)
  public
    constructor Create(const guid: PhGUID); override;

    class function CreateUserAccount(const usr, pswd, email, names,
      surname: string): PhUser;

    procedure Push(); override;
    procedure Pull(); override;

    function CheckPassword(const pswd: string): bool;

    procedure AddAppliance(const appliance: PhAppliance);
    procedure RemoveAppliance(const appliance: PhAppliance);

    function Equals(other: PhUser): bool; reintroduce;

    function GetUsername(): string;
    procedure SetUsername(const newUsrName: string);

    function GetEmailAddress(): string;
    procedure SetEmailAddress(const newAddress: string);

    function GetForenames(): string;
    procedure SetForenames(const newNames: string);

    function GetSurname(): string;
    procedure SetSurname(const newSurname: string);

    function GetPasswordHash(): string;
    procedure SetPassword(const newPswd: string);

    function GetAppliances(): PhAppliances;
    procedure SetAppliances(const appliances: PhAppliances);

    function GetApplianceByName(const name: string): PhAppliance;
    function GetApplianceByGUID(const guid: PhGUID): PhAppliance;

  private
    class function HashPassword(const pswd: string): string;

  private
    m_Username: string;
    m_EmailAddress: string;
    m_Forenames: string;
    m_Surname: string;
    m_PasswordHash: string;
    m_Appliances: PhAppliances;
  end;

type
  PhUsers = PhVector<PhUser>;

const
  PH_TBL_FIELD_NAME_USERS_PK = 'UserGUID';
  PH_TBL_FIELD_NAME_USERS_USERNAME = 'Username';
  PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS = 'EmailAddress';
  PH_TBL_FIELD_NAME_USERS_FORENAMES = 'Forenames';
  PH_TBL_FIELD_NAME_USERS_SURNAME = 'Surname';
  PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH = 'PasswordHash';

var
  g_CurrentUser: PhUser;

implementation

constructor PhUser.Create(const guid: PhGUID);
begin
  m_Appliances := PhAppliances.Create();

  inherited Create(guid);
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

procedure PhUser.Push();
var
  query: string;
  e: Exception;
begin
  query := Format('UPDATE %s ' +
    'SET %s = ''%s'', %s = ''%s'', %s = ''%s'', %s = ''%s'', %s = ''%s'' ' +
    'WHERE %s = ''%s'';', [PH_TBL_NAME_USERS, PH_TBL_FIELD_NAME_USERS_USERNAME,
    m_Username, PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS, m_EmailAddress,
    PH_TBL_FIELD_NAME_USERS_FORENAMES, m_Forenames,
    PH_TBL_FIELD_NAME_USERS_SURNAME, m_Surname,
    PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH, m_PasswordHash,
    PH_TBL_FIELD_NAME_USERS_PK, m_GUID.ToString()]);

  e := g_Database.RunQuery(query);

  if e <> nil then
    PhLogger.Error('Error updating database: %s', [e.Message]);
end;

procedure PhUser.Pull();
begin
  with g_Database do
  begin
    if TblUsers.Locate(PH_TBL_FIELD_NAME_USERS_PK, m_GUID.ToString(), []) then
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

function PhUser.CheckPassword(const pswd: string): bool;
begin
  Result := HashPassword(pswd) = m_PasswordHash;
end;

procedure PhUser.AddAppliance(const appliance: PhAppliance);
begin
  Assert(m_Appliances <> nil, 'PhUser.AddAppliance() : m_Appliances was null!');
  m_Appliances.PushBack(appliance);
end;

procedure PhUser.RemoveAppliance(const appliance: PhAppliance);
var
  i: int;
begin
  for i := 0 to m_Appliances.Size() do
  begin
    if m_Appliances[i] = appliance then
    begin
      m_Appliances.Erase(uint64(i));
      break;
    end;
  end;
end;

function PhUser.Equals(other: PhUser): bool;
begin
  if other = nil then
    Result := false
  else
    Result := m_GUID = other.m_GUID;
end;

function PhUser.GetUsername(): string;
begin
  Result := m_Username;
end;

procedure PhUser.SetUsername(const newUsrName: string);
begin
  m_Username := newUsrName;
end;

function PhUser.GetEmailAddress(): string;
begin
  Result := m_EmailAddress;
end;

procedure PhUser.SetEmailAddress(const newAddress: string);
begin
  m_EmailAddress := newAddress;
end;

function PhUser.GetForenames(): string;
begin
  Result := m_Forenames;
end;

procedure PhUser.SetForenames(const newNames: string);
begin
  m_Forenames := newNames;
end;

function PhUser.GetSurname(): string;
begin
  Result := m_Surname;
end;

procedure PhUser.SetSurname(const newSurname: string);
begin
  m_Surname := newSurname;
end;

function PhUser.GetPasswordHash(): string;
begin
  Result := m_PasswordHash;
end;

procedure PhUser.SetPassword(const newPswd: string);
begin
  m_PasswordHash := HashPassword(newPswd);
end;

function PhUser.GetAppliances(): PhAppliances;
begin
  Result := m_Appliances;
end;

procedure PhUser.SetAppliances(const appliances: PhAppliances);
begin
  m_Appliances := appliances;
end;

function PhUser.GetApplianceByName(const name: string): PhAppliance;
var
  i: int;
begin
  for i := 0 to m_Appliances.Size() do
  begin
    if m_Appliances[i].GetName() = name then
    begin
      Result := m_Appliances[i];
      Exit();
    end;
  end;

  Result := Default (PhAppliance);
end;

function PhUser.GetApplianceByGUID(const guid: PhGUID): PhAppliance;
var
  i: int;
begin
  for i := 0 to m_Appliances.Size() do
  begin
    if m_Appliances[i].GetGUID() = guid then
    begin
      Result := m_Appliances[i];
      Exit();
    end;
  end;

  Result := Default (PhAppliance);
end;

class function PhUser.HashPassword(const pswd: string): string;
var
  MD5: THashMD5;
  hash, dynamicSalt: string;
begin
  MD5 := THashMD5.Create();

  hash := MD5.GetHashString(pswd);
  dynamicSalt := MD5.GetHashString(IntToStr(Length(pswd)));
  hash := hash.Insert(Length(pswd), dynamicSalt);
  hash := MD5.GetHashString(hash) + '==';

  Result := hash;
end;

end.

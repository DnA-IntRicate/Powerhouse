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
  /// <summary>
  /// Object used to interact with user accounts in the Powerhouse database.
  /// </summary>
  PhUser = class(PhDatabaseObjectBase, IEquatable<PhUser>)
  public
    /// <summary>
    /// Creates a new instance of <c>PhUser</c> by pulling all the values from
    /// the Powerhouse database associated with the specified GUID.
    /// </summary>
    constructor Create(const guid: PhGUID); override;

    /// <summary>
    /// Creates a new user account in the database.
    /// </summary>
    /// <param name="usr">
    /// The username for the new user account.
    /// </param>
    /// <param name="pswd">
    /// The password for the new user account.
    /// </param>
    /// <param name="email">
    /// The email address for the new user account.
    /// </param>
    /// <param name="names">
    /// The forenames for the new user account.
    /// </param>
    /// <param name="surname">
    /// The surname for the new user account.
    /// </param>
    /// <returns>
    /// The newly created user account.
    /// </returns>
    class function CreateUserAccount(const usr, pswd, email, names,
      surname: string): PhUser;

    /// <summary>
    /// Pushes the current state of this user account to the database by
    /// overwriting it with the current values of this instance.
    /// </summary>
    procedure Push(); override;

    /// <summary>
    /// Pulls the state of this user account from the database and overwrites
    /// this instance with the values from the database.
    /// </summary>
    procedure Pull(); override;

    /// <summary>
    /// Hashes the provided password and checks if it matches the user
    /// account's password hash.
    /// </summary>
    /// <param name="pswd">
    /// The password to check against.
    /// </param>
    function CheckPassword(const pswd: string): bool;

    /// <summary>
    /// Adds an appliance to the user's account.
    /// </summary>
    procedure AddAppliance(const appliance: PhAppliance);

    /// <summary>
    /// Removes an appliance from the user's account.
    /// </summary>
    procedure RemoveAppliance(const appliance: PhAppliance);

    /// <summary>
    /// Compares this user account with another <c>PhUser</c> instance for
    /// equality.
    /// </summary>
    /// <param name="other">
    /// The user account to compare against.
    /// </param>
    function Equals(other: PhUser): bool; reintroduce;

    /// <summary>
    /// Returns the username of the user account.
    /// </summary>
    function GetUsername(): string;

    /// <summary>
    /// Sets the username of the user account.
    /// </summary>
    procedure SetUsername(const newUsrName: string);

    /// <summary>
    /// Returns the email address of the user account.
    /// </summary>
    function GetEmailAddress(): string;

    /// <summary>
    /// Sets the email address of the user account.
    /// </summary>
    procedure SetEmailAddress(const newAddress: string);

    /// <summary>
    /// Returns the forenames of the user account.
    /// </summary>
    function GetForenames(): string;

    /// <summary>
    /// Sets the forenames of the user account.
    /// </summary>
    procedure SetForenames(const newNames: string);

    /// <summary>
    /// Returns the surname of the user account.
    /// </summary>
    function GetSurname(): string;

    /// <summary>
    /// Sets the surname of the user account.
    /// </summary>
    procedure SetSurname(const newSurname: string);

    /// <summary>
    /// Returns the password hash of the user account.
    /// </summary>
    function GetPasswordHash(): string;

    /// <summary>
    /// Sets the password of the user account.
    /// </summary>
    procedure SetPassword(const newPswd: string);

    /// <summary>
    /// Returns a vector of appliances associated with the user account.
    /// </summary>
    function GetAppliances(): PhAppliances;

    /// <summary>
    /// Sets the vector of appliances associated with the user account.
    /// </summary>
    procedure SetAppliances(const appliances: PhAppliances);

    /// <summary>
    /// Returns an appliance by name associated with the user account.
    /// </summary>
    function GetApplianceByName(const name: string): PhAppliance;

    /// <summary>
    /// Returns an appliance by GUID associated with the user account.
    /// </summary>
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
  /// <summary>
  /// Typedef for a pointer to a <c>PhUser</c> object.
  /// </summary>
  PhUserPtr = ^PhUser;

  /// <summary>
  /// Typedef for a vector of <c>PhUser</c>.
  /// </summary>
  PhUsers = PhVector<PhUser>;

const
  /// <summary>
  /// The name of the primary key field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_PK = 'UserGUID';

  /// <summary>
  /// The name of the username field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_USERNAME = 'Username';

  /// <summary>
  /// The name of the email address field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_EMAIL_ADDRESS = 'EmailAddress';

  /// <summary>
  /// The name of the forenames field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_FORENAMES = 'Forenames';

  /// <summary>
  /// The name of the surname field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_SURNAME = 'Surname';

  /// <summary>
  /// The name of the password hash field in the 'users' table in the
  /// Powerhouse database.
  /// </summary>
  PH_TBL_FIELD_NAME_USERS_PASSWORD_HASH = 'PasswordHash';

var
  /// <summary>
  /// The current global instance of the logged-in user.
  /// </summary>
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

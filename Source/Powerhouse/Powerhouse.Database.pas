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

unit Powerhouse.Database;

interface

uses
  System.SysUtils,
  Data.DB,
  Data.Win.ADODB,
  Powerhouse.Types, Powerhouse.Logger;

type
  /// <summary>
  /// Typedef for the lambda procedure to be executed in PhDatabase.RunQuery().
  /// </summary>
  PhOnRunQueryProc = reference to procedure(var query: TADOQuery);

type
  /// <summary>
  /// Encapsulates the logical interface to the Powerhouse database.
  /// </summary>
  PhDatabase = class
  public
    /// <summary>
    /// Establishes a connection to the database and opens its tables.
    /// </summary>
    /// <param name="dbPath">
    /// The path to the database.
    /// </param>
    constructor Create(const dbPath: string);

    /// <summary>
    /// Closes the database connection and all tables.
    /// </summary>
    destructor Destroy(); override;

    /// <summary>
    /// Executes a SQL query on the current database.
    /// </summary>
    /// <param name="sqlQuery">
    /// The SQL query string that will be executed.
    /// </param>
    /// <param name="onRunQueryProc">
    /// A reference to a lambda procedure which will be called immediately after
    /// the query has been executed.
    /// Lambda signature: procedure(var query: TADOQuery).
    /// </param>
    function RunQuery(const sqlQuery: string;
      const onRunQueryProc: PhOnRunQueryProc): EADOError; overload;

    /// <summary>
    /// Executes a SQL query on the current database.
    /// </summary>
    /// <param name="sqlQuery">
    /// The SQL query string that will be executed.
    /// </param>
    function RunQuery(const sqlQuery: string): EADOError; overload;

    /// <summary>
    /// Returns the path to the current database.
    /// </summary>
    function GetPath(): string;

  public
    Connection: TADOConnection;
    TblAppliances: TADOTable;
    TblTips: TADOTable;
    TblUsers: TADOTable;

  private
    procedure OpenTable(var refTable: TADOTable; const tableName: string);
    procedure Reload();

  private
    m_Path: string;
  end;

const
  /// <summary>
  /// The name of the 'appliances' table in the Powerhouse database.
  /// </summary>
  PH_TBL_NAME_APPLIANCES = 'tblAppliances';

  /// <summary>
  /// The name of the 'tips' table in the Powerhouse database.
  /// </summary>
  PH_TBL_NAME_TIPS = 'tblTips';

  /// <summary>
  /// The name of the 'users' table in the Powerhouse database.
  /// </summary>
  PH_TBL_NAME_USERS = 'tblUsers';

var
  /// <summary>
  /// The current global instance of the Powerhouse database.
  /// </summary>
  g_Database: PhDatabase;

implementation

constructor PhDatabase.Create(const dbPath: string);
begin
  m_Path := dbPath;

  try
    Connection := TADOConnection.Create(nil);
    with Connection do
    begin
      ConnectionString := Format('User ID=Admin;Data Source=%s', [m_Path]);
      Provider := 'Microsoft.Jet.OLEDB.4.0';
      Mode := cmReadWrite;
      LoginPrompt := false;
      Open();
    end;

    OpenTable(TblAppliances, PH_TBL_NAME_APPLIANCES);
    OpenTable(TblTips, PH_TBL_NAME_TIPS);
    OpenTable(TblUsers, PH_TBL_NAME_USERS);

  except
    on e: Exception do
      PhLogger.Error('Error connecting to database: %s', [e.Message]);
  end;
end;

destructor PhDatabase.Destroy();
begin
  TblAppliances.Close();
  TblAppliances.Free();
  TblAppliances := nil;

  TblTips.Close();
  TblTips.Free();
  TblTips := nil;

  TblUsers.Close();
  TblUsers.Free();
  TblUsers := nil;

  Connection.Close();
  Connection.Free();
  Connection := nil;

  inherited Destroy();
end;

function PhDatabase.RunQuery(const sqlQuery: string;
  const onRunQueryProc: PhOnRunQueryProc): EADOError;
var
  query: TADOQuery;
begin
  Result := nil;
  query := TADOQuery.Create(nil);

  try
    query.Connection := Connection;
    query.SQL.Text := sqlQuery;

    try
      query.ExecSQL();
      onRunQueryProc(query);
    except
      on e: EADOError do
        Result := e;
    end;

  finally
    query.Free();
  end;

  Reload();
end;

function PhDatabase.RunQuery(const sqlQuery: string): EADOError;
var
  query: TADOQuery;
begin
  Result := nil;
  query := TADOQuery.Create(nil);

  try
    query.Connection := Connection;
    query.SQL.Text := sqlQuery;

    try
      query.ExecSQL();
    except
      on e: EADOError do
        Result := e;
    end;

  finally
    query.Free();
  end;

  Reload();
end;

function PhDatabase.GetPath(): string;
begin
  Result := m_Path;
end;

procedure PhDatabase.OpenTable(var refTable: TADOTable;
  const tableName: string);
begin
  refTable := TADOTable.Create(nil);
  refTable.Connection := Connection;
  refTable.tableName := tableName;
  refTable.Open();
end;

procedure PhDatabase.Reload();
begin
  TblAppliances.Close();
  TblTips.Close();
  TblUsers.Close();

  Connection.Close();
  Connection.Open();

  TblAppliances.Open();
  TblTips.Open();
  TblUsers.Open();
end;

end.

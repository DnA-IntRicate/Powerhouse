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
  PhOnRunQueryProc = reference to procedure(var query: TADOQuery);

type
  PhDatabase = class
  public
    constructor Create(const dbPath: string);
    destructor Destroy(); override;

    function RunQuery(const sqlQuery: string;
      const onRunQueryProc: PhOnRunQueryProc): EADOError; overload;
    function RunQuery(const sqlQuery: string): EADOError; overload;

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
  PH_TBL_NAME_APPLIANCES = 'tblAppliances';
  PH_TBL_NAME_TIPS = 'tblTips';
  PH_TBL_NAME_USERS = 'tblUsers';

var
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
  inherited;

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

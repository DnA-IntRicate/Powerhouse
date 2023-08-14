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

unit Powerhouse.Base;

interface

uses
  System.SysUtils,
  Powerhouse.Types;

type
  /// <summary>
  /// The base class for all Powerhouse-specific objects.
  /// </summary>
  PhBase = class(TInterfacedObject)
  end;

type
  /// <summary>
  /// The base class for database-related objects in Powerhouse.
  /// </summary>
  PhDatabaseObjectBase = class(PhBase)
  public
    /// <summary>
    /// Creates a new instance of the PhDatabaseObjectBase class.
    /// </summary>
    /// <param name="guid">
    /// The globally unique identifier for the object which acts as the primary
    /// key for the object in the Powerhouse database.
    /// </param>
    constructor Create(const guid: PhGUID); virtual;

    /// <summary>
    /// Pushes changes made to the object to the Powerhouse database.
    /// </summary>
    procedure Push(); virtual; abstract;

    /// <summary>
    /// Pulls data from the Powerhouse database to update the object's state.
    /// </summary>
    procedure Pull(); virtual; abstract;

    /// <summary>
    /// Synchronizes the object's state with the Powerhouse database by
    /// performing a Push and then a Pull.
    /// </summary>
    procedure Sync(); virtual;

    /// <summary>
    /// Returns the GUID of the database-object.
    /// </summary>
    function GetGUID(): PhGUID;

  protected
    m_GUID: PhGUID;
  end;

implementation

constructor PhDatabaseObjectBase.Create(const guid: PhGUID);
begin
  m_GUID := guid;

  Pull();
end;

procedure PhDatabaseObjectBase.Sync();
begin
  Push();
  Pull();
end;

function PhDatabaseObjectBase.GetGUID(): PhGUID;
begin
  Result := m_GUID;
end;

end.

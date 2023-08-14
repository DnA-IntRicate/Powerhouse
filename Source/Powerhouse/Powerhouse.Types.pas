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

unit Powerhouse.Types;

interface

uses
  System.SysUtils, System.StrUtils, System.Math;

type
  /// <summary>
  /// Typedef for a boolean value (True or False).
  /// </summary>
  bool = System.Boolean;

  /// <summary>
  /// Typedef for a signed 32-bit integer.
  /// </summary>
  int = System.Integer;

  /// <summary>
  /// Typedef for a signed 8-bit integer.
  /// </summary>
  int8 = System.ShortInt;

  /// <summary>
  /// Typedef for a signed 16-bit integer.
  /// </summary>
  int16 = System.SmallInt;

  /// <summary>
  /// Typedef for a signed 32-bit integer.
  /// </summary>
  int32 = int;

  /// <summary>
  /// Typedef for a signed 64-bit integer.
  /// </summary>
  int64 = System.Int64;

  /// <summary>
  /// Typedef for an unsigned 32-bit integer.
  /// </summary>
  uint = System.Cardinal;

  /// <summary>
  /// Typedef for an unsigned 8-bit integer.
  /// </summary>
  uint8 = System.Byte;

  /// <summary>
  /// Typedef for an unsigned 16-bit integer.
  /// </summary>
  uint16 = System.Word;

  /// <summary>
  /// Typedef for an unsigned 32-bit integer.
  /// </summary>
  uint32 = uint;

  /// <summary>
  /// Typedef for an unsigned 64-bit integer.
  /// </summary>
  uint64 = System.UInt64;

  /// <summary>
  /// Typedef for a floating-point number (32-bit).
  /// </summary>
  float = System.Single;

  /// <summary>
  /// Typedef for a floating-point number (extended precision).
  /// </summary>
  floatmax = System.Extended;

  /// <summary>
  /// Typedef for a double-precision floating-point number (64-bit).
  /// </summary>
  double = System.Double;

  /// <summary>
  /// Typedef for a decimal value.
  /// </summary>
  decimal = System.Currency;

  /// <summary>
  /// Typedef for a wide string (Unicode) character.
  /// </summary>
  wstring = System.WideString;

  /// <summary>
  /// Typedef for a wide character (Unicode).
  /// </summary>
  wchar_t = System.WideChar;

  /// <summary>
  /// Typedef for a pointer to void (untyped pointer).
  /// </summary>
  voidptr = Pointer;

type
  /// <summary>
  /// Represents a globally unique identifier. This is the logical
  /// representation of all primary keys in the Powerhouse database.
  /// </summary>
  PhGUID = record
  public
    /// <summary>
    /// Creates a new instance of the <c>PhGUID</c> structure.
    /// </summary>
    /// <param name="hexGuidStr">
    /// An optional hexadecimal GUID string for initialization.
    /// </param>
    class function Create(const hexGuidStr: string = ''): PhGUID; static;

    /// <summary>
    /// Converts the <c>PhGUID</c> to a hex-string representation.
    /// </summary>
    function ToString(): string;

    /// <summary>
    /// Converts the <c>PhGUID</c> to an unsigned 64-bit integer representation.
    /// </summary>
    function ToInt(): uint64;

    /// <summary>
    /// Conversion operator explicitly converts a <c>PhGUID</c> to a string.
    /// </summary>
    class operator explicit(const value: PhGUID): string; inline;

    /// <summary>
    /// Conversion operator implicitly converts a <c>PhGUID</c> to a string.
    /// </summary>
    class operator implicit(const value: PhGUID): string; inline;

    /// <summary>
    /// Conversion operator explicitly converts a <c>PhGUID</c> to an
    /// unsigned 64-bit integer.
    /// </summary>
    class operator explicit(const value: PhGUID): uint64; inline;

    /// <summary>
    /// Conversion operator implicitly converts a <c>PhGUID</c> to an
    /// unsigned 64-bit integer.
    /// </summary>
    class operator implicit(const value: PhGUID): uint64; inline;

    /// <summary>
    /// Conversion operator explicitly converts a hexadecimal GUID string to
    /// a <c>PhGUID</c>.
    /// </summary>
    class operator explicit(const hexGuidStr: string): PhGUID; inline;

    /// <summary>
    /// Conversion operator implicitly converts a hexadecimal GUID string to
    /// a <c>PhGUID</c>.
    /// </summary>
    class operator implicit(const hexGuidStr: string): PhGUID; inline;

    /// <summary>
    /// Compares the current <c>PhGUID</c> instance with another <c>PhGUID</c>
    /// for equality.
    /// </summary>
    /// <param name="other">
    /// The <c>PhGUID</c> instance to compare with.
    /// </param>
    function Equals(const other: PhGUID): bool; inline;

    /// <summary>
    /// Checks if two <c>PhGUID</c> instances are equal.
    /// </summary>
    class operator Equal(const left, right: PhGUID): bool; inline;

    /// <summary>
    /// Checks if two <c>PhGUID</c> instances are not equal.
    /// </summary>
    class operator NotEqual(const left, right: PhGUID): bool; inline;

  private
    m_GUID: string;
  end;

implementation

class function PhGUID.Create(const hexGuidStr: string = ''): PhGUID;
var
  guid: TGUID;
  hexGUID: string;
begin
  if hexGuidStr = '' then
  begin
    CreateGUID(guid);
    hexGUID := GUIDToString(guid);

    hexGUID := StringReplace(hexGUID, '{', '', [rfReplaceAll]);
    hexGUID := StringReplace(hexGUID, '}', '', [rfReplaceAll]);
    hexGUID := StringReplace(hexGUID, '-', '', [rfReplaceAll]);
  end
  else
  begin
    hexGUID := hexGuidStr;
  end;

  Result.m_GUID := hexGUID;
end;

function PhGUID.ToString(): string;
begin
  Result := m_GUID;
end;

function PhGUID.ToInt(): uint64;
begin
  Result := StrToInt('$' + m_GUID);
end;

class operator PhGUID.explicit(const value: PhGUID): string;
begin
  Result := value.ToString();
end;

class operator PhGUID.implicit(const value: PhGUID): string;
begin
  Result := string(value);
end;

class operator PhGUID.explicit(const value: PhGUID): uint64;
begin
  Result := value.ToInt();
end;

class operator PhGUID.implicit(const value: PhGUID): uint64;
begin
  Result := uint64(value);
end;

class operator PhGUID.explicit(const hexGuidStr: string): PhGUID;
begin
  Result := PhGUID.Create(hexGuidStr);
end;

class operator PhGUID.implicit(const hexGuidStr: string): PhGUID;
begin
  Result := PhGUID(hexGuidStr);
end;

function PhGUID.Equals(const other: PhGUID): bool;
begin
  Result := m_GUID = other.m_GUID;
end;

class operator PhGUID.Equal(const left, right: PhGUID): bool;
begin
  Result := left.Equals(right);
end;

class operator PhGUID.NotEqual(const left, right: PhGUID): bool;
begin
  Result := not(left = right);
end;

end.

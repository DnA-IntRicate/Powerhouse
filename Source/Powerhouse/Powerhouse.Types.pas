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
  bool = System.Boolean;

  int = System.Integer;
  int8 = System.ShortInt;
  int16 = System.SmallInt;
  int32 = int;
  int64 = System.Int64;

  uint = System.Cardinal;
  uint8 = System.Byte;
  uint16 = System.Word;
  uint32 = uint;
  uint64 = System.UInt64;

  float = System.Single;
  floatmax = System.Extended;
  double = System.Double;
  decimal = System.Currency;

  wstring = System.WideString;
  wchar_t = System.WideChar;

  voidptr = Pointer;

  PhIDType = uint32;

implementation

end.

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

unit Powerhouse.Vector;

interface

uses
  System.SysUtils, System.Math,
  System.Generics.Defaults, System.Generics.Collections,
  Powerhouse.Types, Powerhouse.Base;

type
  PhVector<_Ty> = class(PhBase, IEquatable<PhVector<_Ty>>)
  public
    constructor Create(const capacity: uint64); overload;
    constructor Create(const values: PhVector<_Ty>); overload;
    constructor Create(const values: array of _Ty); overload;
    constructor Create(const values: TArray<_Ty>); overload;
    constructor Create(const collection: IEnumerable<_Ty>); overload;
    constructor Create(const collection: TEnumerable<_Ty>); overload;
    constructor Create(); overload;
    destructor Destroy(); override;

    procedure Assign(const values: PhVector<_Ty>); overload;
    procedure Assign(const values: array of _Ty); overload;
    procedure Assign(const values: TArray<_Ty>); overload;
    procedure Assign(const collection: IEnumerable<_Ty>); overload;
    procedure Assign(const collection: TEnumerable<_Ty>); overload;

    function Copy(): PhVector<_Ty>;

    procedure PushBack(const value: _Ty);
    procedure PopBack();

    procedure PushBackRange(const values: PhVector<_Ty>); overload;
    procedure PushBackRange(const values: array of _Ty); overload;
    procedure PushBackRange(const values: TArray<_Ty>); overload;
    procedure PushBackRange(const collection: IEnumerable<_Ty>); overload;
    procedure PushBackRange(const collection: TEnumerable<_Ty>); overload;

    procedure Insert(const index: uint64; const value: _Ty);
    procedure Erase(const index: uint64);

    procedure Resize(const newSize: uint64);
    procedure Reserve(const newCapacity: uint64);
    procedure ShrinkToFit();
    procedure Clear();

    function Contains(const value: IEquatable<_Ty>): bool;
    function Equals(other: PhVector<_Ty>): bool; reintroduce;

    function Empty(): bool; inline;
    function Size(): uint64; inline;
    function Capacity(): uint64; inline;

    function Data(): TArray<_Ty>; inline;
    function Front(): _Ty;
    function Back(): _Ty;

    function First(): uint64; inline;
    function Last(): uint64; inline;

    function At(const index: uint64): _Ty; inline;

  private
    function GetItem(const index: uint64): _Ty;
    procedure SetItem(const index: uint64; const value: _Ty);

  public
    property Items[const index: uint64]: _Ty read GetItem
      write SetItem; default;

  private type
    Iterator = record
    public
      constructor Create(vector: PhVector<_Ty>; index: int64);

      function MoveNext(): bool;

      function GetCurrent(): _Ty;
      property Current: _Ty read GetCurrent;

    private
      m_Vector: PhVector<_Ty>;
      m_Index: int64;
    end;

  public
    function GetEnumerator(): Iterator;

  private
    function GetCapacity(): uint64; inline;
    procedure SetCapacity(const newCapacity: uint64);

    procedure AssertIndex(const index: uint64); inline;

    procedure Grow();

  private
    m_Data: TArray<_Ty>;
    m_Size: uint64;
  end;

implementation

constructor PhVector<_Ty>.Create(const capacity: uint64);
begin
  m_Size := 0;
  SetCapacity(capacity);
end;

constructor PhVector<_Ty>.Create(const values: PhVector<_Ty>);
begin
  Create(values.Size());
  PushBackRange(values);
end;

constructor PhVector<_Ty>.Create(const values: array of _Ty);
begin
  Create(uint64(Length(values)));
  PushBackRange(values);
end;

constructor PhVector<_Ty>.Create(const values: TArray<_Ty>);
begin
  Create(values);
end;

constructor PhVector<_Ty>.Create(const collection: IEnumerable<_Ty>);
begin
  Create();
  PushBackRange(collection);
end;

constructor PhVector<_Ty>.Create(const collection: TEnumerable<_Ty>);
begin
  Create();
  PushBackRange(collection);
end;

constructor PhVector<_Ty>.Create();
begin
  m_Size := 0;
  SetCapacity(1);
end;

destructor PhVector<_Ty>.Destroy();
begin
  Clear();
  inherited Destroy();
end;

procedure PhVector<_Ty>.Assign(const values: PhVector<_Ty>);
begin
  Clear();
  PushBackRange(values);
end;

procedure PhVector<_Ty>.Assign(const values: array of _Ty);
begin
  Clear();
  PushBackRange(values);
end;

procedure PhVector<_Ty>.Assign(const values: TArray<_Ty>);
begin
  Assign(values);
end;

procedure PhVector<_Ty>.Assign(const collection: IEnumerable<_Ty>);
begin
  Clear();
  PushBackRange(collection);
end;

procedure PhVector<_Ty>.Assign(const collection: TEnumerable<_Ty>);
begin
  Assign(collection);
end;

function PhVector<_Ty>.Copy(): PhVector<_Ty>;
begin
  Result := PhVector<_Ty>.Create(GetCapacity());
  Result.Assign(Self);
end;

procedure PhVector<_Ty>.PushBack(const value: _Ty);
begin
  if m_Size = GetCapacity() then
    Grow();

  m_Data[m_Size] := value;
  Inc(m_Size);
end;

procedure PhVector<_Ty>.PopBack();
begin
  if m_Size > 0 then
  begin
    Dec(m_Size);
    m_Data[m_Size] := Default (_Ty);
  end;
end;

procedure PhVector<_Ty>.PushBackRange(const values: PhVector<_Ty>);
var
  i: int;
begin
  SetCapacity(m_Size + values.m_Size);

  for i := values.First() to values.Last() do
    PushBack(values[i]);
end;

procedure PhVector<_Ty>.PushBackRange(const values: array of _Ty);
var
  i: int;
begin
  SetCapacity(m_Size + uint64(Length(values)));

  for i := 0 to High(values) do
    PushBack(values[i]);
end;

procedure PhVector<_Ty>.PushBackRange(const values: TArray<_Ty>);
begin
  PushBackRange(values);
end;

procedure PhVector<_Ty>.PushBackRange(const collection: IEnumerable<_Ty>);
var
  item: _Ty;
begin
  for item in collection do
    PushBack(item);
end;

procedure PhVector<_Ty>.PushBackRange(const collection: TEnumerable<_Ty>);
begin
  PushBackRange(collection);
end;

procedure PhVector<_Ty>.Insert(const index: uint64; const value: _Ty);
begin
  AssertIndex(index);
  SetCapacity(m_Size + 1);

  if index < m_Size then
  begin
    System.Move(m_Data[index], m_Data[index + 1],
      (m_Size - index) * SizeOf(_Ty));
  end;

  m_Data[index] := value;
  Inc(m_Size);
end;

procedure PhVector<_Ty>.Erase(const index: uint64);
begin
  AssertIndex(index);

  if index < (m_Size - 1) then
  begin
    System.Move(m_Data[index + 1], m_Data[index], (m_Size - index - 1) *
      SizeOf(_Ty));
  end;

  Dec(m_Size);
  m_Data[m_Size] := Default (_Ty);
end;

procedure PhVector<_Ty>.Resize(const newSize: uint64);
begin
  if newSize > m_Size then
  begin
    if newSize > GetCapacity() then
      SetCapacity(newSize);

    while m_Size < newSize do
    begin
      m_Data[m_Size] := Default (_Ty);
      Inc(m_Size);
    end;
  end
  else if newSize < m_Size then
  begin
    while m_Size > newSize do
    begin
      Dec(m_Size);
      m_Data[m_Size] := Default (_Ty);
    end;

    SetCapacity(newSize);
  end;
end;

procedure PhVector<_Ty>.Reserve(const newCapacity: uint64);
begin
  if newCapacity > GetCapacity() then
    SetCapacity(newCapacity);
end;

procedure PhVector<_Ty>.ShrinkToFit();
begin
  if m_Size < GetCapacity() then
    SetCapacity(m_Size);
end;

procedure PhVector<_Ty>.Clear();
begin
  while m_Size > 0 do
    PopBack();

  m_Size := 0;
end;

function PhVector<_Ty>.Contains(const value: IEquatable<_Ty>): bool;
var
  i: uint64;
begin
  Result := false;

  for i := Low(m_Data) to High(m_Data) do
  begin
    if value.Equals(m_Data[i]) then
    begin
      Result := true;
      break;
    end;
  end;
end;

function PhVector<_Ty>.Equals(other: PhVector<_Ty>): bool;
begin
  Result := Self.m_Data = other.m_Data;
end;

function PhVector<_Ty>.Empty(): bool;
begin
  Result := m_Size = 0;
end;

function PhVector<_Ty>.Size(): uint64;
begin
  Result := m_Size;
end;

function PhVector<_Ty>.Capacity(): uint64;
begin
  Result := GetCapacity();
end;

function PhVector<_Ty>.Data(): TArray<_Ty>;
begin
  Result := m_Data;
end;

function PhVector<_Ty>.Front(): _Ty;
begin
  if m_Size > 0 then
    Result := m_Data[First()]
  else
    raise EListError.Create('Cannot get Front of an empty vector!');
end;

function PhVector<_Ty>.Back(): _Ty;
begin
  if m_Size > 0 then
    Result := m_Data[Last()]
  else
    raise EListError.Create('Cannot get Back of an empty vector!');
end;

function PhVector<_Ty>.First(): uint64;
begin
  Result := 0;
end;

function PhVector<_Ty>.Last(): uint64;
begin
  Result := m_Size - 1;
end;

function PhVector<_Ty>.At(const index: uint64): _Ty;
begin
  Result := GetItem(index);
end;

function PhVector<_Ty>.GetItem(const index: uint64): _Ty;
begin
  AssertIndex(index);
  Result := m_Data[index];
end;

procedure PhVector<_Ty>.SetItem(const index: uint64; const value: _Ty);
begin
  AssertIndex(index);
  m_Data[index] := value;
end;

constructor PhVector<_Ty>.Iterator.Create(vector: PhVector<_Ty>; index: int64);
begin
  m_Vector := vector;
  m_Index := index;
end;

function PhVector<_Ty>.Iterator.MoveNext(): bool;
begin
  if not m_Vector.Empty() then
  begin
    if m_Index <> -1 then
      Result := m_Index < m_Vector.Last()
    else
      Result := true;

    if Result then
      Inc(m_Index);
  end
  else
    Result := false;
end;

function PhVector<_Ty>.Iterator.GetCurrent(): _Ty;
begin
  Result := m_Vector[m_Index];
end;

function PhVector<_Ty>.GetEnumerator(): Iterator;
begin
  Result := Iterator.Create(Self, -1);
end;

function PhVector<_Ty>.GetCapacity(): uint64;
begin
  Result := Length(m_Data);
end;

procedure PhVector<_Ty>.SetCapacity(const newCapacity: uint64);
begin
  if newCapacity <> GetCapacity then
  begin
    SetLength(m_Data, newCapacity);
    m_Size := Min(m_Size, newCapacity);
  end;
end;

procedure PhVector<_Ty>.AssertIndex(const index: uint64);
begin
  if (index > m_Size) then
    raise EArgumentOutOfRangeException.Create('Index was out of range!');
end;

procedure PhVector<_Ty>.Grow();
var
  newCapacity: int64;
begin
  if GetCapacity() < 64 then
    newCapacity := GetCapacity() * 2
  else
    newCapacity := GetCapacity() + (GetCapacity() div 4);

  SetCapacity(newCapacity);
end;

end.

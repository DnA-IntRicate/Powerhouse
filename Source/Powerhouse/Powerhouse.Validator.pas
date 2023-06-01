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

unit Powerhouse.Validator;

interface

uses
  System.SysUtils, System.StrUtils, System.Variants, System.Classes,
  System.RegularExpressions;

type
  PhValidationFlag = (TooShort = 1, TooLong = 2, InvalidFormat = 4,
    ForbiddenCharacter = 8, Empty = 16, Null = Empty);
  PhValidationFlags = set of PhValidationFlag;

  PhValidationOption = (Letters = 1, Numbers = 2, Symbols = 4, All = 8);
  PhValidationOptions = set of PhValidationOption;

type
  PhValidation = record
    Flags: PhValidationFlags;
    Valid: boolean;
  end;

type
  PhValidator = class
  public
    class function ValidateStringLength(const str: string; min, max: integer)
      : PhValidation;

    class function ValidateString(const str: string;
      options: PhValidationOptions = []; min: integer = -1; max: integer = -1)
      : PhValidation;

    class function ValidateEmailAddress(const email: string): PhValidation;

  private
    class procedure AddFlag(var validation: PhValidation;
      flag: PhValidationFlag);

    class function HasOption(const options: PhValidationOptions;
      const option: PhValidationOption): boolean;
  end;

const
  PH_REGEX_WHITELIST = '^[a-zA-Z0-9_+\-=.@ ]+$';
  PH_REGEX_EMAIL_ADDRESS = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  PH_REGEX_LETTERS = '^[A-Za-z]+$';
  PH_REGEX_LETTERS_NUMBERS = '^[a-zA-Z0-9]+$';
  PH_REGEX_LETTERS_SYMBOLS = '^[a-zA-Z\p{P}]+$';
  PH_REGEX_LETTERS_NUMBERS_SYMBOLS = '^[a-zA-Z0-9\p{P}]+$';

  PH_REGEX_NUMBERS = '^[0-9]+$';
  PH_REGEX_NUMBERS_SYMBOLS = '^[0-9\p{P}]+$';

  PH_REGEX_SYMBOLS = '^[p{P}]+$';

implementation

class function PhValidator.ValidateStringLength(const str: string;
  min, max: integer): PhValidation;
var
  validation: PhValidation;
begin
  validation.Valid := true;
  validation.Flags := [];

  if Length(str) < min then
    AddFlag(validation, PhValidationFlag.TooShort)
  else if Length(str) > max then
    AddFlag(validation, PhValidationFlag.TooLong);

  Result := validation;
end;

class function PhValidator.ValidateString(const str: string;
  options: PhValidationOptions = []; min: integer = -1; max: integer = -1)
  : PhValidation;
var
  validation, lengthValidation: PhValidation;
  mustValidateLength: boolean;
begin
  validation.Valid := true;
  validation.Flags := [];

  mustValidateLength := (min <> -1) and (max <> -1);
  if mustValidateLength then
    lengthValidation := ValidateStringLength(str, min, max);

  if not HasOption(options, PhValidationOption.All) then
  begin
    if HasOption(options, PhValidationOption.Letters) and
      HasOption(options, PhValidationOption.Numbers) and
      HasOption(options, PhValidationOption.Symbols) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_LETTERS_NUMBERS_SYMBOLS);
    end
    else if HasOption(options, PhValidationOption.Letters) and
      HasOption(options, PhValidationOption.Numbers) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_LETTERS_NUMBERS);
    end
    else if HasOption(options, PhValidationOption.Letters) and
      HasOption(options, PhValidationOption.Symbols) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_LETTERS_SYMBOLS);
    end
    else if HasOption(options, PhValidationOption.Letters) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_LETTERS);
    end
    else if HasOption(options, PhValidationOption.Numbers) and
      HasOption(options, PhValidationOption.Symbols) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_NUMBERS_SYMBOLS);
    end
    else if HasOption(options, PhValidationOption.Numbers) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_NUMBERS);
    end
    else if HasOption(options, PhValidationOption.Symbols) then
    begin
      validation.Valid := TRegEx.IsMatch(str, PH_REGEX_SYMBOLS);
    end;
  end;

  if not validation.Valid then
    AddFlag(validation, PhValidationFlag.InvalidFormat);

  if str = '' then
    AddFlag(validation, PhValidationFlag.Empty);

  if not TRegEx.IsMatch(str, PH_REGEX_WHITELIST) then
    AddFlag(validation, PhValidationFlag.ForbiddenCharacter);

  if mustValidateLength then
  begin
    validation.Valid := validation.Valid and lengthValidation.Valid;
    validation.Flags := validation.Flags + lengthValidation.Flags;
  end;

  Result := validation;
end;

class function PhValidator.ValidateEmailAddress(const email: string)
  : PhValidation;
var
  validation: PhValidation;
begin
  validation := ValidateString(email);

  if not TRegEx.IsMatch(email, PH_REGEX_EMAIL_ADDRESS) then
    AddFlag(validation, PhValidationFlag.InvalidFormat);

  Result := validation;
end;

class procedure PhValidator.AddFlag(var validation: PhValidation;
  flag: PhValidationFlag);
begin
  Include(validation.Flags, flag);
  validation.Valid := false;
end;

class function PhValidator.HasOption(const options: PhValidationOptions;
  const option: PhValidationOption): boolean;
begin
  Result := option in options;
end;

end.

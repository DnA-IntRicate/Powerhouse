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
  System.RegularExpressions,
  Powerhouse.Types;

type
  /// <summary>
  /// Flags indicating various validation issues.
  /// </summary>
  PhValidationFlag = (TooShort = 1, TooLong = 2, InvalidFormat = 4,
    ForbiddenCharacter = 8, Empty = 16, Null = Empty);

  /// <summary>
  /// Set of <c>PhValidationFlag</c>.
  /// </summary>
  PhValidationFlags = set of PhValidationFlag;

  /// <summary>
  /// Options for string validation.
  /// </summary>
  PhValidationOption = (Letters = 1, Numbers = 2, Symbols = 4, All = 8);

  /// <summary>
  /// Set of <c>PhValidationOptions</c>.
  /// </summary>s
  PhValidationOptions = set of PhValidationOption;

type
  /// <summary>
  /// Represents the result of a validation operation.
  /// </summary>
  PhValidation = record
    /// <summary>
    /// Flags indicating validation issues.
    /// </summary>
    Flags: PhValidationFlags;

    /// <summary>
    /// Indicates if the validation passed.
    /// </summary>
    Valid: bool;
  end;

type
  /// <summary>
  /// Provides methods for validating strings and email addresses.
  /// </summary>
  PhValidator = class
  public
    /// <summary>
    /// Validates the length of a string.
    /// </summary>
    /// <param name="str">
    /// The string to validate.
    /// </param>
    /// <param name="min">
    /// The minimum allowed length.
    /// </param>
    /// <param name="max">
    /// The maximum allowed length.
    /// </param>
    /// <returns>
    /// A <c>PhValidation</c> result indicating validation outcome.
    /// </returns>
    class function ValidateStringLength(const str: string; const min, max: int)
      : PhValidation;

    /// <summary>
    /// Validates a string based on specified options and length constraints.
    /// </summary>
    /// <param name="str">
    /// The string to validate.
    /// </param>
    /// <param name="options">
    /// The validation options to apply.
    /// </param>
    /// <param name="min">
    /// The minimum allowed length.
    /// </param>
    /// <param name="max">
    /// The maximum allowed length.
    /// </param>
    /// <returns>
    /// A <c>PhValidation</c> result indicating validation outcome.
    /// </returns>
    class function ValidateString(const str: string;
      options: PhValidationOptions = []; const min: int = -1;
      const max: int = -1): PhValidation;

    /// <summary>
    /// Validates an email address.
    /// </summary>
    /// <param name="email">
    /// The email address to validate.
    /// </param>
    /// <returns>
    /// A <c>PhValidation</c> result indicating validation outcome.
    /// </returns>
    class function ValidateEmailAddress(const email: string): PhValidation;

  private
    class procedure AddFlag(var refValidation: PhValidation;
      const flag: PhValidationFlag);

    class function HasOption(const options: PhValidationOptions;
      const option: PhValidationOption): bool;
  end;

implementation

const
  // Since quite a few systems in the application sees user-input being
  // sent to the database in SQL queries, this makes the application vulnerable
  // to SQL injection attacks which can be used to bypass login-screens and
  // inflict harm onto the database. To prevent this, a character whitelist has
  // been created. This means that if the user inputs any character into any
  // input field that is not in the whitelist, PhValidator will validate that
  // input as a fail and these invalid strings will therefore not be passed to
  // the database. For example: characters such as quotes (' ") have been
  // excluded from the whitelist because these characters can be used to
  // interfere with SQL queries and to inject other SQL queries inside of the
  // queries that the application creates.
  PH_REGEX_WHITELIST = '^[a-zA-Z0-9_+\-=.,@ ]+$';
  PH_REGEX_EMAIL_ADDRESS = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  PH_REGEX_LETTERS = '^[A-Za-z ]+$';
  PH_REGEX_LETTERS_NUMBERS = '^[a-zA-Z0-9, ]+$';
  PH_REGEX_LETTERS_SYMBOLS = '^[a-zA-Z\p{P} ]+$';
  PH_REGEX_LETTERS_NUMBERS_SYMBOLS = '^[a-zA-Z0-9,\p{P} ]+$';

  PH_REGEX_NUMBERS = '^[0-9]+(\,[0-9]+)?$';
  PH_REGEX_NUMBERS_SYMBOLS = '^[0-9\p{P}]+$';

  PH_REGEX_SYMBOLS = '^[p{P}]+$';

class function PhValidator.ValidateStringLength(const str: string;
  const min, max: int): PhValidation;
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
  options: PhValidationOptions = []; const min: int = -1; const max: int = -1)
  : PhValidation;
var
  validation, lengthValidation: PhValidation;
  mustValidateLength: bool;
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

class procedure PhValidator.AddFlag(var refValidation: PhValidation;
  const flag: PhValidationFlag);
begin
  Include(refValidation.Flags, flag);
  refValidation.Valid := false;
end;

class function PhValidator.HasOption(const options: PhValidationOptions;
  const option: PhValidationOption): boolean;
begin
  Result := option in options;
end;

end.

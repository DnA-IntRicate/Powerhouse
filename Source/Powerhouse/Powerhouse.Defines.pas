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

unit Powerhouse.Defines;

interface

const
  /// <summary>
  /// The path to the Powerhouse database file.
  /// </summary>
  PH_PATH_DATABASE = 'Assets/PowerhouseDb.mdb';

  /// <summary>
  /// The path to the Powerhouse save file.
  /// </summary>
  PH_PATH_SAVEFILE = 'PowerhouseSave.json';

  /// <summary>
  /// The tab character.
  /// </summary>
  PH_TAB = #9;

  /// <summary>
  /// Carriage return and line feed characters.
  /// </summary>
  PH_CRLF = #13#10;

  /// <summary>
  /// Conversion constant for cents to rands.
  /// </summary>
  PH_CENT_TO_RAND = 0.01;

  /// <summary>
  /// Conversion constant for minutes to hours.
  /// </summary>
  PH_MINUTE_TO_HOUR = 0.0166667;

  /// <summary>
  /// Conversion constant for hours to minutes.
  /// </summary>
  PH_HOUR_TO_MINUTE = 60.0;

  /// <summary>
  /// Conversion constant for watts to kilowatts.
  /// </summary>
  PH_WATT_TO_KILOWATT = 0.001;

  /// <summary>
  /// Maximum length for appliance string representation.
  /// </summary>
  PH_MAX_LENGTH_APPLIANCE_STR = 26;

  /// <summary>
  /// Maximum length for appliance battery kind string representation.
  /// </summary>
  PH_MAX_LENGTH_APPLIANCE_STR_BATTERY_KIND = 8;

  /// <summary>
  /// Maximum length for a valid username.
  /// </summary>
  PH_MAX_LENGTH_USERNAME = 18;

  /// <summary>
  /// Maximum length for a valid password.
  /// </summary>
  PH_MAX_LENGTH_PASSWORD = 26;

  /// <summary>
  /// Minimum length for a valid username.
  /// </summary>
  PH_MIN_LENGTH_USERNAME = 6;

  /// <summary>
  /// Minimum length for a valid password.
  /// </summary>
  PH_MIN_LENGTH_PASSWORD = 8;

  /// <summary>
  /// ASCII key code for Enter.
  /// </summary>
  PH_KEYS_ENTER = Chr(13);

implementation

end.

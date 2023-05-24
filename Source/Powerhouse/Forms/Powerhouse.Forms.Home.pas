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

unit Powerhouse.Forms.Home;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Powerhouse.Form;

type
  TPhfHome = class(PhForm)
    lstAppliances: TListBox;
    pnlApplianceInformation: TPanel;
    Label1: TLabel;
    btnModifyAppliance: TButton;
    pnlHomeForm: TPanel;
    Label3: TLabel;
    pgcHome: TPageControl;
    tabAppliances: TTabSheet;
    tabInsights: TTabSheet;
    tabCalculator: TTabSheet;
    tabAccount: TTabSheet;
    tabHelp: TTabSheet;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  public
    procedure Enable(); override;
    procedure Disable(); override;
  end;

var
  g_HomeForm: TPhfHome;

implementation

{$R *.dfm}

procedure TPhfHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Quit();
end;

procedure TPhfHome.Enable();
begin
  inherited;

  Self.Enabled := true;
  Self.Show();
end;

procedure TPhfHome.Disable();
begin
  inherited;

  Self.Hide();
  Self.Enabled := false;
end;

end.

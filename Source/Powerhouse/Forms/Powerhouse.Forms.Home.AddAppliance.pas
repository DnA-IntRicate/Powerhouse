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

unit Powerhouse.Forms.Home.AddAppliance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Powerhouse.Types, Powerhouse.Vector,
  Powerhouse.Form, Powerhouse.Database, Powerhouse.Logger, Powerhouse.Appliance;

type
  TPhfAddAppliance = class(PhForm)
    lstAllAppliances: TListBox;
    btnAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);

  public
    function GetNewAppliance(): PhAppliance;

  private
    m_NewAppliance: PhAppliance;
    m_AllAppliances: PhVector<PhAppliance>;
  end;

implementation

{$R *.dfm}

procedure TPhfAddAppliance.FormCreate(Sender: TObject);
var
  guid: PhGUID;
  guids: PhVector<PhGUID>;
  appliance: PhAppliance;
begin
  with g_Database do
  begin
    m_AllAppliances := PhVector<PhAppliance>.Create(TblAppliances.RecordCount);
    guids := PhVector<PhGUID>.Create(TblAppliances.RecordCount);

    TblAppliances.First();
    while not TblAppliances.Eof do
    begin
      guids.PushBack(TblAppliances[PH_TBL_FIELD_NAME_APPLIANCES_PK]);
      TblAppliances.Next();
    end;

    TblAppliances.First();

    for guid in guids do
      m_AllAppliances.PushBack(PhAppliance.Create(guid));
  end;

  for appliance in m_AllAppliances do
    lstAllAppliances.Items.Add(appliance.GetName());
end;

procedure TPhfAddAppliance.btnAddClick(Sender: TObject);
begin
  m_NewAppliance := m_AllAppliances[lstAllAppliances.ItemIndex];

  DisableModal();
end;

function TPhfAddAppliance.GetNewAppliance(): PhAppliance;
begin
  Result := m_NewAppliance;
end;

end.

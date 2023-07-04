object PhfMain: TPhfMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 203
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 12
  object edtGUID: TEdit
    Left = 8
    Top = 8
    Width = 265
    Height = 89
    TabOrder = 0
    Text = 'Edit1'
  end
  object btnGUID: TButton
    Left = 96
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Generate GUID'
    TabOrder = 1
    OnClick = btnGUIDClick
  end
end

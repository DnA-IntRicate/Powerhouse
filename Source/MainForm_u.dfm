object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 554
  ClientWidth = 802
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object btnGUID: TButton
    Left = 8
    Top = 54
    Width = 75
    Height = 25
    Caption = 'GUID'
    TabOrder = 0
    OnClick = btnGUIDClick
  end
  object edtGUID: TEdit
    Left = 8
    Top = 24
    Width = 329
    Height = 24
    TabOrder = 1
  end
  object edtPassword: TEdit
    Left = 352
    Top = 176
    Width = 249
    Height = 24
    TabOrder = 2
  end
  object edtHash: TEdit
    Left = 352
    Top = 206
    Width = 249
    Height = 24
    TabOrder = 3
  end
  object btnHash: TButton
    Left = 264
    Top = 232
    Width = 97
    Height = 51
    Caption = 'Hash'
    TabOrder = 4
    OnClick = btnHashClick
  end
end

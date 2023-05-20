object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 668
  ClientWidth = 802
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
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
  object redQuestion: TRichEdit
    Left = 8
    Top = 352
    Width = 401
    Height = 153
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 5
    Zoom = 100
  end
  object btnAsk: TButton
    Left = 8
    Top = 511
    Width = 105
    Height = 49
    Caption = 'Ask'
    TabOrder = 6
    OnClick = btnAskClick
  end
  object redAnswer: TRichEdit
    Left = 448
    Top = 352
    Width = 346
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Zoom = 100
  end
end

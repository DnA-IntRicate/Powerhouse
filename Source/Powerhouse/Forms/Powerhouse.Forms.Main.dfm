object PhfMain: TPhfMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 114
  ClientWidth = 227
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -8
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 10
  object edtGUID: TEdit
    Left = 6
    Top = 6
    Width = 212
    Height = 18
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 0
    Text = 'Edit1'
  end
  object btnGUID: TButton
    Left = 77
    Top = 90
    Width = 60
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Generate GUID'
    TabOrder = 1
    OnClick = btnGUIDClick
  end
end

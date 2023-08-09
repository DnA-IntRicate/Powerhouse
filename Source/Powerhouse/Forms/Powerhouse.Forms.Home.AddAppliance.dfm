object PhfAddAppliance: TPhfAddAppliance
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Add Appliance'
  ClientHeight = 402
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 12
  object lstAvailableAppliances: TListBox
    Left = 6
    Top = 6
    Width = 424
    Height = 285
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ItemHeight = 12
    TabOrder = 0
  end
  object btnAdd: TButton
    Left = 26
    Top = 307
    Width = 154
    Height = 39
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
end

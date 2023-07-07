object PhfAddAppliance: TPhfAddAppliance
  Left = 0
  Top = 0
  Caption = 'Add Appliance'
  ClientHeight = 502
  ClientWidth = 712
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object lstAvailableAppliances: TListBox
    Left = 8
    Top = 8
    Width = 529
    Height = 356
    TabOrder = 0
  end
  object btnAdd: TButton
    Left = 32
    Top = 384
    Width = 193
    Height = 49
    Caption = 'Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
end

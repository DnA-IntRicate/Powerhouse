object g_HomeForm: TPhfHome
  Left = 0
  Top = 0
  Caption = 'Powerhouse'
  ClientHeight = 457
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object pnlHomeForm: TPanel
    Left = 8
    Top = 8
    Width = 537
    Height = 441
    TabOrder = 0
    object Label3: TLabel
      Left = 133
      Top = 0
      Width = 250
      Height = 48
      Caption = 'Powerhouse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object tbcHome: TTabControl
      Left = 13
      Top = 54
      Width = 513
      Height = 377
      TabOrder = 0
      Tabs.Strings = (
        'My Appliances'
        'Insights'
        'Calculator'
        'My Account'
        'Help')
      TabIndex = 0
      object lstAppliances: TListBox
        Left = 11
        Top = 40
        Width = 239
        Height = 326
        Items.Strings = (
          'Samsung 303L Fridge')
        TabOrder = 0
      end
      object pnlApplianceInformation: TPanel
        Left = 264
        Top = 40
        Width = 233
        Height = 269
        BorderStyle = bsSingle
        TabOrder = 1
        object Label1: TLabel
          Left = 22
          Top = 0
          Width = 188
          Height = 21
          Caption = 'ApplianceInformation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object btnModifyAppliance: TButton
        Left = 264
        Top = 315
        Width = 233
        Height = 50
        Caption = 'Modify'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
  end
end

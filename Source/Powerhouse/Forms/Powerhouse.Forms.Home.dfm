object PhfHome: TPhfHome
  Left = 0
  Top = 0
  Caption = 'Powerhouse'
  ClientHeight = 519
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 16
  object pnlHomeForm: TPanel
    Left = 8
    Top = 8
    Width = 521
    Height = 505
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
    object pgcHome: TPageControl
      Left = 8
      Top = 54
      Width = 505
      Height = 443
      ActivePage = tabAppliances
      TabOrder = 0
      object tabAppliances: TTabSheet
        Caption = 'My Appliances'
        object btnModifyAppliance: TButton
          Left = 254
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
          TabOrder = 0
        end
        object lstAppliances: TListBox
          Left = 11
          Top = 40
          Width = 239
          Height = 326
          TabOrder = 1
        end
        object pnlApplianceInformation: TPanel
          Left = 254
          Top = 40
          Width = 233
          Height = 269
          BorderStyle = bsSingle
          TabOrder = 2
          object Label1: TLabel
            Left = 22
            Top = 0
            Width = 193
            Height = 21
            Caption = 'Appliance Information'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object btnAddAppliance: TButton
          Left = 11
          Top = 371
          Width = 239
          Height = 38
          Caption = 'Add Appliance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnAddApplianceClick
        end
      end
      object tabInsights: TTabSheet
        Caption = 'Insights'
        ImageIndex = 1
      end
      object tabCalculator: TTabSheet
        Caption = 'Calculator'
        ImageIndex = 2
      end
      object tabAccount: TTabSheet
        Caption = 'My Account'
        ImageIndex = 3
      end
      object tabHelp: TTabSheet
        Caption = 'Help'
        ImageIndex = 4
      end
    end
  end
end

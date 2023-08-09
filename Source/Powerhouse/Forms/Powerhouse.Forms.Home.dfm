object PhfHome: TPhfHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Powerhouse'
  ClientHeight = 415
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 12
  object pnlHomeForm: TPanel
    Left = 6
    Top = 6
    Width = 417
    Height = 404
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 0
    object Label3: TLabel
      Left = 106
      Top = 0
      Width = 197
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Powerhouse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pgcHome: TPageControl
      Left = 6
      Top = 43
      Width = 404
      Height = 355
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      ActivePage = tabAppliances
      TabOrder = 0
      object tabAppliances: TTabSheet
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'My Appliances'
        object btnModifyAppliance: TButton
          Left = 203
          Top = 269
          Width = 187
          Height = 40
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Modify'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object lstAppliances: TListBox
          Left = 9
          Top = 32
          Width = 191
          Height = 261
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ItemHeight = 12
          TabOrder = 1
          OnClick = lstAppliancesClick
          OnMouseDown = lstAppliancesMouseDown
        end
        object pnlApplianceInformation: TPanel
          Left = 203
          Top = 32
          Width = 187
          Height = 233
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          BorderStyle = bsSingle
          TabOrder = 2
          object Label1: TLabel
            Left = 13
            Top = 0
            Width = 154
            Height = 17
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Caption = 'Appliance Information'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation2: TLabel
            Left = 4
            Top = 36
            Width = 64
            Height = 16
            Caption = 'Manufacturer:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblManufacturer: TLabel
            Left = 94
            Top = 36
            Width = 86
            Height = 16
            Alignment = taRightJustify
            Caption = 'MANUFACTURER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceName: TLabel
            Left = 150
            Top = 22
            Width = 30
            Height = 12
            Alignment = taRightJustify
            Caption = 'NAME'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation1: TLabel
            Left = 4
            Top = 22
            Width = 29
            Height = 12
            Caption = 'Name:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblVoltage: TLabel
            Left = 131
            Top = 50
            Width = 49
            Height = 12
            Alignment = taRightJustify
            Caption = 'VOLTAGE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation3: TLabel
            Left = 4
            Top = 50
            Width = 37
            Height = 12
            Caption = 'Voltage:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblAmperage: TLabel
            Left = 122
            Top = 63
            Width = 58
            Height = 12
            Alignment = taRightJustify
            Caption = 'AMPERAGE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation4: TLabel
            Left = 4
            Top = 63
            Width = 50
            Height = 12
            Caption = 'Amperage:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblActivePowerConsumption: TLabel
            Left = 102
            Top = 78
            Width = 78
            Height = 12
            Alignment = taRightJustify
            Caption = 'ACTIVEPOWER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation5: TLabel
            Left = 4
            Top = 78
            Width = 64
            Height = 12
            Caption = 'Active Power:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblInputPower: TLabel
            Left = 109
            Top = 93
            Width = 71
            Height = 11
            Alignment = taRightJustify
            Caption = 'INPUTPOWER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation6: TLabel
            Left = 4
            Top = 93
            Width = 61
            Height = 11
            Caption = 'Input Power:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblOutputPower: TLabel
            Left = 99
            Top = 107
            Width = 81
            Height = 12
            Alignment = taRightJustify
            Caption = 'OUTPUTPOWER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation7: TLabel
            Left = 4
            Top = 107
            Width = 68
            Height = 12
            Caption = 'Output Power:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblStandbyPowerConsumption: TLabel
            Left = 92
            Top = 122
            Width = 88
            Height = 12
            Alignment = taRightJustify
            Caption = 'STANDBYPOWER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation8: TLabel
            Left = 4
            Top = 122
            Width = 74
            Height = 12
            Caption = 'Standby Power:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblPowerFactor: TLabel
            Left = 99
            Top = 137
            Width = 81
            Height = 12
            Alignment = taRightJustify
            Caption = 'POWERFACTOR'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation9: TLabel
            Left = 4
            Top = 137
            Width = 65
            Height = 12
            Caption = 'Power Factor:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblFrequency: TLabel
            Left = 119
            Top = 151
            Width = 61
            Height = 12
            Alignment = taRightJustify
            Caption = 'FREQUENCY'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation10: TLabel
            Left = 4
            Top = 151
            Width = 53
            Height = 12
            Caption = 'Frequency:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblEnergyEfficiencyRating: TLabel
            Left = 99
            Top = 166
            Width = 81
            Height = 12
            Alignment = taRightJustify
            Caption = 'ENERGYRATING'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation11: TLabel
            Left = 4
            Top = 166
            Width = 68
            Height = 12
            Caption = 'Energy Rating:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblSurgeProtection: TLabel
            Left = 111
            Top = 181
            Width = 69
            Height = 12
            Alignment = taRightJustify
            Caption = 'PROTECTION'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation12: TLabel
            Left = 4
            Top = 181
            Width = 80
            Height = 12
            Caption = 'Surge Protection:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblApplianceInformation13: TLabel
            Left = 4
            Top = 196
            Width = 56
            Height = 12
            Caption = 'Battery Size:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblBatterySize: TLabel
            Left = 108
            Top = 196
            Width = 72
            Height = 12
            Alignment = taRightJustify
            Caption = 'BATTERYSIZE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblApplianceInformation14: TLabel
            Left = 4
            Top = 211
            Width = 59
            Height = 12
            Caption = 'Battery Kind:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblBatteryKind: TLabel
            Left = 104
            Top = 211
            Width = 76
            Height = 12
            Alignment = taRightJustify
            Caption = 'BATTERYKIND'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object btnAddAppliance: TButton
          Left = 9
          Top = 297
          Width = 191
          Height = 30
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Add Appliance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnAddApplianceClick
        end
      end
      object tabInsights: TTabSheet
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Insights'
        ImageIndex = 1
      end
      object tabCalculator: TTabSheet
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Calculator'
        ImageIndex = 2
      end
      object tabAccount: TTabSheet
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'My Account'
        ImageIndex = 3
      end
      object tabHelp: TTabSheet
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Help'
        ImageIndex = 4
      end
    end
  end
end

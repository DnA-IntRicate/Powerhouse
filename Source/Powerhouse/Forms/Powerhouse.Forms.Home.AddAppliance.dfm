object PhfAddAppliance: TPhfAddAppliance
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Add Appliance'
  ClientHeight = 380
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 12
  object pnlAddAppliance: TPanel
    Left = -4
    Top = 8
    Width = 409
    Height = 369
    TabOrder = 0
    object Label1: TLabel
      Left = 87
      Top = 0
      Width = 186
      Height = 31
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Add Appliance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -26
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 10
      Top = 43
      Width = 123
      Height = 16
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Existing Appliances'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCreateNewAppliance: TLabel
      Left = 47
      Top = 300
      Width = 113
      Height = 12
      Cursor = crHandPoint
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Create a new appliance...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblCreateNewApplianceClick
    end
    object btnAdd: TButton
      Left = 10
      Top = 316
      Width = 287
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Add'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnAddClick
    end
    object lstAvailableAppliances: TListBox
      Left = 9
      Top = 63
      Width = 191
      Height = 233
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      ItemHeight = 12
      TabOrder = 1
      OnClick = lstAvailableAppliancesClick
      OnDblClick = lstAvailableAppliancesDblClick
      OnMouseDown = lstAvailableAppliancesMouseDown
    end
    object pnlApplianceInformation: TPanel
      Left = 211
      Top = 63
      Width = 187
      Height = 233
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      BorderStyle = bsSingle
      TabOrder = 2
      object Label3: TLabel
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
        Height = 12
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
        Height = 12
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
        Height = 12
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
        Height = 12
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
    object btnCancel: TButton
      Left = 301
      Top = 316
      Width = 97
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
end

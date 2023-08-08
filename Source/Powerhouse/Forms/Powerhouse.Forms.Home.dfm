object PhfHome: TPhfHome
  Left = 0
  Top = 0
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
          Top = 252
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
        end
        object pnlApplianceInformation: TPanel
          Left = 203
          Top = 32
          Width = 187
          Height = 215
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          BorderStyle = bsSingle
          TabOrder = 2
          object Label1: TLabel
            Left = 18
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

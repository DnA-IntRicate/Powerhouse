object PhfLogin: TPhfLogin
  Left = 0
  Top = 0
  Caption = 'Powerhouse'
  ClientHeight = 245
  ClientWidth = 479
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
  object pnlLogin: TPanel
    Left = 8
    Top = 8
    Width = 465
    Height = 233
    TabOrder = 0
    object Label1: TLabel
      Left = 61
      Top = 67
      Width = 63
      Height = 16
      Caption = 'Username:'
    end
    object Label2: TLabel
      Left = 64
      Top = 97
      Width = 60
      Height = 16
      Caption = 'Password:'
    end
    object Label3: TLabel
      Left = 29
      Top = 8
      Width = 410
      Height = 40
      Caption = 'Welcome to Powerhouse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtUsername: TEdit
      Left = 130
      Top = 64
      Width = 241
      Height = 24
      TabOrder = 0
      TextHint = 'Enter username or email address...'
    end
    object edtPassword: TEdit
      Left = 130
      Top = 94
      Width = 241
      Height = 24
      TabOrder = 1
      TextHint = 'Enter password...'
    end
    object lnkForgotPassword: TLinkLabel
      Left = 176
      Top = 124
      Width = 106
      Height = 20
      Caption = 'Forgot Password?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      TabOrder = 2
    end
    object btnLogin: TButton
      Left = 130
      Top = 150
      Width = 193
      Height = 57
      Caption = 'Login'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
end

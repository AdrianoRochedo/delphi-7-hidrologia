object PasswordDlg: TPasswordDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = ' Propagar'
  ClientHeight = 126
  ClientWidth = 262
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 49
    Width = 92
    Height = 13
    Caption = 'Entre com a senha:'
  end
  object Bevel1: TBevel
    Left = 9
    Top = 42
    Width = 242
    Height = 6
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 8
    Top = 6
    Width = 167
    Height = 13
    Caption = 'Este programa esta registrado para:'
  end
  object L_Reg: TLabel
    Left = 8
    Top = 22
    Width = 38
    Height = 13
    Caption = 'Mister X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edSenha: TEdit
    Left = 8
    Top = 63
    Width = 244
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 97
    Top = 93
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 177
    Top = 93
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end

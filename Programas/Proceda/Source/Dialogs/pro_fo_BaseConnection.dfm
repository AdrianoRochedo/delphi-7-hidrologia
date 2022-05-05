object foBaseConnection: TfoBaseConnection
  Left = 220
  Top = 124
  BorderStyle = bsDialog
  Caption = ' Conec'#231#227'o'
  ClientHeight = 91
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Banco de Dados:'
  end
  object Bevel1: TBevel
    Left = 6
    Top = 47
    Width = 462
    Height = 6
    Shape = bsBottomLine
  end
  object edID: TdrEdit
    Left = 5
    Top = 21
    Width = 465
    Height = 21
    BeepOnError = False
    DataType = dtString
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 255
    Top = 61
    Width = 105
    Height = 24
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 364
    Top = 61
    Width = 105
    Height = 24
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end

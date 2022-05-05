object iphs1_Form_Dialogo_SB_TCV_PEB: Tiphs1_Form_Dialogo_SB_TCV_PEB
  Left = 253
  Top = 152
  BorderStyle = bsToolWindow
  Caption = 'PEB'
  ClientHeight = 87
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 4
    Top = 57
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 82
    Top = 57
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 3
  end
  object Panel6: TPanel
    Left = 4
    Top = 6
    Width = 192
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Par. do Res. Linear Simples (horas):'
    TabOrder = 4
  end
  object edPR: TdrEdit
    Left = 196
    Top = 6
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 0
  end
  object Panel7: TPanel
    Left = 4
    Top = 28
    Width = 192
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o Base Inicial (m'#179'/s):'
    TabOrder = 5
  end
  object edVB: TdrEdit
    Left = 196
    Top = 28
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 1
  end
end

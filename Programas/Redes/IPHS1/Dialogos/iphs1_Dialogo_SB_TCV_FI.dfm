object iphs1_Form_Dialogo_SB_TCV_FI: Tiphs1_Form_Dialogo_SB_TCV_FI
  Left = 241
  Top = 140
  Width = 185
  Height = 112
  BorderStyle = bsSizeToolWin
  Caption = 'FI'
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
    Top = 56
    Width = 82
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 89
    Top = 56
    Width = 82
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 4
    Top = 6
    Width = 101
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Perda inicial (mm):'
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 4
    Top = 28
    Width = 101
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' '#205'ndice FI (mm/h):'
    TabOrder = 5
  end
  object edPI: TdrEdit
    Left = 106
    Top = 6
    Width = 65
    Height = 22
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 0
  end
  object edI: TdrEdit
    Left = 106
    Top = 28
    Width = 65
    Height = 22
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 1
  end
end

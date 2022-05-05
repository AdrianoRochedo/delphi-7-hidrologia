object iphs1_Form_Dialogo_SB_TCV_IPHII: Tiphs1_Form_Dialogo_SB_TCV_IPHII
  Left = 253
  Top = 159
  BorderStyle = bsToolWindow
  Caption = ' IPH II'
  ClientHeight = 108
  ClientWidth = 386
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
    Top = 78
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 82
    Top = 78
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 7
  end
  object Panel2: TPanel
    Left = 4
    Top = 6
    Width = 78
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' IO (mm/hora):'
    TabOrder = 8
  end
  object edIO: TdrEdit
    Left = 82
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
  object Panel1: TPanel
    Left = 147
    Top = 6
    Width = 76
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' IB (mm/hora):'
    TabOrder = 9
  end
  object edIB: TdrEdit
    Left = 223
    Top = 6
    Width = 70
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 1
  end
  object Panel4: TPanel
    Left = 294
    Top = 6
    Width = 22
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' H:'
    TabOrder = 10
  end
  object edH: TdrEdit
    Left = 316
    Top = 6
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 4
    Top = 28
    Width = 78
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' RMAX (mm): '
    TabOrder = 11
  end
  object edRMax: TdrEdit
    Left = 82
    Top = 28
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 5
  end
  object Panel6: TPanel
    Left = 4
    Top = 50
    Width = 312
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o de Base Espec'#237'fica no In'#237'cio da Chuva (m'#179'/s/km'#178'):'
    TabOrder = 12
  end
  object edVB: TdrEdit
    Left = 316
    Top = 50
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 3
  end
  object Panel5: TPanel
    Left = 147
    Top = 28
    Width = 169
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' % da '#193'rea Imperme'#225'vel:'
    TabOrder = 13
  end
  object edPAI: TdrEdit
    Left = 316
    Top = 28
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 4
  end
end

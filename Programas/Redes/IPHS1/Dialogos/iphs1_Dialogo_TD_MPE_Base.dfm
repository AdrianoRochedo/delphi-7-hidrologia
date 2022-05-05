object iphs1_Form_Dialogo_TD_MPE_Base: Tiphs1_Form_Dialogo_TD_MPE_Base
  Left = 244
  Top = 88
  BorderStyle = bsDialog
  Caption = 'iphs1_Form_Dialogo_TD_MPE_Base'
  ClientHeight = 241
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TBitBtn
    Left = 7
    Top = 209
    Width = 89
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 18
  end
  object btnCancelar: TBitBtn
    Left = 99
    Top = 209
    Width = 89
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 19
  end
  object p5: TPanel
    Left = 7
    Top = 94
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Largura do Canal (m):'
    TabOrder = 8
  end
  object p1: TPanel
    Left = 7
    Top = 10
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Comprimento do Trecho de Propaga'#231#227'o (m):'
    TabOrder = 0
  end
  object p9: TPanel
    Left = 7
    Top = 178
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Intervalo de Tempo de C'#225'lculo (seg):'
    TabOrder = 16
    TabStop = True
    object cbITC: TCheckBox
      Left = 198
      Top = 2
      Width = 45
      Height = 17
      Caption = 'Auto'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbITCClick
    end
  end
  object p8: TPanel
    Left = 7
    Top = 157
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' N'#250'mero de Sub-Trechos:'
    TabOrder = 14
    TabStop = True
    object cbNST: TCheckBox
      Left = 198
      Top = 2
      Width = 45
      Height = 17
      Caption = 'Auto'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbNSTClick
    end
  end
  object p6: TPanel
    Left = 7
    Top = 115
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rugosidade dos Sub-Trechos:'
    TabOrder = 10
  end
  object edLC: TdrEdit
    Left = 255
    Top = 94
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 9
  end
  object edCTP: TdrEdit
    Left = 255
    Top = 10
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 1
  end
  object edITC: TdrEdit
    Left = 255
    Top = 178
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtInteger
    Enabled = False
    MaxLength = 5
    TabOrder = 17
    Text = '0'
  end
  object edNST: TdrEdit
    Left = 255
    Top = 157
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtInteger
    Enabled = False
    MaxLength = 5
    TabOrder = 15
    Text = '0'
  end
  object edRST: TdrEdit
    Left = 255
    Top = 115
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 11
  end
  object p3: TPanel
    Left = 7
    Top = 52
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Cota de Fundo de Jusante (m)'
    TabOrder = 4
  end
  object p7: TPanel
    Left = 7
    Top = 136
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o de Refer'#234'ncia (m'#179'/s):'
    TabOrder = 12
    TabStop = True
    object cbVR: TCheckBox
      Left = 198
      Top = 2
      Width = 45
      Height = 17
      Caption = 'Auto'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbVRClick
    end
  end
  object edCFJ: TdrEdit
    Left = 255
    Top = 52
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 5
  end
  object edVR: TdrEdit
    Left = 255
    Top = 136
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    Enabled = False
    MaxLength = 10
    TabOrder = 13
    Text = '0'
  end
  object p2: TPanel
    Left = 7
    Top = 31
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Cota de Fundo de Montante (m)'
    TabOrder = 2
  end
  object edCFM: TdrEdit
    Left = 255
    Top = 31
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 3
  end
  object p4: TPanel
    Left = 7
    Top = 73
    Width = 248
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Altura do Canal (m)'
    TabOrder = 6
  end
  object edAC: TdrEdit
    Left = 255
    Top = 73
    Width = 67
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 7
  end
end

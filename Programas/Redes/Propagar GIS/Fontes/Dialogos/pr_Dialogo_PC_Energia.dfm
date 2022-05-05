object prDialogo_PC_Energia: TprDialogo_PC_Energia
  Left = 211
  Top = 224
  Width = 340
  Height = 246
  Caption = 'prDialogo_PC_Energia'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel7: TPanel
    Left = 6
    Top = 8
    Width = 236
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento do Sistema de Adu'#231#227'o:'
    TabOrder = 5
  end
  object edRSA: TdrEdit
    Left = 242
    Top = 8
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 6
    Top = 29
    Width = 236
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento das Turbinas:'
    TabOrder = 6
  end
  object edRT: TdrEdit
    Left = 242
    Top = 29
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 6
    Top = 50
    Width = 236
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento dos Geradores:'
    TabOrder = 7
  end
  object edRG: TdrEdit
    Left = 242
    Top = 50
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 6
    Top = 71
    Width = 236
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o M'#225'xima Turbin'#225'vel: (m'#179'/s)'
    TabOrder = 8
  end
  object edVMT: TdrEdit
    Left = 242
    Top = 71
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 3
  end
  object Panel4: TPanel
    Left = 6
    Top = 92
    Width = 236
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Queda Hidr'#225'ulica: (m)'
    TabOrder = 9
  end
  object edX: TdrEdit
    Left = 242
    Top = 92
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 4
  end
  object Painel: TPanel
    Left = 6
    Top = 113
    Width = 323
    Height = 98
    BevelOuter = bvNone
    TabOrder = 10
    object btnACDE: TSpeedButton
      Left = 292
      Top = 21
      Width = 26
      Height = 22
      Caption = '...'
      OnClick = btnACDEClick
    end
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 236
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Demanda Energ'#233'tica: (KWh)'
      TabOrder = 3
    end
    object edDE: TdrEdit
      Left = 236
      Top = 0
      Width = 83
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 0
    end
    object Panel6: TPanel
      Left = 0
      Top = 21
      Width = 291
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Arquivo com a  Curva de Demanda Energ'#233'tica:'
      TabOrder = 4
    end
    object edACDE: TdrEdit
      Left = 0
      Top = 42
      Width = 319
      Height = 21
      BeepOnError = False
      DataType = dtString
      TabOrder = 1
    end
    object btnOk: TBitBtn
      Left = 1
      Top = 73
      Width = 113
      Height = 25
      Caption = '&Ok'
      ModalResult = 1
      TabOrder = 2
    end
  end
end

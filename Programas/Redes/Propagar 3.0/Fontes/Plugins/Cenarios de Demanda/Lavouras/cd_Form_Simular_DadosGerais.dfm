object foSimular_DadosGerais: TfoSimular_DadosGerais
  Left = 127
  Top = 0
  BorderStyle = bsDialog
  Caption = ' Dados Gerais'
  ClientHeight = 501
  ClientWidth = 663
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edAnos: TEdit
    Left = 4
    Top = 54
    Width = 324
    Height = 21
    TabOrder = 0
    OnExit = edAnosExit
  end
  object Panel9: TPanel
    Left = 5
    Top = 33
    Width = 323
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Intervalo de Simula'#231#227'o: (anos)'
    TabOrder = 34
  end
  object Panel10: TPanel
    Left = 334
    Top = 299
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento da Cultura n'#227'o Irrigada:'
    TabOrder = 35
  end
  object sgRCNI: TdrStringAlignGrid
    Left = 334
    Top = 319
    Width = 324
    Height = 38
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    PopupMenu = Menu_Grade
    ScrollBars = ssNone
    TabOrder = 16
    Alignment = alCenter
  end
  object Panel11: TPanel
    Left = 334
    Top = 356
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento da Cultura Irrigada:'
    TabOrder = 19
  end
  object sgRCI: TdrStringAlignGrid
    Left = 334
    Top = 376
    Width = 324
    Height = 37
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    PopupMenu = Menu_Grade
    ScrollBars = ssNone
    TabOrder = 17
    Alignment = alCenter
  end
  object Panel1: TPanel
    Left = 334
    Top = 101
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Lavoura:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 20
  end
  object Panel2: TPanel
    Left = 334
    Top = 128
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento Potencial Local Calculado: ( Fao - M'#233'todo Z.A )'
    TabOrder = 23
  end
  object sgRPLC: TdrStringAlignGrid
    Left = 334
    Top = 148
    Width = 324
    Height = 38
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    PopupMenu = Menu_Grade
    ScrollBars = ssNone
    TabOrder = 13
    Alignment = alCenter
  end
  object Panel3: TPanel
    Left = 334
    Top = 185
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Valor do Produto no Mercado: ($/ha)'
    TabOrder = 28
  end
  object sgVPM: TdrStringAlignGrid
    Left = 334
    Top = 205
    Width = 324
    Height = 38
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    PopupMenu = Menu_Grade
    ScrollBars = ssNone
    TabOrder = 14
    Alignment = alCenter
  end
  object Panel4: TPanel
    Left = 334
    Top = 242
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Valor da Produ'#231#227'o Agropecu'#225'ria:'
    TabOrder = 29
  end
  object sgVPA: TdrStringAlignGrid
    Left = 334
    Top = 262
    Width = 324
    Height = 37
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    PopupMenu = Menu_Grade
    ScrollBars = ssNone
    TabOrder = 15
    Alignment = alCenter
  end
  object Panel5: TPanel
    Left = 4
    Top = 80
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Informa'#231#245'es Locais:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 30
  end
  object edLat: TdrEdit
    Left = 4
    Top = 128
    Width = 67
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 1
  end
  object Panel6: TPanel
    Left = 4
    Top = 107
    Width = 67
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Latitude:'
    TabOrder = 31
  end
  object edLon: TdrEdit
    Left = 70
    Top = 128
    Width = 68
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 2
  end
  object Panel7: TPanel
    Left = 71
    Top = 107
    Width = 67
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Longitude:'
    TabOrder = 32
  end
  object edAlt: TdrEdit
    Left = 137
    Top = 128
    Width = 68
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 3
  end
  object Panel8: TPanel
    Left = 138
    Top = 107
    Width = 67
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Altitude:'
    TabOrder = 33
  end
  object Panel12: TPanel
    Left = 205
    Top = 107
    Width = 123
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Altura do Anem'#244'metro:'
    TabOrder = 36
  end
  object edAn: TdrEdit
    Left = 204
    Top = 128
    Width = 124
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 4
  end
  object Panel13: TPanel
    Left = 4
    Top = 265
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tend'#234'ncias de Tempo e Clima: '
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 37
  end
  object Panel14: TPanel
    Left = 5
    Top = 292
    Width = 323
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tempo da Pr'#243'xima Semana:'
    TabOrder = 38
  end
  object Panel15: TPanel
    Left = 5
    Top = 313
    Width = 323
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 6
    object rbSemChuva: TRadioButton
      Left = 18
      Top = 4
      Width = 113
      Height = 16
      Caption = 'Sem chuva'
      TabOrder = 0
    end
    object rbComChuva: TRadioButton
      Left = 115
      Top = 4
      Width = 113
      Height = 16
      Caption = 'Com chuva'
      TabOrder = 1
    end
  end
  object Panel16: TPanel
    Left = 5
    Top = 335
    Width = 323
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Clima dos Pr'#243'ximos Meses:'
    TabOrder = 39
  end
  object Panel17: TPanel
    Left = 5
    Top = 356
    Width = 323
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 7
    object rbSeco: TRadioButton
      Left = 18
      Top = 4
      Width = 113
      Height = 16
      Caption = 'Seco'
      TabOrder = 0
    end
    object rbMedio: TRadioButton
      Left = 115
      Top = 4
      Width = 113
      Height = 16
      Caption = 'M'#233'dio'
      TabOrder = 1
    end
    object rbUmido: TRadioButton
      Left = 211
      Top = 4
      Width = 100
      Height = 16
      Caption = #218'mido'
      TabOrder = 2
    end
  end
  object Panel18: TPanel
    Left = 5
    Top = 384
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tecnologia de Irriga'#231#227'o:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 40
  end
  object Panel19: TPanel
    Left = 5
    Top = 411
    Width = 125
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Sistema:'
    TabOrder = 41
  end
  object cbSistema: TComboBox
    Left = 5
    Top = 432
    Width = 126
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    OnChange = cbSistemaChange
    Items.Strings = (
      'Localizada'
      'Aspers'#227'o'
      'Sulcos'
      'Inunda'#231#227'o')
  end
  object Panel20: TPanel
    Left = 5
    Top = 453
    Width = 323
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Crit'#233'rio de Manejo:'
    TabOrder = 42
  end
  object Panel21: TPanel
    Left = 5
    Top = 474
    Width = 323
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 9
    object rbNatureza: TRadioButton
      Left = 18
      Top = 4
      Width = 85
      Height = 16
      Caption = ' Natureza'
      TabOrder = 0
    end
    object rbProdMax: TRadioButton
      Left = 115
      Top = 4
      Width = 113
      Height = 16
      Caption = 'Prod. M'#225'x.'
      TabOrder = 1
    end
    object rbComDef: TRadioButton
      Left = 211
      Top = 4
      Width = 100
      Height = 16
      Caption = 'Com Deficit'
      TabOrder = 2
    end
  end
  object Panel22: TPanel
    Left = 5
    Top = 6
    Width = 323
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Geral:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 43
  end
  object Panel23: TPanel
    Left = 334
    Top = 33
    Width = 262
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' '#193'rea a Irrigar/dia: (ha)'
    TabOrder = 44
  end
  object Panel24: TPanel
    Left = 334
    Top = 6
    Width = 324
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Projeto:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 45
  end
  object Panel25: TPanel
    Left = 334
    Top = 54
    Width = 262
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Intervalos de Irriga'#231#227'o: (dias)'
    TabOrder = 46
  end
  object Panel26: TPanel
    Left = 334
    Top = 75
    Width = 262
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' N'#250'mero de Horas de Opera'#231#227'o/dia:'
    TabOrder = 47
  end
  object btnOk: TButton
    Left = 508
    Top = 474
    Width = 151
    Height = 23
    Caption = 'Ok'
    TabOrder = 18
    OnClick = btnOkClick
  end
  object edArea: TdrEdit
    Left = 597
    Top = 32
    Width = 61
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 10
  end
  object edInt: TdrEdit
    Left = 597
    Top = 53
    Width = 61
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 11
  end
  object edHorasOper: TdrEdit
    Left = 597
    Top = 74
    Width = 61
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 12
  end
  object edEf: TdrEdit
    Left = 129
    Top = 432
    Width = 68
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtFloat
    Color = clSilver
    ReadOnly = True
    TabOrder = 21
  end
  object Panel27: TPanel
    Left = 130
    Top = 411
    Width = 67
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Efici'#234'ncia:'
    TabOrder = 48
  end
  object Panel28: TPanel
    Left = 197
    Top = 411
    Width = 131
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Custo por Hectar:'
    TabOrder = 49
  end
  object edCusto: TdrEdit
    Left = 196
    Top = 432
    Width = 132
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtInteger
    Color = clSilver
    ReadOnly = True
    TabOrder = 22
  end
  object Panel29: TPanel
    Left = 4
    Top = 154
    Width = 324
    Height = 21
    Hint = 'FAO, 1995 and Dunde, 1990'
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Conte'#250'do Nutricional dos Alimentos'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 50
  end
  object Panel30: TPanel
    Left = 4
    Top = 176
    Width = 219
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Alimento:'
    TabOrder = 51
  end
  object cbAlimentos: TComboBox
    Left = 4
    Top = 197
    Width = 220
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbAlimentosChange
    Items.Strings = (
      'Localizada'
      'Aspers'#227'o'
      'Sulcos'
      'Inunda'#231#227'o')
  end
  object edCalorias: TdrEdit
    Left = 223
    Top = 197
    Width = 105
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtFloat
    Color = clSilver
    ReadOnly = True
    TabOrder = 24
  end
  object Panel31: TPanel
    Left = 224
    Top = 176
    Width = 104
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Calorias:'
    TabOrder = 52
  end
  object Panel32: TPanel
    Left = 4
    Top = 218
    Width = 108
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Prote'#237'nas:'
    TabOrder = 53
  end
  object edProt: TdrEdit
    Left = 3
    Top = 239
    Width = 109
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtInteger
    Color = clSilver
    ReadOnly = True
    TabOrder = 25
  end
  object Panel33: TPanel
    Left = 113
    Top = 218
    Width = 109
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Gorduras:'
    TabOrder = 54
  end
  object edGord: TdrEdit
    Left = 112
    Top = 239
    Width = 110
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtInteger
    Color = clSilver
    ReadOnly = True
    TabOrder = 26
  end
  object Panel34: TPanel
    Left = 222
    Top = 218
    Width = 106
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' C'#225'lcio:'
    TabOrder = 55
  end
  object edCalcio: TdrEdit
    Left = 221
    Top = 239
    Width = 107
    Height = 21
    TabStop = False
    BeepOnError = False
    DataType = dtFloat
    Color = clSilver
    ReadOnly = True
    TabOrder = 27
  end
  object Menu_Grade: TPopupMenu
    OnPopup = Menu_GradePopup
    Left = 592
    Top = 209
    object Menu_PreencherValor: TMenuItem
      Caption = 'Preencher Valores ...'
      OnClick = Menu_PreencherValorClick
    end
  end
end

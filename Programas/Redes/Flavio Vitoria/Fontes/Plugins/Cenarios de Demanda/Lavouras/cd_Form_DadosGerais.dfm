object foDadosGerais: TfoDadosGerais
  Left = 73
  Top = 21
  BorderStyle = bsDialog
  Caption = ' General Data'
  ClientHeight = 416
  ClientWidth = 683
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
  object Book: TPageControl
    Left = 0
    Top = 0
    Width = 683
    Height = 382
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Agricultural Scenario'
      object Panel5: TPanel
        Left = 9
        Top = 10
        Width = 323
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Local Information:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object edLat: TdrEdit
        Left = 9
        Top = 53
        Width = 67
        Height = 21
        BeepOnError = False
        DataType = dtInteger
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 9
        Top = 32
        Width = 67
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Latitude:'
        TabOrder = 2
      end
      object edLon: TdrEdit
        Left = 75
        Top = 53
        Width = 68
        Height = 21
        BeepOnError = False
        DataType = dtInteger
        TabOrder = 3
      end
      object Panel7: TPanel
        Left = 76
        Top = 32
        Width = 67
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Longitude:'
        TabOrder = 4
      end
      object edAlt: TdrEdit
        Left = 142
        Top = 53
        Width = 68
        Height = 21
        BeepOnError = False
        DataType = dtInteger
        TabOrder = 5
      end
      object Panel8: TPanel
        Left = 143
        Top = 32
        Width = 67
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Altitude:'
        TabOrder = 6
      end
      object Panel12: TPanel
        Left = 210
        Top = 32
        Width = 122
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Anemometer Height:'
        TabOrder = 7
      end
      object edAn: TdrEdit
        Left = 209
        Top = 53
        Width = 123
        Height = 21
        BeepOnError = False
        DataType = dtInteger
        TabOrder = 8
      end
      object Panel29: TPanel
        Left = 9
        Top = 81
        Width = 323
        Height = 21
        Hint = 'FAO, 1995 and Dunde, 1990'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Crop and Food Nutritional Content'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object Panel30: TPanel
        Left = 9
        Top = 103
        Width = 219
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Crop:'
        TabOrder = 10
      end
      object cbAlimentos: TComboBox
        Left = 9
        Top = 124
        Width = 220
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 11
        OnChange = cbAlimentosChange
        Items.Strings = (
          'Localizada'
          'Aspers'#227'o'
          'Sulcos'
          'Inunda'#231#227'o')
      end
      object edCalorias: TdrEdit
        Left = 228
        Top = 124
        Width = 104
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtFloat
        Color = clSilver
        ReadOnly = True
        TabOrder = 12
      end
      object Panel31: TPanel
        Left = 229
        Top = 103
        Width = 103
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Calories:'
        TabOrder = 13
      end
      object Panel32: TPanel
        Left = 9
        Top = 145
        Width = 107
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Protein:'
        TabOrder = 14
      end
      object edProt: TdrEdit
        Left = 8
        Top = 166
        Width = 108
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtInteger
        Color = clSilver
        ReadOnly = True
        TabOrder = 15
      end
      object Panel33: TPanel
        Left = 118
        Top = 145
        Width = 110
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Fat:'
        TabOrder = 16
      end
      object edGord: TdrEdit
        Left = 117
        Top = 166
        Width = 111
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtInteger
        Color = clSilver
        ReadOnly = True
        TabOrder = 17
      end
      object Panel34: TPanel
        Left = 229
        Top = 145
        Width = 103
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Calcium:'
        TabOrder = 18
      end
      object edCalcio: TdrEdit
        Left = 228
        Top = 166
        Width = 104
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtFloat
        Color = clSilver
        ReadOnly = True
        TabOrder = 19
      end
      object Panel18: TPanel
        Left = 8
        Top = 195
        Width = 324
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Irrigation System:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 20
      end
      object Panel19: TPanel
        Left = 8
        Top = 217
        Width = 256
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' System:'
        TabOrder = 21
      end
      object cbSistema: TComboBox
        Left = 8
        Top = 238
        Width = 257
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 22
        OnChange = cbSistemaChange
        Items.Strings = (
          'Localizada'
          'Aspers'#227'o'
          'Sulcos'
          'Inunda'#231#227'o')
      end
      object Panel20: TPanel
        Left = 8
        Top = 302
        Width = 324
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Management Criterion:'
        TabOrder = 23
      end
      object Panel21: TPanel
        Left = 8
        Top = 323
        Width = 324
        Height = 22
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 24
        object rbNatureza: TRadioButton
          Left = 18
          Top = 4
          Width = 85
          Height = 16
          Caption = ' Nature'
          TabOrder = 0
        end
        object rbProdMax: TRadioButton
          Left = 114
          Top = 4
          Width = 90
          Height = 16
          Caption = 'Maximal Yield'
          TabOrder = 1
        end
        object rbComDef: TRadioButton
          Left = 210
          Top = 4
          Width = 85
          Height = 16
          Caption = 'With Deficit'
          TabOrder = 2
        end
      end
      object edEf: TdrEdit
        Left = 264
        Top = 238
        Width = 68
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtString
        Color = clSilver
        ReadOnly = True
        TabOrder = 25
      end
      object Panel27: TPanel
        Left = 265
        Top = 217
        Width = 67
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Efficiency:'
        TabOrder = 26
      end
      object Panel28: TPanel
        Left = 8
        Top = 259
        Width = 156
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Installation Cost: ($/ha)'
        TabOrder = 27
      end
      object edCustoInst: TdrEdit
        Left = 7
        Top = 280
        Width = 157
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtString
        Color = clSilver
        ReadOnly = True
        TabOrder = 28
      end
      object Panel23: TPanel
        Left = 339
        Top = 53
        Width = 262
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Irrigated Area per Day: (ha)'
        TabOrder = 30
      end
      object Panel24: TPanel
        Left = 339
        Top = 10
        Width = 324
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Project Estimate:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 31
      end
      object Panel25: TPanel
        Left = 339
        Top = 74
        Width = 262
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Irrigation Frequency: (days)'
        TabOrder = 32
      end
      object Panel26: TPanel
        Left = 339
        Top = 95
        Width = 262
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Operation Hours per Day:'
        TabOrder = 33
      end
      object edArea: TdrEdit
        Left = 602
        Top = 53
        Width = 61
        Height = 21
        Hint = ' Value > 0 '
        BeepOnError = False
        DataType = dtFloat
        ParentShowHint = False
        ShowHint = True
        TabOrder = 35
      end
      object edInt: TdrEdit
        Left = 602
        Top = 74
        Width = 61
        Height = 21
        Hint = ' Value <> 1 '
        BeepOnError = False
        DataType = dtInteger
        ParentShowHint = False
        ShowHint = True
        TabOrder = 36
      end
      object edHorasOper: TdrEdit
        Left = 602
        Top = 95
        Width = 61
        Height = 21
        Hint = ' Value > 0 '
        BeepOnError = False
        DataType = dtInteger
        ParentShowHint = False
        ShowHint = True
        TabOrder = 37
      end
      object Panel45: TPanel
        Left = 165
        Top = 259
        Width = 167
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Maintenance Cost: ($/ha)'
        TabOrder = 38
      end
      object edCustoMan: TdrEdit
        Left = 164
        Top = 280
        Width = 168
        Height = 21
        TabStop = False
        BeepOnError = False
        DataType = dtString
        Color = clSilver
        ReadOnly = True
        TabOrder = 29
      end
      object Panel46: TPanel
        Left = 339
        Top = 32
        Width = 262
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Project Likelihood Level: (%)'
        TabOrder = 39
      end
      object edProb: TdrEdit
        Left = 602
        Top = 32
        Width = 61
        Height = 21
        Hint = ' Value > 0 '
        BeepOnError = False
        DataType = dtFloat
        ParentShowHint = False
        ShowHint = True
        TabOrder = 34
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Simulation of Management'
      ImageIndex = 1
      object sb2: TSpeedButton
        Tag = 1
        Left = 637
        Top = 133
        Width = 24
        Height = 20
        Caption = '...'
        OnClick = Arquivos_Click
      end
      object sb3: TSpeedButton
        Tag = 2
        Left = 637
        Top = 174
        Width = 24
        Height = 20
        Caption = '...'
        OnClick = Arquivos_Click
      end
      object sb4: TSpeedButton
        Tag = 3
        Left = 637
        Top = 217
        Width = 24
        Height = 20
        Caption = '...'
        OnClick = Arquivos_Click
      end
      object sb5: TSpeedButton
        Tag = 4
        Left = 637
        Top = 257
        Width = 24
        Height = 20
        Caption = '...'
        OnClick = Arquivos_Click
      end
      object sb6: TSpeedButton
        Tag = 5
        Left = 637
        Top = 298
        Width = 24
        Height = 20
        Caption = '...'
        OnClick = Arquivos_Click
      end
      object edAnos: TEdit
        Left = 9
        Top = 55
        Width = 157
        Height = 21
        TabOrder = 0
        OnExit = edAnosExit
      end
      object Panel9: TPanel
        Left = 9
        Top = 34
        Width = 156
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Interval of Simulation: (years)'
        TabOrder = 2
      end
      object Panel22: TPanel
        Left = 9
        Top = 12
        Width = 653
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' General:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object edC: TEdit
        Left = 9
        Top = 132
        Width = 628
        Height = 21
        TabOrder = 4
      end
      object Panel37: TPanel
        Left = 9
        Top = 111
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Crop File (*.cul)'
        TabOrder = 5
      end
      object edS: TEdit
        Left = 9
        Top = 174
        Width = 628
        Height = 21
        TabOrder = 6
      end
      object Panel38: TPanel
        Left = 9
        Top = 153
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Soil File (*.sol)'
        TabOrder = 7
      end
      object edP: TEdit
        Left = 9
        Top = 216
        Width = 628
        Height = 21
        TabOrder = 8
      end
      object Panel39: TPanel
        Left = 9
        Top = 195
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Effective Precipitation File (*.pre)'
        TabOrder = 9
      end
      object edE: TEdit
        Left = 9
        Top = 257
        Width = 628
        Height = 21
        TabOrder = 10
      end
      object Panel40: TPanel
        Left = 9
        Top = 236
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Evapotranspiration File (*.et0)'
        TabOrder = 11
      end
      object edA: TEdit
        Left = 9
        Top = 298
        Width = 628
        Height = 21
        TabOrder = 12
      end
      object Panel41: TPanel
        Left = 9
        Top = 277
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Capillary Rise File (*.asc)'
        TabOrder = 13
      end
      object edPasta: TEdit
        Left = 165
        Top = 55
        Width = 497
        Height = 21
        Color = clSilver
        ReadOnly = True
        TabOrder = 1
      end
      object Panel42: TPanel
        Left = 166
        Top = 34
        Width = 496
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Work Directory:'
        TabOrder = 14
      end
      object Panel43: TPanel
        Left = 9
        Top = 89
        Width = 652
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Files:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 15
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Annual Tables'
      ImageIndex = 2
      object Panel1: TPanel
        Left = 9
        Top = 10
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Tables:'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 9
        Top = 43
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Calculated Local Potential Yield ( FAO - Z.A Method ): (kg/ha)'
        TabOrder = 1
      end
      object sgRPLC: TdrStringAlignGrid
        Left = 9
        Top = 63
        Width = 654
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
        TabOrder = 2
        Alignment = alCenter
      end
      object Panel3: TPanel
        Left = 9
        Top = 100
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Market Product Value: ($/ha)'
        TabOrder = 3
      end
      object sgVPM: TdrStringAlignGrid
        Left = 9
        Top = 120
        Width = 654
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
        TabOrder = 4
        Alignment = alCenter
      end
      object Panel4: TPanel
        Left = 9
        Top = 157
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Farming Production Value: ($)'
        TabOrder = 5
      end
      object sgVPA: TdrStringAlignGrid
        Left = 9
        Top = 177
        Width = 654
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
        TabOrder = 6
        Alignment = alCenter
      end
      object Panel35: TPanel
        Left = 9
        Top = 214
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Rainfed Crop Potential Yield: (kg/ha)'
        TabOrder = 7
      end
      object sgRPCNI: TdrStringAlignGrid
        Left = 9
        Top = 234
        Width = 654
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
        TabOrder = 8
        Alignment = alCenter
      end
      object Panel36: TPanel
        Left = 9
        Top = 271
        Width = 654
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Irrigated Crop Potential Yield: (kg/ha)'
        TabOrder = 9
      end
      object sgRPCI: TdrStringAlignGrid
        Left = 9
        Top = 291
        Width = 654
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
        TabOrder = 10
        Alignment = alCenter
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Weather and Climate'
      ImageIndex = 4
      object Panel13: TPanel
        Left = 9
        Top = 10
        Width = 476
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Weather and Climate Trends: '
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel14: TPanel
        Left = 9
        Top = 32
        Width = 213
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Weather Forecast:'
        TabOrder = 1
      end
      object Panel15: TPanel
        Left = 9
        Top = 53
        Width = 213
        Height = 22
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 2
        object rbSemChuva: TRadioButton
          Left = 18
          Top = 4
          Width = 113
          Height = 16
          Caption = 'No Rain'
          TabOrder = 0
        end
        object rbComChuva: TRadioButton
          Left = 115
          Top = 4
          Width = 89
          Height = 16
          Caption = 'Rainy'
          TabOrder = 1
        end
      end
      object Panel16: TPanel
        Left = 222
        Top = 32
        Width = 263
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Climate Prediction'
        TabOrder = 3
      end
      object Panel17: TPanel
        Left = 222
        Top = 53
        Width = 263
        Height = 22
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 4
        object rbSeco: TRadioButton
          Left = 18
          Top = 4
          Width = 113
          Height = 16
          Caption = 'Dry'
          TabOrder = 0
        end
        object rbMedio: TRadioButton
          Left = 92
          Top = 4
          Width = 113
          Height = 16
          Caption = 'Average'
          TabOrder = 1
        end
        object rbUmido: TRadioButton
          Left = 171
          Top = 4
          Width = 65
          Height = 16
          Caption = 'Humid'
          TabOrder = 2
        end
      end
    end
  end
  object Panel44: TPanel
    Left = 0
    Top = 382
    Width = 683
    Height = 34
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 1
    object btnOk: TButton
      Left = 445
      Top = 5
      Width = 115
      Height = 23
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btnOkClick
    end
    object Button1: TButton
      Left = 563
      Top = 5
      Width = 115
      Height = 23
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Menu_Grade: TPopupMenu
    OnPopup = Menu_GradePopup
    Left = 555
    Top = 174
    object Menu_PreencherValor: TMenuItem
      Caption = 'Fill Values ...'
      OnClick = Menu_PreencherValorClick
    end
  end
  object Open: TOpenDialog
    Left = 491
    Top = 173
  end
end

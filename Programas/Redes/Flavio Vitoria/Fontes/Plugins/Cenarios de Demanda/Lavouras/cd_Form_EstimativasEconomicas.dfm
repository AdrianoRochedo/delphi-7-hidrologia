object foEstimativasEconomicas: TfoEstimativasEconomicas
  Left = 223
  Top = 29
  BorderStyle = bsDialog
  Caption = ' Economical Data'
  ClientHeight = 383
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Book: TPageControl
    Left = 0
    Top = 0
    Width = 289
    Height = 348
    ActivePage = TabSheet6
    Align = alClient
    TabOrder = 0
    object TabSheet6: TTabSheet
      Caption = 'Crop'
      object c_BY: TdrEdit
        Left = 192
        Top = 42
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 0
      end
      object Panel48: TPanel
        Left = 12
        Top = 42
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Base Yield: (kg/ha)'
        TabOrder = 1
      end
      object c_CA: TdrEdit
        Left = 192
        Top = 63
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 2
      end
      object Panel49: TPanel
        Left = 12
        Top = 63
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Cultivated Area: (ha)'
        TabOrder = 3
      end
      object c_NI: TdrEdit
        Left = 192
        Top = 84
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 4
      end
      object Panel51: TPanel
        Left = 12
        Top = 84
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Net Income: (%)'
        TabOrder = 5
      end
      object Panel68: TPanel
        Left = 12
        Top = 9
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Gerneral'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object c_FCost: TdrEdit
        Left = 192
        Top = 151
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 7
        OnChange = CustoTotalIrrigacao_Change
      end
      object Panel74: TPanel
        Left = 12
        Top = 151
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Fixed: ($/ha)'
        TabOrder = 8
      end
      object c_VCost: TdrEdit
        Left = 192
        Top = 172
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 9
        OnChange = CustoTotalIrrigacao_Change
      end
      object Panel75: TPanel
        Left = 12
        Top = 172
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Variable: ($/ha)'
        TabOrder = 10
      end
      object Panel76: TPanel
        Left = 12
        Top = 118
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Production Costs'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
      object c_T: TdrEdit
        Left = 192
        Top = 193
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        Color = clSilver
        TabOrder = 12
      end
      object Panel77: TPanel
        Left = 12
        Top = 193
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Total:'
        TabOrder = 13
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'System'
      ImageIndex = 1
      object s_FR: TdrEdit
        Left = 192
        Top = 42
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 0
      end
      object Panel53: TPanel
        Left = 12
        Top = 42
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Flow Rate: (m3/s)'
        TabOrder = 20
      end
      object s_PH: TdrEdit
        Left = 192
        Top = 63
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 1
      end
      object Panel54: TPanel
        Left = 12
        Top = 63
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Pressure Head: (mca)'
        TabOrder = 19
      end
      object s_PE: TdrEdit
        Left = 192
        Top = 105
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 3
      end
      object Panel55: TPanel
        Left = 12
        Top = 105
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Pumping Efficiency: (%)'
        TabOrder = 18
      end
      object s_Life: TdrEdit
        Left = 192
        Top = 126
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 4
      end
      object Panel56: TPanel
        Left = 12
        Top = 126
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Life: (years)'
        TabOrder = 17
      end
      object Panel67: TPanel
        Left = 12
        Top = 9
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' General'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 16
      end
      object s_ICost: TdrEdit
        Left = 192
        Top = 193
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 5
        OnChange = CustoTotalDoSistema_Change
      end
      object Panel69: TPanel
        Left = 12
        Top = 193
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Instalation: ($/ha)'
        TabOrder = 15
      end
      object s_MCost: TdrEdit
        Left = 192
        Top = 214
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 6
        OnChange = CustoTotalDoSistema_Change
      end
      object Panel70: TPanel
        Left = 12
        Top = 214
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Maintenance: ($/ha)'
        TabOrder = 14
      end
      object Panel71: TPanel
        Left = 12
        Top = 159
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Irrigation Costs'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 13
      end
      object s_TCost: TdrEdit
        Left = 192
        Top = 235
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        Color = clSilver
        TabOrder = 7
      end
      object Panel72: TPanel
        Left = 12
        Top = 235
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Total:'
        TabOrder = 12
      end
      object s_RV: TdrEdit
        Left = 192
        Top = 267
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 8
      end
      object Panel73: TPanel
        Left = 12
        Top = 267
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Residual Valuel: ($/ha)'
        TabOrder = 11
      end
      object s_IR: TdrEdit
        Left = 192
        Top = 288
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 9
      end
      object Panel65: TPanel
        Left = 12
        Top = 288
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Interest Rate: (%)'
        TabOrder = 10
      end
      object s_SE: TdrEdit
        Left = 192
        Top = 84
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 2
      end
      object Panel1: TPanel
        Left = 12
        Top = 84
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' System Efficiency: (%)'
        TabOrder = 21
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Others'
      ImageIndex = 2
      object o_WP: TdrEdit
        Left = 192
        Top = 42
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 0
      end
      object Panel58: TPanel
        Left = 12
        Top = 42
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Water Price: ($/m3)'
        TabOrder = 1
      end
      object o_EP: TdrEdit
        Left = 192
        Top = 63
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 2
      end
      object Panel59: TPanel
        Left = 12
        Top = 63
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Energy Price: ($/kwh)'
        TabOrder = 3
      end
      object Panel61: TPanel
        Left = 12
        Top = 96
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Labor'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object o_P: TdrEdit
        Left = 192
        Top = 130
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 5
      end
      object Panel62: TPanel
        Left = 12
        Top = 130
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Persons: (persons/ha)'
        TabOrder = 6
      end
      object o_CH: TdrEdit
        Left = 192
        Top = 151
        Width = 75
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 7
      end
      object Panel63: TPanel
        Left = 12
        Top = 151
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Cost Hourly: ($/h/persons)'
        TabOrder = 8
      end
      object Panel66: TPanel
        Left = 12
        Top = 9
        Width = 255
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Prices'
        Color = clBtnHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
    end
  end
  object Panel44: TPanel
    Left = 0
    Top = 348
    Width = 289
    Height = 35
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 1
    object btnFechar: TButton
      Left = 6
      Top = 6
      Width = 115
      Height = 23
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnFecharClick
    end
  end
end

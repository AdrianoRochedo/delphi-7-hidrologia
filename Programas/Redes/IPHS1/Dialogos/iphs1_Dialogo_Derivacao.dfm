inherited iphs1_Form_Dialogo_Derivacao: Tiphs1_Form_Dialogo_Derivacao
  Left = 228
  Top = 39
  Caption = ' Derivacao'
  ClientHeight = 321
  ClientWidth = 453
  KeyPreview = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited sbObs: TSpeedButton
    Top = 425
    Visible = False
  end
  inherited btnOk: TBitBtn
    Top = 290
    TabOrder = 6
  end
  inherited btnCancelar: TBitBtn
    Top = 290
    TabOrder = 8
  end
  inherited Panel3: TPanel
    Top = 362
    Width = 129
  end
  inherited Panel4: TPanel
    Left = 134
    Top = 362
    Width = 156
  end
  inherited Panel5: TPanel
    Left = 290
    Top = 362
    Width = 158
  end
  inherited Panel8: TPanel
    Top = 404
    Visible = False
  end
  inherited edObs: TEdit
    Top = 425
    TabOrder = 9
    Visible = False
  end
  inherited edOper: TdrEdit
    Top = 383
    Width = 129
    TabOrder = 4
  end
  inherited edVMin: TdrEdit
    Left = 134
    Top = 383
    Width = 156
    TabOrder = 5
  end
  inherited edVMax: TdrEdit
    Left = 289
    Top = 383
    Width = 159
  end
  object Panel6: TPanel [17]
    Left = 5
    Top = 129
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
    object rbDer: TRadioButton
      Left = 3
      Top = 4
      Width = 303
      Height = 14
      Caption = 'Deriva'#231#227'o (com caracter'#237'sticas da se'#231#227'o):'
      TabOrder = 0
      OnClick = rbDerClick
    end
  end
  object Panel7: TPanel [18]
    Left = 5
    Top = 240
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 17
    object rbDH: TRadioButton
      Left = 3
      Top = 4
      Width = 208
      Height = 15
      Caption = 'Deriva'#231#227'o (com % da vaz'#227'o):'
      TabOrder = 0
      OnClick = rbDHClick
    end
  end
  object paDer: TPanel [19]
    Left = 2
    Top = 150
    Width = 449
    Height = 88
    BevelOuter = bvNone
    Caption = 'paDer'
    TabOrder = 18
    object Panel11: TPanel
      Left = 134
      Top = 0
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Largura:'
      TabOrder = 0
    end
    object Panel9: TPanel
      Left = 238
      Top = 0
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Rugosidade:'
      TabOrder = 1
    end
    object Panel10: TPanel
      Left = 342
      Top = 0
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Declividade:'
      TabOrder = 2
    end
    object Panel15: TPanel
      Left = 3
      Top = 0
      Width = 130
      Height = 42
      Alignment = taRightJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Canal Principal:  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object Panel12: TPanel
      Left = 134
      Top = 42
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Largura:'
      TabOrder = 4
    end
    object Panel13: TPanel
      Left = 238
      Top = 42
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Rugosidade:'
      TabOrder = 5
    end
    object Panel14: TPanel
      Left = 342
      Top = 42
      Width = 104
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Declividade:'
      TabOrder = 6
    end
    object Panel16: TPanel
      Left = 3
      Top = 42
      Width = 130
      Height = 42
      Alignment = taRightJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = '  Canal de Deriva'#231#227'o:  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
    end
    object edCPL: TdrEdit
      Left = 133
      Top = 21
      Width = 105
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 8
    end
    object edCPR: TdrEdit
      Left = 238
      Top = 21
      Width = 104
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 9
    end
    object edCPD: TdrEdit
      Left = 342
      Top = 21
      Width = 104
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 10
    end
    object edCDL: TdrEdit
      Left = 134
      Top = 63
      Width = 104
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 11
    end
    object edCDR: TdrEdit
      Left = 238
      Top = 63
      Width = 104
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 12
    end
    object edCDD: TdrEdit
      Left = 342
      Top = 63
      Width = 104
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 13
    end
  end
  object paDH: TPanel [20]
    Left = 3
    Top = 261
    Width = 447
    Height = 25
    BevelOuter = bvNone
    TabOrder = 19
    object Panel19: TPanel
      Left = 2
      Top = 0
      Width = 338
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Percentagem (%) da Vaz'#227'o:'
      TabOrder = 0
    end
    object edPerc: TdrEdit
      Left = 340
      Top = 0
      Width = 105
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 1
    end
  end
end

inherited iphs1_Form_Dialogo_Res: Tiphs1_Form_Dialogo_Res
  Left = 289
  Top = 83
  Caption = ' Reservat'#243'rio'
  ClientHeight = 351
  ClientWidth = 386
  KeyPreview = True
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbCV: TSpeedButton [0]
    Left = 5
    Top = 321
    Width = 162
    Height = 25
    Caption = 'Editar Tabela Cota-Volume ...'
    OnClick = btnTCV_Click
  end
  inherited sbObs: TSpeedButton
    Left = 207
    Height = 21
  end
  inherited P1: TPanel
    TabOrder = 11
  end
  inherited edDescricao: TEdit
    Width = 212
  end
  inherited Panel1: TPanel
    Width = 211
    TabOrder = 12
  end
  inherited Panel2: TPanel
    Width = 375
    TabOrder = 13
  end
  inherited mComentarios: TMemo
    Width = 375
  end
  inherited btnOk: TBitBtn
    Left = 199
    Top = 321
    TabOrder = 9
  end
  inherited btnCancelar: TBitBtn
    Left = 291
    Top = 321
    TabOrder = 10
  end
  inherited Panel3: TPanel
    Left = 515
    Top = 6
    Width = 91
    TabOrder = 15
  end
  inherited Panel4: TPanel
    Left = 515
    Top = 48
    Width = 90
    TabOrder = 16
  end
  inherited Panel5: TPanel
    Left = 514
    Top = 90
    Width = 92
    TabOrder = 14
  end
  inherited Panel8: TPanel
    Width = 225
    inherited rbPDO: TRadioButton
      Left = 137
      Width = 42
    end
    inherited RadioButton6: TRadioButton
      Left = 178
      Width = 43
    end
  end
  inherited edObs: TEdit
    Width = 203
  end
  inherited edOper: TdrEdit
    Left = 515
    Top = 27
    Width = 91
  end
  inherited edVMin: TdrEdit
    Left = 514
    Top = 69
    Width = 91
  end
  inherited edVMax: TdrEdit
    Left = 513
    Top = 111
    Width = 93
  end
  object Panel9: TPanel [18]
    Left = 230
    Top = 123
    Width = 150
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Armazenam. Inicial (1000 m'#179'):'
    TabOrder = 17
  end
  object edAI: TdrEdit [19]
    Left = 229
    Top = 144
    Width = 151
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 8
  end
  object Panel7: TPanel [20]
    Left = 5
    Top = 165
    Width = 375
    Height = 147
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 18
    object rbVO: TRadioButton
      Left = 24
      Top = 30
      Width = 139
      Height = 17
      Caption = 'Vertedor e/ou Orif'#237'cios'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = EstruturasDeSaida_Click
    end
    object paVO: TPanel
      Left = 42
      Top = 46
      Width = 312
      Height = 49
      BevelOuter = bvNone
      TabOrder = 1
      object btnVert: TSpeedButton
        Left = 72
        Top = 4
        Width = 30
        Height = 20
        Glyph.Data = {
          EE000000424DEE000000000000007600000028000000160000000A0000000100
          0400000000007800000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777007777777777777777777777007777777777777777777777007777
          0077770077770077770077700007700007700007770077700007700007700007
          7700777700777700777700777700777777777777777777777700777777777777
          777777777700777777777777777777777700}
        OnClick = btnVertClick
      end
      object btnOrif: TSpeedButton
        Left = 72
        Top = 25
        Width = 30
        Height = 20
        Glyph.Data = {
          EE000000424DEE000000000000007600000028000000160000000A0000000100
          0400000000007800000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777007777777777777777777777007777777777777777777777007777
          0077770077770077770077700007700007700007770077700007700007700007
          7700777700777700777700777700777777777777777777777700777777777777
          777777777700777777777777777777777700}
        OnClick = btnOrifClick
      end
      object cbVert: TCheckBox
        Left = 1
        Top = 5
        Width = 63
        Height = 17
        Caption = ' Vertedor'
        TabOrder = 0
        OnClick = cbVertClick
      end
      object cbOrif: TCheckBox
        Left = 1
        Top = 26
        Width = 58
        Height = 17
        Caption = ' Orif'#237'cio'
        TabOrder = 1
        OnClick = cbOrifClick
      end
      object edBypass: TdrEdit
        Left = 132
        Top = 25
        Width = 155
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        AutoSize = False
        TabOrder = 2
      end
      object Panel10: TPanel
        Left = 133
        Top = 4
        Width = 154
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Vaz'#227'o M'#225'x. do Bypass (m'#179'/s):'
        TabOrder = 3
      end
    end
    object rbEE: TRadioButton
      Left = 24
      Top = 96
      Width = 223
      Height = 17
      Caption = 'Estruturas Extravazoras (curvas H-Qsai)'
      TabOrder = 2
      OnClick = EstruturasDeSaida_Click
    end
    object paEE: TPanel
      Left = 40
      Top = 111
      Width = 298
      Height = 29
      BevelOuter = bvNone
      Enabled = False
      TabOrder = 3
      object btnEE: TSpeedButton
        Left = 134
        Top = 4
        Width = 155
        Height = 21
        Caption = 'Editar Estruturas ...'
        OnClick = btnEE_Click
      end
      object Panel12: TPanel
        Left = 3
        Top = 4
        Width = 81
        Height = 21
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = ' Quantidade:'
        TabOrder = 0
      end
      object edNE: TdrEdit
        Left = 84
        Top = 3
        Width = 40
        Height = 22
        Hint = ' N'#250'mero de Estruturas Extravazoras (1..10) '
        BeepOnError = False
        DataType = dtFloat
        AutoSize = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 375
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Estruturas de Sa'#237'da:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
end

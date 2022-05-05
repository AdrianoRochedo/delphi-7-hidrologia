object foSeries_FrequencyAnalisys: TfoSeries_FrequencyAnalisys
  Left = 286
  Top = 88
  Width = 266
  Height = 400
  Caption = ' An'#225'lise de Frequ'#234'ncias'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnCalcular: TButton
    Left = 27
    Top = 331
    Width = 99
    Height = 25
    Caption = 'Calcular'
    TabOrder = 0
    OnClick = btnCalcularClick
  end
  object btnFechar: TButton
    Left = 129
    Top = 331
    Width = 99
    Height = 25
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = btnFecharClick
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 7
    Width = 240
    Height = 257
    Caption = 'Sa'#237'das'
    DragMode = dmAutomatic
    TabOrder = 2
    object labImprime: TLabel
      Left = 177
      Top = 15
      Width = 41
      Height = 13
      Caption = 'Imprimir: '
    end
    object labEsperado: TLabel
      Left = 21
      Top = 128
      Width = 78
      Height = 13
      Caption = 'Valor Esperado: '
      Enabled = False
    end
    object labResiduos: TLabel
      Left = 21
      Top = 153
      Width = 52
      Height = 13
      Caption = 'Res'#237'duos: '
      Enabled = False
    end
    object labResPadr: TLabel
      Left = 21
      Top = 176
      Width = 119
      Height = 13
      Caption = 'Res'#237'duos Padronizados: '
      Enabled = False
    end
    object labTabFreq: TLabel
      Left = 21
      Top = 57
      Width = 115
      Height = 13
      Caption = 'Tabela de Freq'#252#234'ncias: '
    end
    object labEstAss: TLabel
      Left = 21
      Top = 201
      Width = 131
      Height = 13
      Caption = 'Estat'#237'sticas de Associa'#231#227'o:'
    end
    object labMatFreq: TLabel
      Left = 21
      Top = 80
      Width = 107
      Height = 13
      Caption = 'Matriz de Freq'#252#234'ncias:'
    end
    object labQuiQuad: TLabel
      Left = 21
      Top = 102
      Width = 69
      Height = 13
      Caption = 'Qui-Quadrado:'
    end
    object labDSFrame: TLabel
      Left = 21
      Top = 36
      Width = 34
      Height = 13
      Caption = 'Dados:'
    end
    object labFreqByValue: TLabel
      Left = 21
      Top = 225
      Width = 103
      Height = 13
      Caption = 'Frequ'#234'ncias por Valor'
    end
    object chbIEsperado: TCheckBox
      Left = 190
      Top = 128
      Width = 27
      Height = 13
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 4
      OnClick = AtualizarOpcoes
    end
    object chbIResiduos: TCheckBox
      Left = 190
      Top = 153
      Width = 27
      Height = 13
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 5
      OnClick = AtualizarOpcoes
    end
    object chbIResPadr: TCheckBox
      Left = 190
      Top = 177
      Width = 29
      Height = 13
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 6
      OnClick = AtualizarOpcoes
    end
    object chbITabFreq: TCheckBox
      Left = 190
      Top = 57
      Width = 27
      Height = 13
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = AtualizarOpcoes
    end
    object chbIQuiQuad: TCheckBox
      Left = 190
      Top = 103
      Width = 29
      Height = 13
      TabOrder = 3
      OnClick = chbIQuiQuadClick
    end
    object chbIEstAss: TCheckBox
      Left = 190
      Top = 202
      Width = 29
      Height = 17
      TabOrder = 7
      OnClick = AtualizarOpcoes
    end
    object chbIMatFreq: TCheckBox
      Left = 190
      Top = 80
      Width = 29
      Height = 13
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = AtualizarOpcoes
    end
    object chbIDSFrame: TCheckBox
      Left = 190
      Top = 36
      Width = 27
      Height = 12
      TabOrder = 0
      OnClick = AtualizarOpcoes
    end
    object chbIFreqByValue: TCheckBox
      Left = 190
      Top = 226
      Width = 29
      Height = 17
      TabOrder = 8
      OnClick = AtualizarOpcoes
    end
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 270
    Width = 239
    Height = 51
    Caption = 'Gr'#225'ficos'
    TabOrder = 3
    object chbHistograma: TCheckBox
      Left = 19
      Top = 20
      Width = 81
      Height = 19
      Caption = 'Histograma'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
end

object foSeries_DescEstats: TfoSeries_DescEstats
  Left = 286
  Top = 88
  BorderStyle = bsDialog
  Caption = ' Estat'#237'sticas Descritivas'
  ClientHeight = 356
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 217
    Top = 25
    Width = 193
    Height = 289
    BevelOuter = bvLowered
    TabOrder = 0
    object CBO_Minimo: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'M'#237'nimo'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CBO_Perc1: TCheckBox
      Tag = 1
      Left = 8
      Top = 29
      Width = 97
      Height = 17
      Caption = 'Percentil 1%'
      TabOrder = 1
    end
    object CBO_Perc5: TCheckBox
      Tag = 2
      Left = 8
      Top = 51
      Width = 97
      Height = 17
      Caption = 'Percentil 5%'
      TabOrder = 2
    end
    object CBO_Perc10: TCheckBox
      Tag = 3
      Left = 8
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Percentil 10%'
      TabOrder = 3
    end
    object CBO_Quartil1: TCheckBox
      Tag = 4
      Left = 8
      Top = 93
      Width = 97
      Height = 17
      Caption = 'Primeiro Quartil'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CBO_Mediana: TCheckBox
      Tag = 5
      Left = 8
      Top = 115
      Width = 97
      Height = 17
      Caption = 'Mediana'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object CBO_Quartil3: TCheckBox
      Tag = 6
      Left = 8
      Top = 136
      Width = 97
      Height = 17
      Caption = 'Terceiro Quartil'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object CBO_Maximo: TCheckBox
      Tag = 7
      Left = 8
      Top = 157
      Width = 97
      Height = 17
      Caption = 'M'#225'ximo'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object CBO_Amplitude: TCheckBox
      Tag = 8
      Left = 8
      Top = 179
      Width = 97
      Height = 17
      Caption = 'Amplitude'
      TabOrder = 8
    end
    object CBO_AmpInter: TCheckBox
      Tag = 9
      Left = 8
      Top = 200
      Width = 137
      Height = 17
      Caption = 'Amplitude Interquart'#237'lica'
      TabOrder = 9
    end
    object CBO_Perc90: TCheckBox
      Tag = 10
      Left = 8
      Top = 221
      Width = 97
      Height = 17
      Caption = 'Percentil 90%'
      TabOrder = 10
    end
    object CBO_Perc95: TCheckBox
      Tag = 11
      Left = 8
      Top = 243
      Width = 97
      Height = 17
      Caption = 'Percentil 95%'
      TabOrder = 11
    end
    object CBO_Perc99: TCheckBox
      Tag = 12
      Left = 8
      Top = 264
      Width = 97
      Height = 17
      Caption = 'Percentil 99%'
      TabOrder = 12
    end
  end
  object Panel2: TPanel
    Left = 9
    Top = 25
    Width = 201
    Height = 289
    BevelOuter = bvLowered
    TabOrder = 1
    object CB_Media: TCheckBox
      Left = 9
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Media'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CB_Variancia: TCheckBox
      Tag = 1
      Left = 8
      Top = 25
      Width = 97
      Height = 17
      Caption = 'Vari'#226'ncia'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CB_Desvio: TCheckBox
      Tag = 2
      Left = 8
      Top = 42
      Width = 97
      Height = 17
      Caption = 'Desvio Padr'#227'o'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CB_Total: TCheckBox
      Tag = 3
      Left = 8
      Top = 59
      Width = 97
      Height = 17
      Caption = 'Total'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CB_Minimo: TCheckBox
      Tag = 4
      Left = 8
      Top = 76
      Width = 97
      Height = 17
      Caption = 'M'#237'nimo'
      TabOrder = 4
    end
    object CB_Maximo: TCheckBox
      Tag = 5
      Left = 8
      Top = 93
      Width = 97
      Height = 17
      Caption = 'M'#225'ximo'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object CB_NumVal: TCheckBox
      Tag = 6
      Left = 8
      Top = 110
      Width = 121
      Height = 17
      Caption = 'N'#250'mero de Valores'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object CB_NumValVal: TCheckBox
      Tag = 7
      Left = 8
      Top = 127
      Width = 153
      Height = 17
      Caption = 'N'#250'mero de Valores V'#225'lidos'
      TabOrder = 7
    end
    object CB_Erro: TCheckBox
      Tag = 8
      Left = 8
      Top = 145
      Width = 129
      Height = 17
      Caption = 'Erro Padr'#227'o da M'#233'dia'
      TabOrder = 8
    end
    object CB_Amplitude: TCheckBox
      Tag = 9
      Left = 8
      Top = 162
      Width = 97
      Height = 17
      Caption = 'Amplitude'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
    object CB_Curtose: TCheckBox
      Tag = 12
      Left = 8
      Top = 213
      Width = 97
      Height = 17
      Caption = 'Curtose'
      TabOrder = 12
    end
    object CB_SomaNCor: TCheckBox
      Tag = 13
      Left = 8
      Top = 230
      Width = 185
      Height = 17
      Caption = 'Soma de Quadrados N'#227'o Corrigida'
      TabOrder = 13
    end
    object CB_SomCor: TCheckBox
      Tag = 14
      Left = 8
      Top = 247
      Width = 169
      Height = 17
      Caption = 'Soma de Quadrados Corrigida'
      TabOrder = 14
    end
    object CB_SomPesos: TCheckBox
      Tag = 15
      Left = 8
      Top = 264
      Width = 169
      Height = 17
      Caption = 'Soma dos Pesos'
      TabOrder = 15
    end
    object CB_CoefVar: TCheckBox
      Tag = 10
      Left = 8
      Top = 179
      Width = 137
      Height = 17
      Caption = 'Coeficiente de Varia'#231#227'o'
      TabOrder = 10
    end
    object CB_Assimetria: TCheckBox
      Tag = 11
      Left = 8
      Top = 196
      Width = 129
      Height = 17
      Caption = 'Assimetria'
      TabOrder = 11
    end
  end
  object RB_Ordem: TRadioButton
    Left = 216
    Top = 8
    Width = 69
    Height = 17
    Caption = 'Percentis'
    TabOrder = 2
  end
  object RB_Posicao: TRadioButton
    Left = 8
    Top = 8
    Width = 177
    Height = 17
    Caption = 'Medidas de Posi'#231#227'o e Dispers'#227'o'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object btnCalcular: TButton
    Left = 9
    Top = 323
    Width = 99
    Height = 25
    Caption = 'Calcular'
    TabOrder = 4
    OnClick = btnCalcularClick
  end
  object btnFechar: TButton
    Left = 111
    Top = 323
    Width = 99
    Height = 25
    Caption = 'Fechar'
    TabOrder = 5
    OnClick = btnFecharClick
  end
end

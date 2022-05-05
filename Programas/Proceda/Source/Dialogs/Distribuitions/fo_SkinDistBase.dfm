inherited foSkinDistBase: TfoSkinDistBase
  Left = -1
  Top = 78
  Caption = 'foSkinDistBase'
  ClientHeight = 269
  ClientWidth = 396
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Left = 10
    Top = 232
    Width = 88
    Caption = 'Ok'
    TabOrder = 5
  end
  inherited btnCancelar: TButton
    Left = 101
    Top = 232
    Width = 88
    TabOrder = 6
  end
  object GB: TGroupBox
    Left = 10
    Top = 8
    Width = 181
    Height = 213
    Caption = ' Op'#231#245'es '
    TabOrder = 0
    object Label1: TLabel
      Left = 13
      Top = 167
      Width = 61
      Height = 13
      Caption = 'Constante C:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbImpEst: TCheckBox
      Left = 8
      Top = 15
      Width = 118
      Height = 21
      Caption = 'Imprimir estimativas'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
    end
    object cbIFN: TCheckBox
      Left = 27
      Top = 57
      Width = 118
      Height = 21
      Caption = 'Incluir Formato Nulo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cbSE: TCheckBox
      Left = 27
      Top = 76
      Width = 105
      Height = 17
      Caption = 'Simular Envelope'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object cbGraph: TCheckBox
      Left = 8
      Top = 37
      Width = 138
      Height = 21
      Caption = 'Gr'#225'fico de Probabilidade'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = cbGraphClick
    end
    object cbReturn: TCheckBox
      Left = 8
      Top = 118
      Width = 138
      Height = 21
      Caption = 'Tempos de Retorno'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = cbReturnClick
    end
    object drReturn: TdrEdit
      Left = 30
      Top = 137
      Width = 132
      Height = 21
      BeepOnError = False
      DataType = dtString
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '2 5 10 20 50 100'
    end
    object edCC: TdrEdit
      Left = 30
      Top = 182
      Width = 132
      Height = 21
      BeepOnError = False
      DataType = dtString
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '0.375'
    end
    object cbImpr: TCheckBox
      Left = 27
      Top = 91
      Width = 96
      Height = 21
      Caption = 'Imprimir dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object rgNInt: TRadioGroup
    Left = 200
    Top = 121
    Width = 187
    Height = 100
    Caption = ' Intervalo - N'#250'mero '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Autom'#225'tico'
      'Fixado'
      'Prop. Distintas')
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnClick = rgNIntClick
  end
  object rgTestes: TRadioGroup
    Left = 200
    Top = 8
    Width = 187
    Height = 105
    Caption = ' Testes de Ajustamento '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Nenhum'
      'Qui-quadrado'
      'Kolmogorov-Smirnov'
      'Anderson-Darling')
    ParentFont = False
    TabOrder = 1
    OnClick = rgTestesClick
  end
  object edFix: TdrEdit
    Left = 304
    Top = 166
    Width = 70
    Height = 21
    BeepOnError = False
    DataType = dtString
    TabOrder = 3
    Text = '5'
    Visible = False
  end
  object edPropDist: TdrEdit
    Left = 304
    Top = 191
    Width = 70
    Height = 21
    BeepOnError = False
    DataType = dtString
    TabOrder = 4
    Visible = False
  end
end

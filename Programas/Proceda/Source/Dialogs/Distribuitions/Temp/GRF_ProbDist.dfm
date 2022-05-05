inherited foGRF_ProbDist: TfoGRF_ProbDist
  Left = 217
  Top = 127
  Caption = 'foGRF_ProbDist'
  ClientHeight = 267
  ClientWidth = 204
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Left = 9
    Top = 232
    Width = 88
    Caption = 'Ok'
    ModalResult = 1
    OnClick = nil
  end
  inherited btnAjuda: TButton
    Left = 100
    Top = 232
    Width = 88
    Caption = 'Cancelar'
    ModalResult = 2
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 8
    Width = 181
    Height = 213
    Caption = ' Op'#231#245'es '
    TabOrder = 2
    object Label1: TLabel
      Left = 13
      Top = 164
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
      Top = 13
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
    object cbImpr: TCheckBox
      Left = 8
      Top = 32
      Width = 96
      Height = 21
      Caption = 'Imprimir dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object cbIFN: TCheckBox
      Left = 27
      Top = 71
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
      Top = 90
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
      Top = 51
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
      TabOrder = 4
      OnClick = cbGraphClick
    end
    object cbReturn: TCheckBox
      Left = 8
      Top = 108
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
      Top = 133
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
  end
end

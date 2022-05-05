inherited foGRF_Dist_WithParameters: TfoGRF_Dist_WithParameters
  Left = 251
  Top = 111
  Caption = 'foGRF_Dist_WithParameters'
  ClientHeight = 233
  ClientWidth = 464
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Left = 4
    Top = 195
    Width = 121
  end
  inherited btnAjuda: TButton
    Left = 130
    Top = 195
    Width = 121
  end
  inherited GroupBox1: TGroupBox
    Left = 265
    Width = 186
    inherited Label1: TLabel
      Left = 12
      Top = 162
    end
    inherited cbImpEst: TCheckBox
      Left = 11
      Top = 19
    end
    inherited cbImpr: TCheckBox
      Left = 11
      Top = 38
    end
    inherited cbIFN: TCheckBox
      Left = 30
      Top = 76
    end
    inherited cbSE: TCheckBox
      Left = 30
      Top = 95
    end
    inherited cbGraph: TCheckBox
      Left = 11
      Top = 57
    end
    inherited cbReturn: TCheckBox
      Left = 11
      Top = 114
    end
    inherited drReturn: TdrEdit
      Left = 31
      Width = 141
    end
    inherited edCC: TdrEdit
      Left = 12
      Top = 177
      Width = 160
    end
  end
  object gbPars: TGroupBox
    Left = 9
    Top = 8
    Width = 244
    Height = 173
    Caption = ' Par'#226'metros: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object R1: TRadioButton
      Left = 56
      Top = 45
      Width = 113
      Height = 17
      Caption = 'N'#227'o especificar'
      TabOrder = 0
    end
    object R2: TRadioButton
      Left = 56
      Top = 69
      Width = 80
      Height = 17
      Caption = 'Momentos'
      TabOrder = 1
    end
    object R3: TRadioButton
      Left = 57
      Top = 93
      Width = 127
      Height = 17
      Caption = 'M'#225'x. Verossimilhan'#231'a'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object R4: TRadioButton
      Left = 56
      Top = 117
      Width = 82
      Height = 17
      Caption = 'Especificar'
      TabOrder = 3
    end
  end
end

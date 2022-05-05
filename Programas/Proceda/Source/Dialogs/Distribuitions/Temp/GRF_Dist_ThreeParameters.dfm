inherited foGRF_Dist_ThreeParameters: TfoGRF_Dist_ThreeParameters
  Left = 325
  Top = 81
  Caption = 'foGRF_Dist_ThreeParameters'
  ClientHeight = 246
  ClientWidth = 531
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Top = 209
  end
  inherited btnAjuda: TButton
    Top = 209
  end
  inherited GroupBox1: TGroupBox
    Top = 13
    Width = 185
    Height = 221
    inherited Label1: TLabel
      Top = 168
    end
    inherited cbImpEst: TCheckBox
      Top = 25
    end
    inherited cbImpr: TCheckBox
      Top = 44
    end
    inherited cbIFN: TCheckBox
      Top = 82
    end
    inherited cbSE: TCheckBox
      Top = 101
    end
    inherited cbGraph: TCheckBox
      Top = 63
    end
    inherited cbReturn: TCheckBox
      Top = 120
    end
    inherited drReturn: TdrEdit
      Top = 139
    end
    inherited edCC: TdrEdit
      Top = 183
    end
  end
  inherited gbPars: TGroupBox
    Top = 13
    Width = 309
    Height = 185
    inherited R1: TRadioButton
      Left = 12
      Top = 53
    end
    inherited R2: TRadioButton
      Left = 12
      Top = 74
    end
    inherited R3: TRadioButton
      Left = 12
      Top = 95
    end
    inherited R4: TRadioButton
      Left = 13
      Top = 117
    end
    inherited gbParVal: TGroupBox
      Top = 18
      Height = 150
      inherited laP1: TLabel
        Left = 11
        Top = 21
      end
      inherited laP2: TLabel
        Left = 10
        Top = 61
      end
      object laP3: TLabel [2]
        Left = 10
        Top = 101
        Width = 16
        Height = 13
        Caption = 'P3:'
      end
      inherited edP1: TdrEdit
        Left = 9
        Top = 35
      end
      inherited edP2: TdrEdit
        Left = 9
        Top = 75
      end
      object edP3: TdrEdit
        Left = 9
        Top = 116
        Width = 125
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 2
      end
    end
  end
end

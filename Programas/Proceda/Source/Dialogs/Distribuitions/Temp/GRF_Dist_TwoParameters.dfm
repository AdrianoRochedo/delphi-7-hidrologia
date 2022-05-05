inherited foGRF_Dist_TwoParameters: TfoGRF_Dist_TwoParameters
  Left = 317
  Top = 117
  Caption = 'foGRF_Dist_TwoParameters'
  ClientHeight = 244
  ClientWidth = 527
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnAjuda: TButton
    Left = 171
  end
  inherited gbPars: TGroupBox
    Height = 176
    inherited R1: TRadioButton
      Top = 28
    end
    inherited R2: TRadioButton
      Top = 52
    end
    inherited R3: TRadioButton
      Top = 77
    end
    inherited R4: TRadioButton
      Top = 101
    end
    inherited gbParVal: TGroupBox
      Top = 28
      Height = 126
      inherited laP1: TLabel
        Top = 26
      end
      object laP2: TLabel [1]
        Left = 9
        Top = 68
        Width = 16
        Height = 13
        Caption = 'P2:'
      end
      inherited edP1: TdrEdit
        Left = 8
        Top = 42
      end
      object edP2: TdrEdit
        Left = 8
        Top = 84
        Width = 125
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 1
      end
    end
  end
end

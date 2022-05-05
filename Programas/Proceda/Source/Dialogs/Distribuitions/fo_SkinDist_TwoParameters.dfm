inherited foSkinDist_TwoParameters: TfoSkinDist_TwoParameters
  Left = 317
  Top = 117
  Caption = 'foSkinDist_TwoParameters'
  ClientHeight = 434
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Top = 398
  end
  inherited btnCancelar: TButton
    Top = 398
  end
  inherited GB: TGroupBox
    Top = 174
    inherited drReturn: TdrEdit
      Top = 139
      Width = 141
    end
    inherited edCC: TdrEdit
      Width = 160
    end
  end
  inherited rgNInt: TRadioGroup
    Top = 288
  end
  inherited rgTestes: TRadioGroup
    Top = 174
  end
  inherited edFix: TdrEdit
    Top = 334
  end
  inherited edPropDist: TdrEdit
    Top = 359
  end
  inherited gbPars: TGroupBox
    Top = 12
    Height = 153
    inherited R1: TRadioButton
      Left = 42
      Top = 35
    end
    inherited R2: TRadioButton
      Left = 42
      Top = 59
    end
    inherited R3: TRadioButton
      Left = 42
      Top = 84
    end
    inherited R4: TRadioButton
      Left = 42
      Top = 108
    end
    inherited gbParVal: TGroupBox
      Left = 181
      Top = 19
      Width = 160
      Height = 116
      inherited laP1: TLabel
        Left = 12
        Top = 21
      end
      object laP2: TLabel [1]
        Left = 11
        Top = 64
        Width = 16
        Height = 13
        Caption = 'P2:'
      end
      inherited edP1: TdrEdit
        Left = 12
        Width = 137
      end
      object edP2: TdrEdit
        Left = 12
        Top = 79
        Width = 136
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 1
      end
    end
  end
end

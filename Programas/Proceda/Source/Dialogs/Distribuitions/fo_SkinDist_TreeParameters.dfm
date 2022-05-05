inherited foSkinDist_TreeParameters: TfoSkinDist_TreeParameters
  Caption = 'foSkinDist_TreeParameters'
  ClientHeight = 476
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Top = 440
  end
  inherited btnCancelar: TButton
    Top = 440
  end
  inherited GB: TGroupBox
    Top = 216
  end
  inherited rgNInt: TRadioGroup
    Top = 330
  end
  inherited rgTestes: TRadioGroup
    Top = 216
  end
  inherited edFix: TdrEdit
    Top = 383
  end
  inherited edPropDist: TdrEdit
    Top = 408
  end
  inherited gbPars: TGroupBox
    Height = 196
    inherited R1: TRadioButton
      Top = 54
    end
    inherited R2: TRadioButton
      Top = 78
    end
    inherited R3: TRadioButton
      Top = 103
    end
    inherited R4: TRadioButton
      Top = 127
    end
    inherited gbParVal: TGroupBox
      Height = 160
      object laP3: TLabel [2]
        Left = 11
        Top = 108
        Width = 16
        Height = 13
        Caption = 'P3:'
      end
      object edP3: TdrEdit
        Left = 12
        Top = 123
        Width = 136
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 2
      end
    end
  end
end

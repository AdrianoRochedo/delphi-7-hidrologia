inherited foSkinDist_OneParameter: TfoSkinDist_OneParameter
  Left = 299
  Top = 115
  Caption = 'foSkinDist_OneParameter'
  ClientHeight = 418
  ClientWidth = 400
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Left = 13
    Top = 379
    Width = 88
  end
  inherited btnCancelar: TButton
    Left = 104
    Top = 379
    Width = 88
  end
  inherited GB: TGroupBox
    Left = 13
    Top = 153
    Width = 180
    Height = 214
    inherited drReturn: TdrEdit
      Top = 138
      Width = 137
    end
    inherited edCC: TdrEdit
      Width = 156
    end
  end
  inherited rgNInt: TRadioGroup
    Left = 202
    Top = 267
  end
  inherited rgTestes: TRadioGroup
    Left = 202
    Top = 153
  end
  inherited edFix: TdrEdit
    Left = 307
    Top = 311
  end
  inherited edPropDist: TdrEdit
    Left = 307
    Top = 336
  end
  inherited gbPars: TGroupBox
    Left = 12
    Top = 14
    Width = 377
    Height = 130
    inherited R1: TRadioButton
      Left = 46
      Top = 24
      OnClick = R1Click
    end
    inherited R2: TRadioButton
      Left = 46
      Top = 48
      OnClick = R2Click
    end
    inherited R3: TRadioButton
      Left = 46
      Top = 73
      Width = 124
      OnClick = R3Click
    end
    inherited R4: TRadioButton
      Left = 46
      Top = 99
      OnClick = R4Click
    end
    object gbParVal: TGroupBox
      Left = 185
      Top = 24
      Width = 146
      Height = 68
      Caption = ' Valor dos Par'#226'metros: '
      TabOrder = 4
      object laP1: TLabel
        Left = 10
        Top = 22
        Width = 16
        Height = 13
        Caption = 'P1:'
      end
      object edP1: TdrEdit
        Left = 10
        Top = 36
        Width = 124
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 0
      end
    end
  end
end

inherited foGRF_Dist_OneParameter: TfoGRF_Dist_OneParameter
  Left = 299
  Top = 115
  Caption = 'foGRF_Dist_OneParameter'
  ClientHeight = 243
  ClientWidth = 525
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Left = 12
    Top = 202
    Width = 150
  end
  inherited btnAjuda: TButton
    Left = 172
    Top = 202
    Width = 150
  end
  inherited GroupBox1: TGroupBox
    Left = 333
    Top = 14
    Width = 180
    Height = 214
  end
  inherited gbPars: TGroupBox
    Left = 12
    Top = 14
    Width = 311
    Height = 175
    inherited R1: TRadioButton
      Left = 9
      Top = 47
      OnClick = R1Click
    end
    inherited R2: TRadioButton
      Left = 9
      Top = 71
      OnClick = R2Click
    end
    inherited R3: TRadioButton
      Left = 9
      Top = 96
      Width = 124
      OnClick = R3Click
    end
    inherited R4: TRadioButton
      Left = 9
      Top = 122
      OnClick = R4Click
    end
    object gbParVal: TGroupBox
      Left = 148
      Top = 47
      Width = 146
      Height = 68
      Caption = ' Valor dos Par'#226'metros: '
      TabOrder = 4
      object laP1: TLabel
        Left = 10
        Top = 21
        Width = 16
        Height = 13
        Caption = 'P1:'
      end
      object edP1: TdrEdit
        Left = 9
        Top = 37
        Width = 126
        Height = 21
        BeepOnError = False
        DataType = dtFloat
        TabOrder = 0
      end
    end
  end
end

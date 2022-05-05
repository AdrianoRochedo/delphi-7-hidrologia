object frSensibilidade: TfrSensibilidade
  Left = 0
  Top = 0
  Width = 335
  Height = 41
  Hint = 'An'#225'lise de Sensibilidade'
  TabOrder = 0
  object Label1: TLabel
    Left = 75
    Top = 20
    Width = 6
    Height = 13
    Caption = 'a'
  end
  object Label2: TLabel
    Left = 163
    Top = 20
    Width = 14
    Height = 13
    Caption = 'em'
  end
  object Label3: TLabel
    Left = 1
    Top = 2
    Width = 57
    Height = 13
    Caption = 'Valor Inicial:'
  end
  object Label4: TLabel
    Left = 87
    Top = 2
    Width = 52
    Height = 13
    Caption = 'Valor Final:'
  end
  object Label5: TLabel
    Left = 184
    Top = 2
    Width = 27
    Height = 13
    Caption = 'Taxa:'
  end
  object X: TdrEdit
    Left = 1
    Top = 16
    Width = 69
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 0
  end
  object y: TdrEdit
    Left = 88
    Top = 16
    Width = 69
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 1
  end
  object z: TdrEdit
    Left = 185
    Top = 16
    Width = 69
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 2
  end
  object btnCalc: TButton
    Left = 262
    Top = 16
    Width = 69
    Height = 21
    Caption = 'Calcular'
    TabOrder = 3
  end
end

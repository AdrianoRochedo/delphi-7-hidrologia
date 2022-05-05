object Frame_ParDistrib: TFrame_ParDistrib
  Left = 0
  Top = 0
  Width = 210
  Height = 114
  TabOrder = 0
  object GB: TGroupBox
    Left = 1
    Top = -1
    Width = 209
    Height = 113
    Caption = ' Texto '
    TabOrder = 0
    object R1: TRadioButton
      Left = 25
      Top = 19
      Width = 113
      Height = 17
      Caption = 'N'#227'o especificar'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object R2: TRadioButton
      Left = 25
      Top = 40
      Width = 152
      Height = 17
      Caption = 'Estimar por Momentos'
      TabOrder = 1
    end
    object R3: TRadioButton
      Left = 25
      Top = 62
      Width = 161
      Height = 17
      Caption = 'Estimar por Verossimilhan'#231'a'
      TabOrder = 2
    end
    object R4: TRadioButton
      Left = 25
      Top = 84
      Width = 82
      Height = 17
      Caption = 'Especificar'
      TabOrder = 3
    end
    object edEspecificar: TdrEdit
      Left = 105
      Top = 82
      Width = 74
      Height = 21
      BeepOnError = False
      DataType = dtFloat
      TabOrder = 4
      Text = '0'
    end
  end
end

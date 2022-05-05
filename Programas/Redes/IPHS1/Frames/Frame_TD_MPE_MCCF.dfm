object iphs1_Frame_TD_MPE_MCCF: Tiphs1_Frame_TD_MPE_MCCF
  Left = 0
  Top = 0
  Width = 483
  Height = 42
  TabOrder = 0
  object pa1: TPanel
    Left = 0
    Top = 0
    Width = 84
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tipo da Se'#231#227'o:'
    TabOrder = 0
  end
  object cbTS: TComboBox
    Left = -1
    Top = 21
    Width = 85
    Height = 21
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 1
    Text = ' Circular'
    OnChange = cbTSChange
    Items.Strings = (
      ' Retangular'
      ' Circular'
      ' Trapezoidal')
  end
  object pa2: TPanel
    Left = 84
    Top = 0
    Width = 73
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Di'#226'metro (m):'
    TabOrder = 2
  end
  object edAD: TdrEdit
    Left = 84
    Top = 21
    Width = 73
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 3
  end
  object pa3: TPanel
    Left = 157
    Top = 0
    Width = 68
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Largura (m):'
    TabOrder = 4
  end
  object edL: TdrEdit
    Left = 157
    Top = 21
    Width = 68
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    Enabled = False
    TabOrder = 5
  end
  object pa4: TPanel
    Left = 225
    Top = 0
    Width = 95
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Talude Esq. (1:z):'
    TabOrder = 6
  end
  object edDE: TdrEdit
    Left = 225
    Top = 21
    Width = 95
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    Enabled = False
    TabOrder = 7
  end
  object pa5: TPanel
    Left = 320
    Top = 0
    Width = 91
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Talude Dir. (1:z):'
    TabOrder = 8
  end
  object edDD: TdrEdit
    Left = 320
    Top = 21
    Width = 91
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    Enabled = False
    TabOrder = 9
  end
  object pa6: TPanel
    Left = 411
    Top = 0
    Width = 72
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rugosidade:'
    TabOrder = 10
  end
  object edR: TdrEdit
    Left = 411
    Top = 21
    Width = 72
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 11
  end
end

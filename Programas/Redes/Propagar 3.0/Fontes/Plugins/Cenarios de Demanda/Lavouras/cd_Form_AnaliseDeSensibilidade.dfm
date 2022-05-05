object foAnaliseDeSens: TfoAnaliseDeSens
  Left = 438
  Top = 108
  Width = 250
  Height = 272
  Caption = ' Sensibility Analysis'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 12
    Width = 41
    Height = 13
    Caption = 'Variable:'
  end
  object Label2: TLabel
    Left = 18
    Top = 56
    Width = 57
    Height = 13
    Caption = 'Initial Value:'
  end
  object Label3: TLabel
    Left = 124
    Top = 56
    Width = 50
    Height = 13
    Caption = 'Increment:'
  end
  object Label4: TLabel
    Left = 18
    Top = 100
    Width = 81
    Height = 13
    Caption = 'Simulation count:'
  end
  object Label5: TLabel
    Left = 19
    Top = 144
    Width = 85
    Height = 13
    Caption = 'Decision Variable:'
  end
  object Bevel1: TBevel
    Left = 20
    Top = 189
    Width = 201
    Height = 5
    Shape = bsBottomLine
  end
  object cbV: TComboBox
    Left = 18
    Top = 26
    Width = 204
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Base Yield (kg/ha)'
      'Cultivated Area (ha)'
      'Net Income (%)'
      'Flow Rate (m3/s)'
      'Pressure Head (mca)'
      'System Efficiency (%)'
      'Pumping Efficiency (%)'
      'Life (years)'
      'Interest Rate (%)'
      'Water Price ($/m3)'
      'Energy Price ($/kwh)'
      'Labor - Persons (persons/ha)'
      'Labor - Cost Hourly ($/h/persons)')
  end
  object edIV: TdrEdit
    Left = 18
    Top = 70
    Width = 96
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 1
    Text = '60'
  end
  object edI: TdrEdit
    Left = 124
    Top = 70
    Width = 96
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 2
    Text = '10'
  end
  object edSC: TdrEdit
    Left = 18
    Top = 114
    Width = 202
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 3
    Text = '5'
  end
  object cbDV: TComboBox
    Left = 19
    Top = 158
    Width = 203
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'MEDIA of Liquid Profit ($/ha)'
      'STDDV of Liquid Profit ($/ha)'
      'Limit Prod. for Revenue (kg/ha)')
  end
  object btnSim: TButton
    Left = 20
    Top = 207
    Width = 98
    Height = 25
    Caption = 'Simulate'
    TabOrder = 5
    OnClick = btnSimClick
  end
  object btnClose: TButton
    Left = 123
    Top = 207
    Width = 98
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = btnCloseClick
  end
end

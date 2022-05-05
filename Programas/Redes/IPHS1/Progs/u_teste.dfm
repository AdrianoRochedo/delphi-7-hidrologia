object Form2: TForm2
  Left = 182
  Top = 127
  Width = 564
  Height = 397
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gauge: TTrackBar
    Left = 16
    Top = 338
    Width = 309
    Height = 31
    Max = 100
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = gaugeChange
  end
  object Button1: TButton
    Left = 346
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object e: TdrEdit
    Left = 430
    Top = 338
    Width = 121
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 2
    Text = '30'
  end
end

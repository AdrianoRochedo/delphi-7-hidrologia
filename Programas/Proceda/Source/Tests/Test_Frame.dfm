object TestFrame: TTestFrame
  Left = 288
  Top = 73
  BorderStyle = bsDialog
  Caption = ' An'#225'lise de per'#237'odos'
  ClientHeight = 485
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 11
    Top = 435
    Width = 453
    Height = 5
    Shape = bsBottomLine
  end
  inline frame: TfrIntervalsOfStations
    Left = 6
    Top = 6
    Width = 465
    Height = 432
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 356
    Top = 450
    Width = 109
    Height = 25
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 1
  end
end

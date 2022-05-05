object Form1: TForm1
  Left = 15
  Top = 92
  BorderStyle = bsDialog
  Caption = ' MPS Conversor'
  ClientHeight = 495
  ClientWidth = 967
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object laProgresso: TLabel
    Left = 7
    Top = 437
    Width = 113
    Height = 13
    Caption = 'Progresso da opera'#231#227'o:'
  end
  object inMemo: TMemo
    Left = 7
    Top = 29
    Width = 474
    Height = 366
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '! teste'
      'MIN'
      'FO) A + B + C'
      'ST'
      'E1) A + B = 2'
      'E2) C = 5'
      'E3) A + C = 7'
      'E4) C - B = 4'
      'END')
    ParentFont = False
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 6
    Top = 404
    Width = 951
    Height = 25
    Caption = 'Convert to MPS'
    TabOrder = 1
    OnClick = Button1Click
  end
  object outMemo: TMemo
    Left = 486
    Top = 8
    Width = 475
    Height = 387
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    WordWrap = False
  end
  object p1: TProgressBar
    Left = 7
    Top = 454
    Width = 952
    Height = 16
    TabOrder = 3
  end
  object p2: TProgressBar
    Left = 7
    Top = 473
    Width = 952
    Height = 16
    TabOrder = 4
  end
  object cbOpt: TCheckBox
    Left = 8
    Top = 7
    Width = 97
    Height = 17
    Caption = 'Optimize'
    TabOrder = 5
  end
end

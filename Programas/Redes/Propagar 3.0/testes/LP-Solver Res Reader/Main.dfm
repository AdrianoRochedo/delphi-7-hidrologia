object foMain: TfoMain
  Left = 111
  Top = 140
  Width = 828
  Height = 480
  Caption = ' LP-Solver Res Reader'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 14
    Top = 7
    Width = 192
    Height = 25
    Caption = 'Ler resultados'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo: TRichEdit
    Left = 14
    Top = 32
    Width = 794
    Height = 405
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end

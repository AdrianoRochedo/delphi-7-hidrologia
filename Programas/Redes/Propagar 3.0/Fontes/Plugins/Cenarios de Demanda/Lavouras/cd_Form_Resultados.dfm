object foResultados: TfoResultados
  Left = 132
  Top = 88
  Width = 599
  Height = 333
  BorderWidth = 3
  Caption = ' Results'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Saida: TMemo
    Left = 0
    Top = 17
    Width = 585
    Height = 283
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 585
    Height = 17
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = 'Data:'
    TabOrder = 1
  end
end

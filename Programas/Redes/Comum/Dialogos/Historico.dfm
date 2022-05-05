object Form_Historico: TForm_Historico
  Left = 23
  Top = 53
  Width = 750
  Height = 448
  Caption = ' Hist'#243'rico'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 742
    Height = 385
    Align = alClient
    Anchors = [akLeft, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 385
    Width = 742
    Height = 35
    Align = alBottom
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      742
      35)
    object Button1: TButton
      Left = 469
      Top = 5
      Width = 268
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end

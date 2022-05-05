object iphs1_Form_Dialogo_VazaoCont: Tiphs1_Form_Dialogo_VazaoCont
  Left = 54
  Top = 89
  Width = 696
  Height = 419
  Caption = 'iphs1_Form_Dialogo_VazaoCont'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 206
    Width = 688
    Height = 4
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 688
    Height = 177
    Align = alTop
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 344
      Top = 1
      Width = 4
      Height = 175
      Cursor = crHSplit
    end
    object QQV: TChart
      Left = 1
      Top = 1
      Width = 343
      Height = 175
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BottomWall.Brush.Color = clScrollBar
      Foot.Brush.Color = clScrollBar
      Foot.Color = clScrollBar
      LeftWall.Brush.Color = clScrollBar
      Title.Brush.Color = clScrollBar
      Title.Color = clScrollBar
      Title.Text.Strings = (
        'TChart')
      BackColor = clScrollBar
      BottomAxis.Title.Caption = 'Volume'
      LeftAxis.Title.Caption = 'QLim / QMax'
      Legend.Brush.Color = clScrollBar
      Align = alLeft
      PopupMenu = MenuQQV
      TabOrder = 0
    end
    object QQA: TChart
      Left = 348
      Top = 1
      Width = 339
      Height = 175
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BottomWall.Brush.Color = clScrollBar
      Foot.Brush.Color = clScrollBar
      Foot.Color = clScrollBar
      LeftWall.Brush.Color = clScrollBar
      Title.Brush.Color = clScrollBar
      Title.Color = clScrollBar
      Title.Text.Strings = (
        'TChart')
      BackColor = clScrollBar
      BottomAxis.Title.Caption = #193'rea necess'#225'ria considerando um reservat'#243'rio de h=2m'
      LeftAxis.Title.Caption = 'QLim / QMax'
      Legend.Brush.Color = clScrollBar
      Align = alClient
      PopupMenu = MenuQQA
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 210
    Width = 688
    Height = 182
    Align = alClient
    TabOrder = 1
    object Splitter3: TSplitter
      Left = 344
      Top = 1
      Width = 4
      Height = 180
      Cursor = crHSplit
    end
    object QV: TChart
      Left = 1
      Top = 1
      Width = 343
      Height = 180
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BottomWall.Brush.Color = clScrollBar
      Foot.Brush.Color = clScrollBar
      Foot.Color = clScrollBar
      LeftWall.Brush.Color = clScrollBar
      Title.Brush.Color = clScrollBar
      Title.Color = clScrollBar
      Title.Text.Strings = (
        'TChart')
      BackColor = clScrollBar
      BottomAxis.Title.Caption = 'Volume'
      LeftAxis.Title.Caption = 'QLim'
      Legend.Brush.Color = clScrollBar
      Align = alLeft
      PopupMenu = MenuQV
      TabOrder = 0
    end
    object QA: TChart
      Left = 348
      Top = 1
      Width = 339
      Height = 180
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BottomWall.Brush.Color = clScrollBar
      Foot.Brush.Color = clScrollBar
      Foot.Color = clScrollBar
      LeftWall.Brush.Color = clScrollBar
      Title.Brush.Color = clScrollBar
      Title.Color = clScrollBar
      Title.Text.Strings = (
        'TChart')
      BackColor = clScrollBar
      BottomAxis.Title.Caption = #193'rea necess'#225'ria considerando um reservat'#243'rio de h=2m'
      LeftAxis.Title.Caption = 'QLim'
      Legend.Brush.Color = clScrollBar
      Align = alClient
      PopupMenu = MenuQA
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 29
    Align = alTop
    Caption = 
      'Os valores apresentados s'#227'o aproximados e dependem das estrutura' +
      's de entrada e sa'#237'da'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object MenuQQV: TPopupMenu
    Left = 69
    Top = 53
    object MenuCopiar: TMenuItem
      Caption = 'Copiar'
      OnClick = MenuCopiarClick
    end
  end
  object MenuQQA: TPopupMenu
    Left = 411
    Top = 47
    object MenuItem1: TMenuItem
      Caption = 'Copiar'
      OnClick = MenuItem1Click
    end
  end
  object MenuQV: TPopupMenu
    Left = 56
    Top = 265
    object MenuItem2: TMenuItem
      Caption = 'Copiar'
      OnClick = MenuItem2Click
    end
  end
  object MenuQA: TPopupMenu
    Left = 407
    Top = 263
    object MenuItem3: TMenuItem
      Caption = 'Copiar'
      OnClick = MenuItem3Click
    end
  end
end

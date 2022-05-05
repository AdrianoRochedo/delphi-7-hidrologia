object foMain: TfoMain
  Left = 248
  Top = 148
  Width = 695
  Height = 450
  Caption = ' Conversor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    687
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 7
    Width = 59
    Height = 13
    Caption = 'Linha Inicial:'
  end
  object Label2: TLabel
    Left = 100
    Top = 7
    Width = 54
    Height = 13
    Caption = 'Linha Final:'
  end
  inline frPlanilha: TSpreadSheetBookFrame
    Left = 9
    Top = 48
    Width = 670
    Height = 360
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    inherited SS: TcxSpreadSheetBook
      Width = 670
      Height = 360
    end
  end
  object edLI: TdrEdit
    Left = 10
    Top = 21
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 1
    Text = '2'
  end
  object edLF: TdrEdit
    Left = 100
    Top = 21
    Width = 83
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 2
    Text = '143'
  end
  object btnConverter: TButton
    Left = 190
    Top = 21
    Width = 121
    Height = 21
    Caption = 'Converter'
    TabOrder = 3
    OnClick = btnConverterClick
  end
end

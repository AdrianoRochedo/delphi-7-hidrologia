object foSeries_LinearModel: TfoSeries_LinearModel
  Left = 357
  Top = 177
  BorderStyle = bsDialog
  Caption = ' C'#225'lculo dos Coeficientes de Correla'#231#227'o'
  ClientHeight = 198
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 10
    Top = 11
    Width = 46
    Height = 13
    Caption = 'Vari'#225'veis:'
  end
  object Label8: TLabel
    Left = 10
    Top = 150
    Width = 38
    Height = 13
    Caption = 'Modelo:'
  end
  object lbVars: TListBox
    Left = 10
    Top = 25
    Width = 253
    Height = 114
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnDblClick = lbVarsDblClick
  end
  object edM: TEdit
    Left = 10
    Top = 164
    Width = 253
    Height = 21
    Hint = ' Ex: A = B + C'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btnCalcular: TButton
    Left = 277
    Top = 25
    Width = 97
    Height = 25
    Caption = 'Calcular'
    TabOrder = 2
    OnClick = btnCalcular_Click
  end
  object btnFechar: TButton
    Left = 277
    Top = 54
    Width = 97
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = btnFechar_Click
  end
end

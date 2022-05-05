object foDefineDates: TfoDefineDates
  Left = 302
  Top = 234
  BorderStyle = bsDialog
  Caption = ' Datas'
  ClientHeight = 95
  ClientWidth = 219
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
    Left = 9
    Top = 47
    Width = 199
    Height = 8
    Shape = bsBottomLine
  end
  inline frDates: TfrDates
    Left = 2
    Top = 3
    Width = 214
    Height = 50
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 9
    Top = 63
    Width = 75
    Height = 22
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 89
    Top = 63
    Width = 75
    Height = 22
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end

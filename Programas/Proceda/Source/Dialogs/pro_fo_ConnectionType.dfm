object foConnectionType: TfoConnectionType
  Left = 315
  Top = 160
  BorderStyle = bsDialog
  Caption = ' Conec'#231#227'o'
  ClientHeight = 127
  ClientWidth = 154
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 10
    Top = 46
    Width = 131
    Height = 9
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 9
    Top = 7
    Width = 24
    Height = 13
    Caption = 'Tipo:'
  end
  object btnOK: TButton
    Left = 10
    Top = 64
    Width = 131
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 10
    Top = 88
    Width = 131
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object cbCT: TComboBox
    Left = 11
    Top = 22
    Width = 132
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    Sorted = True
    TabOrder = 2
    Text = 'Access'
    Items.Strings = (
      'Access'
      'Paradox\DBase')
  end
end

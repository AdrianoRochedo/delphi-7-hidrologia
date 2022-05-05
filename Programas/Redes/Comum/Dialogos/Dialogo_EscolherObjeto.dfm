object DialogoEscolherObjeto: TDialogoEscolherObjeto
  Left = 402
  Top = 73
  BorderStyle = bsDialog
  Caption = ' Escolha um Objeto'
  ClientHeight = 312
  ClientWidth = 191
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Objetos:'
  end
  object lbObjetos: TListBox
    Left = 6
    Top = 22
    Width = 177
    Height = 247
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 6
    Top = 279
    Width = 87
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancelat: TButton
    Left = 96
    Top = 279
    Width = 87
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end

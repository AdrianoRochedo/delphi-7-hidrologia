object foDados: TfoDados
  Left = 109
  Top = 85
  BorderStyle = bsDialog
  Caption = ' Dados'
  ClientHeight = 212
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnFechar: TButton
    Left = 458
    Top = 38
    Width = 118
    Height = 30
    Caption = 'Fechar'
    TabOrder = 0
    OnClick = btnFecharClick
  end
  object btnTransferir: TButton
    Left = 458
    Top = 108
    Width = 118
    Height = 30
    Caption = 'Transferir Dados ...'
    TabOrder = 1
    Visible = False
    OnClick = btnTransferirClick
  end
  object btnDG: TButton
    Left = 458
    Top = 9
    Width = 118
    Height = 29
    Caption = 'Dados Gerais ...'
    TabOrder = 2
    OnClick = btnDGClick
  end
end

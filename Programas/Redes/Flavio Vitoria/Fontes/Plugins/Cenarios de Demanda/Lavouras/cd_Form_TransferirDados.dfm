object foTransferirDados: TfoTransferirDados
  Left = 256
  Top = 115
  BorderStyle = bsDialog
  Caption = ' Transferir Dados'
  ClientHeight = 252
  ClientWidth = 377
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
    Left = 4
    Top = 5
    Width = 90
    Height = 13
    Caption = 'Dados a Transferir:'
  end
  object Label2: TLabel
    Left = 191
    Top = 5
    Width = 58
    Height = 13
    Caption = 'Receptores:'
  end
  object Bevel1: TBevel
    Left = 4
    Top = 213
    Width = 368
    Height = 8
    Shape = bsTopLine
  end
  object lb1: TCheckListBox
    Left = 4
    Top = 19
    Width = 181
    Height = 186
    ItemHeight = 13
    Items.Strings = (
      'Arquivo de Cultura'
      'Arquivos de Manejo'
      'Arquivos de Restri'#231#245'es'
      '...')
    TabOrder = 0
  end
  object lb2: TCheckListBox
    Left = 191
    Top = 19
    Width = 181
    Height = 186
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 4
    Top = 222
    Width = 181
    Height = 25
    Caption = 'Transferir'
    TabOrder = 2
  end
end

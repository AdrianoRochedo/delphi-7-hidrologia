object Form_Dialogo_Projeto_RU: TForm_Dialogo_Projeto_RU
  Left = 91
  Top = 130
  Width = 593
  Height = 122
  Caption = ' Rotinas do Usu'#225'rio'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edGeralUsuario: TEdit
    Left = 7
    Top = 32
    Width = 433
    Height = 21
    AutoSize = False
    ReadOnly = True
    TabOrder = 0
  end
  object Panel10: TPanel
    Left = 8
    Top = 11
    Width = 570
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rotina de uso geral (executada opcionalmente ap'#243's a simula'#231#227'o)'
    TabOrder = 1
  end
  object b1: TButton
    Left = 439
    Top = 31
    Width = 23
    Height = 23
    Caption = '...'
    TabOrder = 2
    OnClick = escolherArquivo_Click
  end
  object b11: TButton
    Left = 461
    Top = 31
    Width = 59
    Height = 23
    Caption = 'Editar'
    TabOrder = 3
    OnClick = editar_Click
  end
  object btnOk: TBitBtn
    Left = 7
    Top = 63
    Width = 89
    Height = 25
    Caption = '&Ok'
    TabOrder = 4
    OnClick = btnOkClick
  end
  object b111: TButton
    Left = 519
    Top = 31
    Width = 59
    Height = 23
    Caption = 'Limpar'
    TabOrder = 5
    OnClick = Limpar_Click
  end
end

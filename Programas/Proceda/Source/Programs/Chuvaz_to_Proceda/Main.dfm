object foMain: TfoMain
  Left = 206
  Top = 169
  BorderStyle = bsDialog
  Caption = ' Conversor Chuvaz-Proceda'
  ClientHeight = 160
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 8
    Width = 118
    Height = 13
    Caption = 'Arquivo a ser convertido:'
  end
  object btnNome: TSpeedButton
    Left = 418
    Top = 22
    Width = 23
    Height = 21
    Caption = '...'
    OnClick = btnNomeClick
  end
  object L1: TLabel
    Left = 7
    Top = 49
    Width = 413
    Height = 13
    Caption = 
      'O arquivo ser'#225' salvo na mesma pasta do arquivo de origem com a e' +
      'xtens'#227'o "Proceda".'
  end
  object Info: TLabel
    Left = 8
    Top = 81
    Width = 113
    Height = 13
    Caption = 'Progresso da opera'#231#227'o:'
  end
  object edNome: TEdit
    Left = 7
    Top = 22
    Width = 410
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object PB: TProgressBar
    Left = 9
    Top = 96
    Width = 430
    Height = 16
    TabOrder = 1
  end
  object btnConverter: TButton
    Left = 326
    Top = 125
    Width = 113
    Height = 25
    Caption = 'Converter'
    TabOrder = 2
    OnClick = btnConverterClick
  end
  object T: TTable
    Left = 407
    Top = 52
  end
end

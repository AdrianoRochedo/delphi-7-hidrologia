object foInsertStation: TfoInsertStation
  Left = 126
  Top = 128
  BorderStyle = bsDialog
  Caption = ' Inserir Postos'
  ClientHeight = 255
  ClientWidth = 605
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
    Left = 6
    Top = 7
    Width = 82
    Height = 13
    Caption = 'Inserir postos em:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object laProg: TLabel
    Left = 166
    Top = 220
    Width = 30
    Height = 13
    Caption = 'laProg'
    Visible = False
  end
  object btnOk: TBitBtn
    Left = 6
    Top = 221
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancelar: TBitBtn
    Left = 84
    Top = 221
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object paInfo: TPanel
    Left = 6
    Top = 22
    Width = 593
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 50
    Width = 593
    Height = 161
    Caption = ' Origem dos dados: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label2: TLabel
      Left = 12
      Top = 18
      Width = 84
      Height = 13
      Caption = 'Nome do arquivo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbOrigem: TSpeedButton
      Left = 558
      Top = 33
      Width = 23
      Height = 21
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = sbOrigemClick
    end
    object Label3: TLabel
      Left = 11
      Top = 61
      Width = 100
      Height = 13
      Caption = 'Postos selecionados:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object paOrigem: TPanel
      Left = 12
      Top = 33
      Width = 542
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object lbPostos: TListBox
      Left = 11
      Top = 76
      Width = 569
      Height = 73
      Hint = 'Selecione os postos que ser'#227'o inseridos no conjunto selecionado'
      Columns = 2
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object Prog: TProgressBar
    Left = 167
    Top = 234
    Width = 431
    Height = 12
    Min = 1
    Position = 1
    TabOrder = 4
    Visible = False
  end
end

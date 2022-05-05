object foDataImport: TfoDataImport
  Left = 123
  Top = 17
  BorderStyle = bsDialog
  Caption = ' Importar'
  ClientHeight = 497
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 5
    Top = 230
    Width = 94
    Height = 13
    Caption = 'Arquivos a Importar:'
  end
  object Label6: TLabel
    Left = 5
    Top = 349
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object Label1: TLabel
    Left = 5
    Top = 5
    Width = 114
    Height = 13
    Caption = 'M'#243'dulos de Importa'#231#227'o:'
  end
  object Label2: TLabel
    Left = 5
    Top = 125
    Width = 145
    Height = 13
    Caption = 'Propriedades do M'#243'dulo Ativo:'
  end
  object Messages: TRichEdit
    Left = 5
    Top = 364
    Width = 566
    Height = 96
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 8
    WordWrap = False
  end
  object btnImport: TButton
    Left = 5
    Top = 468
    Width = 112
    Height = 23
    Caption = 'Importar'
    TabOrder = 9
    OnClick = btnImportClick
  end
  object PB: TProgressBar
    Left = 44
    Top = 347
    Width = 527
    Height = 16
    BorderWidth = 1
    TabOrder = 3
  end
  object lbArquivos: TListBox
    Left = 5
    Top = 245
    Width = 465
    Height = 101
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 2
  end
  object btnAdicionar: TButton
    Left = 476
    Top = 245
    Width = 95
    Height = 23
    Caption = '&Selecionar'
    TabOrder = 4
    OnClick = btnAdicionarClick
  end
  object btnRemover: TButton
    Left = 476
    Top = 271
    Width = 95
    Height = 23
    Caption = '&Remover'
    TabOrder = 5
    OnClick = btnRemoverClick
  end
  object btnVisualizar: TButton
    Left = 476
    Top = 297
    Width = 95
    Height = 23
    Caption = '&Visualizar'
    Enabled = False
    TabOrder = 6
  end
  object btnLimpar: TButton
    Left = 476
    Top = 323
    Width = 95
    Height = 23
    Caption = '&Limpar'
    TabOrder = 7
    OnClick = btnLimparClick
  end
  object lbPlugins: TListBox
    Left = 5
    Top = 19
    Width = 565
    Height = 101
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnClick = lbPluginsClick
  end
  object Props: TValueListEditor
    Left = 5
    Top = 140
    Width = 566
    Height = 86
    FixedColor = clActiveBorder
    FixedCols = 1
    ScrollBars = ssVertical
    Strings.Strings = (
      '=')
    TabOrder = 1
    TitleCaptions.Strings = (
      'Propriedade'
      'Valor')
    OnDrawCell = PropsDrawCell
    ColWidths = (
      150
      410)
  end
  object btnFechar: TButton
    Left = 121
    Top = 468
    Width = 112
    Height = 23
    Caption = 'Fechar'
    TabOrder = 10
    OnClick = btnFecharClick
  end
  object Open: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 12
    Top = 251
  end
end

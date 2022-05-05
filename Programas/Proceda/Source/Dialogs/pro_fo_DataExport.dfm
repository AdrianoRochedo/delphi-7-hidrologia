object foDataExport: TfoDataExport
  Left = 136
  Top = 34
  BorderStyle = bsDialog
  Caption = ' Exportar'
  ClientHeight = 427
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
  object Label6: TLabel
    Left = 5
    Top = 280
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object Label1: TLabel
    Left = 5
    Top = 51
    Width = 115
    Height = 13
    Caption = 'M'#243'dulos de Exporta'#231#227'o:'
  end
  object Label2: TLabel
    Left = 5
    Top = 173
    Width = 145
    Height = 13
    Caption = 'Propriedades do M'#243'dulo Ativo:'
  end
  object Label3: TLabel
    Left = 5
    Top = 8
    Width = 152
    Height = 13
    Caption = 'Conjunto de dados selecionado:'
  end
  object Messages: TRichEdit
    Left = 5
    Top = 295
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
    TabOrder = 3
    WordWrap = False
  end
  object btnExport: TButton
    Left = 5
    Top = 399
    Width = 112
    Height = 23
    Caption = 'Exportar'
    TabOrder = 4
    OnClick = btnExportClick
  end
  object PB: TProgressBar
    Left = 44
    Top = 278
    Width = 527
    Height = 16
    BorderWidth = 1
    TabOrder = 2
  end
  object lbPlugins: TListBox
    Left = 5
    Top = 65
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
    Top = 188
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
    Top = 399
    Width = 112
    Height = 23
    Caption = 'Fechar'
    TabOrder = 5
    OnClick = btnFecharClick
  end
  object paInfo: TPanel
    Left = 6
    Top = 23
    Width = 564
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 6
  end
end

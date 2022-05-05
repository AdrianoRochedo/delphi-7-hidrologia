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
  object sb2: TSpeedButton
    Tag = 1
    Left = 204
    Top = 100
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb3: TSpeedButton
    Tag = 2
    Left = 426
    Top = 99
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb4: TSpeedButton
    Tag = 3
    Left = 204
    Top = 142
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb5: TSpeedButton
    Tag = 4
    Left = 426
    Top = 141
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb6: TSpeedButton
    Tag = 5
    Left = 426
    Top = 183
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object btnFechar: TButton
    Left = 458
    Top = 38
    Width = 118
    Height = 30
    Caption = 'Fechar'
    TabOrder = 6
    OnClick = btnFecharClick
  end
  object edC: TEdit
    Left = 7
    Top = 99
    Width = 198
    Height = 21
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 7
    Top = 78
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Cultura (*.cul)'
    TabOrder = 9
  end
  object edS: TEdit
    Left = 227
    Top = 99
    Width = 199
    Height = 21
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 228
    Top = 78
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Solo (*.sol)'
    TabOrder = 8
  end
  object edP: TEdit
    Left = 7
    Top = 141
    Width = 198
    Height = 21
    TabOrder = 3
  end
  object Panel4: TPanel
    Left = 7
    Top = 120
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Precipita'#231#227'o (*.pre)'
    TabOrder = 11
  end
  object edE: TEdit
    Left = 227
    Top = 141
    Width = 199
    Height = 21
    TabOrder = 4
  end
  object Panel5: TPanel
    Left = 228
    Top = 120
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Evapotranspira'#231#227'o (*.et0)'
    TabOrder = 10
  end
  object edA: TEdit
    Left = 7
    Top = 183
    Width = 420
    Height = 21
    TabOrder = 5
  end
  object Panel8: TPanel
    Left = 7
    Top = 162
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Ascen'#231#227'o Capilar (*.asc)'
    TabOrder = 13
  end
  object edPasta: TEdit
    Left = 6
    Top = 57
    Width = 444
    Height = 21
    Color = clSilver
    ReadOnly = True
    TabOrder = 0
  end
  object Panel12: TPanel
    Left = 7
    Top = 36
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Diret'#243'rio do Projeto:'
    TabOrder = 12
  end
  object Panel13: TPanel
    Left = 7
    Top = 9
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivos:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object btnTransferir: TButton
    Left = 458
    Top = 108
    Width = 118
    Height = 30
    Caption = 'Transferir Dados ...'
    TabOrder = 14
    Visible = False
    OnClick = btnTransferirClick
  end
  object btnDG: TButton
    Left = 458
    Top = 9
    Width = 118
    Height = 29
    Caption = 'Dados Gerais ...'
    TabOrder = 15
    OnClick = btnDGClick
  end
  object Open: TOpenDialog
    Left = 376
    Top = 7
  end
end

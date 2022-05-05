object foSimular: TfoSimular
  Left = 127
  Top = 11
  BorderStyle = bsDialog
  Caption = ' Dados e Simula'#231#227'o (Isareg)'
  ClientHeight = 493
  ClientWidth = 576
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
    Left = 201
    Top = 96
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb3: TSpeedButton
    Tag = 2
    Left = 423
    Top = 95
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb4: TSpeedButton
    Tag = 3
    Left = 201
    Top = 138
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb5: TSpeedButton
    Tag = 4
    Left = 423
    Top = 137
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object sb6: TSpeedButton
    Tag = 5
    Left = 423
    Top = 179
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivo_Click
  end
  object btnOk: TButton
    Left = 453
    Top = 34
    Width = 118
    Height = 30
    Caption = 'Simular'
    TabOrder = 12
    OnClick = btnOkClick
  end
  object m: TMemo
    Left = 4
    Top = 376
    Width = 566
    Height = 112
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 14
  end
  object btnFechar: TButton
    Left = 453
    Top = 64
    Width = 118
    Height = 30
    Caption = 'Fechar'
    TabOrder = 13
    OnClick = btnFecharClick
  end
  object edC: TEdit
    Left = 4
    Top = 95
    Width = 198
    Height = 21
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 4
    Top = 74
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Cultura (*.cul)'
    TabOrder = 18
  end
  object edS: TEdit
    Left = 224
    Top = 95
    Width = 199
    Height = 21
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 225
    Top = 74
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Solo (*.sol)'
    TabOrder = 17
  end
  object edP: TEdit
    Left = 4
    Top = 137
    Width = 198
    Height = 21
    TabOrder = 3
  end
  object Panel4: TPanel
    Left = 4
    Top = 116
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Precipita'#231#227'o (*.pre)'
    TabOrder = 20
  end
  object edE: TEdit
    Left = 224
    Top = 137
    Width = 199
    Height = 21
    TabOrder = 4
  end
  object Panel5: TPanel
    Left = 225
    Top = 116
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Evapotranspira'#231#227'o (*.et0)'
    TabOrder = 19
  end
  object Panel6: TPanel
    Left = 4
    Top = 200
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Manejo (*.esq)'
    TabOrder = 23
  end
  object Panel7: TPanel
    Left = 225
    Top = 200
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Restri'#231#245'es (*.res)'
    TabOrder = 22
  end
  object edA: TEdit
    Left = 4
    Top = 179
    Width = 420
    Height = 21
    TabOrder = 5
  end
  object Panel8: TPanel
    Left = 4
    Top = 158
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Ascen'#231#227'o Capilar (*.asc)'
    TabOrder = 24
  end
  object edPasta: TEdit
    Left = 3
    Top = 53
    Width = 444
    Height = 21
    Color = clSilver
    ReadOnly = True
    TabOrder = 0
  end
  object Panel12: TPanel
    Left = 4
    Top = 32
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Diret'#243'rio do Projeto:'
    TabOrder = 21
  end
  object clMan: TCheckListBox
    Left = 4
    Top = 222
    Width = 221
    Height = 102
    OnClickCheck = ClickCheck
    ItemHeight = 13
    TabOrder = 6
  end
  object clRes: TCheckListBox
    Left = 224
    Top = 222
    Width = 223
    Height = 102
    OnClickCheck = ClickCheck
    ItemHeight = 13
    TabOrder = 7
  end
  object btnAddMan: TButton
    Left = 4
    Top = 324
    Width = 111
    Height = 19
    Caption = 'Adicionar'
    TabOrder = 8
    OnClick = btnAddManClick
  end
  object btnRemMan: TButton
    Left = 114
    Top = 324
    Width = 112
    Height = 19
    Caption = 'Remover'
    TabOrder = 9
    OnClick = btnRemManClick
  end
  object btnAddRes: TButton
    Left = 226
    Top = 324
    Width = 111
    Height = 19
    Caption = 'Adicionar'
    TabOrder = 10
    OnClick = btnAddResClick
  end
  object btnRemRes: TButton
    Left = 336
    Top = 324
    Width = 111
    Height = 19
    Caption = 'Remover'
    TabOrder = 11
    OnClick = btnRemResClick
  end
  object Panel13: TPanel
    Left = 4
    Top = 5
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
    TabOrder = 15
  end
  object Panel14: TPanel
    Left = 4
    Top = 349
    Width = 565
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Mensagens:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
  end
  object btnTransferir: TButton
    Left = 453
    Top = 104
    Width = 118
    Height = 30
    Caption = 'Transferir Dados ...'
    TabOrder = 25
    Visible = False
    OnClick = btnTransferirClick
  end
  object btnDG: TButton
    Left = 453
    Top = 5
    Width = 118
    Height = 29
    Caption = 'Dados Gerais ...'
    TabOrder = 26
    OnClick = btnDGClick
  end
  object Open: TOpenDialog
    Left = 351
    Top = 242
  end
end

object Moldura: TMoldura
  Left = 0
  Top = 0
  Width = 444
  Height = 351
  AutoScroll = False
  BiDiMode = bdLeftToRight
  Ctl3D = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentBiDiMode = False
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  TabStop = True
  object sb2: TSpeedButton
    Tag = 1
    Left = 197
    Top = 122
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivos_Click
  end
  object sb3: TSpeedButton
    Tag = 2
    Left = 419
    Top = 121
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivos_Click
  end
  object sb4: TSpeedButton
    Tag = 3
    Left = 197
    Top = 164
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivos_Click
  end
  object sb5: TSpeedButton
    Tag = 4
    Left = 419
    Top = 163
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivos_Click
  end
  object sb6: TSpeedButton
    Tag = 5
    Left = 419
    Top = 205
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = Arquivos_Click
  end
  object sb1: TSpeedButton
    Left = 419
    Top = 80
    Width = 24
    Height = 20
    Caption = '...'
    OnClick = sb1Click
  end
  object edC: TEdit
    Left = 0
    Top = 121
    Width = 198
    Height = 21
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 100
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Cultura (*.cul)'
    TabOrder = 14
  end
  object edS: TEdit
    Left = 220
    Top = 121
    Width = 199
    Height = 21
    TabOrder = 4
  end
  object Panel2: TPanel
    Left = 221
    Top = 100
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Solo (*.sol)'
    TabOrder = 15
  end
  object edP: TEdit
    Left = 0
    Top = 163
    Width = 198
    Height = 21
    TabOrder = 5
  end
  object Panel3: TPanel
    Left = 0
    Top = 142
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Precipita'#231#227'o (*.pre)'
    TabOrder = 16
  end
  object edE: TEdit
    Left = 220
    Top = 163
    Width = 199
    Height = 21
    TabOrder = 6
  end
  object Panel4: TPanel
    Left = 221
    Top = 142
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Evapotranspira'#231#227'o (*.et0)'
    TabOrder = 17
  end
  object Panel5: TPanel
    Left = 0
    Top = 226
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Manejo (*.esq)'
    TabOrder = 18
  end
  object Panel6: TPanel
    Left = 221
    Top = 226
    Width = 222
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Restri'#231#245'es (*.res)'
    TabOrder = 19
  end
  object edA: TEdit
    Left = 0
    Top = 205
    Width = 420
    Height = 21
    TabOrder = 7
  end
  object Panel7: TPanel
    Left = 0
    Top = 184
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Arquivo de Ascen'#231#227'o Capilar (*.asc)'
    TabOrder = 20
  end
  object edPasta: TEdit
    Left = -1
    Top = 79
    Width = 420
    Height = 21
    TabOrder = 2
  end
  object Panel8: TPanel
    Left = 0
    Top = 58
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Diret'#243'rio dos Arquivos:'
    TabOrder = 21
  end
  object edAnos: TEdit
    Left = 0
    Top = 37
    Width = 90
    Height = 21
    TabOrder = 0
    OnExit = edAnosExit
  end
  object Panel9: TPanel
    Left = 1
    Top = 0
    Width = 89
    Height = 37
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Anos:'
    TabOrder = 22
  end
  object clMan: TCheckListBox
    Left = 0
    Top = 248
    Width = 221
    Height = 77
    OnClickCheck = ClickCheck
    ItemHeight = 13
    TabOrder = 8
  end
  object clRes: TCheckListBox
    Left = 220
    Top = 248
    Width = 223
    Height = 77
    OnClickCheck = ClickCheck
    ItemHeight = 13
    TabOrder = 11
  end
  object btnAddMan: TButton
    Left = 1
    Top = 325
    Width = 111
    Height = 19
    Caption = 'Adicionar'
    TabOrder = 9
    OnClick = btnAddManClick
  end
  object btnRemMan: TButton
    Left = 111
    Top = 325
    Width = 111
    Height = 19
    Caption = 'Remover'
    TabOrder = 10
    OnClick = btnRemManClick
  end
  object btnAddRes: TButton
    Left = 222
    Top = 325
    Width = 111
    Height = 19
    Caption = 'Adicionar'
    TabOrder = 12
    OnClick = btnAddResClick
  end
  object btnRemRes: TButton
    Left = 332
    Top = 325
    Width = 111
    Height = 19
    Caption = 'Remover'
    TabOrder = 13
    OnClick = btnRemResClick
  end
  object Panel10: TPanel
    Left = 90
    Top = 0
    Width = 353
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Rendimento da Cultura:'
    TabOrder = 23
  end
  object sgRC: TdrStringAlignGrid
    Left = 90
    Top = 20
    Width = 353
    Height = 37
    BorderStyle = bsNone
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 4
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ScrollBars = ssNone
    TabOrder = 1
    Alignment = alCenter
  end
  object Open: TOpenDialog
    Left = 32
    Top = 271
  end
end

object iphs1_Form_Dialogo_SB_TCV: Tiphs1_Form_Dialogo_SB_TCV
  Left = 269
  Top = 84
  BorderStyle = bsDialog
  Caption = ' Transforma'#231#227'o Chuva-Vaz'#227'o'
  ClientHeight = 396
  ClientWidth = 366
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
  object Panel1: TPanel
    Left = 5
    Top = 51
    Width = 355
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Postos de Chuva e Coeficientes de Thiessen:'
    TabOrder = 10
  end
  object Panel2: TPanel
    Left = 5
    Top = 142
    Width = 355
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Reordenar tormenta de projeto por blocos alternados ?'
    TabOrder = 11
  end
  object Panel_Tormenta: TPanel
    Left = 5
    Top = 163
    Width = 355
    Height = 34
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 4
    object sbReordenada: TSpeedButton
      Left = 204
      Top = 7
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbReordenadaClick
    end
    object rbNR: TRadioButton
      Left = 33
      Top = 9
      Width = 106
      Height = 17
      Caption = 'N'#227'o Reordenar'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbRClick
    end
    object rbR: TRadioButton
      Left = 242
      Top = 9
      Width = 98
      Height = 17
      Caption = 'Reordenar'
      TabOrder = 1
      OnClick = rbRClick
    end
  end
  object Panel4: TPanel
    Left = 5
    Top = 197
    Width = 149
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Separa'#231#227'o do Escoamento:'
    TabOrder = 12
  end
  object Panel_SE: TPanel
    Left = 5
    Top = 218
    Width = 149
    Height = 114
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 5
    object sbIPHII: TSpeedButton
      Left = 24
      Top = 7
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbIPHIIClick
    end
    object sbSCS: TSpeedButton
      Left = 24
      Top = 27
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbSCSClick
    end
    object sbHec: TSpeedButton
      Left = 24
      Top = 47
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbHecClick
    end
    object sbFI: TSpeedButton
      Left = 24
      Top = 67
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbFIClick
    end
    object sbHOLTAN: TSpeedButton
      Left = 24
      Top = 87
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbHOLTANClick
    end
    object rbIPHII: TRadioButton
      Left = 61
      Top = 9
      Width = 73
      Height = 17
      Caption = 'IPH II'
      TabOrder = 0
      OnClick = SE_Click
    end
    object rbSCS: TRadioButton
      Tag = 1
      Left = 61
      Top = 29
      Width = 73
      Height = 17
      Caption = 'SCS'
      TabOrder = 1
      OnClick = SE_Click
    end
    object rbHec: TRadioButton
      Tag = 2
      Left = 61
      Top = 49
      Width = 73
      Height = 17
      Caption = 'HEC1'
      TabOrder = 2
      OnClick = SE_Click
    end
    object rbFI: TRadioButton
      Tag = 3
      Left = 61
      Top = 69
      Width = 73
      Height = 17
      Caption = #205'ndice '#216
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = SE_Click
    end
    object rbHOLTAN: TRadioButton
      Tag = 4
      Left = 61
      Top = 89
      Width = 73
      Height = 17
      Caption = 'HOLTAN'
      TabOrder = 4
      OnClick = SE_Click
    end
  end
  object Panel6: TPanel
    Left = 154
    Top = 197
    Width = 206
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Propaga'#231#227'o do Escoamento Superficial:'
    TabOrder = 13
  end
  object Panel_ES: TPanel
    Left = 154
    Top = 218
    Width = 206
    Height = 114
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 6
    object sbHU: TSpeedButton
      Left = 6
      Top = 17
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbHUClick
    end
    object sbHT: TSpeedButton
      Left = 6
      Top = 37
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbHTClick
    end
    object sbHYMO: TSpeedButton
      Left = 6
      Top = 57
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbHYMOClick
    end
    object sbCLARK: TSpeedButton
      Left = 6
      Top = 77
      Width = 31
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbCLARKClick
    end
    object rbHU: TRadioButton
      Left = 43
      Top = 19
      Width = 127
      Height = 17
      Caption = 'HU dado (1mm, DT)'
      TabOrder = 0
      OnClick = ES_Click
    end
    object rbHT: TRadioButton
      Tag = 1
      Left = 43
      Top = 39
      Width = 157
      Height = 17
      Hint = 
        'Os dados deste m'#233'todo s'#243' tem import'#226'ncia se o'#13#10'Tempo de Concentr' +
        'a'#231#227'o n'#227'o for informado. '
      Caption = 'Hidrograma Triangular (SCS)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ES_Click
    end
    object rbHYMO: TRadioButton
      Tag = 2
      Left = 43
      Top = 59
      Width = 158
      Height = 17
      Caption = 'HYMO (Nash modificado)'
      TabOrder = 2
      OnClick = ES_Click
    end
    object rbCLARK: TRadioButton
      Tag = 3
      Left = 43
      Top = 79
      Width = 158
      Height = 17
      Caption = 'CLARK'
      TabOrder = 3
      OnClick = ES_Click
    end
  end
  object Panel_EB: TPanel
    Left = 5
    Top = 332
    Width = 355
    Height = 23
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Propagar Escoamento de Base ?'
    TabOrder = 7
    object sbPEB_S: TSpeedButton
      Left = 182
      Top = 2
      Width = 31
      Height = 19
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbPEB_SClick
    end
    object rbPEB_S: TRadioButton
      Left = 218
      Top = 3
      Width = 46
      Height = 17
      Caption = 'Sim'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbPEB_Click
    end
    object rbPEB_N: TRadioButton
      Left = 286
      Top = 3
      Width = 51
      Height = 17
      Caption = 'N'#227'o'
      TabOrder = 1
      OnClick = rbPEB_Click
    end
  end
  object Panel_Impressao: TPanel
    Left = 5
    Top = 407
    Width = 355
    Height = 31
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 8
    Visible = False
    object cbIR: TCheckBox
      Left = 5
      Top = 7
      Width = 299
      Height = 17
      Caption = ' Imprimir Tabela de Escoamento e Perdas'
      TabOrder = 0
    end
  end
  object btnCancelar: TBitBtn
    Left = 5
    Top = 364
    Width = 89
    Height = 25
    Caption = '&OK'
    TabOrder = 9
    OnClick = btnOKClick
  end
  object Panel_Tab: TPanel
    Left = 5
    Top = 72
    Width = 355
    Height = 67
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 3
  end
  object Panel11: TPanel
    Left = 125
    Top = 8
    Width = 235
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tempo de Concentra'#231#227'o (min):'
    TabOrder = 14
    object btnCalcularTC: TButton
      Left = 156
      Top = 2
      Width = 75
      Height = 19
      Caption = 'Calcular ...'
      TabOrder = 0
      OnClick = btnCalcularTCClick
    end
  end
  object Panel12: TPanel
    Left = 6
    Top = 8
    Width = 118
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' '#193'rea da Bacia (km'#178'):'
    TabOrder = 15
  end
  object BitBtn1: TBitBtn
    Left = 98
    Top = 364
    Width = 89
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 16
  end
  object TabPostos: TdrCheckBoxGrid
    Left = 4
    Top = 72
    Width = 356
    Height = 70
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 2
    DefaultRowHeight = 16
    FixedColor = clWindow
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goColMoving, goEditing]
    ScrollBars = ssVertical
    TabOrder = 2
    OnKeyPress = TabPostosKeyPress
    ColWidths = (
      281
      52)
    RowHeights = (
      16
      16
      16
      16)
  end
  object edAB: TdrEdit
    Left = 5
    Top = 30
    Width = 119
    Height = 22
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 0
  end
  object edTC: TdrEdit
    Left = 124
    Top = 30
    Width = 236
    Height = 22
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 1
    OnChange = edTCxChange
    OnExit = edTCExit
  end
end

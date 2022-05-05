object foStation_EditExtraData: TfoStation_EditExtraData
  Left = 144
  Top = 105
  Width = 547
  Height = 413
  Caption = ' Propriedades'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    539
    384)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 179
    Width = 88
    Height = 13
    Caption = 'Dados do Usu'#225'rio:'
  end
  object Label2: TLabel
    Left = 173
    Top = 7
    Width = 78
    Height = 13
    Caption = 'Tipo dos Dados:'
  end
  object Label3: TLabel
    Left = 359
    Top = 7
    Width = 43
    Height = 13
    Caption = 'Unidade:'
  end
  object Label4: TLabel
    Left = 6
    Top = 57
    Width = 61
    Height = 13
    Caption = 'Coment'#225'rios:'
  end
  object Label5: TLabel
    Left = 6
    Top = 7
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object Props: TValueListEditor
    Left = 7
    Top = 194
    Width = 430
    Height = 151
    Anchors = [akLeft, akTop, akRight, akBottom]
    FixedColor = clActiveBorder
    KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
    ScrollBars = ssVertical
    Strings.Strings = (
      '=')
    TabOrder = 6
    TitleCaptions.Strings = (
      'Propriedade'
      'Valor')
    OnDrawCell = PropsDrawCell
    ColWidths = (
      150
      274)
  end
  object btnAdd: TButton
    Left = 445
    Top = 194
    Width = 86
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Adicionar'
    TabOrder = 7
    OnClick = btnAddClick
  end
  object btnDel: TButton
    Left = 445
    Top = 223
    Width = 86
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Remover'
    TabOrder = 8
    OnClick = btnDelClick
  end
  object btnOk: TButton
    Left = 7
    Top = 353
    Width = 86
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    TabOrder = 9
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 97
    Top = 353
    Width = 86
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = 'Cancelar'
    TabOrder = 10
    OnClick = btnCancelClick
  end
  object cbTD: TComboBox
    Left = 174
    Top = 22
    Width = 182
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object btnTD: TButton
    Left = 174
    Top = 43
    Width = 180
    Height = 21
    Caption = 'Registrar Novo Tipo ...'
    TabOrder = 2
    OnClick = btnTDClick
  end
  object cbUN: TComboBox
    Left = 360
    Top = 22
    Width = 173
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
  end
  object btnUN: TButton
    Left = 360
    Top = 43
    Width = 171
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Registrar Novo Tipo ...'
    TabOrder = 4
    OnClick = btnUNClick
  end
  object mComent: TMemo
    Left = 7
    Top = 72
    Width = 525
    Height = 100
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
  end
  object edNome: TEdit
    Left = 7
    Top = 22
    Width = 162
    Height = 21
    TabOrder = 0
  end
end

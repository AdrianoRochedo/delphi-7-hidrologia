inherited ProjectDialog: TProjectDialog
  Left = 241
  Top = 199
  Caption = 'ProjectDialog'
  ClientHeight = 233
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Left = 5
    Top = 201
  end
  inherited btnCancelar: TBitBtn
    Left = 97
    Top = 201
  end
  object Panel10: TPanel
    Left = 6
    Top = 124
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Scripts:'
    TabOrder = 8
  end
  object lbScripts: TListBox
    Left = 5
    Top = 145
    Width = 370
    Height = 48
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 9
  end
  object btnAdicionarScript: TButton
    Left = 374
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Adicionar'
    TabOrder = 10
    OnClick = btnAdicionarScriptClick
  end
  object btnRemoverScript: TButton
    Left = 374
    Top = 169
    Width = 75
    Height = 25
    Caption = '&Remover'
    TabOrder = 11
    OnClick = btnRemoverScriptClick
  end
end

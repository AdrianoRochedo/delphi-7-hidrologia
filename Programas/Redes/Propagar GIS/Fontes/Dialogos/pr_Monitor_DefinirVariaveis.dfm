object DLG_DefinirVariaveis: TDLG_DefinirVariaveis
  Left = 175
  Top = 59
  BorderStyle = bsDialog
  Caption = ' Definir vari'#225'veis a serem monitoradas '
  ClientHeight = 394
  ClientWidth = 392
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
    Top = 6
    Width = 39
    Height = 13
    Caption = 'Objetos:'
  end
  object Label2: TLabel
    Left = 199
    Top = 6
    Width = 179
    Height = 13
    Caption = 'Vari'#225'veis que podem ser monitoradas:'
  end
  object Label3: TLabel
    Left = 199
    Top = 193
    Width = 156
    Height = 13
    Caption = 'Vari'#225'veis que ser'#227'o monitoradas:'
  end
  object Arvore: TTreeView
    Left = 6
    Top = 20
    Width = 185
    Height = 333
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnClick = ArvoreClick
    Items.Data = {
      01000000200000000000000000000000FFFFFFFFFFFFFFFF0000000002000000
      0750726F6A65746F1C0000000000000000000000FFFFFFFFFFFFFFFF00000000
      0000000003504373230000000000000000000000FFFFFFFFFFFFFFFF00000000
      000000000A5375622D426163696173}
  end
  object lb1: TListBox
    Left = 200
    Top = 20
    Width = 185
    Height = 135
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 1
  end
  object lb2: TListBox
    Left = 200
    Top = 207
    Width = 185
    Height = 118
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 2
  end
  object btnFechar: TButton
    Left = 6
    Top = 362
    Width = 185
    Height = 25
    Caption = '&Fechar'
    ModalResult = 1
    TabOrder = 3
  end
  object btnAdicionar: TBitBtn
    Left = 200
    Top = 158
    Width = 185
    Height = 25
    Caption = '&Adicionar'
    TabOrder = 4
    OnClick = btnAdicionarClick
  end
  object btnRemover: TBitBtn
    Left = 200
    Top = 328
    Width = 185
    Height = 25
    Caption = '&Remover'
    TabOrder = 5
    OnClick = btnRemoverClick
  end
end

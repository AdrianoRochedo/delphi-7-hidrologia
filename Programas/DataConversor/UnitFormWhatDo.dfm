object FormWhatToDo: TFormWhatToDo
  Left = 392
  Top = 307
  Width = 534
  Height = 506
  Caption = 'O que fazer'
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
    Left = 8
    Top = 72
    Width = 39
    Height = 13
    Caption = 'Tabela: '
  end
  object Label2: TLabel
    Left = 272
    Top = 72
    Width = 36
    Height = 13
    Caption = 'Campo:'
  end
  object Label3: TLabel
    Left = 8
    Top = 320
    Width = 55
    Height = 13
    Caption = 'Atribui'#231#245'es:'
  end
  object LEdFieldOld: TLabeledEdit
    Left = 8
    Top = 32
    Width = 249
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'Campo:'
    ReadOnly = True
    TabOrder = 0
  end
  object LEdValueOld: TLabeledEdit
    Left = 272
    Top = 32
    Width = 249
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Valor:'
    ReadOnly = True
    TabOrder = 1
  end
  object LBTables: TListBox
    Left = 8
    Top = 88
    Width = 249
    Height = 177
    ItemHeight = 13
    TabOrder = 2
  end
  object ListBox1: TListBox
    Left = 272
    Top = 88
    Width = 249
    Height = 177
    ItemHeight = 13
    TabOrder = 3
  end
  object LEdNewValue: TLabeledEdit
    Left = 8
    Top = 288
    Width = 433
    Height = 21
    EditLabel.Width = 55
    EditLabel.Height = 13
    EditLabel.Caption = 'Novo valor:'
    TabOrder = 4
  end
  object BtAply: TButton
    Left = 448
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Aplicar'
    TabOrder = 5
  end
end

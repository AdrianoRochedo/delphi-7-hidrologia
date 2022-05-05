inherited iphs1_Form_Dialogo_Projeto: Tiphs1_Form_Dialogo_Projeto
  Left = 222
  Top = 71
  Caption = ' Projeto'
  ClientHeight = 363
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Top = 332
  end
  inherited btnCancelar: TBitBtn
    Top = 332
  end
  inherited btnRotinas: TButton
    Top = 332
    Width = 258
    Caption = 'Rotinas do Usu'#225'rio'
  end
  inherited btnAdicionarScript: TButton
    Width = 74
  end
  inherited btnRemoverScript: TButton
    Width = 74
  end
  object Panel5: TPanel
    Left = 5
    Top = 192
    Width = 369
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' N'#250'mero de Intervalos de Tempo:'
    TabOrder = 13
  end
  object Panel3: TPanel
    Left = 5
    Top = 255
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Postos de Chuva:'
    TabOrder = 14
  end
  object lbPCs: TListBox
    Left = 4
    Top = 276
    Width = 370
    Height = 48
    Hint = 
      ' Utilize o bot'#227'o de fun'#231#245'es do Mouse para escolher o '#13#10'    tipo ' +
      'de Tormenta (Desagregada ou Acumulada)'
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    PopupMenu = Menu_Postos
    ShowHint = True
    TabOrder = 18
  end
  object btnAdicionarPC: TButton
    Left = 373
    Top = 275
    Width = 74
    Height = 25
    Caption = '&Adicionar'
    TabOrder = 19
    OnClick = btnAdicionarPCClick
  end
  object btnRemoverPC: TButton
    Left = 373
    Top = 300
    Width = 74
    Height = 25
    Caption = '&Remover'
    TabOrder = 20
    OnClick = btnRemoverPC_Click
  end
  object Panel4: TPanel
    Left = 5
    Top = 213
    Width = 369
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' N'#250'mero de Intervalos de Tempo com Chuva:'
    TabOrder = 22
  end
  object Panel6: TPanel
    Left = 5
    Top = 234
    Width = 369
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tamanho do Intervalo de Tempo (s):'
    TabOrder = 21
  end
  object edNIT: TdrEdit
    Left = 375
    Top = 192
    Width = 73
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    AutoSize = False
    TabOrder = 15
    Text = '0'
  end
  object edNITC: TdrEdit
    Left = 375
    Top = 213
    Width = 73
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    AutoSize = False
    TabOrder = 16
    Text = '0'
    OnChange = edNITCChange
  end
  object edTIT: TdrEdit
    Left = 375
    Top = 234
    Width = 73
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    AutoSize = False
    TabOrder = 17
    Text = '0'
  end
  object Menu_Postos: TPopupMenu
    Left = 264
    Top = 279
    object Menu1: TMenuItem
      Tag = 1
      Caption = 'Tormenta Desagregada (mm/AT)'
      OnClick = MenuPostos_Click
    end
    object Menu2: TMenuItem
      Tag = 2
      Caption = 'Tormenta  Acumulada (mm)'
      OnClick = MenuPostos_Click
    end
  end
  object Menu_DO: TPopupMenu
    Left = 34
    Top = 76
    object MenuDO_SelecionarArquivo: TMenuItem
      Caption = '&Selecionar Arquivo ...'
      OnClick = btnAdicionarPC_Click
    end
    object MenuDO_DigitarValores: TMenuItem
      Caption = '&Digitar Valores ...'
      OnClick = MenuDO_DigitarValoresClick
    end
    object Menu_IDF: TMenuItem
      Caption = 'Gerar Valores por uma IDF ...'
      OnClick = Menu_IDF_Click
    end
  end
end

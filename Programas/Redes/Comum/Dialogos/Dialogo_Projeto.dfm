inherited Form_Dialogo_Projeto: TForm_Dialogo_Projeto
  Left = 182
  Top = 33
  Caption = ' Dados do Projeto'
  ClientHeight = 233
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited edNome: TEdit
    AutoSize = False
  end
  inherited P1: TPanel
    TabOrder = 6
  end
  inherited edDescricao: TEdit
    AutoSize = False
    TabOrder = 1
  end
  inherited Panel1: TPanel
    TabOrder = 5
  end
  inherited Panel2: TPanel
    TabOrder = 7
  end
  inherited mComentarios: TMemo
    TabOrder = 2
  end
  inherited btnOk: TBitBtn
    Left = 5
    Top = 200
    TabOrder = 3
  end
  inherited btnCancelar: TBitBtn
    Left = 97
    Top = 200
    TabOrder = 4
  end
  object btnRotinas: TButton
    Left = 189
    Top = 200
    Width = 260
    Height = 25
    Caption = 'Rotinas gerias do usu'#225'rio'
    TabOrder = 8
    OnClick = btnRotinasClick
  end
  object Panel10: TPanel
    Left = 6
    Top = 123
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Scripts:'
    TabOrder = 9
  end
  object lbScripts: TListBox
    Left = 5
    Top = 144
    Width = 370
    Height = 48
    Hint = 
      ' Scripts associados a cada projeto. '#13#10' Os que est'#227'o referenciado' +
      's aqui s'#227'o acess'#237'veis via barra de scripts '#13#10' na barra de ferram' +
      'entas da janela principal.'
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
  end
  object btnAdicionarScript: TButton
    Left = 374
    Top = 143
    Width = 75
    Height = 25
    Caption = '&Adicionar'
    TabOrder = 11
    OnClick = btnAdicionarScriptClick
  end
  object btnRemoverScript: TButton
    Left = 374
    Top = 168
    Width = 75
    Height = 25
    Caption = '&Remover'
    TabOrder = 12
    OnClick = btnRemoverScriptClick
  end
end

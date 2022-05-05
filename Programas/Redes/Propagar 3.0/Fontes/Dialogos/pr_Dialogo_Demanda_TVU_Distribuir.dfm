inherited prDialogo_TVU_Distribuir: TprDialogo_TVU_Distribuir
  Left = 22
  Top = 77
  Caption = ' Distribui'#231#227'o de Demandas'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel [0]
    Left = 385
    Top = 284
    Width = 54
    Height = 13
    Caption = 'Demandas:'
  end
  inherited btnOk: TBitBtn
    Left = 651
    Top = 318
    Caption = '&Distribuir'
  end
  inherited btnCancelar: TBitBtn
    Left = 651
    Top = 347
    Caption = '&Fechar'
  end
  inherited btnImportar: TButton
    Left = 651
  end
  object lbDemandas: TCheckListBox [7]
    Left = 385
    Top = 298
    Width = 258
    Height = 74
    Hint = 
      '    Selecione as Demandas para quais voc'#234' '#13#10'         deseja atri' +
      'buir os valores unit'#225'rios.'#13#10#13#10'    Os '#237'tens que ficaram desabilit' +
      'ados indicam'#13#10' para quais demandas o usu'#225'rio enviou os dados.'#13#10#13 +
      #10'  Para habilit'#225'-los novamente d'#234' um Duplo-Click'#13#10'            co' +
      'm o mouse no '#237'tem desejado.'
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnDblClick = lbDemandasDblClick
  end
  inherited Open: TOpenDialog
    Left = 17
    Top = 224
  end
end

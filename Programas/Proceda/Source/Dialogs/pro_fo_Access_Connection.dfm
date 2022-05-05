inherited foAccess_Connection: TfoAccess_Connection
  Left = 228
  Top = 130
  Caption = ' Conec'#231#227'o Access'
  ClientHeight = 134
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 89
  end
  object Label2: TLabel [2]
    Left = 5
    Top = 49
    Width = 121
    Height = 13
    Caption = 'Nome do Arquivo (*.mdb):'
  end
  inherited btnOk: TButton
    Top = 103
  end
  inherited btnCancel: TButton
    Top = 103
  end
  object edFile: TdrEdit
    Left = 5
    Top = 63
    Width = 391
    Height = 21
    BeepOnError = False
    DataType = dtString
    TabOrder = 3
  end
  object btnProcurar: TButton
    Left = 397
    Top = 63
    Width = 72
    Height = 21
    Caption = 'Procurar ...'
    TabOrder = 4
    OnClick = btnProcurarClick
  end
end

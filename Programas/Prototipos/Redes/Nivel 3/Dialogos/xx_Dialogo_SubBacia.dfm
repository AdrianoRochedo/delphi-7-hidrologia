inherited xxDialogo_SubBacia: TxxDialogo_SubBacia
  Caption = 'xxDialogo_SubBacia'
  ClientHeight = 173
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Left = 188
    Top = 141
  end
  inherited btnCancelar: TBitBtn
    Left = 280
    Top = 141
  end
  object Panel1: TPanel
    Left = 5
    Top = 123
    Width = 150
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' '#193'rea:'
    TabOrder = 6
  end
  object edArea: TdrEdit
    Left = 5
    Top = 144
    Width = 150
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 7
  end
end

inherited prDialogo_Descarga: TprDialogo_Descarga
  Caption = 'prDialogo_Descarga'
  ClientHeight = 246
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Left = 5
    Top = 214
  end
  inherited btnCancelar: TBitBtn
    Left = 97
    Top = 214
  end
  object Panel3: TPanel
    Left = 6
    Top = 122
    Width = 145
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga de DBOC (kg):'
    TabOrder = 8
  end
  object edCargaDBOC: TdrEdit
    Left = 5
    Top = 143
    Width = 146
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 9
  end
  object Panel6: TPanel
    Left = 152
    Top = 122
    Width = 145
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga de DBON (kg):'
    TabOrder = 10
  end
  object edCargaDBON: TdrEdit
    Left = 151
    Top = 143
    Width = 146
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 11
  end
  object Panel7: TPanel
    Left = 298
    Top = 122
    Width = 150
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga em coliformes (un):'
    TabOrder = 12
  end
  object edCargaColif: TdrEdit
    Left = 297
    Top = 143
    Width = 151
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 13
  end
  object Panel4: TPanel
    Left = 6
    Top = 163
    Width = 220
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Concentra'#231#227'o de DBOC (kg/m3):'
    TabOrder = 14
  end
  object edConDBOC: TdrEdit
    Left = 5
    Top = 184
    Width = 221
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 15
  end
  object Panel5: TPanel
    Left = 227
    Top = 163
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Concentra'#231#227'o de DBON (kg/m3):'
    TabOrder = 16
  end
  object edConDBON: TdrEdit
    Left = 226
    Top = 184
    Width = 222
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 17
  end
end

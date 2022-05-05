inherited prDialogo_Descarga: TprDialogo_Descarga
  Left = 266
  Top = 89
  Caption = 'prDialogo_Descarga'
  ClientHeight = 328
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Top = 294
    TabOrder = 13
  end
  inherited btnCancelar: TBitBtn
    Top = 294
    TabOrder = 14
  end
  inherited Panel_Script: TPanel
    TabOrder = 21
  end
  inherited lbScripts: TListBox
    TabOrder = 6
  end
  inherited btnAdicionarScript: TButton
    TabOrder = 7
  end
  inherited btnRemoverScript: TButton
    TabOrder = 8
  end
  inherited btnEditar: TButton
    TabOrder = 22
  end
  object Panel3: TPanel
    Left = 6
    Top = 202
    Width = 145
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga de DBOC (kg):'
    TabOrder = 9
  end
  object edCargaDBOC: TdrEdit
    Left = 5
    Top = 223
    Width = 146
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 10
  end
  object Panel6: TPanel
    Left = 152
    Top = 202
    Width = 145
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga de DBON (kg):'
    TabOrder = 11
  end
  object edCargaDBON: TdrEdit
    Left = 151
    Top = 223
    Width = 146
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 12
  end
  object Panel7: TPanel
    Left = 298
    Top = 202
    Width = 150
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Carga em coliformes (un):'
    TabOrder = 15
  end
  object edCargaColif: TdrEdit
    Left = 297
    Top = 223
    Width = 151
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 16
  end
  object Panel4: TPanel
    Left = 6
    Top = 243
    Width = 220
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Concentra'#231#227'o de DBOC (kg/m3):'
    TabOrder = 17
  end
  object edConDBOC: TdrEdit
    Left = 5
    Top = 264
    Width = 221
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 18
  end
  object Panel5: TPanel
    Left = 227
    Top = 243
    Width = 221
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Concentra'#231#227'o de DBON (kg/m3):'
    TabOrder = 19
  end
  object edConDBON: TdrEdit
    Left = 226
    Top = 264
    Width = 222
    Height = 21
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    MaxLength = 10
    TabOrder = 20
  end
end

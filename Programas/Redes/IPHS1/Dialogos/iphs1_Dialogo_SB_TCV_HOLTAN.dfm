object iphs1_Form_Dialogo_SB_TCV_HOLTAN: Tiphs1_Form_Dialogo_SB_TCV_HOLTAN
  Left = 266
  Top = 162
  BorderStyle = bsToolWindow
  Caption = 'HOLTAN'
  ClientHeight = 144
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 4
    Top = 114
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 82
    Top = 114
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 4
    Top = 41
    Width = 162
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Expoente Emp'#237'rico:'
    TabOrder = 6
  end
  object edEE: TdrEdit
    Left = 166
    Top = 41
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 1
  end
  object edEI: TdrEdit
    Left = 166
    Top = 6
    Width = 65
    Height = 35
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 0
  end
  object Panel5: TPanel
    Left = 4
    Top = 6
    Width = 162
    Height = 35
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 7
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 151
      Height = 26
      AutoSize = False
      Caption = 'Estado Inicial do Reservat'#243'rio de Umidade do Solo (mm):'
      WordWrap = True
    end
  end
  object Panel6: TPanel
    Left = 4
    Top = 63
    Width = 162
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Infiltra'#231#227'o Base (mm/h):'
    TabOrder = 8
  end
  object edIB: TdrEdit
    Left = 166
    Top = 63
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 2
  end
  object Panel7: TPanel
    Left = 4
    Top = 85
    Width = 162
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Cap. Infiltra'#231#227'o Inicial (mm/h):'
    TabOrder = 9
  end
  object edCI: TdrEdit
    Left = 166
    Top = 85
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 3
  end
end

object iphs1_Form_Dialogo_SB_TCV_HYMO: Tiphs1_Form_Dialogo_SB_TCV_HYMO
  Left = 292
  Top = 135
  BorderStyle = bsToolWindow
  Caption = 'HYMO'
  ClientHeight = 131
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 4
    Top = 101
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 82
    Top = 101
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 4
    Top = 28
    Width = 198
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Tempo de Pico do HU (h):'
    TabOrder = 6
  end
  object edTP: TdrEdit
    Left = 202
    Top = 28
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 1
  end
  object Panel6: TPanel
    Left = 4
    Top = 50
    Width = 198
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Diferen'#231'a de N'#237'vel da Sub-Bacia (m):'
    TabOrder = 7
  end
  object edDN: TdrEdit
    Left = 202
    Top = 50
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
    Top = 72
    Width = 198
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Comprimento do Canal Principal (km):'
    TabOrder = 8
  end
  object edCC: TdrEdit
    Left = 202
    Top = 72
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 4
    Top = 6
    Width = 198
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Retardo do Reservat'#243'rio Nash (k):'
    TabOrder = 9
  end
  object edRR: TdrEdit
    Left = 202
    Top = 6
    Width = 65
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 0
  end
end

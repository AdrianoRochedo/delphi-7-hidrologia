object iphs1_Form_Dialogo_SB_TCV_HTSCS: Tiphs1_Form_Dialogo_SB_TCV_HTSCS
  Left = 289
  Top = 195
  BorderStyle = bsToolWindow
  Caption = 'HTSCS'
  ClientHeight = 66
  ClientWidth = 223
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
    Top = 35
    Width = 74
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 81
    Top = 35
    Width = 74
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
  object Painel: TPanel
    Left = 4
    Top = 6
    Width = 149
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Declividade da Bacia (m/km):'
    TabOrder = 3
  end
  object edDB: TdrEdit
    Left = 153
    Top = 6
    Width = 65
    Height = 22
    Cursor = crIBeam
    Hint = ' Habilitado se Tempo de Concentra'#231#227'o = 0 '
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
end

object iphs1_Form_Dialogo_SB_TCV_SCS: Tiphs1_Form_Dialogo_SB_TCV_SCS
  Left = 262
  Top = 182
  BorderStyle = bsToolWindow
  Caption = 'SCS'
  ClientHeight = 61
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 4
    Top = 33
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 82
    Top = 33
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 4
    Top = 6
    Width = 109
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Curva n'#250'mero (CN):'
    TabOrder = 3
  end
  object edCN: TdrEdit
    Left = 113
    Top = 6
    Width = 43
    Height = 22
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 0
  end
  object btnCalcular: TButton
    Left = 161
    Top = 6
    Width = 75
    Height = 23
    Hint = ' Executa o programa CN '
    Caption = 'Calcular ...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnCalcularClick
  end
end

object foiphs1_Dialogo_SB_TCV_Calculo_TC: Tfoiphs1_Dialogo_SB_TCV_Calculo_TC
  Left = 320
  Top = 243
  ActiveControl = edK_C
  BorderStyle = bsDialog
  Caption = 'C'#225'lculo do Tempo de Concentra'#231#227'o'
  ClientHeight = 182
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 65
    Height = 16
    Caption = 'M'#233'todos:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object L1: TLabel
    Left = 45
    Top = 52
    Width = 164
    Height = 13
    Caption = 'Comprimento do Rio Principal (km):'
  end
  object Label2: TLabel
    Left = 146
    Top = 72
    Width = 63
    Height = 13
    Caption = 'Desn'#237'vel (m):'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 132
    Width = 268
    Height = 8
    Shape = bsBottomLine
  end
  object Bevel2: TBevel
    Left = 8
    Top = 94
    Width = 268
    Height = 8
    Shape = bsBottomLine
  end
  object L_Res: TLabel
    Left = 8
    Top = 112
    Width = 187
    Height = 16
    Caption = 'Resultado:  N'#227'o Calculado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnOK: TButton
    Left = 8
    Top = 150
    Width = 97
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancelar: TButton
    Left = 110
    Top = 150
    Width = 97
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 1
  end
  object rbKirpch: TRadioButton
    Left = 26
    Top = 30
    Width = 113
    Height = 17
    Caption = 'Equa'#231#227'o de Kirpich'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object edK_C: TdrEdit
    Left = 216
    Top = 48
    Width = 61
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 3
    OnChange = Change
  end
  object edK_D: TdrEdit
    Left = 216
    Top = 69
    Width = 61
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    TabOrder = 4
    OnChange = Change
  end
end

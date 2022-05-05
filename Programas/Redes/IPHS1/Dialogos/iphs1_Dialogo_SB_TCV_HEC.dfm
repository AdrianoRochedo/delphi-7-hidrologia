object iphs1_Form_Dialogo_SB_TCV_HEC: Tiphs1_Form_Dialogo_SB_TCV_HEC
  Left = 282
  Top = 146
  BorderStyle = bsToolWindow
  Caption = 'HEC'
  ClientHeight = 145
  ClientWidth = 302
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
    Top = 115
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 82
    Top = 115
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 4
    Top = 6
    Width = 229
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Valor Inicial do Coeficiente de Perdas:'
    TabOrder = 6
  end
  object edVI: TdrEdit
    Left = 233
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
  object edLP: TdrEdit
    Left = 233
    Top = 28
    Width = 65
    Height = 35
    Cursor = crIBeam
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    MaxLength = 10
    TabOrder = 1
  end
  object Panel5: TPanel
    Left = 4
    Top = 28
    Width = 229
    Height = 35
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 7
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 200
      Height = 26
      Caption = 
        'L'#226'mina de precipita'#231#227'o limite para o incremento do coeficiente d' +
        'e perdas (mm):'
      WordWrap = True
    end
  end
  object Panel6: TPanel
    Left = 4
    Top = 63
    Width = 229
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Par'#226'metro de declividade do Graf. Semi-Log:'
    TabOrder = 8
  end
  object edPD: TdrEdit
    Left = 233
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
    Width = 229
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Expoente da Internsidade da Precipita'#231#227'o:'
    TabOrder = 9
  end
  object edEI: TdrEdit
    Left = 233
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

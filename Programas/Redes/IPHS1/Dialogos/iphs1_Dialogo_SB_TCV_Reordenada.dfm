object iphs1_Form_Dialogo_SB_TCV_Reordenada: Tiphs1_Form_Dialogo_SB_TCV_Reordenada
  Left = 274
  Top = 170
  BorderStyle = bsToolWindow
  Caption = ' Tormenta Reordenada'
  ClientHeight = 98
  ClientWidth = 224
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
    Top = 68
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 82
    Top = 68
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 4
    Top = 7
    Width = 216
    Height = 20
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Em que posi'#231#227'o deseja colocar o pico ?'
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 4
    Top = 27
    Width = 216
    Height = 34
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 3
    object rb25: TRadioButton
      Left = 25
      Top = 8
      Width = 52
      Height = 17
      Caption = '25 %'
      TabOrder = 0
    end
    object rb50: TRadioButton
      Left = 84
      Top = 8
      Width = 56
      Height = 17
      Caption = '50 %'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object rb75: TRadioButton
      Left = 142
      Top = 8
      Width = 56
      Height = 17
      Caption = '75 %'
      TabOrder = 2
    end
  end
end

inherited iphs1_Form_Dialogo_PC: Tiphs1_Form_Dialogo_PC
  Left = 256
  Top = 93
  Caption = ' PC'
  ClientHeight = 172
  KeyPreview = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited sbObs: TSpeedButton
    Left = 339
    Top = 237
  end
  inherited P1: TPanel
    TabOrder = 11
  end
  inherited Panel1: TPanel
    TabOrder = 12
  end
  inherited Panel2: TPanel
    TabOrder = 13
  end
  inherited btnOk: TBitBtn
    Left = 266
    Top = 140
    TabOrder = 9
  end
  inherited btnCancelar: TBitBtn
    Left = 358
    Top = 140
    TabOrder = 10
  end
  inherited Panel3: TPanel
    TabOrder = 14
  end
  inherited Panel4: TPanel
    TabOrder = 15
  end
  inherited Panel5: TPanel
    TabOrder = 16
  end
  inherited Panel8: TPanel
    Top = 216
    Width = 356
  end
  inherited edObs: TEdit
    Top = 237
    Width = 334
    TabStop = False
  end
  inherited edOper: TdrEdit
    TabOrder = 6
  end
  inherited edVMin: TdrEdit
    TabOrder = 7
  end
  inherited edVMax: TdrEdit
    TabOrder = 8
  end
  object cbCor: TColorBox [17]
    Left = 5
    Top = 143
    Width = 253
    Height = 22
    Selected = clBlue
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 5
  end
  object Panel6: TPanel [18]
    Left = 5
    Top = 123
    Width = 253
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Cor'
    TabOrder = 17
  end
end

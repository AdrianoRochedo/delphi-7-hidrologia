inherited prDialogo_QA: TprDialogo_QA
  Left = 282
  Top = 81
  Caption = ' Qualidadade da '#193'gua'
  ClientHeight = 271
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOk: TBitBtn
    Top = 240
  end
  inherited btnCancelar: TBitBtn
    Top = 240
  end
  object Panel3: TPanel
    Left = 6
    Top = 123
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Qualidade:'
    TabOrder = 8
  end
  object paQual: TPanel
    Left = 6
    Top = 144
    Width = 442
    Height = 87
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 9
    object C8: TPanel
      Tag = 8
      Left = 8
      Top = 8
      Width = 30
      Height = 14
      Color = clWhite
      TabOrder = 0
    end
    object R8: TRadioButton
      Tag = 8
      Left = 46
      Top = 7
      Width = 100
      Height = 17
      Caption = '8 - Excelente'
      TabOrder = 1
    end
    object C7: TPanel
      Tag = 7
      Left = 8
      Top = 27
      Width = 30
      Height = 14
      Color = clAqua
      TabOrder = 2
    end
    object R7: TRadioButton
      Tag = 7
      Left = 46
      Top = 26
      Width = 100
      Height = 17
      Caption = '7 - '#211'tima'
      TabOrder = 3
    end
    object C6: TPanel
      Tag = 6
      Left = 8
      Top = 46
      Width = 30
      Height = 14
      Color = clSkyBlue
      TabOrder = 4
    end
    object R6: TRadioButton
      Tag = 6
      Left = 46
      Top = 45
      Width = 100
      Height = 17
      Caption = '6 - Muito Boa'
      TabOrder = 5
    end
    object C5: TPanel
      Tag = 5
      Left = 8
      Top = 65
      Width = 30
      Height = 14
      Color = clBlue
      TabOrder = 6
    end
    object R5: TRadioButton
      Tag = 5
      Left = 46
      Top = 64
      Width = 100
      Height = 17
      Caption = '5 - Boa'
      Checked = True
      TabOrder = 7
      TabStop = True
    end
    object C4: TPanel
      Tag = 4
      Left = 184
      Top = 8
      Width = 30
      Height = 14
      Color = 13488894
      TabOrder = 8
    end
    object R4: TRadioButton
      Tag = 4
      Left = 222
      Top = 7
      Width = 100
      Height = 17
      Caption = '4 - Regular'
      TabOrder = 9
    end
    object C3: TPanel
      Tag = 3
      Left = 184
      Top = 27
      Width = 30
      Height = 14
      Color = clRed
      TabOrder = 10
    end
    object R3: TRadioButton
      Tag = 3
      Left = 222
      Top = 26
      Width = 100
      Height = 17
      Caption = '3 - Ruim'
      TabOrder = 11
    end
    object C2: TPanel
      Tag = 2
      Left = 184
      Top = 46
      Width = 30
      Height = 14
      Color = clMaroon
      TabOrder = 12
    end
    object R2: TRadioButton
      Tag = 2
      Left = 222
      Top = 45
      Width = 100
      Height = 17
      Caption = '2 - Muito Ruim'
      TabOrder = 13
    end
    object C1: TPanel
      Tag = 1
      Left = 184
      Top = 65
      Width = 30
      Height = 14
      Color = clBlack
      TabOrder = 14
    end
    object R1: TRadioButton
      Tag = 1
      Left = 222
      Top = 64
      Width = 100
      Height = 17
      Caption = '1 - P'#233'ssima'
      TabOrder = 15
    end
  end
end

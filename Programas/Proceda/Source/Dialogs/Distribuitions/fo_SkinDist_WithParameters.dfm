inherited foSkinDist_WithParameters: TfoSkinDist_WithParameters
  Left = 419
  Top = 83
  Caption = 'foSkinDist_WithParameters'
  ClientHeight = 409
  ClientWidth = 404
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnGerar: TButton
    Top = 372
    Width = 121
    TabOrder = 4
  end
  inherited btnCancelar: TButton
    Left = 136
    Top = 372
    Width = 121
    TabOrder = 5
  end
  inherited GB: TGroupBox
    Top = 147
    Width = 186
    inherited Label1: TLabel
      Left = 12
      Top = 166
    end
    inherited cbImpEst: TCheckBox
      Left = 11
      Top = 19
    end
    inherited cbIFN: TCheckBox
      Left = 30
      Top = 61
      Checked = True
      State = cbChecked
    end
    inherited cbSE: TCheckBox
      Left = 30
      Top = 80
      Checked = True
      State = cbChecked
    end
    inherited cbGraph: TCheckBox
      Left = 11
      Top = 41
    end
    inherited cbReturn: TCheckBox
      Left = 11
      Top = 120
      Checked = True
      State = cbChecked
    end
    inherited drReturn: TdrEdit
      Left = 31
      Top = 139
      Width = 141
      Enabled = True
    end
    inherited edCC: TdrEdit
      Left = 12
      Top = 181
      Width = 160
    end
    inherited cbImpr: TCheckBox
      Left = 30
      Top = 95
      Checked = True
      State = cbChecked
    end
  end
  inherited rgNInt: TRadioGroup
    Left = 207
    Top = 260
    TabOrder = 7
  end
  inherited rgTestes: TRadioGroup
    Left = 207
    Top = 147
  end
  inherited edFix: TdrEdit
    Left = 312
    Top = 305
    TabOrder = 6
  end
  inherited edPropDist: TdrEdit
    Left = 312
    Top = 330
    TabOrder = 3
  end
  object gbPars: TGroupBox
    Left = 9
    Top = 8
    Width = 385
    Height = 131
    Caption = ' Par'#226'metros: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object R1: TRadioButton
      Left = 32
      Top = 26
      Width = 113
      Height = 17
      Caption = 'N'#227'o especificar'
      TabOrder = 0
    end
    object R2: TRadioButton
      Left = 32
      Top = 50
      Width = 80
      Height = 17
      Caption = 'Momentos'
      TabOrder = 1
    end
    object R3: TRadioButton
      Left = 33
      Top = 74
      Width = 127
      Height = 17
      Caption = 'M'#225'x. Verossimilhan'#231'a'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object R4: TRadioButton
      Left = 32
      Top = 98
      Width = 82
      Height = 17
      Caption = 'Especificar'
      TabOrder = 3
    end
  end
end

inherited iphs1_Form_Dialogo_Base: Tiphs1_Form_Dialogo_Base
  Left = 192
  Top = 94
  Caption = 'iphs1_Form_Dialogo_Base'
  ClientHeight = 206
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object sbObs: TSpeedButton [0]
    Left = 426
    Top = 144
    Width = 23
    Height = 22
    Caption = '...'
    Enabled = False
    OnClick = sbObsClick
  end
  inherited P1: TPanel
    TabOrder = 10
  end
  inherited edDescricao: TEdit
    TabOrder = 1
  end
  inherited Panel1: TPanel
    TabOrder = 11
  end
  inherited Panel2: TPanel
    Left = 5
    Width = 443
    TabOrder = 12
  end
  inherited mComentarios: TMemo
    TabOrder = 2
  end
  inherited btnOk: TBitBtn
    Left = 5
    Top = 173
    TabOrder = 8
  end
  inherited btnCancelar: TBitBtn
    Left = 97
    Top = 173
    TabOrder = 9
  end
  object Panel3: TPanel
    Left = 5
    Top = 259
    Width = 147
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Opera'#231#227'o N.:'
    TabOrder = 13
    Visible = False
  end
  object Panel4: TPanel
    Left = 153
    Top = 259
    Width = 146
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o M'#237'nima:'
    TabOrder = 14
    Visible = False
  end
  object Panel5: TPanel
    Left = 300
    Top = 259
    Width = 148
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Vaz'#227'o M'#225'xima:'
    TabOrder = 15
    Visible = False
  end
  object Panel8: TPanel
    Left = 5
    Top = 123
    Width = 443
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Possui Dados Observados: '
    TabOrder = 3
    object rbPDO: TRadioButton
      Left = 158
      Top = 3
      Width = 46
      Height = 17
      Caption = 'Sim'
      TabOrder = 0
      OnClick = rbPDOClick
    end
    object RadioButton6: TRadioButton
      Left = 207
      Top = 3
      Width = 51
      Height = 17
      Caption = 'N'#227'o'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbPDOClick
    end
  end
  object edObs: TEdit
    Left = 5
    Top = 144
    Width = 422
    Height = 21
    Enabled = False
    TabOrder = 4
  end
  object edOper: TdrEdit
    Left = 5
    Top = 280
    Width = 147
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    AutoSize = False
    ReadOnly = True
    TabOrder = 5
    Visible = False
  end
  object edVMin: TdrEdit
    Left = 152
    Top = 280
    Width = 147
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 6
    Visible = False
  end
  object edVMax: TdrEdit
    Left = 299
    Top = 280
    Width = 149
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 7
    Visible = False
  end
  object Menu_DO: TPopupMenu
    Left = 34
    Top = 76
    object MenuDO_SelecionarArquivo: TMenuItem
      Caption = '&Selecionar Arquivo ...'
      OnClick = MenuDO_SelecionarArquivoClick
    end
    object MenuDO_DigitarValores: TMenuItem
      Caption = '&Digitar Valores ...'
      OnClick = MenuDO_DigitarValoresClick
    end
    object GerarValoresporumaIDF1: TMenuItem
      Caption = 'Gerar Valores por uma IDF ...'
      OnClick = GerarValoresporumaIDF1Click
    end
  end
end

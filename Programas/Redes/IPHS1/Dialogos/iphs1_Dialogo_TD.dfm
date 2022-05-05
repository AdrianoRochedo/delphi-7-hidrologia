inherited iphs1_Form_Dialogo_TD: Tiphs1_Form_Dialogo_TD
  Left = 403
  Top = 124
  Caption = ' Trecho-D'#225'gua'
  ClientHeight = 339
  ClientWidth = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited sbObs: TSpeedButton
    Left = 386
  end
  inherited P1: TPanel
    TabOrder = 11
  end
  inherited edDescricao: TEdit
    Width = 241
  end
  inherited Panel1: TPanel
    Width = 240
    TabOrder = 12
  end
  inherited Panel2: TPanel
    Width = 404
    TabOrder = 14
  end
  inherited mComentarios: TMemo
    Width = 404
  end
  inherited btnOk: TBitBtn
    Top = 308
    TabOrder = 9
  end
  inherited btnCancelar: TBitBtn
    Top = 308
    TabOrder = 10
  end
  inherited Panel3: TPanel
    Top = 363
    Width = 134
    TabOrder = 16
  end
  inherited Panel4: TPanel
    Left = 140
    Top = 363
    Width = 134
    TabOrder = 13
  end
  inherited Panel5: TPanel
    Left = 275
    Top = 363
    Width = 134
  end
  inherited Panel8: TPanel
    Width = 404
    inherited rbPDO: TRadioButton
      Left = 144
    end
    inherited RadioButton6: TRadioButton
      Left = 193
    end
  end
  inherited edObs: TEdit
    Width = 381
  end
  inherited edOper: TdrEdit
    Top = 384
    Width = 134
  end
  inherited edVMin: TdrEdit
    Left = 140
    Top = 384
    Width = 134
  end
  inherited edVMax: TdrEdit
    Left = 274
    Top = 384
    Width = 135
  end
  object paMPE: TPanel [17]
    Left = 5
    Top = 165
    Width = 403
    Height = 135
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 8
    object sbCPI: TSpeedButton
      Left = 39
      Top = 88
      Width = 30
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbCPIClick
    end
    object sbCNL: TSpeedButton
      Left = 39
      Top = 68
      Width = 30
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbCNLClick
    end
    object sbKX: TSpeedButton
      Left = 39
      Top = 28
      Width = 30
      Height = 20
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbKXClick
    end
    object sbCL: TSpeedButton
      Left = 39
      Top = 48
      Width = 30
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbCLClick
    end
    object sbCF: TSpeedButton
      Left = 39
      Top = 108
      Width = 30
      Height = 20
      Enabled = False
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000160000000A0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777007777777777777777777777007777777777777777777777007777
        0077770077770077770077700007700007700007770077700007700007700007
        7700777700777700777700777700777777777777777777777700777777777777
        777777777700777777777777777777777700}
      OnClick = sbCFClick
    end
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 403
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' M'#233'todo de Propaga'#231#227'o do Escoamento:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object rbKX: TRadioButton
      Left = 73
      Top = 31
      Width = 159
      Height = 17
      Caption = 'Muskingum K=F(Q) e X=F(K)'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = MPE_Click
    end
    object rbCL: TRadioButton
      Left = 73
      Top = 50
      Width = 145
      Height = 17
      Caption = 'Muskingum-Cunge Linear'
      TabOrder = 2
      OnClick = MPE_Click
    end
    object rbCNL: TRadioButton
      Left = 73
      Top = 69
      Width = 168
      Height = 17
      Caption = 'Muskingum-Cunge N'#227'o Linear'
      TabOrder = 3
      OnClick = MPE_Click
    end
    object rbCPI: TRadioButton
      Left = 73
      Top = 88
      Width = 253
      Height = 17
      Caption = 'Muskingum-Cunge Com Plan'#237'cie de Inunda'#231#227'o'
      TabOrder = 4
      OnClick = MPE_Click
    end
    object rbCF: TRadioButton
      Left = 73
      Top = 108
      Width = 294
      Height = 17
      Caption = 'Muskingum-Cunge N'#227'o Linear para Condutos Fechados'
      TabOrder = 5
      OnClick = MPE_Click
    end
  end
end

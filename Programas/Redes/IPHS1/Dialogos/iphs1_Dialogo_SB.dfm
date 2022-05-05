inherited iphs1_Form_Dialogo_SB: Tiphs1_Form_Dialogo_SB
  Left = 114
  Top = 71
  Caption = ' Sub-Bacia'
  ClientHeight = 307
  ClientWidth = 453
  KeyPreview = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited P1: TPanel
    TabOrder = 12
  end
  inherited Panel1: TPanel
    TabOrder = 13
  end
  inherited Panel2: TPanel
    TabOrder = 14
  end
  inherited btnOk: TBitBtn
    Top = 274
    TabOrder = 10
  end
  inherited btnCancelar: TBitBtn
    Top = 274
    TabOrder = 11
  end
  inherited Panel3: TPanel
    Top = 323
    Width = 79
    TabOrder = 16
  end
  inherited Panel4: TPanel
    Left = 85
    Top = 323
    Width = 119
    TabOrder = 18
  end
  inherited Panel5: TPanel
    Left = 205
    Top = 323
    Width = 121
  end
  inherited edObs: TEdit
    Left = 4
  end
  inherited edOper: TdrEdit
    Top = 344
    Width = 79
  end
  inherited edVMin: TdrEdit
    Left = 85
    Top = 344
    Width = 120
  end
  inherited edVMax: TdrEdit
    Left = 204
    Top = 344
    Width = 122
  end
  object Panel9: TPanel [17]
    Left = 5
    Top = 165
    Width = 443
    Height = 99
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 9
    object sbH: TSpeedButton
      Left = 413
      Top = 68
      Width = 23
      Height = 22
      Caption = '...'
      Enabled = False
      OnClick = sbHClick
    end
    object sbDLG_TCV: TSpeedButton
      Left = 9
      Top = 28
      Width = 31
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
      OnClick = sbDLG_TCVClick
    end
    object rbTCV: TRadioButton
      Left = 47
      Top = 30
      Width = 384
      Height = 17
      Caption = 'Transforma'#231#227'o Chuva-Vaz'#227'o  -  IPH II / Nash / SCS ...'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbTCVClick
    end
    object rbH: TRadioButton
      Left = 47
      Top = 51
      Width = 248
      Height = 17
      Caption = 'Hidrograma observado a ser propagado:'
      TabOrder = 1
      OnClick = rbHClick
    end
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 443
      Height = 21
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = ' Tipo de Opera'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object edH: TEdit
      Left = 49
      Top = 68
      Width = 364
      Height = 21
      Enabled = False
      TabOrder = 2
    end
  end
  object Panel11: TPanel [18]
    Left = 327
    Top = 323
    Width = 121
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Precipita'#231#227'o M'#225'xima:'
    TabOrder = 17
    Visible = False
  end
  object edPM: TdrEdit [19]
    Left = 326
    Top = 344
    Width = 122
    Height = 21
    BeepOnError = False
    DataType = dtFloat
    AutoSize = False
    TabOrder = 8
    Visible = False
  end
  object Menu_Hidrograma: TPopupMenu
    Left = 118
    Top = 76
    object Menu_SelecionarArquivo: TMenuItem
      Caption = '&Selecionar Arquivo'
      OnClick = Menu_SelecionarArquivoClick
    end
    object Menu_DigitarValores: TMenuItem
      Caption = '&Digitar Valores'
      OnClick = Menu_DigitarValoresClick
    end
    object GerarValoresporumaIDF2: TMenuItem
      Caption = 'Gerar Valores por uma IDF ...'
      OnClick = GerarValoresporumaIDF2Click
    end
  end
end

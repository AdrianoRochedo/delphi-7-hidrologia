object prDialogo_Projeto_OpcVisRede: TprDialogo_Projeto_OpcVisRede
  Left = 232
  Top = 148
  BorderStyle = bsDialog
  Caption = ' Op'#231#245'es para Visualiza'#231#227'o'
  ClientHeight = 271
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
  object sbSC: TSpeedButton
    Left = 257
    Top = 23
    Width = 23
    Height = 21
    Hint = ' Escolher novo Sistema de Coordenadas '
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbSCClick
  end
  object Label1: TLabel
    Left = 7
    Top = 51
    Width = 80
    Height = 13
    Caption = 'Escala do Mapa:'
  end
  object btnOk: TBitBtn
    Left = 85
    Top = 238
    Width = 108
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOkClick
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 96
    Width = 274
    Height = 133
    Caption = ' Visualiza'#231#227'o da Rede: '
    TabOrder = 4
    object GroupBox1: TGroupBox
      Left = 31
      Top = 24
      Width = 213
      Height = 89
      Caption = ' Sub-Bacias e Demandas: '
      TabOrder = 0
      object VR_SD_rbSP: TRadioButton
        Left = 19
        Top = 20
        Width = 113
        Height = 17
        Caption = 'Sempre Vis'#237'veis'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object VR_SD_rbE: TRadioButton
        Left = 19
        Top = 40
        Width = 177
        Height = 17
        Caption = 'Visualizar se Escala  menor que:'
        TabOrder = 1
      end
      object VR_SD_edE: TdrEdit
        Left = 39
        Top = 56
        Width = 150
        Height = 21
        BeepOnError = False
        DataType = dtInteger
        TabOrder = 2
      end
    end
  end
  object edSC: TLabeledEdit
    Left = 6
    Top = 23
    Width = 198
    Height = 21
    Hint = ' Identifica'#231#227'o do Sistema de Coordenadas Corrente '
    EditLabel.Width = 121
    EditLabel.Height = 13
    EditLabel.Caption = 'Sistema de Coordenadas:'
    LabelSpacing = 2
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
  end
  object edSC_Cod: TEdit
    Left = 204
    Top = 23
    Width = 54
    Height = 21
    Hint = ' C'#243'digo do Sistema de Coordenadas '
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 1
  end
  object edEscala: TdrEdit
    Left = 7
    Top = 66
    Width = 81
    Height = 21
    BeepOnError = False
    DataType = dtInteger
    TabOrder = 2
  end
  inline frUnidade: TFrame_moUnits
    Left = 94
    Top = 49
    Width = 188
    Height = 39
    TabOrder = 3
    inherited cbUnits: TComboBox
      Width = 186
    end
  end
end

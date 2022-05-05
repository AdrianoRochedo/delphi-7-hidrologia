object foAnaliseDePeriodos: TfoAnaliseDePeriodos
  Left = 146
  Top = 95
  BorderStyle = bsDialog
  Caption = ' An'#225'lise de per'#237'odos'
  ClientHeight = 490
  ClientWidth = 790
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
  object Bevel1: TBevel
    Left = 11
    Top = 443
    Width = 767
    Height = 5
    Shape = bsBottomLine
  end
  inline frame: TfrIntervalsOfStations
    Left = 6
    Top = 6
    Width = 465
    Height = 437
    TabOrder = 0
    inherited Label1: TLabel
      Top = 393
    end
    inherited Label2: TLabel
      Top = 412
    end
    inherited GroupBox1: TGroupBox
      inherited rb1: TRadioButton
        OnClick = frame_radio_Click
      end
      inherited rb2: TRadioButton
        OnClick = frame_radio_Click
      end
    end
    inherited g2: TChart
      Height = 102
      OnMouseMove = frame_g2_MouseMove
    end
    inherited meDI: TMaskEdit
      Top = 408
    end
    inherited meDF: TMaskEdit
      Top = 408
    end
  end
  object btnClose: TButton
    Left = 670
    Top = 456
    Width = 109
    Height = 25
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 1
  end
  object Paginas: TPageControl
    Left = 476
    Top = 11
    Width = 303
    Height = 425
    ActivePage = P1
    TabOrder = 2
    object P1: TTabSheet
      Caption = 'Per'#237'odos'
      inline RTF: Tfr_RTF
        Left = 0
        Top = 0
        Width = 295
        Height = 397
        Align = alClient
        TabOrder = 0
        inherited Memo: TRichEdit
          Width = 295
          Height = 397
          Color = clWindow
        end
      end
    end
    object P2: TTabSheet
      Caption = 'Matriz de Coeficientes'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 368
        Width = 295
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btnExportar: TButton
          Left = 171
          Top = 5
          Width = 125
          Height = 22
          Hint = ' Salva a matriz de coeficientes '
          Caption = 'Salvar coeficientes ...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnExportarMatriz_Click
        end
        object btnLerCombs: TButton
          Left = 1
          Top = 5
          Width = 167
          Height = 22
          Hint = 
            ' Importa a matriz de combinac'#245'es. '#13#10' As combina'#231#245'es ser'#227'o utiliz' +
            'adas na substitui'#231#227'o de cada per'#237'odo '#13#10' que coincidir com o padr' +
            #227'o combinat'#243'rio.'#13#10' Ap'#243's este passo o usu'#225'rio possuir'#225' a verdadei' +
            'ra matriz de'#13#10' coeficientes que poder'#225' ser utilizada em outras f' +
            'un'#231#245'es do sistema. '
          Caption = 'Importar padr'#245'es ...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnLerCombs_Click
        end
      end
      inline Planilha1: TSpreadSheetBookFrame
        Left = 0
        Top = 0
        Width = 295
        Height = 368
        Align = alClient
        TabOrder = 1
        inherited SS: TcxSpreadSheetBook
          Width = 295
          Height = 368
          DefaultColWidth = 30
          ShowCaptionBar = False
          ShowHeaders = False
        end
      end
    end
    object P3: TTabSheet
      Caption = 'Matriz de Padr'#245'es'
      ImageIndex = 2
      inline Planilha2: TSpreadSheetBookFrame
        Left = 0
        Top = 0
        Width = 295
        Height = 368
        Align = alClient
        TabOrder = 0
        inherited SS: TcxSpreadSheetBook
          Width = 295
          Height = 368
          DefaultColWidth = 30
          ShowCaptionBar = False
          ShowHeaders = False
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 368
        Width = 295
        Height = 29
        Hint = ' Salva a matriz de combina'#231#245'es '
        Align = alBottom
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        object btnExportarComb: TButton
          Left = 171
          Top = 5
          Width = 125
          Height = 22
          Caption = 'Salvar padr'#245'es ...'
          TabOrder = 0
          OnClick = btnExportarComb_Click
        end
      end
    end
  end
  object SaveCoefs: TSaveDialog
    DefaultExt = 'coeficientes'
    Filter = 'Coeficientes|*.coeficientes'
    Title = ' Salvar coeficientes'
    Left = 237
    Top = 399
  end
  object SaveCombs: TSaveDialog
    DefaultExt = 'padroes'
    Filter = 'Padr'#245'es|*.padroes'
    Title = ' Salvar Padr'#245'es'
    Left = 306
    Top = 399
  end
  object OpenCombs: TOpenDialog
    DefaultExt = 'padroes'
    Filter = 'Padr'#245'es|*.padroes'
    Title = ' Importar padr'#245'es'
    Left = 380
    Top = 399
  end
end

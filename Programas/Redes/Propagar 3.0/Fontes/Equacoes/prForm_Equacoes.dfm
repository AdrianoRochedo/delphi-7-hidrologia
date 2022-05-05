object prForm_Equacoes: TprForm_Equacoes
  Left = 60
  Top = 30
  Width = 883
  Height = 668
  BorderIcons = [biSystemMenu, biMaximize]
  BorderWidth = 4
  Caption = ' Gerenciador de Equa'#231#245'es'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object paControles: TPanel
    Left = 0
    Top = 0
    Width = 867
    Height = 163
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object BookControles: TPageControl
      Left = 3
      Top = 3
      Width = 763
      Height = 157
      ActivePage = TabSheet1
      Align = alClient
      Constraints.MinWidth = 564
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = ' Script e MPS '
        DesignSize = (
          755
          129)
        object btnEscolherArquivo: TSpeedButton
          Left = 724
          Top = 19
          Width = 23
          Height = 21
          Hint = 'Seleciona um script'
          Anchors = [akTop, akRight]
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          OnClick = btnEscolherArq_Click
        end
        object edScript: TLabeledEdit
          Left = 6
          Top = 19
          Width = 715
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 140
          EditLabel.Height = 13
          EditLabel.Caption = 'Script gerador das Equa'#231#245'es:'
          LabelSpacing = 2
          TabOrder = 0
        end
        object GroupBox1: TGroupBox
          Left = 6
          Top = 47
          Width = 235
          Height = 60
          Caption = ' Script '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object btnEditar: TRAColorButton
            Left = 11
            Top = 22
            Width = 104
            Height = 23
            Caption = 'Editar ...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btnEditarClick
            Color = clBtnFace
            ParentColor = False
          end
          object btnGerar: TRAColorButton
            Left = 119
            Top = 22
            Width = 104
            Height = 23
            Hint = 'Gera equa'#231#245'es utilizando o script indicado acima'
            Caption = 'Gerar equa'#231#245'es'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnGerarClick
            Color = clBtnFace
            ParentColor = False
          end
        end
        object GroupBox2: TGroupBox
          Left = 247
          Top = 47
          Width = 303
          Height = 60
          Caption = ' MPS '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object btnStop: TRAColorButton
            Left = 203
            Top = 24
            Width = 89
            Height = 21
            Caption = 'Parar'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btnStopClick
            Color = clBtnFace
            ParentColor = False
          end
          object btnMPS: TRAColorButton
            Left = 110
            Top = 24
            Width = 89
            Height = 21
            Hint = 'Converte as equa'#231#245'es geradas via script para o formato MPS'
            Caption = 'Converter'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnMPSClick
            Color = clBtnFace
            ParentColor = False
          end
          object cbOpt: TCheckBox
            Left = 11
            Top = 26
            Width = 99
            Height = 17
            Caption = 'Otimizar c'#243'digo'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = ' LP-Solver '
        ImageIndex = 1
        DesignSize = (
          755
          129)
        object Bevel1: TBevel
          Left = 9
          Top = 88
          Width = 715
          Height = 8
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object btnEnt: TSpeedButton
          Left = 724
          Top = 19
          Width = 23
          Height = 21
          Hint = 'Seleciona um script'
          Anchors = [akTop, akRight]
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          OnClick = btnEnt_Click
        end
        object btnSolver: TRAColorButton
          Left = 9
          Top = 98
          Width = 86
          Height = 23
          Hint = 
            ' Executa o otimizador LP-Solver com as '#13#10'   equa'#231#245'es geradas em ' +
            'formato MPS.'#13#10#13#10'  A otimiza'#231#227'o '#233' ass'#237'ncrona, isto '#233', o'#13#10'Propagar' +
            ' n'#227'o ficar'#225' esperando o t'#233'rmino'#13#10'  do  LP-Solver para ler os res' +
            'ultados, '#13#10'       isto ficar'#225' por conta do usu'#225'rio.'
          Caption = 'Executar ...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnSolverClick
          Color = clBtnFace
          ParentColor = False
        end
        object edEnt: TLabeledEdit
          Left = 8
          Top = 19
          Width = 715
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 269
          EditLabel.Height = 13
          EditLabel.Caption = 'Salvar equa'#231#245'es como ... (Arquivo de Entrada do Solver)'
          LabelSpacing = 2
          TabOrder = 1
          OnChange = edEntChange
        end
        object edRes: TLabeledEdit
          Left = 8
          Top = 59
          Width = 715
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = clScrollBar
          EditLabel.Width = 191
          EditLabel.Height = 13
          EditLabel.Caption = 'Resultado:  (Arquivo gerado pelo Solver)'
          LabelSpacing = 2
          TabOrder = 2
        end
        object btnLerRes: TButton
          Left = 100
          Top = 98
          Width = 104
          Height = 23
          Hint = 
            'Cuidado: '#13#10'    Certifique-se que o LP-Solver terminou a otimiza'#231 +
            #227'o.  '
          Caption = 'Ler resultados'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnLerResClick
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Par'#226'metros do Solver'
        ImageIndex = 2
        object mPars: TMemo
          Left = 0
          Top = 0
          Width = 755
          Height = 129
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Lines.Strings = (
            'min'
            'wafter'
            's'
            'si'
            'se'
            'presolve'
            'presolverow'
            'presolvecol'
            'presolvel'
            'presolves'
            'presolver'
            'simplexdp'
            'B5'
            'BB'
            'v5'
            't'
            'd'
            'ia')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          WordWrap = False
        end
      end
    end
    object Panel2: TPanel
      Left = 766
      Top = 3
      Width = 98
      Height = 157
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnFechar: TRAColorButton
        Left = 6
        Top = 20
        Width = 92
        Height = 24
        Caption = 'Fechar'
        TabOrder = 0
        OnClick = btnFecharClick
        Color = clBtnFace
        ParentColor = False
      end
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 570
    Width = 867
    Height = 61
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    DesignSize = (
      867
      61)
    object laProgresso: TLabel
      Left = 4
      Top = 5
      Width = 278
      Height = 13
      Caption = 'Progresso da opera'#231#227'o de convers'#227'o para o formato MPS:'
    end
    object p1: TProgressBar
      Left = 3
      Top = 21
      Width = 860
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object p2: TProgressBar
      Left = 3
      Top = 40
      Width = 860
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object paEditores: TPanel
    Left = 0
    Top = 163
    Width = 867
    Height = 407
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 2
    object Book: TPageControl
      Left = 3
      Top = 3
      Width = 861
      Height = 401
      ActivePage = TabEQ
      Align = alClient
      TabOrder = 0
      object TabEQ: TTabSheet
        Caption = 'Equa'#231#245'es'
        object Equacoes: TRAHLEditor
          Left = 0
          Top = 0
          Width = 853
          Height = 373
          Cursor = crIBeam
          BorderStyle = bsNone
          GutterWidth = 0
          RightMargin = 0
          RightMarginColor = clSilver
          Completion.ItemHeight = 13
          Completion.Interval = 800
          Completion.ListBoxStyle = lbStandard
          Completion.CaretChar = '|'
          Completion.CRLF = '/n'
          Completion.Separator = '='
          TabStops = '3 5'
          SelForeColor = clBlack
          SelBackColor = clInfoBk
          OnChange = EquacoesChange
          Align = alClient
          Color = clBlack
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          PopupMenu = Menu
          TabStop = True
          UseDockManager = False
          Colors.Comment.Style = [fsItalic]
          Colors.Comment.ForeColor = clSilver
          Colors.Comment.BackColor = clBlack
          Colors.Number.Style = []
          Colors.Number.ForeColor = clAqua
          Colors.Number.BackColor = clBlack
          Colors.Strings.Style = []
          Colors.Strings.ForeColor = clAqua
          Colors.Strings.BackColor = clBlack
          Colors.Symbol.Style = [fsBold]
          Colors.Symbol.ForeColor = clWhite
          Colors.Symbol.BackColor = clBlack
          Colors.Reserved.Style = []
          Colors.Reserved.ForeColor = clWhite
          Colors.Reserved.BackColor = clBlack
          Colors.Identifer.Style = []
          Colors.Identifer.ForeColor = clYellow
          Colors.Identifer.BackColor = clBlack
          Colors.Preproc.Style = []
          Colors.Preproc.ForeColor = clGreen
          Colors.Preproc.BackColor = clWindow
          Colors.FunctionCall.Style = []
          Colors.FunctionCall.ForeColor = clWhite
          Colors.FunctionCall.BackColor = clBlack
          Colors.Declaration.Style = []
          Colors.Declaration.ForeColor = clWhite
          Colors.Declaration.BackColor = clBlack
          Colors.Statement.Style = []
          Colors.Statement.ForeColor = clWhite
          Colors.Statement.BackColor = clBlack
          Colors.PlainText.Style = []
          Colors.PlainText.ForeColor = clWhite
          Colors.PlainText.BackColor = clBlack
        end
      end
      object TabMPS: TTabSheet
        Caption = 'Formato MPS'
        ImageIndex = 1
        object MPS: TRichEdit
          Left = 0
          Top = 0
          Width = 853
          Height = 373
          Align = alClient
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PlainText = True
          PopupMenu = Menu
          ScrollBars = ssVertical
          TabOrder = 0
          WordWrap = False
          OnChange = MPSChange
        end
      end
      object TabMes: TTabSheet
        Caption = 'Mensagens'
        ImageIndex = 2
        object Mensagens: TRichEdit
          Left = 0
          Top = 0
          Width = 853
          Height = 373
          Align = alClient
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clLime
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PlainText = True
          PopupMenu = Menu
          ScrollBars = ssVertical
          TabOrder = 0
          WordWrap = False
        end
      end
      object TabRes: TTabSheet
        Caption = 'Resultados'
        ImageIndex = 3
        object Res: TRichEdit
          Left = 0
          Top = 0
          Width = 853
          Height = 373
          Align = alClient
          Color = 13100787
          Font.Charset = ANSI_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PlainText = True
          PopupMenu = Menu
          ScrollBars = ssVertical
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object Open: TOpenDialog
    DefaultExt = 'txt'
    Title = ' Escolher arquivo'
    Left = 654
    Top = 255
  end
  object Menu: TPopupMenu
    OnPopup = MenuPopup
    Left = 654
    Top = 303
    object Menu_Ler: TMenuItem
      Caption = 'Ler ...'
      OnClick = Menu_LerClick
    end
    object Menu_SalvarComo: TMenuItem
      Caption = 'Salvar Como ...'
      OnClick = Menu_SalvarComoClick
    end
    object Menu_Copiar: TMenuItem
      Caption = 'Copiar'
      OnClick = Menu_CopiarClick
    end
  end
  object Exec: TExecFile
    Associate = False
    Wait = False
    Left = 654
    Top = 207
  end
  object Save: TSaveDialog
    DefaultExt = 'LP'
    Filter = 'Arquivos LP|*.LP'
    Title = 'Escolha um nome para o arq. LP'
    Left = 655
    Top = 351
  end
end

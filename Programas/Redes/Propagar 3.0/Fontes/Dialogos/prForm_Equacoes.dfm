object prForm_Equacoes: TprForm_Equacoes
  Left = 90
  Top = 60
  Width = 680
  Height = 480
  BorderIcons = [biSystemMenu, biMaximize]
  BorderWidth = 4
  Caption = ' Gerador de Equacoes'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 74
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      664
      74)
    object btnEscolherArquivo: TSpeedButton
      Left = 640
      Top = 18
      Width = 23
      Height = 21
      Anchors = []
      Caption = '...'
      OnClick = btnEscolherArq_Click
    end
    object btnGerar: TButton
      Left = 126
      Top = 45
      Width = 103
      Height = 23
      Caption = 'Gerar Equa'#231#245'es'
      TabOrder = 1
      OnClick = btnGerarClick
    end
    object btnFechar: TButton
      Left = 560
      Top = 45
      Width = 103
      Height = 23
      Caption = 'Fechar'
      TabOrder = 3
      OnClick = btnFecharClick
    end
    object edScript: TLabeledEdit
      Left = 2
      Top = 18
      Width = 637
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 129
      EditLabel.Height = 13
      EditLabel.Caption = 'Script Geral das Equa'#231#245'es:'
      LabelSpacing = 2
      TabOrder = 4
    end
    object btnEditar: TButton
      Left = 2
      Top = 45
      Width = 120
      Height = 23
      Caption = 'Editar Equa'#231#245'es ...'
      TabOrder = 0
      OnClick = btnEditarClick
    end
    object btnMPS: TButton
      Left = 233
      Top = 45
      Width = 169
      Height = 23
      Caption = 'Converter para o formato MPS'
      TabOrder = 2
      OnClick = btnMPSClick
    end
    object btnStop: TButton
      Left = 406
      Top = 45
      Width = 150
      Height = 23
      Caption = 'Parar conversor MPS'
      TabOrder = 5
      OnClick = btnStopClick
    end
  end
  object Book: TPageControl
    Left = 0
    Top = 74
    Width = 664
    Height = 308
    ActivePage = TabEQ
    Align = alClient
    TabOrder = 1
    object TabEQ: TTabSheet
      Caption = 'Equa'#231#245'es Lineares'
      object Equacoes: TRAHLEditor
        Left = 0
        Top = 0
        Width = 656
        Height = 280
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
        Width = 656
        Height = 280
        Align = alClient
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = Menu
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 382
    Width = 664
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object laProgresso: TLabel
      Left = 2
      Top = 7
      Width = 278
      Height = 13
      Caption = 'Progresso da opera'#231#227'o de convers'#227'o para o formato MPS:'
    end
    object p1: TProgressBar
      Left = 1
      Top = 23
      Width = 662
      Height = 16
      TabOrder = 0
    end
    object p2: TProgressBar
      Left = 1
      Top = 42
      Width = 662
      Height = 16
      TabOrder = 1
    end
  end
  object Open: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Pascal Script (*.pscript)|*.pscript|Todos (*.*)|*.*'
    Title = ' Escolher arquivo'
    Left = 32
    Top = 208
  end
  object Menu: TPopupMenu
    Left = 88
    Top = 209
    object Menu_SalvarComo: TMenuItem
      Caption = 'Salvar Como ...'
      OnClick = Menu_SalvarComoClick
    end
    object Menu_Copiar: TMenuItem
      Caption = 'Copiar'
      OnClick = Menu_CopiarClick
    end
  end
end

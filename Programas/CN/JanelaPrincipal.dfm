object foPrincipal: TfoPrincipal
  Left = 41
  Top = 7
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = ' IPHS1 - Escoamento Superficial - C'#225'lculo do CN'
  ClientHeight = 508
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 11
    Width = 111
    Height = 13
    Caption = 'Sub-divis'#245'es da Bacia: '
  end
  object Label2: TLabel
    Left = 22
    Top = 363
    Width = 161
    Height = 20
    Caption = 'Condi'#231#227'o de Umidade:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 7
    Top = 353
    Width = 695
    Height = 6
    Shape = bsTopLine
  end
  object laCU: TLabel
    Left = 44
    Top = 391
    Width = 465
    Height = 25
    AutoSize = False
    Caption = 
      'Situa'#231#227'o em que os solos est'#227'o secos. Na esta'#231#227'o de crescimento ' +
      'a precipita'#231#227'o acumulada dos cinco dias anteriores '#233' menor que 3' +
      '6 mm e em outro per'#237'odo, menor que 13 mm.'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 22
    Top = 395
    Width = 6
    Height = 13
    Caption = 'I:'
  end
  object Label11: TLabel
    Left = 22
    Top = 429
    Width = 9
    Height = 13
    Caption = 'II:'
  end
  object Label12: TLabel
    Left = 22
    Top = 462
    Width = 12
    Height = 13
    Caption = 'III:'
  end
  object Label13: TLabel
    Left = 44
    Top = 425
    Width = 465
    Height = 25
    AutoSize = False
    Caption = 
      'Situa'#231#227'o m'#233'dia em que os solos correspondem '#224' umidade da capacid' +
      'ade de campo. Para esta situa'#231#227'o, o CN m'#233'dio encontrado n'#227'o sofr' +
      'e altera'#231#227'o.'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 44
    Top = 458
    Width = 465
    Height = 43
    AutoSize = False
    Caption = 
      'Situa'#231#227'o em que ocorreram precipita'#231#245'es consider'#225'veis nos cinco ' +
      'dias anteriores e o solo encontra-se saturado. No per'#237'odo de cre' +
      'scimento, as precipita'#231#245'es acumuladas nos cinco dias anteriores,' +
      ' s'#227'o maiores que 53 mm e no outro maior que 28 mm.'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 538
    Top = 363
    Width = 77
    Height = 20
    Caption = 'CN  M'#233'dio:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Chart: TChart
    Left = 0
    Top = 31
    Width = 711
    Height = 226
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Pen.Visible = False
    BottomWall.Brush.Color = clScrollBar
    Foot.Brush.Color = clScrollBar
    Foot.Color = clScrollBar
    LeftWall.Brush.Color = clScrollBar
    Title.Brush.Color = clScrollBar
    Title.Color = clScrollBar
    Title.Text.Strings = (
      'TChart')
    AxisVisible = False
    BackColor = clScrollBar
    Chart3DPercent = 30
    ClipPoints = False
    Frame.Visible = False
    Legend.Brush.Color = clScrollBar
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    View3DWalls = False
    Align = alTop
    BorderWidth = 1
    BorderStyle = bsSingle
    TabOrder = 0
  end
  object btnAdicionar: TButton
    Left = 628
    Top = 265
    Width = 75
    Height = 23
    Action = ActAdicionar
    Caption = '&Adicionar'
    TabOrder = 1
  end
  object btnEditar: TButton
    Left = 628
    Top = 292
    Width = 75
    Height = 24
    Action = ActAtualizar
    Enabled = False
    TabOrder = 2
  end
  object btnRemover: TButton
    Left = 628
    Top = 320
    Width = 75
    Height = 24
    Action = ActRemover
    Enabled = False
    TabOrder = 3
  end
  object rbAMC_I: TRadioButton
    Left = 537
    Top = 391
    Width = 163
    Height = 17
    Caption = 'N'#227'o Calculado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object rbAMC_II: TRadioButton
    Left = 537
    Top = 431
    Width = 163
    Height = 17
    Caption = 'N'#227'o Calculado'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    TabStop = True
  end
  object rbAMC_III: TRadioButton
    Left = 537
    Top = 470
    Width = 163
    Height = 17
    Caption = 'N'#227'o Calculado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
  object ControlBar1: TControlBar
    Left = 0
    Top = 0
    Width = 711
    Height = 31
    Align = alTop
    TabOrder = 7
    object btnOK: TSpeedButton
      Left = 658
      Top = 2
      Width = 44
      Height = 22
      Hint = ' Termina o Programa '
      Caption = 'Fim'
      OnClick = btnOKClick
    end
    object ToolBar1: TToolBar
      Left = 11
      Top = 2
      Width = 128
      Height = 22
      ButtonHeight = 21
      ButtonWidth = 49
      Caption = 'ToolBar1'
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Menu = Menu
      ShowCaptions = True
      TabOrder = 0
    end
  end
  object Grid: TdrStringAlignGrid
    Left = 6
    Top = 265
    Width = 615
    Height = 79
    FocusColor = clWindow
    FocusTextColor = clWindowText
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 8
    ColWidths = (
      433
      107
      50)
  end
  object Menu: TMainMenu
    Left = 22
    Top = 40
    object Arquivo2: TMenuItem
      Caption = '&Arquivo'
      object Abrir1: TMenuItem
        Action = ActAbrir
      end
      object Salvar1: TMenuItem
        Action = ActSalvar
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Iniciar2: TMenuItem
        Action = ActLimpar
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Action = AclSair
      end
    end
    object Editar1: TMenuItem
      Caption = '&Editar'
      object Adicionar1: TMenuItem
        Action = ActAdicionar
      end
      object Atualizar1: TMenuItem
        Action = ActAtualizar
      end
      object Remover1: TMenuItem
        Action = ActRemover
      end
      object Limpar1: TMenuItem
        Action = ActLimpar
      end
    end
    object Ajuda1: TMenuItem
      Caption = 'A&juda'
      object picosdaajuda1: TMenuItem
        Caption = 'T'#243'picos da ajuda ...'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SobreocalculodeCN1: TMenuItem
        Caption = 'Sobre o calculo do CN ...'
      end
    end
  end
  object ODIni: TOpenDialog
    DefaultExt = 'cn'
    Filter = 
      'Arquivos de curva de n'#237'vel (*.cn)|*.cn|Todos os tipo de arquivos' +
      ' (*.*)|*.*'
    Left = 610
    Top = 36
  end
  object SDIni: TSaveDialog
    DefaultExt = 'cn'
    Filter = 
      'Arquivos de curva de n'#237'vel (*.cn)|*.cn|Todos os tipo de arquivos' +
      ' (*.*)|*.*'
    Left = 656
    Top = 38
  end
  object ALPrincipal: TActionList
    Left = 562
    Top = 36
    object ActAdicionar: TAction
      Caption = '&Adiconar ...'
      OnExecute = btnAdicionarClick
    end
    object ActLimpar: TAction
      Caption = '&Iniciar'
      OnExecute = ActLimparExecute
    end
    object ActAtualizar: TAction
      Caption = '&Editar ...'
      OnExecute = btnEditarClick
    end
    object ActRemover: TAction
      Caption = '&Remover'
      OnExecute = btnRemoverClick
    end
    object ActAbrir: TAction
      Caption = '&Abrir ...'
      OnExecute = ActAbrirExecute
    end
    object ActSalvar: TAction
      Caption = '&Salvar ...'
      OnExecute = ActSalvarExecute
    end
    object AclSair: TAction
      Caption = 'Sai&r'
      OnExecute = AclSairExecute
    end
  end
end

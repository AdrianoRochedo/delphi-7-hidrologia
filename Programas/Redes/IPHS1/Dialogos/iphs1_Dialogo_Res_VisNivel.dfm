object foiphs1_Dialogo_Res_VisNivel: Tfoiphs1_Dialogo_Res_VisNivel
  Left = 28
  Top = 86
  BorderStyle = bsDialog
  Caption = ' Visualiza'#231#227'o de Cotas'
  ClientHeight = 393
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object laCotas: TLabel
    Left = 4
    Top = 4
    Width = 33
    Height = 13
    Caption = 'Cotas: '
  end
  object Button1: TButton
    Left = 540
    Top = 358
    Width = 178
    Height = 28
    Caption = 'Fechar'
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Chart: TChart
    Left = 347
    Top = 22
    Width = 372
    Height = 244
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.AdjustFrame = False
    Title.Text.Strings = (
      '')
    Title.Visible = False
    View3D = False
    TabOrder = 1
    object Label5: TLabel
      Left = 140
      Top = 6
      Width = 68
      Height = 13
      Caption = 'Vaz'#245'es (m3/s)'
    end
  end
  object GroupBox1: TGroupBox
    Left = 346
    Top = 274
    Width = 187
    Height = 113
    Caption = ' Visualizar: '
    TabOrder = 2
    object cbE: TCheckBox
      Left = 84
      Top = 17
      Width = 81
      Height = 17
      Caption = ' Q. Entrada'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbEClick
    end
    object cbS: TCheckBox
      Left = 84
      Top = 35
      Width = 75
      Height = 17
      Caption = ' Q. Sa'#237'da'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbSClick
    end
    object cbV: TCheckBox
      Left = 84
      Top = 53
      Width = 81
      Height = 17
      Caption = ' Q. Vertedor'
      TabOrder = 2
      OnClick = cbVClick
    end
    object Panel1: TPanel
      Left = 29
      Top = 20
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clBlue
      TabOrder = 3
    end
    object Panel2: TPanel
      Left = 29
      Top = 38
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clRed
      TabOrder = 4
    end
    object Panel3: TPanel
      Left = 29
      Top = 56
      Width = 45
      Height = 12
      BevelOuter = bvLowered
      Color = clYellow
      TabOrder = 5
    end
    object cbBP: TCheckBox
      Left = 84
      Top = 90
      Width = 81
      Height = 17
      Caption = ' Bypass'
      TabOrder = 6
      OnClick = cbBPClick
    end
    object Panel4: TPanel
      Left = 29
      Top = 93
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clGreen
      TabOrder = 7
    end
    object cbO: TCheckBox
      Left = 84
      Top = 71
      Width = 81
      Height = 17
      Caption = ' Q. Orif'#237'cio'
      TabOrder = 8
      OnClick = cbOClick
    end
    object Panel5: TPanel
      Left = 29
      Top = 74
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clBlack
      TabOrder = 9
    end
  end
  object GroupBox2: TGroupBox
    Left = 3
    Top = 274
    Width = 345
    Height = 113
    Caption = ' Simula'#231#227'o: '
    TabOrder = 3
    object Label1: TLabel
      Left = 24
      Top = 19
      Width = 47
      Height = 13
      Caption = 'Intervalo: '
    end
    object laDT: TLabel
      Left = 73
      Top = 19
      Width = 15
      Height = 13
      Caption = 'DT'
    end
    object Label2: TLabel
      Left = 128
      Top = 19
      Width = 45
      Height = 13
      Caption = 'Cota (m): '
    end
    object laC: TLabel
      Left = 175
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label3: TLabel
      Left = 147
      Top = 54
      Width = 34
      Height = 13
      Caption = 'R'#225'pido'
    end
    object Label4: TLabel
      Left = 278
      Top = 54
      Width = 41
      Height = 13
      Caption = 'Devagar'
    end
    object Gauge: TTrackBar
      Left = 16
      Top = 32
      Width = 311
      Height = 22
      LineSize = 0
      Max = 100
      PageSize = 0
      TabOrder = 0
      TickStyle = tsNone
    end
    object btn1: TButton
      Left = 24
      Top = 64
      Width = 57
      Height = 22
      Caption = 'Simular'
      TabOrder = 1
      OnClick = btn1Click
    end
    object btnParar: TButton
      Left = 82
      Top = 64
      Width = 57
      Height = 22
      Caption = 'Parar'
      TabOrder = 2
      OnClick = btnPararClick
    end
    object tbV: TTrackBar
      Left = 140
      Top = 67
      Width = 187
      Height = 22
      LineSize = 0
      Max = 800
      Min = 20
      PageSize = 0
      Position = 100
      TabOrder = 3
      TickStyle = tsNone
      OnChange = tbVChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 539
    Top = 274
    Width = 180
    Height = 76
    Caption = ' Op'#231#245'es de Visualiza'#231#227'o: '
    TabOrder = 4
    object Label6: TLabel
      Left = 12
      Top = 49
      Width = 113
      Height = 13
      Caption = 'N.de pontos no Gr'#225'fico:'
    end
    object cb3D: TCheckBox
      Left = 12
      Top = 23
      Width = 38
      Height = 17
      Caption = '3D'
      TabOrder = 0
      OnClick = cb3DClick
    end
    object edPontos: TdrEdit
      Left = 130
      Top = 44
      Width = 41
      Height = 21
      Hint = 
        'N'#250'mero de pontos mostrados simultaneamente '#13#10'pelo gr'#225'fico para c' +
        'ada s'#233'rie'
      BeepOnError = False
      DataType = dtInteger
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '300'
    end
  end
  object chCotas: TChart
    Left = 4
    Top = 22
    Width = 343
    Height = 244
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.AdjustFrame = False
    Title.Text.Strings = (
      '')
    Title.Visible = False
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    TopAxis.AxisValuesFormat = '#,##0,###'
    View3D = False
    TabOrder = 5
    object Label7: TLabel
      Left = 140
      Top = 6
      Width = 44
      Height = 13
      Caption = 'Cotas (m)'
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 24
    Top = 37
  end
end

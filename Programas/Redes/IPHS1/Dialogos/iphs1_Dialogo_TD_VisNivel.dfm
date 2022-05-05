object foiphs1_Dialogo_TD_VisNivel: Tfoiphs1_Dialogo_TD_VisNivel
  Left = 48
  Top = 78
  BorderStyle = bsDialog
  Caption = ' Visualiza'#231#227'o de Cotas'
  ClientHeight = 379
  ClientWidth = 696
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
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
  object P: TExtPanel
    Left = 3
    Top = 22
    Width = 344
    Height = 244
    TabOrder = 0
    AcceptFiles = False
    HorzRedraw = False
    VertRedraw = False
    OnPaint = PPaint
  end
  object Chart: TChart
    Left = 347
    Top = 22
    Width = 346
    Height = 244
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    TabOrder = 1
    object Label5: TLabel
      Left = 140
      Top = 10
      Width = 68
      Height = 13
      Caption = 'Vaz'#245'es (m3/s)'
    end
  end
  object Button2: TButton
    Left = 536
    Top = 280
    Width = 156
    Height = 92
    Caption = 'Fechar'
    ModalResult = 1
    TabOrder = 2
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 346
    Top = 274
    Width = 184
    Height = 97
    Caption = ' Visualizar: '
    TabOrder = 3
    object cbE: TCheckBox
      Left = 84
      Top = 34
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
      Top = 53
      Width = 75
      Height = 17
      Caption = ' Q. Sa'#237'da'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbSClick
    end
    object Panel1: TPanel
      Left = 29
      Top = 37
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clBlue
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 29
      Top = 56
      Width = 46
      Height = 12
      BevelOuter = bvLowered
      Color = clRed
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 3
    Top = 274
    Width = 345
    Height = 97
    Caption = ' Simula'#231#227'o: '
    TabOrder = 4
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
      OnChange = GaugeChange
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
      Max = 3000
      Min = 50
      PageSize = 0
      Position = 300
      TabOrder = 3
      TickStyle = tsNone
      OnChange = tbVChange
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 16
    Top = 31
  end
end

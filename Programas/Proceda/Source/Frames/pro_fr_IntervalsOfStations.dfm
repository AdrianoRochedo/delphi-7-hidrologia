object frIntervalsOfStations: TfrIntervalsOfStations
  Left = 0
  Top = 0
  Width = 466
  Height = 426
  TabOrder = 0
  object laI: TLabel
    Left = 3
    Top = 118
    Width = 168
    Height = 13
    Caption = 'Intervalos dos postos selecionados:'
  end
  object laIC: TLabel
    Left = 4
    Top = 269
    Width = 89
    Height = 13
    Caption = 'Intervalos comuns:'
  end
  object L1: TLabel
    Left = 447
    Top = 118
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = 'L1'
  end
  object L2: TLabel
    Left = 447
    Top = 269
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = 'L2'
  end
  object Label1: TLabel
    Left = 5
    Top = 385
    Width = 109
    Height = 13
    Caption = 'Intervalo Selecionado: '
  end
  object Label2: TLabel
    Left = 97
    Top = 404
    Width = 6
    Height = 13
    Caption = 'a'
  end
  inline frPostos: TFrame_SelecaoDePostos
    Left = 3
    Top = 2
    Width = 210
    Height = 114
    TabOrder = 0
    inherited clPostos: TCheckListBox
      Width = 209
      Height = 96
    end
  end
  object GroupBox1: TGroupBox
    Left = 225
    Top = 12
    Width = 235
    Height = 101
    Caption = ' Mostrar: '
    TabOrder = 1
    object rb1: TRadioButton
      Left = 23
      Top = 22
      Width = 197
      Height = 24
      Caption = 'Intervalos individuais de pelo menos um dos postos selecionados'
      TabOrder = 0
      WordWrap = True
      OnClick = rb1Click
    end
    object rb2: TRadioButton
      Left = 24
      Top = 57
      Width = 197
      Height = 24
      Caption = 'Intervalos comuns entre todos os postos selecionados'
      TabOrder = 1
      WordWrap = True
      OnClick = rb1Click
    end
  end
  object g2: TChart
    Left = 3
    Top = 284
    Width = 458
    Height = 94
    AnimatedZoomSteps = 7
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Color = clBtnFace
    MarginLeft = 5
    MarginRight = 2
    MarginTop = 0
    Title.Text.Strings = (
      '')
    OnClickSeries = Gantt_ClickSeries
    BackColor = clBtnFace
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Axis.Color = clBtnFace
    BottomAxis.Axis.Width = 1
    BottomAxis.DateTimeFormat = 'MM-yyyy'
    BottomAxis.Grid.Visible = False
    BottomAxis.Increment = 1.000000000000000000
    BottomAxis.LabelsAngle = 270
    BottomAxis.LabelsSeparation = 70
    BottomAxis.Maximum = 38292.000000000000000000
    BottomAxis.Minimum = 38239.000000000000000000
    BottomAxis.MinorTickCount = 2
    BottomAxis.StartPosition = 1.000000000000000000
    BottomAxis.EndPosition = 99.000000000000000000
    BottomAxis.PositionPercent = -3.000000000000000000
    BottomAxis.TickLength = 0
    Chart3DPercent = 1
    LeftAxis.Axis.Width = 1
    LeftAxis.Grid.Visible = False
    LeftAxis.LabelsSeparation = 0
    LeftAxis.LabelsSize = 60
    LeftAxis.MinorTickCount = 1
    LeftAxis.MinorTickLength = 1
    LeftAxis.MinorTicks.Width = 0
    LeftAxis.TickLength = 1
    LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
    LeftAxis.Title.Font.Color = clBlue
    LeftAxis.Title.Font.Height = -11
    LeftAxis.Title.Font.Name = 'Arial'
    LeftAxis.Title.Font.Style = []
    Legend.Visible = False
    TopAxis.Axis.Width = 1
    View3D = False
    View3DWalls = False
    BevelInner = bvLowered
    BevelOuter = bvSpace
    Color = clWindow
    TabOrder = 2
    OnMouseMove = Gantt_MouseMove
  end
  object g1: TChart
    Left = 3
    Top = 133
    Width = 458
    Height = 128
    AnimatedZoomSteps = 7
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Color = clBtnFace
    MarginLeft = 5
    MarginRight = 2
    MarginTop = 0
    Title.Text.Strings = (
      '')
    OnClickSeries = Gantt_ClickSeries
    BackColor = clBtnFace
    BottomAxis.Axis.Color = clBtnFace
    BottomAxis.Axis.Width = 1
    BottomAxis.DateTimeFormat = 'MM-yyyy'
    BottomAxis.Grid.Visible = False
    BottomAxis.Increment = 1.000000000000000000
    BottomAxis.LabelsAngle = 270
    BottomAxis.LabelsSeparation = 70
    BottomAxis.MinorTickCount = 2
    BottomAxis.StartPosition = 1.000000000000000000
    BottomAxis.EndPosition = 99.000000000000000000
    BottomAxis.PositionPercent = -3.000000000000000000
    BottomAxis.TickLength = 0
    Chart3DPercent = 1
    LeftAxis.Axis.Width = 1
    LeftAxis.Grid.Visible = False
    LeftAxis.LabelsSeparation = 0
    LeftAxis.LabelsSize = 60
    LeftAxis.MinorTickCount = 1
    LeftAxis.MinorTickLength = 1
    LeftAxis.MinorTicks.Width = 0
    LeftAxis.TickLength = 1
    LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
    LeftAxis.Title.Font.Color = clBlue
    LeftAxis.Title.Font.Height = -11
    LeftAxis.Title.Font.Name = 'Arial'
    LeftAxis.Title.Font.Style = []
    Legend.Visible = False
    TopAxis.Axis.Width = 1
    View3D = False
    View3DWalls = False
    BevelInner = bvLowered
    BevelOuter = bvSpace
    Color = clWindow
    TabOrder = 3
    OnMouseMove = Gantt_MouseMove
  end
  object meDI: TMaskEdit
    Left = 5
    Top = 400
    Width = 82
    Height = 21
    EditMask = '!90/90/0000;1; '
    MaxLength = 10
    TabOrder = 4
    Text = '  /  /    '
  end
  object meDF: TMaskEdit
    Left = 113
    Top = 400
    Width = 82
    Height = 21
    EditMask = '!90/90/0000;1; '
    MaxLength = 10
    TabOrder = 5
    Text = '  /  /    '
  end
end

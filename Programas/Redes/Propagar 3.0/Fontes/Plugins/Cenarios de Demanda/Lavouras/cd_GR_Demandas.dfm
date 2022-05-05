object foGR_Demandas: TfoGR_Demandas
  Left = 198
  Top = 91
  Width = 550
  Height = 338
  Caption = ' Demand Graphic'
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
  object G: TChart
    Left = 0
    Top = 0
    Width = 542
    Height = 309
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWindow
    MarginBottom = 5
    MarginLeft = 10
    Title.AdjustFrame = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BackColor = clWindow
    BottomAxis.AxisValuesFormat = '0.###'
    BottomAxis.Title.Caption = 'Months'
    BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
    BottomAxis.Title.Font.Color = clBlue
    BottomAxis.Title.Font.Height = -11
    BottomAxis.Title.Font.Name = 'Arial'
    BottomAxis.Title.Font.Style = []
    DepthAxis.AxisValuesFormat = '0.###'
    LeftAxis.AxisValuesFormat = '0.###'
    LeftAxis.LabelsSize = 12
    LeftAxis.Title.Caption = 'Demands'
    LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
    LeftAxis.Title.Font.Color = clBlue
    LeftAxis.Title.Font.Height = -11
    LeftAxis.Title.Font.Name = 'Arial'
    LeftAxis.Title.Font.Style = []
    RightAxis.AxisValuesFormat = '0.###'
    TopAxis.AxisValuesFormat = '0.###'
    View3D = False
    Align = alClient
    ParentShowHint = False
    PopupMenu = Menu
    ShowHint = False
    TabOrder = 0
  end
  object Menu: TPopupMenu
    Left = 64
    Top = 49
    object Menu_3D: TMenuItem
      Caption = '3D'
      OnClick = Menu_3DClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Menu_Copiar: TMenuItem
      Caption = 'Copiar'
      OnClick = Menu_CopiarClick
    end
  end
end

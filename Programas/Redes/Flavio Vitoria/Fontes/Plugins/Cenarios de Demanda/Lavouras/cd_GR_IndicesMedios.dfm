object foGR_IndicesMedios: TfoGR_IndicesMedios
  Left = 181
  Top = 116
  Width = 550
  Height = 338
  Caption = ' Average indicators'
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
    Height = 311
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWindow
    MarginBottom = 2
    MarginLeft = 1
    MarginRight = 4
    MarginTop = 2
    Title.AdjustFrame = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BackColor = clWindow
    BottomAxis.AxisValuesFormat = '####'
    BottomAxis.Title.Caption = 'Managements'
    BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
    BottomAxis.Title.Font.Color = clBlue
    BottomAxis.Title.Font.Height = -11
    BottomAxis.Title.Font.Name = 'Arial'
    BottomAxis.Title.Font.Style = []
    LeftAxis.LabelsSize = 60
    LeftAxis.MinorTickCount = 0
    LeftAxis.RoundFirstLabel = False
    LeftAxis.Title.Caption = 'xxx'
    LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
    LeftAxis.Title.Font.Color = clBlue
    LeftAxis.Title.Font.Height = -11
    LeftAxis.Title.Font.Name = 'Arial'
    LeftAxis.Title.Font.Style = []
    Legend.Alignment = laTop
    Legend.LegendStyle = lsSeries
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
      Checked = True
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

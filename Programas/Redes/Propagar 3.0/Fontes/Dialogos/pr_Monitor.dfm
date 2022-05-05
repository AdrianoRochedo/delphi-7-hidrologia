object DLG_Monitor: TDLG_Monitor
  Left = 339
  Top = 264
  Width = 458
  Height = 306
  Caption = ' Monitor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pa_Ferramentas: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 42
    Align = alTop
    TabOrder = 0
    object sbOpt: TSpeedButton
      Left = 4
      Top = 7
      Width = 105
      Height = 28
      Caption = 'Op'#231#245'es ...'
      Flat = True
      PopupMenu = Menu
      OnClick = OpcoesClick
    end
    object Label1: TLabel
      Left = 219
      Top = 4
      Width = 33
      Height = 13
      Caption = 'Pausa:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbPausar: TSpeedButton
      Left = 280
      Top = 7
      Width = 32
      Height = 28
      Hint = ' Pausa a Simula'#231#227'o '
      Enabled = False
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333388888338888833300000830000083330BBB0830BBB083330B7B0830B7B
        083330BBB0830BBB0833307B708307B7083330BBB0830BBB083330B7B0830B7B
        083330BBB0830BBB0833307B708307B7083330BBB0830BBB083330B7B0830B7B
        083330BBB0830BBB083330000033000003333333333333333333}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbPausarClick
    end
    object sbContinuar: TSpeedButton
      Left = 312
      Top = 7
      Width = 32
      Height = 28
      Hint = ' Continua a Simula'#231#227'o '
      Flat = True
      Glyph.Data = {
        06010000424D060100000000000076000000280000000B000000120000000100
        0400000000009000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333333A
        000033833333333F00003088333333380000300883333337000030A088333338
        000030AA088333300000307A70883338000030AAAA08833F000030A7A7A08837
        000030AAAAAA03300000307A7A703338000030AAAA033338000030A7A0333330
        000030AA0333333800003070333333380000300333333338000030333333333F
        00003333333333300000}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbContinuarClick
    end
    object Label2: TLabel
      Left = 388
      Top = 4
      Width = 45
      Height = 13
      Caption = 'Parar em:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbParar: TSpeedButton
      Left = 344
      Top = 7
      Width = 32
      Height = 28
      Hint = ' Termina a Simula'#231#227'o '
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333333333333333EEEEEEEEEEEEEEE333FFFFFFFFFFFFF3E00000000000
        00E337777777777777F3E0F77777777770E337F33333333337F3E0F333333333
        70E337F33333333337F3E0F33333333370E337F333FFFFF337F3E0F330000033
        70E337F3377777F337F3E0F33000003370E337F3377777F337F3E0F330000033
        70E337F3377777F337F3E0F33000003370E337F3377777F337F3E0F330000033
        70E337F33777773337F3E0F33333333370E337F33333333337F3E0F333333333
        70E337F33333333337F3E0FFFFFFFFFFF0E337FFFFFFFFFFF7F3E00000000000
        00E33777777777777733EEEEEEEEEEEEEEE33333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbPararClick
    end
    object rbLinhas: TRadioButton
      Left = 118
      Top = 22
      Width = 59
      Height = 17
      Caption = 'Linhas'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbBarras: TRadioButton
      Left = 118
      Top = 4
      Width = 59
      Height = 17
      Caption = 'Barras'
      TabOrder = 1
    end
    object cb3D: TCheckBox
      Left = 177
      Top = 4
      Width = 39
      Height = 17
      Caption = '3D'
      TabOrder = 2
      OnClick = cb3DClick
    end
    object edPausa: TdrEdit
      Left = 219
      Top = 18
      Width = 49
      Height = 19
      Hint = ' Indica o Tamanho da Pausa (em milisegundos) '
      BeepOnError = False
      DataType = dtInteger
      AutoSize = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '0'
      OnChange = edPausaChange
    end
    object edPararEm: TdrEdit
      Left = 388
      Top = 18
      Width = 49
      Height = 19
      Hint = ' Pausa a Simula'#231#227'o no intervalo determinado '
      BeepOnError = False
      DataType = dtInteger
      AutoSize = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '0'
    end
  end
  object Grafico: TChart
    Left = 0
    Top = 42
    Width = 450
    Height = 235
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    TabOrder = 1
  end
  object Menu: TPopupMenu
    Left = 36
    Top = 98
    object Menu_DefinirVariaveis: TMenuItem
      Caption = '&Definir Vari'#225'veis ...'
      OnClick = sbDVClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Menu_Copiar: TMenuItem
      Caption = '&Copiar'
      OnClick = Menu_CopiarClick
    end
  end
end

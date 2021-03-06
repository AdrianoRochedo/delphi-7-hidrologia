inherited foAreaDeProjeto_Zoom: TfoAreaDeProjeto_Zoom
  Left = 288
  Top = 175
  Width = 469
  Caption = 'foAreaDeProjeto_Zoom'
  OldCreateOrder = True
  OnDblClick = nil
  OnMouseDown = nil
  OnMouseMove = nil
  OnMouseUp = nil
  PixelsPerInch = 96
  TextHeight = 13
  object ZoomPanel: TPanZoomPanel [0]
    Left = 0
    Top = 28
    Width = 461
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    OnMouseDown = ZoomPanel_MouseDown
    OnMouseMove = ZoomPanel_MouseMove
    OnMouseUp = ZoomPanel_MouseUp
    ProportionalZoom = False
    RubberBandWidth = 1
    ShowScalePoints = False
  end
  inherited StatusBar: TStatusBar
    Width = 461
  end
  inherited Progresso: TProgressBar
    Width = 461
  end
  object TopPanel: TPanel [4]
    Left = 0
    Top = 0
    Width = 461
    Height = 28
    Align = alTop
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 4
    object sbZoomOut: TSpeedButton
      Left = 5
      Top = 3
      Width = 23
      Height = 22
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
        4466666666666664744666666666664744466666666664744466666600004744
        46666600777F8444666660877777F8086666607777777F066666077777777770
        6666077777777770666607F700007770666607F777777770666660FF77777706
        6666608FFF777806666666007777006666666666000066666666}
      ParentFont = False
      OnClick = sbZoomOutClick
    end
    object sbZoomIn: TSpeedButton
      Left = 30
      Top = 3
      Width = 23
      Height = 22
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
        4466666666666664744666666666664744466666666664744466666600004744
        46666600777F8444666660877777F8086666607770777F066666077770777770
        6666077000007770666607F770777770666607F770777770666660FF77777706
        6666608FFF777806666666007777006666666666000066666666}
      ParentFont = False
      OnClick = sbZoomInClick
    end
    object sbZoom100: TSpeedButton
      Left = 80
      Top = 3
      Width = 23
      Height = 22
      Hint = 'Visualiza 100% da imagem'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
        5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
        335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
        C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
        CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
        C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
        CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
        5555555775FFFF77555555555C4CCC5555555555577777555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoom100Click
    end
    object btnAbrir: TSpeedButton
      Left = 105
      Top = 3
      Width = 89
      Height = 23
      Hint = 
        '  Importa um projeto existente sem capacidade de zoom. '#13#10'  O pro' +
        'jeto precisa possuir uma imagem de fundo definida '#13#10'            ' +
        '   para que funcione corretamente.'
      Caption = 'Importar ...'
      Flat = True
      Glyph.Data = {
        2A010000424D2A010000000000007600000028000000110000000F0000000100
        040000000000B400000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFF0000000FF00000000000000F0000000F888888888888880F0000000F8FB
        7B7B7B7B7B80F0000000F8F7B7B7B7B7B780F0000000F8FB7B7B7B7B7B80F000
        0000F8F7B7B7B7B7B780F0000000F8FB7B7B7B7B7B80F0000000F8F7B7B7B7B7
        B780F0000000F8FB7B7B7B7B7B80F0000000F8FFFFFFFFFFFF80F0000000F87B
        7B7B7888888FF0000000FF87B7B78FFFFFFFF0000000FFF88888FFFFFFFFF000
        0000FFFFFFFFFFFFFFFFF0000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnAbrirClick
    end
    object sbFit: TSpeedButton
      Left = 55
      Top = 3
      Width = 23
      Height = 22
      Hint = 'Redimensiona a imagem para caber na janela'
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800008777777777777777777800008CCCCCCCCCCCCCCCCC7800008C88
        8888808888888C7800008C888888000888888C7800008C888880808088888C78
        00008C888888808888888C7800008C888888808888888C7800008C8808888088
        88088C7800008C808888808888808C7800008C000000000000000C7800008C80
        8888808888808C7800008C880888808888088C7800008C888888808888888C78
        00008C888888808888888C7800008C888880808088888C7800008C8888880008
        88888C7800008C888888808888888C7800008CCCCCCCCCCCCCCCCC7800008888
        88888888888888880000}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbFitClick
    end
  end
  inherited SaveDialog: TSaveDialog
    Left = 44
    Top = 37
  end
  inherited ObjectMenu: TPopupMenu
    Left = 44
    Top = 91
  end
  object Open: TOpenDialog
    DefaultExt = 'propagar'
    Filter = 'Arquivos Propagar|*.propagar|Todos|*.*'
    Title = ' Importar ...'
    Left = 43
    Top = 150
  end
end

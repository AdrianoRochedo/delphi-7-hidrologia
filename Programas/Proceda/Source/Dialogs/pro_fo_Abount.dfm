object foAbout: TfoAbout
  Left = 107
  Top = 100
  Width = 639
  Height = 423
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Equipe de desenvolvimento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline FrameAbout: TfrAbout
    Left = 0
    Top = 0
    Width = 631
    Height = 395
    Align = alClient
    TabOrder = 0
    inherited WebBrowser: TWebBrowser
      Width = 631
      Height = 395
      ControlData = {
        4C00000037410000D32800000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end

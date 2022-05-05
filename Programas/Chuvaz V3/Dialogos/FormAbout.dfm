object FAbout: TFAbout
  Left = 286
  Top = 193
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Equipe de desenvolvimento'
  ClientHeight = 396
  ClientWidth = 631
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
  inline FrameAbout: TFrame1
    Left = 1
    Top = 0
    Width = 625
    Height = 396
    TabOrder = 0
    inherited Panel1: TPanel
      inherited WebBrowser1: TWebBrowser
        ControlData = {
          4C000000BC3E0000732600000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
end

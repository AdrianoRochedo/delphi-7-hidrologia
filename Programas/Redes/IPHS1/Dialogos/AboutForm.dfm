object iphs1_Form_About: Tiphs1_Form_About
  Left = 188
  Top = 36
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = ' Informa'#231#245'es Gerais'
  ClientHeight = 513
  ClientWidth = 691
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 126
    Top = 101
    Width = 438
    Height = 10
    Shape = bsTopLine
    Style = bsRaised
  end
  object Panel1: TPanel
    Left = 6
    Top = 6
    Width = 679
    Height = 89
    BevelWidth = 2
    TabOrder = 0
    object PBCreditos: TPaintBox
      Left = 2
      Top = 2
      Width = 675
      Height = 85
      Align = alClient
    end
  end
  object btnFechar: TBitBtn
    Left = 267
    Top = 476
    Width = 155
    Height = 27
    Caption = '&Fechar'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    NumGlyphs = 2
  end
  inline TFrame_About1: TFrame_About
    Left = 6
    Top = 109
    Width = 678
    Height = 355
    Color = clBlack
    ParentColor = False
    TabOrder = 2
    inherited Panel2: TPanel
      Width = 678
      inherited Label3: TLabel
        Left = 159
      end
      inherited Label4: TLabel
        Left = 174
      end
      inherited Label6: TLabel
        Left = 118
      end
      inherited Label7: TLabel
        Left = 234
      end
      inherited Image1: TImage
        Left = 196
      end
      inherited Image2: TImage
        Left = 301
      end
    end
  end
end

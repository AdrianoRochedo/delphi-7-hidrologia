inherited ScenariosDesigner: TScenariosDesigner
  Left = 530
  Top = 135
  Width = 389
  Caption = 'ScenariosDesigner'
  FormStyle = fsMDIChild
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited TopPanel: TPanel
    Width = 381
    object sbBG: TSpeedButton [3]
      Left = 107
      Top = 3
      Width = 38
      Height = 22
      Caption = 'BG ...'
      Flat = True
      OnClick = sbBGClick
    end
  end
  inherited ZoomPanel: TPanZoomPanel
    Width = 381
  end
  object OpenPicture: TOpenPictureDialog
    Filter = 'All (*.jpg;*.jpeg;*.bmp)|*.jpg;*.jpeg;*.bmp'
    Title = ' Choose background image'
    Left = 73
    Top = 64
  end
end

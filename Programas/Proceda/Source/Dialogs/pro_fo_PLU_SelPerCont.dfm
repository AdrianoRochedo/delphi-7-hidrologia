object foPLU_SelPerCont: TfoPLU_SelPerCont
  Left = 297
  Top = 148
  Width = 320
  Height = 358
  Caption = ' Sele'#231#227'o de Per'#237'odos'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frPer: TFrameCheckListBox
    Left = 11
    Top = 6
    Width = 289
    Height = 282
    TabOrder = 0
    inherited lbItems: TCheckListBox
      Width = 289
      Height = 266
      Font.Charset = ANSI_CHARSET
      Font.Name = 'Courier New'
      ItemHeight = 14
      ParentFont = False
    end
    inherited Panel: TPanel
      Width = 289
      Caption = 'Selecione dois per'#237'odos:'
    end
  end
  object btnOk: TButton
    Left = 11
    Top = 296
    Width = 124
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 141
    Top = 296
    Width = 124
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end

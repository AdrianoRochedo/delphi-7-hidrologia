object iphs1_Dialogo_EscolherObjetos: Tiphs1_Dialogo_EscolherObjetos
  Left = 339
  Top = 110
  Width = 199
  Height = 339
  Caption = ' Escolher Objetos'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 6
    Top = 279
    Width = 87
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancelat: TButton
    Left = 96
    Top = 279
    Width = 88
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
  inline FO: TFrameCheckListBox
    Left = 6
    Top = 6
    Width = 178
    Height = 265
    TabOrder = 0
    inherited lbItems: TCheckListBox
      Width = 178
      Height = 249
    end
    inherited Panel: TPanel
      Width = 178
    end
  end
end

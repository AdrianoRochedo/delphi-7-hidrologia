object Form1: TForm1
  Left = 449
  Top = 228
  Width = 307
  Height = 184
  Caption = 'Selecionar diret'#243'rio de Banco de Dados'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline FrameDialogOpSv1: TFrameDialogOpSv
    Left = 2
    Top = 2
    Width = 297
    Height = 154
    TabOrder = 0
    inherited FileListBox1: TFileListBox
      Mask = '*.db'
    end
    inherited FilterComboBox1: TFilterComboBox
      Filter = 
        'Banco de dados Paradox (*.db)|*.db|Todos os tipos de arquivo (*.' +
        '*)|*.*'
    end
    inherited Button1: TButton
      Caption = 'Selecionar'
      OnClick = FrameDialogOpSv1Button1Click
    end
  end
end

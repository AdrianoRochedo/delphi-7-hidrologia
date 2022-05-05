object FrameListBox: TFrameListBox
  Left = 0
  Top = 0
  Width = 176
  Height = 169
  TabOrder = 0
  object ListBox: TListBox
    Left = 0
    Top = 0
    Width = 176
    Height = 169
    Align = alClient
    ItemHeight = 13
    PopupMenu = PMListBox
    TabOrder = 0
  end
  object PMListBox: TPopupMenu
    object Remover1: TMenuItem
      Caption = '&Remover'
      OnClick = Remover1Click
    end
  end
end

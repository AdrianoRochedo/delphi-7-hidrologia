object foSel_Man_Res: TfoSel_Man_Res
  Left = 177
  Top = 103
  BorderStyle = bsDialog
  Caption = ' New Management: Select the files need for the simulation'
  ClientHeight = 194
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sbRes: TSpeedButton
    Tag = 5
    Left = 460
    Top = 137
    Width = 24
    Height = 21
    Caption = '...'
    OnClick = sbResClick
  end
  object sbMan: TSpeedButton
    Tag = 5
    Left = 460
    Top = 95
    Width = 24
    Height = 21
    Caption = '...'
    OnClick = sbManClick
  end
  object edRes: TEdit
    Left = 4
    Top = 137
    Width = 457
    Height = 21
    TabOrder = 0
  end
  object Panel8: TPanel
    Left = 4
    Top = 116
    Width = 480
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Water Restriction File (*.res)'
    TabOrder = 1
  end
  object edPasta: TEdit
    Left = 4
    Top = 53
    Width = 480
    Height = 21
    Color = clSilver
    ReadOnly = True
    TabOrder = 2
  end
  object Panel12: TPanel
    Left = 4
    Top = 32
    Width = 480
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Project Directory:'
    TabOrder = 3
  end
  object Panel13: TPanel
    Left = 4
    Top = 5
    Width = 479
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Files:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object edMan: TEdit
    Left = 4
    Top = 95
    Width = 457
    Height = 21
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 4
    Top = 74
    Width = 480
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Water Management File (*.esq)'
    TabOrder = 6
  end
  object btnOk: TButton
    Left = 5
    Top = 164
    Width = 95
    Height = 25
    Caption = 'Ok'
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 104
    Top = 164
    Width = 95
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object Open: TOpenDialog
    Left = 376
    Top = 7
  end
end

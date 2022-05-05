object Form_Dialogo_Base: TForm_Dialogo_Base
  Left = 219
  Top = 143
  ActiveControl = edNome
  BorderStyle = bsDialog
  ClientHeight = 163
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object edNome: TEdit
    Left = 5
    Top = 29
    Width = 163
    Height = 21
    MaxLength = 20
    TabOrder = 0
  end
  object P1: TPanel
    Left = 5
    Top = 8
    Width = 163
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Nome:'
    TabOrder = 1
  end
  object edDescricao: TEdit
    Left = 168
    Top = 29
    Width = 280
    Height = 21
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 169
    Top = 8
    Width = 279
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Descri'#231#227'o:'
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 6
    Top = 50
    Width = 442
    Height = 21
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' Coment'#225'rios:'
    TabOrder = 4
  end
  object mComentarios: TMemo
    Left = 5
    Top = 71
    Width = 443
    Height = 52
    TabOrder = 5
  end
  object btnOk: TBitBtn
    Left = 6
    Top = 132
    Width = 89
    Height = 25
    Caption = '&Ok'
    TabOrder = 6
    OnClick = btnOkClick
  end
  object btnCancelar: TBitBtn
    Left = 98
    Top = 132
    Width = 89
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 7
    OnClick = btnCancelarClick
  end
end

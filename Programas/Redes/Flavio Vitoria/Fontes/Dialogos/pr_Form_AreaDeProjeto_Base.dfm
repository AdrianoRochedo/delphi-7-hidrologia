object foAreaDeProjeto_Base: TfoAreaDeProjeto_Base
  Left = 195
  Top = 108
  Width = 472
  Height = 304
  Caption = 'foAreaDeProjeto_Base'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = Form_Activate
  OnClick = Mouse_Click
  OnClose = Form_Close
  OnCloseQuery = Form_CloseQuery
  OnDblClick = Mouse_DuploClick
  OnKeyDown = Form_KeyDown
  OnMouseDown = Mouse_Down
  OnMouseMove = Mouse_Move
  OnMouseUp = Mouse_Up
  PixelsPerInch = 96
  TextHeight = 13
  object mmMensagemInicial: TMemo
    Left = 96
    Top = 22
    Width = 277
    Height = 199
    BevelKind = bkTile
    BevelOuter = bvNone
    BorderStyle = bsNone
    Lines.Strings = (
      ''
      '   Construa a rede hidrol'#243'gica utilizando a paleta de '
      '   componentes ao lado. '
      ''
      '   Os objeto centrais s'#227'o o PC (quadrado) e o '
      '   Reservat'#243'rio (Tri'#226'ngulo), eles s'#227'o conectados '
      '   atrav'#233's de trechos-d'#225'gua formando assim uma rede. '
      '   Voc'#234' tamb'#233'm poder'#225' conectar outros objetos a estes '
      '   componentes tais como sub-bacias e deriva'#231#245'es.'
      ''
      '   Um duplo-click na janela ou em um componente abrir'#225
      '   seu di'#225'logo de dados. Os objetos tamb'#233'm possuem '
      '   menus suspensos que s'#227'o ativados atrav'#233's do bot'#227'o'
      '   de fun'#231#227'o de seu "mouse".')
    ReadOnly = True
    TabOrder = 0
    Visible = False
    WordWrap = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 256
    Width = 464
    Height = 19
    Panels = <
      item
        Width = 120
      end>
  end
  object Progresso: TProgressBar
    Left = 0
    Top = 240
    Width = 464
    Height = 16
    Align = alBottom
    Step = 1
    TabOrder = 2
    Visible = False
  end
  object SaveDialog: TSaveDialog
    Tag = 1
    DefaultExt = 'propagar'
    Filter = 'Propagar 3.0 (*.propagar)|*.propagar'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Salvar projeto como'
    Left = 20
    Top = 9
  end
  object ObjectMenu: TPopupMenu
    AutoPopup = False
    Left = 22
    Top = 68
  end
end

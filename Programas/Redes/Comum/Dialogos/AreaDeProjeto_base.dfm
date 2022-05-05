object Form_AreaDeProjeto_base: TForm_AreaDeProjeto_base
  Left = 82
  Top = 78
  Width = 431
  Height = 271
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnActivate = Form_Activate
  OnClick = Form_Click
  OnClose = Form_Close
  OnCloseQuery = Form_CloseQuery
  OnCreate = Form_Create
  OnDblClick = Form_Dbl_Click
  OnDestroy = Form_Destroy
  OnDeactivate = Form_Deactivate
  OnKeyDown = FormKeyDown
  OnMouseDown = Form_MouseDown
  OnMouseMove = Form_MouseMove
  OnMouseUp = Form_MouseUp
  OnPaint = Form_Paint
  OnResize = Form_Resize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Progresso: TProgressBar
    Left = 0
    Top = 226
    Width = 423
    Height = 16
    Align = alBottom
    Step = 1
    TabOrder = 0
    Visible = False
  end
  object paMensagemInicial: TPanel
    Left = 51
    Top = 13
    Width = 326
    Height = 200
    Color = clWindow
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 305
      Height = 26
      AutoSize = False
      Caption = 
        'Construa a rede hidrol'#243'gica utilizando a paleta de componentes a' +
        'o lado.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 49
      Width = 165
      Height = 18
      AutoSize = False
      Caption = 'Os objetos dispon'#237'veis s'#227'o os PCs'
      WordWrap = True
    end
    object Image1: TImage
      Left = 176
      Top = 45
      Width = 20
      Height = 19
      Picture.Data = {
        07544269746D617066010000424D660100000000000076000000280000001400
        0000140000000100040000000000F00000000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777777
        777777770000777777777777777777770000777F00000000000077770000777F
        0CCCCCCCCCC077770000777F0CCCCCCCCCC077770000777F0CCCCCCCCCC07777
        0000777F0CCCCCCCCCC077770000777F0CCCCCCCCCC077770000777F0CCCCCCC
        CCC077770000777F0CCCCCCCCCC077770000777F0CCCCCCCCCC077770000777F
        0CCCCCCCCCC077770000777F0CCCCCCCCCC077770000777F0000000000007777
        0000777FFFFFFFFFFFFF77770000777777777777777777770000777777777777
        777777770000777777777777777777770000}
      Transparent = True
    end
    object Label3: TLabel
      Left = 244
      Top = 117
      Width = 16
      Height = 21
      AutoSize = False
      Caption = 'D'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 8
      Top = 67
      Width = 251
      Height = 18
      AutoSize = False
      Caption = 'que s'#227'o os n'#243's do sistema a ser simulado, as bacias '
    end
    object Image2: TImage
      Left = 261
      Top = 65
      Width = 20
      Height = 19
      Picture.Data = {
        07544269746D617066010000424D660100000000000076000000280000001400
        0000140000000100040000000000F00000000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777777
        7777777700007777777777777777007700007777777777700000C07700007777
        777000000BCC077700007777700BBBBBBCC07777000077770BBBBBBBCBB07777
        00007770BCCCCCBCBB07777700007770BCBBBCCBBB0777770000770BCBBBBCCB
        BB0777770000770BBBBBBCBCB07777770000770BBBBCCCBBB077777700007770
        BBCBBCBB0777777700007770BCBBBCBB0777777700007770BBBBBBB077777777
        0000777700BBB007777777770000777777000777777777770000777777777777
        777777770000777777777777777777770000}
      Transparent = True
    end
    object Label5: TLabel
      Left = 286
      Top = 67
      Width = 18
      Height = 13
      Caption = 'que'
    end
    object Label6: TLabel
      Left = 8
      Top = 85
      Width = 303
      Height = 19
      AutoSize = False
      Caption = 'representam a simula'#231#227'o P-Q, e os trechos de escoamento em'
    end
    object Label7: TLabel
      Left = 8
      Top = 103
      Width = 60
      Height = 19
      AutoSize = False
      Caption = 'rio ou canal'
      WordWrap = True
    end
    object Image3: TImage
      Left = 69
      Top = 103
      Width = 38
      Height = 15
      Picture.Data = {
        07544269746D6170A2010000424DA20100000000000076000000280000002400
        00000F00000001000400000000002C0100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFF0FFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFF0000FFFF
        FFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF0FFFFFFFFF
        FFFFFFFF0000FFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFF0FFFFFFFFFFFFFFF0000F0000000000000000000000000000000000F
        0000FFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFF0
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFF0000FFFF
        FFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF0FFFFFFFFFFF
        FFFFFFFF0000FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000}
      Transparent = True
    end
    object Label8: TLabel
      Left = 113
      Top = 103
      Width = 204
      Height = 19
      AutoSize = False
      Caption = '( Trechos - D'#225'gua )  formando assim uma '
      WordWrap = True
    end
    object Label9: TLabel
      Left = 8
      Top = 121
      Width = 235
      Height = 19
      AutoSize = False
      Caption = 'rede. Voc'#234' tamb'#233'm poder'#225' conectar Deriva'#231#245'es '
      WordWrap = True
    end
    object Label10: TLabel
      Left = 262
      Top = 121
      Width = 47
      Height = 16
      AutoSize = False
      Caption = 'aos n'#243's.'
      WordWrap = True
    end
    object Image4: TImage
      Left = 294
      Top = 45
      Width = 21
      Height = 21
      Picture.Data = {
        07544269746D617066010000424D660100000000000076000000280000001400
        0000140000000100040000000000F00000000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777777
        777007770000777777777777700C077700007777777777700CCC077700007777
        7777700CCCCC07770000777777700CCCCCCC077700007777700CCCCCCCCC0777
        000077700CCCCCCCCCCC07770000770CCCCCCCCCCCCC0777000077FCCCCCCCCC
        CCCC07770000777FFCCCCCCCCCCC0777000077777FFCCCCCCCCC077700007777
        777FFCCCCCCC07770000777777777FFCCCCC0777000077777777777FFCCC0777
        00007777777777777FFC07770000777777777777777FF7770000777777777777
        777777770000777777777777777777770000}
      Transparent = True
    end
    object Label11: TLabel
      Left = 201
      Top = 49
      Width = 92
      Height = 15
      AutoSize = False
      Caption = 'e os Reservat'#243'rios'
    end
    object Label12: TLabel
      Left = 8
      Top = 149
      Width = 309
      Height = 47
      AutoSize = False
      Caption = 
        'Um duplo-click na janela ou em um componente abrir'#225' seu di'#225'logo ' +
        'de dados. Os objetos tamb'#233'm possuem menus suspensos que s'#227'o ativ' +
        'ados atrav'#233's do bot'#227'o de fun'#231#227'o de seu "mouse".'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object SaveDialog: TSaveDialog
    Tag = 1
    DefaultExt = 'iphs1'
    Filter = 'Arquivo IPHS1 (*.iphs1)|*.iphs1'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Salvar projeto como'
    Left = 12
    Top = 7
  end
end

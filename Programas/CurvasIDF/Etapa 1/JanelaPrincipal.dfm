object foJP: TfoJP
  Left = 140
  Top = 80
  Width = 724
  Height = 485
  Anchors = []
  Caption = ' IPHS1 - Curvas IDF 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 457
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Book: TPageControl
      Left = 4
      Top = 4
      Width = 708
      Height = 449
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 1
      TabOrder = 0
      object Tab2: TTabSheet
        Caption = 'Equa'#231#245'es'
        ImageIndex = 1
        object Label7: TLabel
          Left = 20
          Top = 13
          Width = 51
          Height = 13
          Caption = 'Equa'#231#245'es:'
        end
        object lbDE_Equacoes: TListBox
          Left = 20
          Top = 27
          Width = 222
          Height = 384
          Hint = 
            'Equa'#231#245'es j'#225' definidas.'#13#10'Selecione uma Equa'#231#227'o para mostrar suas ' +
            'propriedades.'
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lbDE_EquacoesClick
        end
        object GroupBox1: TGroupBox
          Left = 251
          Top = 22
          Width = 410
          Height = 389
          Caption = ' Dados: '
          TabOrder = 1
          object Label11: TLabel
            Left = 25
            Top = 185
            Width = 61
            Height = 13
            Caption = 'Coment'#225'rios:'
          end
          object Label2: TLabel
            Left = 25
            Top = 68
            Width = 46
            Height = 13
            Caption = 'Equa'#231#227'o:'
          end
          object btnAdicionarEq: TButton
            Left = 25
            Top = 352
            Width = 119
            Height = 25
            Hint = 'Adiciona uma defini'#231#227'o de Equa'#231#227'o ainda n'#227'o cadastrada'
            Caption = 'Adicionar'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = btnAdicionarEqClick
          end
          object btnAtualizarEq: TButton
            Left = 147
            Top = 352
            Width = 117
            Height = 25
            Hint = 'Atualiza os campos de uma Equa'#231#227'o j'#225' cadastrada'
            Caption = 'Atualizar'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnAtualizarEqClick
          end
          object btnRemoverEq: TButton
            Left = 267
            Top = 352
            Width = 118
            Height = 25
            Hint = 'Remove a Equa'#231#227'o selecionada'
            Caption = 'Remover'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btnRemoverEqClick
          end
          object edDE_Nome: TLabeledEdit
            Left = 25
            Top = 39
            Width = 360
            Height = 21
            Hint = 'Nome da Equa'#231#227'o.'
            EditLabel.Width = 31
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome:'
            LabelPosition = lpAbove
            LabelSpacing = 2
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnExit = GlobalEditExit
          end
          object mmDE_Coment: TMemo
            Left = 25
            Top = 200
            Width = 360
            Height = 141
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
          end
          object psDE_Codigo: TScriptPascalEditor
            Left = 25
            Top = 83
            Width = 360
            Height = 94
            Cursor = crIBeam
            Hint = 
              'F'#243'rmula da Equa'#231#227'o.'#13#10#13#10'Um padr'#227'o dever'#225' ser utilizado para defin' +
              'i'#231#227'o das f'#243'rmulas:'#13#10'  - A linguagem a ser utilizada '#233' o PascalSc' +
              'ript'#13#10'  - O resultado da equa'#231#227'o dever'#225' ser atribu'#237'do a vari'#225'vel' +
              ' "Result"'#13#10'  - As vari'#225'veis "Duracao" e "Tr" dever'#227'o ser utiliza' +
              'das quando quisermos'#13#10'    referenciar a dura'#231#227'o, fornecida em mi' +
              'nutos e Tr fornecida em anos.'#13#10'  - Os par'#226'metros dever'#227'o ser ref' +
              'enciados como a, b, ..., z e possuir'#227'o'#13#10'    correspond'#234'ncia de o' +
              'rdem com os par'#226'metros informados nas Esta'#231#245'es e '#13#10'    Localidad' +
              'es.'#13#10#13#10'Ex:  Result := Duracao * a + Tr * b'
            ScrollBars = ssNone
            GutterWidth = 0
            RightMarginColor = clSilver
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            Ctl3D = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabStop = True
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clPurple
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clWindowText
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Estados'
        ImageIndex = 3
        object Splitter1: TSplitter
          Left = 227
          Top = 0
          Width = 4
          Height = 421
          Cursor = crHSplit
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 227
          Height = 421
          Align = alLeft
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object Panel2: TPanel
            Left = 5
            Top = 5
            Width = 217
            Height = 37
            Align = alTop
            Anchors = []
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              217
              37)
            object Label15: TLabel
              Left = 1
              Top = -1
              Width = 41
              Height = 13
              Caption = 'Estados:'
            end
            object cbEstado: TComboBox
              Left = 0
              Top = 13
              Width = 217
              Height = 21
              Hint = 
                'Selecione um estado.'#13#10'Ap'#243's, abaixo, ser'#227'o mostratos as localidad' +
                'es'#13#10'e esta'#231#245'es pertencentes a este estado.'
              BevelEdges = [beLeft, beTop]
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 13
              ParentShowHint = False
              ShowHint = True
              Sorted = True
              TabOrder = 0
              OnChange = cbEstadoChange
            end
          end
          object Arvore: TTreeView
            Left = 5
            Top = 42
            Width = 217
            Height = 374
            Hint = 
              #13#10' Selecione uma localidade ou uma esta'#231#227'o'#13#10' para mostrar suas p' +
              'ropriedades ao lado.'#13#10#13#10' Para adicionar uma nova esta'#231#227'o selecio' +
              'ne o n'#243' "Esta'#231#245'es", '#13#10' preencha suas propriedades e precione o b' +
              'ot'#227'o Adicionar.'#13#10' A mesma sequ'#234'ncia vale para o n'#243' "Localidades"' +
              ' '#13#10#13#10
            Align = alClient
            HideSelection = False
            Indent = 19
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            SortType = stText
            TabOrder = 1
            OnChanging = ArvoreChanging
            OnClick = ArvoreClick
          end
        end
        object PageControl1: TPageControl
          Left = 231
          Top = 0
          Width = 469
          Height = 421
          ActivePage = TabSheet2
          Align = alClient
          TabIndex = 0
          TabOrder = 1
          object TabSheet2: TTabSheet
            Caption = 'Esta'#231#245'es e Localidades'
            object Label8: TLabel
              Left = 5
              Top = 55
              Width = 61
              Height = 13
              Caption = 'Coment'#225'rios:'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
            end
            object Label1: TLabel
              Left = 169
              Top = 126
              Width = 41
              Height = 13
              Caption = 'Latitude:'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
            end
            object Label5: TLabel
              Left = 5
              Top = 126
              Width = 50
              Height = 13
              Caption = 'Longitude:'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
            end
            object Label6: TLabel
              Left = 6
              Top = 13
              Width = 31
              Height = 13
              Caption = 'Nome:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object mmEL_Coment: TMemo
              Left = 6
              Top = 69
              Width = 315
              Height = 48
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object GroupBox2: TGroupBox
              Left = 5
              Top = 171
              Width = 315
              Height = 213
              BiDiMode = bdLeftToRight
              Caption = ' Equa'#231#245'es e Par'#226'metros '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentBiDiMode = False
              ParentFont = False
              TabOrder = 1
              DesignSize = (
                315
                213)
              object Label3: TLabel
                Left = 10
                Top = 89
                Width = 46
                Height = 13
                Anchors = [akTop]
                Caption = 'Equa'#231#227'o:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label4: TLabel
                Left = 10
                Top = 20
                Width = 96
                Height = 13
                Caption = 'Equa'#231#245'es definidas:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object lbEL_ED: TListBox
                Left = 10
                Top = 35
                Width = 296
                Height = 47
                Hint = 
                  'Equa'#231#245'es e par'#226'metros definidos para esta Esta'#231#227'o ou Localidade.' +
                  #13#10'Utilize os campos abaixo para definir uma equa'#231#227'o e seus respe' +
                  'ctivos par'#226'metros.'
                Anchors = []
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemHeight = 13
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = lbEL_EDClick
              end
              object edEL_Par: TLabeledEdit
                Left = 10
                Top = 145
                Width = 296
                Height = 21
                Hint = 
                  #13#10' Par'#226'metros da Equa'#231#227'o. '#13#10' Utilize o "." como ponto decimal e ' +
                  'separe os par'#226'metros com um ou mais espa'#231'os.'#13#10' Ex:  0.002  5.6  ' +
                  '32  3.56'#13#10#13#10' Quando uma equa'#231#227'o for avaliada: '#13#10'   - a assumir'#225' ' +
                  'o valor de 0.002'#13#10'   - b assumir'#225' o valor de 5.6'#13#10'   - c assumir' +
                  #225' o valor de 32'#13#10'   - d assumir'#225' o valor de 3.56 e assim por dia' +
                  'nte ...'#13#10' '
                Anchors = []
                EditLabel.Width = 56
                EditLabel.Height = 13
                EditLabel.Caption = 'Par'#226'metros:'
                EditLabel.Font.Charset = DEFAULT_CHARSET
                EditLabel.Font.Color = clBlack
                EditLabel.Font.Height = -11
                EditLabel.Font.Name = 'MS Sans Serif'
                EditLabel.Font.Style = []
                EditLabel.ParentFont = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                LabelPosition = lpAbove
                LabelSpacing = 1
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnExit = GlobalEditExit
              end
              object btnAdicionarEQ_EL: TButton
                Left = 56
                Top = 177
                Width = 80
                Height = 25
                Hint = 
                  'Define uma Equa'#231#227'o para o registro atual.'#13#10'Voc'#234' ainda precisar'#225' ' +
                  'Adicionar/Atualizar o registro que est'#225' sendo editato'#13#10'atrav'#233's d' +
                  'os bot'#245'es localizados acima a direita para que as modifica'#231#245'es'#13#10 +
                  'sejam salvas na mem'#243'ria e no banco de dados.'
                Anchors = []
                Caption = 'Definir'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnClick = btnAdicionarEQ_ELClick
              end
              object btnRemoverEQ_EL: TButton
                Left = 226
                Top = 177
                Width = 80
                Height = 25
                Hint = 
                  'Remove a defini'#231#227'o de uma Equa'#231#227'o para o registro atual.'#13#10'Voc'#234' a' +
                  'inda precisar'#225' Adicionar/Atualizar o registro que est'#225' sendo edi' +
                  'tato'#13#10'atrav'#233's dos bot'#245'es localizados acima a direita para que as' +
                  ' modifica'#231#245'es'#13#10'sejam salvas na mem'#243'ria e no banco de dados.'
                Anchors = []
                Caption = 'Remover'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 5
                OnClick = btnRemoverEQ_ELClick
              end
              object cbEL_Eq: TComboBox
                Left = 10
                Top = 103
                Width = 296
                Height = 21
                Hint = 
                  'Selecione uma equa'#231#227'o.'#13#10'As equa'#231#245'es que aparecem aqui s'#227'o as equ' +
                  'a'#231#245'es definidas na folha "Defini'#231#227'o de Equa'#231#245'es"'
                Style = csDropDownList
                Anchors = []
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemHeight = 13
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
              end
              object btnAtualizarEQ_EL: TButton
                Left = 141
                Top = 177
                Width = 80
                Height = 25
                Hint = 
                  'Atualiza os campos de uma Equa'#231#227'o para o registro atual.'#13#10'Voc'#234' a' +
                  'inda precisar'#225' Adicionar/Atualizar o registro que est'#225' sendo edi' +
                  'tato'#13#10'atrav'#233's dos bot'#245'es localizados acima a direita para que as' +
                  ' modifica'#231#245'es'#13#10'sejam salvas na mem'#243'ria e no banco de dados.'
                Anchors = []
                Caption = 'Atualizar'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 4
                OnClick = btnAtualizarEQ_ELClick
              end
            end
            object btnAdicionarEL: TButton
              Left = 333
              Top = 27
              Width = 96
              Height = 25
              Hint = 
                'Adiciona uma Esta'#231#227'o ou Localidade ainda n'#227'o cadastrados '#13#10'depen' +
                'dento do n'#243' ao lado selecionado.'
              Caption = 'Adicionar'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = btnAdicionarELClick
            end
            object btnRemoverEL: TButton
              Left = 334
              Top = 85
              Width = 95
              Height = 25
              Hint = 'Remove a Esta'#231#227'o/Localidade selecionada.'
              Caption = 'Remover'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = btnRemoverELClick
            end
            object btnAtualizarEL: TButton
              Left = 334
              Top = 56
              Width = 95
              Height = 25
              Hint = 
                'Atualiza as informa'#231#245'es da Esta'#231#227'o ou Localidade '#13#10'selecionada n' +
                'o banco de dados.'
              Caption = 'Atualizar'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = btnAtualizarELClick
            end
            object edEL_Lat: TMaskEdit
              Left = 168
              Top = 141
              Width = 153
              Height = 21
              Hint = 'Formato: graus, minutos e segundos'
              EditMask = '990'#186' 00'#39' 00";1; '
              MaxLength = 12
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              Text = '   '#186'   '#39'   "'
              OnExit = GlobalEditExit
            end
            object edEL_Lon: TMaskEdit
              Left = 5
              Top = 141
              Width = 151
              Height = 21
              Hint = 'Formato: graus, minutos e segundos'
              EditMask = '990'#186' 00'#39' 00";1; '
              MaxLength = 12
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              Text = '   '#186'   '#39'   "'
              OnExit = GlobalEditExit
            end
            object edEL_Nome: TEdit
              Left = 6
              Top = 27
              Width = 315
              Height = 21
              Hint = 'Nome da Esta'#231#227'o ou Localidade'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 7
              OnExit = GlobalEditExit
            end
          end
          object TabSheet3: TTabSheet
            Caption = 'C'#225'lculos'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ImageIndex = 1
            ParentFont = False
            DesignSize = (
              461
              393)
            object Label9: TLabel
              Left = 5
              Top = 4
              Width = 46
              Height = 13
              Caption = 'Equa'#231#227'o:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 269
              Top = 3
              Width = 45
              Height = 13
              Caption = 'Tr (anos):'
            end
            object imEQ: TImage
              Left = 341
              Top = 90
              Width = 101
              Height = 55
              Hint = 
                ' Formato da Equa'#231#227'o Padr'#227'o '#13#10' Esta imagem somente aparece se a '#13 +
                #10' equa'#231#227'o selecionada for a Padr'#227'o.'
              ParentShowHint = False
              Picture.Data = {
                07544269746D61703A0B0000424D3A0B00000000000076000000280000006300
                0000350000000100040000000000C40A00000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF00888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888880000088888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888880000088888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888000008888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888000008888888088888888888888888888
                8888888888888888888888888888888888888888888888888888880888888888
                8888888000008888880888888888888888888888888888888888888888888888
                8888888888888888888888888888888088888888888888800000888888088888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888088888888888888800000888888088888000008888800008808888008
                0888000888800808880008888888088888888800088888808888888888888880
                0000888880888888088880888088808808880880088088808808800880888088
                8888088888888088808888880888888888888880000088888088888808888808
                8088808808880888088088888808880880888088888808888888808888888888
                0888888888888880000088888088888808888808808880880888800008808888
                8880000880888088800000008888808888888888088888888888888000008888
                8088888808888808808880880888888808808888888888088088808888880888
                8888808888888888088888888888888000008888808888880888880880888088
                0088088808808880880888088088808888880888888880888088888808888888
                8888888000008888808888880888880880888088080880008888000888800088
                8800088888880888888888000888888808888888888888800000888880888888
                0888880888888888888888888888888888888888888888888888888888888888
                8888888808888880000888800000888888088888088880888888888888888888
                8888888888888888888888888888888888888888888888808888880888088880
                0000888888088888000008888888888888888888888888888888888888888888
                8888888888888888888888808888880888088880000088888808888888888888
                8888888888888888888888888888888888888888888888888888888888888880
                8888880888088880000088888880888888888888888888888888888888888888
                8888888888888888888888888888888888888808888888088808888000008888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888088008888000008888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888888880
                0808888000008888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888880888800000888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888880888800000888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888088880
                0000888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888880000088888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888880000088888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888000008880
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000088888888888000008888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888000008888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888800000888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888800000888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888888880
                0000888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888880000088888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888880000088888888888888888888888888888000080888888808
                8888888808888808888888888888888888888888888888888888888000008888
                8888888888888888888888880888800888888888888888880888880888888888
                8888888888888888888888888888888000008888888888888888888888888888
                0888880888888888888888880888880888888888888888888888888888888888
                8888888000008888888888888888888888888888088888088888888888888888
                0888880888888888888888888888888888888888888888800000888888888888
                8888888888888888800088088888888888888888088888088888888888888888
                8888888888888888888888800000888888888888888888888888888888880008
                8888888888888888088888088888888888888888888888888888888888888880
                0000888888888888888888888888888808888808888888888888888808888808
                8888880000888888888888888888888888888880000088888888888888888888
                8888888880888808888888888888888808888800888888088808888888888888
                8888888888888880000088888888888888888888888888888800008888888888
                8888888808888808008888088808888888888888888888888888888000008888
                8888888888888888888888888888888888888888888888880888888888888808
                8808888888888888888888888888888000008888888888888888888888888888
                8888888888888888888888880888888888888808880888888888888888888888
                8888888000008888888888888888888888888888888888888888888888880000
                0000088888888800880888888888888888888888888888800000888888888888
                8888888888888888888888888888888888888888888888888888880800888888
                8888888888888888888888800000888888888888888888888888888888888888
                8888888888888888888888888888880888888888888888888888888888888880
                0000888888888888888888888888888888888888888888888888888888888888
                8888880888888888888888888888888888888880000088888888888888888888
                8888888888888888888888888888888888888888888888088888888888888888
                8888888888888880000088888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888000008888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888000008888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                888888800000}
              ShowHint = True
              Visible = False
            end
            object cbC_Eq: TComboBox
              Left = 5
              Top = 18
              Width = 255
              Height = 21
              Hint = 
                'Selecione uma equa'#231#227'o.'#13#10'As equa'#231#245'es que aparecem aqui s'#227'o as equ' +
                'a'#231#245'es definidas para'#13#10'a Esta'#231#227'o/Localidade selecionada ao lado.'
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 0
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = cbC_EqChange
            end
            object BookCalculos: TPageControl
              Left = 19
              Top = 175
              Width = 434
              Height = 214
              ActivePage = TabPlanilha
              Anchors = [akLeft, akTop, akRight, akBottom]
              TabIndex = 0
              TabOrder = 1
              object TabPlanilha: TTabSheet
                Caption = ' Tabela de Intensidades '
                inline paInt: TFramePlanilha
                  Left = 0
                  Top = 15
                  Width = 426
                  Height = 171
                  Align = alClient
                  Anchors = []
                  TabOrder = 0
                  inherited Tab: TF1Book
                    Width = 426
                    Height = 145
                    ParentShowHint = False
                    ShowHint = True
                    OnSelChange = TabSelChange
                    ControlData = {
                      00000100712C00003015000060000000010001074631426F6F6B310101010101
                      0101010101010101010101005D060000000009080800000505006C09C907EE7E
                      040000000000EF7E140000000000000000000000FFFFFFFFFFFFFFFFF1FF3D00
                      1200000000003219030C3800000000000100580222000200000031001400C800
                      0000FF7F900100000000000005417269616C31001400C8000000FF7FBC020000
                      0000000005417269616C31001400C8000200FF7F900100000000000005417269
                      616C31001400C8000200FF7FBC0200000000000005417269616C31001400C800
                      0000FF7F900100000000000005417269616C1E041C0005001922522422232C23
                      23305F293B5C2822522422232C2323305C291E04210006001E22522422232C23
                      23305F293B5B5265645D5C2822522422232C2323305C291E04220007001F2252
                      2422232C2323302E30305F293B5C2822522422232C2323302E30305C291E0427
                      0008002422522422232C2323302E30305F293B5B5265645D5C2822522422232C
                      2323302E30305C291E0432002A002F5F285C242A20232C2323305F293B5F285C
                      242A205C28232C2323305C293B5F285C242A20222D225F293B5F28405F291E04
                      2C002900295F282A20232C2323305F293B5F282A205C28232C2323305C293B5F
                      282A20222D225F293B5F28405F291E043A002C00375F285C242A20232C232330
                      2E30305F293B5F285C242A205C28232C2323302E30305C293B5F285C242A2022
                      2D223F3F5F293B5F28405F291E0434002B00315F282A20232C2323302E30305F
                      293B5F282A205C28232C2323302E30305C293B5F282A20222D223F3F5F293B5F
                      28405F291E041F0032001C2252242022232C2323303B5B5265645D5C2D225224
                      2022232C2323301E0425003300222252242022232C2323302E30303B5B526564
                      5D5C2D2252242022232C2323302E3030ED7E05000000000000EC7E0300000000
                      E000140000000000F5FF2000C02000000000000000000000E000140001000000
                      F5FF20C4C02000000000000000000000E000140001000000F5FF20C4C0200000
                      0000000000000000E000140002000000F5FF20C4C02000000000000000000000
                      E000140002000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E00014000000000001002000C02000000000000000000000
                      E000140005003300F5FF20C8C02000000000000000000000E000140005003200
                      F5FF20C8C02000000000000000000000E000140005000C00F5FF20C8C0200000
                      0000000000000000E000140005000A00F5FF20C8C02000000000000000000000
                      E000140005000D00F5FF20C8C02000000000000000000000E000140004000000
                      F0FF1248C0200000000000000000000093020400108003FF93020400118006FF
                      93020400128004FF93020400138007FF93020400008000FF93020400148005FF
                      85000D00E30400000000065368656574310A00000009080800000510006C09C9
                      070D00020001000C00020064000F000200010011000200000010000800FCA9F1
                      D24D62503F5F00020001002A00020000002B0002000100250204000100FF008C
                      0004000100370081000200C10414000300022641150008000750616765202650
                      83000200000084000200000026000800000000000000E83F2700080000000000
                      0000E83F28000800000000000000F03F29000800000000000000F03FA1002200
                      01006400010001000100060000000000000000000000E03F000000000000E03F
                      010055000200080000020A0000000000000000000000F77E18004A003FCCFFFF
                      FF00C0C0C000FF00FF3F0000000000000000F27E100000000000000000000000
                      00000000FFFFF67E0A00150015001500FF0040061D000F000300000000000001
                      000000000000003E020A0032020000000000000000A000040064006400AB0022
                      002000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFF9900020026090A0000000000000452E30B918FCE119DE300AA004BB851
                      6C7400006C00000001000000580000000000000000000000FFFFFFFFFFFFFFFF
                      00000000000000006C520000B83D000020454D46000001006C00000002000000
                      010000000000000000000000000000002003000058020000D30000009E000000
                      0E0000001400000000000000100000001400000001}
                  end
                  inherited Panel1: TPanel
                    Width = 426
                  end
                  inherited Menu: TPopupMenu
                    inherited Menu_Abrir: TMenuItem
                      Visible = False
                    end
                    inherited Menu_Salvar: TMenuItem
                      Visible = False
                    end
                    inherited N2: TMenuItem
                      Visible = False
                    end
                  end
                end
                object Panel4: TPanel
                  Left = 0
                  Top = 0
                  Width = 426
                  Height = 15
                  Align = alTop
                  BevelOuter = bvNone
                  Caption = 'Tr'
                  Color = clBlue
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clYellow
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 1
                end
              end
              object TabGrafico: TTabSheet
                Caption = ' Gr'#225'fico '
                ImageIndex = 1
              end
              object TabDesag: TTabSheet
                Caption = 'Alt. L'#226'm. Acumulada'
                ImageIndex = 2
                inline paALA: TFramePlanilha
                  Left = 0
                  Top = 15
                  Width = 426
                  Height = 171
                  Align = alClient
                  Anchors = []
                  TabOrder = 0
                  inherited Tab: TF1Book
                    Width = 426
                    Height = 145
                    ParentShowHint = False
                    ShowHint = True
                    OnSelChange = TabSelChange
                    ControlData = {
                      00000100712C00003015000060000000010001074631426F6F6B310101010101
                      0101010101010101010101005D060000000009080800000505006C09C907EE7E
                      040000000000EF7E140000000000000000000000FFFFFFFFFFFFFFFFF1FF3D00
                      1200000000003219030C3800000000000100580222000200000031001400C800
                      0000FF7F900100000000000005417269616C31001400C8000000FF7FBC020000
                      0000000005417269616C31001400C8000200FF7F900100000000000005417269
                      616C31001400C8000200FF7FBC0200000000000005417269616C31001400C800
                      0000FF7F900100000000000005417269616C1E041C0005001922522422232C23
                      23305F293B5C2822522422232C2323305C291E04210006001E22522422232C23
                      23305F293B5B5265645D5C2822522422232C2323305C291E04220007001F2252
                      2422232C2323302E30305F293B5C2822522422232C2323302E30305C291E0427
                      0008002422522422232C2323302E30305F293B5B5265645D5C2822522422232C
                      2323302E30305C291E0432002A002F5F285C242A20232C2323305F293B5F285C
                      242A205C28232C2323305C293B5F285C242A20222D225F293B5F28405F291E04
                      2C002900295F282A20232C2323305F293B5F282A205C28232C2323305C293B5F
                      282A20222D225F293B5F28405F291E043A002C00375F285C242A20232C232330
                      2E30305F293B5F285C242A205C28232C2323302E30305C293B5F285C242A2022
                      2D223F3F5F293B5F28405F291E0434002B00315F282A20232C2323302E30305F
                      293B5F282A205C28232C2323302E30305C293B5F282A20222D223F3F5F293B5F
                      28405F291E041F0032001C2252242022232C2323303B5B5265645D5C2D225224
                      2022232C2323301E0425003300222252242022232C2323302E30303B5B526564
                      5D5C2D2252242022232C2323302E3030ED7E05000000000000EC7E0300000000
                      E000140000000000F5FF2000C02000000000000000000000E000140001000000
                      F5FF20C4C02000000000000000000000E000140001000000F5FF20C4C0200000
                      0000000000000000E000140002000000F5FF20C4C02000000000000000000000
                      E000140002000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E00014000000000001002000C02000000000000000000000
                      E000140005003300F5FF20C8C02000000000000000000000E000140005003200
                      F5FF20C8C02000000000000000000000E000140005000C00F5FF20C8C0200000
                      0000000000000000E000140005000A00F5FF20C8C02000000000000000000000
                      E000140005000D00F5FF20C8C02000000000000000000000E000140004000000
                      F0FF1248C0200000000000000000000093020400108003FF93020400118006FF
                      93020400128004FF93020400138007FF93020400008000FF93020400148005FF
                      85000D00E30400000000065368656574310A00000009080800000510006C09C9
                      070D00020001000C00020064000F000200010011000200000010000800FCA9F1
                      D24D62503F5F00020001002A00020000002B0002000100250204000100FF008C
                      0004000100370081000200C10414000300022641150008000750616765202650
                      83000200000084000200000026000800000000000000E83F2700080000000000
                      0000E83F28000800000000000000F03F29000800000000000000F03FA1002200
                      01006400010001000100060000000000000000000000E03F000000000000E03F
                      010055000200080000020A0000000000000000000000F77E18004A003FCCFFFF
                      FF00C0C0C000FF00FF3F0000000000000000F27E100000000000000000000000
                      00000000FFFFF67E0A00150015001500FF0040061D000F000300000000000001
                      000000000000003E020A0032020000000000000000A000040064006400AB0022
                      002000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFF9900020026090A0000000000000452E30B918FCE119DE300AA004BB851
                      6C7400006C00000001000000580000000000000000000000FFFFFFFFFFFFFFFF
                      00000000000000006C520000B83D000020454D46000001006C00000002000000
                      010000000000000000000000000000002003000058020000D30000009E000000
                      0E0000001400000000000000100000001400000001}
                  end
                  inherited Panel1: TPanel
                    Width = 426
                  end
                end
                object Panel5: TPanel
                  Left = 0
                  Top = 0
                  Width = 426
                  Height = 15
                  Align = alTop
                  BevelOuter = bvNone
                  Caption = 'Tr'
                  Color = clBlue
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clYellow
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 1
                end
              end
              object TabAcum: TTabSheet
                Caption = 'Alt. L'#226'm. Desagregada'
                ImageIndex = 3
                inline paALD: TFramePlanilha
                  Left = 0
                  Top = 15
                  Width = 426
                  Height = 171
                  Align = alClient
                  Anchors = []
                  TabOrder = 0
                  inherited Tab: TF1Book
                    Width = 426
                    Height = 145
                    ParentShowHint = False
                    ShowHint = True
                    OnSelChange = TabSelChange
                    ControlData = {
                      00000100712C00003015000060000000010001074631426F6F6B310101010101
                      0101010101010101010101005D060000000009080800000505006C09C907EE7E
                      040000000000EF7E140000000000000000000000FFFFFFFFFFFFFFFFF1FF3D00
                      1200000000003219030C3800000000000100580222000200000031001400C800
                      0000FF7F900100000000000005417269616C31001400C8000000FF7FBC020000
                      0000000005417269616C31001400C8000200FF7F900100000000000005417269
                      616C31001400C8000200FF7FBC0200000000000005417269616C31001400C800
                      0000FF7F900100000000000005417269616C1E041C0005001922522422232C23
                      23305F293B5C2822522422232C2323305C291E04210006001E22522422232C23
                      23305F293B5B5265645D5C2822522422232C2323305C291E04220007001F2252
                      2422232C2323302E30305F293B5C2822522422232C2323302E30305C291E0427
                      0008002422522422232C2323302E30305F293B5B5265645D5C2822522422232C
                      2323302E30305C291E0432002A002F5F285C242A20232C2323305F293B5F285C
                      242A205C28232C2323305C293B5F285C242A20222D225F293B5F28405F291E04
                      2C002900295F282A20232C2323305F293B5F282A205C28232C2323305C293B5F
                      282A20222D225F293B5F28405F291E043A002C00375F285C242A20232C232330
                      2E30305F293B5F285C242A205C28232C2323302E30305C293B5F285C242A2022
                      2D223F3F5F293B5F28405F291E0434002B00315F282A20232C2323302E30305F
                      293B5F282A205C28232C2323302E30305C293B5F282A20222D223F3F5F293B5F
                      28405F291E041F0032001C2252242022232C2323303B5B5265645D5C2D225224
                      2022232C2323301E0425003300222252242022232C2323302E30303B5B526564
                      5D5C2D2252242022232C2323302E3030ED7E05000000000000EC7E0300000000
                      E000140000000000F5FF2000C02000000000000000000000E000140001000000
                      F5FF20C4C02000000000000000000000E000140001000000F5FF20C4C0200000
                      0000000000000000E000140002000000F5FF20C4C02000000000000000000000
                      E000140002000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E000140000000000F5FF20C4C02000000000000000000000
                      E000140000000000F5FF20C4C02000000000000000000000E000140000000000
                      F5FF20C4C02000000000000000000000E000140000000000F5FF20C4C0200000
                      0000000000000000E00014000000000001002000C02000000000000000000000
                      E000140005003300F5FF20C8C02000000000000000000000E000140005003200
                      F5FF20C8C02000000000000000000000E000140005000C00F5FF20C8C0200000
                      0000000000000000E000140005000A00F5FF20C8C02000000000000000000000
                      E000140005000D00F5FF20C8C02000000000000000000000E000140004000000
                      F0FF1248C0200000000000000000000093020400108003FF93020400118006FF
                      93020400128004FF93020400138007FF93020400008000FF93020400148005FF
                      85000D00E30400000000065368656574310A00000009080800000510006C09C9
                      070D00020001000C00020064000F000200010011000200000010000800FCA9F1
                      D24D62503F5F00020001002A00020000002B0002000100250204000100FF008C
                      0004000100370081000200C10414000300022641150008000750616765202650
                      83000200000084000200000026000800000000000000E83F2700080000000000
                      0000E83F28000800000000000000F03F29000800000000000000F03FA1002200
                      01006400010001000100060000000000000000000000E03F000000000000E03F
                      010055000200080000020A0000000000000000000000F77E18004A003FCCFFFF
                      FF00C0C0C000FF00FF3F0000000000000000F27E100000000000000000000000
                      00000000FFFFF67E0A00150015001500FF0040061D000F000300000000000001
                      000000000000003E020A0032020000000000000000A000040064006400AB0022
                      002000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFF9900020026090A0000000000000452E30B918FCE119DE300AA004BB851
                      6C7400006C00000001000000580000000000000000000000FFFFFFFFFFFFFFFF
                      00000000000000006C520000B83D000020454D46000001006C00000002000000
                      010000000000000000000000000000002003000058020000D30000009E000000
                      0E0000001400000000000000100000001400000001}
                  end
                  inherited Panel1: TPanel
                    Width = 426
                  end
                end
                object Panel6: TPanel
                  Left = 0
                  Top = 0
                  Width = 426
                  Height = 15
                  Align = alTop
                  BevelOuter = bvNone
                  Caption = 'Tr'
                  Color = clBlue
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clYellow
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 1
                end
              end
            end
            object gbDur: TGroupBox
              Left = 5
              Top = 92
              Width = 255
              Height = 73
              Hint = 
                'A vari'#225'vel "Duracao" de uma Equa'#231#227'o assumir'#225' os valores indicado' +
                's aqui.'
              Caption = ' Dura'#231#227'o (min): '
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              object Label10: TLabel
                Left = 35
                Top = 21
                Width = 28
                Height = 13
                Caption = 'Inicio:'
              end
              object Label12: TLabel
                Left = 98
                Top = 21
                Width = 19
                Height = 13
                Caption = 'Fim:'
              end
              object Label13: TLabel
                Left = 161
                Top = 21
                Width = 38
                Height = 13
                Caption = 'Increm.:'
              end
              object edC_DurIni: TdrEdit
                Left = 35
                Top = 36
                Width = 59
                Height = 21
                BeepOnError = False
                DataType = dtInteger
                TabOrder = 0
                Text = '5'
              end
              object edC_DurFim: TdrEdit
                Left = 98
                Top = 36
                Width = 59
                Height = 21
                BeepOnError = False
                DataType = dtInteger
                TabOrder = 1
                Text = '1440'
              end
              object edC_DurInc: TdrEdit
                Left = 161
                Top = 36
                Width = 59
                Height = 21
                BeepOnError = False
                DataType = dtInteger
                TabOrder = 2
                Text = '5'
              end
            end
            object mC_Tr: TMemo
              Left = 269
              Top = 18
              Width = 60
              Height = 147
              Hint = 
                'A vari'#225'vel "Tr" de uma Equa'#231#227'o assumir'#225' os valores indicados aqu' +
                'i.'
              Lines.Strings = (
                '30'
                '50'
                '80'
                '100'
                '130'
                '150')
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
            end
            object btnC_Calcular: TButton
              Left = 338
              Top = 18
              Width = 96
              Height = 25
              Hint = 
                'Avaliar'#225' uma equa'#231#227'o para todos as '#13#10'varia'#231#245'es de par'#226'metros ind' +
                'icados nesta folha.'
              Caption = 'Calcular'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = btnC_CalcularClick
            end
            object edC_Par: TLabeledEdit
              Left = 5
              Top = 62
              Width = 255
              Height = 21
              Hint = 'Par'#226'metros da equa'#231#227'o selecionada.'
              EditLabel.Width = 56
              EditLabel.Height = 13
              EditLabel.Caption = 'Par'#226'metros:'
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clBlack
              EditLabel.Font.Height = -11
              EditLabel.Font.Name = 'MS Sans Serif'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              LabelPosition = lpAbove
              LabelSpacing = 1
              ParentFont = False
              ParentShowHint = False
              ReadOnly = True
              ShowHint = True
              TabOrder = 5
              OnExit = GlobalEditExit
            end
            object btnC_Salvar: TButton
              Left = 338
              Top = 46
              Width = 96
              Height = 25
              Hint = 
                'Salva em disco os dados selecionados em uma das planilhas abaixo' +
                '.'
              Caption = 'Salvar ...'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              OnClick = btnC_SalvarClick
            end
            object Panel7: TPanel
              Left = 1
              Top = 215
              Width = 15
              Height = 174
              BevelOuter = bvNone
              Color = clBlue
              TabOrder = 7
              object Label16: TLabel
                Left = 3
                Top = 2
                Width = 8
                Height = 169
                Caption = 'D'#13#13'U'#13#13'R'#13#13'A'#13#13#199#13#13#195#13#13'O'
                Color = clBlue
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clYellow
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
            end
          end
        end
      end
    end
  end
  object Save: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Arquivos Texto (*.txt)|*.txt'
    Title = ' Salvar dados da Planilha'
    Left = 646
    Top = 4
  end
end

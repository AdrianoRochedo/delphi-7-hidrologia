?
 TDLG_CRIARPOSTO 0?  TPF0TDLG_CriarPostoDLG_CriarPostoLeftTopwWidth?HeightcCaption Criar novo postoColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameMS Sans Serif
Font.Style OldCreateOrderOnCreate
FormCreate	OnDestroyFormDestroyOnShowFormShowPixelsPerInch`
TextHeight TLabelLabel3LeftTop? Width4HeightCaption   Expressão:  TLabelLabel4LeftTopWidth? HeightCaptionIntervalos a serem calculados:  TLabelLabel1LeftTopWidth9HeightCaptionPosto Base:  ?TFrame_PeriodosValidosPVLeftTop.Width=Height? TabOrder  TEditedExpressaoLeftTop? Width0HeightHintx    Utilize a variável "x" para se referenciar 
          aos valores do posto base.
                  Ex: 0.5 * x + 0.1ParentShowHintShowHint	TabOrder  TListBoxlbExpressoesLeftTopWidth0Height0HintO    Indica quais os intervalos e expressões 
            definidos pelo usuárioTabStop
ItemHeightParentShowHintShowHint	TabOrderOnClicklbExpressoesClick  	TComboBoxcbPostoBaseLeftTopWidth? HeightHint?    Servirá de base no cálculo no novo  posto. 
 Seus valores corresponderão a variável "x"
          em uma expressão. Ex: 0.5 * x StylecsDropDownList
ItemHeightParentShowHintShowHint	TabOrder   TBitBtnbtnOkLeft?Top
WidthVHeightHintR    Utilizará as definições do usuário para 
     criar um novo posto em arquivoCaption&CriarParentShowHintShowHint	TabOrderOnClick
btnOkClick
Glyph.Data
?  ?  BM?      v   (   $            h                      ?  ?   ?? ?   ? ? ??  ??? ???   ?  ?   ?? ?   ? ? ??  ??? 333333333333333333  333333333333?33333  334C33333338?33333  33B$3333333?8?3333  34""C33333833?3333  3B""$33333?338?333  4"*""C3338?8?3?333  2"??"C3338???3?333  :*3:"$3338?38?8?33  3?33?"C333?33?3?33  3333:"$3333338?8?3  33333?"C333333?3?3  33333:"$3333338?8?  333333?"C333333?3?  333333:"C3333338??  3333333?#3333333??  3333333:3333333383  333333333333333333  	NumGlyphs  TBitBtn	btnCancelLeft?Top&WidthVHeightCancel	Caption&FecharModalResultTabOrder	
Glyph.Data
?  ?  BM?      v   (   $            h                       ?  ?   ?? ?   ? ? ??  ??? ???   ?  ?   ?? ?   ? ? ??  ??? 333333333333333333  33?33333333?333333  39?33?3333??33?33  3939?338??3???3  39??338?8??3?3  33?338?3??38?  339?333?3833?3  333?33338?33??3  3331?33333?33833  3339?333338?3?33  333??33333833?33  33933333?33?33  33????333838?8?3  33?39333?3??3?3  33933?333??38?8?  33333393338?33???  3333333333333338?3  333333333333333333  	NumGlyphs  TButtonbtnAdicionarLeft?Top? WidthVHeightHint(    Adiciona um intervalo e uma expressão Caption
&AdicionarParentShowHintShowHint	TabOrderOnClickbtnAdicionarClick  TButton
btnRemoverLeft@Top+WidthVHeightHint%    Remove uma definição de intervalo Caption&RemoverParentShowHintShowHint	TabOrderOnClickbtnRemoverClick  TButtonbtnModificarLeft@TopWidthVHeightCaption
&ModificarTabOrderOnClickbtnModificarClick  TButtonbtnAPLeft?Top? WidthVHeightHint?       Inclue todos os intervalos possíveis com uma expressão neutra,  Isto é, 
 se não houver modificações nas definições, será criado uma cópia do posto.CaptionAuto &ProcessoParentShowHintShowHint	TabOrderOnClick
btnAPClick  TSaveDialogSave
DefaultExtDBFilterArquivo Paradox (*.DB)|*.DBTitleSalvar posto comoLeftHTopK   
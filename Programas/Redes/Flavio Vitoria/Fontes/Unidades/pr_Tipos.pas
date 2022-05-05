unit pr_Tipos;

interface
uses wsVec,
     IniFiles,
     graphics;

type
  TV                          = TwsDFVec;

  pRecObjeto                  = ^TRecPonteiroParaUmObjeto;
  TRecPonteiroParaUmObjeto    = record
                                  Obj: TObject;
                                end;

  TRecCotaVolume              = record
                                  Cota : Real;
                                  Vol  : Real;
                                end;

  TRecAreaVolume              = record
                                  Area : Real;
                                  Vol  : Real;
                                end;

  pRecClassesDemanda          = ^TRecClassesDemanda;
  TRecClassesDemanda          = record
                                  Demanda : TObject;
                                  Bitmap  : graphics.TBitmap;
                                end;

  TEnumTipoDemanda            = (tdDifusa, tdLocalizada);
  TEnumPriorDemanda           = (pdPrimaria, pdSecundaria, pdTerciaria);
  TEnumIntSim                 = (isQuinquendial, isSemanal, isDecendial, isQuinzenal, isMensal);
  TEnumTipoDeGrafico          = (tgBarras, tgLinhas);
  TEnumTipoDialogo            = (tdClasseDemanda, tdDemanda);
  TEnumTipoSimulacao          = (tsDOS, tsWIN);

  TEnumEquacoes_TipoGerador   = (tgAutomatico, tgManual);

  // --------------------------------------------------------------

  TRecVU  = Record
              AnoIni : Word;
              AnoFim : Word;
              Mes    : Array[1..12] of Real;
            end;

  TaRecVU = Array of TRecVU;

  // --------------------------------------------------------------

  TaRecFI = TaRecVU;

  // --------------------------------------------------------------

  TRecUD  = Record
              AnoIni  : Word;
              AnoFim  : Word;
              Unidade : Real;
            end;

  TaRecUD = Array of TRecUD;

  // --------------------------------------------------------------

  TRec_prData       = Record
                        Mes: byte;
                        Ano: Integer;
                      end;

  TRecIntervalo     = Record
                        AnoIni: Word;
                        AnoFim: Word;
                        dtAcum: Cardinal;
                      end;

  TaRecIntervalos   = array of TRecIntervalo;

  TSetByte          = Set of Byte;

  pRecMatContrib    = ^TRecMatContrib;
  TRecMatContrib    = Record
                        Lin, Col: integer;
                        Val     : real;
                      End;

  TMapPoint         = record
                        X, Y: Double;
                      end;

  // Cores ..........................................

  const clPink = $00CDD2FE;

  // Qualidade da Agua ..............................

  type TQA_Enum_Codigos = (qac_Excelente = 8,
                           qac_Otima     = 7,
                           qac_MuitoBoa  = 6,
                           qac_Boa       = 5,
                           qac_Regular   = 4,
                           qac_Ruim      = 3,
                           qac_MuitoRuim = 2,
                           qac_Pessima   = 1);

  // Encapsula os codigos para gerenciamento da qualidade da agua
  type TQACodigos = class
  public
    class function Nome(Cod: integer): string;
    class function Cor(Cod: integer): TColor;
    class function NumCodigos(): integer;
  end;

implementation

{ TQACodigos }

class function TQACodigos.Cor(Cod: integer): TColor;
begin
  case TQA_Enum_Codigos(Cod) of
    qac_Excelente : result := clWhite;
    qac_Otima     : result := clAqua;
    qac_MuitoBoa  : result := clSkyBlue;
    qac_Boa       : result := clBlue;
    qac_Regular   : result := clPink;
    qac_Ruim      : result := clRed;
    qac_MuitoRuim : result := clMaroon;
    qac_Pessima   : result := clBlack;
  end;
end;

class function TQACodigos.Nome(Cod: integer): string;
begin
  case TQA_Enum_Codigos(Cod) of
    qac_Excelente : result := 'Excelente';
    qac_Otima     : result := 'Ótima';
    qac_MuitoBoa  : result := 'Muito Boa';
    qac_Boa       : result := 'Boa';
    qac_Regular   : result := 'Regular';
    qac_Ruim      : result := 'Ruim';
    qac_MuitoRuim : result := 'Muito Ruim';
    qac_Pessima   : result := 'Péssima';
  end;
end;

class function TQACodigos.NumCodigos(): integer;
begin
  result := 8;
end;

end.

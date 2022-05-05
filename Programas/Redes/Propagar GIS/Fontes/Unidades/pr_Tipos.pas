unit pr_Tipos;

interface
uses wsVec,
     IniFiles,
     graphics;

type
  TV                          = TwsSFVec;
  TIF                         = TMemIniFile;

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

  TRecVU                      = Record
                                  AnoIni : Word;
                                  AnoFim : Word;
                                  Mes    : Array[1..12] of Real;
                                end;

  TaRecVU                     = Array of TRecVU;

  TaRecFI                     = TaRecVU;

  TRecUD                      = Record
                                  AnoIni  : Word;
                                  AnoFim  : Word;
                                  Unidade : Real;
                                end;

  TaRecUD                     = Array of TRecUD;

  TRec_prData                 = Record
                                  Mes: byte;
                                  Ano: Integer;
                                end;

  TRecIntervalo               = Record
                                  AnoIni: Word;
                                  AnoFim: Word;
                                  dtAcum: Cardinal;
                                end;

  TaRecIntervalos             = array of TRecIntervalo;

  TSetByte                    = Set of Byte;

  pRecMatContrib              = ^TRecMatContrib;
  TRecMatContrib              = Record
                                  Lin, Col: Integer;
                                  Val     : Real;
                                End;

implementation

end.

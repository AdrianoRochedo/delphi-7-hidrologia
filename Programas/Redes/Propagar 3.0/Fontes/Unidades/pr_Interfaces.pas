unit pr_Interfaces;

interface
uses Classes, Forms, IniFiles, ExtCtrls, ActnList, SysUtilsEx, MSXML4;

type
  IPropagar = interface(SysUtilsEx.IInterface)
    procedure ipr_setExePath(const ExePath: string);
    procedure ipr_setObjectName(const Name: string);
    procedure ipr_setProjectPath(const ProjectPath: string);
  end;

  IHidroComponente = interface(IPropagar)
    ['{002C0F24-F9D2-4602-B9A2-ECD823A0830B}']
    function  ihc_TemErros(): boolean;
    procedure ihc_ObterErros(var Erros: TStrings);
    procedure ihc_ObterAcoesDeMenu(Acoes: TActionList);
    procedure ihc_Simular();
    procedure ihc_toXML(Buffer: TStrings; Ident: integer);
    procedure ihc_fromXML(no: IXMLDOMNode);
    function  ihc_getXMLVersion(): integer;
  end;

  ICenarioDemanda = interface(IHidroComponente)
    ['{846F943C-71CC-4A25-A405-28221DB9A27C}']

    // Esta funcao devera retornar um objeto do tipo TwsDataSet
    // O objeto retornado nao devera ser destruido.
    function icd_ObterValoresUnitarios(): TObject;

    // Retornara os valores das propriedades
    function icd_ObterValorFloat(const Propriedade: string): real;
    function icd_ObterValorString(const Propriedade: string): string;
    
    // procedure icd_AtribuirValorComoReal(const Name: string; const Valor: Real);
  end;

implementation

end.

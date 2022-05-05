unit pro_fo_Series_DescEstats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  pro_Application,
  wsVec,
  wsMatrix,
  wsBXML_Output,
  wsConstTypes;

type
  TfoSeries_DescEstats = class(TForm)
    Panel3: TPanel;
    CBO_Minimo: TCheckBox;
    CBO_Perc1: TCheckBox;
    CBO_Perc5: TCheckBox;
    CBO_Perc10: TCheckBox;
    CBO_Quartil1: TCheckBox;
    CBO_Mediana: TCheckBox;
    CBO_Quartil3: TCheckBox;
    CBO_Maximo: TCheckBox;
    CBO_Amplitude: TCheckBox;
    CBO_AmpInter: TCheckBox;
    CBO_Perc90: TCheckBox;
    CBO_Perc95: TCheckBox;
    CBO_Perc99: TCheckBox;
    Panel2: TPanel;
    CB_Media: TCheckBox;
    CB_Variancia: TCheckBox;
    CB_Desvio: TCheckBox;
    CB_Total: TCheckBox;
    CB_Minimo: TCheckBox;
    CB_Maximo: TCheckBox;
    CB_NumVal: TCheckBox;
    CB_NumValVal: TCheckBox;
    CB_Erro: TCheckBox;
    CB_Amplitude: TCheckBox;
    CB_Curtose: TCheckBox;
    CB_SomaNCor: TCheckBox;
    CB_SomCor: TCheckBox;
    CB_SomPesos: TCheckBox;
    CB_CoefVar: TCheckBox;
    CB_Assimetria: TCheckBox;
    RB_Ordem: TRadioButton;
    RB_Posicao: TRadioButton;
    btnCalcular: TButton;
    btnFechar: TButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnCalcularClick(Sender: TObject);
  private
    FDS: TwsDataset;
    FVars: TStrings;
  public
    constructor Create(ds: TwsDataset; Vars: TStrings);
  end;

implementation

{$R *.dfm}

{ TfoSeries_DescEstats }

constructor TfoSeries_DescEstats.Create(ds: TwsDataset; Vars: TStrings);
begin
  inherited Create(nil);
  FDS := ds;
  FVars := Vars;
end;

procedure TfoSeries_DescEstats.btnFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TfoSeries_DescEstats.btnCalcularClick(Sender: TObject);
Var
  i,j    : Byte;           {Variavel auxiliar que guarda o numero de elementos assinalados para serem calculados em um dos panels}
  Stat   : TwsLIVec;       {Vetor que será passado para a mfunc com a codificaao dos elementos que serão calculados}
  Col    : TwsLIVec;       {Vetor que será passado com o index das coluna que deverão entrar no calculo}
  Result : TwsGeneral;     {Receberá os resultados dos calculos}
  Output : TwsBXML_Output; {Relatorio}
begin
  Output := TwsBXML_Output.Create();

  // Informacoes gerais sobre a analise ....

  OutPut.BeginText();
    OutPut.WriteTitle(2, 'Estatísticas Descritivas');
    for i := 1 to FDS.nCols do
      OutPut.WritePropValue(FDS.Struct.Col[i].Name + ':', FDS.Struct.Col[i].Lab);
  OutPut.EndText();

  // Indice das variaveis a serem utilizadas
  Col := TwsLIVec.Create(FDS.NCols);
  for i := 1 to FDS.NCols do
    Col[i] := FDS.Struct.IndexOf(FVars[i-1]);

  // Estatisticas a serem calculadas
  Stat := TwsLIVec.Create(0);
  If RB_Posicao.Checked then
    {Cria um vetor com a codificacao das estatísticas que serão obtidas}
    For i := 0 to ComponentCount-1 do
      begin
      if (Components[i] is TCheckBox) and (TCheckBox(Components[i]).Checked) and
         (System.Copy(Components[i].Name, 1, 3) = 'CB_') then
          Stat.Add(TCheckBox(Components[i]).Tag);
      end
  else
    For i := 0 to ComponentCount-1 do
      if (Components[i] is TCheckBox) and (TCheckBox(Components[i]).Checked) and
         (System.Copy(Components[i].Name,1, 4) = 'CBO_') then
          Stat.Add(TCheckBox(Components[i]).Tag);

    if RB_Posicao.Checked then
       begin
       Result := TwsGeneral(FDS.DescStat(Col, Stat));
       if FDS.MLab <> '' then
         Result.MLab :=  Result.MLab + ' - '+ FDS.MLab;
       end
    else
       begin
       Result := TwsGeneral(FDS.MatOrderStat(Col, Stat));
       if FDS.MLab <> '' then
          Result.MLab :=  Result.MLab +  ' - ' + FDS.MLab;
       end;

    OutPut.Add(Result);
    Result.Free();

    Applic.ShowReport(Output.SaveToTempFile(), ' Estatísticas Descritivas');
end; {btnAplicarClick}

end.

unit pro_fo_Series_FrequencyAnalisys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtilsEx,
  //pro_Classes,
  pro_Application,
  wsVec,
  wsMatrix,
  wsBXML_Output,
  wsConstTypes,
  wsFrequencias;

type
  TfoSeries_FrequencyAnalisys = class(TForm)
    btnCalcular: TButton;
    btnFechar: TButton;
    GroupBox1: TGroupBox;
    labImprime: TLabel;
    labEsperado: TLabel;
    labResiduos: TLabel;
    labResPadr: TLabel;
    labTabFreq: TLabel;
    labEstAss: TLabel;
    labMatFreq: TLabel;
    labQuiQuad: TLabel;
    labDSFrame: TLabel;
    labFreqByValue: TLabel;
    chbIEsperado: TCheckBox;
    chbIResiduos: TCheckBox;
    chbIResPadr: TCheckBox;
    chbITabFreq: TCheckBox;
    chbIQuiQuad: TCheckBox;
    chbIEstAss: TCheckBox;
    chbIMatFreq: TCheckBox;
    chbIDSFrame: TCheckBox;
    chbIFreqByValue: TCheckBox;
    GroupBox2: TGroupBox;
    chbHistograma: TCheckBox;
    procedure chbIQuiQuadClick(Sender: TObject);
    procedure AtualizarOpcoes(Sender: TObject);
    procedure btnCalcularClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FOpcoes: TBits;
    FDS: TwsDataset;
    FVars: TStrings;
  public
    constructor Create(ds: TwsDataset; Vars: TStrings);
    destructor Destroy(); override;
  end;

implementation

{$R *.dfm}

procedure TfoSeries_FrequencyAnalisys.chbIQuiQuadClick(Sender: TObject);
var b: boolean;
begin
  b := (chbIQuiQuad.checked);

  labEsperado.enabled  := b;
  chbIEsperado.enabled := b;
  labResiduos.enabled  := b;
  chbIResiduos.enabled := b;
  labResPadr.enabled   := b;
  chbIResPadr.enabled  := b;

  AtualizarOpcoes(sender);
end;

procedure TfoSeries_FrequencyAnalisys.AtualizarOpcoes(Sender: TObject);
begin
  FOpcoes[cIDSFrame      ] := chbIDSFrame.Checked;
  FOpcoes[cITabFreq      ] := chbITabFreq.Checked;
  FOpcoes[cIMatFreq      ] := chbIMatFreq.Checked;
  FOpcoes[cIQuiQuad      ] := chbIQuiQuad.Checked;
  FOpcoes[cIEsperado     ] := chbIEsperado.Checked;
  FOpcoes[cIResiduos     ] := chbIResiduos.Checked;
  FOpcoes[cIResPadr      ] := chbIResPadr.Checked;
  FOpcoes[cIEstAss       ] := chbIEstAss.Checked;
  FOpcoes[cGeraHistograma] := chbHistograma.Checked;
  FOpcoes[cIFreqByValue  ] := chbIFreqByValue.Checked;
end;

constructor TfoSeries_FrequencyAnalisys.Create(ds: TwsDataset; Vars: TStrings);
begin
  inherited Create(nil);
  FDS := ds;
  FVars := Vars;
  FOpcoes := TBits.Create;
  FOpcoes.Size := 32;
  AtualizarOpcoes(nil);
end;

destructor TfoSeries_FrequencyAnalisys.Destroy();
begin
  FOpcoes.Free();
  inherited;
end;

procedure TfoSeries_FrequencyAnalisys.btnCalcularClick(Sender: TObject);
Var Freq: TwsFreq;
    sts_VarsGrupo: TStrings;
    Output: TwsBXML_Output;
    i: integer;
begin
  freq := nil;
  sts_VarsGrupo := TStringList.create;
  try
    Output := TwsBXML_Output.Create();
    OutPut.BeginText();
      for i := 1 to FDS.nCols do
        OutPut.WritePropValue(FDS.Struct.Col[i].Name + ':', FDS.Struct.Col[i].Lab);
    OutPut.EndText();

    freq := TwsFreq.Create(FDS,
                           sts_VarsGrupo,
                           '',
                           '',
                           StringsToString(FVars, ' '),
                           FOpcoes,
                           Output,
                           nil);

    Applic.ShowReport(Output.SaveToTempFile(), 'Análise de Frequências');
  finally
    freq.Free();
    sts_VarsGrupo.Free();
  end;
end;

procedure TfoSeries_FrequencyAnalisys.btnFecharClick(Sender: TObject);
begin
  Close();
end;

end.

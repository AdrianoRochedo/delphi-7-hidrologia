unit pr_Dialogo_Grafico_PCsRes_XTudo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_Grafico_PCs_XTudo, StdCtrls, Buttons, ExtCtrls,
  esquemas_OpcoesGraf;

type
  TprDialogo_Grafico_PCsRes_XTudo = class(TprDialogo_Grafico_PCs_XTudo)
    cbVol: TCheckBox;
    cbFalhaVolume: TCheckBox;
  private
    { Private declarations }
  public
    function  ObtemEsquema: Tesq_OpcoesGraf; override;
    procedure AplicarEsquema(Esquema: Tesq_OpcoesGraf); override;

    procedure CriarGrafico(k: Integer); override;
  end;

implementation
uses pr_Classes, teEngine;

{$R *.DFM}

procedure TprDialogo_Grafico_PCsRes_XTudo.CriarGrafico(k: Integer);
var b: TChartSeries;
    i: Integer;
begin
  inherited;
  if cbLinhas.Checked then
     begin
     if cbVol.Checked then
        begin
        b := g1.Series.AddLineSerie('Volume', $00C7CBEF, TprPCPR(PC).Volume, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhaVolume.Checked then
           for i := Ini to Fim do
              if TprPCPR(PC).Volume[i] < 0.6 * TprPCPR(PC).VolumeMaximo then
                 b.ValueColor[i-Ini] := clRED;
        end;
     end;

  if cbBarras.Checked then
     begin
     if cbVol.Checked then
        begin
        b := g2.Series.AddBarSerie('Volume', $00C7CBEF, 0, 1, TprPCPR(PC).Volume, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        end;
     end;

  if cbPontos.Checked then
     begin
     if cbVol.Checked then
        begin
        b := g1.Series.AddPointSerie('Volume', $00C7CBEF, TprPCPR(PC).Volume, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhaVolume.Checked then
           for i := Ini to Fim do
              if TprPCPR(PC).Volume[i] < 0.6 * TprPCPR(PC).VolumeMaximo then
                 b.ValueColor[i-Ini] := clRED;
        end;
     end;
end;

function TprDialogo_Grafico_PCsRes_XTudo.ObtemEsquema: Tesq_OpcoesGraf;
begin
  Result := Inherited ObtemEsquema;
  Result[0] := cbVol.Checked;
  Result[1] := cbEG.Checked;
end;

procedure TprDialogo_Grafico_PCsRes_XTudo.AplicarEsquema(Esquema: Tesq_OpcoesGraf);
begin
  inherited;
  cbVol.Checked := Esquema[0];
  cbEG.Checked  := Esquema[1];
end;

end.

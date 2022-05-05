program CurvasIDF;

uses
  Forms,
  SysUtils,
  JanelaPrincipal in 'JanelaPrincipal.pas' {foJP},
  drGraficosBase in '..\..\..\..\Comum\Graficos\drGraficosBase.pas' {grGraficoBase},
  drGraficos in '..\..\..\..\Comum\Graficos\drGraficos.pas' {grGrafico},
  Frame_Planilha in '..\..\..\..\Comum\Frames\Frame_Planilha.pas' {FramePlanilha: TFrame};

{$R *.res}

begin
  //SysUtils.DecimalSeparator := '.';

  Application.HintHidePause := 30000;
  Application.Initialize;
  Application.CreateForm(TfoJP, foJP);
  Application.Run;
end.

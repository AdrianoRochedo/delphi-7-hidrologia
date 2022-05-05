unit prDialogo_Planilha_DemandasDeUmaClasse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_PlanilhaBase, Menus, AxCtrls, OleCtrls, vcf1, StdCtrls,
  ExtCtrls, pr_Classes, pr_Form_AreaDeProjeto_Base, Mask, drEdit;

type
  TprDialogoPlanilha_DemandasDeUmaClasse = class(TprDialogo_PlanilhaBase)
    Panel1: TPanel;
    cbPeriodos: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    edEscala: TdrEdit;
    procedure FormShow(Sender: TObject);
    procedure cbPeriodosChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabSelChange(Sender: TObject);
    procedure TabEndEdit(Sender: TObject; var EditString: WideString;
      var Cancel: Smallint);
    procedure FormCreate(Sender: TObject);
    procedure edEscalaExit(Sender: TObject);
    procedure edEscalaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FBlocos     : array of record Ini, Fim: Integer end;
    FPriVez     : Boolean;
    FModificado : Boolean;
    FClasse     : TprClassedemanda;
    FPeriodo    : Integer;
    FAP         : TfoAreaDeProjeto_Base;

    procedure SetPeriodo(const Value: Integer);
    procedure CalcularDemanda(DM: TprDemanda; Linha: Integer);
    procedure CalculaSomatorios;
    procedure RecuperaValores;
  public
    property Classe        : TprClassedemanda         read FClasse  write FClasse;
    property Periodo       : Integer                  read FPeriodo write SetPeriodo;
    property AreaDeProjeto : TfoAreaDeProjeto_Base    read FAP write FAP;
  end;

implementation
uses pr_Funcoes, SysUtilsEx;

{$R *.DFM}

{ TprDialogo_Planilha_DemandasDeUmClasse }

procedure TprDialogoPlanilha_DemandasDeUmaClasse.SetPeriodo(const Value: Integer);
var i, j, k, ii : Integer;    // contadores
    L, C        : Integer;    // Linha e columa atual da tabela
    SL          : TStrings;   // auxiliar
    DM          : TprDemanda; // Demanda atual
begin
  RecuperaValores;

  FPeriodo := Value;
  SL := TStringList.Create;
  ObterDemandasPelaClasse(FClasse.Nome, SL, FAP.Projeto);

  if FPriVez then
     begin
     SetLength(FBlocos, FAP.Projeto.PCs.PCs);
     Tab.SetActiveCell(1, 7);
     Tab.SetFont('ARIAL', 8, True, False, False, False, clRed, False, False);
     Tab.SetAlignment(F1HAlignLeft, False, F1VAlignCenter, 0);
     Tab.TextRC [1, 7] := Format('  Demandas unitárias em %s; Demandas por projeto em %s', [
                             FClasse.NomeUnidadeConsumoDagua,
                             FClasse.NomeUnidadeDeDemanda
                             ]);
     end;

  for ii := 1 to FAP.Projeto.TotalAnual_IntSim do
    begin
    if FPriVez then
       begin
       Tab.SetActiveCell(2, 6 + ii);
       Tab.SetAlignment(F1HAlignCenter, False, F1VAlignCenter, 0);
       Tab.SetFont('ARIAL', 8, True, False, False, False, Cardinal(clWindowText), False, False);
       Tab.SetActiveCell(3, 6 + ii); Tab.SetPattern(1, clYellow, clBlack);
       Tab.SetActiveCell(4, 6 + ii); Tab.SetPattern(1, clYellow, clBlack);
       end;

    Tab.TextRC[2, 6 + ii] := IntToStr(ii);

    //Tab.NumberRC [3, 6 + ii] := FClasse.TabUnidadesDeDemanda[Periodo].Unidade;
    //FAP.Projeto.DeltaT := ii;
    L := FAP.Projeto.IntervaloParaData(ii).Mes;
    Tab.NumberRC [3, 6 + ii] := FClasse.TabValoresUnitarios[Periodo].Mes[L];
    end;

  L := 5;
  for i := 0 to FAP.Projeto.PCs.PCs - 1 do
    begin
    FBlocos[i].Ini := L;

    if FPriVez then
       begin
       Tab.SetActiveCell(L, 1);
       Tab.SetAlignment(F1HAlignCenter, False, F1VAlignCenter, 0);
       end;

    Tab.TextRC[L, 1] := FAP.Projeto.PCs[i].Nome;

    k := 0;
    // pega todas as demandas pertencentes a uma classe e a um PC
    for j := 0 to FAP.Projeto.PCs[i].Demandas - 1 do
      if SL.IndexOfObject(FAP.Projeto.PCs[i].Demanda[j]) > -1 then
         begin
         DM := FAP.Projeto.PCs[i].Demanda[j];

         if FPriVez then
            begin
            Tab.SetActiveCell(L + k, 2);
            Tab.SetAlignment(F1HAlignCenter, False, F1VAlignCenter, 0);
            end;

         Tab.TextRC [L + k, 2] := DM.Nome;

         DM.ValorTemp := DM.TabFatoresImplantacao[Periodo].Mes[1];

         Tab.NumberRC [L + k, 3] := DM.TabUnidadesDeDemanda[Periodo].Unidade;
         Tab.NumberRC [L + k, 5] := DM.TabFatoresImplantacao[Periodo].Mes[1];
         Tab.NumberRC [L + k, 4] := Tab.NumberRC [L + k, 3] * Tab.NumberRC [L + k, 5];

         CalcularDemanda(DM, L + k);
         inc(k);
         end;

    FBlocos[i].Fim := L + k - 1;
    inc(L, k + 1);
    //inc(L);
    end;

  // Coloca a cor da fonte em vermelho de todas as células que indicam somatório
  if FPriVez then
     for i := 0 to High(FBlocos) do
       for ii := 1 to FAP.Projeto.Projeto.TotalAnual_IntSim + 4 do
         begin
         C := 2 + ii;
         if (C = 5) or (C = 6) or (FBlocos[i].Fim <= FBlocos[i].Ini) then Continue;
         Tab.SetActiveCell(FBlocos[i].Fim + 1, C);
         Tab.SetFont('ARIAL', 8, False, False, False, False, clRed, False, False);
         end;

  SL.Free;
  FPriVez := False;
  CalculaSomatorios;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.FormShow(Sender: TObject);
var CD : TprClasseDemanda;
    i  : Integer;
begin
  inherited;

  Caption := ' Demandas da Classe ' + FClasse.Nome;

  Tab.TextRC[1,1] := 'PCs';
  Tab.TextRC[1,2] := 'Demandas';
  Tab.TextRC[1,3] := 'Un. Dem.';
  Tab.TextRC[1,4] := 'Un. Dem.';
  Tab.TextRC[1,5] := 'Fator';

  Tab.TextRC[2,3] := 'Máxima';
  Tab.TextRC[2,4] := 'Projetada';
  Tab.TextRC[2,5] := 'Implant.';
  Tab.TextRC[2,6] := 'Intervalos';

  Tab.TextRC[3,6] := 'Val.Un.Classe';
  Tab.TextRC[4,6] := 'Val.Un.Demanda';

  edEscala.AsInteger := 100;

  cbPeriodos.Clear;
  CD := TprClasseDemanda(FAP.Projeto.ObjetoPeloNome(FClasse.Nome));
  for i := 0 to High(CD.TabValoresUnitarios) do
    begin
    cbPeriodos.Items.Add(Format('%d - %d',
      [CD.TabValoresUnitarios[i].AnoIni, CD.TabValoresUnitarios[i].AnoFim]));
    end;

  if cbPeriodos.Items.Count > 0 then
     begin
     cbPeriodos.ItemIndex := 0;
     Periodo := 0;
     end;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.cbPeriodosChange(Sender: TObject);
begin
  inherited;
  Periodo := cbPeriodos.ItemIndex;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  RecuperaValores;
  Action := caFree;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.TabSelChange(Sender: TObject);
var R, C, ii, Mes : Integer;
    DM            : TprDemanda;
begin
  inherited;
  Tab.GetActiveCell(R, C);
  DM := TprDemanda(TprProjeto(FAP).ObjetoPeloNome(Tab.TextRC[R, 2]));
  if DM <> nil then
     for ii := 1 to FAP.Projeto.TotalAnual_IntSim do
       begin
       //FAP.Projeto.DeltaT := ii;
       Mes := FAP.Projeto.IntervaloParaData(ii).Mes;
       Tab.NumberRC [4, 6 + ii] := DM.TabValoresUnitarios[Periodo].Mes[Mes];
       end
  else
     for ii := 1 to FAP.Projeto.TotalAnual_IntSim do
       Tab.TextRC [4, 6 + ii] := '';
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.TabEndEdit(
                  Sender: TObject; var EditString: WideString; var Cancel: Smallint);

var R, C, ii : Integer;
    DM       : TprDemanda;
    x        : Real;
begin
  inherited;
  Tab.GetActiveCell(R, C);
  DM := TprDemanda(TprProjeto(FAP).ObjetoPeloNome(Tab.TextRC[R, 2]));

  if DM <> nil then
     begin
     try
       x := StrToFloat(EditString);
     except
       EditString := '0';
       x := 0;
     end;

     if C = 5 then
        // Área projetada
        begin
        Tab.NumberRC [R, 4] := Tab.NumberRC [R, 3] * x;
        Tab.NumberRC [R, 5] := Tab.NumberRC [R, 4] / Tab.NumberRC [R, 3];

        FModificado := FModificado or
                       (DM.TabFatoresImplantacao[Periodo].Mes[1] <> Tab.NumberRC [R, 5]);

        DM.TabFatoresImplantacao[Periodo].Mes[1] := Tab.NumberRC [R, 5];
        CalcularDemanda(DM, R);
        CalculaSomatorios;
        end else

     if C = 4 then
        begin try
          // Fator de Implantação
          Tab.NumberRC [R, 5] := x / Tab.NumberRC [R, 3];

          FModificado := FModificado or
                         (DM.TabFatoresImplantacao[Periodo].Mes[1] <> Tab.NumberRC [R, 5]);

          DM.TabFatoresImplantacao[Periodo].Mes[1] := Tab.NumberRC [R, 5];
        except
          Tab.NumberRC [R, 5] := 0;
          DM.TabFatoresImplantacao[Periodo].Mes[1] := 0;
          end;

        CalcularDemanda(DM, R);
        CalculaSomatorios;
        end;
     end; // if DM ...
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.FormCreate(Sender: TObject);
begin
  inherited;
  FPriVez := True;
  Tab.FixedCols := 3;
  Tab.FixedRows := 4;
  Tab.ShowEditBar := False;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.CalcularDemanda(DM: TprDemanda; Linha: Integer);
var ii, Mes: Integer;
begin
  for ii := 1 to FAP.Projeto.TotalAnual_IntSim do
    begin
    //FAP.Projeto.DeltaT := ii;
    Mes := FAP.Projeto.IntervaloParaData(ii).Mes;
    Tab.NumberRC[Linha, 6 + ii] := DM.TabFatoresImplantacao[Periodo].Mes[1] *
                                   DM.TabUnidadesDeDemanda[Periodo].Unidade *
                                   DM.TabValoresUnitarios[Periodo].Mes[Mes] *
                                   DM.FatorDeConversao;
    end;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.CalculaSomatorios;
var i, ii, k, C: Integer;
    x          : Real;
begin
  // Somatórios Parciais
  for i := 0 to High(FBlocos) do
    for ii := 1 to FAP.Projeto.TotalAnual_IntSim + 4 do
      begin
      C := 2 + ii;
      if (C = 5) or (C = 6) or (FBlocos[i].Fim <= FBlocos[i].Ini) then Continue;
      x := 0;
      for k := FBlocos[i].Ini to FBlocos[i].Fim do x := x + Tab.NumberRC[k, C];
      Tab.NumberRC[FBlocos[i].Fim + 1, C] := x;
      end;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.edEscalaExit(Sender: TObject);
begin
  inherited;
  Try
    Tab.ViewScale := edEscala.AsInteger;
  except
    MessageDLG('Valor Inválido', mtError, [mbOK], 0);
  end;
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.edEscalaKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then edEscalaExit(Sender);
end;

procedure TprDialogoPlanilha_DemandasDeUmaClasse.RecuperaValores();
var i, j: Integer;
    SL  : TStrings;   // auxiliar
    DM  : TprDemanda; // Demanda atual
begin
  if FModificado and
     (MessageDLG('Fatores de Implantações modificados. Aceitar ?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNO) then
     begin
     SL := TStringList.Create;
     ObterDemandasPelaClasse(FClasse.Nome, SL, FAP);
     for i := 0 to FAP.Projeto.PCs.PCs - 1 do
        for j := 0 to FAP.Projeto.PCs[i].Demandas - 1 do
          if SL.IndexOfObject(FAP.Projeto.PCs[i].Demanda[j]) > -1 then
             begin
             DM := FAP.Projeto.PCs[i].Demanda[j];
             DM.TabFatoresImplantacao[FPeriodo].Mes[1] := DM.ValorTemp;
             end;
     SL.Free;
     end;
     
  FModificado := False;
end;

end.

unit pr_Dialogo_Grafico_PCs_XTudo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, drGraficos,
  pr_Classes,
  esquemas_OpcoesGraf;

type
  TprDialogo_Grafico_PCs_XTudo = class(TForm)
    L1: TLabel;
    cbVSB: TCheckBox;
    cbDef: TCheckBox;
    Bevel1: TBevel;
    Label1: TLabel;
    cbDAP: TCheckBox;
    cbDAS: TCheckBox;
    cbDAT: TCheckBox;
    Label2: TLabel;
    cbDPP: TCheckBox;
    cbDPS: TCheckBox;
    cbDPT: TCheckBox;
    Label3: TLabel;
    cbDRP: TCheckBox;
    cbDRS: TCheckBox;
    cbDRT: TCheckBox;
    Bevel2: TBevel;
    btnOk: TBitBtn;
    btnFechar: TBitBtn;
    cbVM: TCheckBox;
    Label4: TLabel;
    Bevel3: TBevel;
    cbLinhas: TCheckBox;
    cbBarras: TCheckBox;
    Label5: TLabel;
    Label7: TLabel;
    cbEsquemas: TComboBox;
    Label8: TLabel;
    btnSalvarEsquema: TButton;
    cbDATot: TCheckBox;
    cbDPTot: TCheckBox;
    cbDRTot: TCheckBox;
    cbVT: TCheckBox;
    cbFalhas: TCheckBox;
    cbPontos: TCheckBox;
    cbEG: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnSalvarEsquemaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEsquemasChange(Sender: TObject);
    procedure cbEsquemasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPC: TprPCP;
  public
    g1, g2, g3: TgrGrafico;
    p: TprProjeto;
    Ini, Fim: Integer;

    procedure CriarGrafico(k: Integer); virtual;

    function  ObtemEsquema: Tesq_OpcoesGraf; virtual;
    procedure AplicarEsquema(Esquema: Tesq_OpcoesGraf); virtual;

    property PC: TprPCP read FPC write FPC;
  end;

implementation
uses pr_Const,
     pr_Tipos,
     pr_Vars,
     teEngine,
     WinUtils;

{$R *.DFM}

procedure TprDialogo_Grafico_PCs_XTudo.btnOkClick(Sender: TObject);
var k: Integer;
begin
  p := PC.Projeto;
  for k := 0 to p.Intervalos.NumInts - 1 do
    begin
    if not p.Intervalos.Habilitado[k] then Continue;
    Ini := p.Intervalos.IntIni[k];
    Fim := p.Intervalos.IntFim[k];
    StartWait;
    CriarGrafico(k);
    StopWait;

    if g1 <> nil then
       begin
       g1.Left := g1.Left + k*20;
       g1.Top  := g1.Top  + k*20;
       g1.Show;
       end;

    if g2 <> nil then
       begin
       g2.Left := g2.Left + k*20;
       g2.Top  := g2.Top  + k*20;
       g2.Show;
       end;

    if g3 <> nil then
       begin
       g3.Left := g3.Left + k*20;
       g3.Top  := g3.Top  + k*20;
       g3.Show;
       end;
    end; // for k

  close;
end;

procedure TprDialogo_Grafico_PCs_XTudo.CriarGrafico(k: Integer);
var V        : TV;
    i        : Integer;
    b        : TChartSeries;
    Falhas   : TListaDeFalhas;
    ComFalhas: Boolean;

    procedure DestacaFalhas(Prior: Byte);
    var i, j, ii, k : Integer;
        F           : TprFalha;
    begin
      Case Prior of
        1: k := Falhas.FalhasPrimarias;
        2: k := Falhas.FalhasSecundarias;
        3: k := Falhas.FalhasTerciarias;
        end;

      for i := 0 to k-1 do
        begin

        Case Prior of
          1: F := Falhas.FalhaPrimaria[i];
          2: F := Falhas.FalhaSecundaria[i];
          3: F := Falhas.FalhaTerciaria[i];
          end;

        for j := 0 to F.Intervalos.Count-1 do
           begin
           ii := F.Intervalos[j];
           if (ii >= Ini) and (ii <= Fim) then
              if F.IntervalosCriticos[j] then
                 b.ValueColor[ii-Ini] := clRED
              else
                 b.ValueColor[ii-Ini] := clFUCHSIA; // rosa
           end; // for j
        end; //for i
    end; // DestacaFalhas

begin
  g1 := nil;

  ComFalhas := (cbFalhas.Checked and (cbDAP.Checked or cbDAS.Checked or cbDAT.Checked));
  if ComFalhas then Falhas := PC.ObtemFalhas;

  if cbLinhas.Checked then
     begin
     g1 := PC.CriarGrafico_Default('Grafico X-Tudo do ' + PC.Nome, k);

     if cbVT.Checked Then
        begin
        V := TV.Create(PC.AfluenciaSB.Len);

        if (Fim <= PC.AfluenciaSB.Len) and (Fim <= PC.VazMontante.Len) then
           begin
           for i := Ini to Fim do V[i] := PC.AfluenciaSB[i] + PC.VazMontante[i];
           b := g1.Series.AdicionaSerieDeLinhas('Vazão Total', clRED, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbVSB.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Vazões das Sub-Bacias', clBlack, PC.AfluenciaSB, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbVM.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Vazões de Montante', clGray, PC.VazMontante, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDef.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Defluência', clWhite, PC.Defluencia, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDATot.Checked Then
        begin
        V := TV.Create(PC.DemPriAtendida.Len);

        if (Fim <= PC.DemPriAtendida.Len) and (Fim <= PC.DemSecAtendida.Len) and (Fim <= PC.DemTerAtendida.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriAtendida[i] + PC.DemSecAtendida[i] + PC.DemTerAtendida[i];

           b := g1.Series.AdicionaSerieDeLinhas('Dem. Tot. Atendida', clMaroon, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDAP.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Pri. Atendida', clGreen, PC.DemPriAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(1);
        end;

     if cbDAS.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Sec. Atendida', clYellow, PC.DemSecAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(2);
        end;

     if cbDAT.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Ter. Atendida', clBlue, PC.DemTerAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(3);
        end;

     if cbDPTot.Checked Then
        begin
        V := TV.Create(PC.DemPriPlanejada.Len);

        if (Fim <= PC.DemPriPlanejada.Len) and (Fim <= PC.DemSecPlanejada.Len) and (Fim <= PC.DemTerPlanejada.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriPlanejada[i] + PC.DemSecPlanejada[i] + PC.DemTerPlanejada[i];

           b := g1.Series.AdicionaSerieDeLinhas('Dem. Tot. Planejada', clBlack, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDPP.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Pri. Planejada', clPurple, PC.DemPriPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPS.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Sec. Planejada', clRed, PC.DemSecPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPT.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Ter. Planejada', clLime, PC.DemTerPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRTot.Checked Then
        begin
        V := TV.Create(PC.DemPriTotal.Len);

        if (Fim <= PC.DemPriTotal.Len) and (Fim <= PC.DemSecTotal.Len) and (Fim <= PC.DemTerTotal.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriTotal[i] + PC.DemSecTotal[i] + PC.DemTerTotal[i];

           b := g1.Series.AdicionaSerieDeLinhas('Dem. Tot. Ref ', clYellow, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDRP.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Pri. Ref', clLime, PC.DemPriTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRS.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Sec. Ref', clRed, PC.DemSecTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRT.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Dem. Ter. Ref', clAqua, PC.DemTerTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbEG.Checked then
        begin
        b := g1.Series.AdicionaSerieDeLinhas('Energia', $00F1BECF, TprPCP(PC).Energia, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        end;
     end;

  g2 := nil;
  if cbBarras.Checked then
     begin
     g2 := PC.CriarGrafico_Default('Grafico X-Tudo do ' + PC.Nome, k);

     if cbVT.Checked Then
        begin
        V := TV.Create(PC.AfluenciaSB.Len);

        if (Fim <= PC.AfluenciaSB.Len) and (Fim <= PC.VazMontante.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.AfluenciaSB[i] + PC.VazMontante[i];

           b := g2.Series.AdicionaSerieDeBarras('Vazão Total', clRED, 0, 1, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbVSB.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Vazões das Sub-Bacias', clBlack, 0, 1, PC.AfluenciaSB, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbVM.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Vazões de Montante', clGray, 0, 1, PC.VazMontante, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDef.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Defluência', clWhite, 0, 1, PC.Defluencia, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDATot.Checked Then
        begin
        V := TV.Create(PC.DemPriAtendida.Len);

        if (Fim <= PC.DemPriAtendida.Len) and (Fim <= PC.DemSecAtendida.Len) and (Fim <= PC.DemTerAtendida.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriAtendida[i] + PC.DemSecAtendida[i] + PC.DemTerAtendida[i];

           b := g2.Series.AdicionaSerieDeBarras('Dem. Tot. Atendida', clMaroon, 0, 1, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDAP.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Pri. Atendida', clGreen, 0, 1, PC.DemPriAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(1);
        end;

     if cbDAS.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Sec. Atendida', clYellow, 0, 1, PC.DemSecAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(2);
        end;

     if cbDAT.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Ter. Atendida', clBlue, 0, 1, PC.DemTerAtendida, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(3);
        end;

     if cbDPTot.Checked Then
        begin
        V := TV.Create(PC.DemPriPlanejada.Len);

        if (Fim <= PC.DemPriPlanejada.Len) and (Fim <= PC.DemSecPlanejada.Len) and (Fim <= PC.DemTerPlanejada.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriPlanejada[i] + PC.DemSecPlanejada[i] + PC.DemTerPlanejada[i];

           b := g2.Series.AdicionaSerieDeBarras('Dem. Tot. Planejada', clBlack, 0, 1, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDPP.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Pri. Planejada', clMaroon, 0, 1, PC.DemPriPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPS.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Sec. Planejada', clGreen, 0, 1, PC.DemSecPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPT.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Ter. Planejada', clLime, 0, 1, PC.DemTerPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRTot.Checked Then
        begin
        V := TV.Create(PC.DemPriTotal.Len);

        if (Fim <= PC.DemPriTotal.Len) and (Fim <= PC.DemSecTotal.Len) and (Fim <= PC.DemTerTotal.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriTotal[i] + PC.DemSecTotal[i] + PC.DemTerTotal[i];

           b := g2.Series.AdicionaSerieDeBarras('Dem. Tot. Ref', clYellow, 0, 1, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDRP.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Pri. Ref', clLime, 0, 1, PC.DemPriTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRS.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Sec. Ref', clRed, 0, 1, PC.DemSecTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRT.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Dem. Ter. Ref', clAqua, 0, 1, PC.DemTerTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbEG.Checked then
        begin
        b := g2.Series.AdicionaSerieDeBarras('Energia', $00F1BECF, 0, 1, TprPCP(PC).Energia, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        end;
     end;

  g3 := nil;
  if cbPontos.Checked then
     begin
     g1 := PC.CriarGrafico_Default('Grafico X-Tudo do ' + PC.Nome, k);

     if cbVT.Checked Then
        begin
        V := TV.Create(PC.AfluenciaSB.Len);

        if (Fim <= PC.AfluenciaSB.Len) and (Fim <= PC.VazMontante.Len) then
           begin
           for i := Ini to Fim do V[i] := PC.AfluenciaSB[i] + PC.VazMontante[i];
           b := g1.Series.AdicionaSerieDePontos('Vazão Total', clRED, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbVSB.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Vazões das Sub-Bacias', clBlack, PC.AfluenciaSB, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbVM.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Vazões de Montante', clGray, PC.VazMontante, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDef.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Defluência', clWhite, PC.Defluencia, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDATot.Checked Then
        begin
        V := TV.Create(PC.DemPriAtendida.Len);

        if (Fim <= PC.DemPriAtendida.Len) and (Fim <= PC.DemSecAtendida.Len) and (Fim <= PC.DemTerAtendida.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriAtendida[i] + PC.DemSecAtendida[i] + PC.DemTerAtendida[i];

           b := g1.Series.AdicionaSerieDePontos('Dem. Tot. Atendida', clMaroon, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDAP.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Pri. Atendida', clGreen, PC.DemPriAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(1);
        end;

     if cbDAS.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Sec. Atendida', clYellow, PC.DemSecAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(2);
        end;

     if cbDAT.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Ter. Atendida', clBlue, PC.DemTerAtendida, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        if cbFalhas.Checked then DestacaFalhas(3);
        end;

     if cbDPTot.Checked Then
        begin
        V := TV.Create(PC.DemPriPlanejada.Len);

        if (Fim <= PC.DemPriPlanejada.Len) and (Fim <= PC.DemSecPlanejada.Len) and (Fim <= PC.DemTerPlanejada.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriPlanejada[i] + PC.DemSecPlanejada[i] + PC.DemTerPlanejada[i];

           b := g1.Series.AdicionaSerieDePontos('Dem. Tot. Planejada', clBlack, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDPP.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Pri. Planejada', clPurple, PC.DemPriPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPS.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Sec. Planejada', clRed, PC.DemSecPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDPT.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Ter. Planejada', clLime, PC.DemTerPlanejada, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRTot.Checked Then
        begin
        V := TV.Create(PC.DemPriTotal.Len);

        if (Fim <= PC.DemPriTotal.Len) and (Fim <= PC.DemSecTotal.Len) and (Fim <= PC.DemTerTotal.Len) then
           begin
           for i := Ini to Fim do V[i] :=
             PC.DemPriTotal[i] + PC.DemSecTotal[i] + PC.DemTerTotal[i];

           b := g1.Series.AdicionaSerieDePontos('Dem. Tot. Ref ', clYellow, V, Ini,Fim);
           PC.DefinirEixoX_Default(b, k);
           end;

        V.Free;
        end;

     if cbDRP.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Pri. Ref', clLime, PC.DemPriTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRS.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Sec. Ref', clRed, PC.DemSecTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbDRT.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Dem. Ter. Ref', clAqua, PC.DemTerTotal, Ini,Fim);
        PC.DefinirEixoX_Default(b, k);
        end;

     if cbEG.Checked then
        begin
        b := g1.Series.AdicionaSerieDePontos('Energia', $00F1BECF, TprPCP(PC).Energia, Ini, Fim);
        PC.DefinirEixoX_Default(b, k);
        end;
     end;

  if ComFalhas then Falhas.Free;
end;

procedure TprDialogo_Grafico_PCs_XTudo.btnSalvarEsquemaClick(Sender: TObject);
var Nome: String;
    b: Boolean;
begin
  Nome := 'Esquema 1';
  b := InputQuery(' Esquemas', 'Entre com um nome para o esquema:', Nome);
  if b then
     if not gEsq_OpcoesGraf.Existe(Nome) then
        begin
        gEsq_OpcoesGraf.Adicionar(Nome, ObtemEsquema);
        FormShow(nil);
        end
     else
        MessageDLG('Este nome de esquema já existe.'#13'Escolha outro nome.', mtInformation, [mbOK], 0);
end;

function TprDialogo_Grafico_PCs_XTudo.ObtemEsquema: Tesq_OpcoesGraf;
var i: Integer;
begin
  Result := Tesq_OpcoesGraf.Create;

  // 6 esquemas reservados
  for i := 0 to 5 do Result.Add(False);

  Result.Add(cbLinhas.Checked);
  Result.Add(cbBarras.Checked);

  Result.Add(cbVSB.Checked);
  Result.Add(cbVM.Checked);
  Result.Add(cbDef.Checked);

  Result.Add(cbDATot.Checked);
  Result.Add(cbDAP.Checked);
  Result.Add(cbDAS.Checked);
  Result.Add(cbDAT.Checked);

  Result.Add(cbDPTot.Checked);
  Result.Add(cbDPP.Checked);
  Result.Add(cbDPS.Checked);
  Result.Add(cbDPT.Checked);

  Result.Add(cbDRTot.Checked);
  Result.Add(cbDRP.Checked);
  Result.Add(cbDRS.Checked);
  Result.Add(cbDRT.Checked);

  Result.Add(cbVT.Checked);
  Result.Add(cbPontos.Checked);

{
  for i := 0 to lbUsuario.Items.Count-1 do
    Result.Add(lbUsuario.Selected[i]);
}
end;

procedure TprDialogo_Grafico_PCs_XTudo.AplicarEsquema(Esquema: Tesq_OpcoesGraf);
var i: Integer;
begin
  // 6 esquemas reservados

  cbLinhas.Checked := Esquema[6];
  cbBarras.Checked := Esquema[7];

  cbVSB.Checked    := Esquema[8];
  cbVM.Checked     := Esquema[9];
  cbDef.Checked    := Esquema[10];

  cbDATot.Checked  := Esquema[11];
  cbDAP.Checked    := Esquema[12];
  cbDAS.Checked    := Esquema[13];
  cbDAT.Checked    := Esquema[14];

  cbDPTot.Checked  := Esquema[15];
  cbDPP.Checked    := Esquema[16];
  cbDPS.Checked    := Esquema[17];
  cbDPT.Checked    := Esquema[18];

  cbDRTot.Checked  := Esquema[19];
  cbDRP.Checked    := Esquema[20];
  cbDRS.Checked    := Esquema[21];
  cbDRT.Checked    := Esquema[22];

  cbVT.Checked     := Esquema[23];

  cbPontos.Checked := Esquema[24];
{
  for i := 0 to lbUsuario.Items.Count-1 do
    if 24 + i < Esquema.Count then
       lbUsuario.Selected[i] := Esquema[24 + i];
}
end;

procedure TprDialogo_Grafico_PCs_XTudo.FormShow(Sender: TObject);
begin
  gEsq_OpcoesGraf.Mostrar(cbEsquemas.Items);
end;

procedure TprDialogo_Grafico_PCs_XTudo.cbEsquemasChange(Sender: TObject);
begin
  if cbEsquemas.ItemIndex > -1 then
     AplicarEsquema(gEsq_OpcoesGraf.Esquema[cbEsquemas.ItemIndex]);
end;

procedure TprDialogo_Grafico_PCs_XTudo.cbEsquemasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
     begin
     gEsq_OpcoesGraf.Remover(cbEsquemas.Text);
     FormShow(nil);
     if cbEsquemas.Items.Count > 0 then cbEsquemas.ItemIndex := 0 else cbEsquemas.Text := '';
     cbEsquemasChange(nil);
     end;

  Key := 0;
end;

end.

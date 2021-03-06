unit JanelaPrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Execfile, Menus, ComCtrls, ImgList, ToolWin, ActnList,
  drEdit, foBook, ChartBaseClasses;

type
  TcaDialogo_JanelaPrincipal = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    edTituloGeral: TEdit;
    edNumAcudes: TdrEdit;
    edNumAnos: TdrEdit;
    edAnoIni: TdrEdit;
    Button1: TButton;
    Load: TOpenDialog;
    Save: TSaveDialog;
    Label5: TLabel;
    edDirSai: TEdit;
    btnDir: TSpeedButton;
    Exec: TExecFile;
    MenuHelp: TPopupMenu;
    MenuHelp_About: TMenuItem;
    MenuHelp_Help: TMenuItem;
    CBTaskBar: TCoolBar;
    ImgListTBar: TImageList;
    ActionList1: TActionList;
    ActOpen: TAction;
    ActSave: TAction;
    ActEditor: TAction;
    ActGraf: TAction;
    ActDiagnostic: TAction;
    ActRun: TAction;
    ActHelp: TAction;
    ActExit: TAction;
    MMMain: TMainMenu;
    Arquivo1: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Editar1: TMenuItem;
    Editor1: TMenuItem;
    Grficos1: TMenuItem;
    N2: TMenuItem;
    Diagnstico1: TMenuItem;
    Executar1: TMenuItem;
    Ajuda1: TMenuItem;
    Ajuda2: TMenuItem;
    ToolBar2: TToolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TbBtHelp: TToolButton;
    ToolButton11: TToolButton;
    Sobre1: TMenuItem;
    ActAbout: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    ActData: TAction;
    procedure btnDirClick(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActEditorExecute(Sender: TObject);
    procedure ActGrafExecute(Sender: TObject);
    procedure ActDiagnosticExecute(Sender: TObject);
    procedure ActRunExecute(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure ActHelpExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActDataExecute(Sender: TObject);
  private
    Arq_Grafico: String;

    procedure GerarArquivo;
    procedure Diagnostico(MostraMesOK: Boolean);
    procedure LeArquivosDoCascataDOS;
    procedure LerParametrosBasicos(i: Integer; const s: String; SL: TStrings);
    procedure LerFuncaoDeRegulacao(i: Integer; const s: String; SL: TStrings);
    procedure LerAjustePolinomial(i: Integer; const s: String; SL: TStrings);
  public
    procedure Abrir(const Arquivo: String);
  end;

var
  caDialogo_JanelaPrincipal: TcaDialogo_JanelaPrincipal;
  gDir : String;

implementation
uses JanelaDeDados, IniFiles, FileCTRL,
     sysUtilsEx,
     FileUtils,
     WinUtils,
     Form_Chart,
     GraphicUtils,
     TeEngine,
     ca_Dialogo_ParametrosBasicos,
     ca_Dialogo_FuncaoRegula,
     ca_Dialogo_AjustePolinomio,
     AboutForm,
     Series,
     wsVec,
     UnitConst;

{$R *.DFM}



// ******************* Grava??o e Leitura dos Dados ******************

type TI = TMemIniFile;



// ******************* Grava??o e Leitura dos Dados ******************

Const
  Aspa = #39;

procedure TcaDialogo_JanelaPrincipal.GerarArquivo();
var i, k: Integer;
    s   : String;
    Erro: Boolean;
begin
  with caDialogo_Acudes, Book.TextPage do
    begin
    // Conta quantos a?udes est?o desabilitados
    k := 0;
    for i := 0 to NumAcudes - 1 do
      if sgAtivos.Cells[1, i] <> 'X' then inc(k);

    Write(Aspa + self.edTituloGeral.Text + Aspa);
    Write(IntToStr(NumAcudes - k));
    Write(IntToStr(self.edNumAnos.AsInteger));
    Write(IntToStr(self.edAnoIni.AsInteger));

    for i := 0 to NumAcudes - 1 do
      begin
      // Se o a?ude n?o est? habilitado, est?o n?o gera as informa??es
      if sgAtivos.Cells[1, i] <> 'X' then Continue;

      Write(Aspa + sgTitulos.Cells[1, i] + Aspa);
      Write(sgCoefCorr.Cells[1, i]);
      Write(Aspa + ExtractShortPathName(sgArqVaz.Cells[1, i]) + Aspa);
      Write(Aspa + ExtractShortPathName(sgArqChu.Cells[1, i]) + Aspa);

      s := '';
      for k := 1 to 12 do
        s := s + sgMes_VazMin.Cells[k, i+1] + ' ';
      Write(s);

      s := '';
      for k := 1 to 12 do
        s := s + sgMes_CoefDESC.Cells[k, i+1] + ' ';
      Write(s);

      s := '';
      for k := 1 to 12 do
        s := s + sgMes_PercRetDescarga.Cells[k, i+1] + ' ';
      Write(s);

      Write(sgCoefCorrEvap.Cells[1, i]);

      s := '';
      for k := 1 to 12 do
        s := s + sgMes_ValEvapLago.Cells[k, i+1] + ' ';
      Write(s);

      Write(sgGrauPol.Cells[1, i+1]);

      s := '';
      for k := 0 to Trunc(sgGrauPol.CellToReal(1, i+1, Erro)) do
        s := s + sgCoefsPol.Cells[k, i+1] + ' ';
      Write(s);

      // Dados dos Ac?des:
      Write(sgDA_AMax.Cells[1, i] + ' ' +
            sgDA_AMin.Cells[0, i] + ' ' +
            sgDA_AIni.Cells[0, i] + ' ' +
            sgDA_PercVMin.Cells[0, i] + ' ' +
            sgDA_TF.Cells[0, i] + ' ' +
            sgDA_TPF.Cells[0, i] + ' ' +
            sgDA_NMCR.Cells[0, i]);

      // Fun??o de regulariza??o obtida:
      s := sgFR_NumPontos.Cells[1, i] + ' ' +
           sgFR_ParKD.Cells[0, i] + ' ' +
           sgFR_NumPol.Cells[1, i+1] + ' ';

      for k := 1 to Trunc(sgFR_NumPol.CellToReal(1, i+1, Erro)) do
        s := s + sgFR_GrauPol.Cells[k-1, i+1] + ' ';

      Write(s);

      // Ajuste da ?rea da superf?cie l?quida do a?ude:
      Write(sgAASL_PercErro.Cells[1, i] + ' ' + sgAASL_NumMaxIter.Cells[1, i]);
      end; // for i
    end; // With
end;

procedure TcaDialogo_JanelaPrincipal.LeArquivosDoCascataDOS;

  function IndiceDe(const s: String; sl: TStrings; IniciarEm: Integer = 0; TamStr: Integer = -1): Integer;
  var i: Integer;
      s2: String;
  begin
    Result := -1;
    for i := IniciarEm to sl.Count - 1 do
      begin
      if TamStr = -1 then s2 := allTrim(sl[i]) else s2 := allTrim(System.Copy(sl[i], 1, TamStr));
      if CompareText(s, s2) = 0 then
         begin
         Result := i;
         Break;
         end;
      end;
  end;

  function UltimoAcude(i: Integer): Boolean;
  var ii: Integer;
  begin
    Result := True;
    with caDialogo_Acudes.sgAtivos do
      for ii := i+1 to RowCount-1 do
        if Cells[1, ii] = 'X' then
           begin
           Result := False;
           Break;
           end;
  end;


var slPB, slFR, slAP, slGRA, slAux: TStrings;
    s, s1, s2: String;
    i, ii, k, kk, j, jj, n: Integer;
    inicio1, fim1: Integer;
    inicio2, fim2: Integer;
begin
//  gEditor.NewPage;

  slPB  := TStringList.Create;
  slFR  := TStringList.Create;
  slAP  := TStringList.Create;
  slGRA := TStringList.Create;
  slAux := TStringList.Create;

  s := edDirSai.Text;
  i := Length(s);
  if (i > 0) and (s[i] <> '\') then s := s + '\';

  try
    slPB.LoadFromFile(s + 'Parametros basicos.txt');
    slFR.LoadFromFile(s + 'funcao regula.txt');
    try
      slAP.LoadFromFile(s + 'ajuste polinomio.txt');
    except
      // nada
    end;

    for i := 0 to caDialogo_Acudes.NumAcudes-1 do
      begin
      // Se o a?ude n?o est? habilitado, est?o n?o l? as informa??es
      if caDialogo_Acudes.sgAtivos.Cells[1, i] <> 'X' then Continue;

      if UltimoAcude(i) then
         begin
         fim1 := slPB.Count-1;
         fim2 := slFR.Count-1;
         end
      else
         begin
         s := caDialogo_Acudes.sgTitulos.Cells[1, i+1];
         fim1 := IndiceDe(s, slPB) - 1;
         fim2 := IndiceDe(s, slFR) - 1;
         end;

      s := caDialogo_Acudes.sgTitulos.Cells[1, i];
      inicio1 := IndiceDe(s, slPB) + 1;
      inicio2 := IndiceDe(s, slFR) + 1;

      slAux.Clear; for k := inicio1 to fim1 do slAux.Add(slPB[k]);
      LerParametrosBasicos(i, s, slAux);

      slAux.Clear; for k := inicio2 to fim2 do slAux.Add(slFR[k]);
      LerFuncaoDeRegulacao(i, s, slAux);
      end;

      { Leitura do arquivo de ajuste do polin?mio ------------------------------------ }

      // Acha o a?ude que possui ajuste polinomial
      if slAP.Count > 0 then
         begin
         k := 0;
         for i := 1 to edNumAcudes.AsInteger do
           begin
           // Se o a?ude n?o est? habilitado, est?o n?o l? as informa??es
           if caDialogo_Acudes.sgAtivos.Cells[1, i] <> 'X' then Continue;

           if strToInt(caDialogo_Acudes.sgFR_NumPol.Cells[1, i]) <> 1 then
              begin
              k := i;
              break;
              end;
           end;

         // Achou o a?ude
         if k <> 0 then
            begin
            // Ajusta o arquivo
            for i := 0 to slAP.Count - 1 do
              if (Length(slAP[i]) > 1) and (slAP[i][2] <> ' ') then
                 slAP[i] := allTrim(slAP[i+1]) + ' -' + slAP[i];

            s1 := caDialogo_Acudes.sgTitulos.Cells[1, k-1];
            ii := strToInt(caDialogo_Acudes.sgFR_NumPol.Cells[1, k]);
            for i := 0 to ii-1 do
               begin
               if i < ii-1 then
                  begin
                  s := caDialogo_Acudes.sgFR_GrauPol.Cells[i+1, k] + ' - ' + s1;
                  fim1 := IndiceDe(s, slAP) - 1;
                  end
               else
                  fim1 := slAP.Count-1;

               s := caDialogo_Acudes.sgFR_GrauPol.Cells[i, k] + ' - ' + s1;
               inicio1 := IndiceDe(s, slAP) + 1;

               slAux.Clear; for kk := inicio1 to fim1 do slAux.Add(slAP[kk]);
               LerAjustePolinomial(i, s1, slAux);
               end;

            { Leitura do arquivo GRA ------------------------------------ }

            slGRA.LoadFromFile(Arq_Grafico);

            Inicio1 := 0;
            ii := StrToInt(caDialogo_Acudes.sgFR_NumPontos.Cells[1, k-1]);
            for i := 0 to caDialogo_Acudes.NumAcudes-1 do
              begin
              // Se o a?ude n?o est? habilitado, est?o n?o l? as informa??es
              if caDialogo_Acudes.sgAtivos.Cells[1, i] <> 'X' then Continue;

              s  := caDialogo_Acudes.sgTitulos.Cells[1, i];
              for j := 1 to ii do
                begin
                s2 := 'CAPACIDADE NO.' + RightStr(IntToStr(j), 3);
                s1 := LeftStr(s, 83) + s2;
                s2 := 'FIM ' + s2;

                Inicio1 := IndiceDe(s1, slGRA, Inicio1, 101) + 3;
                Fim1    := IndiceDe(s2, slGRA, Inicio1) - 1;

                // Separa os Armazenamentos dos Defluvios
                slAux.Clear; slPB.Clear; slFR.Clear;
                for n := Inicio1 to Fim1 do slAux.Add(slGRA[n]);
                jj := IndiceDe('DEFLUVIOS', slAux);
                for n := 0 to jj-1 do slPB.Add(slAux[n]);
                for n := jj+1 to slAux.Count-1 do slFR.Add(slAux[n]);

                // slPB cont?m os Armazenamentos e slFR cont?m os Defluvios
                // ...
                end; // for j
              end; // for i
            end; // if k <> 0
         end; // if slAP.Count > 0 ...
  finally
    slPB.Free;
    slFR.Free;
    slAP.Free;
    slGRA.Free;
    slAux.Free;
  end;
end;

procedure TcaDialogo_JanelaPrincipal.btnDirClick(Sender: TObject);
var s: String;
begin
  if SelectDirectory('Selecione um Diret?rio', '', s) then
     edDirSai.Text := s;
end;

procedure TcaDialogo_JanelaPrincipal.Diagnostico(MostraMesOK: Boolean);
var i, k: Integer;
begin
  k := 0;
  for i := 0 to edNumAcudes.AsInteger - 1 do
    if caDialogo_Acudes.sgAtivos.Cells[1, i] = 'X' then inc(k);
  if k = 0 then
     Raise Exception.Create('Nenhum a?ude selecionado');

  if not DirectoryExists(edDirSai.Text) then
     Raise Exception.Create('Diret?rio de Trabalho n?o existe');

  for i := 0 to caDialogo_Acudes.NumAcudes - 1 do
    begin
    if not FileExists(caDialogo_Acudes.sgArqVaz.Cells[1, i]) then
       Raise Exception.CreateFmt('Arquivo de Vaz?es do A?ude %d inexistente', [i + 1]);

    if not FileExists(caDialogo_Acudes.sgArqChu.Cells[1, i]) then
       Raise Exception.CreateFmt('Arquivo de Chuvas do A?ude %d inexistente', [i + 1]);
    end;

  if MostraMesOK then
     MessageDLG('Dados OK !', mtInformation, [mbOK], 0);
end;

procedure TcaDialogo_JanelaPrincipal.LerAjustePolinomial(i: Integer; const s: String; SL: TStrings);

    procedure Erro;
    begin
      Raise Exception.Create('Arquivo <Ajuste Polin?mio.txt> incorreto');
    end;

const cTit1 : array[2..7] of String = ('Q (fio d?gua)', 'Q (m?dia)', 'Vol (morto)', 'MAX (Cap.?til)', 'Coef.Determ', 'DP dos Er.Aj.');
      cTit2 : array[2..5] of String = ('Func.Regul', 'Capacidade', 'Vaz.Obs', 'Vaz.Cal');

var v: TwsSFVec;
    j, k, kk: Integer;
    G  : TfoChart;
    sPol, sInd: String;
    s2, Sinal: String;
    y: Real;
    Serie: TLineSeries;
begin
  v := TwsSFVec.Create(0);
  try
    v.LoadFromStrings(SL);

    if (v.Len = 0) then
       Erro
    else
       begin
       k := 1 + 1 + 2 * v.AsInteger[1] + 6;
       if (v.Len <> k + 1 + v.AsInteger[k+1] * 3) then Erro;
       end;

    Planilha_AP.Show;

    kk := 2;
    inc(Planilha_AP.Linha);
    Planilha_AP.Tab.TextRC[Planilha_AP.Linha, 1] := s;
    Planilha_AP.SetTitulo(Planilha_AP.Linha, 2);
    Planilha_AP.Tab.TextRC[Planilha_AP.Linha, 2] := 'Polin?mio -->';
    sPol := '';
    for k := 1 to v.AsInteger[1] + 1 do // Polin?mio
      begin
      Planilha_AP.SetTitulo(Planilha_AP.Linha, k+2);
      Planilha_AP.Tab.TextRC[Planilha_AP.Linha, k+2] := 'X' + intToStr(k-1);
      Planilha_AP.Tab.NumberRC[Planilha_AP.Linha+1, k+2] := v[kk];

      // Obtendo a string Polin?mio
      s2 := FloatToStrF(v[kk], ffExponent, 7, 2);
      if k = 1 then
         sPol := s2
      else
         begin
         if v[kk] < 0 then
            begin
            Sinal := ' - ';
            Delete(s2, 1, 1);
            end
         else
            Sinal := ' + ';

         sPol := sPol + Sinal + s2 + ' x' + intToStr(k-1);
         end;

      inc(kk);
      if kk > 3 then inc(kk); // pula o grau do coeficiente
      end;

    inc(Planilha_AP.Linha, 3);
    for k := 2 to 7 do // Par?metros
      begin
      Planilha_AP.SetTitulo(Planilha_AP.Linha, k);
      Planilha_AP.Tab.TextRC[Planilha_AP.Linha, k] := cTit1[k];
      Planilha_AP.Tab.NumberRC[Planilha_AP.Linha+1, k] := v[kk];
      inc(kk);
      end;

    // T?tulos da Fun??o de Regulariza??o
    inc(Planilha_AP.Linha, 3);
    for k := 2 to 5 do
      begin
      Planilha_AP.SetTitulo(Planilha_AP.Linha, k);
      Planilha_AP.Tab.TextRC[Planilha_AP.Linha, k] := cTit2[k];
      end;

    // Valores da Fun??o de Regulariza??o, Plotagem
    sInd := IntToStr(i+1);
    if i = 0 then
       begin
       G := TfoChart.Create('Resultados');
       Graficos.Add(G);
       G.Width := 620;
       G.Caption := ' ' + s;
       G.Chart.LeftAxis.Title.Caption := 'Capacidade';
       G.Chart.BottomAxis.Title.Caption := 'Vaz?es';
       G.Series.AddLineSerie('Vaz. Obs', clBLUE);
       G.Series.AddLineSerie('Vaz. Cal (' + sInd + ')', clWHITE);
       G.Chart.Title.Text.Add('Polin?mios:');
       G.Chart.Title.Text.Add('(' + sInd + '): ' + sPol);
       end
    else
       begin
       G := TfoChart(Graficos[0]);
       Serie := G.Series.AddLineSerie('Vaz. Cal (' + sInd + ')', SelectColor(i));
       G.Chart.Title.Text.Add('(' + sInd + '): ' + sPol);
       end;

    for j := 1 to v.AsInteger[kk] do
      begin
      inc(Planilha_AP.Linha);
      for k := 3 to 5 do
        begin
        inc(kk);
        Planilha_AP.Tab.NumberRC[Planilha_AP.Linha, k] := v[kk];
        if k = 3 then
           y := v[kk]
        else
           if i = 0 then
              G.Series[k-4].AddXY(v[kk], y, '', clTeeColor) // para k = 4 e 5
           else
              if k = 5 then
                 Serie.AddXY(v[kk], y, '', clTeeColor) // para k = 5
        end;
      end;

    inc(Planilha_AP.Linha, 2);
  finally
    v.Free;
  end;
end;

procedure TcaDialogo_JanelaPrincipal.LerFuncaoDeRegulacao(i: Integer; const s: String; SL: TStrings);
var v: TwsSFVec;
    k, np, kk: Integer;
begin
  v := TwsSFVec.Create(0);
  try
    v.LoadFromStrings(SL);
    Planilha_FR.Show;

    inc(Planilha_FR.Linha);
    Planilha_FR.Tab.TextRC[Planilha_FR.Linha, 1] := s;

    if (v.Len = 0) or (v.Len <> v[1] * 11 + 1) then
       Raise Exception.Create('Arquivo <Fun??o Regula.txt> incorreto');

    kk := 1;
    for np := 1 to v.AsInteger[1] do
      begin
      for k := 1 to 11 do
        begin
        inc(kk);
        Planilha_FR.Tab.NumberRC[Planilha_FR.Linha, k+1] := v[kk];
        end;
      inc(Planilha_FR.Linha);
      end;
  finally
    v.Free;
  end;
end;

procedure TcaDialogo_JanelaPrincipal.LerParametrosBasicos(i: Integer; const s: String; SL: TStrings);
var v: TwsSFVec;
    k: Integer;
begin
  v := TwsSFVec.Create(0);
  try
    v.LoadFromStrings(SL);
    Planilha_PB.Show;
    Planilha_PB.Tab.TextRC[i+4, 1] := s;
    for k := 1 to 9 do Planilha_PB.Tab.NumberRC[i+4, k+1] := v[k];
  finally
    v.Free;
  end;
end;

procedure TcaDialogo_JanelaPrincipal.Abrir(const Arquivo: String);
var ini: TI;
    Secao: String;
    i,k: Integer;
    Key: Word;
    Erro: Boolean;
begin
  gDir := ExtractFilePath(Arquivo);
  ini := TI.Create(Arquivo);
  with caDialogo_Acudes, ini do
    begin
    Secao := 'ACUDES';

    if ReadString (Secao, 'Tipo Arq.', '') <> 'CASCATA' then
       begin
       ini.Free;
       MessageDLG('Tipo incompat?vel de arquivo', mtError, [mbOK], 0);
       EXIT;
       end;

    self.edDirSai.Text         := ReadString (Secao, 'Dir.Sai', '');
    self.edTituloGeral.Text    := ReadString (Secao, 'Titulo', '');
    self.edNumAcudes.AsInteger := ReadInteger(Secao, 'Num Acudes', 1);
    self.edNumAnos.AsInteger   := ReadInteger(Secao, 'Num Anos', 1);
    self.edAnoIni.AsInteger    := ReadInteger(Secao, 'Ano Inicial', 1800);

    NumAcudes := self.edNumAcudes.AsInteger;

    for i := 0 to NumAcudes - 1 do
      begin
      Secao := 'ACUDE ' + IntToStr(i+1);

      sgAtivos.Cells[1, i]   := ReadString(Secao, 'Ativado'  , 'X');
      sgTitulos.Cells[1, i]  := ReadString(Secao, 'Titulo'   , '');
      sgCoefCorr.Cells[1, i] := ReadString(Secao, 'Coef.Corr', '');
      sgArqVaz.Cells[1, i]   := ReadString(Secao, 'Arq.Vaz'  , '');
      sgArqChu.Cells[1, i]   := ReadString(Secao, 'Arq.Chu'  , '');

      for k := 1 to 12 do
       sgMes_VazMin.Cells[k, i+1] := ReadString(Secao, 'VazMin' + intToStr(k), '');

      for k := 1 to 12 do
        sgMes_CoefDESC.Cells[k, i+1] := ReadString(Secao, 'CoefDESC' + intToStr(k), '');

      for k := 1 to 12 do
        sgMes_PercRetDescarga.Cells[k, i+1] := ReadString(Secao, 'PercRetDescarga' + intToStr(k), '');

      sgCoefCorrEvap.Cells[1, i] := ReadString(Secao, 'CoefCorrEvap', '');

      for k := 1 to 12 do
        sgMes_ValEvapLago.Cells[k, i+1] := ReadString(Secao, 'ValEvapLago' + intToStr(k), '');

      sgGrauPol.Cells[1, i+1] := ReadString(Secao, 'GrauPol', '');

      sgGrauPol_KeyUp(sgGrauPol, Key, []);
      for k := 0 to Trunc(sgGrauPol.CellToReal(1, i+1, Erro)) do
        sgCoefsPol.Cells[k, i+1] := ReadString(Secao, 'CoefsPol' + intToStr(k), '');

      // Dados dos Ac?des:
      sgDA_AMax.Cells[1, i]     := ReadString(Secao, 'sgDA_AMax',     '');
      sgDA_AMin.Cells[0, i]     := ReadString(Secao, 'sgDA_AMin',     '');
      sgDA_AIni.Cells[0, i]     := ReadString(Secao, 'sgDA_AIni',     '');
      sgDA_PercVMin.Cells[0, i] := ReadString(Secao, 'sgDA_PercVMin', '');
      sgDA_TF.Cells[0, i]       := ReadString(Secao, 'sgDA_TF',       '');
      sgDA_TPF.Cells[0, i]      := ReadString(Secao, 'sgDA_TPF',      '');
      sgDA_NMCR.Cells[0, i]     := ReadString(Secao, 'sgDA_NMCR',     '');

      // Fun??o de regulariza??o obtida:
      sgFR_NumPontos.Cells[1, i] := ReadString(Secao, 'sgFR_NumPontos', '');
      sgFR_ParKD.Cells[0, i]     := ReadString(Secao, 'sgFR_ParKD'    , '');
      sgFR_NumPol.Cells[1, i+1]  := ReadString(Secao, 'sgFR_NumPol'   , '');

      sgFR_NumPol_KeyUp(sgFR_NumPol, Key, []);
      for k := 1 to Trunc(sgFR_NumPol.CellToReal(1, i+1, Erro)) do
        sgFR_GrauPol.Cells[k-1, i+1] := ReadString(Secao, 'sgFR_GrauPol' + intToStr(k), '');

      // Ajuste da ?rea da superf?cie l?quida do a?ude:
      sgAASL_PercErro.Cells[1, i]   := ReadString(Secao, 'sgAASL_PercErro'   , '');
      sgAASL_NumMaxIter.Cells[1, i] := ReadString(Secao, 'sgAASL_NumMaxIter' , '');
      end; // for i
    end; // With

  ini.Free;
end;

procedure TcaDialogo_JanelaPrincipal.ActOpenExecute(Sender: TObject);
begin
  Load.InitialDir := gDir;
  if Load.Execute then
     Abrir(Load.FileName);
end;

procedure TcaDialogo_JanelaPrincipal.ActSaveExecute(Sender: TObject);
var ini: TI;
    Secao: String;
    i,k: Integer;
    Erro: Boolean;
begin
  Save.InitialDir := gDir;
  if Save.Execute then
     begin
     gDir := ExtractFilePath(Save.FileName);
     RenameFile(Save.FileName, ChangeFileExt(Save.FileName, '.Bak'));
     ini := TI.Create(Save.FileName);
     with caDialogo_Acudes, ini do
       begin
       Secao := 'ACUDES';
       WriteString (Secao, 'Tipo Arq.'  , 'CASCATA');
       WriteString (Secao, 'Vers?o'     , '0.6');
       WriteString (Secao, 'Dir.Sai'    , self.edDirSai.Text);
       WriteString (Secao, 'Titulo'     , self.edTituloGeral.Text);
       WriteInteger(Secao, 'Num Acudes' , NumAcudes);
       WriteInteger(Secao, 'Num Anos'   , self.edNumAnos.AsInteger);
       WriteInteger(Secao, 'Ano Inicial', self.edAnoIni.AsInteger);
       for i := 0 to NumAcudes - 1 do
         begin
         Secao := 'ACUDE ' + IntToStr(i+1);
         WriteString(Secao, 'Ativado'  , sgAtivos.Cells[1, i]);
         WriteString(Secao, 'Titulo'   , sgTitulos.Cells[1, i]);
         WriteString(Secao, 'Coef.Corr', sgCoefCorr.Cells[1, i]);
         WriteString(Secao, 'Arq.Vaz'  , sgArqVaz.Cells[1, i]);
         WriteString(Secao, 'Arq.Chu'  , sgArqChu.Cells[1, i]);

         for k := 1 to 12 do
           WriteString(Secao, 'VazMin' + intToStr(k), sgMes_VazMin.Cells[k, i+1]);

         for k := 1 to 12 do
           WriteString(Secao, 'CoefDESC' + intToStr(k), sgMes_CoefDESC.Cells[k, i+1]);

         for k := 1 to 12 do
           WriteString(Secao, 'PercRetDescarga' + intToStr(k), sgMes_PercRetDescarga.Cells[k, i+1]);

         WriteString(Secao, 'CoefCorrEvap', sgCoefCorrEvap.Cells[1, i]);

         for k := 1 to 12 do
           WriteString(Secao, 'ValEvapLago' + intToStr(k), sgMes_ValEvapLago.Cells[k, i+1]);

         WriteString(Secao, 'GrauPol', sgGrauPol.Cells[1, i+1]);

         for k := 0 to Trunc(sgGrauPol.CellToReal(1, i+1, Erro)) do
           WriteString(Secao, 'CoefsPol' + intToStr(k), sgCoefsPol.Cells[k, i+1]);

         // Dados dos Ac?des:
         WriteString(Secao, 'sgDA_AMax'    , sgDA_AMax.Cells[1, i]);
         WriteString(Secao, 'sgDA_AMin'    , sgDA_AMin.Cells[0, i]);
         WriteString(Secao, 'sgDA_AIni'    , sgDA_AIni.Cells[0, i]);
         WriteString(Secao, 'sgDA_PercVMin', sgDA_PercVMin.Cells[0, i]);
         WriteString(Secao, 'sgDA_TF'      , sgDA_TF.Cells[0, i]);
         WriteString(Secao, 'sgDA_TPF'     , sgDA_TPF.Cells[0, i]);
         WriteString(Secao, 'sgDA_NMCR'    , sgDA_NMCR.Cells[0, i]);

         // Fun??o de regulariza??o obtida:
         WriteString(Secao, 'sgFR_NumPontos', sgFR_NumPontos.Cells[1, i]);
         WriteString(Secao, 'sgFR_ParKD'    , sgFR_ParKD.Cells[0, i]);
         WriteString(Secao, 'sgFR_NumPol'   , sgFR_NumPol.Cells[1, i+1]);

         for k := 1 to Trunc(sgFR_NumPol.CellToReal(1, i+1, Erro)) do
           WriteString(Secao, 'sgFR_GrauPol' + intToStr(k), sgFR_GrauPol.Cells[k-1, i+1]);

         // Ajuste da ?rea da superf?cie l?quida do a?ude:
         WriteString(Secao, 'sgAASL_PercErro'    , sgAASL_PercErro.Cells[1, i]);
         WriteString(Secao, 'sgAASL_NumMaxIter'   , sgAASL_NumMaxIter.Cells[1, i]);
         end; // for i
       end; // With

     ini.UpdateFile;
     ini.Free;
     end;
end;

procedure TcaDialogo_JanelaPrincipal.ActEditorExecute(Sender: TObject);
begin
  Book.Show;
end;

procedure TcaDialogo_JanelaPrincipal.ActGrafExecute(Sender: TObject);
begin
  Graficos.Show();
end;

procedure TcaDialogo_JanelaPrincipal.ActDiagnosticExecute(Sender: TObject);
begin
  Diagnostico(True);
end;

procedure TcaDialogo_JanelaPrincipal.ActRunExecute(Sender: TObject);
var NomeArquivo, Entrada, Saida, s: String;
    i: Integer;
begin
  Diagnostico(False);

  Book.NewPage('memo', 'Entrada');
  GerarArquivo();
  Book.Show();

  {$IFNDEF DEBUG}
  s := edDirSai.Text;
  i := Length(s);
  if (i > 0) and (s[i] <> '\') then s := s + '\';

  NomeArquivo := GetTempFile(s, 'CAS');
  Entrada     := ChangeFileExt(NomeArquivo, '.ENT');
  Saida       := ChangeFileExt(NomeArquivo, '.SAI');
  Arq_Grafico := ChangeFileExt(NomeArquivo, '.GRA');

  DeleteFile(Saida);
  DeleteFile(Arq_Grafico);
  DeleteFile(s + 'Parametros basicos.txt');
  DeleteFile(s + 'funcao regula.txt');
  DeleteFile(s + 'ajuste polinomio.txt');

  Book.TextPage.SaveToFile(Entrada);

  {$IFDEF NomesCurtos}
  Entrada := ExtractShortPathName(Entrada);
  {$ENDIF}

  Exec.CommandLine := ExtractFilePath(Application.ExeName) + 'CAS_DOS.EXE';
  Exec.Parameters  := Entrada + ' ' + ExtractFileName(Saida) + ' ' + ExtractFileName(Arq_Grafico);

  FreeAndNil(Planilha_FR);
  FreeAndNil(Planilha_PB);
  FreeAndNil(Planilha_AP);

  Graficos.Clear();

  if MessageDlg('Executar o Cascata DOS ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
     Planilha_FR := TcaDialogo_PlanilhaFR.Create(Application);
     Planilha_PB := TcaDialogo_PlanilhaPB.Create(Application);
     Planilha_AP := TcaDialogo_PlanilhaAP.Create(Application);

     if Exec.Execute then
        if FileExists(Saida) then
           begin
           Book.NewPage('rtf', 'Resultados');
           Book.TextPage.LoadFromFile(Saida);

           StartWait;
           s := Caption;
           Caption := ' Lendo Resultados ...';
           try
             LeArquivosDoCascataDOS;
             Graficos.Show();
             finally
             StopWait;
             Caption := s;
             end;
           end
     else
        MessageDLG('Houve um erro na execu??o do Cascata DOS', mtError, [mbOK], 0);
     end
  else
     Abort;
  {$ENDIF}
end;

procedure TcaDialogo_JanelaPrincipal.ActExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TcaDialogo_JanelaPrincipal.ActHelpExecute(Sender: TObject);
begin
  MessageDLG('Sistema de Ajuda ainda n?o implementado', mtInformation, [mbOK], 0);
end;

procedure TcaDialogo_JanelaPrincipal.ActAboutExecute(Sender: TObject);
var D: TAbout;
begin
  D := TAbout.Create(self);
  Try
    D.ShowModal;
  Finally
    D.Release;
  End;
end;

procedure TcaDialogo_JanelaPrincipal.ActDataExecute(Sender: TObject);
begin
  if edNumAcudes.AsInteger < 1 then edNumAcudes.AsInteger := 1;
  caDialogo_Acudes.NumAcudes := edNumAcudes.AsInteger;
  caDialogo_Acudes.Show;
end;

end.

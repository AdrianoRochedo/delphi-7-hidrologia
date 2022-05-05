unit pro_fo_AnalysisOfIntervals;

interface

uses     
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pro_fr_IntervalsOfStations, StdCtrls, ExtCtrls, Frame_RTF,
  pro_Classes, ComCtrls, SpreadSheetBook_Frame, pro_Application, GanttCh,
  pro_Interfaces;

type
  TfoAnaliseDePeriodos = class(TForm)
    frame: TfrIntervalsOfStations;
    Bevel1: TBevel;
    btnClose: TButton;
    Paginas: TPageControl;
    P1: TTabSheet;
    RTF: Tfr_RTF;
    P2: TTabSheet;
    Panel1: TPanel;
    Planilha1: TSpreadSheetBookFrame;
    btnExportar: TButton;
    SaveCoefs: TSaveDialog;
    P3: TTabSheet;
    Planilha2: TSpreadSheetBookFrame;
    Panel2: TPanel;
    btnExportarComb: TButton;
    SaveCombs: TSaveDialog;
    btnLerCombs: TButton;
    OpenCombs: TOpenDialog;
    procedure frame_radio_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExportarMatriz_Click(Sender: TObject);
    procedure frame_g2_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnExportarComb_Click(Sender: TObject);
    procedure btnLerCombs_Click(Sender: TObject);
  private
    FSC: TGanttSeries;
    procedure AtualizarMemo();
    procedure frame_Change(Sender: TObject; L: TListaDePeriodos);
    procedure Exportar(SaveDialog: TSaveDialog; Planilha: TSpreadSheetBookFrame; L: char);
  public
    { Public declarations }
  end;

implementation
uses SysUtilsEx, pro_Procs, Math, DateUtils;

{$R *.dfm}

procedure TfoAnaliseDePeriodos.frame_radio_Click(Sender: TObject);
begin
  FSC.Clear();
  frame.rb1Click(Sender);
  AtualizarMemo();
end;

procedure TfoAnaliseDePeriodos.AtualizarMemo();
var i, k, c, L: Integer;
    s: string;
begin
  RTF.Clear();

  RTF.setFontColor(clBlue);
  RTF.setFontSize(12);
  RTF.Write('Intervalos Individuais');

  for k := 0 to frame.PostosSel.Count-1 do
    begin
    s := frame.PostosSel[k];

    RTF.Write('');
    RTF.setFontSize(8);
    RTF.setFontColor(clRED);
    RTF.Write('   ' + s, L);
    RTF.Write('');

    c := 0;
    for i := 0 to frame.S1.Count-1 do
      if s = frame.S1.XLabel[i] then
         begin
         inc(c);
         RTF.setFontSize(8);
         RTF.setFontColor(clBlack);
         RTF.Write('   ' +
                   DateToStr(frame.S1.XValues[i]) + ' - ' +
                   DateToStr(frame.S1.EndValues[i]));
         end;

    RTF.Memo.Lines[L] := RTF.Memo.Lines[L] + ': ' + toString(c);
    end; // for k

  RTF.Write(''); // ---------------------------------------------------------------------

  RTF.setFontColor(clBlue);
  RTF.setFontSize(12);
  RTF.Write('Intervalos Comuns: ' + toString(frame.S2.Count));
  RTF.Write('');

  for i := 0 to frame.S2.Count-1 do
    begin
    RTF.setFontSize(8);
    RTF.setFontColor(clBlack);
    RTF.Write('   ' +
              DateToStr(frame.S2.XValues[i]) + ' - ' +
              DateToStr(frame.S2.EndValues[i]));
    end;

  RTF.Write(''); // ---------------------------------------------------------------------

  if frame.rb1.Checked then
     begin
     RTF.setFontColor(clBlue);
     RTF.setFontSize(12);
     RTF.Write('Continuidade Comum: ' + toString(FSC.Count));
     RTF.Write('');

     for i := 0 to FSC.Count-1 do
       begin
       RTF.setFontSize(8);
       RTF.setFontColor(clBlack);
       RTF.Write('   ' +
                 DateToStr(FSC.XValues[i]) + ' - ' +
                 DateToStr(FSC.EndValues[i]));
       end;
     end;
end;

procedure TfoAnaliseDePeriodos.frame_Change(Sender: TObject; L: TListaDePeriodos);

    procedure ConstroiMatrizDePeriodos();
    var i, j, k: Integer;
        s: string;
        p: string;
        t: char;
        c: TColor;
    begin
      Planilha1.BeginUpdate();
      Planilha1.ActiveSheet.Clear();

      // Cabecalho das linhas
      i := 0;
      for k := 0 to frame.PostosSel.Count-1 do
        begin
        s := frame.PostosSel[k];
        Planilha1.ActiveSheet.Write(k+2, 1, true, s);
        j := Canvas.TextWidth('   ' + s);
        if j > i then i := j;
        end;
      Planilha1.ActiveSheet.ColWidth[1] := i;

      // Cabecalho das colunas
      for k := 0 to L.NumPeriodos-1 do
        begin
        s := 'P' + toString(k+1);
        Planilha1.ActiveSheet.WriteCenter(1, k+2, 6, clBlack, true, s);
        Planilha1.ActiveSheet.ColWidth[k+2] := Canvas.TextWidth('  ' + s);
        end;

      for j := 0 to L.NumPeriodos-1 do
        begin
        s := pro_Procs.SetToPostos(L[j].Postos, frame.Info);
        for k := 0 to frame.PostosSel.Count-1 do
          begin
          if (System.Pos(frame.PostosSel[k], s) > 0) then
             begin
             t := '1';
             c := clRED;
             end
          else
             begin
             t := '0';
             c := clBLACK;
             end;
          Planilha1.ActiveSheet.WriteCenter(k+2, j+2, 8, c, false, t);
          end;
        end;

      Planilha1.EndUpdate();
    end;

    procedure ConstroiMatrizDeCombinacoes();
    var i, j, k: Integer;
        s: string;
        p: string;
        t: char;
        c: TColor;
       sl: TStringList;
    begin
      Planilha2.BeginUpdate();
      Planilha2.ActiveSheet.Clear();

      // Cabecalho das linhas
      i := 0;
      for k := 0 to frame.PostosSel.Count-1 do
        begin
        s := frame.PostosSel[k];
        Planilha2.ActiveSheet.Write(k+2, 1, true, s);
        j := Canvas.TextWidth('   ' + s);
        if j > i then i := j;
        end;
      Planilha2.ActiveSheet.ColWidth[1] := i;

      // Cria a lista que contera as diferentes compinacoes binarias
      sl := TStringList.Create();
      sl.Sorted := true;
      sl.Duplicates := dupIgnore;

      // Obtem as combinacoes
      for k := 0 to L.NumPeriodos-1 do
        begin
        s := '';
        for i := 0 to frame.PostosSel.Count-1 do
          s := s + Planilha1.ActiveSheet.GetText(i+2, k+2);
        sl.Add(s);
        end;

      // Escreve as combinacoes encontradas
      for k := 0 to sl.Count-1 do
        begin
        s := sl[k];
        Planilha2.ActiveSheet.WriteCenter(1, k+2, true, 'C' + toString(k+1));
        for i := 1 to Length(s) do
          begin
          t := s[i];
          if t = '1' then c := clRED else c := clBLACK;
          Planilha2.ActiveSheet.WriteCenter(i+1, k+2, 8, c, false, t);
          end;
        end;

      sl.Free();
      Planilha2.EndUpdate();
    end;

(*
    procedure ConstroiGanttDeContinuidade();
    var pi: pRecDadosPeriodo; // Periodo inicial
        k: integer;
    begin
      if frame.rb1.Checked and (L.NumPeriodos > 0) then
         begin
         pi := L[0];
         for k := 1 to L.NumPeriodos-1 do
           // Verifica se a diferenca entre os periodos eh de mais de 1 dia
           if (L[k].DI - L[k-1].DF) > 1 then
              begin
              FSC.AddGantt(pi.DI, L[k-1].DF, 1, 'per.Cont.');
              pi := L[k];
              end;
         FSC.AddGantt(pi.DI, L[L.NumPeriodos-1].DF, 1, 'per.Cont.');
         end;
    end;
*)

    procedure ConstroiGanttDeContinuidade();
    var pi: pRecDadosPeriodo; // Periodo inicial
        k: integer;
    begin
      if frame.rb1.Checked and (L.NumPeriodos > 0) then
         begin
         pi := L[0];

         if frame.Info.TipoIntervalo = tiDiario then
            begin
            for k := 1 to L.NumPeriodos-1 do
              // Verifica se a diferenca entre os periodos eh de mais de 1 dia
              if (L[k].DI - L[k-1].DF) > 1 then
                 begin
                 FSC.AddGantt(pi.DI, L[k-1].DF, 1, 'per.Cont.');
                 pi := L[k];
                 end;
            end
         else
            begin
            for k := 1 to L.NumPeriodos-1 do
              // Verifica se a diferenca entre os periodos eh de mais de 1 mes
              if MonthsBetween(L[k-1].DF, L[k].DI) > 1 then
                 begin
                 FSC.AddGantt(pi.DI, L[k-1].DF, 1, 'per.Cont.');
                 pi := L[k];
                 end;
            end;

         FSC.AddGantt(pi.DI, L[L.NumPeriodos-1].DF, 1, 'per.Cont.');
         end;
    end;

begin
  FSC.Clear();
  AtualizarMemo();
  ConstroiMatrizDePeriodos();
  ConstroiMatrizDeCombinacoes();
  ConstroiGanttDeContinuidade();
end;

procedure TfoAnaliseDePeriodos.FormCreate(Sender: TObject);
begin
  FSC := TGanttSeries.Create(frame);
  FSC.ParentChart := frame.g2;
  FSC.Title := 'Per. Contínuos';
  
  frame.OnChange := frame_Change;
  Planilha1.ActiveSheet.ColWidth[1] := 100;
  Planilha2.ActiveSheet.ColWidth[1] := 100;
end;

procedure TfoAnaliseDePeriodos.Exportar(SaveDialog: TSaveDialog; Planilha: TSpreadSheetBookFrame; L: char);
var sl: TStringList;
    k, j: integer;
    s: string;
begin
  SaveDialog.InitialDir := Applic.LastDir;
  if SaveDialog.Execute() then
     begin
     Applic.LastDir := ExtractFilePath(SaveDialog.FileName);
     sl := TStringList.Create();

     // 1. linha
     s := 'Posto';
     for j := 1 to Planilha.ActiveSheet.ColCount-1 do
       s := s + ';' + L + toString(j);
     sl.Add(s);

     // Postos e Periodos
     for k := 0 to frame.PostosSel.Count-1 do
       begin
       s := frame.PostosSel[k];
       for j := 2 to Planilha.ActiveSheet.ColCount do
         s := s + ';' + Planilha.ActiveSheet.GetText(k+2, j);
       sl.Add(s);
       end;

     sl.SaveToFile(SaveDialog.FileName);
     sl.Free();
     end;
end;

procedure TfoAnaliseDePeriodos.btnExportarMatriz_Click(Sender: TObject);
begin
  Exportar(SaveCoefs, Planilha1, 'P');
end;

procedure TfoAnaliseDePeriodos.btnExportarComb_Click(Sender: TObject);
begin
  Exportar(SaveCombs, Planilha2, 'C');
end;

procedure TfoAnaliseDePeriodos.frame_g2_MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FSC.Clicked(x, y) > -1 then
     frame.DoGanttMouseMove(FSC, frame.L2, x, y)
  else
     frame.Gantt_MouseMove(Sender, Shift, X, Y);
end;

procedure TfoAnaliseDePeriodos.btnLerCombs_Click(Sender: TObject);
var ms: TStringMat;
    p1, p2, s: string;
    i, j, k, t, m: integer;
    r, f, v, Total: real;
begin
  OpenCombs.InitialDir := Applic.LastDir;
  if OpenCombs.Execute() then
     try
       Planilha1.BeginUpdate();
       Applic.LastDir := ExtractFilePath(OpenCombs.FileName);

       // Cria uma matriz de strings correspondente ao arquivo
       ms := TStringMat.Create(OpenCombs.FileName);

       // Verifica se o arquivo eh valido
       if ms.SizeOfRowsAreEquals() then
          ms.CheckBounds := false
       else
          raise Exception.Create('Arquivo inválido');

       if Planilha1.ActiveSheet.RowCount <> ms.Rows then
          raise Exception.Create('Numero de postos do arquivo de combinações é'#13 +
                                 'diferente do número de postos selecionados');

       // Faz a substituicao dos coeficientes se o arquivo for valido
       for i := 2 to ms.Cols do
         begin
         // Obtem o padrao de uma combinacao do arquivo e ja calcula o total
         p1 := '';
         Total := 0;
         for j := 2 to ms.Rows do
           begin
           r := toFloat(ms.Item[j, i], 0);
           Total := Total + r;
           if r = 0 then
              p1 := p1 + '0'
           else
              p1 := p1 + '1';
           end;

         // Compara o padrao acima com todos os padroes da matriz dos coeficientes
         for k := 2 to Planilha1.ActiveSheet.ColCount do
           begin
           // Pega o padrao que esta na tela para comparacao com o do arquivo
           p2 := '';
           for j := 2 to Planilha1.ActiveSheet.RowCount do
             begin
             r := Planilha1.ActiveSheet.GetFloat(j, k);
             if r = 0 then
                p2 := p2 + '0'
             else
                p2 := p2 + '1';
             end;

           // Compara o padrao, se for igual, substitue pelos valores do arquivo
           if p1 = p2 then
              begin
              t := 0;

              // Substitui valores pelo coeficiente "Area/AreaTotal"
              for j := 2 to Planilha1.ActiveSheet.RowCount do
                 begin
                 if Total <> 0 then s := toString(toFloat(ms.Item[j, i], 0) / Total, 3) else s := '0';
                 Planilha1.ActiveSheet.Write(j, k, s);
                 m := Canvas.TextWidth('   ' + s);
                 if m > t then t := m;
                 end;

              // Estabelece o tamanho da celula
              Planilha1.ActiveSheet.ColWidth[k] := t;

              // Ajusta o maior valor para que a soma gere exatamente 1 .........................

              // Verifica se a soma gera 1 e ja obtek a posicao do maior valor
              v := 0.0;
              r := 0.0;
              for j := 2 to Planilha1.ActiveSheet.RowCount do
                 begin
                 f := toFloat(Planilha1.ActiveSheet.GetText(j, k)); // pega o valor da planilha
                 r := r + f; // acumula o total em "r"
                 if f > v then begin m := j; v := f end; // Guarda a posicao do maior valor em "m"
                 end;

              // Calculo a diferenca
              v := 1 - r;

              // Recalcula o maior se necessario
              if System.Abs(v) >= 0.001 then
                 begin
                 f := toFloat(Planilha1.ActiveSheet.GetText(m, k));
                 f := f + v;
                 Planilha1.ActiveSheet.Write(m, k, f, 3);
                 end;
              end;
           end;
         end;

     finally
       Planilha1.EndUpdate();
       ms.Free();
     end;
end;

end.

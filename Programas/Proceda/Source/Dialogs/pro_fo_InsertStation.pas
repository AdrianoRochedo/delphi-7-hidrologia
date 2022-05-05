unit pro_fo_InsertStation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DialogsEx,
  pro_Classes,
  pro_Application,
  pro_Interfaces;

type
  TfoInsertStation = class(TForm)
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    Label1: TLabel;
    paInfo: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    paOrigem: TPanel;
    sbOrigem: TSpeedButton;
    lbPostos: TListBox;
    Label3: TLabel;
    laProg: TLabel;
    Prog: TProgressBar;
    procedure sbOrigemClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    FInfo, Fx: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses DialogUtils,
     WinUtils,
     wsMatrix;

{$R *.dfm}

{ TfoInsertStation }

constructor TfoInsertStation.Create(Info: TDSInfo);
begin
  inherited Create(nil);
  FInfo := Info;
  paInfo.Caption := ' ' + FInfo.NomeArq;
end;

procedure TfoInsertStation.sbOrigemClick(Sender: TObject);

  procedure Limpar();
  begin
    paOrigem.Caption := '';
    lbPostos.Clear();
  end;

  // Se false, significa que não existe nenhum intervalo comum entre os dados
  function IntervaloValido(): boolean;
  begin
    {
    result := not ((Fx.DataFinal < FInfo.DataInicial) or
                   (Fx.DataInicial > FInfo.DataFinal));
    }
    result := true;
  end;

var s: string;
begin
  if DialogUtils.SelectFile(s, '', 'Arquivos PROCEDA|*.proceda') then
     if not Applic.IsOpen(s) and Applic.IsProcedaFile(s, {out} Fx) then
        if IntervaloValido() then
           begin
           paOrigem.Caption := ' ' + s;
           Fx.GetStationNames(lbPostos.Items);
           end
        else
           begin
           FreeAndNil(Fx);
           Limpar();
           Dialogs.showMessage('Arquivo válido mas intervalo de tempo inválido');
           end
     else
        begin
        Fx := nil;
        Limpar();
        Dialogs.showMessage('Arquivo Inválido');
        end;
end;

procedure TfoInsertStation.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfoInsertStation.btnOkClick(Sender: TObject);

  procedure ShowMessage(const s: string);
  begin
    laProg.Caption := s;
    laProg.Repaint();
  end;

  procedure InserirTruncarDados();
  var     ds : TwsDataset;
       i, ii : integer;
  ki, kj, kk : integer;
       j, id : integer;
           s : string;
          sl : TStrings;
  begin
    StartWait();

    ds := FInfo.DS;
    Prog.Max := Fx.DS.nRows;
    sl := TStringList.Create();

    ShowMessage('Criando Postos ...');
    for i := 0 to lbPostos.Items.Count-1 do
      if lbPostos.Selected[i] then
         begin
         s := lbPostos.Items[i];
         ds.AddCol(s, 'Posto ' + s, dtNumeric);
         ds.Struct.Col[ds.nCols].aObject :=
            // O nome pode variar se ja existir um mesmo
            TStation.Create(ds.Struct.Col[ds.nCols].Name, FInfo);
         sl.Add(ds.Struct.Col[ds.nCols].Name);
         end;

    ShowMessage('Redimensionando registros ...');
    for i := 1 to ds.nRows do
      ds.Row[i].Len := ds.nCols;

   // Copia os dados
    kk := 0;
    for i := 0 to lbPostos.Items.Count-1 do
      if lbPostos.Selected[i] then
         begin
         s := lbPostos.Items[i];
         ShowMessage('Copiando dados do posto ' + s + ' ...');

         // Posicao dos postos nos dois conjuntos
         ki := ds.Struct.IndexOf(sl[kk]);
         kj := Fx.ds.Struct.IndexOf(s);

         for j := 1 to Fx.DS.nRows do
           begin
           Prog.Position := j;
           id := FInfo.IndiceDaData( Fx.DS.AsDateTime[j, 1] );
           if id > -1 then
              ds[id, ki] := Fx.DS[j, kj];
           end;

         inc(kk);
         end;

    sl.Free();
  end;

  procedure InserirExpandirDados();
  var ps, i, k, j, kj, ki: integer;
      d, di, df: TDateTime;
      ds: TwsDataset;
      s: string;
  begin
    StartWait();

    // conta os postos selecionados
    ps := 0;
    for i := 0 to lbPostos.Items.Count-1 do
      if lbPostos.Selected[i] then
         inc(ps);

    // Verifica o maior intervalo
    if Fx.DataInicial < FInfo.DataInicial then di := Fx.DataInicial else di := FInfo.DataInicial;
    if Fx.DataFinal > FInfo.DataFinal then df := Fx.DataFinal else df := FInfo.DataFinal;

    // Cria o Dataset
    ds := Applic.CreateDataSet(di, df, FInfo.TipoIntervalo, FInfo.NumPostos + ps);

    // Copia os dados de "FInfo" para "ds"
    Prog.Max := FInfo.DS.nRows;
    ShowMessage('Copiando dados do conjunto atual para o novo');
    for i := 1 to FInfo.DS.nRows do
      begin
      Prog.Position := i;

      // Calcula o indice da data no novo conjunto
      d := FInfo.DS.AsDateTime[i, 1];
      if FInfo.TipoIntervalo = tiDiario then
         j := trunc(d - di + 1)
      else
         ds.FindDate(d, 1, false, j);

      // Passa os dados para a linha correta
      for k := cPostos to (cPostos + FInfo.NumPostos - 1) do
        ds[j, k] := FInfo.DS[i, k];
      end;

    // Passa as referencias dos postos de "FInfo" para "ds"
    for k := cPostos to (cPostos + FInfo.NumPostos - 1) do
      begin
      ds.Struct.Col[k].Name := FInfo.DS.Struct.Col[k].Name;
      ds.Struct.Col[k].Lab := FInfo.DS.Struct.Col[k].Lab;
      ds.Struct.Col[k].aObject := FInfo.DS.Struct.Col[k].aObject;
      end;

    // Cria os novos postos
    ShowMessage('Criando os novos postos');
    j := cPostos + FInfo.NumPostos;
    for i := 0 to lbPostos.Items.Count-1 do
      if lbPostos.Selected[i] then
         begin
         // Posicao dos postos nos dois conjuntos
         k := Fx.ds.Struct.IndexOf(lbPostos.Items[i]);

         // Criacao do posto
         s := Fx.DS.Struct.Col[k].Name;
         ds.Struct.Col[j].Name := s;
         ds.Struct.Col[j].Lab := 'Posto ' + s;
         ds.Struct.Col[j].aObject := TStation.Create(s, FInfo);

         inc(j);
         end;

     // Copia os dados de "Fx" para "ds"
     Prog.Max := Fx.DS.nRows;
     for i := 0 to lbPostos.Items.Count-1 do
       if lbPostos.Selected[i] then
          begin
          s := lbPostos.Items[i];
          ShowMessage('Copiando dados do conjunto aberto para o novo. Posto: ' + s);

          // Posicao dos postos nos dois conjuntos
          ki := ds.Struct.IndexOf(s);
          kj := Fx.ds.Struct.IndexOf(s);

          for j := 1 to Fx.DS.nRows do
            begin
            Prog.Position := j;

            // Calcula o indice da data no novo conjunto
            d := Fx.DS.AsDateTime[j, 1];
            if Fx.TipoIntervalo = tiDiario then
               k := trunc(d - di + 1)
            else
               ds.FindDate(d, 1, false, k);

            ds[k, ki] := Fx.DS[j, kj];
            end;
          end;

    // Troca a referencia de "FInfo.DS" por "DS"
    FInfo.TrocarDataset(ds);
  end;

var mes: string;
    res: integer;
begin
  if Fx <> nil then
     if lbPostos.SelCount > 0 then
        try
          laProg.Visible := true;
          Prog.Visible := true;

          if (Fx.DataInicial < FInfo.DataInicial) or
             (Fx.DataFinal > FInfo.DataFinal) then
             begin
             mes := 'O intervalo dos dados a serem inseridos estão fora do intervalo atual.'#13 +
                    'Você deseja expandir o conjunto de dados ou truncar o intervalo ao atual ?';
             res := MessageDlg2(mes, mtConfirmation, ['Expandir', 'Truncar', 'Cancelar'], [0, 0], 0);
             case res of
               1: InserirExpandirDados();
               2: InserirTruncarDados();
               3: {Nada} ;
               end;
             end
          else
             begin
             res := 2;
             InserirTruncarDados();
             end;

          if res <> 3 then Applic.UpdateProperties(FInfo);
        finally
          laProg.Visible := false;
          Prog.Visible := false;
          if res <> 3 then StopWait();
        end
     else
       Dialogs.showMessage('Selecione os postos para inserção')
  else
     Dialogs.showMessage('Selecione um arquivo válido');
end;

end.

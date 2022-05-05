unit JanelaPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, drEdit, TeEngine, Series, ExtCtrls, TeeProcs, Chart, IniFiles,
  Contnrs, Menus, ToolWin, ComCtrls, ActnList, Buttons, gridx32, dlg_Dados;

type
  TfoPrincipal = class(TForm)
    Label1: TLabel;
    Chart: TChart;
    btnAdicionar: TButton;
    btnEditar: TButton;
    btnRemover: TButton;
    Label2: TLabel;
    Bevel1: TBevel;
    laCU: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    rbAMC_I: TRadioButton;
    rbAMC_II: TRadioButton;
    rbAMC_III: TRadioButton;
    Menu: TMainMenu;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    Arquivo2: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    Iniciar2: TMenuItem;
    N1: TMenuItem;
    Ajuda1: TMenuItem;
    SobreocalculodeCN1: TMenuItem;
    picosdaajuda1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Sair1: TMenuItem;
    ODIni: TOpenDialog;
    SDIni: TSaveDialog;
    Editar1: TMenuItem;
    Adicionar1: TMenuItem;
    Atualizar1: TMenuItem;
    Remover1: TMenuItem;
    Limpar1: TMenuItem;
    ALPrincipal: TActionList;
    ActAdicionar: TAction;
    ActLimpar: TAction;
    ActAtualizar: TAction;
    ActRemover: TAction;
    ActAbrir: TAction;
    ActSalvar: TAction;
    AclSair: TAction;
    btnOK: TSpeedButton;
    Grid: TdrStringAlignGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure ActLimparExecute(Sender: TObject);
    procedure ActAbrirExecute(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AclSairExecute(Sender: TObject);
  private
    Linhas     : Integer;
    FList      : TObjectList;
    FPizza     : TPieSeries;
    FValidar   : Boolean;
    FDados     : TdlgDados;

    function ObterSomatorio: Real;
    function GetCN_Medio: Real;

    procedure RecalcularAreaRestante;
    procedure CalcularCN_Medio;
    procedure AjustarNomeDaSubDivisao;
  public
    property Validar: Boolean read FValidar write FValidar;
    property CN_Medio: Real read GetCN_Medio;
  end;

  TDados = class
    Titulo : ShortString;
    TB     : Integer;
    US     : Integer;
    Sup    : Integer;
    TS     : Integer;
    Perc   : Real;
    CN     : Integer;

    constructor Create; overload;
    constructor Create(const Titulo: String;
                       const TB, US, Sup, TS: Integer;
                       const Perc: Real;
                       const CN: Integer); overload;
    public
      procedure SaveToFile(const FileName: string);
      procedure LoadFromFile(const FileName,Name: string);
  end;

  function ObterCN(Validar: Boolean): Real;

implementation
uses WinUtils;

const
  MaxDados  = 5;
  CIniDados : array [0..MaxDados] of string =
    ('CN','Perc','Sup','TB','TS','US');

{$R *.dfm}

function ObterCN(Validar: Boolean): Real;
var d: TfoPrincipal;
begin
  d := TfoPrincipal.Create(nil);
  D.Validar := Validar;
  d.ShowModal;
  Result := d.CN_Medio;
  d.Release;
end;

const
  cVM : array[0..19] of Real =
    (5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100);

  cAMC_I : array[0..19] of Real =
    (2, 4, 6, 9, 12, 15, 18, 22, 26, 31, 35, 40, 45, 51, 57, 63, 70, 78, 87, 100);

  cAMC_III : array[0..19] of Real =
    (13, 22, 30, 37, 43, 50, 55, 60, 65, 70, 74, 78, 82, 85, 88, 91, 94, 96, 98, 100);

function Interpol(const x: Real; const v1, v2: array of Real): Real;
var i: word;
begin
  if High(v1) <> High(v2) then
     raise Exception.Create('Interpol: Invalid arrays size');

  for i := 0 to High(v1) do
    if (x = v1[i]) then
       begin
       Result := v2[i];
       Exit;
       end;

  if x < v1[0] then
     Result := v2[0]
  else
     if x > v1[High(v1)] then
        Result := v2[High(v2)]
     else
        for i := 1 to High(v1) do
           if (x > v1[i-1]) and (x < v1[i]) then
              begin
              Result := x * v2[i] / v1[i];
              Break;
              end;
end;

{ TDados }

constructor TDados.Create(const Titulo: String;
                          const TB, US, Sup, TS: Integer;
                          const Perc: Real;
                          const CN: Integer);
begin
  self.Titulo := Titulo;
  self.TB     := TB;
  self.US     := US;
  self.Sup    := Sup;
  self.TS     := TS;
  self.Perc   := Perc;
  self.CN     := CN;
end;

constructor TDados.Create;
begin
  inherited;
  Titulo := '';
  TB := 0;
  US := 0;
  CN := 0;
  TS := 0;
  Sup := 0;
  Perc := 0;
end;

procedure TDados.LoadFromFile(const FileName, Name: string);
var
  IniCN : TMemIniFile;
begin
  IniCN := TMemIniFile.Create(FileName);

  Titulo := Name;
  CN   := IniCN.ReadInteger(Name,CIniDados[0],0);
  Perc := IniCN.ReadFloat(Name,CIniDados[1],0);
  Sup  := IniCN.ReadInteger(Name,CIniDados[2],0);
  TB   := IniCN.ReadInteger(Name,CIniDados[3],0);
  TS   := IniCN.ReadInteger(Name,CIniDados[4],0);
  US   := IniCN.ReadInteger(Name,CIniDados[5],0);

  IniCN.Free;
end;

procedure TDados.SaveToFile(const FileName: string);
var
  IniCN : TMemIniFile;
begin
  IniCN := TMemIniFile.Create(FileName);

  IniCN.WriteFloat(Titulo,CIniDados[0],CN);
  IniCN.WriteFloat(Titulo,CIniDados[1],Perc);
  IniCN.WriteInteger(Titulo,CIniDados[2],Sup);
  IniCN.WriteInteger(Titulo,CIniDados[3],TB);
  IniCN.WriteInteger(Titulo,CIniDados[4],TS);
  IniCN.WriteInteger(Titulo,CIniDados[5],US);

  IniCN.UpdateFile;
  IniCN.Free;
end;

{ TfoPrincipal }

procedure TfoPrincipal.FormCreate(Sender: TObject);
begin
  FList := TObjectList.Create(True);

  FPizza := TPieSeries.Create(Chart);
  FPizza.ParentChart := Chart;
  FPizza.ShowInLegend := False;

  Chart.Title.Text.Clear;

  Grid.Cells[0, 0] := ' Título da Sub-Divisão';
  Grid.Cells[1, 0] := ' Percentagem (%)';
  Grid.Cells[2, 0] := ' CN';
  Grid.AlignCol[1] := alCenter;
  Grid.AlignCol[2] := alCenter;

  FDados := TdlgDados.Create(ExtractFilePath(Application.ExeName) + 'Dados CN\');
end;

procedure TfoPrincipal.FormDestroy(Sender: TObject);
begin
  FDados.Free;
  FList.Free;
end;

procedure TfoPrincipal.btnAdicionarClick(Sender: TObject);
var x: real;
    i: Integer;
begin
  If FDados.ShowModal = mrOk Then
     begin
     if FPizza.Count = 0 then
        FPizza.AddPie(100 - FDados.edPerc.AsFloat, 'Área Restante', clBlack)
     else
        begin
        x := ObterSomatorio + FDados.edPerc.AsFloat;
        if x > 100 then raise Exception.Create('A porcentagem corrente de área excede 100%');
        //FPizza.YValues.Value[0] := 100 - x;
        //FPizza.XLabel[0] := Format('Área Restante: %f %%', [100 - x]);
        end;

     Inc(Linhas);
     If Linhas > 1 Then Grid.RowCount := Linhas + 1;
     btnRemover.Enabled := True;
     btnEditar .Enabled := True;

     AjustarNomeDaSubDivisao;

     FList.Add(
       TDados.Create(
         FDados.edTit.Text,
         FDados.cbTB.ItemIndex,
         FDados.cbUS.ItemIndex,
         FDados.cbS.ItemIndex,
         FDados.cbTS.ItemIndex,
         FDados.edPerc.AsFloat,
         FDados.edCN.AsInteger
       )
     );

     FPizza.AddPie(FDados.edPerc.AsFloat, FDados.edTit.Text + ' (CN: ' + FDados.edCN.AsString + ')', clTeeColor);
     CalcularCN_Medio;

     Grid.Cells[0, Linhas] := FDados.edTit.Text;
     Grid.Cells[1, Linhas] := FDados.edPerc.AsString;
     Grid.Cells[2, Linhas] := FDados.edCN.AsString;

     RecalcularAreaRestante;
     end;
end;

function GetIndex(const s: String; Serie: TPieSeries): Integer;
begin
  for Result := 0 to Serie.PieValues.Count-1 do
    if Pos(s, Serie.ValueMarkText[Result]) > 0 then
       Exit;
  Result := -1;
end;

procedure TfoPrincipal.btnRemoverClick(Sender: TObject);
var i: Integer;
    x: Real;
begin
  if MessageDlg('Remover Sub-Divisão ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
     i := GetIndex(Grid.Cells[0, Grid.Row], FPizza);

     Dec(Linhas);
     If Linhas > 0 Then
        Grid.RemoveRows(Grid.Row, 1)
     Else
        Begin
        Grid.Clear(False);
        btnRemover.Enabled := False;
        btnEditar .Enabled := False;
        End;

     if i > 0 then
        begin
        FPizza.Delete(i);
        FList.Delete(i-1);

        if FPizza.Count = 1 then
           FPizza.Delete(0)
        else
           begin
           RecalcularAreaRestante;
           CalcularCN_Medio;
           end;
        end;
     end;
end;

procedure TfoPrincipal.CalcularCN_Medio;
var i: Integer;
    d: TDados;
    x: Real;
begin
  x := 0;
  for i := 0 to FList.Count-1 do
    begin
    d := TDados(FList[i]);
    x := x + d.CN * d.Perc/100;
    end;

  rbAMC_I.Caption   := FormatFloat('0.00', Interpol(x, cVM, cAMC_I));
  rbAMC_II.Caption  := FormatFloat('0.00', x);
  rbAMC_III.Caption := FormatFloat('0.00', Interpol(x, cVM, cAMC_III));
end;

procedure TfoPrincipal.btnEditarClick(Sender: TObject);
var i: Integer;
    d: TDados;
    x, Perc: Real;
    s: String;
begin
  i := GetIndex(Grid.Cells[0, Grid.Row], FPizza);
  if i > 0 then
     begin
     d := TDados(FList[i-1]);

     s := d.Titulo;

     FDados.edTit.Text     := d.Titulo;
     FDados.edPerc.AsFloat := d.Perc;
     FDados.cbTB.ItemIndex := d.TB;   FDados.cbTBChange(nil);
     FDados.cbUS.ItemIndex := d.US;   FDados.cbUSChange(nil);
     FDados.cbS.ItemIndex  := d.Sup;  FDados.cbSChange(nil);
     FDados.cbTS.ItemIndex := d.TS;   FDados.cbTSChange(nil);
     FDados.edCN.AsInteger := d.CN;

     If FDados.ShowModal = mrOk Then
        begin
        Perc := d.Perc;
        d.Perc := FDados.edPerc.AsFloat;

        // Verifica se o novo valor de porcentagem não excedeu o limite de 100%
        x := ObterSomatorio;
        if x > 100 then
           begin
           d.Perc := Perc;
           raise Exception.Create('A porcentagem corrente de área excede 100%');
           end
        else
           begin
           //FPizza.YValues.Value[0] := 100 - x;
           //FPizza.XLabel[0] := Format('Área Restante: %f %%', [100 - x]);
           end;

        if s <> FDados.edTit.Text then
           begin
           AjustarNomeDaSubDivisao;
           d.Titulo := FDados.edTit.Text;
           end;

        d.TB     := FDados.cbTB.ItemIndex;
        d.US     := FDados.cbUS.ItemIndex;
        d.Sup    := FDados.cbS.ItemIndex;
        d.TS     := FDados.cbTS.ItemIndex;
        d.CN     := FDados.edCN.AsInteger;

        Grid.Cells[0, Grid.Row] := FDados.edTit.Text;
        Grid.Cells[1, Grid.Row] := FDados.edPerc.AsString;
        Grid.Cells[2, Grid.Row] := FDados.edCN.AsString;

        FPizza.YValues.Value[i] := d.Perc;
        FPizza.xLabel[i] := FDados.edTit.Text + ' (CN: ' + FDados.edCN.AsString + ')';

        CalcularCN_Medio;
        RecalcularAreaRestante;
        //FPizza.Repaint;
        end;
     end;
end;

function TfoPrincipal.ObterSomatorio: Real;
var i: Integer;
begin
  Result := 0;
  for i := 0 to FList.Count-1 do
    Result := Result + TDados(FList[i]).Perc;
end;

procedure TfoPrincipal.AjustarNomeDaSubDivisao;
var i: Integer;
    s: String;

    function NomeJaExiste(const Nome: String): Boolean;
    var i: Integer;
    begin
      Result := False;
      for i := 0 to FList.Count-1 do
        if CompareText(Nome, TDados(FList[i]).Titulo) = 0 then
           begin
           Result := True;
           Break;
           end;
    end;

begin
  i := 2;
  s := FDados.edTit.Text;
  while NomeJaExiste(s) do
    begin
    s := 'SubDiv ' + IntToStr(i);
    inc(i);
    end;
  FDados.edTit.Text := s;  
end;

function TfoPrincipal.GetCN_Medio: Real;
begin
  if rbAMC_I.Checked   then Result := StrToFloatDef(rbAMC_I.Caption, -1) else
  if rbAMC_II.Checked  then Result := StrToFloatDef(rbAMC_II.Caption, -1) else
  if rbAMC_III.Checked then Result := StrToFloatDef(rbAMC_III.Caption, -1);
end;

procedure TfoPrincipal.ActLimparExecute(Sender: TObject);
begin
  FList.Clear;
  FPizza.Clear;
  FPizza.AddPie(0, 'Área Restante', clBlack);

  Grid.Clear(False);
  Grid.RowCount := 2;
  Linhas := 0;

  rbAMC_I.Caption := 'Não Calculado';
  rbAMC_II.Caption := 'Não Calculado';
  rbAMC_III.Caption := 'Não Calculado';

  btnRemover.Enabled := False;
  btnEditar .Enabled := False;
end;

procedure TfoPrincipal.ActAbrirExecute(Sender: TObject);
var
  I        : integer;
  Rest     : real;
  Dados    : TDados;
  IniCN    : TMemIniFile;
  Sections : TStrings;
begin
  if ODIni.Execute then
     begin
     Rest := 0;
     IniCN := TMemIniFile.Create(ODIni.FileName);
     Sections := TStringList.Create;

     ActLimparExecute(nil);
     IniCN.ReadSections(Sections);
{
     for I := 0 to Sections.Count - 1 do
         Rest := Rest + IniCN.ReadFloat(Sections[I],CIniDados[1],0);
     Rest := 100 - Rest;
     FPizza.AddPie(Rest, FloatToStr(Rest), clTeeColor);
}
     Linhas := Sections.Count;
     Grid.RowCount := Sections.Count + 1;
     btnEditar.Enabled := Grid.RowCount > 1;
     btnRemover.Enabled := btnEditar.Enabled;

     for I := 0 to Sections.Count - 1 do
       begin
       Dados := TDados.Create;
       Dados.LoadFromFile(ODIni.FileName,Sections[I]);

       Grid.Cells[0, I+1] := Dados.Titulo;
       Grid.Cells[1, I+1] := FloatToStr(Dados.Perc);
       Grid.Cells[2, I+1] := IntToStr(Dados.CN);

       FList.Add(Dados);

       FPizza.AddPie(Dados.Perc, Dados.Titulo + ' (CN: ' + FloatToStr(Dados.CN) + ')', clTeeColor);
       CalcularCN_Medio;

       FDados.cbTBChange(nil);
       end;

     RecalcularAreaRestante;

     IniCN.Free;
     Sections.Free;
     end;
end;

procedure TfoPrincipal.ActSalvarExecute(Sender: TObject);
var
  I : integer;
begin
  if SDIni.Execute then
     for I := 0 to FList.Count - 1 do
       TDados(FList[I]).SaveToFile(SDIni.FileName);
end;

procedure TfoPrincipal.btnOKClick(Sender: TObject);
begin
  if FValidar and (ObterSomatorio < 100) then
     if MessageDLG('O somatório das áreas não fecha em 100 %'#13 +
                   'Termina o programa mesmo assim ?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Close
     else
        // nada   
  else
     Close;
end;

procedure TfoPrincipal.FormShow(Sender: TObject);
begin
  if FValidar then
     btnOK.Caption := 'Fim'
  else
     btnOK.Caption := 'Fechar';
end;

procedure TfoPrincipal.RecalcularAreaRestante;
var x: Real;
begin
  if Linhas > 0 then
     begin
     x := ObterSomatorio;
     FPizza.YValues.Value[0] := 100 - x;
     FPizza.XLabel[0] := Format('Área Restante: %f %%', [100 - x]);
     end;
end;

procedure TfoPrincipal.AclSairExecute(Sender: TObject);
begin
  Close;
end;

end.

unit pr_Dialogo_Intervalos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, pr_Classes, drEdit, Mask;
  
type
  TprDialogo_Intervalos = class(TForm)
    Label1: TLabel;
    lbInts: TListBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edDI: TMaskEdit;
    Label3: TLabel;
    edDF: TMaskEdit;
    btnAdicionarData: TButton;
    Label4: TLabel;
    edNomeData: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edIntIni: TdrEdit;
    edIntFim: TdrEdit;
    btnAdicionarInt: TButton;
    edNomeInt: TEdit;
    btnOk: TButton;
    btnCancelar: TButton;
    Button2: TButton;
    Button3: TButton;
    btnHabilitar: TButton;
    procedure btnAdicionarIntClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure lbIntsClick(Sender: TObject);
    procedure btnAdicionarDataClick(Sender: TObject);
    procedure btnAdicionarMasesClick(Sender: TObject);
    procedure lbIntsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FProjeto: TprProjeto;
    procedure Obtem(i: Integer; out ini, fim: Integer; out s: String; out b: Boolean);
  public
    property Projeto: TprProjeto read FProjeto write FProjeto;
  end;

implementation
uses stDate, pr_Const,
     SysUtilsEx,
     WinUtils,
     Lists;

{$R *.DFM}

procedure TprDialogo_Intervalos.btnAdicionarIntClick(Sender: TObject);
var s, s2: String;
    ini, fim: Integer;
begin
  ini := edIntIni.AsInteger;
  fim := edIntFim.AsInteger;

  if (fim < ini) or (ini < 1) or (fim > FProjeto.Total_IntSim) then
     Raise Exception.Create('Erro na definição dos dados');

  if (TComponent(Sender).Tag = 0) or (btnHabilitar.Caption[2] = 'A') then
     begin
     s2 := 'ATIVADO';
     btnHabilitar.Caption := '&Desativar intervalo';
     end
  else
     begin
     s2 := 'DESATIVADO';
     btnHabilitar.Caption := '&Ativar intervalo';
     end;

  s := IntervaloToStrData(Fprojeto, ini) + ' - ' + IntervaloToStrData(Fprojeto, Fim);
  s := s + Format(' (%d - %d) - [%s] - <%s>', [ini, fim, edNomeInt.Text, s2]);

  if TComponent(Sender).Tag = 0 then
     lbInts.Items.Add(s)
  else
     if lbInts.ItemIndex > -1 then
        lbInts.Items[lbInts.ItemIndex] := s;
end;

procedure TprDialogo_Intervalos.FormShow(Sender: TObject);
var i: Integer;
    s: String;
begin
  for i := 0 to FProjeto.Intervalos.NumInts-1 do
    begin
    if FProjeto.Intervalos.Habilitado[i] then s := 'ATIVADO' else s := 'DESATIVADO';
    lbInts.Items.Add(Format('%s - %s (%d - %d) - [%s] - <%s>',
      [FProjeto.Intervalos.sDataIni[i],
       FProjeto.Intervalos.sDataFim[i],
       FProjeto.Intervalos.IntIni[i],
       FProjeto.Intervalos.IntFim[i],
       FProjeto.Intervalos.Nome[i],
       s]));
    end;
end;

procedure TprDialogo_Intervalos.btnOkClick(Sender: TObject);
var ini, fim, i: Integer;
    s: String;
    b: Boolean;
begin
  with FProjeto.Intervalos do
    begin
    Limpar;
    for i := 0 to lbInts.Items.Count-1 do
      begin
      Obtem(i, ini, fim, s, b);
      Adicionar(ini, fim, s, b);
      end;
    end;
  ModalResult := mrOk;
end;

procedure TprDialogo_Intervalos.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TprDialogo_Intervalos.Obtem(i: Integer; out ini, fim: Integer; out s: String; out b: Boolean);
var s1, s2: String;
begin
  s := SubString(lbInts.Items[i], '(', ')');
  SubStrings('-', s1, s2, s, true);
  ini := strToInt(s1);
  fim := strToInt(s2);
  s   := SubString(lbInts.Items[i], '[', ']');
  b   := (SubString(lbInts.Items[i], '<', '>') = 'ATIVADO');
end;

procedure TprDialogo_Intervalos.lbIntsClick(Sender: TObject);
var ini, fim: Integer;
    s: String;
    b: Boolean;
begin
  Obtem(lbInts.ItemIndex, ini, fim, s, b);

  edIntIni.AsInteger := ini;
  edIntFim.AsInteger := fim;

  edDI.Text := IntervaloToStrData(FProjeto, ini);
  edDF.Text := IntervaloToStrData(FProjeto, fim);

  edNomeInt.Text := s;
  edNomeData.Text := s;

  btnHabilitar.Visible := (lbInts.ItemIndex > -1);
  if b then
     btnHabilitar.Caption := '&Desativar intervalo'
  else
     btnHabilitar.Caption := '&Ativar intervalo';
end;

procedure TprDialogo_Intervalos.btnAdicionarDataClick(Sender: TObject);
var s, s1, s2: String;
    di, df: TDate;
    mes, ano: Integer;
    LI: TIntegerList;
begin
  di  := StrToDate('01/' + edDI.Text);
  SubStrings('/', s1, s2, edDF.Text, true);
  mes := strToInt(s1);
  Ano := strToInt(s2);
  df  := StrToDate('01/' + edDF.Text) + DaysInMonth(Mes, Ano, Ano);

  LI := IntervalosDo(FProjeto, di, df);

  if LI.Count > 0 then
     begin
     if (TComponent(Sender).Tag = 0) or (btnHabilitar.Caption[2] = 'A') then
        s2 := 'ATIVADO'
     else
        s2 := 'DESATIVADO';

     s := IntervaloToStrData(Fprojeto, LI[0]) + ' - ' + IntervaloToStrData(Fprojeto, LI[LI.Count-1]);
     s := s + Format(' (%d - %d) - [%s] - <%s>', [LI[0], LI[LI.Count-1], edNomeData.Text, s2]);

     if TComponent(Sender).Tag = 0 then
        lbInts.Items.Add(s)
     else
        if lbInts.ItemIndex > -1 then
           lbInts.Items[lbInts.ItemIndex] := s;
     end
  else
     MessageDLG('Erro na definição dos Dados', mtError, [mbOK], 0);

  LI.Free;
end;

procedure TprDialogo_Intervalos.btnAdicionarMasesClick(Sender: TObject);
begin
  ShowMessage('Ainda não implementado');
end;

procedure TprDialogo_Intervalos.lbIntsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if lbInts.ItemIndex > -1 then
     begin
     DeleteElemFromList(lbInts, Key);
     Clear([edDI, edDF, edNomeData, edIntIni, edIntFim, edNomeInt]);
     end;
  btnHabilitar.Visible := lbInts.Items.Count > 0;
end;

end.

unit CriarPosto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CH_Const, ch_Tipos, wsAvaliadorDeExpressoes,
  wsTabeladeSimbolos, FramePeriodosValidos;

type
  TDLG_CriarPosto = class(TForm)
    PV: TFrame_PeriodosValidos;
    Label3: TLabel;
    edExpressao: TEdit;
    Label4: TLabel;
    lbExpressoes: TListBox;
    Label1: TLabel;
    cbPostoBase: TComboBox;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    btnAdicionar: TButton;
    btnRemover: TButton;
    btnModificar: TButton;
    Save: TSaveDialog;
    btnAP: TButton;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure lbExpressoesClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FEval: TAvaliator;
    Finfo: TDSInfo;
    function ObtemDados: String;
    procedure ValidarExpressao;
    procedure ValidarIntervalos;
    procedure Calcular(const Com: String);
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses SysUtilsEx, WinUtils, ch_Procs;

{$R *.DFM}

constructor TDLG_CriarPosto.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

function TDLG_CriarPosto.ObtemDados: String;
begin
  PV.ValidarDatas;
  ValidarIntervalos;
  ValidarExpressao;
  Result := '(' + PV.IntervaloComoString + ') = ' + edExpressao.Text;
end;

procedure TDLG_CriarPosto.btnAdicionarClick(Sender: TObject);
var s: String;
begin
  s := ObtemDados;
  if lbExpressoes.Items.IndexOf(s) = -1 then
     lbExpressoes.Items.Add(s);
end;

procedure TDLG_CriarPosto.btnModificarClick(Sender: TObject);
var s: String;
begin
  s := ObtemDados;
  lbExpressoes.Items[lbExpressoes.ItemIndex] := s;
end;

procedure TDLG_CriarPosto.btnRemoverClick(Sender: TObject);
begin
  DeleteElemFromList(lbExpressoes, VK_DELETE);
end;

procedure TDLG_CriarPosto.lbExpressoesClick(Sender: TObject);
var s, s1, s2: String;
begin
  s := lbExpressoes.Items[lbExpressoes.ItemIndex];
  getInfo('=', s1, s2, s);
  PV.IntervaloComoString := getSubString(s1, '(', ')');
  edExpressao.Text := AllTrim(s2);
end;

procedure TDLG_CriarPosto.Calcular(const Com: String);
var s, s1, s2, s3: String;
    LI, LF, k, i: Integer;
    x: TNumericVar;
    D: TDateTime;
    Posto: String;
begin
  getInfo('=', s1, s2, Com);
  s := AllTrim(s2);
  getInfo('-', s2, s3, getSubString(s1, '(', ')'));
  s1 := AllTrim(s2);
  s2 := AllTrim(s3);
  Posto := cbPostoBase.Items[cbPostoBase.ItemIndex];

  FEval.Expression := s;
  LI := Finfo.IndiceDaData(s1);
  LF := Finfo.IndiceDaData(s2);
  k := FInfo.DS.Struct.IndexOf(GetValidID(Posto));
  x := TNumericVar(FEval.TabVar.VarByName('x'));

  //FInfo.DS

  for i := LI to LF do
    begin
    D := FInfo.DataBase + i - 1;
    x.Value := FInfo.DS[i, k];
    //T.AppendRecord([Posto, D, FEval.Evaluate.AsFloat]);
    end;
end;

procedure TDLG_CriarPosto.btnOkClick(Sender: TObject);
var Erro: String;
    i: Integer;
begin
  if cbPostoBase.ItemIndex = -1 then
     ShowErrorAndGoto(['Selecione um posto base'], cbPostoBase);
  try
    StartWait;
    setEnable([btnOk, btnCancel], False);
    for i := 0 to lbExpressoes.Items.Count-1 do
      Calcular(lbExpressoes.Items[i], T);
  finally
    T.Free;
    StopWait;
    setEnable([btnOk, btnCancel], True);
  end
end;

procedure TDLG_CriarPosto.FormShow(Sender: TObject);
begin
  PV.Mostrar(FInfo);
  cbPostoBase.Items.Assign(FInfo.Postos);
  FEval := TAvaliator.Create;
  FEval.TabVar.AddFloat('x', 0);
end;

procedure TDLG_CriarPosto.ValidarExpressao;
begin
  if AllTrim(edExpressao.Text) = '' then
     ShowErrorAndGoto(['Digite a Expressão'], edExpressao);

  try
    FEval.Expression := edExpressao.Text;
  except
    on E: Exception do
       ShowErrorAndGoto([E.Message], edExpressao);
  end;
end;

procedure TDLG_CriarPosto.FormDestroy(Sender: TObject);
begin
  FEval.Free;
end;

procedure TDLG_CriarPosto.ValidarIntervalos;
var i: Integer;
    s1, s2: String;
    d1, d2, DI, DF: TDateTime;
begin
  PV.ObtemDatas(DI, DF);
  for i := 0 to lbExpressoes.Items.Count-1 do
    begin
    getInfo('-', s1, s2, getSubString(lbExpressoes.Items[i], '(', ')'));
    d1 := StrToDate(AllTrim(s1));
    d2 := StrToDate(AllTrim(s2));
    if ((DI >= d1) and (DI <= d2)) or ((DF >= d1) and (DF <= d2)) then
       ShowErrorAndGoto(['Não pode haver intersecção de intervalos'], PV.meDI);
    end;
end;

procedure TDLG_CriarPosto.btnAPClick(Sender: TObject);
var i: Integer;
begin
  lbExpressoes.Clear;
  for i := 0 to PV.lbPeriodos.Items.Count-1 do
    lbExpressoes.Items.Add('(' + PV.lbPeriodos.Items[i] + ') = x');
end;

procedure TDLG_CriarPosto.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.

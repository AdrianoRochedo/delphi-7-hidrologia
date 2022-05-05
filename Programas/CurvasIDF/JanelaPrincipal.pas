unit JanelaPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, ComCtrls, drEdit, Contnrs, Mask,
  psEditorBaseComp, psEditorComp, Frame_Planilha, drGraficos, psCore, Menus;

type
  TBase = class
  private
    FDirDados: String;
  public
    constructor Create;

    // Abre o arquivo específico
    function AbrirArquivo(const NomeArq: String): TIniFile;

    property DirDados : String read FDirDados;
  end;

  TEquacao = class(TBase)
  private
    FNome: String;
    FComentario: String;
    FCodigo: String;
  public
    // Cria e inicializa os valores dos campos
    constructor Create(const Nome, Comentario, Codigo: String; Registrar: Boolean);

    // Atualiza os valores dos campos internos e no arquivo
    procedure Atualizar(const Nome, Comentario, Codigo: String; Registrar: Boolean);

    // Remove qualquer referência a esta equação, tanto em memória quanto em arquivo
    // Realiza um auto-free.
    procedure Remover;

    property Nome       : String read FNome;
    property Comentario : String read FComentario;
    property Codigo     : String read FCodigo;
  end;

  TEquacoes = array of String;
  TParametros = array of String;

  TLocalidade = class(TBase)
  private
    FLongitude: string;
    FNome: string;
    FComentario: string;
    FLatitude: string;
    FEquacoes: TEquacoes;
    FParametros: TParametros;
    FEstado: string;
    FTipo: string;
  public
    // Cria e inicializa os valores dos campos
    constructor Create(const Estado, Tipo, Nome, Comentario, Latitude, Longitude: String;
                       const Equacoes: TEquacoes; const Parametros: TParametros;
                       Registrar: Boolean);

    // Atualiza os valores dos campos internos e no arquivo
    procedure Atualizar(const Estado, Tipo, Nome, Comentario, Latitude, Longitude: String;
                        const Equacoes: TEquacoes; const Parametros: TParametros;
                        Registrar: Boolean);

    // Remove qualquer referência a esta equação, tanto em memória quanto em arquivo
    // Realiza um auto-free.
    procedure Remover;

    property Estado     : string      read FEstado;
    property Tipo       : string      read FTipo;
    property Nome       : string      read FNome;
    property Comentario : string      read FComentario;
    property Latitude   : string      read FLatitude;
    property Longitude  : string      read FLongitude;
    property Equacoes   : TEquacoes   read FEquacoes;
    property Parametros : TParametros read FParametros;
  end;

  TfoJP = class(TForm)
    Panel3: TPanel;
    Book: TPageControl;
    TabEQ: TTabSheet;
    Label7: TLabel;
    lbDE_Equacoes: TListBox;
    Save: TSaveDialog;
    TabEL: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Label15: TLabel;
    cbEstado: TComboBox;
    Arvore: TTreeView;
    Splitter1: TSplitter;
    Book2: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mmEL_Coment: TMemo;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    lbEL_ED: TListBox;
    edEL_Par: TLabeledEdit;
    btnAdicionarEQ_EL: TButton;
    btnRemoverEQ_EL: TButton;
    cbEL_Eq: TComboBox;
    btnAtualizarEQ_EL: TButton;
    btnAdicionarEL: TButton;
    btnRemoverEL: TButton;
    btnAtualizarEL: TButton;
    edEL_Lat: TMaskEdit;
    edEL_Lon: TMaskEdit;
    edEL_Nome: TEdit;
    Label9: TLabel;
    Label14: TLabel;
    cbC_Eq: TComboBox;
    BookCalculos: TPageControl;
    TabPlanilha: TTabSheet;
    paInt: TFramePlanilha;
    Panel4: TPanel;
    TabGrafico: TTabSheet;
    TabDesag: TTabSheet;
    paALA: TFramePlanilha;
    Panel5: TPanel;
    TabAcum: TTabSheet;
    paALD: TFramePlanilha;
    Panel6: TPanel;
    gbDur: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edC_DurIni: TdrEdit;
    edC_DurFim: TdrEdit;
    edC_DurInc: TdrEdit;
    mC_Tr: TMemo;
    btnC_Calcular: TButton;
    edC_Par: TLabeledEdit;
    btnC_Salvar: TButton;
    GroupBox1: TGroupBox;
    btnAdicionarEq: TButton;
    btnAtualizarEq: TButton;
    btnRemoverEq: TButton;
    Label11: TLabel;
    Label2: TLabel;
    edDE_Nome: TLabeledEdit;
    mmDE_Coment: TMemo;
    psDE_Codigo: TScriptPascalEditor;
    Panel7: TPanel;
    Label16: TLabel;
    imEQ: TImage;
    procedure ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure btnAdicionarEqClick(Sender: TObject);
    procedure btnAtualizarEqClick(Sender: TObject);
    procedure btnRemoverEqClick(Sender: TObject);
    procedure GlobalEditExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarELClick(Sender: TObject);
    procedure btnAtualizarELClick(Sender: TObject);
    procedure btnRemoverELClick(Sender: TObject);
    procedure btnAdicionarEQ_ELClick(Sender: TObject);
    procedure btnRemoverEQ_ELClick(Sender: TObject);
    procedure cbEstadoChange(Sender: TObject);
    procedure ArvoreClick(Sender: TObject);
    procedure lbEL_EDClick(Sender: TObject);
    procedure cbC_EqChange(Sender: TObject);
    procedure btnC_CalcularClick(Sender: TObject);
    procedure btnAtualizarEQ_ELClick(Sender: TObject);
    procedure btnC_SalvarClick(Sender: TObject);
    procedure TabSelChange(Sender: TObject);
    procedure BookChange(Sender: TObject);
    procedure Book2Change(Sender: TObject);
    procedure lbDE_EquacoesClick(Sender: TObject);
  private
    FnoEst, FnoLoc: TTreeNode;
    FDirApp: String;
    G: TgrGrafico;
    procedure ValorCalculado(L, C: Integer; const Intensidade, Duracao: Real);
    procedure DeclararVariaveis(Script: TPascalScript);
    procedure Calcular(Script: TPascalScript);
    procedure InicializarPlanilhas;
    procedure Plotar;
    procedure ObterEquacoes(var Eqs: TEquacoes; var Pars: TParametros);
    procedure LimparCamposDasLocalidades;
    procedure LimparCamposDasEquacoes;
    procedure LimparSubCamposDasEquacoes;
  public
    { Public declarations }
  end;

var
  foJP: TfoJP;

implementation
uses SysUtilsEx,
     TreeViewUtils,
     WinUtils,
     Lib_Math,
     psBase,
     Series,
     vcf1;

{$R *.dfm}

const
  cRegGeral = 'Não se esqueça de atualizar o Registro Geral'#13 +
              'Através do botão "Atualizar E/L"';

{ TBase }

function TBase.AbrirArquivo(const NomeArq: String): TIniFile;
begin
  Result := TIniFile.Create(FDirDados + NomeArq + '.dat');
end;

constructor TBase.Create;
begin
  inherited Create;
  FDirDados := ExtractFilePath(Application.ExeName) + 'Dados IDF\';
end;

{ TEquacao }

constructor TEquacao.Create(const Nome, Comentario, Codigo: String; Registrar: Boolean);
begin
  inherited Create;
  Atualizar(Nome, Comentario, Codigo, Registrar);
end;

procedure TEquacao.Atualizar(const Nome, Comentario, Codigo: String; Registrar: Boolean);
var ini: TIniFile;
begin
  FNome := Nome;
  FComentario := Comentario;
  FCodigo := Codigo;

  // Cria o registro em arquivo
  if Registrar then
     begin
     ini := AbrirArquivo('Equacoes');
     ini.WriteString(FNome, 'Nome', FNome);
     ini.WriteString(FNome, 'Comentario', MultiLineToLine(FComentario));
     ini.WriteString(FNome, 'Codigo', MultiLineToLine(FCodigo));
     ini.Free;
     end;
end;

procedure TEquacao.Remover;
var ini: TIniFile;
begin
  // Remove o registro do arquivo
  ini := AbrirArquivo('Equacoes');
  ini.EraseSection(FNome);
  ini.Free;

  Free;
end;

{ TLocalidade }

procedure TLocalidade.Atualizar(const Estado, Tipo, Nome, Comentario, Latitude, Longitude: String;
                                const Equacoes: TEquacoes;
                                const Parametros: TParametros;
                                Registrar: Boolean);
var ini: TIniFile;
    s: String;
    i: Integer;
begin
  FEstado     := Estado;
  FTipo       := Tipo;
  FNome       := Nome;
  FComentario := Comentario;
  FLatitude   := Latitude;
  FLongitude  := Longitude;
  FEquacoes   := Equacoes;
  FParametros := Parametros;

  // Cria o registro em arquivo
  if Registrar then
     begin
     s := FTipo + ' ' + FNome;
     ini := AbrirArquivo(FEstado);

     ini.WriteString(s, 'Nome', FNome);
     ini.WriteString(s, 'Comentario', MultiLineToLine(FComentario));
     ini.WriteString(s, 'Latitude', FLatitude);
     ini.WriteString(s, 'Longitude', FLongitude);

     // Equacoes
     ini.WriteInteger(s, 'Equacoes', Length(FEquacoes));
     for i := 1 to Length(FEquacoes) do
       ini.WriteString(s, 'Equacao' + IntToStr(i), FEquacoes[i-1]);

     // Parametros
     for i := 1 to Length(FEquacoes) do
       ini.WriteString(s, 'Parametros' + IntToStr(i), FParametros[i-1]);

     ini.Free;
     end;
end;

constructor TLocalidade.Create(const Estado, Tipo, Nome, Comentario, Latitude, Longitude: String;
                               const Equacoes: TEquacoes;
                               const Parametros: TParametros;
                               Registrar: Boolean);
begin
  inherited Create;
  Atualizar(Estado, Tipo, Nome, Comentario, Latitude, Longitude,
            Equacoes, Parametros, Registrar);
end;

procedure TLocalidade.Remover;
var ini: TIniFile;
begin
  // Remove o registro do arquivo
  ini := AbrirArquivo(FEstado);
  ini.EraseSection(FTipo + ' ' + FNome);
  ini.Free;

  Free;
end;

{ TfoJP }

procedure TfoJP.ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := (Node.Data <> nil) or (Node.Level = 1);
end;

// Controle das Equações ****************************************

procedure TfoJP.btnAdicionarEqClick(Sender: TObject);
var e: TEquacao;
begin
  if lbDE_Equacoes.Items.IndexOf(edDE_Nome.Text) > -1 then
     raise Exception.Create('Equação já cadastrada');

  e := TEquacao.Create(edDE_Nome.Text,
                       mmDE_Coment.Lines.Text,
                       psDE_Codigo.Lines.Text,
                       True);

  lbDE_Equacoes.Items.AddObject(edDE_Nome.Text, e);
  cbEL_Eq.Items.Add(edDE_Nome.Text);
end;

procedure TfoJP.btnAtualizarEqClick(Sender: TObject);
var e: TEquacao;
    i: Integer;
begin
  if lbDE_Equacoes.ItemIndex > -1 then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        i := lbDE_Equacoes.ItemIndex;
        lbDE_Equacoes.Items[i] := edDE_Nome.Text;
        e := TEquacao(lbDE_Equacoes.Items.Objects[i]);

        // Atualiza as referencias a esta equacao
        i := cbEL_Eq.Items.IndexOf(e.Nome);
        if i > -1 then cbEL_Eq.Items[i] := edDE_Nome.Text;

        e.Atualizar(edDE_Nome.Text, mmDE_Coment.Lines.Text, psDE_Codigo.Lines.Text, True);
        end;
end;

procedure TfoJP.btnRemoverEqClick(Sender: TObject);
var e: TEquacao;
begin
  if lbDE_Equacoes.ItemIndex > -1 then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        e := TEquacao(lbDE_Equacoes.Items.Objects[lbDE_Equacoes.ItemIndex]);
        e.Remover; // auto free
        lbDE_Equacoes.Items.Delete(lbDE_Equacoes.ItemIndex);
        cbEL_Eq.Items.Delete(lbDE_Equacoes.ItemIndex);
        LimparCamposDasEquacoes;
        end;
end;

procedure TfoJP.lbDE_EquacoesClick(Sender: TObject);
var e: TEquacao;
begin
  if lbDE_Equacoes.ItemIndex > -1 then
     begin
     e := TEquacao(lbDE_Equacoes.Items.Objects[lbDE_Equacoes.ItemIndex]);
     edDE_Nome.Text := e.Nome;
     psDE_Codigo.Lines.Text := e.Codigo;
     mmDE_Coment.Lines.Text := e.Comentario;
     end;
end;

// Controle das Equações ****************************************

procedure TfoJP.GlobalEditExit(Sender: TObject);
begin
  TEdit(Sender).Text := AllTrim(TEdit(Sender).Text);
end;

procedure TfoJP.FormCreate(Sender: TObject);
var ini: TIniFile;
    SL: TStrings;
    i: Integer;
    s: String;
    e: TEquacao;
begin
  Book.ActivePageIndex := 1;
  BookCalculos.ActivePageIndex := 0;

  FDirApp := ExtractFilePath(Application.ExeName);
  SL := TStringList.Create;

  cbEstado.Items.LoadFromFile(FDirApp + 'Dados IDF\Estados.dat');

  // Carrega todas as equacoes
  lbDE_Equacoes.Clear;
  ini := TIniFile.Create(FDirApp + 'Dados IDF\Equacoes.dat');
  ini.ReadSections(SL);
  for i := 0 to SL.Count-1 do
    begin
    s := SL[i];
    e := TEquacao.Create(s,
           LineToMultiLine(ini.ReadString(s, 'Comentario', '')),
           LineToMultiLine(ini.ReadString(s, 'Codigo', '')),
           False);
    lbDE_Equacoes.AddItem(s, e);
    cbEL_Eq.Items.Add(s);
    end;
  ini.Free;
  SL.Free;

  // Gráfico ...
  G := TgrGrafico.Create;
  G.Align := alClient;
  G.Parent := TabGrafico;
  G.BorderStyle := bsNone;
  G.Grafico.View3D := False;
  G.Grafico.LeftAxis.Logarithmic := True;
  G.Grafico.LeftAxis.Title.Caption := 'Intensidade';
  G.Grafico.BottomAxis.Title.Caption := 'Duração';
  G.Show;
end;

// Controle das Estacoes e Localidades *****************************

procedure TfoJP.ObterEquacoes(var Eqs: TEquacoes; var Pars: TParametros);
var i: Integer;
    s1, s2: String;
begin
  SetLength(Eqs, lbEL_ED.Items.Count);
  SetLength(Pars, lbEL_ED.Items.Count);

  for i := 0 to lbEL_ED.Items.Count-1 do
    begin
    SubStrings('|', s1, s2, lbEL_ED.Items[i]);
    Eqs[i] := AllTrim(s1);
    Pars[i] := AllTrim(s2);
    end;
end;

procedure TfoJP.btnAdicionarELClick(Sender: TObject);
var L: TLocalidade;
    no: TTreeNode;
    Tipo: String;
    Eqs: TEquacoes;
    Pars: TParametros;

    procedure Validar;
    var i: Integer;
    begin
      if allTrim(edEL_Nome.Text) = '' then
         raise Exception.Create('Nome da ' + Tipo + ' não pode ser vazio');

      for i := 0 to no.Count-1 do
        if CompareText(no.Item[i].Text, edEL_Nome.Text) = 0 then
           raise Exception.Create(Tipo + ' já Cadastrada');
    end;

begin
  no := Arvore.Selected;

  if (no = nil) or (no.Level <> 1) then
     raise Exception.Create('Primeiro selecione um nó Estação ou'#13 +
                            'um nó Localidade em um estado')
  else
     begin
     ObterEquacoes(Eqs, Pars);
     if no = FnoEst then Tipo := 'Estacao' else Tipo := 'Localidade';
     Validar;

     L := TLocalidade.Create(cbEstado.Text,
                             Tipo,
                             edEL_Nome.Text,
                             mmEL_Coment.Text,
                             edEL_Lat.Text,
                             edEL_Lon.Text,
                             Eqs,
                             Pars,
                             True);
     Arvore.Items.AddChildObject(no, edEL_Nome.Text, L);
     end
end;

procedure TfoJP.btnAtualizarELClick(Sender: TObject);
var L: TLocalidade;
    no: TTreeNode;
    Tipo: String;
    Eqs: TEquacoes;
    Pars: TParametros;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.Level = 2) then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        ObterEquacoes(Eqs, Pars);
        if no.Text = 'Estações' then Tipo := 'Estacao' else Tipo := 'Localidade';
        L := TLocalidade(no.Data);
        L.Atualizar(cbEstado.Text,
                    Tipo,
                    edEL_Nome.Text,
                    mmEL_Coment.Text,
                    edEL_Lat.Text,
                    edEL_Lon.Text,
                    Eqs,
                    Pars,
                    True);
        end;
end;

procedure TfoJP.btnRemoverELClick(Sender: TObject);
var L: TLocalidade;
    no: TTreeNode;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.Level = 2) then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        L := no.Data;
        L.Remover(); // auto free
        no.Delete();
        LimparCamposDasLocalidades();
        end;
end;

procedure TfoJP.btnAdicionarEQ_ELClick(Sender: TObject);
var s: String;

    procedure Validar;
    var i: Integer;
        s2: String;
    begin
      if cbEL_Eq.Text = '' then
         raise Exception.Create('Escolha uma Equação');

      if edEL_Par.Text = '' then
         raise Exception.Create('Equação sem parâmetros');

      for i := 0 to lbEL_ED.Items.Count-1 do
        begin
        s2 := lbEL_ED.Items[i];
        s2 := Copy(s2, 1, System.Pos('|', s2)-2);
        if cbEL_Eq.Text = s2 then
           raise Exception.Create('Equacao já escolhida');
        end;
    end;

begin
  Validar;
  lbEL_ED.Items.Add(cbEL_Eq.Text + ' | ' + edEL_Par.Text);
  MessageDLG(cRegGeral, mtInformation, [mbOk], 0);
end;

procedure TfoJP.btnAtualizarEQ_ELClick(Sender: TObject);
begin
  if lbEL_ED.ItemIndex > -1 then
     begin
     lbEL_ED.Items[lbEL_ED.ItemIndex] := cbEL_Eq.Text + ' | ' + edEL_Par.Text;
     MessageDLG(cRegGeral, mtInformation, [mbOk], 0);
     end;
end;

procedure TfoJP.btnRemoverEQ_ELClick(Sender: TObject);
begin
  if lbEL_ED.ItemIndex > -1 then
     begin
     lbEL_ED.Items.Delete(lbEL_ED.ItemIndex);
     LimparSubCamposDasEquacoes();
     MessageDLG(cRegGeral, mtInformation, [mbOk], 0);
     end;
end;

// Controle das Estacoes e Localidades *****************************

procedure TfoJP.cbEstadoChange(Sender: TObject);
var no: TTreeNode;
    ini: TIniFile;
    SL: TStrings;
    i: Integer;
    s, s1, s2: String;
    L: TLocalidade;
    Eqs: TEquacoes;
    Pars: TParametros;

    procedure LerEquacoes;
    var i: Integer;
    begin
      i := ini.ReadInteger(s, 'Equacoes', 0);
      SetLength(Eqs, i);
      SetLength(Pars, i);
      for i := 1 to i do
        begin
        Eqs[i-1]  := ini.ReadString(s, 'Equacao' + IntToStr(i), '');
        Pars[i-1] := ini.ReadString(s, 'Parametros' + IntToStr(i), '');
        end;
    end;

begin
  TreeViewUtils.FreeNodes(Arvore.Items);
  no := Arvore.Items.AddChild(nil, cbEstado.Text);
  FnoEst := Arvore.Items.AddChild(no, 'Estações');
  FnoLoc := Arvore.Items.AddChild(no, 'Localidades');

  SL := TStringList.Create;

  // Carrega as localidades e estacoes
  ini := TIniFile.Create(FDirApp + 'Dados IDF\' + cbEstado.Text + '.dat');
  ini.ReadSections(SL);
  for i := 0 to SL.Count-1 do
    begin
    s := SL[i];
    SubStrings(' ', s1, s2, s);
    if s1 = 'Estacao' then no := FnoEst else no := FnoLoc;
    LerEquacoes;
    L := TLocalidade.Create(cbEstado.Text, s1, s2,
           LineToMultiLine(ini.ReadString(s, 'Comentario', '')),
           ini.ReadString(s, 'Latitude', ''),
           ini.ReadString(s, 'Longitude', ''),
           Eqs, Pars, False);
    Arvore.Items.AddChildObject(no, s2, L);
    end;
  ini.Free;

  SL.Free;

end;

procedure TfoJP.ArvoreClick(Sender: TObject);
var L: TLocalidade;
    no: TTreeNode;
    i: Integer;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.Level = 2) then
     begin
     L := no.Data;
     edEL_Nome.Text := L.Nome;
     mmEL_Coment.Lines.Text := L.Comentario;
     edEL_Lon.Text := L.Longitude;
     edEL_Lat.Text := L.Latitude;
     lbEL_ED.Clear;
     LimparSubCamposDasEquacoes;
     for i := 0 to High(L.Equacoes) do
       begin
       lbEL_ED.Items.Add(L.Equacoes[i] + ' | ' + L.Parametros[i]);
       cbC_Eq.AddItem(L.Equacoes[i], L);
       end;
     end;
end;

procedure TfoJP.lbEL_EDClick(Sender: TObject);
var s1, s2: String;
begin
  SubStrings('|', s1, s2, lbEL_ED.Items[lbEL_ED.ItemIndex]);
  cbEL_Eq.ItemIndex := cbEL_Eq.Items.IndexOf(AllTrim(s1));
  edEL_Par.Text := AllTrim(s2);
end;

procedure TfoJP.LimparCamposDasEquacoes;
begin
  WinUtils.Clear([edDE_Nome, psDE_Codigo, mmDE_Coment]);
end;

procedure TfoJP.LimparCamposDasLocalidades;
begin
  WinUtils.Clear([edEL_Nome, mmEL_Coment, edEL_Lon, edEL_Lat, lbEL_ED]);
  LimparSubCamposDasEquacoes;
end;

procedure TfoJP.LimparSubCamposDasEquacoes;
begin
  cbEL_Eq.ItemIndex := -1;
  WinUtils.Clear([edEL_Par, cbC_Eq, edC_Par]);
  imEQ.Visible := false;
end;

procedure TfoJP.cbC_EqChange(Sender: TObject);
var L: TLocalidade;
begin
  if cbC_Eq.ItemIndex > -1 then
     begin
     L := TLocalidade(cbC_Eq.Items.Objects[cbC_Eq.ItemIndex]);
     edC_Par.Text := L.Parametros[cbC_Eq.ItemIndex];
     imEQ.Visible := (CompareText(cbC_Eq.Text, 'Padrão') = 0);
     end
  else
     imEQ.Visible := false;
end;

procedure TfoJP.ValorCalculado(L, C: Integer; const Intensidade, Duracao: Real);

  procedure Write(p: TF1Book; const r: real);
  begin
    p.SetActiveCell(L, C);
    p.NumberFormat := '0' + DecimalSeparator + '00';
    p.Number := r;
  end;

var P: Real;
begin
  Write(paInt.Tab, Intensidade); // mm/h

  P := Intensidade * Duracao / 60;

  // Precipitação Acumulada (mm)
  Write(paALA.Tab, P);

  // Precipitação Desagregada (mm)
  if L = 3 then
     Write(paALD.Tab, P)
  else
     Write(paALD.Tab, P - paALA.Tab.NumberRC[L-1, C]);
end;

procedure TfoJP.Calcular(Script: TPascalScript);
var i, k, ini, fim, incr, anos, Row, Col: Integer;
    r: Real;
    Tr, Duracao, Result: TVariable;
begin
  ini  := edC_DurIni.AsInteger;
  fim  := edC_DurFim.AsInteger;
  incr := edC_DurInc.AsInteger;

  Tr      := Script.Variables.VarByName('Tr');
  Duracao := Script.Variables.VarByName('Duracao');
  Result  := Script.Variables.VarByName('Result');

  // permuta os anos
  Col := 2;
  for k := 0 to mC_Tr.Lines.Count-1 do
    begin
    Anos := StrToIntDef(mC_Tr.Lines[k], 0);
    Tr.Value := Anos;

    // permuta a duração
    Row := 3;
    i := ini;
    while i <= fim do
      begin
      Duracao.Value := i;
      Script.Execute;
      ValorCalculado(Row, Col, Result.Value, i);
      inc(i, incr);
      inc(Row);
      end;

    inc(Col);
    end;
end;

procedure TfoJP.btnC_CalcularClick(Sender: TObject);
var L: TLocalidade;
    e: TEquacao;
    Script: TPascalScript;
    i: Integer;

    procedure Obter_Localidade_Equacao;
    begin
      L := TLocalidade(cbC_Eq.Items.Objects[cbC_Eq.ItemIndex]);
      i := lbDE_Equacoes.Items.IndexOf(cbC_Eq.Text);
      if i = -1 then raise Exception.Create('Equação não cadastrada');
      lbDE_Equacoes.ItemIndex := i;
      e := TEquacao(lbDE_Equacoes.Items.Objects[i]);
    end;

begin
  if cbC_Eq.ItemIndex > -1 then
     begin
     Obter_Localidade_Equacao();

     WinUtils.StartWait();
     InicializarPlanilhas();
     Script := TPascalScript.Create();
     try
       Script.Include(Lib_Math.API);
       Script.Text.Add('begin');
       Script.Text.Add(e.Codigo);
       Script.Text.Add('end.');
       DeclararVariaveis(Script);
       if Script.Compile then
          begin
          Calcular(Script);
          Plotar();
          end
       else
          ShowMessage(Script.Errors.Text);
     finally
       WinUtils.StopWait();
       Script.Free;
       end;
     end;
end;

procedure TfoJP.InicializarPlanilhas;

   procedure InicializarPlanilha(p: TF1Book);
   var i, k, incr: Integer;
   begin
     p.ClearRange(1, 1, p.MaxRow, p.MaxCol, 1);

     for k := 0 to mC_Tr.Lines.Count-1 do
       begin
       p.SetActiveCell(1, k+2);
       p.SetFont('arial', 10, True, False, False, False, clBlack, False, False);
       p.Text := mC_Tr.Lines[k];
       end;

     i := 3;
     k := edC_DurIni.AsInteger;
     incr := edC_DurInc.AsInteger;
     while k <= edC_DurFim.AsInteger do
       begin
       p.SetActiveCell(i, 1);
       p.SetFont('arial', 10, True, False, False, False, clBlack, False, False);
       p.Text := IntToStr(k);
       inc(k, incr);
       inc(i);
       end;

     p.SetActiveCell(1, 1);
     p.ShowActiveCell;  
   end;

begin
  InicializarPlanilha(paInt.Tab);
  InicializarPlanilha(paALA.Tab);
  InicializarPlanilha(paALD.Tab);
end;

procedure TfoJP.DeclararVariaveis(Script: TPascalScript);
var SL: TStrings;
    i: Integer;
    r: Real;
    V: TVariable;

    function AjustaNumero(const s: String): String;
    begin
      if DecimalSeparator = '.' then
         Result := SysUtilsEx.ChangeChar(s, ',', '.')
      else
         Result := SysUtilsEx.ChangeChar(s, '.', ',')
    end;


begin
  // Declara a variáve Result
  V := TVariable.Create('Result', pvtReal, 0, nil, True);
  Script.Variables.AddVar(V);

  // Declara a variáve Duracao
  V := TVariable.Create('Duracao', pvtInteger, 0, nil, True);
  Script.Variables.AddVar(V);

  // Declara a variáve Tr
  V := TVariable.Create('Tr', pvtInteger, 0, nil, True);
  Script.Variables.AddVar(V);

  // Declara os Parâmetros --> a b c ...
  SL := nil;
  StringToStrings(edC_Par.Text, SL, [' ']);
  for i := 0 to SL.Count-1 do
    begin
    r := StrToFloatDef(AjustaNumero(AllTrim(SL[i])));
    V := TVariable.Create(char(97 + i), pvtReal, r, nil, True); // declara as letras a, b, ..., z
    Script.Variables.AddVar(V);
    end;
  SL.Free;
end;

procedure TfoJP.Plotar;
var Duracao, col, row, incr: Integer;
    Intensidade: Real;
    s: TLineSeries;
begin
  G.Grafico.SeriesList.Clear;

  for Col := 0 to mC_Tr.Lines.Count-1 do
    begin
    s := TLineSeries.Create(G);
    s.ParentChart := G.Grafico;
    s.Title :=  'Tr = ' + mC_Tr.Lines[Col];

    Row := 3;
    Duracao := edC_DurIni.AsInteger;
    incr := edC_DurInc.AsInteger;
    while Duracao <= edC_DurFim.AsInteger do
      begin
      Intensidade := paInt.Tab.NumberRC[Row, Col + 2];
      s.AddXY(Duracao, Intensidade);
      inc(Duracao, incr);
      inc(Row);
      end;
    end;
end;

procedure TfoJP.btnC_SalvarClick(Sender: TObject);
var i, r1, r2, c1, c2: Integer;
    SL: TStrings;
    p: TF1Book;
begin
  Case BookCalculos.ActivePageIndex of
    0: p := paInt.Tab;
    2: p := paALA.Tab;
    3: p := paALD.Tab;
    end;

  r1 := p.SelStartRow;
  r2 := p.SelEndRow;
  c1 := p.SelStartCol;
  c2 := p.SelEndCol;

  if c1 <> c2 then
     raise Exception.Create('Somente uma coluna pode ser selecionada');

  if MessageDLG('Selecionados ' + IntToStr(r2 - r1 + 1) + ' valores.'#13 +
                'Continua ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     if Save.Execute then
        begin
        SL := TStringList.Create;
        for i := r1 to r2 do
          SL.Add(FormatFloat('0.000', p.NumberRC[i, c1]));
        SL.SaveToFile(Save.FileName);
        SL.Free;
        end;
end;

procedure TfoJP.TabSelChange(Sender: TObject);
var r1, r2, c1, c2: Integer;
    p: TF1Book;
begin
  p := TF1Book(Sender);

  r1 := p.SelStartRow;
  r2 := p.SelEndRow;
  c1 := p.SelStartCol;
  c2 := p.SelEndCol;

  p.Hint := IntToStr(r2 - r1 + 1) + ' valores selecionados.';
  Application.ActivateHint(Mouse.CursorPos);
end;

procedure TfoJP.BookChange(Sender: TObject);
begin
  if Book.ActivePageIndex = 0 then
     lbDE_EquacoesClick(nil);
end;

procedure TfoJP.Book2Change(Sender: TObject);
begin
  if Book2.ActivePageIndex = 1 then
     cbC_EqChange(nil);
end;

end.

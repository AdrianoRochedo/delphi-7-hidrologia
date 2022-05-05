unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBTables, Buttons;

type
  TFunc_TipoPChar        = function: PChar;
  TFunc_TipoBool         = function: Boolean;
  TFunc_TipoByte         = function: Byte;
  TProc_Importar         = procedure(Arquivo: PChar);
  TProc_1ParPointer      = procedure(Par: Pointer);

  TPlugin_REC = record
                  hDLL      : THandle;
                  Filtro    : TFunc_TipoPChar;
                  Descricao : TFunc_TipoPChar;
                  CCS       : TFunc_TipoBool;
                  TipoDados : TFunc_TipoByte;
                  Importar  : TProc_Importar;
                end;

  TDLG_Principal = class(TForm)
    Label1: TLabel;
    lbPlugins: TListBox;
    Label2: TLabel;
    mmDesc: TMemo;
    Label3: TLabel;
    lbArquivos: TListBox;
    btnAdicionar: TButton;
    btnRemover: TButton;
    Label4: TLabel;
    edArquivo: TEdit;
    btnImportar: TButton;
    Open: TOpenDialog;
    btnVisualizar: TButton;
    Save: TSaveDialog;
    btnLimpar: TButton;
    Label6: TLabel;
    Status: TMemo;
    btnSelArqSai: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbPluginsClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure edArquivoDblClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    FPlugin: TPlugin_REC;
    FDLLs: TStrings;
    FPath: String;
    FTab: TTable;
    FComandoAtual: String;
    FLinhaAtual: Integer;
    procedure VerificarSelecoes;
    procedure Importar;
    procedure MostrarDLLs(const DLLs, Visor: TStrings);
    function  CarregarDLL(const DLL: String): TPlugin_REC;
  public
    property Plugin : TPlugin_REC read FPlugin;
    property Tab    : TTable      read FTab;
  end;

var
  DLG_Principal: TDLG_Principal;

implementation
uses DB,
     stUtils,
     WinUtils;
     //CH_Const,
     //CH_Func;

{$R *.DFM}

procedure AdicionarRegistro(Posto: PChar; Data: Double; Valor: Double; Status: Integer);
begin
  if DLG_Principal.Plugin.CCS then
     DLG_Principal.Tab.AppendRecord([Posto, Data, Valor, Status])
  else
     DLG_Principal.Tab.AppendRecord([Posto, Data, Valor]);
end;

procedure AtualizarStatusDaOperacao(ComandoAtual: PChar; LinhaAtual: Integer);
begin
  DLG_Principal.FComandoAtual := String(ComandoAtual);
  DLG_Principal.FLinhaAtual   := LinhaAtual;
end;

function TDLG_Principal.CarregarDLL(const DLL: String): TPlugin_REC;
var R: TProc_1ParPointer;
begin
  if Result.hDLL <> 0 then FreeLibrary(Result.hDLL);

  Result.hDLL      := LoadLibrary(PChar(DLL));
  Result.Descricao := GetProcAddress(Result.hDLL, 'Descricao');
  Result.Filtro    := GetProcAddress(Result.hDLL, 'Filtro');
  Result.CCS       := GetProcAddress(Result.hDLL, 'CriarCampoStatus');
  Result.TipoDados := GetProcAddress(Result.hDLL, 'TipoDosDados');
  Result.Importar  := GetProcAddress(Result.hDLL, 'Importar');

  R := GetProcAddress(Result.hDLL, 'Set_RotinaDeAdicaoDosDados');
  R(@AdicionarRegistro);

  R := GetProcAddress(Result.hDLL, 'Set_StatusDaOperacao');
  R(@AtualizarStatusDaOperacao);
end;

procedure TDLG_Principal.MostrarDLLs(const DLLs, Visor: TStrings);
var i: Integer;
    h: THandle;
    FN: TFunc_TipoPChar;
    FV: TFunc_TipoPChar;
begin
  Visor.Clear;
  for i := 0 to DLLs.Count-1 do
    begin
    h := LoadLibrary(PChar(DLLs[i]));
    FN := GetProcAddress(h, 'Nome');
    FV := GetProcAddress(h, 'Versao');
    if (@FN <> nil) and (@FV <> nil) then
       Visor.Add(FN + ' - Versão ' + FV);
    FreeLibrary(h);
    end;
end;

function IncluiItem(const SR : TSearchRec) : Boolean;
begin
  Result := (CompareText(ExtractFileExt(SR.Name), '.DLL') = 0);
end;

procedure TDLG_Principal.FormCreate(Sender: TObject);
begin
  FTab  := TTable.Create(nil);
  FDLLs := TStringList.Create;
  FPath := ExtractFilePath(Application.ExeName);
  EnumerateFiles(FPath + 'Plugins', FDLLs, True, @IncluiItem);
  MostrarDLLs(FDLLs, lbPlugins.Items);
end;

procedure TDLG_Principal.FormDestroy(Sender: TObject);
begin
  FTab.Free;
  FDLLs.Free;
  if FPlugin.hDLL <> 0 then FreeLibrary(FPlugin.hDLL);
end;

procedure TDLG_Principal.lbPluginsClick(Sender: TObject);
begin
  FPlugin := CarregarDLL(FDLLs[lbPlugins.ItemIndex]);
  mmDesc.SetTextBuf(FPlugin.Descricao);
end;

procedure TDLG_Principal.btnAdicionarClick(Sender: TObject);
begin
  if lbPlugins.ItemIndex > -1 then
     begin
     Open.Filter := FPlugin.Filtro;
     if Open.Execute then
        lbArquivos.Items.AddStrings(Open.Files);
     end;   
end;

procedure TDLG_Principal.btnRemoverClick(Sender: TObject);
begin
  DeleteElemFromList(lbArquivos, VK_DELETE);
end;

procedure TDLG_Principal.edArquivoDblClick(Sender: TObject);
begin
  if Save.Execute then
     edArquivo.Text := Save.FileName;
end;

Function CriaTabela(Const Nome: String; CriaCampoStatus: Boolean = False): Boolean;
Var Table1 : TTable;
begin
  Result := False;
  Table1 := TTable.Create(nil);
  try
    with Table1 do
      begin
      Active    := False;
      TableName := Nome;
      TableType := ttParadox;
      TableLevel := 7;
      with FieldDefs do
        begin
        Clear;
        Add('Posto',  ftString, 10, false);
        Add('Data' ,  ftDate ,   0, false);
        Add('Dado' ,  ftFloat,   0, false);

        if CriaCampoStatus then
           Add('Status' ,  ftSmallInt, 0, false);
        end;

      with IndexDefs do
        begin
        Clear;
        Add('', 'Posto;Data', [ixPrimary, ixUnique]);
        end;

      CreateTable;
      Result := FileExists(Nome);
      end;
  finally
    Table1.Free;
  end;
end;

procedure TDLG_Principal.Importar;
var i: Integer;
begin
  CriaTabela(edArquivo.Text, FPlugin.CCS);
  FTab.Close;
  FTab.TableName := edArquivo.Text;
  FTab.Open;
  Try
    for i := 0 to lbArquivos.Items.Count - 1 do
      Try
        Status.Lines.Add(Format(' - Importando Arquivo %d de %d:', [i + 1, lbArquivos.Items.Count]));
        Status.Lines.Add('   ' + lbArquivos.Items[i]);
        Application.ProcessMessages;

        FPlugin.Importar(PChar(lbArquivos.Items[i]));

        Status.Lines.Add(' - Sucesso !');
        Status.Lines.Add(StringOfChar('-', 50));
      Except
        On E: Exception do
          begin
          Status.Lines.Add(' - Erro:');
          Status.Lines.Add('   ' + E.Message);
          Status.Lines.Add(' - Linha do Arquivo: ' + IntToStr(FLinhaAtual));
          Status.Lines.Add('   ' + FComandoAtual);
          Status.Lines.Add(StringOfChar('-', 50));
          end;
      End;
  Finally
    Tab.Close;
    DeleteFile(ChangeFileExt(edArquivo.Text, '.PX'));
  End
end;

procedure TDLG_Principal.btnImportarClick(Sender: TObject);
begin
  StartWait;
  Status.Clear;
  try
    VerificarSelecoes;
    Importar;
    if FPlugin.TipoDados = 1 {mensal} then
       //SalvarArquivoAuxiliar(x);
  finally
    StopWait;
  end;
end;

procedure TDLG_Principal.btnLimparClick(Sender: TObject);
begin
  lbArquivos.Clear;
end;

procedure TDLG_Principal.VerificarSelecoes;
begin
  if lbPlugins.ItemIndex = -1 then
     Raise Exception.Create('Nenhum plug-in selecionado !');

  if lbArquivos.Items.Count = 0 then
     Raise Exception.Create('Nenhum arquivo selecionado para importação !');

  if edArquivo.Text = '' then
     Raise Exception.Create('Escolha um nome para o arquivo destino');    
end;

end.

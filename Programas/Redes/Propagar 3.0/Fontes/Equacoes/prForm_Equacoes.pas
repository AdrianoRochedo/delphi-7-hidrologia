unit prForm_Equacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pr_Classes, RAEditor, RAHLEditor, ExtCtrls, Buttons,
  MPSConversor, ComCtrls, Menus, pr_Const, Execfile, WinUtils, RAButtons,
  CheckLst, SysUtilsEx;

type
  TprForm_Equacoes = class(TForm, IProgressBar, ITextWriter)
    paControles: TPanel;
    Open: TOpenDialog;
    BottomPanel: TPanel;
    laProgresso: TLabel;
    p1: TProgressBar;
    p2: TProgressBar;
    Menu: TPopupMenu;
    Menu_SalvarComo: TMenuItem;
    Menu_Copiar: TMenuItem;
    Menu_Ler: TMenuItem;
    Exec: TExecFile;
    BookControles: TPageControl;
    TabSheet1: TTabSheet;
    btnEscolherArquivo: TSpeedButton;
    edScript: TLabeledEdit;
    GroupBox1: TGroupBox;
    btnEditar: TRAColorButton;
    btnGerar: TRAColorButton;
    GroupBox2: TGroupBox;
    btnStop: TRAColorButton;
    btnMPS: TRAColorButton;
    cbOpt: TCheckBox;
    paEditores: TPanel;
    Book: TPageControl;
    TabEQ: TTabSheet;
    Equacoes: TRAHLEditor;
    TabMPS: TTabSheet;
    MPS: TRichEdit;
    TabMes: TTabSheet;
    Mensagens: TRichEdit;
    TabRes: TTabSheet;
    Res: TRichEdit;
    Panel2: TPanel;
    btnFechar: TRAColorButton;
    TabSheet2: TTabSheet;
    btnSolver: TRAColorButton;
    edEnt: TLabeledEdit;
    edRes: TLabeledEdit;
    Bevel1: TBevel;
    btnEnt: TSpeedButton;
    btnLerRes: TButton;
    Save: TSaveDialog;
    TabSheet3: TTabSheet;
    mPars: TMemo;
    procedure btnGerarClick(Sender: TObject);
    procedure btnEscolherArq_Click(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnMPSClick(Sender: TObject);
    procedure Menu_SalvarComoClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_LerClick(Sender: TObject);
    procedure MenuPopup(Sender: TObject);
    procedure btnSolverClick(Sender: TObject);
    procedure EquacoesChange(Sender: TObject);
    procedure MPSChange(Sender: TObject);
    procedure btnEnt_Click(Sender: TObject);
    procedure edEntChange(Sender: TObject);
    procedure btnLerResClick(Sender: TObject);
  private
    FProjeto: TprProjeto;
    FMPSConversor: TMPSConversor;

    // IProgressBar interface
    procedure setMin(value: integer);
    procedure setMax(value: integer);
    procedure setValue(value: integer);
    procedure setMessage(const s: string);

    // IWriter interface
    procedure Write(const s: string); overload;
    procedure Write(const s, FontName: string; const Color, Size: integer); overload;
    procedure Write(const s: string; const FontAttributes: TFontAttributesRec); overload;

    procedure TerminatedMPSConversion(Sender: TObject);
    procedure Progress(ProgressID, Value: integer; const Text: string);
    procedure AddMes(const s: string);
    function getSolverParameters(): string;
  public
    constructor Create(Projeto: TprProjeto);
  end;

implementation
uses Solver.LP_Solver.ResReader,
     psBASE,
     psEditor,
     pr_Vars,
     pr_Application;

{$R *.dfm}

{ TprForm_Equacoes }

constructor TprForm_Equacoes.Create(Projeto: TprProjeto);
begin
  inherited Create(nil);
  FProjeto := Projeto;
  edScript.Text := FProjeto.Equacoes_NomeScriptGeral;
end;

procedure TprForm_Equacoes.btnGerarClick(Sender: TObject);
var s: String;
begin
  s := edScript.Text;
  FProjeto.RetiraCaminhoSePuder(s);
  FProjeto.Equacoes_NomeScriptGeral := s;
  StartWait();
  try
    try
      FProjeto.EquationBuilder.Generate();
      Book.ActivePageIndex := 0;
    except
      on E: Exception do
         Dialogs.MessageDLG(E.Message, mtError, [mbOk], 0);
    end;
  finally
    Equacoes.Lines.Assign(FProjeto.EquationBuilder.Text);
    EquacoesChange(self);
    StopWait();
  end;
end;

procedure TprForm_Equacoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TprForm_Equacoes.btnEscolherArq_Click(Sender: TObject);
begin
  Open.Filter := cFiltroPascalScript;
  Open.InitialDir := Applic.LastDir;
  if Open.Execute() then
     begin
     edScript.Text := Open.FileName;
     Applic.LastDir := ExtractFilePath(Open.FileName);
     end;
end;

procedure TprForm_Equacoes.btnEditarClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v1: TVariable;
begin
  p := FProjeto;
  s := edScript.Text;
  p.VerificaCaminho(s);
  v1 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
  RunScript(pr_Vars.g_psLib, s, Applic.LastDir, nil, [v1], p.GlobalObjects, False);
end;

procedure TprForm_Equacoes.btnMPSClick(Sender: TObject);
begin
  MessageDLG('Dependendo do número de Equações e Variáveis distintas,'#13 +
             'esta operação pode levar alguns minutos',
              mtInformation, [mbOk], 0);

  Book.ActivePageIndex := 2;
  btnMPS.Enabled := false;
  Application.ProcessMessages();

  FMPSConversor := TMPSConversor.Create();
  FMPSConversor.OnProgress := Progress;
  FMPSConversor.inText := Equacoes.Lines;
  FMPSConversor.outText := MPS.Lines;
  FMPSConversor.Messages := Mensagens.Lines;
  FMPSConversor.Optimize := cbOpt.Checked;
  try
    Mensagens.Clear();
    Mensagens.Lines.BeginUpdate();
    try
      FMPSConversor.Execute();
    finally
      Mensagens.Lines.EndUpdate();
      Book.ActivePageIndex := 1;
      TerminatedMPSConversion(self);
    end;  
  except
    on E: Exception do
       MessageDLG(E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TprForm_Equacoes.Progress(ProgressID, Value: integer; const Text: string);
begin
  if Text <> '' then
     begin
     laProgresso.caption := Text;
     laProgresso.Repaint();
     end;

  if ProgressID = 1 then
     p1.Position := Value
  else
     p2.Position := Value
end;

procedure TprForm_Equacoes.Menu_SalvarComoClick(Sender: TObject);
var Filename: string;
begin
  if PromptForFileName(Filename, cFiltroEquacoes, 'txt', 'Salvar arquivo ...', Applic.LastDir, true) then
     if Book.ActivePageIndex = 0 then
        Equacoes.Lines.SaveToFile(Filename)
     else
        MPS.Lines.SaveToFile(Filename);
end;

procedure TprForm_Equacoes.Menu_CopiarClick(Sender: TObject);
begin
  if Book.ActivePageIndex = 0 then
     Equacoes.ClipBoardCopy()
  else
     MPS.CopyToClipboard();
end;

procedure TprForm_Equacoes.btnStopClick(Sender: TObject);
begin
  if FMPSConversor <> nil then
     FMPSConversor.Terminated := true;
end;

procedure TprForm_Equacoes.TerminatedMPSConversion(Sender: TObject);
var x: TObject;
begin
  laProgresso.Caption := 'Progresso da operação de conversão para o formato MPS:';
  p1.Position := 0;
  p2.Position := 0;
  btnMPS.Enabled := true;
  x := FMPSConversor;
  FMPSConversor := nil;
  x.Free();
  MPSChange(self);
end;

procedure TprForm_Equacoes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (FMPSConversor = nil);
end;

procedure TprForm_Equacoes.Menu_LerClick(Sender: TObject);
begin
  Open.Filter := cFiltroEquacoes;
  Open.InitialDir := Applic.LastDir;
  if Open.Execute() then
     begin
     Equacoes.Lines.LoadFromFile(Open.Filename);
     Applic.LastDir := ExtractFilePath(Open.FileName);
     EquacoesChange(self);
     end;
end;

procedure TprForm_Equacoes.MenuPopup(Sender: TObject);
begin
  Menu_Ler.Enabled := (Book.ActivePageIndex = 0);
end;

procedure TprForm_Equacoes.btnSolverClick(Sender: TObject);
var ent, sai, bat: string;
    SL: TStrings;
begin
  if Equacoes.Lines.Count = 0 then
     raise Exception.Create('Equações não definidas !');

  Mensagens.Clear();
  Res.Clear();

  ent := edEnt.Text;
  Equacoes.Lines.SaveToFile(ent);

  // Gera o nome do arquivo de resultados
  sai := edRes.Text;

  // Remove qualquer arquivo de resultados antigo
  DeleteFile(sai);

  AddMes('Arquivo de equações salvo como: ' + ent);
  AddMes('Executando Solver ...');

  bat := ChangeFileExt(ent, '.bat');
  SL := TStringList.Create();
  SL.Add('@echo off');
  SL.Add('title "Propagar --> LP-Solver"');
  SL.Add('prompt $G');
  SL.Add('echo.');
  SL.Add('echo ATENCAO:');
  SL.Add('echo A leitura dos resultados pelo Propagar somente estara disponivel apos o termino deste processo.');
  SL.Add('echo on');
  SL.Add('"' + Applic.AppDir + cTOOL_LPSolve + Format('" %s -lp "%s" > "%s"', [getSolverParameters(), ent, sai]));
  SL.Add('pause');
  SL.SaveToFile(bat);
  SL.Free();
{
  // Executa o Solver ...
  SysUtils.setCurrentDir(Applic.AppDir + cPATH_LPSolve);
  Exec.CommandLine := Applic.AppDir + cTOOL_LPSolve;
  Exec.Parameters := Format('-s -lp "%s" > "%s"', [ent, sai]);
  Exec.Execute();
}
  // Executa o Solver ...
  Exec.CommandLine := bat;
  Exec.Execute();
end;

procedure TprForm_Equacoes.AddMes(const s: string);
begin
  Book.ActivePageIndex := 2;
  Mensagens.Lines.Add(s);
  Applic.ProcessMessages();
end;

procedure TprForm_Equacoes.EquacoesChange(Sender: TObject);
begin
  TabEQ.Caption := Format('Equações: %d linhas', [Equacoes.Lines.Count]);
end;

procedure TprForm_Equacoes.MPSChange(Sender: TObject);
begin
  TabMPS.Caption := Format('Formato MPS: %d linhas', [MPS.Lines.Count]);
end;

procedure TprForm_Equacoes.btnEnt_Click(Sender: TObject);
begin
  Save.InitialDir := Applic.LastDir;
  if Save.Execute() then
     begin
     edEnt.Text := Save.FileName;
     Applic.LastDir := ExtractFilePath(Save.FileName);
     end;
end;

procedure TprForm_Equacoes.edEntChange(Sender: TObject);
begin
  edRes.Text := ChangeFileExt(edEnt.Text, '.res');
end;

procedure TprForm_Equacoes.btnLerResClick(Sender: TObject);
var Reader: TLP_Solver_Res_Reader;
begin
  if FileExists(edRes.Text) then
     begin
     Book.ActivePageIndex := 3;
     Reader := TLP_Solver_Res_Reader.Create(self);
     try
       Res.Clear();
       Reader.LoadFromFile(edRes.Text, self);
       FProjeto.Variaveis.Assign(Reader.Variables);
     finally
       Reader.Free();
       end;
     end
  else
     begin
     AddMes('Arquivo de resultados não encontrado');
     Book.ActivePageIndex := 2;
     end;
end;

function TprForm_Equacoes.getSolverParameters(): string;
var i: Integer;
begin
  result := '';
  for i := 0 to mPars.Lines.Count-1 do
    result := Result + ' -' + mPars.Lines[i];
end;

procedure TprForm_Equacoes.setMax(value: integer);
begin
  p1.Max := value;
end;

procedure TprForm_Equacoes.setMessage(const s: string);
begin
  laProgresso.Caption := s;
  ProcessMessages();
end;

procedure TprForm_Equacoes.setMin(value: integer);
begin
  p1.Min := value;
end;

procedure TprForm_Equacoes.setValue(value: integer);
begin
  p1.Position := value;
end;

procedure TprForm_Equacoes.Write(const s, FontName: string; const Color, Size: integer);
begin
  Res.SelAttributes.Color := Color;
  Res.SelAttributes.Size := Size;
  if FontName = '' then
     Res.SelAttributes.Name := 'Courier New'
  else
     Res.SelAttributes.Name := FontName;

  Res.Lines.Add(s);
end;

procedure TprForm_Equacoes.Write(const s: string);
begin
  Res.Lines.Add(s);
end;

procedure TprForm_Equacoes.Write(const s: string; const FontAttributes: TFontAttributesRec);
begin
  with FontAttributes do
    Write(s, FontName, Color, Size);
end;

end.

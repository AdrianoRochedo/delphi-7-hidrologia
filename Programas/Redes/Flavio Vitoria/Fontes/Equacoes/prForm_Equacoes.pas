unit prForm_Equacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pr_Classes, RAEditor, RAHLEditor, ExtCtrls, Buttons,
  MPSConversor, ComCtrls, Menus, pr_Const;

type
  TprForm_Equacoes = class(TForm)
    Panel1: TPanel;
    btnGerar: TButton;
    btnFechar: TButton;
    Open: TOpenDialog;
    edScript: TLabeledEdit;
    btnEditar: TButton;
    btnEscolherArquivo: TSpeedButton;
    Book: TPageControl;
    TabEQ: TTabSheet;
    TabMPS: TTabSheet;
    Equacoes: TRAHLEditor;
    btnMPS: TButton;
    BottomPanel: TPanel;
    laProgresso: TLabel;
    p1: TProgressBar;
    p2: TProgressBar;
    Menu: TPopupMenu;
    Menu_SalvarComo: TMenuItem;
    Menu_Copiar: TMenuItem;
    MPS: TRichEdit;
    btnStop: TButton;
    Menu_Ler: TMenuItem;
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
  private
    FProjeto: TprProjeto;
    FMPSConversor: TMPSConversor;
    procedure TerminatedMPSConversion(Sender: TObject);
    procedure Progress(ProgressID, Value: integer; const Text: string);
  public
    constructor Create(Projeto: TprProjeto);
  end;

implementation
uses psBASE,
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
  try
    try
      FProjeto.EquationBuilder.Generate();
    except
      on E: Exception do
         Dialogs.MessageDLG(E.Message, mtError, [mbOk], 0);
    end;
  finally
    Equacoes.Lines.Assign(FProjeto.EquationBuilder.Text);
  end;
end;

procedure TprForm_Equacoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TprForm_Equacoes.btnEscolherArq_Click(Sender: TObject);
begin
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

  Book.ActivePageIndex := 1;
  btnMPS.Enabled := false;

  FMPSConversor := TMPSConversor.Create();
  FMPSConversor.OnProgress := Progress;
  FMPSConversor.OnTerminate := TerminatedMPSConversion;
  FMPSConversor.inText := Equacoes.Lines;
  FMPSConversor.outText := MPS.Lines;
  FMPSConversor.FreeOnTerminate := true;
  FMPSConversor.Resume();
end;

procedure TprForm_Equacoes.Progress(ProgressID, Value: integer; const Text: string);
begin
  if Text <> '' then
     begin
     laProgresso.caption := Text;
     //Application.ProcessMessages();
     end;

  if ProgressID = 1 then
     p1.Position := Value
  else
     p2.Position := Value
end;

procedure TprForm_Equacoes.Menu_SalvarComoClick(Sender: TObject);
var Filename: string;
begin
  if PromptForFileName(Filename, cFiltroPascalScript, 'txt', 'Salvar arquivo ...', Applic.LastDir, true) then
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
     FMPSConversor.Terminate();
end;

procedure TprForm_Equacoes.TerminatedMPSConversion(Sender: TObject);
begin
  laProgresso.Caption := 'Progresso da operação de conversão para o formato MPS:';
  p1.Position := 0;
  p2.Position := 0;
  btnMPS.Enabled := true;
  //FMPSConversor.Free();
  FMPSConversor := nil;
end;

procedure TprForm_Equacoes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (FMPSConversor = nil);
end;

procedure TprForm_Equacoes.Menu_LerClick(Sender: TObject);
var Filename: string;
begin
  if Open.Execute() then
     Equacoes.Lines.SaveToFile(Open.Filename);
end;

procedure TprForm_Equacoes.MenuPopup(Sender: TObject);
begin
  Menu_Ler.Enabled := (Book.ActivePageIndex = 0);
end;

end.

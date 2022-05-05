unit pr_DialogoBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, MessagesForm;

type
  TprDialogo_Base = class(TForm)
    edNome: TEdit;
    P1: TPanel;
    edDescricao: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    mComentarios: TMemo;
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    Panel_Script: TPanel;
    lbScripts: TListBox;
    btnAdicionarScript: TButton;
    btnRemoverScript: TButton;
    btnEditar: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarScriptClick(Sender: TObject);
    procedure btnRemoverScriptClick(Sender: TObject);
    procedure btnEditarScript_Click(Sender: TObject);
    procedure lbScriptsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbScriptsDblClick(Sender: TObject);
  private
    procedure SetBloqueado(const Value: Boolean);
  protected
    Erros : TfoMessages;
  public
    // Objeto que possue esta janela
    Objeto : TObject;

    // Tabela de Nomes dos objetos
    TN : TStrings;

    // Indice do script default
    DefaultScript : integer;

    // Diz se o dialogo esta bloqueado para edicoes
    property Bloqueado : Boolean write SetBloqueado;
  end;

implementation
uses pr_Classes,
     pr_Const,
     SysUtilsEx,
     WinUtils,
     DialogUtils,
     pr_Application,
     psBASE,
     psEditor,
     pr_Vars;

{$R *.DFM}

procedure TprDialogo_Base.btnOkClick(Sender: TObject);
var TudoOk: Boolean;
begin
  edNome.Text := AllTrim(edNome.Text);
  
  if TN.IndexOf(edNome.Text) > -1 then
     begin
     Erros.Add(etError, Format(cMsgErro03, [edNome.Text]));
     Erros.Show;
     end
  else
     begin
     TudoOk := True;
     THidroComponente(Objeto).ValidarDados(TudoOk, Erros);
     if TudoOk then
        modalResult := mrOk
     else
        Erros.Show;
     end;

  //if Erros.G.Cells[1,0] <> '' then Erros.Show else ModalResult := mrOk;
end;

procedure TprDialogo_Base.btnCancelarClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TprDialogo_Base.FormCreate(Sender: TObject);
begin
  Erros := TfoMessages.Create();
  DefaultScript := -1;

  {$ifdef Objetos_Nao_Editaveis}                         
  btnOK.Enabled := false;
  {$endif}
end;

procedure TprDialogo_Base.FormDestroy(Sender: TObject);
begin
  Erros.Free;
end;

procedure TprDialogo_Base.SetBloqueado(const Value: Boolean);
begin
  {$ifdef Objetos_Nao_Editaveis}
  btnOK.Enabled := false;
  {$else}
  btnOk.Enabled := not Value;
  {$endif}
end;

procedure TprDialogo_Base.btnAdicionarScriptClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, Applic.LastDir, cFiltroPascalScript) then
     begin
     TprProjeto(Objeto).RetiraCaminhoSePuder(s);
     if lbScripts.Items.IndexOf(s) = -1 then
        lbScripts.Items.Add(s);
     end;
end;

procedure TprDialogo_Base.btnRemoverScriptClick(Sender: TObject);
begin
  if lbScripts.ItemIndex = DefaultScript then DefaultScript := -1;
  DeleteElemFromListEx(lbScripts);
end;

procedure TprDialogo_Base.btnEditarScript_Click(Sender: TObject);
var s: String;
    p: TprProjeto;
    v1: TVariable;
    v2: TVariable;
begin
  p := THidroComponente(Objeto).Projeto;
  s := lbScripts.Items[lbScripts.ItemIndex];
  p.VerificaCaminho(s);
  v1 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
  v2 := TVariable.Create('Obj', pvtObject, Integer(Objeto), Objeto.ClassType, True);
  RunScript(g_psLib, s, Applic.LastDir, nil, [v1, v2], p.GlobalObjects, False);
end;

procedure TprDialogo_Base.lbScriptsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var c: TCanvas;
    s: string;
begin
  c := TListBox(Control).Canvas;
  s := TListBox(Control).Items[Index];

  c.FillRect(Rect);

  if Index = DefaultScript then
     c.Font.Style := [fsBold]
  else
     c.Font.Style := [];

  c.TextOut(Rect.Left + 2, Rect.Top, s);
end;

procedure TprDialogo_Base.lbScriptsDblClick(Sender: TObject);
begin
  DefaultScript := lbScripts.ItemIndex;
  lbScripts.Invalidate();
end;

end.

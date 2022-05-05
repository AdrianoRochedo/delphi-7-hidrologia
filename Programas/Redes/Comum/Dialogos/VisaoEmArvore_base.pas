unit VisaoEmArvore_base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ExtCtrls, Buttons,
  MessageManager,
  Hidro_Classes,
  AreaDeProjeto_base;

type
  TForm_VisaoEmArvore_base = class(TForm, IMessageReceptor)
    Arvore: TTreeView;
    Imagens: TImageList;
    Botoes: TPanel;
    sbExpandir: TSpeedButton;
    sbEncolher: TSpeedButton;
    sbEditar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbExpandirClick(Sender: TObject);
    procedure sbEncolherClick(Sender: TObject);
    procedure sbEditarClick(Sender: TObject);
    procedure ArvoreClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ArvoreDblClick(Sender: TObject);
  private
    FAP     : TForm_AreaDeProjeto_base;

    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; virtual;
    procedure SetAP(const Value: TForm_AreaDeProjeto_base);
    procedure ReconstroiPCs(no: TTreeNode);
    procedure ReconstroiSubBacias(no: TTreeNode);
    procedure ReconstroiTrechos(no: TTreeNode);
    function  NoDoObjeto(Raiz: TTreeNode; Obj: THidroComponente): TTreeNode;
  protected
    procedure ReconstruirArvore; virtual;
    function  ObtemRamo(Obj: THidroComponente): TTreeNode; virtual;
    procedure Adicionar(Obj: THidroComponente; Em: TTreeNode); virtual;
  public
    No_PR, No_PCs, No_SBs, No_TDs: TTreeNode;

    procedure Atualizar;
    procedure SelecionarObjeto(Obj: THidroComponente);
    procedure AdicionarObjeto(Obj: THidroComponente);
    procedure RemoverObjeto(Obj: THidroComponente);

    property AreaDeProjeto: TForm_AreaDeProjeto_base read FAP write SetAP;
  end;

var
  Gerenciador: TForm_VisaoEmArvore_base;

implementation
uses Hidro_Variaveis,
     TreeViewUtils;

{$R *.DFM}

{ TForm_VisaoEmArvore_base }

procedure TForm_VisaoEmArvore_base.Atualizar;
begin
  // Inicia atualização da árvore
  Arvore.Items.BeginUpdate;

  ReconstruirArvore;

  // Termina atualização da árvore
  Arvore.Items.EndUpdate;
end;

procedure TForm_VisaoEmArvore_base.ReconstroiPCs(no: TTreeNode);
var nf: TTreeNode;
    i : Integer;
begin
  no.DeleteChildren;
  for i := 0 to AreaDeProjeto.Projeto.PCs.PCs-1 do
    begin
    nf := Arvore.Items.AddChildObject(
      no, AreaDeProjeto.Projeto.PCs[i].Nome, AreaDeProjeto.Projeto.PCs[i]);
    nf.ImageIndex := 4;
    nf.SelectedIndex := 4;
    end;
end;

procedure AdicionaSubBacia(Projeto: TProjeto; SB: TSubBacia);
var nf: TTreeNode;
begin
  nf := Gerenciador.Arvore.Items.AddChildObject(Gerenciador.No_SBs, SB.Nome, SB);
  nf.ImageIndex := 4;
  nf.SelectedIndex := 4;
end;

procedure TForm_VisaoEmArvore_base.ReconstroiSubBacias(no: TTreeNode);
begin
  no.DeleteChildren;
  AreaDeProjeto.Projeto.PercorreSubBacias(AdicionaSubBacia);
end;

procedure TForm_VisaoEmArvore_base.ReconstroiTrechos(no: TTreeNode);
var nf: TTreeNode;
     i: Integer;
    TD: TTrechoDagua;
begin
  no.DeleteChildren;
  for i := 0 to AreaDeProjeto.Projeto.PCs.PCs-1 do
    begin
    TD := AreaDeProjeto.Projeto.PCs[i].TrechoDagua;
    if TD <> nil then
       begin
       nf := Arvore.Items.AddChildObject(no, TD.Nome, TD);
       nf.ImageIndex := 4;
       nf.SelectedIndex := 4;
       end;
    end
end;

procedure TForm_VisaoEmArvore_base.SetAP(const Value: TForm_AreaDeProjeto_base);
begin
  if Value <> FAP then
     begin
     FAP := Value;
     Atualizar;
     end;
end;

procedure TForm_VisaoEmArvore_base.FormCreate(Sender: TObject);
begin
  No_PR  := Arvore.Items[0]; // Nó raiz --> AreaDeProjeto
  No_PCs := No_PR[0]; // Primeiro nó da raiz --> PCs
  No_SBs := No_PR[1]; // Segundo nó da raiz --> Sub-Bacias
  No_TDs := No_PR[2]; // Terceiro nó da raiz --> Trechos Dágua

  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, Self);
end;

procedure TForm_VisaoEmArvore_base.sbExpandirClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if no <> nil then no.Expand(True);
end;

procedure TForm_VisaoEmArvore_base.sbEncolherClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if no <> nil then no.Collapse(True);
end;

procedure TForm_VisaoEmArvore_base.sbEditarClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.Data <> nil) then
     THidroComponente(no.Data).MostrarDialogo;
end;

procedure TForm_VisaoEmArvore_base.ArvoreClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  sbEditar.Enabled := (no <> nil) and (no.Data <> nil);
  if sbEditar.Enabled then
     begin
     GetMessageManager.SendMessage(UM_CLICK_GERENTE, [no.Data]);
     AreaDeProjeto.ObjetoSelecionado := THidroComponente(no.Data);
     AreaDeProjeto.AtualizarTela;
     end
  else
     GetMessageManager.SendMessage(UM_CLICK_GERENTE, [0]);
end;

procedure TForm_VisaoEmArvore_base.SelecionarObjeto(Obj: THidroComponente);
var no: TTreeNode;
begin
  if Obj = nil then
     Arvore.Selected := nil
  else
     begin
     no := NoDoObjeto(ObtemRamo(Obj), Obj);
     if no <> nil then no.Selected := True;
     end;
end;

function TForm_VisaoEmArvore_base.NoDoObjeto(Raiz: TTreeNode; Obj: THidroComponente): TTreeNode;
begin
  Result := nil;
  if Raiz = nil then Raiz := Arvore.Items.GetFirstNode;
  while Raiz <> nil do
    begin
    if Raiz.Data = Obj then begin Result := Raiz; Break end;
    Raiz := Raiz.GetNext;
    end;
end;

function TForm_VisaoEmArvore_base.ObtemRamo(Obj: THidroComponente): TTreeNode;
begin
  Result := nil;

  if Obj is TPC              then Result := No_PCs else
  if Obj is TSubBacia        then Result := No_SBs else
  if Obj is TTrechoDagua     then Result := No_TDs;
end;

procedure TForm_VisaoEmArvore_base.RemoverObjeto(Obj: THidroComponente);
var no: TTreeNode;
begin
  no := NoDoObjeto(ObtemRamo(Obj), Obj);
  if no <> nil then no.Delete();
end;

procedure TForm_VisaoEmArvore_base.AdicionarObjeto(Obj: THidroComponente);
var no: TTreeNode;
begin
  if Obj <> nil then
     begin
     no := ObtemRamo(Obj);
     if no <> nil then Adicionar(Obj, no);
     end;
end;

procedure TForm_VisaoEmArvore_base.FormDestroy(Sender: TObject);
begin
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, Self);
end;

procedure TForm_VisaoEmArvore_base.ReconstruirArvore;
begin
  if AreaDeProjeto <> nil then
     begin
     No_PR.Data := AreaDeProjeto.Projeto;
     No_PR.Text := AreaDeProjeto.Projeto.Nome;
     if AreaDeProjeto.Projeto.Descricao <> '' then
        No_PR.Text := No_PR.Text + ' - ' + AreaDeProjeto.Projeto.Descricao;

     // Inicia preenchimento dos nós intermediários
     ReconstroiPCs(No_PCs);
     ReconstroiSubBacias(No_SBs);
     ReconstroiTrechos(No_TDs);
     end
  else
     begin
     No_PR.Data := nil;
     No_PR.Text := 'Projeto';
     No_PCs.DeleteChildren;
     No_SBs.DeleteChildren;
     No_TDs.DeleteChildren;
     end;
end;

procedure TForm_VisaoEmArvore_base.Adicionar(Obj: THidroComponente; Em: TTreeNode);
var no: TTreeNode;
begin
  no := Arvore.Items.AddChildObject(Em, Obj.Nome, Obj);
  no.ImageIndex := 4;
  no.SelectedIndex := 4;
end;

function TForm_VisaoEmArvore_base.ReceiveMessage(const MSG: TadvMessage): Boolean;
var no: TTreeNode;
begin
  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     begin
     no := TreeViewUtils.FindNode(Arvore.Items[0], MSG.ParamAsString(1));
     if no <> nil then no.Text := MSG.ParamAsString(2);
     end;
end;

procedure TForm_VisaoEmArvore_base.ArvoreDblClick(Sender: TObject);
var no: TTreeNode;
begin
  ArvoreClick(Arvore);
  sbEditarClick(nil);
end;

end.

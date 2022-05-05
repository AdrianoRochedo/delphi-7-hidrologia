unit pr_Gerenciador;
                              
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ExtCtrls, Buttons,
  MessageManager,
  pr_Classes, 
  pr_Funcoes,
  pr_Form_AreaDeProjeto_Base;

const
  cNumeroDeImagensFixas = 8;  

type
  TprDialogo_Gerenciador = class(TForm, IMessageReceptor)
    Arvore: TTreeView;
    Botoes: TPanel;
    sbExpandir: TSpeedButton;
    sbEncolher: TSpeedButton;
    sbEditar: TSpeedButton;
    Imagens: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure sbExpandirClick(Sender: TObject);
    procedure sbEncolherClick(Sender: TObject);
    procedure sbEditarClick(Sender: TObject);
    procedure ArvoreClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ArvoreDblClick(Sender: TObject);
  private
    FAP: TfoAreaDeProjeto_Base;

    procedure SetAP(const Value: TfoAreaDeProjeto_Base);
    procedure ReconstroiClassesDeDemandas_e_Demandas(no: TTreeNode);
    procedure ReconstroiPCs(no: TTreeNode);
    procedure ReconstroiSubBacias(no: TTreeNode);
    procedure ReconstroiTrechos(no: TTreeNode);
    procedure ReconstroiCenarios(no: TTreeNode);
    procedure ReconstroiQAs(no: TTreeNode);
    function  NoDoObjeto(Raiz: TTreeNode; Obj: THidroComponente): TTreeNode;
    function  ObtemRamo(Obj: THidroComponente): TTreeNode;
    function  GetCD_Selecionada: TprDemanda;
    function  AdicionaClasseDemanda(Raiz: TTreeNode; Classe: TprClasseDemanda): TTreeNode;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;
  public
    No_PR  : TTreeNode;
    No_CDs : TTreeNode;
    No_PCs : TTreeNode;
    No_SBs : TTreeNode;
    No_TDs : TTreeNode;
    No_CNs : TTreeNode;
    No_QAs : TTreeNode;

    procedure ReconstroiArvore;
    procedure SelecionarObjeto(Obj: THidroComponente);
    procedure AdicionarObjeto(Obj: THidroComponente);
    procedure RemoverObjeto(Obj: THidroComponente);

    property  AreaDeProjeto  : TfoAreaDeProjeto_Base read FAP write SetAP;
    property  CD_Selecionada : TprDemanda read GetCD_Selecionada;
  end;

var
  Gerenciador: TprDialogo_Gerenciador;

implementation
uses pr_Const, pr_Vars;

{$R *.DFM}

{ TGerenciador }

procedure TprDialogo_Gerenciador.ReconstroiArvore;
begin
  // Inicia atualização da árvore
  Arvore.Items.BeginUpdate;

  if AreaDeProjeto <> nil then
     begin
     No_PR.Data := AreaDeProjeto.Projeto;
     No_PR.Text := AreaDeProjeto.Projeto.Nome;
     if AreaDeProjeto.Projeto.Descricao <> '' then
        No_PR.Text := No_PR.Text + ' - ' + AreaDeProjeto.Projeto.Descricao;

     // Inicia preenchimento dos nós intermediários
     ReconstroiClassesDeDemandas_e_Demandas(No_CDs);
     ReconstroiPCs(No_PCs);
     ReconstroiSubBacias(No_SBs);
     ReconstroiTrechos(No_TDs);
     ReconstroiCenarios(No_CNs);
     ReconstroiQAs(No_QAs);
     end
  else
     begin
     No_PR.Data := nil;
     No_PR.Text := 'Projeto';
     No_CDs.DeleteChildren;
     No_PCs.DeleteChildren;
     No_SBs.DeleteChildren;
     No_TDs.DeleteChildren;
     No_CNs.DeleteChildren;
     No_QAs.DeleteChildren;
     end;

  // Termina atualização da árvore
  Arvore.Items.EndUpdate;
end;

procedure TprDialogo_Gerenciador.ReconstroiClassesDeDemandas_e_Demandas(no: TTreeNode);
var i,j : Integer;
    nf  : TTreeNode;
    nf2 : TTreeNode;
    SL  : TStrings;
begin
  no.DeleteChildren;

  // Limpa as imagens para poder adicionar novamente
  i := Imagens.Count-1;
  for j := i downTo cNumeroDeImagensFixas do
    Imagens.Delete(j);

  // Monta a árvore com as Classes de Demanda e seus respectivos Bitmaps
  SL := TStringList.Create;
  for i := 0 to AreaDeProjeto.Projeto.ClassesDeDemanda.Classes-1 do
    begin
    nf := AdicionaClasseDemanda(no, AreaDeProjeto.Projeto.ClassesDeDemanda[i]);
    ObterDemandasPelaClasse(AreaDeProjeto.Projeto.ClassesDeDemanda[i].Nome, SL, AreaDeProjeto.Projeto);
    for j := 0 to SL.Count-1 do
      begin
      nf2 := Arvore.Items.AddChildObject(nf, SL[j], SL.Objects[j]);
      nf2.ImageIndex := 7;
      nf2.SelectedIndex := 7;
      end;
    end;

  //if naCDs in AreaDeProjeto.GO_NosAbertos then no.Expand(True);

  SL.Free();
end;

procedure TprDialogo_Gerenciador.ReconstroiPCs(no: TTreeNode);
var nf: TTreeNode;
    i : Integer;
begin
  no.DeleteChildren;
  for i := 0 to AreaDeProjeto.Projeto.PCs.PCs-1 do
    begin
    nf := Arvore.Items.AddChildObject(
      no, AreaDeProjeto.Projeto.PCs[i].Nome, AreaDeProjeto.Projeto.PCs[i]);
    nf.ImageIndex := 7;
    nf.SelectedIndex := 7;
    end;
end;

procedure AdicionaSubBacia(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList);
var nf: TTreeNode;
begin
  nf := Gerenciador.Arvore.Items.AddChildObject(Gerenciador.No_SBs, SB.Nome, SB);
  nf.ImageIndex := 7;
  nf.SelectedIndex := 7;
end;

procedure TprDialogo_Gerenciador.ReconstroiSubBacias(no: TTreeNode);
begin
  no.DeleteChildren;
  AreaDeProjeto.Projeto.PercorreSubBacias(AdicionaSubBacia, nil);
end;

procedure TprDialogo_Gerenciador.ReconstroiTrechos(no: TTreeNode);
var nf: TTreeNode;
     i: Integer;
    TD: TprTrechoDagua;
begin
  no.DeleteChildren;
  for i := 0 to AreaDeProjeto.Projeto.PCs.PCs-1 do
    begin
    TD := AreaDeProjeto.Projeto.PCs[i].TrechoDagua;
    if TD <> nil then
       begin
       nf := Arvore.Items.AddChildObject(no, TD.Nome, TD);
       nf.ImageIndex := 7;
       nf.SelectedIndex := 7;
       end;
    end
end;

procedure TprDialogo_Gerenciador.ReconstroiCenarios(no: TTreeNode);
var nf: TTreeNode;
     i: Integer;
    CN: TprCenarioDeDemanda;
     L: TList;
begin
  L := AreaDeProjeto.Projeto.ObtemCenarios();
  no.DeleteChildren;
  for i := 0 to L.Count-1 do
    begin
    CN := TprCenarioDeDemanda(L[i]);
    nf := Arvore.Items.AddChildObject(no, CN.Nome, CN);
    nf.ImageIndex := 7;
    nf.SelectedIndex := 7;
    end;
  L.Free();
end;

procedure TprDialogo_Gerenciador.SetAP(const Value: TfoAreaDeProjeto_Base);
begin
  if Value <> FAP then
     begin
     FAP := Value;
     ReconstroiArvore;
     end;
end;

procedure TprDialogo_Gerenciador.FormCreate(Sender: TObject);
begin
  No_PR  := Arvore.Items[0]; // Nó raiz --> AreaDeProjeto
  No_CDs := No_PR[0]; // Classes de Demandas
  No_CNs := No_PR[1]; // Cenários
  No_PCs := No_PR[2]; // PCs
  No_SBs := No_PR[3]; // Sub-Bacias
  No_TDs := No_PR[4]; // Trechos Dágua
  No_QAs := No_PR[5]; // Qualidades da Agua

  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);
end;

procedure TprDialogo_Gerenciador.sbExpandirClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if no <> nil then no.Expand(True);
end;

procedure TprDialogo_Gerenciador.sbEncolherClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if no <> nil then no.Collapse(True);
end;

procedure TprDialogo_Gerenciador.sbEditarClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.Data <> nil) then
     THidroComponente(no.Data).Editar();
end;

procedure TprDialogo_Gerenciador.ArvoreClick(Sender: TObject);
var no: TTreeNode;
begin
  no := Arvore.Selected;
  sbEditar.Enabled := (no <> nil) and (no.Data <> nil);
  if sbEditar.Enabled then
     begin
     GetMessageManager.SendMessage(UM_CLICK_GERENTE, [no.Data]);
     AreaDeProjeto.ObjetoSelecionado := THidroComponente(no.Data);
     end
  else
     GetMessageManager.SendMessage(UM_CLICK_GERENTE, [nil]);
end;

procedure TprDialogo_Gerenciador.SelecionarObjeto(Obj: THidroComponente);
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

function TprDialogo_Gerenciador.NoDoObjeto(Raiz: TTreeNode; Obj: THidroComponente): TTreeNode;
begin
  Result := nil;
  if Raiz = nil then Raiz := Arvore.Items.GetFirstNode;
  while Raiz <> nil do
    begin
    if Raiz.Data = Obj then begin Result := Raiz; Break end;
    Raiz := Raiz.GetNext;
    end;
end;
                                  
function TprDialogo_Gerenciador.ObtemRamo(Obj: THidroComponente): TTreeNode;
begin
  Result := nil;

  if Obj is TprPC               then Result := No_PCs else
  if Obj is TprSubBacia         then Result := No_SBs else
  if Obj is TprClasseDemanda    then Result := No_CDs else
  if Obj is TprTrechoDagua      then Result := No_TDs else
  if Obj is TprQualidadeDaAgua  then Result := No_QAs else
  if Obj is TprCenarioDeDemanda then Result := No_CNs;
end;

procedure TprDialogo_Gerenciador.RemoverObjeto(Obj: THidroComponente);
var no: TTreeNode;
begin
  no := ObtemRamo(Obj);
  if no <> nil then
     begin
     no := NoDoObjeto(no, Obj);
     if no <> nil then no.Delete;
     end;
end;

procedure TprDialogo_Gerenciador.AdicionarObjeto(Obj: THidroComponente);
var no: TTreeNode;
begin
  if Obj <> nil then
     begin
     no := ObtemRamo(Obj);
     if no <> nil then
        if no = No_CDs then
           if Obj is TprDemanda then
              if getCD_Selecionada() <> nil then
                 begin
                 no := Arvore.Selected;
                 no := Arvore.Items.AddChildObject(no, Obj.Nome, Obj);
                 no.ImageIndex := 7;
                 no.SelectedIndex := 7;
                 end
              else
                 // nada
           else
              AdicionaClasseDemanda(no, TprClasseDemanda(Obj))
        else
           begin
           no := Arvore.Items.AddChildObject(no, Obj.Nome, Obj);
           no.ImageIndex := 7;
           no.SelectedIndex := 7;
           end;
     end;
end;

function TprDialogo_Gerenciador.GetCD_Selecionada: TprDemanda;
var no: TTreeNode;
begin
  no := Arvore.Selected;
  if (no <> nil) and (no.HasAsParent(No_CDs)) then
     Result := TprDemanda(no.Data)
  else
     Result := nil;
end;

function TprDialogo_Gerenciador.AdicionaClasseDemanda(Raiz: TTreeNode; Classe: TprClasseDemanda): TTreeNode;
var b: TBitMap;
    j: Integer;
    s: String;
begin
  s := Classe.Nome;
  s := s + ' - ' + PrioridadeToString(Classe.Prioridade);
  Result := Arvore.Items.AddChildObject(Raiz, s, Classe);

  b := Classe.Bitmap;
  if b.Width <> Imagens.Width then b.Width := Imagens.Width;
  if b.Height <> Imagens.Height then b.Height := Imagens.Height;
  j := Imagens.Add(b, nil);
  if j > -1 then
     begin
     Result.ImageIndex := j;
     Result.SelectedIndex := j;
     end;
end;

procedure TprDialogo_Gerenciador.FormDestroy(Sender: TObject);
begin
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, self);
end;

procedure TprDialogo_Gerenciador.ArvoreDblClick(Sender: TObject);
begin
  ArvoreClick(Arvore);
  sbEditarClick(nil);
end;

function TprDialogo_Gerenciador.ReceiveMessage(const MSG: TadvMessage): Boolean;
var obj : THidroComponente;
    no  : TTreeNode;
    s   : String;
begin
  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     begin
     obj := THidroComponente(MSG.ParamAsObject(0));
     s := Obj.Nome;
     if Obj is TprClasseDemanda then
        s := s + ' - ' + PrioridadeToString(TprClasseDemanda(Obj).Prioridade);
     no := Gerenciador.NoDoObjeto(Gerenciador.ObtemRamo(Obj), Obj);
     if no <> nil then no.Text := s;
     Gerenciador.AreaDeProjeto.ObjetoSelecionado := Obj;
     end;
end;

procedure TprDialogo_Gerenciador.ReconstroiQAs(no: TTreeNode);
var nf: TTreeNode;
     i: Integer;
    QA: TprQualidadeDaAgua;
     L: TList;
begin
  L := AreaDeProjeto.Projeto.ObtemQAs();
  no.DeleteChildren();
  for i := 0 to L.Count-1 do
    begin
    QA := TprQualidadeDaAgua(L[i]);
    nf := Arvore.Items.AddChildObject(no, QA.Nome, QA);
    nf.ImageIndex := 7;
    nf.SelectedIndex := 7;
    end;
  L.Free();
end;

initialization
  Gerenciador := TprDialogo_Gerenciador.Create(nil);

finalization
  Gerenciador.Free();

end.


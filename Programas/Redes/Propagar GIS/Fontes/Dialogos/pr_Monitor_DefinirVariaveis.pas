unit pr_Monitor_DefinirVariaveis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons,
  pr_Classes;

type
  TDLG_DefinirVariaveis = class(TForm)
    Label1: TLabel;
    Arvore: TTreeView;
    Label2: TLabel;
    lb1: TListBox;
    Label3: TLabel;
    lb2: TListBox;
    btnFechar: TButton;
    btnAdicionar: TBitBtn;
    btnRemover: TBitBtn;
    procedure ArvoreClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
  private
    FProjeto: TprProjeto;
    noPCs, noSBs: TTreeNode;
    procedure DefinirVariaveis;
  public
    constructor Create(Projeto: TprProjeto);
  end;

implementation
uses SysUtilsEx, WinUtils;

{$R *.dfm}

{ TDLG_DefinirVariaveis }

var DLG: TDLG_DefinirVariaveis;

procedure AdicionaSubBacia(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList);
begin
  DLG.Arvore.Items.AddChildObject(DLG.noSBs, SB.Nome, SB);
end;

constructor TDLG_DefinirVariaveis.Create(Projeto: TprProjeto);
var i: Integer;
begin
  inherited Create(nil);
  FProjeto := Projeto;
  noPCs := Arvore.Items[0].Item[0];
  noSBs := Arvore.Items[0].Item[1];
  Arvore.Items[0].Expand(False);
  for i := 0 to Projeto.PCs.PCs-1 do
    Arvore.Items.AddChildObject(noPCs, Projeto.PCs[i].Nome, Projeto.PCs[i]);
  DLG := Self; Projeto.PercorreSubBacias(AdicionaSubBacia, nil);
end;

procedure TDLG_DefinirVariaveis.ArvoreClick(Sender: TObject);
var Obj: THidroComponente;
    no: TTreeNode;
    SL: TStrings;
begin
  SL := nil;
  no := Arvore.Selected;
  if no.Data <> nil then
     begin
     Obj := THidroComponente(no.Data);
     StringToStrings(Obj.VarsQuePodemSerMonitoradas, SL, [';']);
     lb1.Items.Assign(SL);
     SL.Clear;
     StringToStrings(Obj.VarsMonitoradas, SL, [';']);
     lb2.Items.Assign(SL);
     SL.Free;
     end;
end;

procedure TDLG_DefinirVariaveis.DefinirVariaveis;
var Obj: THidroComponente;
    no: TTreeNode;
    SL: TStrings;
begin
  no := Arvore.Selected;
  if no.Data <> nil then
     begin
     Obj := THidroComponente(no.Data);
     Obj.VarsMonitoradas := StringsToString(lb2.Items, ';');
     end;
end;

procedure TDLG_DefinirVariaveis.btnAdicionarClick(Sender: TObject);
begin
  WinUtils.AddElemToList(lb1, lb2, False);
  DefinirVariaveis;
end;

procedure TDLG_DefinirVariaveis.btnRemoverClick(Sender: TObject);
begin
  WinUtils.DeleteElemFromList(lb2);
  DefinirVariaveis;
end;

end.

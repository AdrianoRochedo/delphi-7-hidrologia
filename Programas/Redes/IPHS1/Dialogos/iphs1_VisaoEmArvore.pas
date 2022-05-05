unit iphs1_VisaoEmArvore;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VisaoEmArvore_base, ImgList, Buttons, ExtCtrls, ComCtrls;

type
  Tiphs1_Form_VisaoEmArvore = class(TForm_VisaoEmArvore_base)
    procedure FormCreate(Sender: TObject);
  private
    procedure ReconstruirArvore; override;
    procedure ReconstroiDemandas(No: TTreeNode);
  public
    No_DMs: TTreeNode;
  end;

implementation
uses iphs1_Classes;

{$R *.DFM}

procedure Tiphs1_Form_VisaoEmArvore.FormCreate(Sender: TObject);
begin
  inherited;
  No_DMs := No_PR[3]; // Demandas
end;

procedure Tiphs1_Form_VisaoEmArvore.ReconstroiDemandas(No: TTreeNode);
var i: Integer;
    PC: Tiphs1_PC;
    nf: TTreeNode;
begin
  no.DeleteChildren;
  for i := 0 to AreaDeProjeto.Projeto.PCs.PCs-1 do
    if AreaDeProjeto.Projeto.PCs[i] is Tiphs1_PC then
       begin
       PC := Tiphs1_PC(AreaDeProjeto.Projeto.PCs[i]);
       if PC.Derivacao <> nil then
          begin
          nf := Arvore.Items.AddChildObject(no, PC.Derivacao.Nome, PC.Derivacao);
          nf.ImageIndex := 4;
          nf.SelectedIndex := 4;
          end;
       end;
end;

procedure Tiphs1_Form_VisaoEmArvore.ReconstruirArvore;
begin
  inherited;
  if AreaDeProjeto <> nil then
     ReconstroiDemandas(No_DMs)
  else
     No_DMs.DeleteChildren;
end;

end.

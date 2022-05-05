unit iphs1_EscolherObjetos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dialogo_EscolherObjeto, StdCtrls, CheckLst, hidro_Classes,
  frame_CheckListBox;

type
  Tiphs1_Dialogo_EscolherObjetos = class(TForm)
    btnOk: TButton;
    btnCancelat: TButton;
    FO: TFrameCheckListBox;
    procedure FormShow(Sender: TObject);
  private
    FProjeto: TProjeto;
    procedure MostrarObjetos;
  public
    constructor Create(Projeto: TProjeto);
    property Projeto: TProjeto read FProjeto;
  end;

implementation
uses iphs1_Classes;

{$R *.dfm}

{ Tiphs1_Dialogo_EscolherObjetos }

constructor Tiphs1_Dialogo_EscolherObjetos.Create(Projeto: TProjeto);
begin
  inherited Create(nil);
  FProjeto := Projeto;
end;

procedure Tiphs1_Dialogo_EscolherObjetos.MostrarObjetos;
var i, k  : Integer;
    PC    : TPC;
    TD    : Tiphs1_TrechoDagua;
begin
  FO.lbItems.Clear;

  // Todos os PCs
  for i := 0 to Projeto.PCs.PCs-1 do
    FO.lbItems.Items.AddObject(Projeto.PCs.PC[i].Nome, Projeto.PCs.PC[i]);

  // Todas as Sub-Bacias
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    for k := 0 to PC.SubBacias-1 do
        FO.lbItems.Items.AddObject(PC.SubBacia[k].Nome, PC.SubBacia[k]);

    if (PC.TrechoDagua <> nil) then
       begin
       TD := Tiphs1_TrechoDagua(PC.TrechoDagua);
       if TD.SubBacia <> nil then
          FO.lbItems.Items.AddObject(TD.SubBacia.Nome, TD.SubBacia);
       end;
    end;

  // Todos os Trechos-Dagua
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if (PC.TrechoDagua <> nil) then
       FO.lbItems.Items.AddObject(PC.TrechoDagua.Nome, PC.TrechoDagua);
    end;

  // Todas as Derivacoes
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if PC is Tiphs1_PC then
       if (Tiphs1_PC(PC).Derivacao <> nil) then
          FO.lbItems.Items.AddObject(Tiphs1_PC(PC).Derivacao.Nome, Tiphs1_PC(PC).Derivacao);
    end;
end;

procedure Tiphs1_Dialogo_EscolherObjetos.FormShow(Sender: TObject);
begin
  MostrarObjetos;
end;

end.

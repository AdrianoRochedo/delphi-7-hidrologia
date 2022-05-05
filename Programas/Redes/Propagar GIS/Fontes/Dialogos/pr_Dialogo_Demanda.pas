unit pr_Dialogo_Demanda;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_ClasseDeDemanda, ExtCtrls, StdCtrls, Buttons, ExtDlgs, drEdit;

type
  TprDialogo_Demanda = class(TprDialogo_ClasseDeDemanda)
    Panel3: TPanel;
    edClasse: TEdit;
    Panel4: TPanel;
    cbGrupos: TComboBox;
    Panel9: TPanel;
    edTipo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
  end;

implementation
uses pr_Const, pr_Tipos;

{$R *.DFM}

procedure TprDialogo_Demanda.FormCreate(Sender: TObject);
begin
  inherited;

  //DLG_TVU.btnAdicionar.Enabled := False;
  DLG_TVU.btnRemover.Enabled := False;
  DLG_TVU.Tipo := tdDemanda;

  //DLG_TUD.btnAdicionar.Enabled := False;
  DLG_TUD.btnRemover.Enabled := False;
  DLG_TUD.Tipo := tdDemanda;

  //DLG_TFI.btnAdicionar.Enabled := False;
  DLG_TFI.btnRemover.Enabled := False;
  DLG_TFI.Tipo := tdDemanda;
end;

procedure TprDialogo_Demanda.btnOpcoesClick(Sender: TObject);
begin
  DLG_OPC.Show;
end;

end.

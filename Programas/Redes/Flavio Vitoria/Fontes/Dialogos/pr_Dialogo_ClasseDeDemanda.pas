unit pr_Dialogo_ClasseDeDemanda;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, ExtDlgs,
  pr_Dialogo_Demanda_TVU,
  pr_Dialogo_Demanda_TUD,
  pr_Dialogo_Demanda_TFI,
  pr_Dialogo_Demanda_Opcoes,
  pr_Dialogo_Demanda_SD, drEdit;  // Sincronizacao de dados

type
  TprDialogo_ClasseDeDemanda = class(TprDialogo_Base)
    edED: TdrEdit;
    Panel5: TPanel;
    Panel7: TPanel;
    edFC: TdrEdit;
    Panel8: TPanel;
    cbStatus: TComboBox;
    Panel10: TPanel;
    Panel11: TPanel;
    edUCA: TEdit;
    Panel12: TPanel;
    edUD: TEdit;
    sbTVU: TSpeedButton;
    sbTUD: TSpeedButton;
    Panel13: TPanel;
    Label1: TLabel;
    Image: TImage;
    Open: TOpenPictureDialog;
    cbPrioridade: TComboBox;
    edFR: TdrEdit;
    Panel14: TPanel;
    sbTFI: TSpeedButton;
    btnOpcoes: TBitBtn;
    btnOpSinc: TSpeedButton;
    procedure sbTVUClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbTUDClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure sbTFIClick(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
    procedure btnOpSincClick(Sender: TObject);
  private
    { Private declarations }
  public
    ImagemMudou: Boolean;

    DLG_TVU: TprDialogo_TVU;
    DLG_TUD: TprDialogo_TUD;
    DLG_TFI: TprDialogo_TFI;
    DLG_OPC: TprDialogo_OpcoesDeDemanda;
    DLG_SD : TprDialogo_SDD; // Sincronizacao de dados das demandas
  end;

implementation
uses MessageManager, pr_Classes, pr_Const;

{$R *.DFM}

procedure TprDialogo_ClasseDeDemanda.sbTVUClick(Sender: TObject);
begin
  DLG_TVU.Show;
end;

procedure TprDialogo_ClasseDeDemanda.FormCreate(Sender: TObject);
begin
  inherited;
  DLG_TVU := TprDialogo_TVU.Create(self);
  DLG_TUD := TprDialogo_TUD.Create(self);
  DLG_TFI := TprDialogo_TFI.Create(self);
  DLG_OPC := TprDialogo_OpcoesDeDemanda.Create(self);
  DLG_SD  := TprDialogo_SDD.Create(self);
end;

procedure TprDialogo_ClasseDeDemanda.FormDestroy(Sender: TObject);
begin
  DLG_TVU.Free;
  DLG_TUD.Free;
  DLG_TFI.Free;
  DLG_OPC.Free;
  DLG_SD.Free;
  inherited;
end;

procedure TprDialogo_ClasseDeDemanda.sbTUDClick(Sender: TObject);
begin
  DLG_TUD.Show;
end;

procedure TprDialogo_ClasseDeDemanda.ImageClick(Sender: TObject);
begin
  if Open.Execute then
     begin
     Image.Picture.LoadFromFile(Open.FileName);
     ImagemMudou := True;
     end;
end;

procedure TprDialogo_ClasseDeDemanda.sbTFIClick(Sender: TObject);
begin
  DLG_TFI.Show;
end;

procedure TprDialogo_ClasseDeDemanda.btnOpcoesClick(Sender: TObject);
begin
  DLG_SD.Show;
end;

procedure TprDialogo_ClasseDeDemanda.btnOpSincClick(Sender: TObject);
begin
  DLG_OPC.Show;
end;

end.

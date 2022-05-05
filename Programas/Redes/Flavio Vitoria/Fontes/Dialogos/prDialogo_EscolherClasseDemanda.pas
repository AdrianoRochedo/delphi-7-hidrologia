unit prDialogo_EscolherClasseDemanda;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, pr_Classes;

type
  TprDialogoEscolherClasseDemanda = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbClasses: TListBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbClassesClick(Sender: TObject);
  private
    FClasses: TprListaDeClassesDemanda;
    FClasse: TprClasseDemanda;
  public
    property Classes: TprListaDeClassesDemanda read FClasses write FClasses;
    property Classe : TprClasseDemanda read FClasse;
  end;

implementation
uses pr_Const, pr_Tipos;

{$R *.DFM}

procedure TprDialogoEscolherClasseDemanda.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogoEscolherClasseDemanda.btnOkClick(Sender: TObject);
begin
  FClasse := TprClasseDemanda(lbClasses.Items.Objects[lbClasses.ItemIndex]);
  ModalResult := mrOk;
end;

procedure TprDialogoEscolherClasseDemanda.FormShow(Sender: TObject);
var s: String;
    i: Integer;
begin
  for i := 0 to Classes.Classes - 1 do
    begin
    case Classes[i].Prioridade of
      pdPrimaria   : s := '  (PRIMÁRIA)';
      pdSecundaria : s := '  (SECUNDÁRIA)';
      pdTerciaria  : s := '  (TERCIÁRIA)';
      end;
    lbClasses.Items.AddObject(Classes[i].Nome + s, Classes[i]);
    end;
end;

procedure TprDialogoEscolherClasseDemanda.lbClassesClick(Sender: TObject);
begin
  btnOk.Enabled := (lbClasses.ItemIndex > -1);
end;

end.

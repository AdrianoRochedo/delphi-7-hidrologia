unit pr_Dialogo_EscolherClasseDemanda;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, pr_Classes;

type
  TprDialogo_EscolherClasseDemanda = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbClasses: TListBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbClassesClick(Sender: TObject);
  private
    FClasses: TListaDeClassesDemanda;
    FClasse: TprClasseDemanda;
  public
    property Classes: TListaDeClassesDemanda read FClasses write FClasses;
    property Classe : TprClasseDemanda read FClasse;
  end;

implementation
uses pr_Const, pr_Tipos;

{$R *.DFM}

procedure TprDialogo_EscolherClasseDemanda.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_EscolherClasseDemanda.btnOkClick(Sender: TObject);
begin
  FClasse := TprClasseDemanda(lbClasses.Items.Objects[lbClasses.ItemIndex]);
  ModalResult := mrOk;
end;

procedure TprDialogo_EscolherClasseDemanda.FormShow(Sender: TObject);
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

procedure TprDialogo_EscolherClasseDemanda.lbClassesClick(Sender: TObject);
begin
  btnOk.Enabled := (lbClasses.ItemIndex > -1);
end;

end.

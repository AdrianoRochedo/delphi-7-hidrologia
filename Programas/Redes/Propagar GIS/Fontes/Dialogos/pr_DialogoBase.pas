unit pr_DialogoBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ErrosDLG;

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
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure SetBloqueado(const Value: Boolean);
  protected
    Erros : TErros_DLG;
  public
    Objeto : TObject;
    TabelaDeNomes: TStrings; // Tabela de Nomes dos objetos

    property Bloqueado : Boolean write SetBloqueado;
  end;

implementation
uses pr_Classes,
     pr_Const,
     SysUtilsEx;

{$R *.DFM}

procedure TprDialogo_Base.btnOkClick(Sender: TObject);
var TudoOk: Boolean;
begin
  edNome.Text := AllTrim(edNome.Text);
  
  if TabelaDeNomes.IndexOf(edNome.Text) > -1 then
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
  Erros := TErros_DLG.Create(nil);
end;

procedure TprDialogo_Base.FormDestroy(Sender: TObject);
begin
  Erros.Free;
end;

procedure TprDialogo_Base.SetBloqueado(const Value: Boolean);
begin
  btnOk.Enabled := not Value;
end;

end.

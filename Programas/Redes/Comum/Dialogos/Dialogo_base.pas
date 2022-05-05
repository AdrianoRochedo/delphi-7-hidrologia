unit Dialogo_base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, MessagesForm;

type
  TForm_Dialogo_Base = class(TForm)
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
    Erros : TfoMessages;
  public
    Objeto : TObject;
    TN     : TStrings; // Tabela de Nomes dos objetos

    property Bloqueado : Boolean write SetBloqueado;
  end;

implementation
uses Hidro_Classes,
     SysUtilsEx;

const
  cMsgErro  = 'O nome "%s" já pertence a outro objeto !'#13 +
              'Por favor, escolha um nome que não exista.';

{$R *.DFM}

procedure TForm_Dialogo_Base.btnOkClick(Sender: TObject);
var TudoOk: Boolean;
begin
  edNome.Text := AllTrim(edNome.Text);

  if TN.IndexOf(edNome.Text) > -1 then
     begin
     Erros.Add(etError, Format(cMsgErro, [edNome.Text]));
     Erros.Show;
     end
  else
     begin
     {$ifndef IPHS1}
     TudoOk := True;
     THidroComponente(Objeto).ValidarDados(TudoOk, Erros);
     if TudoOk then
        modalResult := mrOk
     else
        Erros.Show;
     {$else}
     modalResult := mrOk
     {$endif}
     end;
end;

procedure TForm_Dialogo_Base.btnCancelarClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TForm_Dialogo_Base.FormCreate(Sender: TObject);
begin
  Erros := TfoMessages.Create();
end;

procedure TForm_Dialogo_Base.FormDestroy(Sender: TObject);
begin
  Erros.Free;
end;

procedure TForm_Dialogo_Base.SetBloqueado(const Value: Boolean);
begin
  btnOk.Enabled := not Value;
end;

end.

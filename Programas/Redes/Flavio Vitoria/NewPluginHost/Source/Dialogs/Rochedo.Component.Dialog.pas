unit Rochedo.Component.Dialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, MessagesForm;

type
  TComponentDialog = class(TForm)
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
    ErrorsDialog : TfoMessages;
    Parent : TObject;
    Names : TStrings; // Tabela de Nomes dos objetos
  public
    constructor Create(Parent: TObject; Names: TStrings);
    property Lock : Boolean write SetBloqueado;
  end;

implementation
uses SysUtilsEx;

const cMsgErro = 'O nome "%s" já pertence a outro objeto !'#13 +
                 'Por favor, escolha um nome que não exista.';

{$R *.DFM}

procedure TComponentDialog.btnOkClick(Sender: TObject);
var TudoOk: Boolean;
begin
  edNome.Text := AllTrim(edNome.Text);

  if Names.IndexOf(edNome.Text) > -1 then
     begin
     ErrorsDialog.Add(etError, Format(cMsgErro, [edNome.Text]));
     ErrorsDialog.Show();
     end
  else
     begin
     TudoOk := True;
     if TudoOk then
        modalResult := mrOk
     else
        ErrorsDialog.Show();
     end;
end;

procedure TComponentDialog.btnCancelarClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TComponentDialog.FormCreate(Sender: TObject);
begin
  ErrorsDialog := TfoMessages.Create();
  {$ifdef Objetos_Nao_Editaveis}
  btnOK.Enabled := false;
  {$endif}
end;

procedure TComponentDialog.FormDestroy(Sender: TObject);
begin
  ErrorsDialog.Free();
end;

procedure TComponentDialog.SetBloqueado(const Value: Boolean);
begin
  {$ifdef Objetos_Nao_Editaveis}
  btnOK.Enabled := false;
  {$else}
  btnOk.Enabled := not Value;
  {$endif}
end;

constructor TComponentDialog.Create(Parent: TObject; Names: TStrings);
begin
  inherited Create(nil);
  self.Parent := Parent;
  self.Names := Names;
end;

end.

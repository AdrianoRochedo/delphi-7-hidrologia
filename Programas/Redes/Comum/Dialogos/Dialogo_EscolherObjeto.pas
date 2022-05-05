unit Dialogo_EscolherObjeto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, hidro_Classes;

type
  {<description>
    Permite a seleção de objetos de um determindado tipo. Para isso, o usuário deverá
    sobreescrever o método <MostrarObjetos>, o qual é responsável por encher a "ListBox" e
    associar a cada item um objeto.
  <\description>}
  TDialogoEscolherObjeto = class(TForm)
    Label1: TLabel;
    lbObjetos: TListBox;
    btnOk: TButton;
    btnCancelat: TButton;
    procedure FormShow(Sender: TObject);
  private
    FProjeto: TProjeto;
    function getSel: THidroObjeto;
    function getTemSel: Boolean;
  protected
    procedure MostrarObjetos; virtual;
  public
    constructor Create(Projeto: TProjeto);

    property TemSelecionado : Boolean      read getTemSel;
    property Selecionado    : THidroObjeto read getSel;
    property Projeto        : TProjeto     read FProjeto;
  end;

implementation

{$R *.dfm}

{ TDialogoEscolherObjeto }

constructor TDialogoEscolherObjeto.Create(Projeto: TProjeto);
begin
  inherited Create(nil);
  FProjeto := Projeto;
end;

function TDialogoEscolherObjeto.getSel: THidroObjeto;
begin
  if getTemSel then
     Result := THidroObjeto(lbObjetos.Items.Objects[lbObjetos.ItemIndex])
  else
     Result := nil;
end;

function TDialogoEscolherObjeto.getTemSel: Boolean;
begin
  Result := (lbObjetos.ItemIndex <> -1);
end;

procedure TDialogoEscolherObjeto.MostrarObjetos;
begin
  lbObjetos.Items.Clear;
end;

procedure TDialogoEscolherObjeto.FormShow(Sender: TObject);
begin
  MostrarObjetos;
end;

end.

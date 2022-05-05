unit pr_Dialogo_Projeto_Otimizavel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_Projeto, StdCtrls, Buttons, ExtCtrls,
  pr_Dialogo_Projeto_Otimizador_RU, drEdit;

type
  TprDialogo_ProjetoOtimizavel = class(TprDialogo_Projeto)
    btnOtimizacao: TButton;
    procedure btnOtimizacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    // Rotinas de Otimizacao
    RO: TprDialogo_Projeto_Otimizador_RU;
  end;

implementation

{$R *.DFM}

procedure TprDialogo_ProjetoOtimizavel.btnOtimizacaoClick(Sender: TObject);
begin
  RO.Projeto := Objeto;
  RO.Show;
end;

procedure TprDialogo_ProjetoOtimizavel.FormCreate(Sender: TObject);
begin
  inherited;
  RO := TprDialogo_Projeto_Otimizador_RU.Create(self);
end;

procedure TprDialogo_ProjetoOtimizavel.FormDestroy(Sender: TObject);
begin
  RO.Free;
  inherited;
end;

end.

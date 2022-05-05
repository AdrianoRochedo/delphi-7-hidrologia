unit pr_Dialogo_Projeto_Rosenbrock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_Projeto, StdCtrls, Buttons, ExtCtrls,
  pr_Dialogo_Projeto_Rosenbrock_RU, drEdit;

type
  TprDialogo_ProjetoRosen = class(TprDialogo_Projeto)
    btnOtimizacao: TButton;
    procedure btnOtimizacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    RotinasRosenbrock: TprDialogo_Projeto_Rosenbrock_RU;
  end;

implementation

{$R *.DFM}

procedure TprDialogo_ProjetoRosen.btnOtimizacaoClick(Sender: TObject);
begin
  RotinasRosenbrock.Projeto := Objeto;
  RotinasRosenbrock.Show;
end;

procedure TprDialogo_ProjetoRosen.FormCreate(Sender: TObject);
begin
  inherited;
  RotinasRosenbrock := TprDialogo_Projeto_Rosenbrock_RU.Create(self);
end;

procedure TprDialogo_ProjetoRosen.FormDestroy(Sender: TObject);
begin
  RotinasRosenbrock.Free;
  inherited;
end;

end.

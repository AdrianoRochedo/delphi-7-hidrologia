unit cd_Form_Resultados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cd_ClassesBase, cd_Classes, ExtCtrls;

type
  TfoResultados = class(TForm)
    Saida: TMemo;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDados: TManagement;
  public
    constructor Create(Dados: TManagement);
  end;

implementation
uses SysUtilsEx,
     MessageManager;

{$R *.dfm}

{ TfoResultados }

constructor TfoResultados.Create(Dados: TManagement);
begin
  inherited Create(nil);
  FDados := Dados;
end;

procedure TfoResultados.FormShow(Sender: TObject);
begin
  Caption := 'Dados de ' + FDados.Description;

  Saida.Lines.Add('  Vazão da Bomba a n_horas/dia (VB): ...................... ' + toString(FDados.VB));
  Saida.Lines.Add('  Vazão da Bomba no Sistema de Irrigação (VB_SI): ............. ' + toString(FDados.VB_SI));
  Saida.Lines.Add('');

  FDados.Years.ShowAsText(Saida.Lines);
  Saida.Lines.Add('');
  if (FDados.Irrigate) and (FDados.Reqs <> nil) then
     FDados.Reqs.Print(Saida.Lines);
end;

procedure TfoResultados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  getMessageManager.SendMessage(UM_FormDestroy, [self]);
  Action := caFree;
end;

end.

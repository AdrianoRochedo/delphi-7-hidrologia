unit iphs1_Dialogo_TD_Alagamentos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, iphs1_Classes;

type
  Tiphs1_fo_TD_Alagamentos = class(TForm)
    M: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    constructor Create(Projeto: Tiphs1_Projeto);
  end;

implementation
uses SysUtilsEx;

{$R *.dfm}

{ Tiphs1_fo_TD_Alagamentos }

constructor Tiphs1_fo_TD_Alagamentos.Create(Projeto: Tiphs1_Projeto);
var i: Integer;
    TD: Tiphs1_TrechoDagua;
begin
  inherited Create(nil);
  Caption := Projeto.Nome + ' - Alagamentos (' + TimeToStr(Time) + ')'; 
  M.Lines.Add(Format('%20s %15s %15s', ['Nome', 'Volume (m³)', 'Duração (min)']));
  for i := 0 to Projeto.PCs.PCs-1 do
    if Projeto.PCs[i].TrechoDagua <> nil then
       begin
       TD := Tiphs1_TrechoDagua(Projeto.PCs[i].TrechoDagua);
       M.Lines.Add(Format('%20s %15.2f %15.2f', [TD.Nome, TD.Alagamento_Volume, TD.Alagamento_Duracao]));
       end;
end;

procedure Tiphs1_fo_TD_Alagamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

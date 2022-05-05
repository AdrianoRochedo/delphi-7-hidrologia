unit pr_Dialogo_PC_Energia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, drEdit, ExtCtrls;

type
  TprDialogo_PC_Energia = class(TForm)
    Panel7: TPanel;
    edRSA: TdrEdit;
    Panel1: TPanel;
    edRT: TdrEdit;
    Panel2: TPanel;
    edRG: TdrEdit;
    Panel3: TPanel;
    edVMT: TdrEdit;
    Panel4: TPanel;
    edX: TdrEdit;
    Painel: TPanel;
    btnACDE: TSpeedButton;
    Panel5: TPanel;
    edDE: TdrEdit;
    Panel6: TPanel;
    edACDE: TdrEdit;
    btnOk: TBitBtn;
    procedure btnACDEClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FObjeto: TObject;
    FTipo: byte;
  public
    constructor Create(Objeto: TObject);
    property Tipo: byte read FTipo write FTipo;  // 1 = PC    2 = Reservatório
  end;

implementation
uses FileUtils, pr_Const, pr_Vars, pr_Classes;

{$R *.dfm}

procedure TprDialogo_PC_Energia.btnACDEClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir) then
     begin
     TprPCP(FObjeto).Projeto.RetirarCaminhoSePuder(s);
     edACDE.Text := s;
     end;
end;

constructor TprDialogo_PC_Energia.Create(Objeto: TObject);
begin
  inherited Create(nil);
  FObjeto := Objeto;
end;

procedure TprDialogo_PC_Energia.FormShow(Sender: TObject);
begin
  if FTipo = 1 then
     Panel4.Caption := ' Queda Hidráulica: (m)'
  else
     Panel4.Caption := ' Cota de Jusante da Usina: (m)'
end;

end.

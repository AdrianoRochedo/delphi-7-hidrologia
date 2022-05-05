unit pr_Dialogo_Demanda_TVU_Distribuir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pr_Dialogo_Demanda_TVU, StdCtrls, drEdit, gridx32, Buttons,
  CheckLst;

type
  TprDialogo_TVU_Distribuir = class(TprDialogo_TVU)
    Label4: TLabel;
    lbDemandas: TCheckListBox;
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure lbDemandasDblClick(Sender: TObject);
  private
    procedure AtribuirValoresUnitarios(const Item: String);
  public
    { Public declarations }
  end;

implementation
uses WinUtils,
     pr_Funcoes,
     pr_Classes,
     pr_tipos;

{$R *.dfm}

procedure TprDialogo_TVU_Distribuir.btnAdicionarClick(Sender: TObject);
begin
  VerificarIntervalo();
  AdicionarDados();
end;

procedure TprDialogo_TVU_Distribuir.FormShow(Sender: TObject);
var SL: TStrings;
    i: Integer;
begin
  inherited;
  SL := TStringList.Create;
  ObterDemandasPelaClasse('TODAS', SL, Projeto);
  TStringList(SL).Sort;
  for i := 0 to SL.Count-1 do
    lbDemandas.Items.Add(SL[i]);
  SL.Free;
end;

procedure TprDialogo_TVU_Distribuir.AtribuirValoresUnitarios(const Item: String);
var Nome: String;
    DM: TprDemanda;
    Tab: TaRecVU;
begin
  Nome := Copy(Item, Pos(']', Item) + 2, 100);
  DM := TprDemanda(ObterObjetoPeloNome(Nome, Projeto));
  Obter(Tab);
  DM.TabValoresUnitarios := Tab;
end;

procedure TprDialogo_TVU_Distribuir.btnOkClick(Sender: TObject);
var i: Integer;
begin
  if MessageDLG('Os valores unitários das demandas serão sobreescritos'#13 +
                'Você deseja continuar ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
     StartWait();
     for i := 0 to lbDemandas.Items.Count-1 do
       if lbDemandas.Checked[i] then
          begin
          AtribuirValoresUnitarios(lbDemandas.Items[i]);
          lbDemandas.ItemEnabled[i] := false;
          end;
     StopWait();
     lbDemandas.Invalidate;
     end;
end;

procedure TprDialogo_TVU_Distribuir.lbDemandasDblClick(Sender: TObject);
begin
  if lbDemandas.ItemIndex > -1 then
     lbDemandas.ItemEnabled[lbDemandas.ItemIndex] := true;
end;

end.

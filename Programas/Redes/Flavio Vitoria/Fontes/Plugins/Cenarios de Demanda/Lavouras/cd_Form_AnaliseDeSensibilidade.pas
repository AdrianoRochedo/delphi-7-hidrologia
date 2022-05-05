unit cd_Form_AnaliseDeSensibilidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, drEdit, ExtCtrls,
  MessageManager,
  SpreadSheetBook,
  cd_Classes;

type
  TfoAnaliseDeSens = class(TForm, IMessageReceptor)
    Label1: TLabel;
    cbV: TComboBox;
    Label2: TLabel;
    edIV: TdrEdit;
    Label3: TLabel;
    edI: TdrEdit;
    Label4: TLabel;
    edSC: TdrEdit;
    Label5: TLabel;
    cbDV: TComboBox;
    Bevel1: TBevel;
    btnSim: TButton;
    btnClose: TButton;
    procedure btnSimClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FC: TCrop;
    Fp: TSpreadSheetBook;

    // Iniciado em Falso
    FAutoClose: boolean;

    procedure setVarValue(const Value: real);
    procedure calculateDecisionVar(m: TManagement; R, C: integer);
    function ReceiveMessage(const MSG: TadvMessage): Boolean;
  public
    constructor Create(C: TCrop);
    destructor Destroy(); override;
  end;

implementation
uses SysUtilsEx,
     ObjectListEx;

{$R *.dfm}

{ TfoAnaliseDeSens }

constructor TfoAnaliseDeSens.Create(C: TCrop);
begin
  inherited Create(nil);
  FC := C;
  getMessageManager.RegisterMessage(OL_RemoveObject, self);
end;

destructor TfoAnaliseDeSens.Destroy;
begin
  getMessageManager.UnregisterMessage(OL_RemoveObject, self);
  inherited;
end;

procedure TfoAnaliseDeSens.calculateDecisionVar(m: TManagement; R, C: integer);
var s: string;
begin
  case cbDV.itemIndex of
    0: Fp.ActiveSheet.Write(R, C, m.Years.Mean('LiquidNetProfit'));
    1: Fp.ActiveSheet.Write(R, C, m.Years.StdDev('LiquidNetProfit'));
    2: Fp.ActiveSheet.Write(R, C, m.Years.Mean('LimProdForRevenue'));
  end;
end;

procedure TfoAnaliseDeSens.setVarValue(const Value: real);
begin
  if cbV.ItemIndex = -1 then
     raise Exception.Create('Choose a variable !');

  case cbV.ItemIndex of
     0: FC.BaseYield      := Value;
     1: FC.CultivatedArea := Value;
     2: FC.NetIncome      := Value;

     3: FC.Sys_FlowRate      := Value;
     4: FC.Sys_PressureHead  := Value;
     5: FC.Sys_Efficiency    := Value;
     6: FC.Sys_PumpEffic     := Value;
     7: FC.Sys_Life          := Value;
     8: FC.Sys_AnualIR       := Value;

     9: FC.WaterPrice  := Value;
    10: FC.EnergyPrice := Value;

    11: FC.Labor_Persons    := Value;
    12: FC.Labor_CostHourly := Value;
  end;
end;

procedure TfoAnaliseDeSens.btnSimClick(Sender: TObject);
var C, L, S, i, j: integer;
    x, y: real;
    m: TManagement;
begin
  if Fp = nil then
     begin
     Fp := TSpreadSheetBook.Create(' ' + FC.Name + ' - ' + Caption, cbV.Text);
     FC.AddResult(Fp);
     end
  else
     Fp.NewSheet(cbV.Text);

  S := edSC.AsInteger;
  x := edIV.AsFloat;
  y := edI.AsFloat;

  // Escreve o cabecalho das colunas
  L := 4;
  C := 2;
  for i := 1 to S do
    begin
    Fp.ActiveSheet.Write(L, C, x);
    x := x + y;
    C := C + 1;
    end;
  Fp.ActiveSheet.BoldRow(L);

  // Escreve os títulos da planilha
  Fp.ActiveSheet.Merge(1, 2, 1, C-1);
  Fp.ActiveSheet.Merge(2, 2, 2, C-1);
  Fp.ActiveSheet.WriteCenter(1, 2, cbDV.Text);
  Fp.ActiveSheet.WriteCenter(2, 2, cbV.Text);
  Fp.ActiveSheet.BoldRow(1);
  Fp.ActiveSheet.BoldRow(2);

  // Escreve o cabecalho das linhas
  L := 5;
  C := 1;
  for i := 0 to FC.Managements.Count-1 do
    begin
    Fp.ActiveSheet.Write(L, C, 'Man ' + toString(i));
    L := L + 1;
    end;
  Fp.ActiveSheet.BoldCol(C);

  // Recupera o valor inicial
  x := edIV.AsFloat;

  // Calcula os valores por manejo
  L := 5;
  for i := 0 to FC.Managements.Count-1 do
    begin
    m := FC.Managements.Item[i];

    C := 2;
    for j := 1 to S do
      begin
      setVarValue(x);
      calculateDecisionVar(m, L, C);

      // Proximo valor a ser simulado
      x := x + y;
      C := C + 1;
      end;

    // Proximo Manejo
    L := L + 1;
    end;

  Fp.Show();
end;

procedure TfoAnaliseDeSens.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfoAnaliseDeSens.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfoAnaliseDeSens.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = OL_RemoveObject then
     if MSG.ParamAsPointer(0) = Fp then
        Fp := nil;
end;

end.

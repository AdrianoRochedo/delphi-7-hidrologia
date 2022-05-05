unit cd_Form_DadosGerais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, drEdit, gridx32, ExtCtrls, StdCtrls, Menus;

type
  TfoDadosGerais = class(TForm)
    edAnos: TEdit;
    Panel9: TPanel;
    Panel10: TPanel;
    sgRCNI: TdrStringAlignGrid;
    Panel11: TPanel;
    sgRCI: TdrStringAlignGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    sgRPLC: TdrStringAlignGrid;
    Panel3: TPanel;
    sgVPM: TdrStringAlignGrid;
    Panel4: TPanel;
    sgVPA: TdrStringAlignGrid;
    Panel5: TPanel;
    edLat: TdrEdit;
    Panel6: TPanel;
    edLon: TdrEdit;
    Panel7: TPanel;
    edAlt: TdrEdit;
    Panel8: TPanel;
    Panel12: TPanel;
    edAn: TdrEdit;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    rbSemChuva: TRadioButton;
    rbComChuva: TRadioButton;
    Panel16: TPanel;
    Panel17: TPanel;
    rbSeco: TRadioButton;
    rbMedio: TRadioButton;
    rbUmido: TRadioButton;
    Panel18: TPanel;
    Panel19: TPanel;
    cbSistema: TComboBox;
    Panel20: TPanel;
    Panel21: TPanel;
    rbNatureza: TRadioButton;
    rbProdMax: TRadioButton;
    rbComDef: TRadioButton;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    btnOk: TButton;
    Menu_Grade: TPopupMenu;
    Menu_PreencherValor: TMenuItem;
    edArea: TdrEdit;
    edInt: TdrEdit;
    edHorasOper: TdrEdit;
    edEf: TdrEdit;
    Panel27: TPanel;
    Panel28: TPanel;
    edCusto: TdrEdit;
    Panel29: TPanel;
    Panel30: TPanel;
    cbAlimentos: TComboBox;
    edCalorias: TdrEdit;
    Panel31: TPanel;
    Panel32: TPanel;
    edProt: TdrEdit;
    Panel33: TPanel;
    edGord: TdrEdit;
    Panel34: TPanel;
    edCalcio: TdrEdit;
    procedure edAnosExit(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure Menu_PreencherValorClick(Sender: TObject);
    procedure Menu_GradePopup(Sender: TObject);
    procedure cbSistemaChange(Sender: TObject);
    procedure cbAlimentosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ConfiguraTab(sg: TdrStringAlignGrid; i1, i2: Integer);
  public
    { Public declarations }
  end;

implementation
uses SysUtilsEx,
     cd_Classes;

{$R *.dfm}

procedure TfoDadosGerais.edAnosExit(Sender: TObject);
var s1, s2: string;
    i1, i2, k: integer;
begin
  if System.Pos('-', edAnos.Text) > 0 then
     begin
     SysUtilsEx.SubStrings('-', s1, s2, edAnos.Text, true);
     i1 := strToIntDef(s1, -1);
     i2 := strToIntDef(s2, -1);
     if (i1 <> -1) and (i2 <> -1) and (i2 >= i1) then
        begin
        ConfiguraTab(sgRCNI, i1, i2);
        ConfiguraTab(sgRCI , i1, i2);
        ConfiguraTab(sgVPA , i1, i2);
        ConfiguraTab(sgVPM , i1, i2);
        ConfiguraTab(sgRPLC, i1, i2);
        end;
     end
  else
     begin
     ConfiguraTab(sgRCNI, -1, -1);
     ConfiguraTab(sgRCI , -1, -1);
     ConfiguraTab(sgVPA , -1, -1);
     ConfiguraTab(sgVPM , -1, -1);
     ConfiguraTab(sgRPLC, -1, -1);
     end;
end;

procedure TfoDadosGerais.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TfoDadosGerais.ConfiguraTab(sg: TdrStringAlignGrid; i1, i2: Integer);
var k: Integer;
begin
  if i1 = -1 then
     begin
     sg.ColCount := 1;
     sg.Cells[0, 0] := edAnos.Text;
     end
  else
     begin
     sg.ColCount := i2 - i1 + 1;
     for k := 0 to sg.ColCount-1 do
       sg.Cells[k, 0] := toString(i1 + k);
     end;
end;

procedure TfoDadosGerais.Menu_PreencherValorClick(Sender: TObject);
var sg: TdrStringAlignGrid;
     v: string;
     i: integer;
begin
  v := '1000';
  sg := TdrStringAlignGrid(TComponent(Sender).Tag);
  if Dialogs.InputQuery(' Preencher Valores', 'Entre com um valor:', v) then
     for i := 0 to sg.ColCount-1 do
        sg.Cells[i, 1] := v;
end;

procedure TfoDadosGerais.Menu_GradePopup(Sender: TObject);
begin
  Menu_PreencherValor.Tag := integer(self.ActiveControl);
end;

procedure TfoDadosGerais.cbSistemaChange(Sender: TObject);
begin
  edEf.AsFloat := cd_Classes.EficienciaDoSistema(cbSistema.ItemIndex);
  edCusto.AsInteger := cd_Classes.CustoPorHectar(cbSistema.ItemIndex);
end;

procedure TfoDadosGerais.cbAlimentosChange(Sender: TObject);
begin
  edCalorias.AsInteger := cd_Classes.Calorias(cbAlimentos.ItemIndex);
  edProt.AsInteger     := cd_Classes.Proteinas(cbAlimentos.ItemIndex);
  edGord.AsInteger     := cd_Classes.Gorduras(cbAlimentos.ItemIndex);
  edCalcio.AsFloat     := cd_Classes.Calcio(cbAlimentos.ItemIndex);
end;

procedure TfoDadosGerais.FormCreate(Sender: TObject);
begin
  cd_Classes.AlimentosToStrings(cbAlimentos.Items);
end;

end.

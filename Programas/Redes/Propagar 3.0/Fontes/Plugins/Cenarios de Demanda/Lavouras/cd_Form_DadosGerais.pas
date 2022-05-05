unit cd_Form_DadosGerais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, drEdit, gridx32, ExtCtrls, StdCtrls, Menus, ComCtrls, Buttons,
  cd_Frame_Sensibilidade;

type
  TfoDadosGerais = class(TForm)
    Menu_Grade: TPopupMenu;
    Menu_PreencherValor: TMenuItem;
    Book: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    edLat: TdrEdit;
    Panel6: TPanel;
    edLon: TdrEdit;
    Panel7: TPanel;
    edAlt: TdrEdit;
    Panel8: TPanel;
    Panel12: TPanel;
    edAn: TdrEdit;
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
    Panel18: TPanel;
    Panel19: TPanel;
    cbSistema: TComboBox;
    Panel20: TPanel;
    Panel21: TPanel;
    rbNatureza: TRadioButton;
    rbProdMax: TRadioButton;
    rbComDef: TRadioButton;
    edEf: TdrEdit;
    Panel27: TPanel;
    Panel28: TPanel;
    edCustoInst: TdrEdit;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    edArea: TdrEdit;
    edInt: TdrEdit;
    edHorasOper: TdrEdit;
    TabSheet2: TTabSheet;
    edAnos: TEdit;
    Panel9: TPanel;
    Panel22: TPanel;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    sgRPLC: TdrStringAlignGrid;
    Panel3: TPanel;
    sgVPM: TdrStringAlignGrid;
    Panel4: TPanel;
    sgVPA: TdrStringAlignGrid;
    TabSheet5: TTabSheet;
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
    Panel35: TPanel;
    sgRPCNI: TdrStringAlignGrid;
    Panel36: TPanel;
    sgRPCI: TdrStringAlignGrid;
    sb2: TSpeedButton;
    sb3: TSpeedButton;
    sb4: TSpeedButton;
    sb5: TSpeedButton;
    sb6: TSpeedButton;
    edC: TEdit;
    Panel37: TPanel;
    edS: TEdit;
    Panel38: TPanel;
    edP: TEdit;
    Panel39: TPanel;
    edE: TEdit;
    Panel40: TPanel;
    edA: TEdit;
    Panel41: TPanel;
    edPasta: TEdit;
    Panel42: TPanel;
    Panel43: TPanel;
    Open: TOpenDialog;
    Panel44: TPanel;
    btnOk: TButton;
    Button1: TButton;
    Panel45: TPanel;
    edCustoMan: TdrEdit;
    Panel46: TPanel;
    edProb: TdrEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    edMU: TdrEdit;
    procedure edAnosExit(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure Menu_PreencherValorClick(Sender: TObject);
    procedure Menu_GradePopup(Sender: TObject);
    procedure cbSistemaChange(Sender: TObject);
    procedure cbAlimentosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Arquivos_Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ConfiguraTab(sg: TdrStringAlignGrid; i1, i2: Integer);
  public
    { Public declarations }
  end;

implementation
uses SysUtilsEx,
     cd_Classes;

{$R *.dfm}

const
  Exts : array[1..5] of string = ('cul', 'sol', 'pre', 'et0', 'asc');

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
        ConfiguraTab(sgRPCNI, i1, i2);
        ConfiguraTab(sgRPCI , i1, i2);
        ConfiguraTab(sgVPA  , i1, i2);
        ConfiguraTab(sgVPM  , i1, i2);
        ConfiguraTab(sgRPLC , i1, i2);
        end;
     end
  else
     begin
     ConfiguraTab(sgRPCNI, -1, -1);
     ConfiguraTab(sgRPCI , -1, -1);
     ConfiguraTab(sgVPA  , -1, -1);
     ConfiguraTab(sgVPM  , -1, -1);
     ConfiguraTab(sgRPLC , -1, -1);
     end;
end;

procedure TfoDadosGerais.btnOkClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
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
  if Dialogs.InputQuery(' Fill Values', 'Enter a value:', v) then
     for i := 0 to sg.ColCount-1 do
        sg.Cells[i, 1] := v;
end;

procedure TfoDadosGerais.Menu_GradePopup(Sender: TObject);
begin
  Menu_PreencherValor.Tag := integer(self.ActiveControl);
end;

procedure TfoDadosGerais.cbSistemaChange(Sender: TObject);
begin
  edEf.AsString := Format('%f - %f',
    [cd_Classes.EficienciaMinimaDoSistema(cbSistema.ItemIndex),
     cd_Classes.EficienciaMaximaDoSistema(cbSistema.ItemIndex)]);

  edCustoInst.AsString := Format('%d - %d',
    [cd_Classes.CustoMinimoDeInstalacaoPorHectar(cbSistema.ItemIndex),
     cd_Classes.CustoMaximoDeInstalacaoPorHectar(cbSistema.ItemIndex)]);

  edCustoMan.AsString := Format('%d - %d',
    [cd_Classes.CustoMinimoDeManutencaoPorHectar(cbSistema.ItemIndex),
     cd_Classes.CustoMaximoDeManutencaoPorHectar(cbSistema.ItemIndex)]);
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
  cd_Classes.SistemasDeIrrigacao(cbSistema.Items);
  cd_Classes.AlimentosToStrings(cbAlimentos.Items);
end;

procedure TfoDadosGerais.Arquivos_Click(Sender: TObject);
var s: string;
begin
  s := Exts[TSpeedButton(Sender).Tag];
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := s;
  Open.Filter := Format('Files %s|*.%s', [UpperCase(s), s]);
  if Open.Execute() then
     begin
     s := ExtractRelativePath(edPasta.Text, Open.FileName);
     case TSpeedButton(Sender).Tag of
       1: edC.Text := s;
       2: edS.Text := s;
       3: edP.Text := s;
       4: edE.Text := s;
       5: edA.Text := s;
       end;
     end;
end;

procedure TfoDadosGerais.Button1Click(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

end.

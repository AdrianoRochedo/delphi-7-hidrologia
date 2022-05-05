unit iphs1_Dialogo_Base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Dialogo_base, StdCtrls, Buttons, ExtCtrls, drEdit, Menus;

type
  Tiphs1_Form_Dialogo_Base = class(TForm_Dialogo_Base)
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    rbPDO: TRadioButton;
    RadioButton6: TRadioButton;
    edObs: TEdit;
    sbObs: TSpeedButton;
    edOper: TdrEdit;
    edVMin: TdrEdit;
    edVMax: TdrEdit;
    Menu_DO: TPopupMenu;
    MenuDO_SelecionarArquivo: TMenuItem;
    MenuDO_DigitarValores: TMenuItem;
    GerarValoresporumaIDF1: TMenuItem;
    procedure rbPDOClick(Sender: TObject);
    procedure rbGHC_Click(Sender: TObject);
    procedure MenuDO_SelecionarArquivoClick(Sender: TObject);
    procedure MenuDO_DigitarValoresClick(Sender: TObject);
    procedure sbObsClick(Sender: TObject);
    procedure GerarValoresporumaIDF1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses WinUtils,
     DialogUtils,
     hidro_Variaveis,
     hidro_Classes,
     iphs1_Classes,
     iphs1_Procs,
     Planilha_EntradaDeValores;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_Base.rbPDOClick(Sender: TObject);
begin
  SetEnable([edObs, sbOBS], rbPDO.Checked);
end;

procedure Tiphs1_Form_Dialogo_Base.rbGHC_Click(Sender: TObject);
begin
  inherited;
  SetEnable([edVMin, edVMax, Panel4, Panel5], {rbGHC.Checked} True);
end;

procedure Tiphs1_Form_Dialogo_Base.MenuDO_SelecionarArquivoClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir) then
     begin
     gDir := ExtractFilePath(s);
     THidroComponente(Objeto).RetirarCaminhoSePuder(s);
     edObs.Text := s;
     end;
end;

procedure Tiphs1_Form_Dialogo_Base.MenuDO_DigitarValoresClick(Sender: TObject);
begin
  edObs.Text := EntrarValores_e_SalvarComoTexto(gDir,
                  Tiphs1_Projeto(THidroObjeto(Objeto).Projeto).NIT);
end;

procedure Tiphs1_Form_Dialogo_Base.sbObsClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(sbObs.Left, sbObs.Top);
  P := ClientToScreen(P);
  Menu_DO.Popup(P.x, P.y);
end;

procedure Tiphs1_Form_Dialogo_Base.GerarValoresporumaIDF1Click(Sender: TObject);
begin
  edObs.Text := iphs1_Procs.ObterDadosDeUmaCurvaIDF();
end;

end.

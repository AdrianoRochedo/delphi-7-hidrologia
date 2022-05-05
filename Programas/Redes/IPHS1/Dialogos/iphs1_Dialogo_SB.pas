unit iphs1_Dialogo_SB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  iphs1_Dialogo_Base, StdCtrls, Buttons, ExtCtrls,
  iphs1_Dialogo_SB_TCV,
  iphs1_Classes, drEdit, Menus;

type
  Tiphs1_Form_Dialogo_SB = class(Tiphs1_Form_Dialogo_Base)
    Panel9: TPanel;
    rbTCV: TRadioButton;
    rbH: TRadioButton;
    Panel10: TPanel;
    edH: TEdit;
    sbH: TSpeedButton;
    sbDLG_TCV: TSpeedButton;
    Panel11: TPanel;
    edPM: TdrEdit;
    Menu_Hidrograma: TPopupMenu;
    Menu_SelecionarArquivo: TMenuItem;
    Menu_DigitarValores: TMenuItem;
    GerarValoresporumaIDF2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbDLG_TCVClick(Sender: TObject);
    procedure sbHClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure rbTCVClick(Sender: TObject);
    procedure rbHClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_SelecionarArquivoClick(Sender: TObject);
    procedure Menu_DigitarValoresClick(Sender: TObject);
    procedure GerarValoresporumaIDF2Click(Sender: TObject);
  private
    FSB: Tiphs1_SubBacia;
  public
    DLG_TCV: Tiphs1_Form_Dialogo_SB_TCV;
    property SubBacia : Tiphs1_SubBacia read FSB write FSB;
  end;

implementation
uses hidro_Classes,
     hidro_Variaveis,
     hidro_Constantes,
     hidro_Procs,
     iphs1_Procs,
     iphs1_Tipos,
     DialogUtils,
     Planilha_EntradaDeValores,
     WinUtils;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB.FormCreate(Sender: TObject);
begin
  inherited;
  FSB := Tiphs1_SubBacia.Create(Point(0,0), nil, nil);
  DLG_TCV := Tiphs1_Form_Dialogo_SB_TCV.Create(self);
  DLG_TCV.SubBacia := FSB;
end;

procedure Tiphs1_Form_Dialogo_SB.FormDestroy(Sender: TObject);
begin
  FSB.Free;
  DLG_TCV.Free;
  inherited;
end;

procedure Tiphs1_Form_Dialogo_SB.sbDLG_TCVClick(Sender: TObject);
begin
  inherited;
  DLG_TCV.ShowModal;
end;

procedure Tiphs1_Form_Dialogo_SB.sbHClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(sbH.Left, sbH.Top);
  P := panel9.ClientToScreen(P);
  Menu_Hidrograma.Popup(P.x, P.y);
end;

procedure Tiphs1_Form_Dialogo_SB.FormShow(Sender: TObject);
begin
  inherited;
  if FSB.Tipo = sbTCV then rbTCV.Checked := True else rbH.Checked := True;
  edH.Text := FSB.Hidrograma;
end;

procedure Tiphs1_Form_Dialogo_SB.btnOkClick(Sender: TObject);
begin
  inherited;
  if rbTCV.Checked then FSB.Tipo := sbTCV else FSB.Tipo := sbHidrograma;
  FSB.Hidrograma := edH.Text;
end;

procedure Tiphs1_Form_Dialogo_SB.rbTCVClick(Sender: TObject);
begin
  SetEnable([edH, sbH], rbH.Checked);
  SetEnable([sbDLG_TCV], rbTCV.Checked);
  FSB.IB.Oper := iphs1_Tipos.coTCV;
  FSB.Tipo := iphs1_Tipos.sbTCV;
end;

procedure Tiphs1_Form_Dialogo_SB.rbHClick(Sender: TObject);
begin
  SetEnable([edH, sbH], rbH.Checked);
  SetEnable([sbDLG_TCV], rbTCV.Checked);
  FSB.IB.Oper := iphs1_Tipos.coH;
  FSB.Tipo := iphs1_Tipos.sbHidrograma;
end;

procedure Tiphs1_Form_Dialogo_SB.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('EdicaoDosObjetos.htm#SB');
end;

procedure Tiphs1_Form_Dialogo_SB.Menu_SelecionarArquivoClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir, cFiltroTexto) then
     begin
     TSubBacia(Objeto).RetirarCaminhoSePuder(s);
     edH.Text := s;
     end;
end;

procedure Tiphs1_Form_Dialogo_SB.Menu_DigitarValoresClick(Sender: TObject);
begin
  edH.Text := EntrarValores_e_SalvarComoTexto(gDir,
                 Tiphs1_Projeto(TSubBacia(Objeto).Projeto).NIT);
end;

procedure Tiphs1_Form_Dialogo_SB.GerarValoresporumaIDF2Click(Sender: TObject);
begin
  edH.Text := iphs1_Procs.ObterDadosDeUmaCurvaIDF;
end;

end.

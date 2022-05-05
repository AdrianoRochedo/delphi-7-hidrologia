unit iphs1_Dialogo_Projeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Dialogo_Projeto, StdCtrls, Buttons, ExtCtrls, Menus, drEdit;

type
  Tiphs1_Form_Dialogo_Projeto = class(TForm_Dialogo_Projeto)
    Panel5: TPanel;
    Panel3: TPanel;
    lbPCs: TListBox;
    btnAdicionarPC: TButton;
    btnRemoverPC: TButton;
    Panel4: TPanel;
    Panel6: TPanel;
    Menu_Postos: TPopupMenu;
    Menu1: TMenuItem;
    Menu2: TMenuItem;
    edNIT: TdrEdit;
    edNITC: TdrEdit;
    edTIT: TdrEdit;
    Menu_DO: TPopupMenu;
    MenuDO_SelecionarArquivo: TMenuItem;
    MenuDO_DigitarValores: TMenuItem;
    procedure btnAdicionarPC_Click(Sender: TObject);
    procedure btnRemoverPC_Click(Sender: TObject);
    procedure MenuPostos_Click(Sender: TObject);
    procedure edNITCChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuDO_DigitarValoresClick(Sender: TObject);
    procedure btnAdicionarPCClick(Sender: TObject);
    procedure Menu_IDF_Click(Sender: TObject);
  private
    function Existe(const s: String): Boolean;
    function EscolherTipoTormenta: String;
  public
    { Public declarations }
  end;

implementation
uses hidro_Classes,
     hidro_Variaveis,
     hidro_Constantes,
     iphs1_procs,
     DialogUtils,
     WinUtils,
     SysUtilsEx,
     DialogsEx,
     Planilha_EntradaDeValores;

{$R *.DFM}

function Tiphs1_Form_Dialogo_Projeto.Existe(const s: String): Boolean;
var ss: String;
     i: Integer;
begin
  Result := False;
  for i := 0 to lbPCs.Items.Count-1 do
    begin
    ss := SubString(lbPCs.Items[i], '[', ']');
    if ss = s then
       begin
       Result := True;
       Break;
       end
    end;
end;

procedure Tiphs1_Form_Dialogo_Projeto.btnAdicionarPC_Click(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir, cFiltroTexto) then
     begin
     TProjeto(Objeto).RetirarCaminhoSePuder(s);

     if not Existe(s) then
        lbPCs.Items.Add(s + ' : ' + EscolherTipoTormenta);
     end;
end;

procedure Tiphs1_Form_Dialogo_Projeto.btnRemoverPC_Click(Sender: TObject);
begin
  DeleteElemFromListEx(lbPCs);
end;

procedure Tiphs1_Form_Dialogo_Projeto.MenuPostos_Click(Sender: TObject);
var p: byte;
    s: String;
begin
  if lbPCs.ItemIndex > -1 then
     begin
     s := lbPCs.Items[lbPCs.ItemIndex];

     p := System.Pos(' : ', s);
     Delete(s, p+3, 50);

     if TComponent(Sender).Tag = 1 then
        s := s + 'Tormenta Desagregada'
     else
        s := s + 'Tormenta Acumulada';

     lbPCs.Items[lbPCs.ItemIndex] := s;
     end;
end;

procedure Tiphs1_Form_Dialogo_Projeto.edNITCChange(Sender: TObject);
var b: Boolean;
begin
  b := edNITC.AsInteger > 0;
  lbPCs.Enabled := b;
  btnAdicionarPC.Enabled := b;
  btnRemoverPC.Enabled := b;
end;

procedure Tiphs1_Form_Dialogo_Projeto.FormShow(Sender: TObject);
begin
  inherited;
  edNITCChange(nil);
end;

procedure Tiphs1_Form_Dialogo_Projeto.MenuDO_DigitarValoresClick(Sender: TObject);
var s: String;
begin
  MessageDLG('ATENÇÃO:'#13#13 +
             'Será pedido a você que digite tantos valores'#13 +
             'quanto o número de Intervalos de Tempo com Chuva.'#13 +
             'Após, será pedido o nome do arquivo para salvamento dos dados.',
             mtInformation, [mbOK], 0);

  s := EntrarValores_e_SalvarComoTexto(gDir, edNITC.AsInteger);
  if s <> '' then
     begin
     TProjeto(Objeto).RetirarCaminhoSePuder(s);

     if not Existe(s) then
        lbPCs.Items.Add(s + ' : ' + EscolherTipoTormenta);
     end;
end;

procedure Tiphs1_Form_Dialogo_Projeto.btnAdicionarPCClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(btnAdicionarPC.Left, btnAdicionarPC.Top);
  P := ClientToScreen(P);
  Menu_DO.Popup(P.x, P.y);
end;

procedure Tiphs1_Form_Dialogo_Projeto.Menu_IDF_Click(Sender: TObject);
var s: String;
begin
  s := iphs1_Procs.ObterDadosDeUmaCurvaIDF;
  if s <> '' then
     begin
     TProjeto(Objeto).RetirarCaminhoSePuder(s);

     if not Existe(s) then
        lbPCs.Items.Add(s + ' : ' + EscolherTipoTormenta);
     end;
end;

function Tiphs1_Form_Dialogo_Projeto.EscolherTipoTormenta: String;
begin
  if DialogsEx.MessageDlg2('Selecione o tipo de Tormenta', mtInformation,
                           ['Desagregada', 'Acumulada'], [0, 0], 0) = 1 then
     Result := ' Tormenta Desagregada'
  else
     Result := ' Tormenta Acumulada';
end;

end.

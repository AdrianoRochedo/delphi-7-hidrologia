unit mh_HistoricoDosParametros;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Gridx32, StdCtrls, Menus, Buttons,
  mh_TCs;

type
  TDLG_Historico = class(TForm)
    G: TdrStringAlignGrid;
    PanelInfo: TPanel;
    cb1: TCheckBox;
    cb2: TCheckBox;
    cb3: TCheckBox;
    cb4: TCheckBox;
    cb5: TCheckBox;
    btnOpcoes: TSpeedButton;
    Menu: TPopupMenu;
    Menu_Restaurar: TMenuItem;
    Fechar1: TMenuItem;
    Menu_Fechar: TMenuItem;
    N1: TMenuItem;
    Menu_Salvar: TMenuItem;
    Menu_Ler: TMenuItem;
    Save: TSaveDialog;
    Open: TOpenDialog;
    N2: TMenuItem;
    Menu_Colar: TMenuItem;
    Menu_Copiar: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure GMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelInfoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Menu_RestaurarClick(Sender: TObject);
    procedure Menu_FecharClick(Sender: TObject);
    procedure Menu_SalvarClick(Sender: TObject);
    procedure Menu_LerClick(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure Menu_ColarClick(Sender: TObject);
    procedure GKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    Procedure SetNewCol(Col: TStrings);
    Procedure SetColIni(Col: TStrings);
  public
    Dados: pTDadosDaBacia;
    Property NewCol : TStrings Write SetNewCol;
    Property ColIni : TStrings Write SetColIni;
  end;

implementation
uses mh_Classes;

{$R *.DFM}

Procedure TDLG_Historico.SetColIni(Col: TStrings);
Begin
  If Col[0] <> '' Then Col.Insert(0, '');
  G.Cols[0].Assign(Col);
End;

Procedure TDLG_Historico.SetNewCol(Col: TStrings);

  Function VoltaParaTras(k: Integer): Integer;
  var i: Integer;
  Begin
    Result := -1;
    For i := k downTo 1 do
      If (G.Cells[i,1] = '') or Not
         (TCheckBox(FindComponent('cb'+IntToStr(i))).Checked) Then
         Begin
         Result := i;
         Break;
         End;
  End;

  Procedure Empurra(k: Integer);
  var a,b : Integer;
  Begin
    If k <> -1 Then
       Begin
       a := VoltaParaTras(k);
       b := VoltaParaTras(a-1);
       If (a <> -1) and (b <> -1) Then
          Begin
          G.Cols[a].Assign(G.Cols[b]);
          Empurra(b);
          End;
       End;
  End;

  Function BuscaPrimeiraColunaLivre: Integer;
  var i: Integer;
  Begin
    For i := 1 to 5 do
      If (G.Cells[i,1] = '') or Not
         (TCheckBox(FindComponent('cb'+IntToStr(i))).Checked) Then
         Begin
         Result := i;
         Break;
         End;
  End;

var k: Integer;
Begin
  If G.Cells[0,1] = '' Then
     Begin
     Col.Insert(0, 'Vals. Iniciais');
     G.Cols[0].Assign(Col);
     End
  Else
     Begin
     k := BuscaPrimeiraColunaLivre;
     If k <> -1 Then
        Begin
        Empurra(5);
        If Col[0] <> '' Then Col.Insert(0, '');
        G.Cols[k].Assign(Col);
        End;
     End;
End;

procedure TDLG_Historico.FormCreate(Sender: TObject);
var i: Integer;
begin
  G.Cells[0,0] := 'Vals. Iniciais';
  G.Options := G.Options - [goEditing] + [goDrawFocusSelected];
  G.FocusColor := clHighLight;
  G.FocusTextColor := clHighLightText;
end;

procedure TDLG_Historico.GMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var P        : TPoint;
    Col, Row : Longint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  G.MouseToCell(P.X, P.Y, Col, Row);
  If Row > 0 Then
     PanelInfo.Caption := ' ' + ParamNames[Row] + ': ' + ParamHints[Row]
  Else
     PanelInfo.Caption := '';
end;

procedure TDLG_Historico.PanelInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  PanelInfo.Caption := '';
end;

procedure TDLG_Historico.Menu_RestaurarClick(Sender: TObject);
Var Linha: Integer;
begin
  if G.Col > 0 then
  For Linha := 1 to 14 do
    Dados^.Parametros[Linha].ValsIni :=  StrToFloat(G.Cells[G.Col,Linha]);
end;

procedure TDLG_Historico.Menu_FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Historico.Menu_SalvarClick(Sender: TObject);
begin
  Save.InitialDir := mhApplication.LastPath;
  If Save.Execute Then
     begin
     mhApplication.LastPath := ExtractFilePath(Save.FileName);
     G.SaveToFile(Save.FileName);
     end;
end;

procedure TDLG_Historico.Menu_LerClick(Sender: TObject);
begin
  Open.InitialDir := mhApplication.LastPath;
  If Open.Execute Then
     begin
     mhApplication.LastPath := ExtractFilePath(Open.FileName);
     G.LoadFromFile(Open.FileName);
     end;
end;

procedure TDLG_Historico.btnOpcoesClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(btnOpcoes.Left, btnOpcoes.Top);
  P := PanelInfo.ClientToScreen(P);
  Menu_Restaurar.Enabled := (G.Col > 0) and (G.Cells[G.Col, 1] <> '');
  Menu.Popup(P.x, P.y);
end;

procedure TDLG_Historico.Menu_CopiarClick(Sender: TObject);
begin
  g.Copy;
end;

procedure TDLG_Historico.Menu_ColarClick(Sender: TObject);
begin
  g.Paste;
end;

procedure TDLG_Historico.GKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (activecontrol = g) then
     if (ssCtrl in Shift) then
        case upCase(char(key)) of
           'C': Menu_CopiarClick(nil);
           'V': Menu_ColarClick(nil);
           'X': Menu_FecharClick(nil);
           'R': Menu_RestaurarClick(nil);
           'L': Menu_LerClick(nil);
           'S': Menu_SalvarClick(nil);
           end;
end;

end.

unit pr_Dialogo_FalhasDeUmPC;

interface

uses                                          
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Classes, StdCtrls, AxCtrls, OleCtrls, vcf1, Menus;

type
  TprDialogo_FalhasDeUmPC = class(TForm)
    GB1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbOcorrenciasPri: TListBox;
    GB2: TGroupBox;
    Label4: TLabel;
    lbOcorrenciasSec: TListBox;
    GB3: TGroupBox;
    Label7: TLabel;
    lbOcorrenciasTer: TListBox;
    btnOk: TButton;
    Label10: TLabel;
    Label12: TLabel;
    TabPri: TF1Book;
    TabSec: TF1Book;
    TabTer: TF1Book;
    Label5: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Menu: TPopupMenu;
    Menu_Copiar: TMenuItem;
    procedure lbOcorrenciasDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure lbOcorrenciasClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
  private
    FFalhas: TListaDeFalhas;
    procedure SetFalhas(const Value: TListaDeFalhas);
  public
    property Falhas: TListaDeFalhas read FFalhas write SetFalhas;
  end;

var
  prDialogo_FalhasDeUmPC: TprDialogo_FalhasDeUmPC;

implementation
uses pr_Const, pr_Tipos;

{$R *.DFM}

{ TprDialogo_FalhasDeUmPC }

procedure TprDialogo_FalhasDeUmPC.SetFalhas(const Value: TListaDeFalhas);
var i: Integer;
begin
  FFalhas := Value;
  lbOcorrenciasPri.Clear;
  lbOcorrenciasSec.Clear;
  lbOcorrenciasTer.Clear;                        
  with FFalhas do
    begin
    for i := 0 to FalhasPrimarias-1   do lbOcorrenciasPri.Items.Add(FalhaPrimaria[i].sAno);
    for i := 0 to FalhasSecundarias-1 do lbOcorrenciasSec.Items.Add(FalhaSecundaria[i].sAno);
    for i := 0 to FalhasTerciarias-1  do lbOcorrenciasTer.Items.Add(FalhaTerciaria[i].sAno);
    end;
end;

procedure TprDialogo_FalhasDeUmPC.lbOcorrenciasClick(Sender: TObject);
var lb   : TListBox;
    F    : TprFalha;
    d    : TRec_prData;
    i, j : Integer;
    p    : Pointer;
    x    : Real;
    T    : TF1Book;
begin
  lb := TListBox(Sender);
  Case lb.Tag of
    0: begin
       F   := FFalhas.FalhaPrimaria[lb.ItemIndex];
       T := TabPri;
       end;
                                                      
    1: begin
       F := FFalhas.FalhaSecundaria[lb.ItemIndex];
       T := TabSec;
       end;

    2: begin
       F   := FFalhas.FalhaTerciaria[lb.ItemIndex];
       T := TabTer;
       end;
    end;

  T.MaxRow := F.Intervalos.Count;
  T.ClearRange(1, 1, T.MaxRow, T.MaxCol, F1ClearAll);
  for i := 0 to F.Intervalos.Count-1 do
    begin
    FFalhas.Projeto.DeltaT := F.Intervalos[i];
    d := FFalhas.Projeto.Data;
    p := pointer(F.IntervalosCriticos[i]);

    if F.FalhaCritica then
       for j := 1 to 3 do
         begin
         T.SetActiveCell(i + 1, j);
         T.SetFont('MS Sans Serif', 8, False, False, False, False, clRed, False, False);
         end;

    T.TextRC[i+1, 1] := Format('%d/%d', [d.Mes, d.Ano]);
    T.TextRC[i+1, 2] := F.Intervalos.AsString[i];
    try x := F.DemsAten[i] * 100 / F.DemsRef[i] except x := 0 end;
    T.TextRC[i+1, 3] := Format('%4.3f/%4.3f - %4.2f%%', [F.DemsRef[i], F.DemsAten[i], x]);
    end;
end;

procedure TprDialogo_FalhasDeUmPC.lbOcorrenciasDrawItem(
          Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var lb: TListBox;
    F : TprFalha;
    C : TColor;
begin
  lb := TListBox(Control);
  Case lb.Tag of
    0: F := FFalhas.FalhaPrimaria[index];
    1: F := FFalhas.FalhaSecundaria[index];
    2: F := FFalhas.FalhaTerciaria[index];
    end;

  with lb.Canvas do
    begin
    FillRect(Rect);
    if (odSelected in State) or (odFocused in State) then Font.Color := clHighlightText else
    if F.FalhaCritica then Font.Color := clRed else Font.Color := clWindowText;
    TextOut(Rect.Left, Rect.Top, F.sAno);
    end;
end;

procedure TprDialogo_FalhasDeUmPC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FFalhas.Free;
  Action := caFree;
end;

procedure TprDialogo_FalhasDeUmPC.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_FalhasDeUmPC.Menu_CopiarClick(Sender: TObject);
begin
  TF1Book(ActiveControl).EditCopy;
end;

end.

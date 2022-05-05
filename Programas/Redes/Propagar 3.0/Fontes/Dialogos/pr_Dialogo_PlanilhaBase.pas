unit pr_Dialogo_PlanilhaBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AxCtrls, OleCtrls, vcf1, Menus, DiretivasDeCompilacao;
  
type
  TprDialogo_PlanilhaBase = class(TForm)
    Tab: TF1Book;
    Menu: TPopupMenu;
    Menu_Copiar: TMenuItem;
    Menu_Colar: TMenuItem;
    Menu_Recortar: TMenuItem;
    N1: TMenuItem;
    Menu_Abrir: TMenuItem;
    Menu_Salvar: TMenuItem;
    N2: TMenuItem;
    Menu_Imprimir: TMenuItem;
    Save: TSaveDialog;
    Load: TOpenDialog;
    procedure TabKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure Menu_ColarClick(Sender: TObject);
    procedure Menu_RecortarClick(Sender: TObject);
    procedure Menu_AbrirClick(Sender: TObject);
    procedure Menu_SalvarClick(Sender: TObject);
    procedure Menu_OpcoesClick(Sender: TObject);
    procedure Menu_ImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TprDialogo_PlanilhaBase.TabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var c: Char;
begin
  if (Shift = [ssCtrl]) then
     begin
     c := upCase(char(Key));
     case c of
       'C': Tab.EditCopy;
       'V': Tab.EditPaste;
       'X': Tab.EditCut;
       'P': Tab.FilePrint(True); // Mostra diálogo de Impressão
       end;
     end;
end;

procedure TprDialogo_PlanilhaBase.Menu_CopiarClick(Sender: TObject);
begin
  {$IF dir_NivelDeRestricao < 1}
  Tab.EditCopy;
  {$ELSE}
  MessageDLG(mes_NivelDeRestricao, mtInformation, [mbOk], 0);
  {$IFEND}
end;

procedure TprDialogo_PlanilhaBase.Menu_ColarClick(Sender: TObject);
begin
  {$IF dir_NivelDeRestricao < 1}
  Tab.EditPaste;
  {$ELSE}
  MessageDLG(mes_NivelDeRestricao, mtInformation, [mbOk], 0);
  {$IFEND}
end;

procedure TprDialogo_PlanilhaBase.Menu_RecortarClick(Sender: TObject);
begin
  {$IF dir_NivelDeRestricao < 1}
  Tab.EditCut;
  {$ELSE}
  MessageDLG(mes_NivelDeRestricao, mtInformation, [mbOk], 0);
  {$IFEND}
end;

procedure TprDialogo_PlanilhaBase.Menu_AbrirClick(Sender: TObject);
var FT: SmallInt;
begin
  try
    if Load.Execute Then
       begin
       Screen.Cursor := crHourGlass;
       Tab.Read(Load.FileName, FT);
       end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TprDialogo_PlanilhaBase.Menu_SalvarClick(Sender: TObject);
begin
  {$IF dir_NivelDeRestricao < 2}
  if Save.Execute then
     Case Save.FilterIndex of
       1 : {TXT} Tab.Write(Save.FileName, F1FileTabbedText);
       2 : {XLS} Tab.Write(Save.FileName, F1FileExcel5);
       end;
  {$ELSE}
  MessageDLG(mes_NivelDeRestricao, mtInformation, [mbOk], 0);
  {$IFEND}
end;

procedure TprDialogo_PlanilhaBase.Menu_OpcoesClick(Sender: TObject);
begin
  {}
end;

procedure TprDialogo_PlanilhaBase.Menu_ImprimirClick(Sender: TObject);
begin
  Tab.FilePrint(True); // True = Mostra Diálogo de Impressão
end;

procedure TprDialogo_PlanilhaBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

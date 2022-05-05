unit Planilha_base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AxCtrls, OleCtrls, vcf1, Menus;

type
  TForm_Planilha_Base = class(TForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TForm_Planilha_Base.TabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TForm_Planilha_Base.Menu_CopiarClick(Sender: TObject);
begin
  Tab.EditCopy;
end;

procedure TForm_Planilha_Base.Menu_ColarClick(Sender: TObject);
begin
  Tab.EditPaste;
end;

procedure TForm_Planilha_Base.Menu_RecortarClick(Sender: TObject);
begin
  Tab.EditCut;
end;

procedure TForm_Planilha_Base.Menu_AbrirClick(Sender: TObject);
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

procedure TForm_Planilha_Base.Menu_SalvarClick(Sender: TObject);
begin
  if Save.Execute then
     Case Save.FilterIndex of
       1 : {TXT} Tab.Write(Save.FileName, F1FileTabbedText);
       2 : {XLS} Tab.Write(Save.FileName, F1FileExcel5);
       end;
end;

procedure TForm_Planilha_Base.Menu_OpcoesClick(Sender: TObject);
begin
  {}
end;

procedure TForm_Planilha_Base.Menu_ImprimirClick(Sender: TObject);
begin
  Tab.FilePrint(True); // True = Mostra Diálogo de Impressão
end;

end.

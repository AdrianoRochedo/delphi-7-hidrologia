unit iphs1_Dialogo_VazaoCont;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, hidro_Classes, Series, TeeProcs, TeEngine, Chart, ExtCtrls,
  Menus;

type
  Tiphs1_Form_Dialogo_VazaoCont = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    QQV: TChart;
    QQA: TChart;
    Splitter2: TSplitter;
    QV: TChart;
    Splitter3: TSplitter;
    QA: TChart;
    MenuQQV: TPopupMenu;
    MenuCopiar: TMenuItem;
    MenuQQA: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuQV: TPopupMenu;
    MenuItem2: TMenuItem;
    MenuQA: TPopupMenu;
    MenuItem3: TMenuItem;
    Panel3: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuCopiarClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private
    Fc: THidroComponente;
    sQQV, sQQA, sQV, sQA: TLineSeries;
    function CriarSerie(Parent: TChart): TLineSeries;
  public
    constructor Create(c: THidroComponente);
  end;

implementation

{$R *.dfm}

{ TTiphs1_Form_Dialogo_VazaoCont }

constructor Tiphs1_Form_Dialogo_VazaoCont.Create(c: THidroComponente);
var i: Integer;
begin
  inherited Create(nil);
  Fc := c;
  Caption := c.Projeto.Nome + ' - ' + c.Nome + ' - Curva de Vazão Controlada';

  QQV.Title.Text.Clear;
  QQA.Title.Text.Clear;
  QV.Title.Text.Clear;
  QA.Title.Text.Clear;

  Panel1.Height := ClientHeight div 2 - 3;
  QQV.Width := ClientWidth div 2 - 10;
  QV.Width := ClientWidth div 2 - 10;

  if c.VazaoCont <> nil then
     begin
     sQQV := CriarSerie(QQV);
     sQQA := CriarSerie(QQA);
     sQV := CriarSerie(QV);
     sQA := CriarSerie(QA);
     for i := 1 to 9 do
       begin
       sQQV.AddXY(c.VazaoCont[i, 3], c.VazaoCont[i, 1]);
       sQQA.AddXY(c.VazaoCont[i, 4], c.VazaoCont[i, 1]);
       sQV. AddXY(c.VazaoCont[i, 3], c.VazaoCont[i, 2]);
       sQA. AddXY(c.VazaoCont[i, 4], c.VazaoCont[i, 2]);
       end;
     end;
end;

function Tiphs1_Form_Dialogo_VazaoCont.CriarSerie(Parent: TChart): TLineSeries;
begin
  Result := TLineSeries.Create(nil);
  Result.ParentChart := Parent;
  Result.Pointer.HorizSize := 3;
  Result.Pointer.VertSize := 3;
  Result.Pointer.Style := psCircle;
  Parent.Legend.Visible := False;
end;

procedure Tiphs1_Form_Dialogo_VazaoCont.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tiphs1_Form_Dialogo_VazaoCont.MenuCopiarClick(Sender: TObject);
begin
  QQV.CopyToClipboardBitmap;
end;

procedure Tiphs1_Form_Dialogo_VazaoCont.MenuItem1Click(Sender: TObject);
begin
  QQA.CopyToClipboardBitmap;
end;

procedure Tiphs1_Form_Dialogo_VazaoCont.MenuItem2Click(Sender: TObject);
begin
  QV.CopyToClipboardBitmap;
end;

procedure Tiphs1_Form_Dialogo_VazaoCont.MenuItem3Click(Sender: TObject);
begin
  QA.CopyToClipboardBitmap;
end;

end.

unit ObterPeriodosValidos;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, DBTables, CH_CONST, CH_Tipos,
  frameSelecaoDePostos;

type
  TDLG_ObterPeriodosValidos = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cb1: TCheckBox;
    cb2: TCheckBox;
    cb3: TCheckBox;
    FS: TFrame_SelecaoDePostos;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FInfo: TDSInfo;
  public
    InsercaoExecutada: Boolean;
    constructor Create(Info: TDSInfo);
  end;

implementation
uses CH_Procs, WinUtils, DialogsEx, SysUtilsEx;

{$R *.DFM}

constructor TDLG_ObterPeriodosValidos.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_ObterPeriodosValidos.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDLG_ObterPeriodosValidos.btnOkClick(Sender: TObject);
var L: TListaDePeriodos;
    SL: TStrings;
    i: Integer;
begin
  SL := TStringList.Create;
  for i := 0 to FS.PostosSel.Count-1 do
    SL.Add(GetValidID(FS.PostosSel[i]));

  if cb1.Checked then
     begin
     L := ObtemPeriodos(FInfo, True, SL);
     Applic.OutPut.Editor.NewPage;
     Applic.OutPut.Editor.Write('PERÍODOS COMUNS COM DADOS CONTÍNUOS EM TODOS OS POSTOS');
     Applic.OutPut.Editor.Write;
     L.Imprimir(Applic.OutPut, FInfo, True);
     L.Free;
     end;

  if cb2.Checked then
     begin
     L := ObtemPeriodos(FInfo, False, SL);
     Applic.OutPut.Editor.Write;
     Applic.OutPut.Editor.Write('PERÍODOS COMUNS SEM DADOS');
     Applic.OutPut.Editor.Write;
     Applic.OutPut.Editor.Write('Postos Selecionados:');

     for i := 0 to FS.PostosSel.Count-1 do
       Applic.OutPut.Editor.Write('   ' + FS.PostosSel[i]);

     Applic.OutPut.Editor.Write;
     L.Imprimir(Applic.OutPut, FInfo, False);
     L.Free;
     end;

  SL.Free;
  Applic.OutPut.Editor.Show;
  Show;
end;

procedure TDLG_ObterPeriodosValidos.FormShow(Sender: TObject);
begin
  FInfo.MostrarPostos(FS.clPostos.Items);
end;

procedure TDLG_ObterPeriodosValidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_ObterPeriodosValidos.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.

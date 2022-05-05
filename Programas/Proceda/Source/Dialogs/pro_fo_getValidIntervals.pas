unit pro_fo_getValidIntervals;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, DBTables, pro_CONST, pro_Classes,
  pro_fr_StationSelections, pro_Application;

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
uses pro_Procs, WinUtils, DialogsEx, SysUtilsEx, pro_fo_Memo;

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
    m: TfoMemo;
begin
  m := TfoMemo.Create(Caption);

  SL := TStringList.Create;
  for i := 0 to FS.PostosSel.Count-1 do
    SL.Add(GetValidID(FS.PostosSel[i]));

  if cb1.Checked then
     begin
     L := ObtemPeriodos(FInfo, True, SL);
     m.Write('PERÍODOS COMUNS COM DADOS CONTÍNUOS EM TODOS OS POSTOS');
     m.Write;
     L.Imprimir(m.Buffer, FInfo, True);
     L.Free;
     end;

  if cb2.Checked then
     begin
     L := ObtemPeriodos(FInfo, False, SL);

     m.Write;
     m.Write('PERÍODOS COMUNS SEM DADOS');
     m.Write;
     m.Write('Postos Selecionados:');

     for i := 0 to FS.PostosSel.Count-1 do
       m.Write('   ' + FS.PostosSel[i]);

     m.Write;
     L.Imprimir(m.Buffer, FInfo, False);

     L.Free;
     end;

  SL.Free();
  
  m.FormStyle := fsMDIChild;
  m.Show();

  Show();

  Applic.ArrangeChildrens();
end;

procedure TDLG_ObterPeriodosValidos.FormShow(Sender: TObject);
begin
  FInfo.GetStationNames(FS.clPostos.Items);
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

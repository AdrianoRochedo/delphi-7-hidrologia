unit pro_fo_Station_EditExtraData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit,
  pro_Classes,
  pro_Application;

type
  TfoStation_EditExtraData = class(TForm)
    Props: TValueListEditor;
    btnAdd: TButton;
    btnDel: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cbTD: TComboBox;
    btnTD: TButton;
    Label3: TLabel;
    cbUN: TComboBox;
    btnUN: TButton;
    Label4: TLabel;
    mComent: TMemo;
    Label5: TLabel;
    edNome: TEdit;
    procedure PropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure btnDelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTDClick(Sender: TObject);
    procedure btnUNClick(Sender: TObject);
  private
    FPosto: TStation;
  public
    constructor Create(Posto: TStation);
  end;

implementation

{$R *.dfm}

constructor TfoStation_EditExtraData.Create(Posto: TStation);
begin
  inherited Create(nil);

  cbTD.Items.Assign(Applic.DataTypes);
  cbUN.Items.Assign(Applic.DataUnits);

  FPosto := Posto;

  edNome.Text := FPosto.Nome;
  cbTD.Text := FPosto.DataType;
  cbUN.Text := FPosto.DataUnit;
  mComent.Lines.Assign(FPosto.Comment);
  Props.Strings.Assign(FPosto.ExtraData);
end;

procedure TfoStation_EditExtraData.btnOkClick(Sender: TObject);
begin
  FPosto.Nome := edNome.Text;
  FPosto.DataType := cbTD.Text;
  FPosto.DataUnit := cbUN.Text;
  FPosto.Comment.Assign(mComent.Lines);
  FPosto.ExtraData.Assign(Props.Strings);
  Close();
  ModalResult := mrOk;
end;

procedure TfoStation_EditExtraData.PropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (aRow = 0) or (aCol = 0) then
     begin
     if (aRow = 0) then Props.Canvas.Font.Color := clNavy;
     Props.Canvas.Font.Style := [fsBold];
     Props.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, Props.Cells[aCol, aRow]);
     end;
end;

procedure TfoStation_EditExtraData.btnDelClick(Sender: TObject);
begin
  if Props.Cells[0, Props.Row] <> '' then
     Props.DeleteRow(Props.Row)
end;

procedure TfoStation_EditExtraData.btnAddClick(Sender: TObject);
var i: integer;
begin
  i := Props.Strings.Count + 1;
  Props.InsertRow('Nova Propriedade ' + intToStr(i), '', true);
end;

procedure TfoStation_EditExtraData.btnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TfoStation_EditExtraData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfoStation_EditExtraData.btnTDClick(Sender: TObject);
begin
  if Applic.EditDataTypes() then
     cbTD.Items.Assign(Applic.DataTypes);
end;

procedure TfoStation_EditExtraData.btnUNClick(Sender: TObject);
begin
  if Applic.EditDataUnits() then
     cbUN.Items.Assign(Applic.DataUnits);
end;

end.

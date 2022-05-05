unit pro_fo_PLU_VZO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, Buttons,
  pro_fr_getValidIntervals,
  pro_Const,
  pro_Application,
  pro_Classes;

type
  TGRF_chuvaXvazao = class(TForm)
    Label3: TLabel;
    lbPostos: TListBox;
    sbAddPostoDeVazao: TBitBtn;
    sbSubPostoDeVazao: TBitBtn;
    Label4: TLabel;
    lbPostosDeVazao: TListBox;
    Bevel2: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Label5: TLabel;
    sbPostoDeChuva: TBitBtn;
    ColorDialog: TColorDialog;
    lbPostosDeChuva: TListBox;
    BitBtn1: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure sbAddPostoDeVazaoClick(Sender: TObject);
    procedure sbSubPostoDeVazaoClick(Sender: TObject);
    procedure lbPostos_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbPostoDeChuvaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lbPostos_DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbPostos_DblClick(Sender: TObject);
    procedure edPostoDeChuvaKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
  private
    FInfo: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses pro_Procs, WinUtils, GraphicUtils, wsMatrix, pro_GRP_PLU_VZO;

{$R *.DFM}

constructor TGRF_chuvaXvazao.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TGRF_chuvaXvazao.btnOkClick(Sender: TObject);
var G: TForm;
    i: Integer;
begin
  for i := 0 to lbPostosDeChuva.Items.Count-1 do
    If lbPostosDeVazao.Items.IndexOf(lbPostosDeChuva.Items[i]) > -1 then
       Raise Exception.Create('Erro:'#13 +
                              'O posto de Chuva <'+ lbPostosDeChuva.Items[i] +'> também foi'#13 +
                              'selecionado como posto de vazão !');

  // plota o gráfico
  G := TGraf_Chuva_X_Vazao_Form.CriaGrafico_Chuva_X_Vazao(
         FInfo.DS,
         lbPostosDeChuva.Items,
         lbPostosDeVazao.Items
         );

  G.Caption := ' ' + FInfo.NomeArq;
  Close();

  Applic.ArrangeChildrens();
end;

procedure TGRF_chuvaXvazao.sbAddPostoDeVazaoClick(Sender: TObject);
var i: Integer;
begin
  // Adiciona os itens escolhidos na lista
  AddElemToList(lbPostos, lbPostosDeVazao, False);

  // Apos incluir os itens na lista escolhemos uma cor para cada item
  for i := 0 to lbPostosDeVazao.Items.Count-1 do
    lbPostosDeVazao.Items.Objects[i] := Pointer(SelectColor(i, false));
end;

procedure TGRF_chuvaXvazao.sbSubPostoDeVazaoClick(Sender: TObject);
begin
  DeleteElemFromListEx(lbPostosDeVazao);
end;

procedure TGRF_chuvaXvazao.lbPostos_KeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DeleteElemFromList((Sender as TListBox), Key);
end;

procedure TGRF_chuvaXvazao.sbPostoDeChuvaClick(Sender: TObject);
var i: Integer;
begin
  AddElemToList(lbPostos, lbPostosDeChuva, False);

  // Apos incluir os itens na lista escolhemos uma cor para cada item
  for i := 0 to lbPostosDeChuva.Items.Count-1 do
    lbPostosDeChuva.Items.Objects[i] := Pointer(SelectColor(i, false));
end;

procedure TGRF_chuvaXvazao.FormShow(Sender: TObject);
begin
  FInfo.GetStationNames(lbPostos.Items);
end;

procedure TGRF_chuvaXvazao.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TGRF_chuvaXvazao.lbPostos_DrawItem(Control: TWinControl;
          Index: Integer; Rect: TRect;  State: TOwnerDrawState);

var Offset: Integer;
    R: TRect;
    LB: TListBox;

const dx = 16;

begin
  LB := (Control as TListBox);
  with LB.Canvas do
    begin
    // Pinta o fundo (limpa o fundo da String)
    Brush.Color := clWindow;
    FillRect(Rect);
    Offset := 2;

    // Desenha o pequeno retângulo colorido
    R := Classes.Rect(Rect.Left + Offset, Rect.Top, Rect.Left + OffSet + dx, Rect.Bottom);
    InflateRect(R, -2, -2);
    //if LB.Items.Objects[Index] = nil then
       //LB.Items.Objects[Index] := Pointer(SelectColor(Index, false));

    Brush.Color := TColor(LB.Items.Objects[Index]);
    FillRect(R);
    Frame3D(LB.Canvas, R, clWhite, clBtnShadow, 2);

    // Desenha a string
    Offset := OffSet + dx + 6;
    if (odSelected in State) then Brush.Color := clHighlight else Brush.Color := clWindow;
    TextOut(Rect.Left + Offset, Rect.Top, LB.Items[Index]);
    end;
end;

procedure TGRF_chuvaXvazao.lbPostos_DblClick(Sender: TObject);
var i: Integer;
    LB: TListBox;
begin
  if ColorDialog.Execute() then
     begin
     LB := (Sender as TListBox);
     LB.Items.Objects[LB.ItemIndex] := Pointer(ColorDialog.Color);
     LB.Invalidate();
     end;
end;

procedure TGRF_chuvaXvazao.edPostoDeChuvaKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) <> VK_BACK then Key := #0;
end;

procedure TGRF_chuvaXvazao.BitBtn1Click(Sender: TObject);
begin
  DeleteElemFromListEx(lbPostosDeChuva);
end;

end.

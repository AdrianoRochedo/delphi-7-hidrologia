unit FrameSelecaoDePostos;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, CheckLst, wsVec;

type

  TFrame_SelecaoDePostos = class(TFrame)
    clPostos: TCheckListBox;
    Label1: TLabel;
    Menu: TPopupMenu;
    MenuST: TMenuItem;
    MenuSN: TMenuItem;
    procedure MenuSTClick(Sender: TObject);
    procedure MenuSNClick(Sender: TObject);
    procedure clPostosClickCheck(Sender: TObject);
  private
    FPostosSel: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Seta os postos que serão mostrados na lista
    procedure setPostos(Postos: TStrings);
    function  ObtemIndiceDosPostosSelecionados: TwsLIVec;

    // Retorna os postos selecionados com seus respectivos índices setados na propriedade
    // <Objects>. Estes índices são os índices das colunas do DataSet.
    property PostosSel : TStrings read FPostosSel;
  end;

implementation

{$R *.DFM}

constructor TFrame_SelecaoDePostos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPostosSel := TStringList.Create;
end;

destructor TFrame_SelecaoDePostos.Destroy;
begin
  FPostosSel.Free;
  inherited;
end;

procedure TFrame_SelecaoDePostos.setPostos(Postos: TStrings);
begin
  clPostos.Items.Assign(Postos);
end;

procedure TFrame_SelecaoDePostos.MenuSTClick(Sender: TObject);
var i: Integer;
begin
  for i := 0 to clPostos.Items.Count-1 do
    clPostos.Checked[i] := True;
  clPostosClickCheck(Sender);    
end;

procedure TFrame_SelecaoDePostos.MenuSNClick(Sender: TObject);
var i: Integer;
begin
  for i := 0 to clPostos.Items.Count-1 do
    clPostos.Checked[i] := False;
  clPostosClickCheck(Sender);
end;

procedure TFrame_SelecaoDePostos.clPostosClickCheck(Sender: TObject);
var i: Integer;
begin
  FPostosSel.Clear;
  for i := 0 to clPostos.Items.Count-1 do
    if clPostos.checked[i] then
       FPostosSel.AddObject(clPostos.Items[i], pointer(i + 1));
end;

function TFrame_SelecaoDePostos.ObtemIndiceDosPostosSelecionados: TwsLIVec;
var i: Integer;
begin
  Result := TwsLIVec.Create(FPostosSel.Count);
  for i := 0 to FPostosSel.Count-1 do
    Result[i+1] := Integer(FPostosSel.Objects[i]);
end;

end.

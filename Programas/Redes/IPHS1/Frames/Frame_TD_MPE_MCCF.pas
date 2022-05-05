unit Frame_TD_MPE_MCCF;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, drEdit, ExtCtrls;

type
  TOn_TipoSecaoMudou = procedure (TipoSecao: byte) of object;

  // Frame dos canais secundários
  Tiphs1_Frame_TD_MPE_MCCF = class(TFrame)
    pa1: TPanel;
    cbTS: TComboBox;
    pa2: TPanel;
    edAD: TdrEdit;
    pa3: TPanel;
    edL: TdrEdit;
    pa4: TPanel;
    edDE: TdrEdit;
    pa5: TPanel;
    edDD: TdrEdit;
    pa6: TPanel;
    edR: TdrEdit;
    procedure cbTSChange(Sender: TObject);
  private
    FOn_TipoSecaoMudou: TOn_TipoSecaoMudou;
    function getTipoSec: Integer;
    { Private declarations }
  public
    procedure SetData(const TipoSec : Integer;
                      const AltDiam : Real;
                      const Largura : Real;
                      const DecEsq  : Real;
                      const DecDir  : Real;
                      const Rugosid : Real);

    procedure GetData(var TipoSec : Integer;
                      var AltDiam : Real;
                      var Largura : Real;
                      var DecEsq  : Real;
                      var DecDir  : Real;
                      var Rugosid : Real);

  property TipoSec : Integer read getTipoSec;

  property TipoSecaoMudou : TOn_TipoSecaoMudou read FOn_TipoSecaoMudou write FOn_TipoSecaoMudou;
  end;

implementation
uses WinUtils;

{$R *.dfm}

procedure Tiphs1_Frame_TD_MPE_MCCF.cbTSChange(Sender: TObject);
begin
  WinUtils.Clear([edAD, edL, edDE, edDD, edR]);
  setEnable([edL, edDE, edDD], true, clWindow);

  case cbTS.ItemIndex of
    0: begin
       pa2.Caption := ' Altura (m):';    // retangular
       setEnable([edDE, edDD], false, clInactiveCaption);
       end;

    1: begin
       pa2.Caption := ' Diâmetro (m):';  // circular
       setEnable([edL, edDE, edDD], false, clInactiveCaption);
       end;

    2: begin
       pa2.Caption := ' Altura (m):';    // trapezoidal
       end;
    end;

  FOn_TipoSecaoMudou(cbTS.ItemIndex);
end;

procedure Tiphs1_Frame_TD_MPE_MCCF.GetData(var TipoSec: Integer;
  var AltDiam, Largura, DecEsq, DecDir, Rugosid: Real);
begin
  TipoSec := cbTS.ItemIndex + 1;
  AltDiam := edAD.AsFloat;
  Largura := edL.AsFloat;
  DecEsq  := edDE.AsFloat;
  DecDir  := edDD.AsFloat;
  Rugosid := edR.AsFloat;
end;

function Tiphs1_Frame_TD_MPE_MCCF.getTipoSec: Integer;
begin
  Result := cbTS.ItemIndex + 1;
end;

procedure Tiphs1_Frame_TD_MPE_MCCF.SetData(const TipoSec: Integer;
  const AltDiam, Largura, DecEsq, DecDir, Rugosid: Real);
begin
  cbTS.ItemIndex := TipoSec - 1;
  cbTSChange(nil);

  edAD.AsFloat  := AltDiam;
  edL.AsFloat   := Largura;
  edDE.AsFloat := DecEsq;
  edDD.AsFloat := DecDir;
  edR.AsFloat   := Rugosid;
end;

end.

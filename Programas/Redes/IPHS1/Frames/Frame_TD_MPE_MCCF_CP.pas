unit Frame_TD_MPE_MCCF_CP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Frame_TD_MPE_MCCF, StdCtrls, drEdit, ExtCtrls;

type
  // Frame do canal principal
  Tiphs1_Frame_TD_MPE_MCCF_CP = class(Tiphs1_Frame_TD_MPE_MCCF)
    pa7: TPanel;
    edLT: TdrEdit;
    pa8: TPanel;
    edDF: TdrEdit;
    pa9: TPanel;
    edIS: TdrEdit;
    pa10: TPanel;
    edST: TdrEdit;          
    pa11: TPanel;
    edHL: TdrEdit;
  private
    { Private declarations }
  public
    procedure SetData(const TipoSec : Integer;
                      const AltDiam : Real;
                      const Largura : Real;
                      const DecEsq  : Real;
                      const DecDir  : Real;
                      const Rugosid : Real;
                      const LatTrec : Real;
                      const DecFun  : Real;
                      const IntSim  : Real;
                      const SubTrs  : Integer;
                      const HidLat  : Integer);

    procedure GetData(var TipoSec : Integer;
                      var AltDiam : Real;
                      var Largura : Real;
                      var DecEsq  : Real;
                      var DecDir  : Real;
                      var Rugosid : Real;
                      var LatTrec : Real;
                      var DecFun  : Real;
                      var IntSim  : Real;
                      var SubTrs  : Integer;
                      var HidLat  : Integer);
  end;

implementation

{$R *.dfm}

{ Tiphs1_Frame_TD_MPE_MCCF_CP }

procedure Tiphs1_Frame_TD_MPE_MCCF_CP.GetData(var TipoSec: Integer;
  var AltDiam, Largura, DecEsq, DecDir, Rugosid, LatTrec, DecFun: Real;
  var IntSim: Real;
  var SubTrs, HidLat: Integer);
begin
  inherited GetData(TipoSec, AltDiam, Largura, DecEsq, DecDir, Rugosid);

  LatTrec := edLT.AsFloat;
  DecFun := edDF.AsFloat;
  IntSim := edIS.AsFloat;
  SubTrs := edST.AsInteger;
  HidLat := edHL.AsInteger;
end;

procedure Tiphs1_Frame_TD_MPE_MCCF_CP.SetData(
  const TipoSec: Integer;
  const AltDiam, Largura, DecEsq, DecDir, Rugosid, LatTrec, DecFun: Real;
  const IntSim: Real;
  const SubTrs, HidLat: Integer);
begin
  inherited SetData(TipoSec, AltDiam, Largura, DecEsq, DecDir, Rugosid);

  edLT.AsFloat   := LatTrec;
  edDF.AsFloat   := DecFun;
  edIS.AsFloat   := IntSim;
  edST.AsInteger := SubTrs;
  edHL.AsInteger := HidLat;
end;

end.

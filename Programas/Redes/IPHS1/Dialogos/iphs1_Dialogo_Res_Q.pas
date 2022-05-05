unit iphs1_Dialogo_Res_Q;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AxCtrls, StdCtrls, Buttons, FrameEstruturaRes_Q;

type
  Tiphs1_Form_Dialogo_Res_Q = class(TForm)
    procedure btnCancelarClick(Sender: TObject);
  private
    FNE: Integer;
    f: TfrEstruturaRes_Q;  // referencia sempre a última estrutura
    procedure SetNE(const Value: Integer);
  public
    property NumEstruturas : Integer read FNE write SetNE;
  end;

implementation
uses VCF1;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_Res_Q.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure Tiphs1_Form_Dialogo_Res_Q.SetNE(const Value: Integer);
var i, t: Integer;

  procedure CriarEstrutura(i: Integer);
  begin
    f := TfrEstruturaRes_Q.Create(self);
    f.Left := 0;
    f.Top := t;
    f.Tag := i;
    f.Name := 'f' + IntToStr(i);
    f.p.Caption := ' Estrutura ' + IntToStr(i);
    f.Tab.ShowVScrollBar := F1OFF;
    f.Tab.ShowHScrollBar := F1OFF;
    f.Tab.MaxCol := 2;
    f.Tab.Height := 87;
    f.Parent := self;
  end;

begin
  if Value = FNE then Exit;

  VertScrollBar.Position := 0;

  if Value > FNE then
     begin
     if f = nil then t := 0 else t := f.Height * FNE;
     for i := FNE + 1 to Value do
       begin
       CriarEstrutura(i);
       inc(t, f.Height);
       end;
     end
  else
     begin
     for i := FNE downto Value+1 do
       begin
       f := TfrEstruturaRes_Q(FindComponent('f' + IntToStr(i)));
       f.Free;
       end;
     f := TfrEstruturaRes_Q(FindComponent('f' + IntToStr(Value)));
     if f = nil then Exit;
     end;

  FNE := Value;

  if FNE <= 2 then
     begin
     ClientHeight := f.Height * FNE;
     ClientWidth := f.Width;
     end
  else
     begin
     ClientHeight := f.Height * 2;
     ClientWidth := f.Width;
     end
end;

end.

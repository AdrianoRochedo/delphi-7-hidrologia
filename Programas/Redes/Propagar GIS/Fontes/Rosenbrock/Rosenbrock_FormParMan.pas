unit Rosenbrock_FormParMan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Rosenbrock_FrameParMan, ExtCtrls;

type
  TrbFormParMan = class(TForm)
    Panel1: TPanel;
    paRot: TPanel;
    Panel3: TPanel;
    paSim: TPanel;
    Panel5: TPanel;
    paFrames: TScrollBox;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
  private
    procedure SetRotation(const Value: Integer);
    procedure SetSimulation(const Value: Integer);
  public
    function CreateFrame(i: Integer): TrbFrameParMan;
    procedure Clear;

    property Simulation : Integer write SetSimulation;
    property Rotation   : Integer write SetRotation;
  end;

implementation

{$R *.dfm}

{ TrbFormParMan }

procedure TrbFormParMan.Clear;
var i: Integer;
    c: TComponent;
begin
  for i := paFrames.ComponentCount - 1 downto 0 do
    begin
    c := paFrames.Components[i];
    if c is TFrame then
       begin
       paFrames.RemoveComponent(c);
       c.Free;
       end;
    end;
end;

function TrbFormParMan.CreateFrame(i: Integer): TrbFrameParMan;
begin
  Result := TrbFrameParMan.Create(nil);
  Result.Align := alTop;
  Result.Parent := paFrames;
  Result.Name := 'P' + IntToStr(i);
  paFrames.InsertComponent(Result);
  if i < 18 then ClientHeight := Result.Height * i + paFrames.Top + 1;
end;

procedure TrbFormParMan.SetRotation(const Value: Integer);
begin
  paRot.Caption := ' ' + IntToStr(Value);
end;

procedure TrbFormParMan.SetSimulation(const Value: Integer);
begin
  paSim.Caption := ' ' + IntToStr(Value);
end;

end.

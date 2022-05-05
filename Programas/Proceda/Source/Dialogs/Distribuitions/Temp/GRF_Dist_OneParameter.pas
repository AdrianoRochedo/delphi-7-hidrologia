unit GRF_Dist_OneParameter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GRF_ProbDist, Buttons, ExtCtrls, drEdit, GRF_Dist_WithParameters;

type
  TfoGRF_Dist_OneParameter = class(TfoGRF_Dist_WithParameters)
    gbParVal: TGroupBox;
    laP1: TLabel;
    edP1: TdrEdit;
    procedure R4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure R3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfoGRF_Dist_OneParameter.FormCreate(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False;
end;

procedure TfoGRF_Dist_OneParameter.R1Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoGRF_Dist_OneParameter.R2Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoGRF_Dist_OneParameter.R3Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoGRF_Dist_OneParameter.R4Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=True
end;

end.

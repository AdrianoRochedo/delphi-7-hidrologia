unit fo_SkinDist_OneParameter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, drEdit, fo_SkinDist_WithParameters;

type                                              
  TfoSkinDist_OneParameter = class(TfoSkinDist_WithParameters)
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

procedure TfoSkinDist_OneParameter.FormCreate(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False;
end;

procedure TfoSkinDist_OneParameter.R1Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoSkinDist_OneParameter.R2Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoSkinDist_OneParameter.R3Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=False
end;

procedure TfoSkinDist_OneParameter.R4Click(Sender: TObject);
begin
  inherited;
  gbParVal.Enabled:=True
end;

end.

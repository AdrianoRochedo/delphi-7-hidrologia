unit GRF_ProbDist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, fo_Skin_Dialog, ExtCtrls, drEdit;

type
  TfoGRF_ProbDist = class(TfoSkinDialog)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbImpEst: TCheckBox;
    cbImpr: TCheckBox;
    cbIFN: TCheckBox;
    cbSE: TCheckBox;
    cbGraph: TCheckBox;
    cbReturn: TCheckBox;
    drReturn: TdrEdit;
    edCC: TdrEdit;
    procedure cbReturnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbGraphClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses WinUtils;

{$R *.dfm}

procedure TfoGRF_ProbDist.cbReturnClick(Sender: TObject);
begin
  inherited;
  if cbReturn.Checked then
    drReturn.Enabled := True
  else
    drReturn.Enabled := False
end;

procedure TfoGRF_ProbDist.FormCreate(Sender: TObject);
begin
  inherited;
  drReturn.Enabled := False;
end;

procedure TfoGRF_ProbDist.cbGraphClick(Sender: TObject);
begin
  inherited;
  if not cbGraph.Checked then
    begin
    cbIFN.Enabled:=False;
    cbSE.Enabled:=False;
    end
  else
    begin
    cbIFN.Enabled:=True;
    cbSE.Enabled:=True;
    end
end;

end.

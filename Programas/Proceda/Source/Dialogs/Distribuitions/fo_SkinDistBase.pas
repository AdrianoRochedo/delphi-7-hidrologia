unit fo_SkinDistBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, fo_Skin_Dialog, ExtCtrls, drEdit;

type
  TfoSkinDistBase = class(TfoSkinDialog)          
    GB: TGroupBox;
    Label1: TLabel;
    cbImpEst: TCheckBox;
    cbIFN: TCheckBox;
    cbSE: TCheckBox;
    cbGraph: TCheckBox;
    cbReturn: TCheckBox;
    drReturn: TdrEdit;
    edCC: TdrEdit;
    rgNInt: TRadioGroup;
    rgTestes: TRadioGroup;
    edFix: TdrEdit;
    edPropDist: TdrEdit;
    cbImpr: TCheckBox;
    procedure cbReturnClick(Sender: TObject);
    procedure cbGraphClick(Sender: TObject);
    procedure rgNIntClick(Sender: TObject);
    procedure rgTestesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses WinUtils;

{$R *.dfm}

procedure TfoSkinDistBase.cbReturnClick(Sender: TObject);
begin
  inherited;
  drReturn.Enabled := cbReturn.Checked;
end;

procedure TfoSkinDistBase.cbGraphClick(Sender: TObject);
begin
  inherited;
  cbIFN.Enabled := cbGraph.Checked;
  cbSE.Enabled := cbGraph.Checked;
  cbImpr.Enabled := cbGraph.Checked;
end;

procedure TfoSkinDistBase.rgNIntClick(Sender: TObject);
begin
  inherited;
  if rgNInt.ItemIndex = 1 then
     edFix.SetFocus()
  else
     if rgNInt.ItemIndex = 2 then
        edPropDist.SetFocus()
end;

procedure TfoSkinDistBase.rgTestesClick(Sender: TObject);
begin
  inherited;
  rgNInt.Visible := (rgTestes.ItemIndex = 1);
  edFix.Visible := rgNInt.Visible;
  edPropDist.Visible := rgNInt.Visible;

end;

end.

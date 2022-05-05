unit fr_ParDistrib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, drEdit;

type
  TFrame_ParDistrib = class(TFrame)
    GB: TGroupBox;
    R1: TRadioButton;
    R2: TRadioButton;
    R3: TRadioButton;
    R4: TRadioButton;
    edEspecificar: TdrEdit;
  public
    procedure setText(const Text: string);
    function  getSelected(): byte; // result: 1, 2, 3 ou 4
    procedure setSelected(value: byte); // value: 1, 2, 3 ou 4
    function  getValue(): real;
    procedure setValue(value: real);
  end;

implementation

{$R *.dfm}

{ TFrame_GRF_ParDistrib }

function TFrame_ParDistrib.getSelected: byte;
begin
  if R1.Checked then Result := 1 else
  if R2.Checked then Result := 2 else
  if R3.Checked then Result := 3 else
  if R4.Checked then Result := 4;
end;

function TFrame_ParDistrib.getValue: real;
begin
  Result := self.edEspecificar.AsFloat;
end;

procedure TFrame_ParDistrib.setSelected(value: byte);
begin
  case value of
    1: R1.Checked := true;
    2: R2.Checked := true;
    3: R3.Checked := true;
    4: R4.Checked := true;
    end;
end;

procedure TFrame_ParDistrib.setText(const Text: string);
begin
  self.GB.Caption := ' ' + Text + ' ';
end;

procedure TFrame_ParDistrib.setValue(value: real);
begin
  self.edEspecificar.AsFloat := value;
end;

end.

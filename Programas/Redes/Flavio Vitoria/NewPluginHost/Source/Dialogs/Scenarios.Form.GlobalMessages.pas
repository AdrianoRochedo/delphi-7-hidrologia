unit Scenarios.Form.GlobalMessages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TGlobalMessagesForm = class(TForm)
    mm: TMemo;
  private
    procedure setMessage(const Value: String);
    { Private declarations }
  public
    procedure Clear;
    property Message: String write setMessage;
  end;

implementation

{$R *.dfm}

{ TGlobalMessagesForm }

procedure TGlobalMessagesForm.Clear;
begin
  mm.Lines.Clear;
end;

procedure TGlobalMessagesForm.setMessage(const Value: String);
begin
  mm.Lines.Text := Value;
end;

end.

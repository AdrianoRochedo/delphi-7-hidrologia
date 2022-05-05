unit Historico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm_Historico = class(TForm)
    Memo: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TForm_Historico.FormShow(Sender: TObject);
var Nome: string;
begin
  Nome := ExtractFilePath(Application.ExeName) + 'Historico.txt';
  if FileExists(Nome) then
     Memo.Lines.LoadFromFile(Nome);
end;

procedure TForm_Historico.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

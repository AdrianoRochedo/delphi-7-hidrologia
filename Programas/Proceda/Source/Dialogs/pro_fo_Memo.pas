unit pro_fo_Memo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Frame_Memo;

type
  TfoMemo = class(TForm)
    fr_Memo: Tfr_Memo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function getBuffer: TStrings;
    { Private declarations }
  public
    constructor Create(const Caption: string);
    procedure Write(const Text: string = '');
    property Buffer : TStrings read getBuffer;
  end;

implementation

{$R *.dfm}

{ TfoMemo }

constructor TfoMemo.Create(const Caption: string);
begin
  inherited Create(nil);
  self.Caption := Caption;
end;

function TfoMemo.getBuffer(): TStrings;
begin
  result := self.fr_Memo.Memo.Lines;
end;

procedure TfoMemo.Write(const Text: string = '');
begin
  self.fr_Memo.Memo.Lines.Add(Text);
end;

procedure TfoMemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

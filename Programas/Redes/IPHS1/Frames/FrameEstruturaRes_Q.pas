unit FrameEstruturaRes_Q;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AxCtrls, OleCtrls, VCF1, StdCtrls, drEdit, ExtCtrls;

type
  TfrEstruturaRes_Q = class(TFrame)
    Panel4: TPanel;
    Panel1: TPanel;
    edNPT: TdrEdit;
    edIT: TdrEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    p: TPanel;
    procedure edNPTExit(Sender: TObject);
    procedure TabExit(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TfrEstruturaRes_Q.edNPTExit(Sender: TObject);
begin
  Tab.MaxRow := StrToIntDef(edNPT.Text, 1);
end;

procedure TfrEstruturaRes_Q.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

end.

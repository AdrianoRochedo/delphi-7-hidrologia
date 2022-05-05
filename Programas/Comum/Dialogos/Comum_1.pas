unit Comum_1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OvcBase, OvcViewr, StdCtrls, FileCtrl;

type
  TComum = class(TForm)
    OvcController1: TOvcController;
    Arquivo: TOvcTextFileViewer;
    Files: TFileListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.

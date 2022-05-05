unit pro_fo_Access_Connection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pro_fo_BaseConnection, StdCtrls, drEdit, ExtCtrls;

type
  TfoAccess_Connection = class(TfoBaseConnection)
    Label2: TLabel;
    edFile: TdrEdit;
    btnProcurar: TButton;
    procedure btnProcurarClick(Sender: TObject);
  private
    function getFile: string;
    { Private declarations }
  public
    property Filename : string read getFile;
  end;

implementation
uses DialogUtils, pro_Application;

{$R *.dfm}

procedure TfoAccess_Connection.btnProcurarClick(Sender: TObject);
var F: string;
begin
  if DialogUtils.SelectFile(F, Applic.LastDir, 'Arquivos Access (*.mbd)|*.mdb') then
     begin
     edFile.AsString := F;
     Applic.LastDir := ExtractFilePath(F);
     if edID.AsString = '' then
        edID.AsString := ChangeFileExt(ExtractFileName(F), '');
     end;
end;

function TfoAccess_Connection.getFile: string;
begin
  result := edFile.AsString;
end;

end.

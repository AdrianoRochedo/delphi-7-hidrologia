unit pro_fo_ViewDataSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, Buttons, ComCtrls, DB, DBCtrls, Mask, StdCtrls;

type
  TfoViewDataset = class(TForm)
    DS: TDataSource;
    DBGrid1: TDBGrid;
    Painel: TPanel;
    Nav: TDBNavigator;
    SB: TStatusBar;
    ToolBar: TPanel;
    btnSalvarComo: TSpeedButton;
    SaveDialog: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSalvarComoClick(Sender: TObject);
  private
    FDataset: TDataset;
  protected
    function getRecordCount(): integer; virtual;
    function getFieldCount(): integer; virtual;
    procedure Update(); virtual;
    procedure Open(); virtual;
  public
    constructor Create(const Caption: string); overload;
    constructor Create(const Caption: string; Dataset: TDataset); overload;
  end;

implementation
uses WinUtils,
     DBUtils,
     FileUtils,
     SysUtilsEx;

{$R *.DFM}

{ TfoViewTable }

constructor TfoViewDataset.Create(const Caption: string);
begin
  inherited Create(nil);
  self.Caption := Caption;
end;

constructor TfoViewDataset.Create(const Caption: string; Dataset: TDataset);
begin
  inherited Create(nil);
  self.Caption := Caption;
  FDataset := Dataset;
  DS.DataSet := FDataset;
  Update();
end;

procedure TfoViewDataset.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDataset.Free();
  Action := caFree;
end;

function TfoViewDataset.getFieldCount(): integer;
begin
  if FDataset <> nil then
     result := FDataset.Fields.Count
  else
     Result := -1;
end;

function TfoViewDataset.getRecordCount(): integer;
begin
  if FDataset <> nil then
     result := FDataset.RecordCount
  else
     Result := -1;
end;

procedure TfoViewDataset.Open();
begin
end;

procedure TfoViewDataset.Update();
var i: Integer;
begin
  i := getRecordCount();
  if i > -1 then
     WriteStatus(SB, ['Registros: ' + intToStr(i) + ' ',
                      'Campos: '    + intToStr(getFieldCount)], false)
  else
     WriteStatus(SB, ['Campos: ' + intToStr(getFieldCount)], false);
end;

procedure TfoViewDataset.btnSalvarComoClick(Sender: TObject);
begin
  if SaveDialog.Execute() then
     try
       StartWait();
       case SaveDialog.FilterIndex of
         1: SaveAsText(DS.DataSet, SaveDialog.FileName, false);
         2: SaveAsText(DS.DataSet, SaveDialog.FileName, true);
         end;
     finally
       StopWait();
     end;
end;

end.

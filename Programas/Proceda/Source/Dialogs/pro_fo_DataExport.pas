unit pro_fo_DataExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ComCtrls, Grids, ValEdit,
  Dialogs, WinUtils, ExtCtrls,
  pro_Classes,
  pro_Interfaces,
  pro_Plugins,
  pro_Application;

type
  TfoDataExport = class(TForm, IProcessControl)
    Messages: TRichEdit;
    btnExport: TButton;
    PB: TProgressBar;
    Label6: TLabel;
    Label1: TLabel;
    lbPlugins: TListBox;
    Props: TValueListEditor;
    Label2: TLabel;
    btnFechar: TButton;
    Label3: TLabel;
    paInfo: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure PropsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure lbPluginsClick(Sender: TObject);
  private
    FPlugins: TPlugins;
    FActivePlugin : TExportPlugin;
    FInfo: TDSInfo;

    function LoadPlugin(): boolean;
    procedure ShowPluginProperties();
    procedure ShowPluginDesc();
    procedure Check();

    // IProcessControl interface
    procedure ipc_ShowMessage(const aMessage: string);
    procedure ipc_ShowError(const aError: string);
    procedure ipc_setMaxProgress(const aMax: integer);
    procedure ipc_setMinProgress(const aMin: integer);
    procedure ipc_setProgress(const aProgress: integer);
  public
    constructor Create(Info: TDSInfo);
    destructor Destroy(); override;
  end;

implementation
uses SysUtilsEx;

{$R *.dfm}

{ TfoDataImport }

constructor TfoDataExport.Create(Info: TDSInfo);
begin
  inherited Create(Nil);

  FInfo := Info;
  paInfo.Caption := ' ' + FInfo.NomeArq;

  FPlugins := TPlugins.Create(true);
  FPlugins.Load();
  FPlugins.Show(lbPlugins.Items, ptDataExport);
end;

destructor TfoDataExport.Destroy;
begin
  FPlugins.Free();
  inherited;
end;

procedure TfoDataExport.ipc_setMaxProgress(const aMax: integer);
begin
  PB.Max := aMax;
end;

procedure TfoDataExport.ipc_setMinProgress(const aMin: integer);
begin
  PB.Min := aMin;
end;

procedure TfoDataExport.ipc_setProgress(const aProgress: integer);
begin
  PB.Position := aProgress;
end;

procedure TfoDataExport.ipc_ShowError(const aError: string);
begin
  Messages.Lines.Add('Erro: ' + aError);
  Applic.ProcessMessages();
end;

procedure TfoDataExport.ipc_ShowMessage(const aMessage: string);
begin
  Messages.Lines.Add(aMessage);
  Applic.ProcessMessages();
end;

function TfoDataExport.LoadPlugin(): boolean;
begin
  if FActivePlugin.Load() then
     begin
     FActivePlugin.setProcessControlInterface(self);
     result := true;
     end
  else
     begin
     result := false;
     ipc_ShowError('Erro na leituta do Plugin');
     end;
end;

procedure TfoDataExport.FormDestroy(Sender: TObject);
begin
  if FActivePlugin <> nil then
     FActivePlugin.Release();
end;

procedure TfoDataExport.ShowPluginProperties();
var SL1: TStrings;
    SL2: TStrings;
    i, j: integer;
    p, v: string;
begin
  SL1 := TStringList.Create();
  SL2 := TStringList.Create();

  FActivePlugin.getProperties(SL1);
  Props.Strings.Assign(SL1);

  for i := 0 to SL1.Count-1 do
    begin
    p := SL1.Names[i];
    v := SL1.ValueFromIndex[i];

    // Desagrega os valores
    if (Length(v) > 0) and (v[1] = '(') then
       begin
       Props.ItemProps[i].EditStyle := esPickList;
       Props.ItemProps[i].ReadOnly := true;
       Split(SubString(v, '(', ')'), SL2, ['|']);
       Props.ItemProps[i].PickList.Assign(SL2);
       Props.Strings[i] := p + '=' + SL2[0];
       end
    else
       begin
       Props.Strings[i] := p + '=' + v;
       Props.ItemProps[i].ReadOnly := false;
       end;
    end;

  SL1.Free();
  SL2.Free();
end;

procedure TfoDataExport.btnExportClick(Sender: TObject);
var i: Integer;
begin
  Check();
  Messages.Clear();
  try
    if FActivePlugin.Handle <> 0 then
       begin
       FActivePlugin.setDataControlInterface(FInfo);
       FActivePlugin.setProcedaControlInterface(Applic);
       FActivePlugin.setProperties(Props.Strings);
       if FActivePlugin.Export() then
          ipc_ShowMessage('Ok.');
       end;
  finally
    PB.Position := PB.Min;
  end;
end;

procedure TfoDataExport.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfoDataExport.PropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if aRow = 0 then
     begin
     Props.Canvas.Font.Style := [fsBold];
     Props.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, Props.Cells[aCol, aRow]);
     end;
end;

procedure TfoDataExport.lbPluginsClick(Sender: TObject);
var p: TExportPlugin;
begin
  p := TExportPlugin(lbPlugins.Items.Objects[lbPlugins.ItemIndex]);
  if p <> FActivePlugin then
     begin
     if FActivePlugin <> nil then FActivePlugin.Release();
     FActivePlugin := p;
     if LoadPlugin() then
        begin
        ShowPluginProperties();
        ShowPluginDesc();
        end;
     end
  else
     ShowPluginDesc();
end;

procedure TfoDataExport.ShowPluginDesc();
begin
  Messages.Lines.Text := FActivePlugin.Description;
end;

procedure TfoDataExport.Check();
begin
  if lbPlugins.ItemIndex = -1 then
     Raise Exception.Create('Nenhum plug-in selecionado !');
end;

end.

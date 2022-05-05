unit pro_fo_DataImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ComCtrls, Grids, ValEdit,
  Dialogs, WinUtils,
  pro_Classes,
  pro_Interfaces,
  pro_Plugins,
  pro_Application;

type
  TfoDataImport = class(TForm, IProcessControl)
    Messages: TRichEdit;
    btnImport: TButton;
    PB: TProgressBar;
    Label3: TLabel;
    lbArquivos: TListBox;
    btnAdicionar: TButton;
    btnRemover: TButton;
    btnVisualizar: TButton;
    btnLimpar: TButton;
    Open: TOpenDialog;
    Label6: TLabel;
    Label1: TLabel;
    lbPlugins: TListBox;
    Props: TValueListEditor;
    Label2: TLabel;
    btnFechar: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure PropsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure lbPluginsClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    FPlugins: TPlugins;
    FActivePlugin : TImportPlugin;

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
    constructor Create();
    destructor Destroy(); override;
  end;

implementation
uses SysUtilsEx;

{$R *.dfm}

{ TfoDataImport }

constructor TfoDataImport.Create();
begin
  inherited Create(Nil);

  FPlugins := TPlugins.Create(true);
  FPlugins.Load();
  FPlugins.Show(lbPlugins.Items, ptDataImport);
end;

destructor TfoDataImport.Destroy;
begin
  FPlugins.Free();
  inherited;
end;

procedure TfoDataImport.ipc_setMaxProgress(const aMax: integer);
begin
  PB.Max := aMax;
end;

procedure TfoDataImport.ipc_setMinProgress(const aMin: integer);
begin
  PB.Min := aMin;
end;

procedure TfoDataImport.ipc_setProgress(const aProgress: integer);
begin
  PB.Position := aProgress;
end;

procedure TfoDataImport.ipc_ShowError(const aError: string);
begin
  Messages.Lines.Add('Erro: ' + aError);
  Applic.ProcessMessages();
end;

procedure TfoDataImport.ipc_ShowMessage(const aMessage: string);
begin
  Messages.Lines.Add(aMessage);
  Applic.ProcessMessages();
end;

function TfoDataImport.LoadPlugin(): boolean;
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

procedure TfoDataImport.FormDestroy(Sender: TObject);
begin
  if FActivePlugin <> nil then
     FActivePlugin.Release();
end;

procedure TfoDataImport.ShowPluginProperties();
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

procedure TfoDataImport.btnImportClick(Sender: TObject);
var i: Integer;
begin
  Check();
  Messages.Clear();
  try
    if FActivePlugin.Handle <> 0 then
       begin
       FActivePlugin.setProcedaControlInterface(Applic);
       FActivePlugin.setProperties(Props.Strings);
       if FActivePlugin.Import(lbArquivos.Items) then
          ipc_ShowMessage('Ok.');
       end;
  finally
    PB.Position := PB.Min;
    lbArquivos.ItemIndex := -1;
  end;
end;

procedure TfoDataImport.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfoDataImport.PropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if aRow = 0 then
     begin
     Props.Canvas.Font.Style := [fsBold];
     Props.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, Props.Cells[aCol, aRow]);
     end;
end;

procedure TfoDataImport.lbPluginsClick(Sender: TObject);
var p: TImportPlugin;
begin
  p := TImportPlugin(lbPlugins.Items.Objects[lbPlugins.ItemIndex]);
  if p <> FActivePlugin then
     begin
     if FActivePlugin <> nil then FActivePlugin.Release();
     FActivePlugin := p;
     if LoadPlugin() then
        begin
        Open.Filter := FActivePlugin.FileFilter;
        ShowPluginProperties();
        ShowPluginDesc();
        end;
     end
  else
     ShowPluginDesc();
end;

procedure TfoDataImport.ShowPluginDesc();
begin
  Messages.Lines.Text := FActivePlugin.Description;
end;

procedure TfoDataImport.btnAdicionarClick(Sender: TObject);
begin
  if lbPlugins.ItemIndex = -1 then
     Raise Exception.Create('Primeiro selecione um Plugin de Importação');

  Open.InitialDir := Applic.LastDir;
  if Open.Execute() then
     begin
     lbArquivos.Items.AddStrings(Open.Files);
     Applic.LastDir := Open.InitialDir;
     end;
end;

procedure TfoDataImport.btnRemoverClick(Sender: TObject);
begin
  DeleteElemFromList(lbArquivos, VK_DELETE);
end;

procedure TfoDataImport.btnLimparClick(Sender: TObject);
begin
  lbArquivos.Clear();
end;

procedure TfoDataImport.Check();
begin
  if lbPlugins.ItemIndex = -1 then
     Raise Exception.Create('Nenhum plug-in selecionado !');

  if lbArquivos.Items.Count = 0 then
     Raise Exception.Create('Nenhum arquivo selecionado para importação !');
end;

end.

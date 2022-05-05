unit Scenarios.Form.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Buttons,
  Dialogs, Plugin, Rochedo.Component, Scenarios.Designer, TB2Item, TB2Dock,
  TB2Toolbar, TBX, ImgList, TBXMDI, TB2ExtItems, TBXExtItems;

type
  TfoMain = class(TForm, IIDE)
    Dock_UP: TTBXDock;
    Dock_LEFT: TTBXDock;
    Toolbar_UP: TTBXToolbar;
    Toolbar_LEFT: TTBXToolbar;
    btnMove: TTBXItem;
    btnSelect: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    btnSC: TTBXItem;
    btnPC: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    btnCPC: TTBXItem;
    btnNew: TTBXItem;
    btnOpen: TTBXItem;
    btnSave: TTBXItem;
    btnSaveAs: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    btnCascate: TTBXItem;
    btnTV: TTBXItem;
    btnTH: TTBXItem;
    ImageList: TImageList;
    MDI_Handler: TTBXMDIHandler;
    TBXSeparatorItem5: TTBXSeparatorItem;
    btnDel: TTBXItem;
    Toolbar_Scripts: TTBXToolbar;
    cbScripts: TTBXComboBoxItem;
    btnRunScript: TTBXItem;
    btnEditScript: TTBXItem;
    btnStopScript: TTBXItem;
    Open: TOpenDialog;
    Save: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TBXItem_Click(Sender: TObject);
    procedure btnNew_Click(Sender: TObject);
    procedure btnCascade_Click(Sender: TObject);
    procedure btnTV_Click(Sender: TObject);
    procedure btnTH_Click(Sender: TObject);
    procedure btnSave_Click(Sender: TObject);
    procedure FormChange(Sender: TObject);
    procedure btnEditScript_Click(Sender: TObject);
    procedure btnRunScript_Click(Sender: TObject);
    procedure btnStopScript_Click(Sender: TObject);
    procedure btnOpen_Click(Sender: TObject);
    procedure btnSaveAs_Click(Sender: TObject);
  private
    function getSelectComponentClass(): TComponentClass;
    function getActiveObjectFactory(): IObjectFactory;
    function getStatus(): integer;
    function getActiveDesigner(): TScenariosDesigner;
  public
    function CreateMDIChild(const Filename: string): TScenariosDesigner;
  end;

implementation
uses psBASE, psCORE, psEditor,
     Scenarios.Consts,
     Scenarios.Components,
     Scenarios.Application;

{$R *.dfm}

{ TfoMain }

function TfoMain.CreateMDIChild(const Filename: string): TScenariosDesigner;
begin
  result := TScenariosDesigner.Create(self);
  if Filename <> '' then
     result.LoadFromFile(Filename);
end;

procedure TfoMain.FormShow(Sender: TObject);
var d: TScenariosDesigner;
begin
  Screen.OnActiveFormChange := FormChange;

  if Applic.Plugins.Count > 0 then
     btnSC.Caption := Applic.Plugins.Item[0].Factory.getName()
  else
     btnSC.Visible := false;

  d := CreateMDIChild(Applic.AppDir + 'designer.xml');
  FormChange(Sender);
end;

function TfoMain.getStatus(): integer;
begin
  if btnSelect.Checked then
     result := IDE_st_SelectObject
  else
  if btnMove.Checked then
     result := IDE_st_MoveObject
  else
  if btnCPC.Checked then
     result := IDE_st_ConnectPC
  else
     result := IDE_st_CreateObject;
end;

function TfoMain.getSelectComponentClass(): TComponentClass;
begin
  if getStatus() = IDE_st_CreateObject then
     begin
     if btnPC.Checked then result := TPC else
     if btnSC.Checked then result := TScenario;
     // ...
     end
  else
     result := nil;
end;

function TfoMain.getActiveObjectFactory(): IObjectFactory;
begin
  if getStatus() = IDE_st_CreateObject then
     if btnSC.Checked then
        result := Applic.Plugins.getFactoryByName(btnSC.Caption)
     else
        result := nil
  else
     result := nil;
end;

procedure TfoMain.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
begin
  for i := 0 to self.MDIChildCount-1 do
    self.MDIChildren[i].Close();
    
  Action := caFree;
end;

procedure TfoMain.TBXItem_Click(Sender: TObject);
begin
  TTBXItem(Sender).Checked := true;
end;

procedure TfoMain.btnNew_Click(Sender: TObject);
begin
  CreateMDIChild('');
end;

procedure TfoMain.btnCascade_Click(Sender: TObject);
begin
  self.Cascade();
end;

procedure TfoMain.btnTV_Click(Sender: TObject);
begin
  self.TileMode := tbVertical;
  self.Tile();
end;

procedure TfoMain.btnTH_Click(Sender: TObject);
begin
  self.TileMode := tbHorizontal;
  self.Tile();
end;

procedure TfoMain.btnSave_Click(Sender: TObject);
var d: TScenariosDesigner;
begin
  d := getActiveDesigner();
  if d <> nil then
     if d.Filename <> '' then
        d.SaveToFile(d.Filename)
     else
        btnSaveAs_Click(Sender);
end;

function TfoMain.getActiveDesigner(): TScenariosDesigner;
begin
  if self.ActiveMDIChild is TScenariosDesigner then
     result := TScenariosDesigner(self.ActiveMDIChild)
  else
     result := nil;
end;

procedure TfoMain.FormChange(Sender: TObject);

    procedure Clear();
    begin
      cbScripts.Clear();
      cbScripts.Strings.Clear();
    end;

begin
  if not (csDestroying in self.ComponentState) then
     if (self.MDIChildCount > 0) then
        if getActiveDesigner() <> nil then
           begin
           Clear();
           cbScripts.Strings.Assign( getActiveDesigner().Project.Scripts );
           if cbScripts.Strings.Count > 0 then
              cbScripts.ItemIndex := 0;
           end
        else
           Clear()
     else
        Clear()
end;

procedure TfoMain.btnEditScript_Click(Sender: TObject);
var s: String;
    v: TVariable;
    d: TScenariosDesigner;
    p: TProject;
begin
  d := getActiveDesigner();
  
  if d <> nil then
     begin
     p := d.Project;
     s := cbScripts.Strings[cbScripts.ItemIndex];
     p.VerifyPath(s);
     end
  else
     begin
     p := nil;
     s := '';
     end;

  if p <> nil then
     begin
     v := TVariable.Create('Project', pvtObject, Integer(p), p.ClassType, True);
     RunScript(Applic.PS_Lib, s, Applic.LastDir, nil, [v], nil, true);
     end;
end;

procedure TfoMain.btnRunScript_Click(Sender: TObject);
var v: TVariable;
    x: TPascalScript;
    s: String;
    d: TScenariosDesigner;
begin
  d := getActiveDesigner();
  if d = nil then Exit;

  v := TVariable.Create('Project', pvtObject, Integer(d.Project), d.Project.ClassType, True);

  btnRunScript.Enabled := False;
  btnStopScript.Enabled := True;

  s := cbScripts.Strings[cbScripts.ItemIndex];
  d.Project.VerifyPath(s);

  x := TPascalScript.Create();
  try
    x.Code.LoadFromFile(s);
    x.Variables.AddVar(v);
    x.AssignLib(Applic.PS_Lib);
    if x.Compile() then
       x.Execute()
    else
       Dialogs.MessageDLG(x.Errors.Text, mtError, [mbOk], 0);
  finally
    btnRunScript.Enabled := true;
    btnStopScript.Enabled := false;
    x.Free();
  end;
end;

procedure TfoMain.btnStopScript_Click(Sender: TObject);
begin
 //
end;

procedure TfoMain.btnOpen_Click(Sender: TObject);
begin
  Open.InitialDir := Applic.LastDir;
  if Open.Execute() then
     begin
     CreateMDIChild(Open.FileName);
     Applic.LastDir := ExtractFilePath(Open.Filename);
     end;
end;

procedure TfoMain.btnSaveAs_Click(Sender: TObject);
var d: TScenariosDesigner;
begin
  d := getActiveDesigner();
  if d <> nil then
     begin
     Save.InitialDir := Applic.LastDir;
     if Save.Execute() then
        begin
        d.SaveToFile(Save.Filename);
        Applic.LastDir := ExtractFilePath(Save.Filename);
        end;
     end;
end;

end.

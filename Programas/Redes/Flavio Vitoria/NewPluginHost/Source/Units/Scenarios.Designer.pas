unit Scenarios.Designer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ExtDlgs, MSXML4, XML_Utils, 
  Rochedo.PanZoom,
  Rochedo.Component,
  Rochedo.Designer,
  Rochedo.Designer.ZoomPanel,
  Scenarios.Components;

type
  TScenariosDesigner = class(TZoomPanelDesigner)
    sbBG: TSpeedButton;
    OpenPicture: TOpenPictureDialog;
    procedure sbBGClick(Sender: TObject);
  private
    Fpc1, Fpc2: TPC;
    FProject: TProject;
    procedure internalConnectPC(Sender: TObject);
  protected
    procedure DoClick(Sender: TObject); override;
    function CanCreateObjectDirectlyOnDesigner(cc: TComponentClass): boolean; override;
    procedure DoDblClick(Sender: TObject); override;
    procedure SaveUserData(x: TXML_Writer); override;
    procedure LoadUserData(no: IXMLDomNode); override;
    procedure DoComponentCreated(c: TComponent); override; 
  public
    constructor Create(IDE: IIDE);
    property Project : TProject read FProject;
  end;

implementation
uses Scenarios.Consts,
     Scenarios.Application;

{$R *.dfm}

{ TScenariosDesigner }

procedure TScenariosDesigner.internalConnectPC(Sender: TObject);
var c: TComponent;
begin
  if getComponent(Sender, c) and (c is TPC) then
     begin
     if Fpc1 = nil then
        begin
        Fpc1 := TPC(c);
        if Fpc1.NextPC = nil then
           caption := 'PC1 selecionado'
        else
           begin
           caption := 'Este PC ja esta conectado a outro PC';
           Fpc1 := nil;
           end;
        end
     else
        if (c <> Fpc1) then
           begin
           Fpc2 := TPC(c);
           Fpc1.Connect(Fpc2, false);
           caption := 'coneccao formada entre o PC1 e o PC2';
           Fpc1 := nil;
           Fpc2 := nil;
           end
        else
           caption := 'Selecione um PC diferente do 1. selecionado';
     end
  else
     begin
     caption := 'Este objeto nao eh um PC. Comece novamente.';
     Fpc1 := nil;
     Fpc2 := nil;
     end;
end;

procedure TScenariosDesigner.DoClick(Sender: TObject);
begin
  if IDE.getStatus() = IDE_st_ConnectPC then
     internalConnectPC(Sender)
  else
     inherited DoClick(Sender);
end;

function TScenariosDesigner.CanCreateObjectDirectlyOnDesigner(cc: TComponentClass): boolean;
begin
  result := inherited CanCreateObjectDirectlyOnDesigner(cc);
  result := result and (cc <> TScenario);
end;

procedure TScenariosDesigner.sbBGClick(Sender: TObject);
begin
  if OpenPicture.Execute() then
     self.setBackgroundImage(OpenPicture.FileName);
end;

constructor TScenariosDesigner.Create(IDE: IIDE);
begin
  inherited Create(IDE);
  FProject := TProject.Create(self);
  setProject(FProject);
end;

procedure TScenariosDesigner.DoDblClick(Sender: TObject);
begin
  inherited DoDblClick(Sender);
  if Sender = getControl() then
     FProject.Edit();
end;

procedure TScenariosDesigner.LoadUserData(no: IXMLDomNode);
begin
  inherited LoadUserData(no);
  FProject.fromXML(no.childNodes.item[0]);
end;

procedure TScenariosDesigner.SaveUserData(x: TXML_Writer);
begin
  inherited SaveUserData(x);
  FProject.toXML(x);
end;

procedure TScenariosDesigner.DoComponentCreated(c: TComponent);
begin
  inherited DoComponentCreated(c);
  if c is TPC then
     FProject.AddPC( TPC(c) );
end;

end.

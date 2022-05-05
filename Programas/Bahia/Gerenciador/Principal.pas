unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, jpeg, StdCtrls, Buttons;

type
  TPrincipal_DLG = class(TForm)
    Panel1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel6: TPanel;
    Label5: TLabel;
    L0: TLabel;
    L4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    L1: TLabel;
    L2: TLabel;
    L3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label6: TLabel;
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FPath: String;  
  end;

var
  Principal_DLG: TPrincipal_DLG;

implementation
uses ShellAPI;

{$R *.DFM}

procedure TPrincipal_DLG.FormResize(Sender: TObject);
var i: Integer;
    c: TControl;
begin
  for i := 0 to ComponentCount - 1 do
    begin
    c := TControl(Components[i]);
    if c.Tag = 1 then
       c.Left := (Width div 2) - (c.Width div 2);
    end;

  L1.Left := L0.Left + 20;
  L2.Left := L1.Left;
  L3.Left := L1.Left;
  L4.Left := L0.Left;
end;

procedure TPrincipal_DLG.SpeedButton1Click(Sender: TObject);
begin
  ShellExecute(0, 'open',
     pChar(FPath + 'Mapa\Propagar\Propagar.exe'), nil, nil, SW_NORMAL);
end;

procedure TPrincipal_DLG.SpeedButton2Click(Sender: TObject);
begin
  ShellExecute(0, 'open',
     pChar(FPath + 'Mapa\MapaBahia.exe'), nil, nil, SW_NORMAL);
end;

procedure TPrincipal_DLG.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TPrincipal_DLG.FormCreate(Sender: TObject);
begin
  FPath := ExtractFilePath(Application.ExeName);
end;

end.

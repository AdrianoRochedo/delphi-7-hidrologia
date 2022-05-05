unit cd_Form_Selecionar_Man_Res;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, cd_Classes;

type
  TfoSel_Man_Res = class(TForm)
    sbRes: TSpeedButton;
    edRes: TEdit;
    Panel8: TPanel;
    edPasta: TEdit;
    Panel12: TPanel;
    Panel13: TPanel;
    sbMan: TSpeedButton;
    edMan: TEdit;
    Panel1: TPanel;
    Open: TOpenDialog;
    btnOk: TButton;
    btnCancel: TButton;
    procedure sbManClick(Sender: TObject);
    procedure sbResClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FCrop: TCrop;
    procedure SelecionarArquivo(E: TEdit; Ext: string);
  public
    constructor Create(Crop: TCrop);
  end;

implementation

{$R *.dfm}

{ TfoSel_Man_Res }

constructor TfoSel_Man_Res.Create(Crop: TCrop);
begin
  inherited Create(nil);
  FCrop := Crop;
  edPasta.Text := FCrop.WorkDir;
end;

procedure TfoSel_Man_Res.SelecionarArquivo(E: TEdit; Ext: string);
begin
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := Ext;
  Open.Filter := Format('Files %s|*.%s', [UpperCase(Ext), Ext]);
  if Open.Execute() then
     E.Text := ExtractRelativePath(edPasta.Text, Open.FileName);
end;

procedure TfoSel_Man_Res.sbManClick(Sender: TObject);
begin
  SelecionarArquivo(edMan, 'esq');
end;

procedure TfoSel_Man_Res.sbResClick(Sender: TObject);
begin
  SelecionarArquivo(edMan, 'res');
end;

procedure TfoSel_Man_Res.btnOkClick(Sender: TObject);
begin
  close;
  ModalResult := mrOK;
end;

procedure TfoSel_Man_Res.btnCancelClick(Sender: TObject);
begin
  close;
  ModalResult := mrCancel;
end;

end.

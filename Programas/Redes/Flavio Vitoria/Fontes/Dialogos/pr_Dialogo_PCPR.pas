unit pr_Dialogo_PCPR;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_PCP, ComCtrls, StdCtrls, Buttons, ExtCtrls, AxCtrls, OleCtrls,
  pr_Dialogo_PCPR_Curvas, Spin, drEdit;

type
  TprDialogo_PCPR = class(TprDialogo_PCP)
    Panel6: TPanel;
    edVolIni: TdrEdit;
    edVolMin: TdrEdit;
    edVolMax: TdrEdit;
    Panel13: TPanel;
    edArqPrec: TEdit;
    btnProcurar: TSpeedButton;
    Panel9: TPanel;
    Open: TOpenDialog;
    SpeedButton1: TSpeedButton;
    edArqETP: TEdit;
    Panel11: TPanel;
    cbStatus: TComboBox;
    btnCurvas: TBitBtn;
    edOperaUsuario: TEdit;
    Panel10: TPanel;
    b2: TButton;
    b22: TButton;
    b222: TButton;
    Panel14: TPanel;
    Panel7: TPanel;
    procedure btnProcurarClick(Sender: TObject);
    procedure cbDPEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCurvasClick(Sender: TObject);
    procedure b222Click(Sender: TObject);
    procedure b333Click(Sender: TObject);
    procedure btnGerClick(Sender: TObject);
  private
    { Private declarations }
  public
    Curvas: TprDialogo_Curvas;
  end;

implementation
uses pr_Classes,
     pr_Const,
     SysUtilsEx,
     psEditor,
     psBASE;

{$R *.DFM}

procedure TprDialogo_PCPR.btnProcurarClick(Sender: TObject);
begin
  inherited;
  Case TComponent(Sender).Tag of
    0: if Open.Execute then edArqPrec.Text := Open.FileName;
    1: if Open.Execute then edArqETP.Text := Open.FileName;
    end;
end;

procedure TprDialogo_PCPR.cbDPEClick(Sender: TObject);
begin
  inherited;
  //edCT.Enabled := cbDPE.Checked; xxx
  //edEF.Enabled := cbDPE.Checked;
  //if cbDPE.Checked then cbDPE.Caption := 'Sim' else cbDPE.Caption := 'Não';
end;

procedure TprDialogo_PCPR.FormCreate(Sender: TObject);
begin
  inherited;
  Curvas := TprDialogo_Curvas.Create(Self);

  // Manha para que as informações apareçam nas tabelas CV e AV
  Curvas.Left := -1600; Curvas.Top := -1600;
  Curvas.Show; Curvas.Hide;
  Curvas.Left := 100; Curvas.Top := 100;

  b2.Tag := integer(edOperaUsuario);   b22.Tag := b2.Tag;  b222.Tag := b2.Tag;
 //b3.Tag := integer(edEnergiaUsuario); b33.Tag := b3.Tag;  b333.Tag := b3.Tag; xxx
end;

procedure TprDialogo_PCPR.FormDestroy(Sender: TObject);
begin
  inherited;
  Curvas.Free;
end;

procedure TprDialogo_PCPR.btnCurvasClick(Sender: TObject);
begin
  Curvas.Show;
end;

procedure TprDialogo_PCPR.b222Click(Sender: TObject);
begin
  edOperaUsuario.Text := '';
end;

procedure TprDialogo_PCPR.b333Click(Sender: TObject);
begin
  edEnergiaUsuario.Text := '';
end;

procedure TprDialogo_PCPR.btnGerClick(Sender: TObject);
begin
  Form_Energia.Tipo := 2;
  Form_Energia.ShowModal;
end;

end.

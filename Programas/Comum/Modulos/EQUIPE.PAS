unit Equipe;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TDLG_Equipe = class(TForm)
    OKButton: TBitBtn;
    Bevel1: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    L_Lanna: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    L_Adriano: TLabel;
    procedure L_AdrianoClick(Sender: TObject);
    procedure L_AndersonClick(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure L_LannaClick(Sender: TObject);
  private
    procedure EnviarEMail(const Endereco: String);
  public
    { Public declarations }
  end;

var
  DLG_Equipe: TDLG_Equipe;

implementation
uses Shellapi, Dialogs;

{$R *.DFM}

procedure TDLG_Equipe.EnviarEMail(const Endereco: String);
begin
  if ShellExecute(Application.Handle,
                 'open',
                 PChar('mailto:' + Endereco),
                 '',
                 '',
                 SW_SHOWNORMAL) < 32 then

     MessageDLG('Não foi possível iniciar o Cliente de E`Mail.'#13 +
                'Certifíque-se que seu sistema está configurado corretamente.',
                mtInformation, [mbOK], 0);
end;

procedure TDLG_Equipe.L_AdrianoClick(Sender: TObject);
begin
  EnviarEMail('rochedo@ufpel.tche.br');
end;

procedure TDLG_Equipe.L_AndersonClick(Sender: TObject);
begin
  EnviarEMail('sandman@ufpel.tche.br');
end;

procedure TDLG_Equipe.Label11Click(Sender: TObject);
begin
  EnviarEMail('amachado@ufpel.tche.br');
end;

procedure TDLG_Equipe.Label9Click(Sender: TObject);
begin
  EnviarEMail('jviegas@conesul.com.br');
end;

procedure TDLG_Equipe.L_LannaClick(Sender: TObject);
begin
  EnviarEMail('lanna@if.ufrgs.br');
end;

end.


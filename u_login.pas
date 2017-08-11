unit u_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_login = class(TForm)
    img1: TImage;
    edtpengguna: TEdit;
    edtsandi: TEdit;
    btnlogin: TBitBtn;
    btnkeluar: TBitBtn;
    procedure btnkeluarClick(Sender: TObject);
    procedure btnloginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtpenggunaKeyPress(Sender: TObject; var Key: Char);
    procedure edtsandiKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_login: Tf_login;

implementation

uses
  u_dm, u_menu;

{$R *.dfm}

procedure Tf_login.btnkeluarClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure Tf_login.btnloginClick(Sender: TObject);
begin
 if (Trim(edtpengguna.Text)='') or (Trim(edtsandi.Text)='') then
  begin
    MessageDlg('Pengguna dan Kata Sandi Harus Diisi',mtWarning,[mbok],0);
    Exit;
  end;

 with dm.tblpengguna do
  begin
    if (edtpengguna.Text=FieldByName('nama_pengguna').AsString) and (edtsandi.Text=FieldByName('kata_sandi').AsString) then
     begin
        f_menu.ShowModal;
        Self.Close;
     end
    else
     begin
       MessageDlg('Pengguna atau Kata Sandi Salah',mtError,[mbOK],0);
       edtpengguna.Clear;
       edtsandi.Clear;
       edtpengguna.SetFocus;
     end;
  end;
end;

procedure Tf_login.FormShow(Sender: TObject);
begin
 edtpengguna.Clear; edtpengguna.SetFocus;
 edtsandi.Clear;
end;

procedure Tf_login.edtpenggunaKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then edtsandi.SetFocus;
end;

procedure Tf_login.edtsandiKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then btnlogin.Click;
end;

end.

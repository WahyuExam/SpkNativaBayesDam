unit u_ubahsandi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_ubahsandi = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label4: TLabel;
    edtpengguna: TEdit;
    grp3: TGroupBox;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    edtsandilama: TEdit;
    edtsandibaru: TEdit;
    btnubah: TBitBtn;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_ubahsandi: Tf_ubahsandi;

implementation

uses
  u_dm;

{$R *.dfm}

procedure Tf_ubahsandi.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_ubahsandi.FormShow(Sender: TObject);
begin
 with dm.tblpengguna do
  begin
    edtpengguna.Text:=fieldbyname('nama_pengguna').AsString;
    edtsandilama.Text:=fieldbyname('kata_sandi').AsString;
  end;
  edtpengguna.Enabled:=false;
  edtsandilama.Enabled:=false;
  edtsandibaru.Enabled:=false; edtsandibaru.Clear;

  btnubah.Enabled:=True; btnubah.Caption:='Ubah';
  btnsimpan.Enabled:=false;
  btnkeluar.Enabled:=True;
end;

procedure Tf_ubahsandi.btnubahClick(Sender: TObject);
begin
 if btnubah.Caption='Ubah' then
  begin
    edtsandibaru.Enabled:=True; edtsandibaru.SetFocus;

    btnubah.Caption:='Batal';
    btnsimpan.Enabled:=True;
    btnkeluar.Enabled:=false;
  end
  else
 if btnubah.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_ubahsandi.btnsimpanClick(Sender: TObject);
begin
 if Trim(edtsandibaru.Text)='' then
  begin
    MessageDlg('Kata Sandi Baru Belum Dimasukkan',mtWarning,[mbok],0);
    edtsandibaru.SetFocus;
    Exit;
  end;
  
 if MessageDlg('Yakin Kata Sandi Akan Diubah',mtConfirmation,[mbYes,mbNo],0)=mryes then
  begin
    dm.tblpengguna.Edit;
    dm.tblpengguna.FieldByName('kata_sandi').AsString := edtsandibaru.Text;
    dm.tblpengguna.Post;
  end;
  MessageDlg('Kata Sandi Sudah Diubah',mtInformation,[mbOK],0);
  FormShow(Sender);
end;

end.

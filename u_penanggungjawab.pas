unit u_penanggungjawab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_penanggungjawab = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtnip: TEdit;
    edtnama: TEdit;
    edtjabatan: TEdit;
    grp3: TGroupBox;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    btnubah: TBitBtn;
    img1: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure edtnipKeyPress(Sender: TObject; var Key: Char);
    procedure edtnamaKeyPress(Sender: TObject; var Key: Char);
    procedure edtjabatanKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_penanggungjawab: Tf_penanggungjawab;

implementation

uses
  u_dm;

{$R *.dfm}

procedure Tf_penanggungjawab.FormShow(Sender: TObject);
begin
 with dm.tblpenanggung do
  begin
    edtnip.Text:=fieldbyname('nip').AsString;
    edtnama.Text:=fieldbyname('nama').AsString;
    edtjabatan.Text:=fieldbyname('jabatan').AsString;
  end;
  edtnip.Enabled:=false;
  edtnama.Enabled:=false;
  edtjabatan.Enabled:=false;

  btnubah.Enabled:=True; btnubah.Caption:='Ubah';
  btnsimpan.Enabled:=false;
  btnkeluar.Enabled:=True;

end;

procedure Tf_penanggungjawab.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_penanggungjawab.btnubahClick(Sender: TObject);
begin
 if btnubah.Caption='Ubah' then
  begin
    edtnip.Enabled:=True; edtnip.SetFocus;
    edtnama.Enabled:=True;
    edtjabatan.Enabled:=True;
  
    btnubah.Caption:='Batal';
    btnsimpan.Enabled:=True;
    btnkeluar.Enabled:=false;
  end
  else
 if btnubah.Caption='Batal' then FormShow(Sender);

end;

procedure Tf_penanggungjawab.btnsimpanClick(Sender: TObject);
begin
 if (Trim(edtnip.Text)='') or (Trim(edtnama.Text)='') or (Trim(edtjabatan.Text)='') then
  begin
    MessageDlg('Semua Data Harus Diisi',mtWarning,[mbok],0);
    edtnip.SetFocus;
    Exit;
  end
  else
  begin
    dm.tblpenanggung.Edit;
    dm.tblpenanggung.FieldByName('nip').AsString := edtnip.Text;
    dm.tblpenanggung.FieldByName('nama').AsString:=edtnama.Text;
    dm.tblpenanggung.FieldByName('jabatan').AsString:=edtjabatan.Text;
    dm.tblpenanggung.Post;
    MessageDlg('Data Sudah Disimpan',mtInformation,[mbOK],0);
    FormShow(Sender);
  end;
end;

procedure Tf_penanggungjawab.edtnipKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (Key in ['0'..'9',#13,#8,#9]) then key:=#0;
 if Key=#13 then edtnama.SetFocus;
end;

procedure Tf_penanggungjawab.edtnamaKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (Key in ['0'..'9',#13,#8,#9,#32,'a'..'z','A'..'Z',',','.']) then key:=#0;
 if Key=#13 then edtjabatan.SetFocus;
end;

procedure Tf_penanggungjawab.edtjabatanKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (Key in ['0'..'9',#13,#8,#9,#32,'a'..'z','A'..'Z',',','.','&','/']) then key:=#0;
 if Key=#13 then btnsimpan.Click;
end;

end.

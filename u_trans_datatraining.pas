unit u_trans_datatraining;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_trans_datatraining = class(TForm)
    grp2: TGroupBox;
    Label7: TLabel;
    grp1: TGroupBox;
    Label2: TLabel;
    edt_namadam: TEdit;
    btnbantu: TBitBtn;
    edtkode: TEdit;
    dbgrd1: TDBGrid;
    grp3: TGroupBox;
    Label1: TLabel;
    mmokriteria: TMemo;
    Label3: TLabel;
    rbya: TRadioButton;
    rbtidak: TRadioButton;
    cbbkeputusan: TComboBox;
    Label4: TLabel;
    grp4: TGroupBox;
    btnbatal2: TBitBtn;
    btnsimpan: TBitBtn;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    btnkeluar: TBitBtn;
    btntambah: TBitBtn;
    img1: TImage;
    edtkode_proses: TEdit;
    cbb_nilai: TComboBox;
    edtkeputusan: TEdit;
    procedure btntambahClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure btnbantuClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnbatal2Click(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure cbbkeputusanKeyPress(Sender: TObject; var Key: Char);
    procedure cbb_nilaiChange(Sender: TObject);
    procedure cbb_nilaiKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
    procedure konek_tampil(kode:string);
    procedure data_training(kode:string);
    procedure update_data_dam(kode, ket : string);
  end;

var
  f_trans_datatraining: Tf_trans_datatraining;
  status, kd, kode_proses, kode_kriteria, kode_dam : string;
  a, urut, b : Integer;
  ada, st : Boolean;

implementation

uses
  u_dm, StrUtils, u_bantu_dam, ADODB;

{$R *.dfm}

procedure Tf_trans_datatraining.btntambahClick(Sender: TObject);
begin
 if btntambah.Caption='Tambah' then
  begin
    f_bantu_dam.edt2.Text:='tambah';
    btnbantu.Enabled:=True;

    status:='tambah';
    btntambah.Caption:='Batal';

    btnubah.Enabled:=false;
  end
  else
 if btntambah.Caption='Batal' then
  begin
    if status='tambah' then
     begin
       with dm.qrytraining do
        begin
         close;
         SQL.Clear;
         SQL.Text:='delete from t_training where kode_train='+QuotedStr(edtkode_proses.Text)+'';
         ExecSQL;
        end;
       konek_tampil('kosong');
       FormShow(Sender);
     end
     else
    if status='ubah' then FormShow(Sender);
  end;
end;

procedure Tf_trans_datatraining.FormShow(Sender: TObject);
begin
 edt_namadam.Enabled:=false; edt_namadam.Clear;
 btnbantu.Enabled:=false;
 dbgrd1.Enabled:=false;

 mmokriteria.Clear; mmokriteria.Enabled:=false;
 {rbya.Checked:=false; rbya.Enabled:=false;
 rbtidak.Checked:=false; rbtidak.Enabled:=false;
 cbbkeputusan.Text:=''; cbbkeputusan.Enabled:=false;}
 cbb_nilai.Enabled:=false; cbb_nilai.Text:='';
 edtkeputusan.Enabled:=false; edtkeputusan.Clear;

 btntambah.Caption:='Tambah'; btntambah.Enabled:=True; btntambah.BringToFront;
 btnsimpan.Enabled:=false;
 btnubah.Enabled:=True;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=True;
 konek_tampil('kosong');
end;

procedure Tf_trans_datatraining.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_trans_datatraining.konek;
begin
 with dm.qrytraining do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from t_training order by kode_train asc';
    Open;
  end;
end;

procedure Tf_trans_datatraining.konek_tampil(kode: string);
begin
 with dm.qrytampil_training do
  begin
    close;
    SQL.Clear;
    sql.Add('select a.kode_train, b.kode_dam, b.nama_dam, b.alamat_dam, b.penanggung_jawab, b.tahun,');
    sql.Add('b.ket, c.kode_kriteria, c.kriteria, a.hasil, a.keputusan, a.nil_angka from t_training a, t_dam b, t_kriteria c');
    sql.Add('where a.kode_dam=b.kode_dam and a.kode_kriteria=c.kode_kriteria');
    sql.Add('and a.kode_train='+QuotedStr(kode)+'');
    Open;
  end;
end;

procedure Tf_trans_datatraining.btnbantuClick(Sender: TObject);
var sql_qry : string;
begin
 f_bantu_dam.edt1.Text:='training';

 if f_bantu_dam.edt2.Text='tambah' then sql_qry:='-';
 if f_bantu_dam.edt1.Text='training' then
  begin
    if f_bantu_dam.edt2.Text='ubah' then  sql_qry:='training';
    with dm.qrydam  do
      begin
        close;
        SQL.Clear;
        SQL.Text:='select * from t_dam where ket='+QuotedStr(sql_qry)+'';
        Open;
        if IsEmpty then
         begin
           MessageDlg('Data Dam Tidak Ada',mtWarning,[mbok],0);
           Exit;
         end;
      end;
  end;

 f_bantu_dam.ShowModal;
end;

procedure Tf_trans_datatraining.dbgrd1DblClick(Sender: TObject);
begin
 mmokriteria.Text:=dbgrd1.Fields[8].AsString;
 kode_kriteria := dbgrd1.Fields[7].AsString;

 if dbgrd1.Fields[11].AsString='Ya' then rbya.Checked:=True else
 if dbgrd1.Fields[11].AsString='Tidak' then rbtidak.Checked:=True else
 if dbgrd1.Fields[11].AsString='' then
  begin
    rbya.Checked:=false;
    rbtidak.Checked:=False;
  end;

 if dbgrd1.Fields[9].AsString='' then cbb_nilai.Text:='' else cbb_nilai.Text := dbgrd1.Fields[9].AsString;

 cbb_nilai.Enabled:=True;
 rbya.Enabled:=True;
 rbtidak.Enabled:=True;
 dbgrd1.Enabled:=false;
 cbbkeputusan.Enabled:=false;

 btnbatal2.BringToFront;
 btnsimpan.Enabled:=True; btnsimpan.Caption:='Simpan';
 btnubah.Enabled:=false;
 btnhapus.Enabled:=False;
 btnkeluar.Enabled:=false;
end;

procedure Tf_trans_datatraining.btnbatal2Click(Sender: TObject);
begin
 mmokriteria.Clear; mmokriteria.Enabled:=False;
 rbya.Checked:=false; rbtidak.Checked:=False;
 rbya.Enabled:=false; rbtidak.Enabled:=False;
 cbb_nilai.Text:=''; cbb_nilai.Enabled:=false;
 btnbatal2.SendToBack;
 dbgrd1.Enabled:=True;

 if status='ubah' then
  begin
    cbbkeputusan.Enabled:=True;
    btnsimpan.Caption:='Selesai';
  end;
end;

procedure Tf_trans_datatraining.btnsimpanClick(Sender: TObject);
var nil_angka : Integer;
begin
 if btnsimpan.Caption='Simpan' then
  begin
    if (rbya.Checked=False) and (rbtidak.Checked=False) then
     begin
       MessageDlg('Penilaian Belum Diberikan',mtWarning,[mbok],0);
       Exit;
     end;

    with dm.qrytraining do
     begin
       if Locate('kode_train;kode_kriteria',VarArrayOf([edtkode_proses.Text,kode_kriteria]),[]) then
        begin
          Edit;
          if rbya.Checked=True then FieldByName('hasil').AsString := rbya.Caption else
          if rbtidak.Checked=True then FieldByName('hasil').AsString := rbtidak.Caption;
          FieldByName('nil_angka').AsString := cbb_nilai.Text;
          Post;
        end;
     end;
     btnbatal2.Click;
     konek_tampil(edtkode_proses.Text);

    //cek semua penilaian klo masih ada kosong
    with dm.qrytampil_training do
     begin
       konek_tampil(edtkode_proses.Text);
       a:=1;
       ada := false;
       st := false;

       while st=false do
        begin
         RecNo:=a;
         if FieldByName('hasil').AsString='' then
          begin
           ada := True;
           urut:=RecNo;
           st:=True;
          end
         else
         begin
          a:=a+1;
          if a > recordcount then st:=True;
         end;
        end;

       if ada=True then
         begin
          btnsimpan.Caption:='Simpan';
          cbbkeputusan.Enabled:=false;
          RecNo:=urut;
          dbgrd1.OnDblClick(Sender);
         end
       else
         begin
          cbbkeputusan.Enabled:=True;
          btnsimpan.Caption:='Selesai';
          with dm.qrytraining do
           begin
             close;
             SQL.Clear;
             SQL.Text:='select * from t_training where kode_train='+QuotedStr(edtkode_proses.Text)+'';
             Open;
             nil_angka :=0;
             for a:=1 to RecordCount do
              begin
                RecNo := a;
                nil_angka := nil_angka + fieldbyname('nil_angka').AsVariant;
              end;
           end;
           //ShowMessage(IntToStr(nil_angka));
           if nil_angka > 70 then edtkeputusan.Text:='Layak Fisik' else edtkeputusan.Text:='Tidak Layak Fisik';
         end;
     end;
    //

    //tambahn lagi pembeda antar status tambah dan simpan
    if status='ubah' then
     begin
       btntambah.Enabled:=false;
     end;
  end
  else
 if btnsimpan.Caption='Selesai' then
  begin
    if cbbkeputusan.Text='' then
     begin
       MessageDlg('Keputusan Belum Dipilih',mtInformation,[mbok],0);
       cbbkeputusan.SetFocus;
     end
     else
     begin
       with dm.qrytraining do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_training set keputusan='+QuotedStr(edtkeputusan.Text)+' where kode_train='+QuotedStr(edtkode_proses.Text)+'';
          ExecSQL;
        end;
        update_data_dam(edtkode.Text,'training');
        FormShow(Sender);
        MessageDlg('Semua Penilaian Sudah Disimpan',mtInformation,[mbok],0);
     end;
  end;
end;

procedure Tf_trans_datatraining.data_training(kode: string);
begin
 with dm.qrytraining do
  begin
   close;
   SQL.Clear;
   SQL.Text:='select * from t_training where kode_train='+QuotedStr(kode)+'';
   Open;
  end;
end;

procedure Tf_trans_datatraining.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Apakah Data Akan Dihapus',mtConfirmation,[mbYes,mbno],0)=mryes then
  begin
    with dm.qrytraining do
     begin
       close;
       SQL.Clear;
       SQL.Text:='delete from t_training where kode_train='+QuotedStr(edtkode_proses.Text)+'';
       ExecSQL;
     end;
     update_data_dam(edtkode.Text,'-');
     FormShow(Sender);
     MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
  end;
end;

procedure Tf_trans_datatraining.btnubahClick(Sender: TObject);
begin
 btnbantu.Enabled:=True;
 f_bantu_dam.edt2.Text:='ubah';
 status:='ubah';

 btnubah.Enabled:=false;
 btntambah.Caption:='Batal';
end;

procedure Tf_trans_datatraining.update_data_dam(kode, ket: string);
begin
 with dm.qrydam do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_dam set ket='+QuotedStr(ket)+' where kode_dam='+QuotedStr(kode)+'';
    ExecSQL;

    Close;
    sql.Clear;
    SQL.Text:='select * from t_dam';
    Open;
  end;
end;

procedure Tf_trans_datatraining.cbbkeputusanKeyPress(Sender: TObject;
  var Key: Char);
begin
 key:=#0;
end;

procedure Tf_trans_datatraining.cbb_nilaiChange(Sender: TObject);
begin
 if cbb_nilai.Text='0' then rbtidak.Checked:=True else
 if StrToInt(cbb_nilai.Text)>0 then rbya.Checked:=True;
 btnsimpan.Click;
end;

procedure Tf_trans_datatraining.cbb_nilaiKeyPress(Sender: TObject;
  var Key: Char);
begin
 key:=#0;
end;

end.

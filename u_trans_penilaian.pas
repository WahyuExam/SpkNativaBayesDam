unit u_trans_penilaian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_trans_penilaian = class(TForm)
    edtkode: TEdit;
    grp2: TGroupBox;
    Label7: TLabel;
    grp1: TGroupBox;
    Label4: TLabel;
    edttahun: TEdit;
    dbgrd1: TDBGrid;
    Label2: TLabel;
    edt_namadam: TEdit;
    btnbantu: TBitBtn;
    grp3: TGroupBox;
    Label1: TLabel;
    mmokriteria: TMemo;
    Label3: TLabel;
    rbya: TRadioButton;
    rbtidak: TRadioButton;
    grp4: TGroupBox;
    btnbatal2: TBitBtn;
    btntambah: TBitBtn;
    btnsimpan: TBitBtn;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    btnkeluar: TBitBtn;
    img1: TImage;
    edtkode_proses: TEdit;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btntambahClick(Sender: TObject);
    procedure btnbatal2Click(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure btnbantuClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure rbtidakClick(Sender: TObject);
    procedure rbyaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek_tampil(kode:string);
    procedure konek;
    procedure update_data_dam (kode, ket, thn_nil :string);
  end;

var
  f_trans_penilaian: Tf_trans_penilaian;
  status, kd, kode_proses, kode_kriteria, kode_dam : string;
  a, urut : Integer;
  ada, st : Boolean;

implementation

uses
  u_dm, StrUtils, u_bantu_dam, DB, u_bantu_dam_nilai;

{$R *.dfm}

procedure Tf_trans_penilaian.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_trans_penilaian.FormShow(Sender: TObject);
begin
 btnbantu.Enabled:=false;
 dbgrd1.Enabled:=false;
 edttahun.Enabled:=True; edttahun.Text:=FormatDateTime('yyyy',Now);
 edt_namadam.Clear;

 mmokriteria.Clear; mmokriteria.Enabled:=false;
 rbya.Checked:=false; rbya.Enabled:=false;
 rbtidak.Checked:=false; rbtidak.Enabled:=false;

 btntambah.Caption:='Tambah'; btntambah.Enabled:=True; btntambah.BringToFront;
 btnsimpan.Enabled:=false;
 btnubah.Enabled:=True;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=True;
 konek_tampil('kosong');
 edtkode_proses.Clear;
end;

procedure Tf_trans_penilaian.konek_tampil(kode: string);
begin
 with dm.qrytampil_proses do
  begin
    close;
    SQL.Clear;
    sql.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.penanggung_jawab,  b.ket, c.kode_kriteria,');
    sql.Add('c.kriteria, d.hasil, a.p_layakfisik, a.p_tidaklayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusan from');
    sql.Add('t_hasil a, t_dam b, t_kriteria c, t_proses d where a.kode_dam=b.kode_dam and d.kode_proses=a.kode_proses and');
    sql.Add('d.kode_kriteria=c.kode_kriteria and a.kode_proses='+QuotedStr(kode)+'');
    Open;
  end;
end;

procedure Tf_trans_penilaian.btntambahClick(Sender: TObject);
begin
 if btntambah.Caption='Tambah' then
  begin
    if edttahun.Text='' then
     begin
      MessageDlg('Tahun Penilaian Harus Diisi',mtWarning,[mbok],0);
      edttahun.SetFocus;
      exit;
     end;

    f_bantu_dam.edt2.Text:='tambah';
    btnbantu.Enabled:=True;
    edttahun.Enabled:=false;

    status:='tambah';
    btntambah.Caption:='Batal';

    btnubah.Enabled:=false;
  end
  else
 if btntambah.Caption='Batal' then
  begin
    if status='tambah' then
     begin
       //ShowMessage(status);
       with dm.qryhasil do
        begin
         close;
         SQL.Clear;
         SQL.Text:='delete from t_hasil where kode_proses='+QuotedStr(edtkode_proses.Text)+'';
         ExecSQL;
        end;
       konek_tampil('kosong');
       FormShow(Sender);
     end
     else
    if status='ubah' then FormShow(Sender);
  end;
end;

procedure Tf_trans_penilaian.konek;
begin
 with dm.qryhasil do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from t_hasil order by kode_proses asc';
    Open;
  end;
end;

procedure Tf_trans_penilaian.btnbatal2Click(Sender: TObject);
begin
 mmokriteria.Clear; mmokriteria.Enabled:=False;
 rbya.Checked:=false; rbtidak.Checked:=False;
 rbya.Enabled:=false; rbtidak.Enabled:=False;
 btnbatal2.SendToBack;
 dbgrd1.Enabled:=True;

 if status='ubah' then
  begin
    btnsimpan.Caption:='Selesai';
  end;
end;

procedure Tf_trans_penilaian.btnsimpanClick(Sender: TObject);
begin
 if btnsimpan.Caption='Simpan' then
  begin
    if (rbya.Checked=False) and (rbtidak.Checked=False) then
     begin
       MessageDlg('Penilaian Belum Diberikan',mtWarning,[mbok],0);
       Exit;
     end;

    with dm.qryproses do
     begin
      close;
      sql.Clear;
      sql.Text:='select * from t_proses';
      open;
       if Locate('kode_proses;kode_kriteria',VarArrayOf([edtkode_proses.Text,kode_kriteria]),[]) then
        begin
          Edit;
          if rbya.Checked=True then FieldByName('hasil').AsString := rbya.Caption else
          if rbtidak.Checked=True then FieldByName('hasil').AsString := rbtidak.Caption;
          Post;
        end;
     end;
     btnbatal2.Click;
     konek_tampil(edtkode_proses.Text);

    //cek semua penilaian klo masih ada kosong
    with dm.qrytampil_proses do
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
          RecNo:=urut;
          dbgrd1.OnDblClick(Sender);
         end
       else
         begin
          btnsimpan.Caption:='Selesai';
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
     update_data_dam(edtkode.Text,'sudah_dinilai',edttahun.Text);
     FormShow(Sender);
     MessageDlg('Semua Penilai Sudah Disimpan',mtInformation,[mbok],0);
  end;
end;

procedure Tf_trans_penilaian.dbgrd1DblClick(Sender: TObject);
begin
 mmokriteria.Text:=dbgrd1.Fields[8].AsString;
 kode_kriteria := dbgrd1.Fields[7].AsString;

 if dbgrd1.Fields[9].AsString='Ya' then rbya.Checked:=True else
 if dbgrd1.Fields[9].AsString='Tidak' then rbtidak.Checked:=True else
 if dbgrd1.Fields[9].AsString='' then
  begin
    rbya.Checked:=false;
    rbtidak.Checked:=False;
  end;

 rbya.Enabled:=True;
 rbtidak.Enabled:=True;
 dbgrd1.Enabled:=false;

 btnbatal2.BringToFront;
 btnsimpan.Enabled:=True; btnsimpan.Caption:='Simpan';
 btnubah.Enabled:=false;
 btnhapus.Enabled:=False;
 btnkeluar.Enabled:=false;
end;

procedure Tf_trans_penilaian.btnubahClick(Sender: TObject);
begin
 btnbantu.Enabled:=True;
 edttahun.Enabled:=false;
 f_bantu_dam.edt2.Text:='ubah';
 status:='ubah';
 
 btntambah.Caption:='Batal';
 btnubah.Enabled:=false;
end;

procedure Tf_trans_penilaian.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Apakah Data Akan Dihapus',mtConfirmation,[mbYes,mbno],0)=mryes then
  begin
    with dm.qryhasil do
     begin
       close;
       SQL.Clear;
       SQL.Text:='delete from t_hasil where kode_proses='+QuotedStr(edtkode_proses.Text)+'';
       ExecSQL;
     end;
     update_data_dam(edtkode.Text,'-','-');
     FormShow(Sender);
     MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
  end;
end;

procedure Tf_trans_penilaian.btnbantuClick(Sender: TObject);
var sql_qry, sql_qry_thn :string;
begin
 if edttahun.Text='' then
  begin
    MessageDlg('Tahun Belum Diisi',mtWarning,[mbok],0);
    edttahun.Enabled:=true;
    edttahun.SetFocus;
    Exit;
  end;

 if status='tambah' then
  begin
   f_bantu_dam.edt1.Text:='penilaian';

   if f_bantu_dam.edt1.Text='penilaian' then
     begin
      if f_bantu_dam.edt2.Text='ubah' then
       begin
         sql_qry:='sudah_dinilai';
         sql_qry_thn := 'thn_nil = '+QuotedStr(edttahun.Text)+'';
       end
       else
      if f_bantu_dam.edt2.Text='tambah' then
       begin
        sql_qry:='-';
        sql_qry_thn := 'thn_nil <> '+QuotedStr(edttahun.Text)+'';
       end;

      with dm.qrydam  do
       begin
        close;
        SQL.Clear;                               
        SQL.Text:='select * from t_dam where ket='+QuotedStr(sql_qry)+' and '+sql_qry_thn+'';
        Open;
        if IsEmpty then
         begin
          MessageDlg('Data Dam Tidak Ada',mtWarning,[mbok],0);
          Exit;
         end;
       end;
     end;
     f_bantu_dam.ShowModal;
  end
  else
 if status='ubah' then
  begin
    with dm.qrybantu_damnil do
     begin
       Close;
       SQL.Clear;
       SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket, a.keputusan from t_hasil a,');
       sql.Add('t_dam b  where a.kode_dam=b.kode_dam and a.tahun='+QuotedStr(edttahun.Text)+'');
       Open;
       if IsEmpty then
        begin
          MessageDlg('Data Dam Tidak Ada',mtWarning,[mbok],0);
          Exit;
        end
        else
        begin
         f_bantu_dam_nil.edt1.Text:='penilaian'; 
         f_bantu_dam_nil.ShowModal;
        end;
     end;
  end;
end;

procedure Tf_trans_penilaian.edttahunKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
end;

procedure Tf_trans_penilaian.update_data_dam(kode, ket, thn_nil: string);
begin
 with dm.qrydam do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_dam set ket='+QuotedStr(ket)+', thn_nil='+QuotedStr(thn_nil)+' where kode_dam='+QuotedStr(kode)+'';
    ExecSQL;

    Close;
    sql.Clear;
    SQL.Text:='select * from t_dam';
    Open;
  end;
end;

procedure Tf_trans_penilaian.rbtidakClick(Sender: TObject);
begin
 //btnsimpan.Click;
end;

procedure Tf_trans_penilaian.rbyaClick(Sender: TObject);
begin
 //btnsimpan.Click;
end;

end.

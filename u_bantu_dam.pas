unit u_bantu_dam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, jpeg;

type
  Tf_bantu_dam = class(TForm)
    grp2: TGroupBox;
    Label11: TLabel;
    edt1: TEdit;
    grp1: TGroupBox;
    dbgrd1: TDBGrid;
    grp3: TGroupBox;
    btn1: TBitBtn;
    btnkeluar: TBitBtn;
    img1: TImage;
    edt2: TEdit;
    procedure btn1Click(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
    procedure konek_tampil (kode:string);
    procedure konek_tampil_nil (kode:string);
    procedure konek_nil;
  end;

var
  f_bantu_dam: Tf_bantu_dam;
  status, kd, kode_proses, kode_kriteria, kode_dam : string;
  a, urut : Integer;
  ada : Boolean;


implementation

uses
  u_trans_datatraining, u_trans_penilaian, u_lap_penilaian, DB, u_dm,
  StrUtils;

{$R *.dfm}

procedure Tf_bantu_dam.btn1Click(Sender: TObject);
begin
 if edt1.Text='training' then
  begin
   f_trans_datatraining.FormShow(Sender);
   f_trans_datatraining.edt_namadam.Text:=dbgrd1.Fields[1].AsString;
   f_trans_datatraining.edtkode.Text:=dbgrd1.Fields[0].AsString;

   if edt2.Text='tambah' then
    begin
      with dm.qrytraining do
      begin
       close;
       sql.Clear;
       SQL.Text:='select * from t_training where kode_dam='+QuotedStr(dbgrd1.Fields[0].AsString)+'';
       Open;
       if IsEmpty then
        begin
          konek;
          if IsEmpty then kd:='001' else
           begin
             Last;
             kd := RightStr(fieldbyname('kode_train').AsString,3);
             kd := IntToStr(StrToInt(kd)+1);
           end;
           kode_proses := 'TRN-'+Format('%.3d',[StrToInt(kd)]);

           //simpan ke data train
           //code..
           with dm.qrykriteria do
            begin
             close;
             SQL.Clear;
             sql.Text:='select * from t_kriteria order by kode_kriteria asc';
             Open;
             for a:=1 to RecordCount do
              begin
                RecNo:=a;
                with dm.qrytraining do
                 begin
                   Append;
                   FieldByName('kode_train').AsString := kode_proses;
                   FieldByName('kode_dam').AsString := dbgrd1.Fields[0].AsString;
                   FieldByName('kode_kriteria').AsString := dm.qrykriteria.fieldbyname('kode_kriteria').AsString;
                   Post;
                 end;
              end;
              a:=a+1;
            end;
           //
           konek_tampil(kode_proses);
           with f_trans_datatraining do
            begin
             dbgrd1.Enabled:=True;
             //rbya.Enabled:=True; rbtidak.Enabled:=True;
             btnbantu.Enabled:=false;
             edtkode_proses.Text:=kode_proses;

             btntambah.Caption:='Batal'; btntambah.BringToFront;
             btnsimpan.Enabled:=True; btnsimpan.Caption:='Simpan';
             btnubah.Enabled:=False;
             btnhapus.Enabled:=false;
             btnkeluar.Enabled:=False;
             status:='tambah';
            end;
        end;
      end;
    end
    else
   if edt2.Text='ubah' then
    begin
      with dm.qrytraining do
       begin
         close;
         SQL.Clear;
         SQL.Text:='select * from t_training where kode_dam='+QuotedStr(dbgrd1.Fields[0].AsString)+'';
         Open;
         f_trans_datatraining.edtkode_proses.Text:=fieldbyname('kode_train').AsString;
       end;
       kode_proses:=f_trans_datatraining.edtkode_proses.Text;
       konek_tampil(kode_proses);

       with f_trans_datatraining do
        begin
          btnubah.Enabled:=false;
          btnsimpan.Enabled:=True;
          btntambah.Enabled:=True; btntambah.BringToFront; btntambah.Caption:='Batal';
          btnhapus.Enabled:=True;
          btnkeluar.Enabled:=False;
          dbgrd1.Enabled:=True;

          if dm.qrytraining.Locate('kode_dam',Self.dbgrd1.Fields[0].AsString,[]) then cbbkeputusan.Text:=dm.qrytraining.fieldbyname('keputusan').AsString;
        end;
    end;
  end
 else
 if edt1.Text='penilaian' then
  begin
   //f_trans_penilaian.FormShow(Sender);
   f_trans_penilaian.edt_namadam.Text:=dbgrd1.Fields[1].AsString;
   f_trans_penilaian.edtkode.Text:=dbgrd1.Fields[0].AsString;

   //
   with dm.qryhasil_bayes do
    begin
      close;
      SQL.Clear;
      SQL.Text:='select * from t_hasil where kode_dam='+QuotedStr(dbgrd1.Fields[0].AsString)+' and tahun='+QuotedStr(f_trans_penilaian.edttahun.Text)+'';
      Open;
      if not IsEmpty then
       begin
         MessageDlg('DAM Sudah Dinilai Pada Tahun ini',mtWarning,[mbok],0);
         Exit;
       end;
    end;
   //

   if edt2.Text='tambah' then
    begin
      with dm.qryhasil do
      begin
       close;
       sql.Clear;
       SQL.Text:='select * from t_hasil where kode_dam='+QuotedStr(dbgrd1.Fields[0].AsString)+' and tahun='+QuotedStr(f_trans_penilaian.edttahun.Text)+'';
       Open;
       if IsEmpty then
        begin
          //ShowMessage('kosong');
          konek_nil;
          if IsEmpty then kd:='001' else
           begin
             Last;
             kd := RightStr(fieldbyname('kode_proses').AsString,3);
             kd := IntToStr(StrToInt(kd)+1);
           end;
           kode_proses := 'PRS-'+Format('%.3d',[StrToInt(kd)]);

           //simpan ke data hasil
           //code..
           with dm.qryhasil do
            begin
              Append;
              FieldByName('kode_proses').AsString := kode_proses;
              FieldByName('tahun').AsString := f_trans_penilaian.edttahun.Text;
              FieldByName('kode_dam').AsString := dbgrd1.Fields[0].AsString;
              Post;
            end;

            //simpan ke dalam train
           with dm.qrykriteria do
            begin
             close;
             SQL.Clear;
             sql.Text:='select * from t_kriteria order by kode_kriteria asc';
             Open;
             for a:=1 to RecordCount do
              begin
                RecNo:=a;
                with dm.qryproses do
                 begin
                   Append;
                   FieldByName('kode_proses').AsString := kode_proses;
                   FieldByName('kode_kriteria').AsString := dm.qrykriteria.fieldbyname('kode_kriteria').AsString;
                   Post;
                 end;
              end;
              a:=a+1;
            end;
           //
           konek_tampil_nil(kode_proses);
           with f_trans_penilaian do
            begin
             dbgrd1.Enabled:=True;
             //rbya.Enabled:=True; rbtidak.Enabled:=True;
             btnbantu.Enabled:=false;
             edtkode_proses.Text:=kode_proses;
             edttahun.Enabled:=false;

             btntambah.Caption:='Batal'; btntambah.BringToFront;
             btnsimpan.Enabled:=True; btnsimpan.Caption:='Simpan';
             btnubah.Enabled:=False;
             btnhapus.Enabled:=false;
             btnkeluar.Enabled:=False;
             status:='tambah';
            end;
        end;
      end;
    end
  end;
 Close;
end;

procedure Tf_bantu_dam.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_bantu_dam.konek;
begin
 with dm.qrytraining do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from t_training order by kode_train asc';
    Open;
  end;
end;

procedure Tf_bantu_dam.konek_nil;
begin
 with dm.qryhasil do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from t_hasil order by kode_proses asc';
    Open;
  end;
end;

procedure Tf_bantu_dam.konek_tampil (kode:string);
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

procedure Tf_bantu_dam.konek_tampil_nil(kode: string);
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

end.

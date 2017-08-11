unit u_trans_proses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_trans_proses = class(TForm)
    grp1: TGroupBox;
    grp2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    edttahun: TEdit;
    btnkeluar: TBitBtn;
    btnbersih: TBitBtn;
    btnproses: TBitBtn;
    grp3: TGroupBox;
    dbgrd1: TDBGrid;
    img1: TImage;
    procedure btnprosesClick(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnbersihClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    function layak_tdk_layak(status:string):Integer;
    function banding_nilai(kriteria, status, hasil : string):Integer;
  end;

var
  f_trans_proses: Tf_trans_proses;
  jml_layak, jml_tidak_layak, jml_data, jml_klas_layak, jml_klas_tidak_layak : real;
  nil_jml_layak, nil_jml_tidak_layak, nil_klas_layak, nil_klas_tidak_layak : Real;
  a,b,c : Integer;
  hasil_layak_fisik, hasil_tidak_layak_fisik, hasil_keputusan_layak, hasil_keputusan_tidak_layak : Real;
  keputusan, bantu_nil_klas_layak, bantu_nil_klas_tidak_layak : string;

implementation

uses
  u_dm, ADODB;

{$R *.dfm}

function Tf_trans_proses.banding_nilai(kriteria, status, hasil: string): Integer;
begin
 with dm.qrytraining do
  begin
    close;
    SQL.Clear;
    sql.Text:='select * from t_training where kode_kriteria='+QuotedStr(kriteria)+' and keputusan='+QuotedStr(status)+' and hasil='+QuotedStr(hasil)+'';
    Open;

    Result := RecordCount;
  end;
end;

procedure Tf_trans_proses.btnprosesClick(Sender: TObject);
begin
 if edttahun.Text=''then
  begin
   MessageDlg('Tahun Penilaian Harus Diisi',mtWarning,[mbok],0);
   edttahun.SetFocus;
   Exit;
  end;

   //langkah 1
  //cek jumlah layak dan tidak layak di tblk training
  jml_layak := layak_tdk_layak('Layak Fisik');
  jml_tidak_layak := layak_tdk_layak('Tidak Layak Fisik');
  jml_data := jml_layak + jml_tidak_layak;

  nil_jml_layak := jml_layak / jml_data;
  nil_jml_tidak_layak := jml_tidak_layak / jml_data;

  //langkak 2
  //bandingkan data kasus dengan training
  with dm.qryhasil_bayes do
   begin
     close;
     SQL.Clear;
     SQL.Text:='select * from t_hasil where tahun='+QuotedStr(edttahun.Text)+' order by kode_proses asc';
     Open;
     if IsEmpty then
      begin
        MessageDlg('Data Penilaian Pada Tahun '+edttahun.Text+' Tidak Ada',mtInformation,[mbOK],0);
        Exit;
      end;

     for a:=1 to RecordCount do
      begin
       RecNo:=a;

       with dm.qrykriteria do
        begin
          close;
          SQL.Clear;
          SQL.Text:='select * from t_kriteria order by kode_kriteria asc';
          Open;
          for b:=1 to RecordCount do
           begin
             RecNo:=b;

             with dm.qryproses_bayes do
              begin
                close;
                SQL.Clear;
                SQL.Text:='select * from t_proses where kode_proses='+QuotedStr(dm.qryhasil_bayes.fieldbyname('kode_proses').AsString)+' and kode_kriteria='+QuotedStr(dm.qrykriteria.fieldbyname('kode_kriteria').AsString)+'';
                Open;

                //bandingkan dengan data traininng kriteria dengan status layak fisik
                jml_klas_layak := banding_nilai(dm.qryproses_bayes.fieldbyname('kode_kriteria').AsString,'Layak Fisik',fieldbyname('hasil').AsString);
                nil_klas_layak := jml_klas_layak / jml_layak;

                jml_klas_tidak_layak := banding_nilai(dm.qryproses_bayes.fieldbyname('kode_kriteria').AsString,'Tidak Layak Fisik',fieldbyname('hasil').AsString);
                nil_klas_tidak_layak := jml_klas_tidak_layak / jml_tidak_layak;

                //if nil_klas_layak=0 then bantu_nil_klas_layak:='1' else bantu_nil_klas_layak:=FormatFloat('#.#####',nil_klas_layak);
                //if nil_klas_tidak_layak=0 then bantu_nil_klas_tidak_layak:='1' else bantu_nil_klas_tidak_layak:=FormatFloat('#.#####',nil_klas_tidak_layak);

                //simpan hasil ke tmp hitung
                with dm.qrytmp_hitung do
                 begin
                   Append;
                   FieldByName('kd_kriteria').AsString := dm.qryproses_bayes.fieldbyname('kode_kriteria').AsString;
                   FieldByName('nilai_layak').AsString := FormatFloat('0.#####',nil_klas_layak);
                   FieldByName('nilai_tidak_layak').AsString := FormatFloat('0.#####',nil_klas_tidak_layak);
                   Post;
                 end;
              end;
           end;
           b:=b+1;
        end;

        //tahap 3
        //kalihan hasil
        with dm.qrytmp_hitung do
         begin
           close;
           SQL.Clear;
           SQL.Text:='select * from tmp_hitung';
           Open;
           hasil_layak_fisik := 1;
           hasil_tidak_layak_fisik :=1;
           for c:=1 to RecordCount do
            begin
              RecNo := c;

              hasil_layak_fisik := hasil_layak_fisik * fieldbyname('nilai_layak').AsVariant;
              hasil_tidak_layak_fisik := hasil_tidak_layak_fisik * fieldbyname('nilai_tidak_layak').AsVariant;
            end;
            c:=c+1;
         end;

         hasil_keputusan_layak := (hasil_layak_fisik * nil_jml_layak)*1000000;
         hasil_keputusan_tidak_layak := (hasil_tidak_layak_fisik * nil_jml_tidak_layak)*1000000;

         if hasil_keputusan_layak > hasil_keputusan_tidak_layak then keputusan := 'Layak Fisik' else
         if hasil_keputusan_layak < hasil_keputusan_tidak_layak then keputusan := 'Tidak Layak Fisik' else
         if hasil_keputusan_layak = hasil_keputusan_tidak_layak then
          begin
             with dm.qryproses do
              begin
                close;
                SQL.Clear;
                sql.Text:='select * from t_proses where kode_proses='+QuotedStr(dm.qryhasil_bayes.fieldbyname('kode_proses').AsString)+' and hasil='+QuotedStr('Tidak')+'';
                Open;

                if recordcount > 6 then keputusan:='Tidak Layak Fisik';
              end;
          end;
         //simpan ke hasil bayes
         Edit;
         FieldByName('p_layakfisik').AsString := Format('%2.4f',[hasil_layak_fisik]);
         FieldByName('p_tidaklayakfisik').AsString := Format('%2.4f',[hasil_tidak_layak_fisik]);
         FieldByName('nil_layakfisik').AsString := Format('%2.4f',[hasil_keputusan_layak]);
         FieldByName('nil_tidaklayakfisik').AsString := Format('%2.4f',[hasil_keputusan_tidak_layak]);            

        { FieldByName('p_layakfisik').AsVariant := hasil_layak_fisik;
         FieldByName('p_tidaklayakfisik').AsVariant := hasil_tidak_layak_fisik;
         FieldByName('nil_layakfisik').AsVariant := hasil_keputusan_layak;
         FieldByName('nil_tidaklayakfisik').AsVariant := hasil_keputusan_tidak_layak;     }

         FieldByName('keputusan').AsString := keputusan;
         Post;

         //lagi
         if keputusan='Tidak Layak Fisik' then
          begin
            with dm.qrydam do
             begin
              Close;
              SQL.Clear;
              SQL.Text:='update t_dam set ket='+QuotedStr('-')+' where kode_dam='+QuotedStr(dm.qryhasil_bayes.fieldbyname('kode_dam').AsString)+'';
              ExecSQL;

              close;
              SQL.Clear;
              SQL.Text:='select * from t_dam';
              Open;
             end;
          end;
          //

          //hapus tmp hitung;
          with dm.qrytmp_hitung do
           begin
             close;
             SQL.Clear;
             SQL.Text:='delete * from tmp_hitung';
             ExecSQL;

             close;
             SQL.Clear;
             SQL.Text:='select * from tmp_hitung';
             Open;
           end;
      end;
      a:=a+1;
   end;

   with dm.qrytampil_hasil do
    begin
     close;
     SQL.Clear;
     SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket,');
     SQL.Add('a.p_layakfisik, a.p_tidaklayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusan from t_hasil a,');
     SQL.Add('t_dam b where a.kode_dam=b.kode_dam and a.tahun='+QuotedStr(edttahun.Text)+'');
     Open;
    end;

   MessageDlg('Perhitungan Selesai!!!',mtInformation,[mbok],0);
   edttahun.Enabled:=false;
   btnproses.Enabled:=False;
   btnbersih.Enabled:=True;
   btnkeluar.Enabled:=false;
end;

function Tf_trans_proses.layak_tdk_layak(status: string): Integer;
begin
 with dm.qrytraining do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select distinct kode_train from t_training where keputusan='+QuotedStr(status)+'';
    Open;

    Result := RecordCount;
  end;
end;

procedure Tf_trans_proses.btnkeluarClick(Sender: TObject);
begin
 Close;
end;

procedure Tf_trans_proses.FormShow(Sender: TObject);
begin
 edttahun.Text:=FormatDateTime('yyyy',Now);
 edttahun.Enabled:=True;
 btnproses.Enabled:=True;
 btnbersih.Enabled:=false;
 btnkeluar.Enabled:=True;

 with dm.qrytampil_hasil do
  begin
    close;
    SQL.Clear;
    SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket,');
    SQL.Add('a.p_layakfisik, a.p_tidaklayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusan from t_hasil a,');
    SQL.Add('t_dam b where a.kode_dam=b.kode_dam and a.tahun='+QuotedStr('kosong')+'');
    Open;
  end;
end;

procedure Tf_trans_proses.btnbersihClick(Sender: TObject);
begin
 FormShow(Sender);
end;

procedure Tf_trans_proses.edttahunKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then key:=#0;
end;

end.

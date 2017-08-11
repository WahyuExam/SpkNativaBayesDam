unit u_bantu_dam_nilai;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_bantu_dam_nil = class(TForm)
    img1: TImage;
    grp2: TGroupBox;
    Label11: TLabel;
    edt1: TEdit;
    grp1: TGroupBox;
    dbgrd1: TDBGrid;
    grp3: TGroupBox;
    btn1: TBitBtn;
    btnkeluar: TBitBtn;
    procedure btnkeluarClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek_tampil_nil (kode : string);
  end;

var
  f_bantu_dam_nil: Tf_bantu_dam_nil;
  kode_proses : string;

implementation

uses
  u_dm, u_trans_penilaian, u_lap_penilaian;

{$R *.dfm}

procedure Tf_bantu_dam_nil.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_bantu_dam_nil.btn1Click(Sender: TObject);
begin
 if edt1.Text='penilaian' then
  begin
   f_trans_penilaian.edt_namadam.Text:=dbgrd1.Fields[3].AsString;
   f_trans_penilaian.edtkode.Text:=dbgrd1.Fields[2].AsString;

   with dm,qryhasil do
    begin
      close;
      SQL.Clear;
      SQL.Text:='select * from t_hasil';
      Open;
    end;

   if dm.qryhasil.Locate('kode_proses',dbgrd1.Fields[0].AsString,[]) then
    begin
     f_trans_penilaian.edtkode_proses.Text:=dm.qrybantu_damnil.fieldbyname('kode_proses').AsString;
    end;

   kode_proses:=f_trans_penilaian.edtkode_proses.Text;
   konek_tampil_nil(kode_proses);

   with f_trans_penilaian do
    begin
      btnubah.Enabled:=false;
      btnsimpan.Enabled:=True; btnsimpan.Caption:='Selesai';
      //btntambah.Enabled:=True; btntambah.BringToFront; btntambah.Caption:='Batal';
      btnhapus.Enabled:=True;
      btnkeluar.Enabled:=False;
      dbgrd1.Enabled:=True;
    end;
  end
  else
 if edt1.Text='lap_nilai' then
  begin
   f_lap_penilaian.edtkode.Text:=dbgrd1.Fields[2].AsString;
   f_lap_penilaian.edtnamadam.Text:=dbgrd1.Fields[3].AsString;
  end;
 Self.Close;
end;

procedure Tf_bantu_dam_nil.konek_tampil_nil(kode: string);
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

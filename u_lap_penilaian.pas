unit u_lap_penilaian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ComCtrls;

type
  Tf_lap_penilaian = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    Label2: TLabel;
    edtnamadam: TEdit;
    btnbantu: TBitBtn;
    grp3: TGroupBox;
    btnlihat: TBitBtn;
    btnkeluar: TBitBtn;
    Label4: TLabel;
    edttahun: TEdit;
    edtkode: TEdit;
    img1: TImage;
    Label3: TLabel;
    dtp1: TDateTimePicker;
    procedure btnkeluarClick(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure btnlihatClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure btnbantuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_lap_penilaian: Tf_lap_penilaian;
  tgl_sek, tgl_pil : string;

implementation

uses
  u_report_nilai, u_menu, u_bantu_dam, u_dm, DB, u_bantu_dam_nilai;

{$R *.dfm}

procedure Tf_lap_penilaian.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_lap_penilaian.rb1Click(Sender: TObject);
begin
 edtnamadam.Clear;
 btnbantu.Enabled:=False;
end;

procedure Tf_lap_penilaian.FormShow(Sender: TObject);
begin
 edtnamadam.Enabled:=false; edtnamadam.Clear;
 rb1.Checked:=false;
 rb2.Checked:=False;
 btnbantu.Enabled:=false;
 edttahun.Text:=FormatDateTime('yyyy',Now);
 dtp1.Date:=Now;
end;

procedure Tf_lap_penilaian.rb2Click(Sender: TObject);
begin
 edtnamadam.Clear;
 btnbantu.Enabled:=True;
end;

procedure Tf_lap_penilaian.btnlihatClick(Sender: TObject);
begin
 if edttahun.Text='' then
  begin
    MessageDlg('Tahun Penilaian Harus Diisi',mtWarning,[mbok],0);
    edttahun.SetFocus;
    Exit;
  end;
 if (rb1.Checked=false) and (rb2.Checked=false) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih',mtWarning,[mbok],0);
    Exit;
  end;

 tgl_sek := DateToStr(Now);
 tgl_pil := DateToStr(dtp1.Date);

 if tgl_pil > tgl_sek then
  begin
    MessageDlg('Tanggal Cetak Tidak Boleh Melewati Tanggal Hari ini',mtWarning,[mbOK],0);
    dtp1.Date:=Now;
    dtp1.SetFocus;
    Exit;
  end;

 if rb1.Checked=True then
  begin
    with report_penilaian.qrylaporan_nilai do
     begin
       Close;
       SQL.Clear;
       SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket,');
       sql.add('c.kode_kriteria, c.kriteria, d.hasil from t_hasil a, t_dam b, t_kriteria c, t_proses d where a.kode_dam=b.kode_dam');
       SQL.add('and d.kode_kriteria=c.kode_kriteria and d.kode_proses=a.kode_proses');
       sql.Add('and a.tahun='+QuotedStr(edttahun.Text)+' order by a.kode_proses asc, c.kode_kriteria asc');
       Open;
       if IsEmpty then
        begin
          MessageDlg('Data Kosong',mtInformation,[mbOK],0);
          Exit;
        end
        else
        begin
          report_penilaian.qrlblbulan.Caption:=f_menu.bulan(dtp1.Date);
          report_penilaian.Preview;
        end;
     end;
  end
  else
 if rb2.Checked=True then
  begin
    if edtnamadam.Text='' then
     begin
       MessageDlg('Nama Dam Belum Dipilih',mtWarning,[mbok],0);
       btnbantu.SetFocus;
       Exit;
     end
     else
     begin
       with report_penilaian.qrylaporan_nilai do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket,');
         sql.add('c.kode_kriteria, c.kriteria, d.hasil from t_hasil a, t_dam b, t_kriteria c, t_proses d where a.kode_dam=b.kode_dam');
         SQL.add('and d.kode_kriteria=c.kode_kriteria and d.kode_proses=a.kode_proses');
         sql.Add('and a.tahun='+QuotedStr(edttahun.Text)+' and b.kode_dam='+QuotedStr(edtkode.Text)+' order by c.kode_kriteria asc');
         Open;
         if IsEmpty then
          begin
            MessageDlg('Data Kosong',mtInformation,[mbOK],0);
            Exit;
          end
          else
          begin
            report_penilaian.qrlblbulan.Caption:=f_menu.bulan(dtp1.Date);
            report_penilaian.Preview;
          end;
       end;
     end;
  end;
end;

procedure Tf_lap_penilaian.edttahunKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
end;

procedure Tf_lap_penilaian.btnbantuClick(Sender: TObject);
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
      f_bantu_dam_nil.edt1.Text:='lap_nilai';
      f_bantu_dam_nil.ShowModal;
    end;
  end;
end;

end.

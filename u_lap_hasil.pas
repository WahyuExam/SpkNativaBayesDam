unit u_lap_hasil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ComCtrls;

type
  Tf_lap_hasil = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label4: TLabel;
    rb1: TRadioButton;
    rb2: TRadioButton;
    edttahun: TEdit;
    grp3: TGroupBox;
    btnlihat: TBitBtn;
    btnkeluar: TBitBtn;
    rb3: TRadioButton;
    img1: TImage;
    Label3: TLabel;
    dtp1: TDateTimePicker;
    procedure btnkeluarClick(Sender: TObject);
    procedure btnlihatClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek(status:string);
  end;

var
  f_lap_hasil: Tf_lap_hasil;
  tgl_sek, tgl_pil : string;

implementation

uses
  u_dm, u_report_hasil, u_menu;

{$R *.dfm}

procedure Tf_lap_hasil.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_lap_hasil.btnlihatClick(Sender: TObject);
begin
 if edttahun.Text='' then
  begin
    MessageDlg('Tahun Penilaian Harus Diisi',mtWarning,[mbok],0);
    edttahun.SetFocus;
    Exit;
  end;

 if (rb1.Checked=false) and (rb2.Checked=false) and (rb3.Checked=false) then
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
    with dm.qrytampil_hasil do
     begin
       close;
       SQL.Clear;
       SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket, a.p_layakfisik,');
       SQL.Add('a.p_tidaklayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusan from t_hasil a, t_dam b where a.kode_dam=b.kode_dam');
       sql.Add('and a.tahun='+QuotedStr(edttahun.Text)+' and a.keputusan<>'+QuotedStr('')+' order by a.kode_proses asc');
       open;
       if IsEmpty then
        begin
          MessageDlg('Data Kosong',mtInformation,[mbok],0);
          Exit;
        end;
     end;
  end
  else
 if rb2.Checked=True then
  begin
    konek(rb2.Caption);
    if dm.qrytampil_hasil.IsEmpty then
     begin
       MessageDlg('Data Kosong',mtInformation,[mbok],0);
       Exit;
     end;
  end
  else
 if rb3.Checked=True then
  begin
    konek(rb3.Caption);
    if dm.qrytampil_hasil.IsEmpty then
     begin
       MessageDlg('Data Kosong',mtInformation,[mbok],0);
       Exit;
     end;
  end;

  report_hasil.qrlblbulan.Caption:=f_menu.bulan(dtp1.Date);
  report_hasil.Preview;
end;

procedure Tf_lap_hasil.edttahunKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then key:=#0;
end;

procedure Tf_lap_hasil.konek(status: string);
begin
 with dm.qrytampil_hasil do
  begin
    Close;
    sql.Clear;
    SQL.Add('select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_dam, b.telp, b.penanggung_jawab, b.ket, a.p_layakfisik,');
    sql.Add('a.p_tidaklayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusan from t_hasil a, t_dam b where a.kode_dam=b.kode_dam');
    sql.Add('and a.keputusan='+QuotedStr(status)+' and a.tahun='+QuotedStr(edttahun.Text)+' order by a.kode_proses asc');
    Open;
  end;
end;

procedure Tf_lap_hasil.FormShow(Sender: TObject);
begin
 edttahun.Text:=FormatDateTime('yyyy',Now);
 rb1.Checked:=false;
 rb2.Checked:=false;
 rb3.Checked:=false;
end;

end.

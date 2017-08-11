unit u_tgl_cetak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_tgl_cetak = class(TForm)
    img1: TImage;
    grp2: TGroupBox;
    Label11: TLabel;
    grp1: TGroupBox;
    grp3: TGroupBox;
    btn1: TBitBtn;
    btnkeluar: TBitBtn;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    procedure btnkeluarClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_tgl_cetak: Tf_tgl_cetak;
  tgl_sek, tgl_pil : string;

implementation

uses
  u_menu, u_dm, u_report_dam;

{$R *.dfm}

procedure Tf_tgl_cetak.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_tgl_cetak.btn1Click(Sender: TObject);
begin
 tgl_sek := DateToStr(Now);
 tgl_pil := DateToStr(dtp1.Date);

 if tgl_pil > tgl_sek then
  begin
    MessageDlg('Tanggal Cetak Tidak Boleh Melewati Tanggal Hari ini',mtWarning,[mbOK],0);
    dtp1.Date:=Now;
    dtp1.SetFocus;
    Exit;
  end;

 with dm.qrydam do
  begin
    Close;
    SQL.Text:='select * from t_dam where ket <> '+QuotedStr('training')+'';
    Open;
    if IsEmpty then
     begin
       MessageDlg('Data Kosong',mtInformation,[mbok],0);
       Exit;
     end
     else
     begin
      report_dam.qrlblbulan.Caption:=f_menu.bulan(dtp1.Date);
      report_dam.Preview;
     end;
  end;
end;

procedure Tf_tgl_cetak.FormShow(Sender: TObject);
begin
 dtp1.Date:=Now;
end;

end.

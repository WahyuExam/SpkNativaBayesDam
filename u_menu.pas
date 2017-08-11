unit u_menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, jpeg, ExtCtrls;

type
  Tf_menu = class(TForm)
    MainMenu1: TMainMenu;
    MASTER1: TMenuItem;
    DAM1: TMenuItem;
    RANSAKSI1: TMenuItem;
    LAPORAN1: TMenuItem;
    PENGATURAN1: TMenuItem;
    KELUAR1: TMenuItem;
    rainingData1: TMenuItem;
    Penilaian1: TMenuItem;
    HasilNaiveBayes1: TMenuItem;
    Dam2: TMenuItem;
    PenilaianDam1: TMenuItem;
    HasilNaiveBayes2: TMenuItem;
    SalindanPanggilData1: TMenuItem;
    GantiKataSandi1: TMenuItem;
    PenanggungJawab1: TMenuItem;
    img1: TImage;
    KRITERIA1: TMenuItem;
    procedure DAM1Click(Sender: TObject);
    procedure KELUAR1Click(Sender: TObject);
    procedure rainingData1Click(Sender: TObject);
    procedure Penilaian1Click(Sender: TObject);
    procedure HasilNaiveBayes1Click(Sender: TObject);
    procedure Dam2Click(Sender: TObject);
    procedure PenilaianDam1Click(Sender: TObject);
    procedure GantiKataSandi1Click(Sender: TObject);
    procedure PenanggungJawab1Click(Sender: TObject);
    procedure SalindanPanggilData1Click(Sender: TObject);
    procedure HasilNaiveBayes2Click(Sender: TObject);
    procedure KRITERIA1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function bulan (vtgl : TDateTime):string;
  end;

var
  f_menu: Tf_menu;

implementation

uses
  u_mast_dam, u_trans_datatraining, u_trans_penilaian, u_trans_proses, 
  u_report_dam, u_dm, u_lap_penilaian, u_ubahsandi, u_penanggungjawab, 
  u_salindata, u_lap_hasil, u_tgl_cetak, f_kriteria;

{$R *.dfm}

procedure Tf_menu.DAM1Click(Sender: TObject);
begin
 f_mast_dam.ShowModal
end;

procedure Tf_menu.KELUAR1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure Tf_menu.rainingData1Click(Sender: TObject);
begin
 f_trans_datatraining.ShowModal;
end;

procedure Tf_menu.Penilaian1Click(Sender: TObject);
begin
 f_trans_penilaian.ShowModal;
end;

procedure Tf_menu.HasilNaiveBayes1Click(Sender: TObject);
begin
 f_trans_proses.ShowModal;
end;

function Tf_menu.bulan(vtgl: TDateTime): string;
const
   nm_bulan : array [1..12] of string = ('Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember');
var
  a : Integer;
begin
  for a:=1 to 12 do
   begin
     LongMonthNames[a] := nm_bulan[a];
   end;
   Result := FormatDateTime('dd mmmm yyyy',vtgl);
end;

procedure Tf_menu.Dam2Click(Sender: TObject);
begin
 f_tgl_cetak.ShowModal;
end;

procedure Tf_menu.PenilaianDam1Click(Sender: TObject);
begin
 f_lap_penilaian.ShowModal;
end;

procedure Tf_menu.GantiKataSandi1Click(Sender: TObject);
begin
 f_ubahsandi.ShowModal;
end;

procedure Tf_menu.PenanggungJawab1Click(Sender: TObject);
begin
 f_penanggungjawab.ShowModal;
end;

procedure Tf_menu.SalindanPanggilData1Click(Sender: TObject);
begin
 f_salindata.ShowModal;
end;

procedure Tf_menu.HasilNaiveBayes2Click(Sender: TObject);
begin
 f_lap_hasil.ShowModal;
end;

procedure Tf_menu.KRITERIA1Click(Sender: TObject);
begin
 fr_kriteria.ShowModal;
end;

end.

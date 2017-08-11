unit u_dm;

interface

uses
  SysUtils, Classes, DB, XPMan, ADODB;

type
  Tdm = class(TDataModule)
    con1: TADOConnection;
    qrydam: TADOQuery;
    XPManifest1: TXPManifest;
    dsdam: TDataSource;
    qrytraining: TADOQuery;
    qrytampil_training: TADOQuery;
    dstampil_training: TDataSource;
    qrykriteria: TADOQuery;
    qrytampil_proses: TADOQuery;
    qryhasil: TADOQuery;
    dstampil_hasil: TDataSource;
    qryproses: TADOQuery;
    qryhasil_bayes: TADOQuery;
    qryproses_bayes: TADOQuery;
    qrytmp_hitung: TADOQuery;
    tblpenanggung: TADOTable;
    tblpengguna: TADOTable;
    qrytampil_hasil: TADOQuery;
    dstampil_hasil_bayes: TDataSource;
    qrybantu_damnil: TADOQuery;
    dsbantu_damnil: TDataSource;
    dskriteria: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
var ss : string;
begin
 con1.Connected:=false;
 getdir(0,ss);
 con1.ConnectionString:=
 'Provider=Microsoft.Jet.OLEDB.4.0;'+
 'Data Source='+ ss +'\DBDAM.mdb;';
 con1.Connected:=true;

 //aktif semua
 tblpenanggung.Active:=True;
 tblpengguna.Active:=True;

 qrydam.Active:=True;
 qrykriteria.Active:=True;

 qrytraining.Active:=True;
 qrytampil_training.Active:=True;

 qryhasil.Active:=True;
 qrytampil_proses.Active:=True;
 qryproses.Active:=True;

 qryhasil_bayes.Active:=True;
 qryproses_bayes.Active:=True;
 qrytmp_hitung.Active:=True;
 qrytampil_hasil.active:=True;

 qrybantu_damnil.Active:=True;
end;
end.

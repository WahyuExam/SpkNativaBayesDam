unit f_kriteria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls,Lib_ku;

type
  Tfr_kriteria = class(TForm)
    img1: TImage;
    grp2: TGroupBox;
    Label7: TLabel;
    grp1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    mmommkriteria: TMemo;
    edtkode: TEdit;
    grp3: TGroupBox;
    btntambah: TBitBtn;
    btnsimpan: TBitBtn;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    btnkeluar: TBitBtn;
    grp4: TGroupBox;
    Label6: TLabel;
    edtcarinama: TEdit;
    grp5: TGroupBox;
    dbgrd1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure btntambahClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure edtcarinamaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fr_kriteria: Tfr_kriteria;
  status, kriteria : string;

implementation

uses
  u_dm;

{$R *.dfm}

procedure Tfr_kriteria.FormShow(Sender: TObject);
begin
 konek_awal(dm.qrykriteria,'t_kriteria','kode_kriteria');
 edit_kosong([edtkode,edtcarinama]);
 edit_mati([edtkode]); edtcarinama.Enabled:=True;
 mmommkriteria.Clear; mmommkriteria.Enabled:=false;
 dbgrd1.Enabled:=True;

 btn_mati([btnsimpan,btnhapus,btnubah]);
 btn_hidup([btntambah,btnkeluar]);
 btntambah.Caption :='Tambah';
end;

procedure Tfr_kriteria.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tfr_kriteria.btntambahClick(Sender: TObject);
begin
 if btntambah.Caption='Tambah' then
  begin
    edtkode.Text := kode_oto('t_kriteria','kode_kriteria','C',2,dm.qrykriteria);
    mmommkriteria.Enabled:=True; mmommkriteria.SetFocus;
    btn_hidup([btntambah,btnsimpan]);
    btn_mati([btnhapus,btnubah,btnkeluar]);

    edtcarinama.Enabled:=false;
    dbgrd1.Enabled:=false;
    btntambah.Caption:='Batal';
    status := 'simpan';
  end
  else
 if btntambah.Caption='Batal' then FormShow(Sender);
end;

procedure Tfr_kriteria.btnsimpanClick(Sender: TObject);
begin
 if mmommkriteria.Text='' then
  begin
    MessageDlg('Kriteria Belum Diisi',mtWarning,[mbok],0);
    mmommkriteria.SetFocus;
    Exit;
  end;

 with dm.qrykriteria do
  begin
    if status='simpan' then
     begin
       if Locate('kriteria',mmommkriteria.Text,[]) then
        begin
          MessageDlg('Kriteria Sudah Ada',mtWarning,[mbOK],0);
          mmommkriteria.SetFocus;
          Exit;
        end
        else
        begin
          Append;
          FieldByName('kode_kriteria').AsString := edtkode.Text;
        end;
     end
     else
    if status='ubah' then
     begin
       if kriteria = mmommkriteria.Text then
        begin
          FormShow(Sender);
          Exit;
        end
        else
       if kriteria <> mmommkriteria.Text then
        begin
          if Locate('kriteria',mmommkriteria.Text,[]) then
            begin
              MessageDlg('Kriteria Sudah Ada',mtWarning,[mbOK],0);
              mmommkriteria.Text:=kriteria;
              mmommkriteria.SetFocus;
              Exit;
            end
          else
           begin
              if Locate('kode_kriteria',edtkode.Text,[]) then Edit;
           end;
        end;
     end;

     FieldByName('kriteria').AsString := mmommkriteria.Text;
     Post;
     FormShow(Sender);
     MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
  end;
end;

procedure Tfr_kriteria.dbgrd1DblClick(Sender: TObject);
begin
 edtkode.Text := dbgrd1.Fields[0].AsString;
 mmommkriteria.Text := dbgrd1.Fields[1].AsString;
 kriteria := dbgrd1.Fields[1].AsString;

 btn_hidup([btnhapus,btnubah,btntambah]);
 btn_mati([btnsimpan,btnkeluar]);
 btntambah.Caption:='Batal';
end;

procedure Tfr_kriteria.btnubahClick(Sender: TObject);
begin
 btn_hidup([btnsimpan,btntambah]);
 btn_mati([btnubah,btnhapus,btnkeluar]);

 mmommkriteria.Enabled:=True; mmommkriteria.SetFocus;
 dbgrd1.Enabled:=false;
 edtcarinama.Clear; edtcarinama.Enabled:=false;
 status :='ubah';
end;

procedure Tfr_kriteria.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbno],0)=mryes then
  begin
    if dm.qrykriteria.Locate('kode_kriteria',edtkode.Text,[]) then
     begin
       dm.qrykriteria.Delete;
       FormShow(Sender);
       MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
     end;
  end;
end;

procedure Tfr_kriteria.edtcarinamaChange(Sender: TObject);
begin
 if edtcarinama.Text ='' then
  begin
    with dm.qrykriteria do
     begin
       close;
       SQL.Clear;
       SQL.Text := 'select * from t_kriteria order by kode_kriteria asc';
       Open;
     end;
  end
  else
  begin
    with dm.qrykriteria do
     begin
       close;
       SQL.Clear;
       SQL.Text := 'select * from t_kriteria where kriteria like ''%'+edtcarinama.Text+'%'' order by kode_kriteria asc';
       Open;
     end;
  end;
end;

end.

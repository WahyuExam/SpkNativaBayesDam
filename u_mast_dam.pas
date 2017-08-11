unit u_mast_dam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_mast_dam = class(TForm)
    grp2: TGroupBox;
    Label7: TLabel;
    grp1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mmoMm_alamat: TMemo;
    edt_namadam: TEdit;
    edt_kodedam: TEdit;
    Label5: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    edt_tahun: TEdit;
    edt_penanggungjawab: TEdit;
    edt_notelp: TEdit;
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
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btntambahClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure edt_namadamKeyPress(Sender: TObject; var Key: Char);
    procedure edt_notelpKeyPress(Sender: TObject; var Key: Char);
    procedure edt_tahunKeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure edtcarinamaChange(Sender: TObject);
    procedure mmoMm_alamatKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
  end;

var
  f_mast_dam: Tf_mast_dam;
  kode, status,
  nama_dam, alamat_dam, notelp_dam, penanggung_jawan, tahun : string;

implementation

uses
  u_dm, StrUtils, DB;

{$R *.dfm}

procedure Tf_mast_dam.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_mast_dam.FormShow(Sender: TObject);
begin
 edt_kodedam.Enabled:=false; edt_kodedam.Clear;
 edt_namadam.Enabled:=False; edt_namadam.Clear;
 mmoMm_alamat.Enabled:=False; mmoMm_alamat.Clear;
 edt_notelp.Enabled:=false; edt_notelp.Clear;
 edt_penanggungjawab.Enabled:=False; edt_penanggungjawab.Clear;
 //edt_tahun.Enabled:=false; edt_tahun.Clear;

 edtcarinama.Enabled:=True; edtcarinama.Clear;
 dbgrd1.Enabled:=True;

 btntambah.Enabled:=True; btntambah.Caption:='Tambah';
 btnsimpan.Enabled:=false;
 btnubah.Enabled:=False;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=True;
 konek;
end;

procedure Tf_mast_dam.btntambahClick(Sender: TObject);
begin
 if btntambah.Caption='Tambah' then
  begin
    with dm.qrydam do
     begin
       close;
       SQL.Clear;
       SQL.Text:='select * from t_dam order by kode_dam asc';
       Open;
       if IsEmpty then kode:='001' else
        begin
          Last;
          kode := RightStr(fieldbyname('kode_dam').AsString,3);
          kode := IntToStr(StrToInt(kode)+1);
        end;
     end;
     edt_kodedam.Text:='DAM-'+Format('%.3d',[StrToInt(kode)]);

     edt_namadam.Enabled:=True; edt_namadam.SetFocus; edt_namadam.Clear;
     mmoMm_alamat.Enabled:=True; mmoMm_alamat.Clear;
     edt_notelp.Enabled:=True; edt_notelp.Clear;
     edt_penanggungjawab.Enabled:=True; edt_penanggungjawab.Clear;
     //edt_tahun.Enabled:=True; edt_tahun.Clear;

     btntambah.Caption:='Batal';
     btnsimpan.Enabled:=True;
     btnubah.Enabled:=false;
     btnhapus.Enabled:=false;
     btnkeluar.Enabled:=False;
     status:='simpan';

     dbgrd1.Enabled:=false;
     edtcarinama.Enabled:=false; edtcarinama.Clear;
  end
  else
 if btntambah.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_mast_dam.btnsimpanClick(Sender: TObject);
begin
 if (Trim(edt_namadam.Text)='') or (Trim(mmoMm_alamat.Text)='') or (Trim(edt_notelp.Text)='') or (Trim(edt_penanggungjawab.Text)='') {or (Trim(edt_tahun.Text)='')} then
  begin
    MessageDlg('Semua Data Wajib Diisi',mtWarning,[mbok],0);
     if Trim(edt_namadam.Text)='' then edt_namadam.SetFocus else
     if Trim(mmoMm_alamat.Text)='' then mmoMm_alamat.SetFocus else
     if Trim(edt_notelp.Text)='' then edt_notelp.SetFocus else
     if Trim(edt_penanggungjawab.Text)='' then edt_penanggungjawab.SetFocus else
     if Trim(edt_tahun.Text)='' then edt_tahun.SetFocus;
    Exit;
  end;

  with dm.qrydam do
   begin
     if status='simpan' then
      begin
        if Locate('nama_dam;alamat_dam;penanggung_jawab',VarArrayOf([edt_namadam.Text,mmoMm_alamat.Text,edt_penanggungjawab.Text]),[]) then
         begin
           MessageDlg('Data Dam Sudah Ada',mtWarning,[mbOK],0);
           Exit;
         end
         else
         begin
           Append;
           FieldByName('kode_dam').AsString := edt_kodedam.Text;
         end;
      end
      else
     if status='ubah' then
      begin
        if (edt_namadam.Text=nama_dam) and (mmoMm_alamat.Text=alamat_dam) and (edt_notelp.Text=notelp_dam) and (edt_penanggungjawab.Text=penanggung_jawan) {and (edt_tahun.Text=tahun)} then
         begin
           MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
           FormShow(Sender);
           Exit;
         end
         else
        if (edt_namadam.Text<>nama_dam) or (mmoMm_alamat.Text<>alamat_dam) or (edt_penanggungjawab.Text<>penanggung_jawan) then
         begin
           if Locate('nama_dam;alamat_dam;penanggung_jawab',VarArrayOf([edt_namadam.Text,mmoMm_alamat.Text,edt_penanggungjawab.Text]),[]) then
            begin
             MessageDlg('Data Dam Sudah Ada',mtWarning,[mbOK],0);
             Exit;
            end;
         end;

         if Locate('kode_dam',edt_kodedam.Text,[]) then Edit;
      end;

      FieldByName('nama_dam').AsString := edt_namadam.Text;
      FieldByName('alamat_dam').AsString := mmoMm_alamat.Text;
      FieldByName('telp').AsString := edt_notelp.Text;
      FieldByName('penanggung_jawab').AsString := edt_penanggungjawab.Text;
      //FieldByName('tahun').AsString := edt_tahun.Text;
      FieldByName('ket').AsString:='-';
      FieldByName('thn_nil').AsString :='-';
      Post;

      MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
      FormShow(Sender);
   end;
end;

procedure Tf_mast_dam.konek;
begin
 with dm.qrydam do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dam order by kode_dam asc';
    Open;
  end;
end;

procedure Tf_mast_dam.dbgrd1CellClick(Column: TColumn);
begin
 edt_kodedam.Text := dbgrd1.Fields[0].AsString;
 edt_namadam.Text := dbgrd1.Fields[1].AsString;
 mmoMm_alamat.Text:= dbgrd1.Fields[2].AsString;
 edt_notelp.Text  := dbgrd1.Fields[3].AsString;
 edt_penanggungjawab.Text := dbgrd1.Fields[4].AsString;
 //edt_tahun.Text := dbgrd1.Fields[5].AsString;

 nama_dam := edt_namadam.Text;
 alamat_dam := mmoMm_alamat.Text;
 notelp_dam := edt_notelp.Text;
 penanggung_jawan := edt_penanggungjawab.Text;
 //tahun := edt_tahun.Text;
end;

procedure Tf_mast_dam.edt_namadamKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9','a'..'z','A'..'Z',#13,#32,#8,#9,'.',',','-','''']) then Key:=#0;
 if Key=#13 then
  begin
    SelectNext(sender as TWinControl, True,True);
  end;
end;

procedure Tf_mast_dam.edt_notelpKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9,'-']) then Key:=#0;
 if Key=#13 then edt_penanggungjawab.SetFocus;
end;

procedure Tf_mast_dam.edt_tahunKeyPress(Sender: TObject; var Key: Char);
begin
 {if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
 if Key=#13 then btnsimpan.Click;}
end;

procedure Tf_mast_dam.dbgrd1DblClick(Sender: TObject);
begin
 btntambah.Caption:='Tambah';
 btnsimpan.Enabled:=false;
 btnubah.Enabled:=True;
 btnhapus.Enabled:=True;
 btnkeluar.Enabled:=false;
end;

procedure Tf_mast_dam.btnubahClick(Sender: TObject);
begin
 btntambah.Caption:='Batal';
 btnsimpan.Enabled:=True;
 btnubah.Enabled:=false;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=false;
 status := 'ubah';

 edt_namadam.Enabled:=True; edt_namadam.SetFocus;
 mmoMm_alamat.Enabled:=True;
 edt_notelp.Enabled:=True;
 edt_penanggungjawab.Enabled:=True;
 //edt_tahun.Enabled:=True;

 dbgrd1.Enabled:=false;
 edtcarinama.Enabled:=false; edtcarinama.Clear;
end;

procedure Tf_mast_dam.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Yakin Data Akan Dihapus?',mtConfirmation,[mbYes,mbNo],0)=mryes then
  begin
    if dm.qrydam.Locate('kode_dam',edt_kodedam.Text,[]) then
     begin
       dm.qrydam.Delete;
       FormShow(Sender);
       MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
     end;
  end;
end;

procedure Tf_mast_dam.edtcarinamaChange(Sender: TObject);
begin
 if edtcarinama.Text='' then konek else
  begin
    with dm.qrydam do
     begin
       close;
       SQL.Clear;
       sql.Text:='select * from t_dam where nama_dam like ''%'+edtcarinama.Text+'%''';
       Open;
     end;
  end;
end;

procedure Tf_mast_dam.mmoMm_alamatKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9','a'..'z','A'..'Z',#13,#32,#8,#9,'(',')','/','.',',','-','''']) then Key:=#0;
 if Key=#13 then
  begin
    SelectNext(sender as TWinControl, True,True);
  end;
end;

end.

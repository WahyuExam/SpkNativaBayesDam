program app_kelayakan_fisik_dam;

uses
  Forms,
  u_menu in 'u_menu.pas' {f_menu},
  u_mast_dam in 'u_mast_dam.pas' {f_mast_dam},
  u_dm in 'u_dm.pas' {dm: TDataModule},
  u_trans_datatraining in 'u_trans_datatraining.pas' {f_trans_datatraining},
  u_bantu_dam in 'u_bantu_dam.pas' {f_bantu_dam},
  u_trans_penilaian in 'u_trans_penilaian.pas' {f_trans_penilaian},
  u_trans_proses in 'u_trans_proses.pas' {f_trans_proses},
  u_report_dam in 'u_report_dam.pas' {report_dam: TQuickRep},
  u_lap_penilaian in 'u_lap_penilaian.pas' {f_lap_penilaian},
  u_report_nilai in 'u_report_nilai.pas' {report_penilaian: TQuickRep},
  u_ubahsandi in 'u_ubahsandi.pas' {f_ubahsandi},
  u_penanggungjawab in 'u_penanggungjawab.pas' {f_penanggungjawab},
  u_lap_hasil in 'u_lap_hasil.pas' {f_lap_hasil},
  u_salindata in 'u_salindata.pas' {f_salindata},
  u_report_hasil in 'u_report_hasil.pas' {report_hasil: TQuickRep},
  u_login in 'u_login.pas' {f_login},
  u_bantu_dam_nilai in 'u_bantu_dam_nilai.pas' {f_bantu_dam_nil},
  u_tgl_cetak in 'u_tgl_cetak.pas' {f_tgl_cetak},
  f_kriteria in 'f_kriteria.pas' {fr_kriteria};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tf_login, f_login);
  Application.CreateForm(Tf_menu, f_menu);
  Application.CreateForm(Tf_mast_dam, f_mast_dam);
  Application.CreateForm(Tf_trans_datatraining, f_trans_datatraining);
  Application.CreateForm(Tf_bantu_dam, f_bantu_dam);
  Application.CreateForm(Tf_trans_penilaian, f_trans_penilaian);
  Application.CreateForm(Tf_trans_proses, f_trans_proses);
  Application.CreateForm(Treport_dam, report_dam);
  Application.CreateForm(Tf_lap_penilaian, f_lap_penilaian);
  Application.CreateForm(Treport_penilaian, report_penilaian);
  Application.CreateForm(Tf_ubahsandi, f_ubahsandi);
  Application.CreateForm(Tf_penanggungjawab, f_penanggungjawab);
  Application.CreateForm(Tf_lap_hasil, f_lap_hasil);
  Application.CreateForm(Tf_salindata, f_salindata);
  Application.CreateForm(Treport_hasil, report_hasil);
  Application.CreateForm(Tf_bantu_dam_nil, f_bantu_dam_nil);
  Application.CreateForm(Tf_tgl_cetak, f_tgl_cetak);
  Application.CreateForm(Tfr_kriteria, fr_kriteria);
  Application.Run;
end.

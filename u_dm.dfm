object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 454
  Top = 308
  Height = 444
  Width = 667
  object con1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DBDAM.mdb;Persist S' +
      'ecurity Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 16
  end
  object qrydam: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_dam')
    Left = 40
    Top = 88
  end
  object XPManifest1: TXPManifest
    Left = 88
    Top = 8
  end
  object dsdam: TDataSource
    DataSet = qrydam
    Left = 40
    Top = 144
  end
  object qrytraining: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_training')
    Left = 152
    Top = 112
  end
  object qrytampil_training: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kode_train, b.kode_dam, b.nama_dam, b.alamat_dam, b.pen' +
        'anggung_jawab, b.tahun, b.ket, c.kode_kriteria, c.kriteria, a.ha' +
        'sil, a.keputusan, a.nil_angka from t_training a, t_dam b, t_krit' +
        'eria c where a.kode_dam=b.kode_dam and a.kode_kriteria=c.kode_kr' +
        'iteria')
    Left = 208
    Top = 104
  end
  object dstampil_training: TDataSource
    DataSet = qrytampil_training
    Left = 208
    Top = 152
  end
  object qrykriteria: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_kriteria')
    Left = 48
    Top = 208
  end
  object qrytampil_proses: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_' +
        'dam, b.penanggung_jawab,  b.ket, c.kode_kriteria, c.kriteria, d.' +
        'hasil, a.p_layakfisik, a.p_tidaklayakfisik, a.nil_layakfisik, a.' +
        'nil_tidaklayakfisik, a.keputusan from t_hasil a, t_dam b, t_krit' +
        'eria c, t_proses d where a.kode_dam=b.kode_dam and d.kode_proses' +
        '=a.kode_proses and d.kode_kriteria=c.kode_kriteria')
    Left = 416
    Top = 56
  end
  object qryhasil: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_hasil')
    Left = 368
    Top = 40
  end
  object dstampil_hasil: TDataSource
    DataSet = qrytampil_proses
    Left = 424
    Top = 112
  end
  object qryproses: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_proses')
    Left = 464
    Top = 32
  end
  object qryhasil_bayes: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_hasil')
    Left = 344
    Top = 296
  end
  object qryproses_bayes: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from t_proses')
    Left = 416
    Top = 312
  end
  object qrytmp_hitung: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select  * from tmp_hitung')
    Left = 472
    Top = 296
  end
  object tblpenanggung: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 't_penanggung'
    Left = 144
    Top = 16
  end
  object tblpengguna: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 't_masuk'
    Left = 192
    Top = 8
  end
  object qrytampil_hasil: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_' +
        'dam, b.telp, b.penanggung_jawab, b.ket, a.p_layakfisik, a.p_tida' +
        'klayakfisik, a.nil_layakfisik, a.nil_tidaklayakfisik, a.keputusa' +
        'n from t_hasil a, t_dam b where a.kode_dam=b.kode_dam')
    Left = 536
    Top = 280
  end
  object dstampil_hasil_bayes: TDataSource
    DataSet = qrytampil_hasil
    Left = 536
    Top = 336
  end
  object qrybantu_damnil: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kode_proses, a.tahun, b.kode_dam, b.nama_dam, b.alamat_' +
        'dam, b.telp, b.penanggung_jawab, b.ket, a.keputusan from t_hasil' +
        ' a, t_dam b  where a.kode_dam=b.kode_dam')
    Left = 176
    Top = 288
  end
  object dsbantu_damnil: TDataSource
    DataSet = qrybantu_damnil
    Left = 184
    Top = 344
  end
  object dskriteria: TDataSource
    DataSet = qrykriteria
    Left = 88
    Top = 256
  end
end

unit u_report_nilai;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB, jpeg;

type
  Treport_penilaian = class(TQuickRep)
    qrbndDetailBand1: TQRBand;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape10: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    qrbndSummaryBand1: TQRBand;
    qrlbl7: TQRLabel;
    qrlblbulan: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    qrlbl10: TQRLabel;
    qrbndTitleBand1: TQRBand;
    QRImage1: TQRImage;
    qrlbl11: TQRLabel;
    qrlbl12: TQRLabel;
    qrlbl13: TQRLabel;
    QRShape12: TQRShape;
    qrylaporan_nilai: TADOQuery;
    QRGroup1: TQRGroup;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    qrlbl4: TQRLabel;
    qrlbl3: TQRLabel;
    qrlbl2: TQRLabel;
    qrlbl8: TQRLabel;
    qrlbl14: TQRLabel;
    qrlbl15: TQRLabel;
    qrlbl16: TQRLabel;
    qrlbl17: TQRLabel;
    qrlbl18: TQRLabel;
    qrlbl19: TQRLabel;
    qrlbl20: TQRLabel;
    qrlbl21: TQRLabel;
    qrlbl22: TQRLabel;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    qrlbl5: TQRLabel;
    qrbnd1: TQRBand;
    QRShape11: TQRShape;
    qrlbl1: TQRLabel;
  private

  public

  end;

var
  report_penilaian: Treport_penilaian;

implementation

uses
  u_dm;

{$R *.DFM}

end.

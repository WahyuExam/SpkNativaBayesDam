unit u_report_hasil;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, jpeg;

type
  Treport_hasil = class(TQuickRep)
    qrbndColumnHeaderBand1: TQRBand;
    qrlbl1: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    qrlbl3: TQRLabel;
    qrlbl4: TQRLabel;
    qrlbl5: TQRLabel;
    qrlbl6: TQRLabel;
    qrbndDetailBand1: TQRBand;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    qrbndSummaryBand1: TQRBand;
    QRShape11: TQRShape;
    qrlbl7: TQRLabel;
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
    qrlbl8: TQRLabel;
    QRDBText9: TQRDBText;
    qrlblbulan: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel1: TQRLabel;
  private

  public

  end;

var
  report_hasil: Treport_hasil;

implementation

uses
  u_dm;

{$R *.DFM}

end.

unit u_salindata;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_salindata = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    btnsalin: TBitBtn;
    btnpanggil: TBitBtn;
    btnkeluar: TBitBtn;
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure btnsalinClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnpanggilClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_salindata: Tf_salindata;
  a,b,c : string;
  
implementation

uses
  u_dm;

{$R *.dfm}

procedure Tf_salindata.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_salindata.btnsalinClick(Sender: TObject);
begin
 dlgSave1.Execute;
 If dlgSave1.filename <> '' Then b:=dlgSave1.FileName else Exit;

 CopyFile(Pchar(A),Pchar(B+'.mdb'),True);
 MessageDlg('Salin Data Berhasil',mtInformation,[mbOK],0);
end;

procedure Tf_salindata.FormShow(Sender: TObject);
begin
 a:=GetCurrentDir+'\DBDAM.mdb';
end;

procedure Tf_salindata.btnpanggilClick(Sender: TObject);
begin
 dlgOpen1.Execute;
 dlgOpen1.Filter:=A;
 If dlgOpen1.FileName <> '' Then c:=dlgOpen1.FileName else Exit;

 if MessageDlg('Panggil Data "'+ExtractFileName(C)+'"  ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
   dm.con1.Connected:=false;
   RenameFile(C,'DBDAM.mdb');
   dm.con1.ConnectionString:=A;
   dm.con1.Connected:=true;
   dm.DataModuleCreate(sender);
   MessageDlg('Panggil Data Berhasil',mtInformation,[mbOK],0);
  end;
end;

end.

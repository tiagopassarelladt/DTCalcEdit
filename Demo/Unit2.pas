unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DTcalcEdit, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    DTCalcEdit1: TDTCalcEdit;
    DTCalcEdit2: TDTCalcEdit;
    DTCalcEdit3: TDTCalcEdit;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
     DTCalcEdit3.Value := (DTCalcEdit1.Value + DTCalcEdit2.Value);
     Panel1.Caption    := DTCalcEdit3.Extenso;
end;


end.

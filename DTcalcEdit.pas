
unit DTCalcEdit;

interface

uses
	Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms, Dialogs,
	Menus, StdCtrls;

type
	TDTCalcEdit = class(TEdit)
	private
		{ Private declarations }
		FDummyProperty: byte;
		FAlignment: TAlignment;
		FDecimalPlaces: Word;
		FDisplayFormat: String;
		FNegColor: TColor;
		FPosColor: TColor;
		FValue: Currency;
    FHabilitaValorExtenso: Boolean;
    FSimbolomoedaVisivel: Boolean;
    function GetExtenso: string;
    procedure setHabilitaValorExtenso(const Value: Boolean);
    procedure setSimbolomoedaVisivel(const Value: Boolean);
	protected
		{ Protected declarations }
		procedure KeyPress(var Key: char); override;
    procedure CreateParams(var Params: TCreateParams); override;
		procedure SetAlignment(newValue: TAlignment);
		procedure SetDecimalPlaces(newValue: Word);
		procedure SetDisplayFormat(newValue: String);
		procedure SetNegColor(newValue: TColor);
		procedure SetPosColor(newValue: TColor);
		procedure SetValue(newValue: Currency);
    procedure CMEnter(var Message: TCMEnter);  message CM_ENTER;
    procedure CMExit(var Message: TCMExit);    message CM_EXIT;
    procedure FormatText;
    procedure UnFormatText;
    function GetText: String;
    function GetValue: Currency;
    function VrCentena(I_Valor: Integer): string;
	public
		{ Public declarations }
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
	published
		{ Published properties and events }
		property Alignment: TAlignment read FAlignment write SetAlignment default taRightJustify;
		property DecimalPlaces: Word read FDecimalPlaces write SetDecimalPlaces default 2;
		property DisplayFormat: String read FDisplayFormat write SetDisplayFormat;
		property NegColor: TColor read FNegColor write SetNegColor default clRed;
		property PosColor: TColor read FPosColor write SetPosColor default clWindowText;
		property Value: Currency read GetValue write SetValue;
		property CharCase: byte read FDummyProperty;  { Hidden Property }
		property PasswordChar: byte read FDummyProperty;  { Hidden Property }
    property Text: String read GetText;
    property Extenso: string read GetExtenso;
    property HabilitaValorExtenso:Boolean read FHabilitaValorExtenso write setHabilitaValorExtenso;
    property SimboloMoedaVisivel:Boolean read FSimbolomoedaVisivel write setSimbolomoedaVisivel;
	end;  { TDTCalcEdit }

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DT Inovacao', [TDTCalcEdit]);
end;

{ Creates an object of type TDTCalcEdit, and initializes properties. }
constructor TDTCalcEdit.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	Alignment := taRightJustify;
	FDecimalPlaces := 2;
	FNegColor := clRed;
	FPosColor := clWindowText;
  //FDisplayFormat := 'R$ 0.00;(R$ 0.00)';
  FDisplayFormat := '#,##0.00';
  FValue := 0.0;
  FormatText;
end;

procedure TDTCalcEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of Longint = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or Alignments[Alignment];
end;

destructor TDTCalcEdit.Destroy;
begin
	{ CDK: Free allocated memory and created objects here. }
	inherited Destroy;
end;  { Destroy }

{ Sets data member FAlignment to newValue. }
procedure TDTCalcEdit.SetAlignment(newValue: TAlignment);
begin
	if FAlignment <> newValue then
	begin
		FAlignment := newValue;
    RecreateWnd;
	end;
end;  { SetAlignment }

{ Sets data member FDecimalPlaces to newValue. }
procedure TDTCalcEdit.SetDecimalPlaces(newValue: Word);
begin
	if FDecimalPlaces <> newValue then
	begin
		FDecimalPlaces := newValue;
    FormatText;
	end;
end;  { SetDecimalPlaces }

{ Sets data member FDisplayFormat to newValue. }
procedure TDTCalcEdit.SetDisplayFormat(newValue: String);
begin
	if FDisplayFormat <> newValue then
	begin
		FDisplayFormat := newValue;
    FormatText;
	end;
end;  procedure TDTCalcEdit.setHabilitaValorExtenso(const Value: Boolean);
begin
  FHabilitaValorExtenso := Value;
end;

{ SetDisplayFormat }

{ Sets data member FNegColor to newValue. }
procedure TDTCalcEdit.SetNegColor(newValue: TColor);
begin
	if FNegColor <> newValue then
	begin
		FNegColor := newValue;
    FormatText;
	end;
end;  { SetNegColor }

{ Sets data member FPosColor to newValue. }
procedure TDTCalcEdit.SetPosColor(newValue: TColor);
begin
	if FPosColor <> newValue then
	begin
		FPosColor := newValue;
    FormatText;
	end;
end;

procedure TDTCalcEdit.setSimbolomoedaVisivel(const Value: Boolean);
begin
  FSimbolomoedaVisivel := Value;
  if Value then
  begin
       FDisplayFormat := 'R$ ' + FDisplayFormat.Replace('R$ ','');
  end else begin
       FDisplayFormat := FDisplayFormat.Replace('R$ ','');
  end;
end;

{ SetPosColor }

{ Sets data member FValue to newValue. }
procedure TDTCalcEdit.SetValue(newValue: Currency);
begin
	if FValue <> newValue then
	begin
		FValue := newValue;
    FormatText;
	end;
end;  { SetValue }

procedure TDTCalcEdit.CMEnter(var Message: TCMEnter);
begin
  SelectAll;
  inherited;
end;

procedure TDTCalcEdit.CMExit(var Message: TCMExit);
begin
  UnformatText;
  FormatText;
  Inherited;
end;

procedure TDTCalcEdit.FormatText;
begin
  inherited Text := FormatFloat(DisplayFormat, FValue);
  if FValue < 0 then
    Font.Color := NegColor
  else
    Font.Color := PosColor;
end;

procedure TDTCalcEdit.UnFormatText;
var
  TmpText : String;
  Tmp     : Byte;
  IsNeg   : Boolean;
begin
  IsNeg := (Pos('-', Text) > 0) or (Pos('(', Text) > 0);
  TmpText := '';
  for Tmp := 1 to Length(Text) do
    if Text[Tmp] in ['0'..'9', {$IFDEF VER150}SysUtils.DecimalSeparator{$ELSE}FormatSettings.DecimalSeparator{$ENDIF}] then
      TmpText := TmpText + Text[Tmp];
  try
    if TmpText = '' then
    	TmpText := '0.00';
    FValue := StrToFloat(TmpText);
    if IsNeg then
    	FValue := -FValue;
  except
    MessageBeep(mb_IconAsterisk);
  end;
end;

function TDTCalcEdit.VrCentena(I_Valor: Integer): string;
var
  IValor: array[1..3] of Integer;
  Unidade, Dezena, DezVinte, Centena: array[1..9] of string;
  SValor, Retorno: string;
begin
  Result := '';
  if ( I_Valor = 0 ) then Exit;
  if ( I_Valor = 100 ) then
      begin
          Result := 'Cem';
          Exit;
      end;
  SValor := Copy( '000', 1, 3 - Length(IntToStr( I_Valor ) ) ) + IntToStr( I_Valor );
  IValor[01] := StrToInt( Copy( SValor, 1, 1 ) );
  IValor[02] := StrToInt( Copy( SValor, 2, 1 ) );
  IValor[03] := StrToInt( Copy( SValor, 3, 1 ) );
  Unidade[01] := 'Um';
  Unidade[02] := 'Dois';
  Unidade[03] := 'Tr?s';
  Unidade[04] := 'Quatro';
  Unidade[05] := 'Cinco';
  Unidade[06] := 'Seis';
  Unidade[07] := 'Sete';
  Unidade[08] := 'Oito';
  Unidade[09] := 'Nove';
  Dezena[01] := 'Dez';
  Dezena[02] := 'Vinte';
  Dezena[03] := 'Trinta';
  Dezena[04] := 'Quarenta';
  Dezena[05] := 'Cinquenta';
  Dezena[06] := 'Sessenta';
  Dezena[07] := 'Setenta';
  Dezena[08] := 'Oitenta';
  Dezena[09] := 'Noventa';
  DezVinte[01] := 'Onze';
  DezVinte[02] := 'Doze';
  DezVinte[03] := 'Treze';
  DezVinte[04] := 'Quatorze';
  DezVinte[05] := 'Quinze';
  DezVinte[06] := 'Dezeseis';
  DezVinte[07] := 'Dezesete';
  DezVinte[08] := 'Dezoito';
  DezVinte[09] := 'Dezenove';
  Centena[01] := 'Cento';
  Centena[02] := 'Duzentos';
  Centena[03] := 'Trezentos';
  Centena[04] := 'Quatrocentos';
  Centena[05] := 'Quinhentos';
  Centena[06] := 'Seiscentos';
  Centena[07] := 'Setecentos';
  Centena[08] := 'Oitocentos';
  Centena[09] := 'Novecentos';
  Retorno := '';
  if ( IValor[01] > 0 ) then
      begin
          Retorno := Centena[ IValor[01] ];
          if ( IValor[02] + IValor[03] > 0 ) then Retorno :=
              Retorno + ' e ';
      end;
  if ( IValor[02] = 1 ) and ( IValor[03] <> 0 )
      then Retorno := Retorno + DezVinte[ IValor[03] ]
  else
      begin
          if ( IValor[02] > 0 ) then
              begin
                  Retorno := Retorno + Dezena[ IValor[02] ];
                  if( IValor[03] > 0 ) then Retorno := Retorno + ' e ';
              end;
          if ( IValor[03] > 0 ) then Retorno :=
              Retorno + Unidade[ IValor[03] ];
      end;
  Result := Retorno;
end;

function TDTCalcEdit.GetExtenso: string;
var
  Cifra: array[1..4, 1..2] of string;
  S_Valor, Retorno, PosNeg: string;
  IValor: integer;
  FMonetario:boolean;
begin
    if FHabilitaValorExtenso then
    begin
      FMonetario := true;
      S_Valor := Format('%f', [Self.FValue]);
      if ( StrToFloat(S_Valor) < 0 ) then PosNeg := ' - Negativo'
      else PosNeg := '';
      S_Valor := StringReplace(S_Valor, '-', '', [rfReplaceAll]);
      Result := 'Zero';
      if ( StrToFloat( S_Valor ) = 0 ) then Exit;
      if( Length( S_Valor ) > 12 ) then
          begin
              MessageDlg('Valor m?ximo v?lido "999.999.999,99"',
                  mtError, [mbOk], 0);
              Exit;
          end;
      Cifra[01,01] := ' Milh?o';
      Cifra[01,02] := ' Milh?es';
      Cifra[02,01] := ' Mil';
      Cifra[02,02] := ' Mil';
      Cifra[03,01] := ' Real';
      Cifra[03,02] := ' Reais';
      Cifra[04,01] := ' Centavo';
      Cifra[04,02] := ' Centavos';
      Retorno := '';
      S_Valor := Copy('000000000,00', 1, 12 -
          Length( S_Valor )) + S_Valor;
      if ( StrToFloat( Copy(S_Valor, 11, 2) ) > 0 ) then
          begin
              IValor := StrToInt( Copy(S_Valor, 11, 2) );
              Retorno := VrCentena( IValor );
              if ( IValor = 1 ) then Retorno := Retorno + Cifra[04,01]
              else Retorno := Retorno + Cifra[04,02];
          end;
      if ( StrToFloat( Copy(S_Valor, 1, 9) ) <> 0 ) then
          begin
              if ( Length( Retorno ) > 0 )
                  then Retorno := ' e ' + Retorno;
              if ( FMonetario ) then
                  begin
                      if ( StrToFloat( Copy(S_Valor, 1, 9) ) = 1 )
                          then Retorno := Cifra[03,01] + Retorno;
                      if ( StrToFloat( Copy(S_Valor, 1, 9) ) > 1 )
                          then Retorno := Cifra[03,02] + Retorno;
                  end;
          end;
      if ( StrToFloat( Copy(S_Valor, 7, 3) ) > 0 ) then
          begin
              IValor := StrToInt( Copy(S_Valor, 7, 3) );
              Retorno := VrCentena( IValor ) + Retorno;
          end;
      if ( StrToFloat( Copy(S_Valor, 4, 6) ) >= 1000 ) then
          begin
              IValor := StrToInt( Copy(S_Valor, 4, 3) );
              if ( StrToFloat( Copy(S_Valor, 7, 3) ) > 0 )
                  then Retorno := ' e ' + Retorno;
              Retorno := VrCentena( IValor ) + Cifra[02,01] + Retorno;
          end;
      if ( StrToFloat( Copy(S_Valor, 1, 9) ) >= 1000000 ) then
          begin
              IValor := StrToInt( Copy(S_Valor, 1, 3) );
              if ( StrToFloat( Copy(S_Valor, 4, 6) ) > 0 )
                  then Retorno := ' e ' + Retorno;
              if ( IValor = 1 ) then Retorno := Cifra[01,01] + Retorno
              else Retorno := Cifra[01,02] + Retorno;
              Retorno := VrCentena( IValor ) + Retorno;
          end;
      Result := Retorno + PosNeg;
    end;
end;

function TDTCalcEdit.GetText: String;
begin
	Result := inherited Text;
end;

function TDTCalcEdit.GetValue: Currency;
begin
  UnformatText;
  Result := FValue;
end;

procedure TDTCalcEdit.KeyPress(var Key: char);
const
	AllowedKeys = ['0'..'9', ',', '.', '-', #1..#26, chr(VK_UP), chr(VK_DOWN)]; //Numbers, Decimal, Minus, Ctrl-Keys
var
  TextWithKey: string;
  frmParent: TForm;
  i, iBracket: integer;
begin
	if not (Key in AllowedKeys) then
		Key := #0;

  case Key of
    #13 :
    begin
      frmParent := TForm(GetParentForm(Self));
      UnformatText;
      {find default button on the parent form if any}
      for i := 0 to (frmParent.ComponentCount-1) do
        if frmParent.Components[i] is TButton then
          if (frmParent.Components[i] as TButton).Default then
            (frmParent.Components[i] as TButton).Click;
    end;
    '.': key:=',';
    { allow only one dot in the number }
    ',' :
	    if ( Pos(',', Text) > 0 ) then
	    	Key := #0;

    { allow only one '-' in the number and only in the first position: }
    '-' :
	    if ( Pos('-', Text) > 0 ) or ( SelStart > 0 ) then
	    	Key := #0;

	  else {of Case statement}
	    { make sure no other character appears before the '-' }
	    if ( Pos('-', Text) > 0 ) and ( SelStart = 0 ) and (SelLength = 0) then
      	Key := #0;
  end;

  if Key <> Char(VK_BACK) then
    begin
      {TextWithKey is a model of Text if we accept the keystroke.  Use SelStart and
      SelLength to find the cursor (insert) position.}
      TextWithKey := Copy(Text, 1, SelStart) + Key + Copy(Text, SelStart + SelLength + 1, Length(Text));
      {iBracket is used to compensate for the ')' character in the "too many decimal places" below}
      if Pos(')', TextWithKey) > 0 then
      	iBracket := 1
      else
      	iBracket := 0;

      if ((Pos({$IFDEF VER150}SysUtils.DecimalSeparator{$ELSE}FormatSettings.DecimalSeparator{$ENDIF}, TextWithKey) > 0) and
         ((Length(TextWithKey) - Pos({$IFDEF VER150}SysUtils.DecimalSeparator{$ELSE}FormatSettings.DecimalSeparator{$ENDIF}, TextWithKey)) > (FDecimalPlaces + iBracket))) or {too many decimal places}
         ((Key = '-') and (Pos('-', Text) <> 0)) or                  {only one minus...}
         (Pos('-', TextWithKey) > 1) then                            {... and only at beginning}
      	Key := #0;
    end;

	inherited KeyPress(Key);
end;  { KeyPress }

end.



{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TWordHelper;

{$DEFINE TEST_UNIT}
{$IFDEF FPC}{$I fpc.inc}{$ELSE}{$I delphi.inc}{$ENDIF}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework,
  {$ENDIF}
  Classes, SysUtils;

type
  TestTWordHelper = class(TTestCase)
  private
    FBadValue: string;
    procedure BadParse;
  published
    procedure TestMinValue;
    procedure TestMaxValue;
    procedure TestSize;
    procedure TestToString1;
    procedure TestToString2;
    procedure TestToHexString1;
    procedure TestToHexString2;
    procedure TestToBoolean;
    {$IF DECLARED(Single)}
    procedure TestToSingle;
    {$IFEND}
    {$IF DECLARED(Double)}
    procedure TestToDouble;
    {$IFEND}
    {$IF DECLARED(Extended)}
    procedure TestToExtended;
    {$IFEND}
    procedure TestParse;
    procedure TestTryParse;
  end;

implementation

{ TestTWordHelper }

procedure TestTWordHelper.TestMinValue;
begin
  CheckEquals(0, Word.MinValue);
end;

procedure TestTWordHelper.TestMaxValue;
begin
  CheckEquals(65535, Word.MaxValue);
end;

procedure TestTWordHelper.TestSize;
begin
  CheckEquals(SizeOf(Word), Word.Size);
end;

procedure TestTWordHelper.TestToString1;
var
  Value: Word;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 500;
  CheckEquals('500', Value.ToString);

  Value := 65535;
  CheckEquals('65535', Value.ToString);
end;

procedure TestTWordHelper.TestToString2;
begin
  CheckEquals('0', Word.ToString(0));

  CheckEquals('500', Word.ToString(500));

  CheckEquals('65535', Word.ToString(65535));
end;

procedure TestTWordHelper.TestToHexString1;
var
  Value: Word;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('0000', Value.ToHexString);

  Value := 15;
  CheckEquals('000F', UpperCase(Value.ToHexString));

  Value := 255;
  CheckEquals('00FF', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('0FFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 65535;
  CheckEquals('FFFF', UpperCase(Value.ToHexString));
end;

procedure TestTWordHelper.TestToHexString2;
var
  Value: Word;
begin
  Value := 0;
  CheckEquals('0', Value.ToHexString(0));
  CheckEquals('0', Value.ToHexString(1));
  CheckEquals('00', Value.ToHexString(2));
  CheckEquals('000', Value.ToHexString(3));
  CheckEquals('0000', Value.ToHexString(4));
  CheckEquals('00000', Value.ToHexString(5));

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString(0)));
  CheckEquals('F', UpperCase(Value.ToHexString(1)));
  CheckEquals('0F', UpperCase(Value.ToHexString(2)));
  CheckEquals('00F', UpperCase(Value.ToHexString(3)));
  CheckEquals('000F', UpperCase(Value.ToHexString(4)));
  CheckEquals('0000F', UpperCase(Value.ToHexString(5)));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FF', UpperCase(Value.ToHexString(2)));
  CheckEquals('0FF', UpperCase(Value.ToHexString(3)));
  CheckEquals('00FF', UpperCase(Value.ToHexString(4)));
  CheckEquals('000FF', UpperCase(Value.ToHexString(5)));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('0FFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('00FFF', UpperCase(Value.ToHexString(5)));

  Value := 65535;
  CheckEquals('FFFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('0FFFF', UpperCase(Value.ToHexString(5)));
end;

procedure TestTWordHelper.TestToBoolean;
var
  Value: Word;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 500;
  CheckTrue(Value.ToBoolean);

  Value := 65535;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTWordHelper.TestToSingle;
var
  Value: Word;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToSingle, Single.Epsilon);

  Value := 65535;
  CheckEquals(65535.0, Value.ToSingle, Single.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTWordHelper.TestToDouble;
var
  Value: Word;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToDouble, Double.Epsilon);

  Value := 65535;
  CheckEquals(65535.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTWordHelper.TestToExtended;
var
  Value: Word;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToExtended, Extended.Epsilon);

  Value := 65535;
  CheckEquals(65535.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTWordHelper.BadParse;
begin
  Word.Parse(FBadValue);
end;

procedure TestTWordHelper.TestParse;
begin
  CheckEquals(0, Word.Parse('0'));
  CheckEquals(0, Word.Parse('000'));
  CheckEquals(0, Word.Parse('+000'));
  CheckEquals(0, Word.Parse('-000'));

  CheckEquals(500, Word.Parse('500'));
  CheckEquals(500, Word.Parse('0500'));
  CheckEquals(500, Word.Parse('+500'));
  CheckEquals(500, Word.Parse('+0500'));

  CheckEquals(65535, Word.Parse('65535'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-1';
  CheckException(BadParse, EConvertError);

  FBadValue := '65536';
  CheckException(BadParse, EConvertError);
  {$IFEND}

  FBadValue := '';
  CheckException(BadParse, EConvertError);

  FBadValue := '+';
  CheckException(BadParse, EConvertError);

  FBadValue := '-';
  CheckException(BadParse, EConvertError);

  FBadValue := 'INF';
  CheckException(BadParse, EConvertError);

  FBadValue := '+INF';
  CheckException(BadParse, EConvertError);

  FBadValue := '-INF';
  CheckException(BadParse, EConvertError);

  FBadValue := 'NAN';
  CheckException(BadParse, EConvertError);

  FBadValue := '**INVALID**';
  CheckException(BadParse, EConvertError);

  FBadValue := '1' + FormatSettings.DecimalSeparator + '0';
  CheckException(BadParse, EConvertError);
end;

procedure TestTWordHelper.TestTryParse;
var
  CheckValue: Word;
begin
  CheckTrue(Word.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Word.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Word.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Word.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(Word.TryParse('500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(Word.TryParse('0500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(Word.TryParse('+500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(Word.TryParse('+0500', CheckValue));
  CheckEquals(500, CheckValue);

  CheckTrue(Word.TryParse('65535', CheckValue));
  CheckEquals(65535, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(Word.TryParse('-1', CheckValue));
  CheckFalse(Word.TryParse('65536', CheckValue));
  {$IFEND}
  CheckFalse(Word.TryParse('', CheckValue));
  CheckFalse(Word.TryParse('+', CheckValue));
  CheckFalse(Word.TryParse('-', CheckValue));
  CheckFalse(Word.TryParse('INF', CheckValue));
  CheckFalse(Word.TryParse('+INF', CheckValue));
  CheckFalse(Word.TryParse('-INF', CheckValue));
  CheckFalse(Word.TryParse('NAN', CheckValue));
  CheckFalse(Word.TryParse('**INVALID**', CheckValue));
  CheckFalse(Word.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTWordHelper.Suite);

end.

{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TInt64Helper;

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
  TestTInt64Helper = class(TTestCase)
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

{ TestTInt64Helper }

procedure TestTInt64Helper.TestMinValue;
begin
  CheckEquals(Int64(-9223372036854775808), Int64.MinValue);
end;

procedure TestTInt64Helper.TestMaxValue;
begin
  CheckEquals(Int64(9223372036854775807), Int64.MaxValue);
end;

procedure TestTInt64Helper.TestSize;
begin
  CheckEquals(SizeOf(Int64), Int64.Size);
end;

procedure TestTInt64Helper.TestToString1;
var
  Value: Int64;
begin
  Value := Int64(0);
  CheckEquals('0', Value.ToString);

  Value := Int64(5000000000);
  CheckEquals('5000000000', Value.ToString);

  Value := Int64(9223372036854775807);
  CheckEquals('9223372036854775807', Value.ToString);

  Value := Int64(-5000000000);
  CheckEquals('-5000000000', Value.ToString);

  Value := Int64(-9223372036854775808);
  CheckEquals('-9223372036854775808', Value.ToString);
end;

procedure TestTInt64Helper.TestToString2;
begin
  CheckEquals('0', Int64.ToString(Int64(0)));

  CheckEquals('5000000000', Int64.ToString(Int64(5000000000)));

  CheckEquals('9223372036854775807', Int64.ToString(Int64(9223372036854775807)));

  CheckEquals('-5000000000', Int64.ToString(Int64(-5000000000)));

  CheckEquals('-9223372036854775808', Int64.ToString(Int64(-9223372036854775808)));
end;

procedure TestTInt64Helper.TestToHexString1;
var
  Value: Int64;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := Int64(0);
  CheckEquals('0000000000000000', Value.ToHexString);

  Value := Int64(1099511627775);
  CheckEquals('000000FFFFFFFFFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := Int64(0);
  CheckEquals('0', Value.ToHexString);

  Value := Int64(1099511627775);
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := Int64(9223372036854775807);
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString));

  Value := Int64(-1099511627775);
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString));

  Value := Int64(-9223372036854775808);
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString));
end;

procedure TestTInt64Helper.TestToHexString2;
var
  Value: Int64;
begin
  Value := 0;
  CheckEquals('0', UpperCase(Value.ToHexString(00)));
  CheckEquals('0', UpperCase(Value.ToHexString(01)));
  CheckEquals('00', UpperCase(Value.ToHexString(02)));
  CheckEquals('000', UpperCase(Value.ToHexString(03)));
  CheckEquals('0000', UpperCase(Value.ToHexString(04)));
  CheckEquals('00000', UpperCase(Value.ToHexString(05)));
  CheckEquals('000000', UpperCase(Value.ToHexString(06)));
  CheckEquals('0000000', UpperCase(Value.ToHexString(07)));
  CheckEquals('00000000', UpperCase(Value.ToHexString(08)));
  CheckEquals('000000000', UpperCase(Value.ToHexString(09)));
  CheckEquals('0000000000', UpperCase(Value.ToHexString(10)));
  CheckEquals('00000000000', UpperCase(Value.ToHexString(11)));
  CheckEquals('000000000000', UpperCase(Value.ToHexString(12)));
  CheckEquals('0000000000000', UpperCase(Value.ToHexString(13)));
  CheckEquals('00000000000000', UpperCase(Value.ToHexString(14)));
  CheckEquals('000000000000000', UpperCase(Value.ToHexString(15)));
  CheckEquals('0000000000000000', UpperCase(Value.ToHexString(16)));
  CheckEquals('00000000000000000', UpperCase(Value.ToHexString(17)));

  Value := Int64(1099511627775);
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(00)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(01)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(02)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(03)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(04)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(05)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(06)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(07)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(08)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(09)));
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString(10)));
  CheckEquals('0FFFFFFFFFF', UpperCase(Value.ToHexString(11)));
  CheckEquals('00FFFFFFFFFF', UpperCase(Value.ToHexString(12)));
  CheckEquals('000FFFFFFFFFF', UpperCase(Value.ToHexString(13)));
  CheckEquals('0000FFFFFFFFFF', UpperCase(Value.ToHexString(14)));
  CheckEquals('00000FFFFFFFFFF', UpperCase(Value.ToHexString(15)));
  CheckEquals('000000FFFFFFFFFF', UpperCase(Value.ToHexString(16)));
  CheckEquals('0000000FFFFFFFFFF', UpperCase(Value.ToHexString(17)));

  Value := Int64(9223372036854775807);
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(00)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(01)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(02)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(03)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(04)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(05)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(06)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(07)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(08)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(09)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(10)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(11)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(12)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(13)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(14)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(15)));
  CheckEquals('7FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(16)));
  CheckEquals('07FFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(17)));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := Int64(-1099511627775);
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(00)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(01)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(02)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(03)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(04)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(05)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(06)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(07)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(08)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(09)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(10)));
  CheckEquals('F0000000001', UpperCase(Value.ToHexString(11)));
  CheckEquals('FF0000000001', UpperCase(Value.ToHexString(12)));
  CheckEquals('FFF0000000001', UpperCase(Value.ToHexString(13)));
  CheckEquals('FFFF0000000001', UpperCase(Value.ToHexString(14)));
  CheckEquals('FFFFF0000000001', UpperCase(Value.ToHexString(15)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(16)));
  CheckEquals('FFFFFFF0000000001', UpperCase(Value.ToHexString(17)));

  Value := Int64(-9223372036854775808);
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(00)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(01)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(02)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(03)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(04)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(05)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(06)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(07)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(08)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(09)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(10)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(11)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(12)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(13)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(14)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(15)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(16)));
  CheckEquals('F8000000000000000', UpperCase(Value.ToHexString(17)));
  {$ELSE}
  { Obsolete }
  Value := Int64(-1099511627775);
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(00)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(01)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(02)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(03)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(04)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(05)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(06)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(07)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(08)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(09)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(10)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(11)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(12)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(13)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(14)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(15)));
  CheckEquals('FFFFFF0000000001', UpperCase(Value.ToHexString(16)));
  CheckEquals('0FFFFFF0000000001', UpperCase(Value.ToHexString(17)));

  Value := Int64(-9223372036854775808);
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(00)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(01)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(02)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(03)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(04)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(05)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(06)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(07)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(08)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(09)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(10)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(11)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(12)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(13)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(14)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(15)));
  CheckEquals('8000000000000000', UpperCase(Value.ToHexString(16)));
  CheckEquals('08000000000000000', UpperCase(Value.ToHexString(17)));
  {$IFEND}
end;

procedure TestTInt64Helper.TestToBoolean;
var
  Value: Int64;
begin
  Value := Int64(0);
  CheckFalse(Value.ToBoolean);

  Value := Int64(5000000000);
  CheckTrue(Value.ToBoolean);

  Value := Int64(9223372036854775807);
  CheckTrue(Value.ToBoolean);

  Value := Int64(-5000000000);
  CheckTrue(Value.ToBoolean);

  Value := Int64(-9223372036854775808);
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTInt64Helper.TestToSingle;
var
  Value: Int64;
begin
  Value := Int64(0);
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := Int64(5000000000);
  CheckEquals(5000000000.0, Value.ToSingle, 1); { Single is unable to fit this number }

  Value := Int64(9223372036854775807);
  CheckEquals(9223372036854775807.0, Value.ToSingle, 2E18); { Single is unable to fit this number }

  Value := Int64(-5000000000);
  CheckEquals(-5000000000.0, Value.ToSingle, 1); { Single is unable to fit this number }

  Value := Int64(-9223372036854775808);
  CheckEquals(-9223372036854775808.0, Value.ToSingle, 2E18); { Single is unable to fit this number }
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTInt64Helper.TestToDouble;
var
  Value: Int64;
begin
  Value := Int64(0);
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := Int64(5000000000);
  CheckEquals(5000000000.0, Value.ToDouble, Double.Epsilon);

  Value := Int64(9223372036854775807);
  CheckEquals(9223372036854775807.0, Value.ToDouble, 2E18); { Double is unable to fit this number }

  Value := Int64(-5000000000);
  CheckEquals(-5000000000.0, Value.ToDouble, Double.Epsilon);

  Value := Int64(-9223372036854775808);
  CheckEquals(-9223372036854775808.0, Value.ToDouble, 2E18); { Double is unable to fit this number }
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTInt64Helper.TestToExtended;
var
  Value: Int64;
begin
  Value := Int64(0);
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := Int64(5000000000);
  CheckEquals(5000000000.0, Value.ToExtended, Extended.Epsilon);

  Value := Int64(9223372036854775807);
  CheckEquals(9223372036854775807.0, Value.ToExtended, 2E18); { Double (64bit) is unable to fit this number }

  Value := Int64(-5000000000);
  CheckEquals(-5000000000.0, Value.ToExtended, Extended.Epsilon);

  Value := Int64(-9223372036854775808);
  CheckEquals(-9223372036854775808.0, Value.ToExtended, 2E18); { Double (64bit) is unable to fit this number }
end;
{$IFEND}

procedure TestTInt64Helper.BadParse;
begin
  Int64.Parse(FBadValue);
end;

procedure TestTInt64Helper.TestParse;
begin
  CheckEquals(Int64(0), Int64.Parse('0'));
  CheckEquals(Int64(0), Int64.Parse('000'));
  CheckEquals(Int64(0), Int64.Parse('+000'));
  CheckEquals(Int64(0), Int64.Parse('-000'));

  CheckEquals(Int64(5000000000), Int64.Parse('5000000000'));
  CheckEquals(Int64(5000000000), Int64.Parse('05000000000'));
  CheckEquals(Int64(5000000000), Int64.Parse('+5000000000'));
  CheckEquals(Int64(5000000000), Int64.Parse('+05000000000'));

  CheckEquals(Int64(9223372036854775807), Int64.Parse('9223372036854775807'));

  CheckEquals(Int64(-5000000000), Int64.Parse('-5000000000'));
  CheckEquals(Int64(-5000000000), Int64.Parse('-05000000000'));

  CheckEquals(Int64(-9223372036854775808), Int64.Parse('-9223372036854775808'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-9223372036854775809';
  CheckException(BadParse, EConvertError);

  FBadValue := '9223372036854775808';
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

procedure TestTInt64Helper.TestTryParse;
var
  CheckValue: Int64;
begin
  CheckTrue(Int64.TryParse('0', CheckValue));
  CheckEquals(Int64(0), CheckValue);
  CheckTrue(Int64.TryParse('000', CheckValue));
  CheckEquals(Int64(0), CheckValue);
  CheckTrue(Int64.TryParse('+000', CheckValue));
  CheckEquals(Int64(0), CheckValue);
  CheckTrue(Int64.TryParse('-000', CheckValue));
  CheckEquals(Int64(0), CheckValue);

  CheckTrue(Int64.TryParse('5000000000', CheckValue));
  CheckEquals(Int64(5000000000), CheckValue);
  CheckTrue(Int64.TryParse('05000000000', CheckValue));
  CheckEquals(Int64(5000000000), CheckValue);
  CheckTrue(Int64.TryParse('+5000000000', CheckValue));
  CheckEquals(Int64(5000000000), CheckValue);
  CheckTrue(Int64.TryParse('+05000000000', CheckValue));
  CheckEquals(Int64(5000000000), CheckValue);

  CheckTrue(Int64.TryParse('9223372036854775807', CheckValue));
  CheckEquals(Int64(9223372036854775807), CheckValue);

  CheckTrue(Int64.TryParse('-5000000000', CheckValue));
  CheckEquals(Int64(-5000000000), CheckValue);
  CheckTrue(Int64.TryParse('-05000000000', CheckValue));
  CheckEquals(Int64(-5000000000), CheckValue);

  CheckTrue(Int64.TryParse('-9223372036854775808', CheckValue));
  CheckEquals(Int64(-9223372036854775808), CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(Int64.TryParse('-9223372036854775809', CheckValue));
  CheckFalse(Int64.TryParse('9223372036854775808', CheckValue));
  {$IFEND}
  CheckFalse(Int64.TryParse('', CheckValue));
  CheckFalse(Int64.TryParse('+', CheckValue));
  CheckFalse(Int64.TryParse('-', CheckValue));
  CheckFalse(Int64.TryParse('INF', CheckValue));
  CheckFalse(Int64.TryParse('+INF', CheckValue));
  CheckFalse(Int64.TryParse('-INF', CheckValue));
  CheckFalse(Int64.TryParse('NAN', CheckValue));
  CheckFalse(Int64.TryParse('**INVALID**', CheckValue));
  CheckFalse(Int64.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTInt64Helper.Suite);

end.


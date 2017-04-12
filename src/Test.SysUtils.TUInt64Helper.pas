{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TUInt64Helper;

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
  TestTUInt64Helper = class(TTestCase)
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

{ TestTUInt64Helper }

procedure TestTUInt64Helper.TestMinValue;
begin
  CheckEquals(UInt64(0), UInt64.MinValue);
end;

procedure TestTUInt64Helper.TestMaxValue;
begin
  CheckEquals(UInt64(18446744073709551615), UInt64.MaxValue);
end;

procedure TestTUInt64Helper.TestSize;
begin
  CheckEquals(SizeOf(UInt64), UInt64.Size);
end;

procedure TestTUInt64Helper.TestToString1;
var
  Value: UInt64;
begin
  Value := UInt64(0);
  CheckEquals('0', Value.ToString);

  Value := UInt64(5000000000);
  CheckEquals('5000000000', Value.ToString);

  Value := UInt64(18446744073709551615);
  CheckEquals('18446744073709551615', Value.ToString);
end;

procedure TestTUInt64Helper.TestToString2;
begin
  CheckEquals('0', UInt64.ToString(UInt64(0)));

  CheckEquals('5000000000', UInt64.ToString(UInt64(5000000000)));

  CheckEquals('18446744073709551615', UInt64.ToString(UInt64(18446744073709551615)));
end;

procedure TestTUInt64Helper.TestToHexString1;
var
  Value: UInt64;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := UInt64(0);
  CheckEquals('0000000000000000', Value.ToHexString);

  Value := UInt64(1099511627775);
  CheckEquals('000000FFFFFFFFFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := UInt64(0);
  CheckEquals('0', Value.ToHexString);

  Value := UInt64(1099511627775);
  CheckEquals('FFFFFFFFFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := UInt64(18446744073709551615);
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString));
end;

procedure TestTUInt64Helper.TestToHexString2;
var
  Value: UInt64;
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

  Value := UInt64(1099511627775);
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

  Value := UInt64(18446744073709551615);
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(00)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(01)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(02)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(03)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(04)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(05)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(06)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(07)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(08)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(09)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(10)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(11)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(12)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(13)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(14)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(15)));
  CheckEquals('FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(16)));
  CheckEquals('0FFFFFFFFFFFFFFFF', UpperCase(Value.ToHexString(17)));
end;

procedure TestTUInt64Helper.TestToBoolean;
var
  Value: UInt64;
begin
  Value := UInt64(0);
  CheckFalse(Value.ToBoolean);

  Value := UInt64(5000000000);
  CheckTrue(Value.ToBoolean);

  Value := UInt64(18446744073709551615);
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTUInt64Helper.TestToSingle;
var
  Value: UInt64;
begin
  Value := UInt64(0);
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := UInt64(5000000000);
  CheckEquals(5000000000.0, Value.ToSingle, 1); { Single is unable to fit this number }

  Value := UInt64(18446744073709551615);
  CheckEquals(18446744073709551615.0, Value.ToSingle, 2E19); { Single is unable to fit this number }
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTUInt64Helper.TestToDouble;
var
  Value: UInt64;
begin
  Value := UInt64(0);
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := UInt64(5000000000);
  CheckEquals(5000000000.0, Value.ToDouble, Double.Epsilon);

  Value := UInt64(18446744073709551615);
  CheckEquals(18446744073709551615.0, Value.ToDouble, 2E19); { Double is unable to fit this number }
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTUInt64Helper.TestToExtended;
var
  Value: UInt64;
begin
  Value := UInt64(0);
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := UInt64(5000000000);
  CheckEquals(5000000000.0, Value.ToExtended, Extended.Epsilon);

  Value := UInt64(18446744073709551615);
  CheckEquals(18446744073709551615.0, Value.ToExtended, 2E19); { Double (64bit) is unable to fit this number }
end;
{$IFEND}

procedure TestTUInt64Helper.BadParse;
begin
  UInt64.Parse(FBadValue);
end;

procedure TestTUInt64Helper.TestParse;
begin
  CheckEquals(UInt64(0), UInt64.Parse('0'));
  CheckEquals(UInt64(0), UInt64.Parse('000'));
  CheckEquals(UInt64(0), UInt64.Parse('+000'));
  CheckEquals(UInt64(0), UInt64.Parse('-000'));

  CheckEquals(UInt64(5000000000), UInt64.Parse('5000000000'));
  CheckEquals(UInt64(5000000000), UInt64.Parse('05000000000'));
  CheckEquals(UInt64(5000000000), UInt64.Parse('+5000000000'));
  CheckEquals(UInt64(5000000000), UInt64.Parse('+05000000000'));

  CheckEquals(UInt64(18446744073709551615), UInt64.Parse('18446744073709551615'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-1';
  CheckException(BadParse, EConvertError);

  FBadValue := '18446744073709551616';
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

procedure TestTUInt64Helper.TestTryParse;
var
  CheckValue: UInt64;
begin
  CheckTrue(UInt64.TryParse('0', CheckValue));
  CheckEquals(UInt64(0), CheckValue);
  CheckTrue(UInt64.TryParse('000', CheckValue));
  CheckEquals(UInt64(0), CheckValue);
  CheckTrue(UInt64.TryParse('+000', CheckValue));
  CheckEquals(UInt64(0), CheckValue);
  CheckTrue(UInt64.TryParse('-000', CheckValue));
  CheckEquals(UInt64(0), CheckValue);

  CheckTrue(UInt64.TryParse('5000000000', CheckValue));
  CheckEquals(UInt64(5000000000), CheckValue);
  CheckTrue(UInt64.TryParse('05000000000', CheckValue));
  CheckEquals(UInt64(5000000000), CheckValue);
  CheckTrue(UInt64.TryParse('+5000000000', CheckValue));
  CheckEquals(UInt64(5000000000), CheckValue);
  CheckTrue(UInt64.TryParse('+05000000000', CheckValue));
  CheckEquals(UInt64(5000000000), CheckValue);

  CheckTrue(UInt64.TryParse('18446744073709551615', CheckValue));
  CheckEquals(UInt64(18446744073709551615), CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(UInt64.TryParse('-1', CheckValue));
  CheckFalse(UInt64.TryParse('18446744073709551616', CheckValue));
  {$IFEND}
  CheckFalse(UInt64.TryParse('', CheckValue));
  CheckFalse(UInt64.TryParse('+', CheckValue));
  CheckFalse(UInt64.TryParse('-', CheckValue));
  CheckFalse(UInt64.TryParse('INF', CheckValue));
  CheckFalse(UInt64.TryParse('+INF', CheckValue));
  CheckFalse(UInt64.TryParse('-INF', CheckValue));
  CheckFalse(UInt64.TryParse('NAN', CheckValue));
  CheckFalse(UInt64.TryParse('**INVALID**', CheckValue));
  CheckFalse(UInt64.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTUInt64Helper.Suite);

end.

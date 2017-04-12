{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TShortIntHelper;

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
  TestTShortIntHelper = class(TTestCase)
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

{ TestTShortIntHelper }

procedure TestTShortIntHelper.TestMinValue;
begin
  CheckEquals(-128, ShortInt.MinValue);
end;

procedure TestTShortIntHelper.TestMaxValue;
begin
  CheckEquals(127, ShortInt.MaxValue);
end;

procedure TestTShortIntHelper.TestSize;
begin
  CheckEquals(SizeOf(ShortInt), ShortInt.Size);
end;

procedure TestTShortIntHelper.TestToString1;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 100;
  CheckEquals('100', Value.ToString);

  Value := 127;
  CheckEquals('127', Value.ToString);

  Value := -100;
  CheckEquals('-100', Value.ToString);

  Value := -128;
  CheckEquals('-128', Value.ToString);
end;

procedure TestTShortIntHelper.TestToString2;
begin
  CheckEquals('0', ShortInt.ToString(0));

  CheckEquals('100', ShortInt.ToString(100));

  CheckEquals('127', ShortInt.ToString(127));

  CheckEquals('-100', ShortInt.ToString(-100));

  CheckEquals('-128', ShortInt.ToString(-128));
end;

procedure TestTShortIntHelper.TestToHexString1;
var
  Value: ShortInt;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('00', Value.ToHexString);

  Value := 15;
  CheckEquals('0F', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 127;
  CheckEquals('7F', UpperCase(Value.ToHexString));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := -15;
  CheckEquals('F1', UpperCase(Value.ToHexString));

  Value := -128;
  CheckEquals('80', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString));

  Value := -128;
  CheckEquals('FFFFFF80', UpperCase(Value.ToHexString));
  {$IFEND}
end;

procedure TestTShortIntHelper.TestToHexString2;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckEquals('0', Value.ToHexString(0));
  CheckEquals('0', Value.ToHexString(1));
  CheckEquals('00', Value.ToHexString(2));
  CheckEquals('000', Value.ToHexString(3));

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString(0)));
  CheckEquals('F', UpperCase(Value.ToHexString(1)));
  CheckEquals('0F', UpperCase(Value.ToHexString(2)));
  CheckEquals('00F', UpperCase(Value.ToHexString(3)));

  Value := 127;
  CheckEquals('7F', UpperCase(Value.ToHexString(0)));
  CheckEquals('7F', UpperCase(Value.ToHexString(1)));
  CheckEquals('7F', UpperCase(Value.ToHexString(2)));
  CheckEquals('07F', UpperCase(Value.ToHexString(3)));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := -15;
  CheckEquals('F1', UpperCase(Value.ToHexString(0)));
  CheckEquals('F1', UpperCase(Value.ToHexString(1)));
  CheckEquals('F1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FF1', UpperCase(Value.ToHexString(3)));

  Value := -128;
  CheckEquals('80', UpperCase(Value.ToHexString(0)));
  CheckEquals('80', UpperCase(Value.ToHexString(1)));
  CheckEquals('80', UpperCase(Value.ToHexString(2)));
  CheckEquals('F80', UpperCase(Value.ToHexString(3)));
  {$ELSE}
  { Obsolete }
  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(3)));

  Value := -128;
  CheckEquals('FFFFFF80', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFF80', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFF80', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFF80', UpperCase(Value.ToHexString(3)));
  {$IFEND}
end;

procedure TestTShortIntHelper.TestToBoolean;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 100;
  CheckTrue(Value.ToBoolean);

  Value := 127;
  CheckTrue(Value.ToBoolean);

  Value := -100;
  CheckTrue(Value.ToBoolean);

  Value := -128;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTShortIntHelper.TestToSingle;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToSingle, Single.Epsilon);

  Value := 127;
  CheckEquals(127.0, Value.ToSingle, Single.Epsilon);

  Value := -100;
  CheckEquals(-100.0, Value.ToSingle, Single.Epsilon);

  Value := -128;
  CheckEquals(-128.0, Value.ToSingle, Single.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTShortIntHelper.TestToDouble;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToDouble, Double.Epsilon);

  Value := 127;
  CheckEquals(127.0, Value.ToDouble, Double.Epsilon);

  Value := -100;
  CheckEquals(-100.0, Value.ToDouble, Double.Epsilon);

  Value := -127;
  CheckEquals(-127.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTShortIntHelper.TestToExtended;
var
  Value: ShortInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToExtended, Extended.Epsilon);

  Value := 127;
  CheckEquals(127.0, Value.ToExtended, Extended.Epsilon);

  Value := -100;
  CheckEquals(-100.0, Value.ToExtended, Extended.Epsilon);

  Value := -127;
  CheckEquals(-127.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTShortIntHelper.BadParse;
begin
  ShortInt.Parse(FBadValue);
end;

procedure TestTShortIntHelper.TestParse;
begin
  CheckEquals(0, ShortInt.Parse('0'));
  CheckEquals(0, ShortInt.Parse('000'));
  CheckEquals(0, ShortInt.Parse('+000'));
  CheckEquals(0, ShortInt.Parse('-000'));

  CheckEquals(100, ShortInt.Parse('100'));
  CheckEquals(100, ShortInt.Parse('0100'));
  CheckEquals(100, ShortInt.Parse('+100'));
  CheckEquals(100, ShortInt.Parse('+0100'));

  CheckEquals(127, ShortInt.Parse('127'));

  CheckEquals(-100, ShortInt.Parse('-100'));
  CheckEquals(-100, ShortInt.Parse('-0100'));

  CheckEquals(-128, ShortInt.Parse('-128'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-129';
  CheckException(BadParse, EConvertError);

  FBadValue := '128';
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

procedure TestTShortIntHelper.TestTryParse;
var
  CheckValue: ShortInt;
begin
  CheckTrue(ShortInt.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(ShortInt.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(ShortInt.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(ShortInt.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(ShortInt.TryParse('100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(ShortInt.TryParse('0100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(ShortInt.TryParse('+100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(ShortInt.TryParse('+0100', CheckValue));
  CheckEquals(100, CheckValue);

  CheckTrue(ShortInt.TryParse('127', CheckValue));
  CheckEquals(127, CheckValue);

  CheckTrue(ShortInt.TryParse('-100', CheckValue));
  CheckEquals(-100, CheckValue);
  CheckTrue(ShortInt.TryParse('-0100', CheckValue));
  CheckEquals(-100, CheckValue);

  CheckTrue(ShortInt.TryParse('-128', CheckValue));
  CheckEquals(-128, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(ShortInt.TryParse('-129', CheckValue));
  CheckFalse(ShortInt.TryParse('128', CheckValue));
  {$IFEND}
  CheckFalse(ShortInt.TryParse('', CheckValue));
  CheckFalse(ShortInt.TryParse('+', CheckValue));
  CheckFalse(ShortInt.TryParse('-', CheckValue));
  CheckFalse(ShortInt.TryParse('INF', CheckValue));
  CheckFalse(ShortInt.TryParse('+INF', CheckValue));
  CheckFalse(ShortInt.TryParse('-INF', CheckValue));
  CheckFalse(ShortInt.TryParse('NAN', CheckValue));
  CheckFalse(ShortInt.TryParse('**INVALID**', CheckValue));
  CheckFalse(ShortInt.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTShortIntHelper.Suite);

end.

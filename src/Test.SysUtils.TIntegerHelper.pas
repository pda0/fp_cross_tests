{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TIntegerHelper;

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
  TestTIntegerHelper = class(TTestCase)
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

{ TestTIntegerHelper }

procedure TestTIntegerHelper.TestMinValue;
begin
  CheckEquals(-2147483648, Integer.MinValue);
end;

procedure TestTIntegerHelper.TestMaxValue;
begin
  CheckEquals(2147483647, Integer.MaxValue);
end;

procedure TestTIntegerHelper.TestSize;
begin
  CheckEquals(SizeOf(Integer), Integer.Size);
end;

procedure TestTIntegerHelper.TestToString1;
var
  Value: Integer;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 70000;
  CheckEquals('70000', Value.ToString);

  Value := 2147483647;
  CheckEquals('2147483647', Value.ToString);

  Value := -70000;
  CheckEquals('-70000', Value.ToString);

  Value := -2147483648;
  CheckEquals('-2147483648', Value.ToString);
end;

procedure TestTIntegerHelper.TestToString2;
begin
  CheckEquals('0', Integer.ToString(0));

  CheckEquals('70000', Integer.ToString(70000));

  CheckEquals('2147483647', Integer.ToString(2147483647));

  CheckEquals('-70000', Integer.ToString(-70000));

  CheckEquals('-2147483648', Integer.ToString(-2147483648));
end;

procedure TestTIntegerHelper.TestToHexString1;
var
  Value: Integer;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('00000000', Value.ToHexString);

  Value := 15;
  CheckEquals('0000000F', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('00000FFF', UpperCase(Value.ToHexString));

  Value := 16777215;
  CheckEquals('00FFFFFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString));

  Value := 16777215;
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 2147483647;
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString));

  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString));

  Value := -4095;
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString));

  Value := -16777215;
  CheckEquals('FF000001', UpperCase(Value.ToHexString));

  Value := -2147483648;
  CheckEquals('80000000', UpperCase(Value.ToHexString));
end;

procedure TestTIntegerHelper.TestToHexString2;
var
  Value: Integer;
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
  CheckEquals('00000F', UpperCase(Value.ToHexString(6)));
  CheckEquals('000000F', UpperCase(Value.ToHexString(7)));
  CheckEquals('0000000F', UpperCase(Value.ToHexString(8)));
  CheckEquals('00000000F', UpperCase(Value.ToHexString(9)));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('0FFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('00FFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('000FFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('0000FFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('00000FFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('000000FFF', UpperCase(Value.ToHexString(9)));

  Value := 16777215;
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('0FFFFFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('00FFFFFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('000FFFFFF', UpperCase(Value.ToHexString(9)));

  Value := 2147483647;
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('7FFFFFFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('07FFFFFFF', UpperCase(Value.ToHexString(9)));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := -15;
  CheckEquals('F1', UpperCase(Value.ToHexString(0)));
  CheckEquals('F1', UpperCase(Value.ToHexString(1)));
  CheckEquals('F1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FF1', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFF1', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFF1', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFF1', UpperCase(Value.ToHexString(6)));
  CheckEquals('FFFFFF1', UpperCase(Value.ToHexString(7)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(8)));
  CheckEquals('FFFFFFFF1', UpperCase(Value.ToHexString(9)));

  Value := -4095;
  CheckEquals('F001', UpperCase(Value.ToHexString(0)));
  CheckEquals('F001', UpperCase(Value.ToHexString(1)));
  CheckEquals('F001', UpperCase(Value.ToHexString(2)));
  CheckEquals('F001', UpperCase(Value.ToHexString(3)));
  CheckEquals('F001', UpperCase(Value.ToHexString(4)));
  CheckEquals('FF001', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFF001', UpperCase(Value.ToHexString(6)));
  CheckEquals('FFFF001', UpperCase(Value.ToHexString(7)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(8)));
  CheckEquals('FFFFFF001', UpperCase(Value.ToHexString(9)));

  Value := -16777215;
  CheckEquals('F000001', UpperCase(Value.ToHexString(0)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(1)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(2)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(3)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(4)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(5)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(6)));
  CheckEquals('F000001', UpperCase(Value.ToHexString(7)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(8)));
  CheckEquals('FFF000001', UpperCase(Value.ToHexString(9)));

  Value := -2147483648;
  CheckEquals('80000000', UpperCase(Value.ToHexString(0)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(1)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(2)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(3)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(4)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(5)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(6)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(7)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(8)));
  CheckEquals('F80000000', UpperCase(Value.ToHexString(9)));
  {$ELSE}
  { Obsolete }
  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(6)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(7)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(8)));
  CheckEquals('0FFFFFFF1', UpperCase(Value.ToHexString(9)));

  Value := -4095;
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(6)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(7)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(8)));
  CheckEquals('0FFFFF001', UpperCase(Value.ToHexString(9)));

  Value := -16777215;
  CheckEquals('FF000001', UpperCase(Value.ToHexString(0)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(1)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(2)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(3)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(4)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(5)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(6)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(7)));
  CheckEquals('FF000001', UpperCase(Value.ToHexString(8)));
  CheckEquals('0FF000001', UpperCase(Value.ToHexString(9)));

  Value := -2147483648;
  CheckEquals('80000000', UpperCase(Value.ToHexString(0)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(1)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(2)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(3)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(4)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(5)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(6)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(7)));
  CheckEquals('80000000', UpperCase(Value.ToHexString(8)));
  CheckEquals('080000000', UpperCase(Value.ToHexString(9)));
  {$IFEND}
end;

procedure TestTIntegerHelper.TestToBoolean;
var
  Value: Integer;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 70000;
  CheckTrue(Value.ToBoolean);

  Value := 2147483647;
  CheckTrue(Value.ToBoolean);

  Value := -70000;
  CheckTrue(Value.ToBoolean);

  Value := -2147483648;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTIntegerHelper.TestToSingle;
var
  Value: Integer;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToSingle, Single.Epsilon);

  Value := 2147483647;
  CheckEquals(2147483647.0, Value.ToSingle, 1); { Single is unable to fit this number }

  Value := -70000;
  CheckEquals(-70000.0, Value.ToSingle, Single.Epsilon);

  Value := -2147483648;
  CheckEquals(-2147483648.0, Value.ToSingle, Single.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTIntegerHelper.TestToDouble;
var
  Value: Integer;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToDouble, Double.Epsilon);

  Value := 2147483647;
  CheckEquals(2147483647.0, Value.ToDouble, Double.Epsilon);

  Value := -70000;
  CheckEquals(-70000.0, Value.ToDouble, Double.Epsilon);

  Value := -2147483648;
  CheckEquals(-2147483648.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTIntegerHelper.TestToExtended;
var
  Value: Integer;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToExtended, Extended.Epsilon);

  Value := 2147483647;
  CheckEquals(2147483647.0, Value.ToExtended, Extended.Epsilon);

  Value := -70000;
  CheckEquals(-70000.0, Value.ToExtended, Extended.Epsilon);

  Value := -2147483648;
  CheckEquals(-2147483648.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTIntegerHelper.BadParse;
begin
  Integer.Parse(FBadValue);
end;

procedure TestTIntegerHelper.TestParse;
begin
  CheckEquals(0, Integer.Parse('0'));
  CheckEquals(0, Integer.Parse('000'));
  CheckEquals(0, Integer.Parse('+000'));
  CheckEquals(0, Integer.Parse('-000'));

  CheckEquals(70000, Integer.Parse('70000'));
  CheckEquals(70000, Integer.Parse('070000'));
  CheckEquals(70000, Integer.Parse('+70000'));
  CheckEquals(70000, Integer.Parse('+070000'));

  CheckEquals(2147483647, Integer.Parse('2147483647'));

  CheckEquals(-70000, Integer.Parse('-70000'));
  CheckEquals(-70000, Integer.Parse('-070000'));

  CheckEquals(-2147483648, Integer.Parse('-2147483648'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-2147483649';
  CheckException(BadParse, EConvertError);

  FBadValue := '2147483648';
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

procedure TestTIntegerHelper.TestTryParse;
var
  CheckValue: Integer;
begin
  CheckTrue(Integer.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Integer.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Integer.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Integer.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(Integer.TryParse('70000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Integer.TryParse('070000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Integer.TryParse('+70000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Integer.TryParse('+070000', CheckValue));
  CheckEquals(70000, CheckValue);

  CheckTrue(Integer.TryParse('2147483647', CheckValue));
  CheckEquals(2147483647, CheckValue);

  CheckTrue(Integer.TryParse('-70000', CheckValue));
  CheckEquals(-70000, CheckValue);
  CheckTrue(Integer.TryParse('-070000', CheckValue));
  CheckEquals(-70000, CheckValue);

  CheckTrue(Integer.TryParse('-2147483648', CheckValue));
  CheckEquals(-2147483648, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(Integer.TryParse('-2147483649', CheckValue));
  CheckFalse(Integer.TryParse('2147483648', CheckValue));
  {$IFEND}
  CheckFalse(Integer.TryParse('', CheckValue));
  CheckFalse(Integer.TryParse('+', CheckValue));
  CheckFalse(Integer.TryParse('-', CheckValue));
  CheckFalse(Integer.TryParse('INF', CheckValue));
  CheckFalse(Integer.TryParse('+INF', CheckValue));
  CheckFalse(Integer.TryParse('-INF', CheckValue));
  CheckFalse(Integer.TryParse('NAN', CheckValue));
  CheckFalse(Integer.TryParse('**INVALID**', CheckValue));
  CheckFalse(Integer.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTIntegerHelper.Suite);

end.

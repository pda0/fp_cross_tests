{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TSingleHelper;

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
  Classes, SysUtils, Test.TFloatHelper;

{$IF (DEFINED(FPC) AND DECLARED(Single)) OR DEFINED(DELPHI_XE2_PLUS)}
  {$DEFINE RUN_TESTS}
{$IFEND}

type
  TestTSingleHelper = class(TFloatHelper)
  private
    {$IFDEF RUN_TESTS}
    FBadString: string;
    FBadFormat: TFormatSettings;
    procedure PrepareValues(out Zero, NZero, SubNormalMin, SubNormalMid,
      SubNormalMax, NSubNormalMin, NSubNormalMid, NSubNormalMax, NormalMin,
      NormalMid, NormalMax, NNormalMin, NNormalMid, NNormalMax, Inf, NInf, NaN1,
      NaN2, NaN3, NaN4, NaN5, NaN6: Single);
    procedure BytesRangeOverflow;
    procedure WordsRangeOverflow;
    procedure BadParse1;
    procedure BadParse2;
    {$ENDIF}
  published
    procedure TestEpsilon;
    procedure TestMaxValue;
    procedure TestMinValue;
    procedure TestPositiveInfinity;
    procedure TestNegativeInfinity;
    procedure TestNaN;
    procedure TestExponent;
    procedure TestFraction;
    procedure TestMantissa;
    procedure TestSign;
    procedure TestExp;
    procedure TestFrac;
    procedure TestSpecialType;
    procedure TestBuildUp;
    procedure TestToString1;
    procedure TestToString2;
    procedure TestToString3;
    procedure TestToString4;
    procedure TestIsNan;
    procedure TestIsInfinity;
    procedure TestIsNegativeInfinity;
    procedure TestIsPositiveInfinity;
    procedure TestBytes;
    procedure TestWords;
    procedure TestParse1;
    procedure TestParse2;
    procedure TestTryParse1;
    procedure TestTryParse2;
    procedure TestSize;
  end;

implementation

{$IFNDEF FPC}
uses
  System.SysConst;
{$ENDIF}

{ TestTSingleHelper }

{$IFDEF RUN_TESTS}
procedure TestTSingleHelper.PrepareValues(out Zero, NZero, SubNormalMin,
  SubNormalMid, SubNormalMax, NSubNormalMin, NSubNormalMid, NSubNormalMax,
  NormalMin, NormalMid, NormalMax, NNormalMin, NNormalMid, NNormalMax, Inf,
  NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single);
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($00, $00, $00, $00); { 0 00000000 00000000000000000000000 }
  Zero := Value;

  ValueArray := MakeSingle($80, $00, $00, $00); { 1 00000000 00000000000000000000000 }
  NZero := Value;

  ValueArray := MakeSingle($00, $00, $00, $01); { 0 00000000 00000000000000000000001 }
  SubNormalMin := Value;

  ValueArray := MakeSingle($00, $40, $00, $00); { 0 00000000 10000000000000000000000 }
  SubNormalMid := Value;

  ValueArray := MakeSingle($00, $7f, $ff, $ff); { 0 00000000 11111111111111111111111 }
  SubNormalMax := Value;

  ValueArray := MakeSingle($80, $00, $00, $01); { 1 00000000 00000000000000000000001 }
  NSubNormalMax := Value;

  ValueArray := MakeSingle($80, $40, $00, $00); { 1 00000000 10000000000000000000000 }
  NSubNormalMid := Value;

  ValueArray := MakeSingle($80, $7f, $ff, $ff); { 1 00000000 11111111111111111111111 }
  NSubNormalMin := Value;

  ValueArray := MakeSingle($00, $80, $00, $00); { 0 00000001 00000000000000000000000 }
  NormalMin := Value;

  ValueArray := MakeSingle($3f, $ff, $ff, $ff); { 0 01111111 11111111111111111111111 }
  NormalMid := Value;

  ValueArray := MakeSingle($7f, $7f, $ff, $ff); { 0 11111110 11111111111111111111111 }
  NormalMax := Value;

  ValueArray := MakeSingle($80, $80, $00, $00); { 1 00000001 00000000000000000000000 }
  NNormalMax := Value;

  ValueArray := MakeSingle($bf, $ff, $ff, $ff); { 1 01111111 11111111111111111111111 }
  NNormalMid := Value;

  ValueArray := MakeSingle($ff, $7f, $ff, $ff); { 1 11111110 11111111111111111111111 }
  NNormalMin := Value;

  ValueArray := MakeSingle($7f, $80, $00, $00); { 0 11111111 00000000000000000000000 }
  Inf := Value;

  ValueArray := MakeSingle($ff, $80, $00, $00); { 1 11111111 00000000000000000000000 }
  NInf := Value;

  ValueArray := MakeSingle($7f, $c0, $00, $00); { 0 11111111 10000000000000000000000 }
  NaN1 := Value;

  ValueArray := MakeSingle($ff, $c0, $00, $00); { 1 11111111 10000000000000000000000 }
  NaN2 := Value;

  ValueArray := MakeSingle($7f, $ff, $ff, $ff); { 0 11111111 11111111111111111111111 }
  NaN3 := Value;

  ValueArray := MakeSingle($ff, $ff, $ff, $ff); { 1 11111111 11111111111111111111111 }
  NaN4 := Value;

  ValueArray := MakeSingle($7f, $d5, $55, $55); { 0 11111111 10101010101010101010101 }
  NaN5 := Value;

  ValueArray := MakeSingle($ff, $d5, $55, $55); { 1 11111111 10101010101010101010101 }
  NaN6 := Value;
end;
{$ENDIF RUN_TESTS}

procedure TestTSingleHelper.TestEpsilon;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value := Single.Epsilon;
  SwapToBig(ValueArray);

  CheckEquals($00, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($01, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestMaxValue;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value := Single.MaxValue;
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0]);
  CheckEquals($7f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestMinValue;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value := Single.MinValue;
  SwapToBig(ValueArray);

  CheckEquals($ff, ValueArray[0]);
  CheckEquals($7f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestPositiveInfinity;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value := Single.PositiveInfinity;
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0]);
  CheckEquals($80, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestNegativeInfinity;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value := Single.NegativeInfinity;
  SwapToBig(ValueArray);

  CheckEquals($ff, ValueArray[0]);
  CheckEquals($80, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestNaN;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
  i: Integer;
  Acc: Byte;
begin
  Value := Single.NaN;
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0] and $7f);
  CheckEquals($80, ValueArray[1] and $80);
  Acc := ValueArray[1] and $7f;

  { The rest of bits can be be anything but zero. }
  for i := 2 to High(ValueArray) do
    Acc := Acc or ValueArray[i];
  CheckNotEquals(0, Acc);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestExponent;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($d5, $00, $00, $00); { 1 10101010 00000000000000000000000 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($d5, $7f, $ff, $ff); { 1 10101010 11111111111111111111111 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($55, $7f, $ff, $ff); { 0 10101010 11111111111111111111111 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($d5, $55, $55, $55); { 1 10101010 10101010101010101010101 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($55, $55, $55, $55); { 0 10101010 10101010101010101010101 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($d5, $2a, $aa, $aa); { 1 10101010 01010101010101010101010 }
  CheckEquals($2b, Value.Exponent);

  ValueArray := MakeSingle($55, $2a, $aa, $aa); { 0 10101010 01010101010101010101010 }
  CheckEquals($2b, Value.Exponent);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestFraction;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
  CheckTrue(Value.Fraction.IsNaN);

  ValueArray := MakeSingle($00, $00, $00, $00); { +0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeSingle($80, $00, $00, $00); { -0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeSingle($3f, $e0, $00, $00); { 1.75, normal, > 1 }
  CheckEquals(1.75, Value.Fraction);

  ValueArray := MakeSingle($3e, $80, $00, $00); { 0.25, normal, < 1 }
  CheckEquals(1, Value.Fraction);               { because of 0 01111101 00000000000000000000000 }

  ValueArray := MakeSingle($00, $01, $00, $00); { 9.18354961579912E-41, denormal }
  CheckEquals(0.0078125, Value.Fraction);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestMantissa;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($aa, $80, $00, $00); { 1 01010101 00000000000000000000000 }
  CheckEquals($800000, Value.Mantissa);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  CheckEquals($800000, Value.Mantissa);

  ValueArray := MakeSingle($aa, $ff, $ff, $ff); { 1 01010101 11111111111111111111111 }
  CheckEquals($ffffff, Value.Mantissa);

  ValueArray := MakeSingle($55, $7f, $ff, $ff); { 0 10101010 11111111111111111111111 }
  CheckEquals($ffffff, Value.Mantissa);


  ValueArray := MakeSingle($aa, $d5, $55, $55); { 1 01010101 10101010101010101010101 }
  CheckEquals($d55555, Value.Mantissa);

  ValueArray := MakeSingle($55, $55, $55, $55); { 0 10101010 10101010101010101010101 }
  CheckEquals($d55555, Value.Mantissa);

  ValueArray := MakeSingle($aa, $aa, $aa, $aa); { 1 01010101 01010101010101010101010 }
  CheckEquals($aaaaaa, Value.Mantissa);

  ValueArray := MakeSingle($55, $2a, $aa, $aa); { 0 10101010 01010101010101010101010 }
  CheckEquals($aaaaaa, Value.Mantissa);


  ValueArray := MakeSingle($00, $00, $00, $00); { 0 00000000 00000000000000000000000 }
  CheckEquals($000000, Value.Mantissa);

  ValueArray := MakeSingle($80, $00, $00, $00); { 1 00000000 00000000000000000000000 }
  CheckEquals($000000, Value.Mantissa);

  ValueArray := MakeSingle($7f, $ff, $ff, $ff); { 0 11111111 11111111111111111111111 }
  CheckEquals($7fffff, Value.Mantissa);

  ValueArray := MakeSingle($ff, $d5, $55, $55); { 1 11111111 10101010101010101010101 }
  CheckEquals($555555, Value.Mantissa);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestSign;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($ff, $ff, $ff, $ff);
  CheckTrue(Value.Sign);

  ValueArray := MakeSingle($80, $00, $00, $00);  { -0, btw }
  CheckTrue(Value.Sign);

  ValueArray := MakeSingle($aa, $aa, $aa, $aa);
  CheckTrue(Value.Sign);

  ValueArray := MakeSingle($7f, $ff, $ff, $ff);
  CheckFalse(Value.Sign);

  ValueArray := MakeSingle($00, $00, $00, $00);
  CheckFalse(Value.Sign);

  ValueArray := MakeSingle($55, $55, $55, $55);
  CheckFalse(Value.Sign);

  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckFalse(Value.Sign);

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckTrue(Value.Sign);

  ValueArray := MakeSingle($00, $00, $00, $00);
  Value.Sign := True;
  SwapToBig(ValueArray);
  CheckEquals($80, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);

  ValueArray := MakeSingle($ff, $ff, $ff, $ff);
  Value.Sign := False;
  SwapToBig(ValueArray);
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestExp;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($d5, $00, $00, $00); { 1 10101010 00000000000000000000000 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($d5, $7f, $ff, $ff); { 1 10101010 11111111111111111111111 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($55, $7f, $ff, $ff); { 0 10101010 11111111111111111111111 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($d5, $55, $55, $55); { 1 10101010 10101010101010101010101 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($55, $55, $55, $55); { 0 10101010 10101010101010101010101 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($d5, $2a, $aa, $aa); { 1 10101010 01010101010101010101010 }
  CheckEquals($aa, Value.Exp);

  ValueArray := MakeSingle($55, $2a, $aa, $aa); { 0 10101010 01010101010101010101010 }
  CheckEquals($aa, Value.Exp);


  ValueArray := MakeSingle($d5, $00, $00, $00); { 1 10101010 00000000000000000000000 }
  Value.Exp := $55;                             { 1 01010101 00000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($80, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  Value.Exp := $55;                             { 0 01010101 00000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($80, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);

  ValueArray := MakeSingle($d5, $7f, $ff, $ff); { 1 10101010 11111111111111111111111 }
  Value.Exp := $55;                             { 1 01010101 11111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($ff, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);

  ValueArray := MakeSingle($55, $7f, $ff, $ff); { 0 10101010 11111111111111111111111 }
  Value.Exp := $55;                             { 0 01010101 11111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($ff, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);

  ValueArray := MakeSingle($d5, $55, $55, $55); { 1 10101010 10101010101010101010101 }
  Value.Exp := $55;                             { 1 01010101 10101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($d5, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]);

  ValueArray := MakeSingle($55, $55, $55, $55); { 0 10101010 10101010101010101010101 }
  Value.Exp := $55;                             { 0 01010101 10101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($d5, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]);

  ValueArray := MakeSingle($d5, $2a, $aa, $aa); { 1 10101010 01010101010101010101010 }
  Value.Exp := $55;                             { 1 01010101 01010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]);

  ValueArray := MakeSingle($55, $2a, $aa, $aa); { 0 10101010 01010101010101010101010 }
  Value.Exp := $55;                             { 0 01010101 01010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]);


  { Overflow protection }
  ValueArray := MakeSingle($00, $00, $00, $00); { 0 00000000 00000000000000000000000 }
  Value.Exp := 256;                             { 0 00000000 00000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($00, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);

  ValueArray := MakeSingle($00, $00, $00, $00); { 0 00000000 00000000000000000000000 }
  Value.Exp := 257;                             { 0 00000001 00000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($80, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestFrac;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($aa, $80, $00, $00); { 1 01010101 00000000000000000000000 }
  CheckEquals($000000, Value.Frac);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  CheckEquals($000000, Value.Frac);

  ValueArray := MakeSingle($aa, $ff, $ff, $ff); { 1 01010101 11111111111111111111111 }
  CheckEquals($7fffff, Value.Frac);

  ValueArray := MakeSingle($55, $7f, $ff, $ff); { 0 10101010 11111111111111111111111 }
  CheckEquals($7fffff, Value.Frac);

  ValueArray := MakeSingle($aa, $d5, $55, $55); { 1 01010101 10101010101010101010101 }
  CheckEquals($555555, Value.Frac);

  ValueArray := MakeSingle($55, $55, $55, $55); { 0 10101010 10101010101010101010101 }
  CheckEquals($555555, Value.Frac);

  ValueArray := MakeSingle($aa, $aa, $aa, $aa); { 1 01010101 01010101010101010101010 }
  CheckEquals($2aaaaa, Value.Frac);

  ValueArray := MakeSingle($55, $2a, $aa, $aa); { 0 10101010 01010101010101010101010 }
  CheckEquals($2aaaaa, Value.Frac);


  ValueArray := MakeSingle($aa, $80, $00, $00); { 1 01010101 00000000000000000000000 }
  Value.Frac := $7fffff;                        { 1 01010101 11111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($ff, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);

  ValueArray := MakeSingle($55, $00, $00, $00); { 0 10101010 00000000000000000000000 }
  Value.Frac := $7fffff;
  SwapToBig(ValueArray);                        { 0 10101010 11111111111111111111111 }
  CheckEquals($55, ValueArray[0]); CheckEquals($7f, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestSpecialType;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  { fsZero }
  CheckTrue(      fsZero = Zero.SpecialType);
  CheckFalse(    fsNZero = Zero.SpecialType);
  CheckFalse( fsDenormal = Zero.SpecialType);
  CheckFalse(fsNDenormal = Zero.SpecialType);
  CheckFalse( fsPositive = Zero.SpecialType);
  CheckFalse( fsNegative = Zero.SpecialType);
  CheckFalse(      fsInf = Zero.SpecialType);
  CheckFalse(     fsNInf = Zero.SpecialType);
  CheckFalse(      fsNaN = Zero.SpecialType);

  { fsNZero }
  CheckFalse(     fsZero = NZero.SpecialType);
  CheckTrue(     fsNZero = NZero.SpecialType);
  CheckFalse( fsDenormal = NZero.SpecialType);
  CheckFalse(fsNDenormal = NZero.SpecialType);
  CheckFalse( fsPositive = NZero.SpecialType);
  CheckFalse( fsNegative = NZero.SpecialType);
  CheckFalse(      fsInf = NZero.SpecialType);
  CheckFalse(     fsNInf = NZero.SpecialType);
  CheckFalse(      fsNaN = NZero.SpecialType);

  { fsDenormal }
  CheckFalse(     fsZero = SubNormalMin.SpecialType);
  CheckFalse(    fsNZero = SubNormalMin.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMin.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMin.SpecialType);
  CheckFalse( fsPositive = SubNormalMin.SpecialType);
  CheckFalse( fsNegative = SubNormalMin.SpecialType);
  CheckFalse(      fsInf = SubNormalMin.SpecialType);
  CheckFalse(     fsNInf = SubNormalMin.SpecialType);
  CheckFalse(      fsNaN = SubNormalMin.SpecialType);

  CheckFalse(     fsZero = SubNormalMid.SpecialType);
  CheckFalse(    fsNZero = SubNormalMid.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMid.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMid.SpecialType);
  CheckFalse( fsPositive = SubNormalMid.SpecialType);
  CheckFalse( fsNegative = SubNormalMid.SpecialType);
  CheckFalse(      fsInf = SubNormalMid.SpecialType);
  CheckFalse(     fsNInf = SubNormalMid.SpecialType);
  CheckFalse(      fsNaN = SubNormalMid.SpecialType);

  CheckFalse(     fsZero = SubNormalMax.SpecialType);
  CheckFalse(    fsNZero = SubNormalMax.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMax.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMax.SpecialType);
  CheckFalse( fsPositive = SubNormalMax.SpecialType);
  CheckFalse( fsNegative = SubNormalMax.SpecialType);
  CheckFalse(      fsInf = SubNormalMax.SpecialType);
  CheckFalse(     fsNInf = SubNormalMax.SpecialType);
  CheckFalse(      fsNaN = SubNormalMax.SpecialType);

  { fsNDenormal }
  CheckFalse(     fsZero = NSubNormalMin.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMin.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMin.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMin.SpecialType);
  CheckFalse( fsPositive = NSubNormalMin.SpecialType);
  CheckFalse( fsNegative = NSubNormalMin.SpecialType);
  CheckFalse(      fsInf = NSubNormalMin.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMin.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMin.SpecialType);

  CheckFalse(     fsZero = NSubNormalMid.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMid.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMid.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMid.SpecialType);
  CheckFalse( fsPositive = NSubNormalMid.SpecialType);
  CheckFalse( fsNegative = NSubNormalMid.SpecialType);
  CheckFalse(      fsInf = NSubNormalMid.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMid.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMid.SpecialType);

  CheckFalse(     fsZero = NSubNormalMax.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMax.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMax.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMax.SpecialType);
  CheckFalse( fsPositive = NSubNormalMax.SpecialType);
  CheckFalse( fsNegative = NSubNormalMax.SpecialType);
  CheckFalse(      fsInf = NSubNormalMax.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMax.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMax.SpecialType);

  { fsPositive }
  CheckFalse(     fsZero = NormalMin.SpecialType);
  CheckFalse(    fsNZero = NormalMin.SpecialType);
  CheckFalse( fsDenormal = NormalMin.SpecialType);
  CheckFalse(fsNDenormal = NormalMin.SpecialType);
  CheckTrue(  fsPositive = NormalMin.SpecialType);
  CheckFalse( fsNegative = NormalMin.SpecialType);
  CheckFalse(      fsInf = NormalMin.SpecialType);
  CheckFalse(     fsNInf = NormalMin.SpecialType);
  CheckFalse(      fsNaN = NormalMin.SpecialType);

  CheckFalse(     fsZero = NormalMid.SpecialType);
  CheckFalse(    fsNZero = NormalMid.SpecialType);
  CheckFalse( fsDenormal = NormalMid.SpecialType);
  CheckFalse(fsNDenormal = NormalMid.SpecialType);
  CheckTrue(  fsPositive = NormalMid.SpecialType);
  CheckFalse( fsNegative = NormalMid.SpecialType);
  CheckFalse(      fsInf = NormalMid.SpecialType);
  CheckFalse(     fsNInf = NormalMid.SpecialType);
  CheckFalse(      fsNaN = NormalMid.SpecialType);

  CheckFalse(     fsZero = NormalMax.SpecialType);
  CheckFalse(    fsNZero = NormalMax.SpecialType);
  CheckFalse( fsDenormal = NormalMax.SpecialType);
  CheckFalse(fsNDenormal = NormalMax.SpecialType);
  CheckTrue(  fsPositive = NormalMax.SpecialType);
  CheckFalse( fsNegative = NormalMax.SpecialType);
  CheckFalse(      fsInf = NormalMax.SpecialType);
  CheckFalse(     fsNInf = NormalMax.SpecialType);
  CheckFalse(      fsNaN = NormalMax.SpecialType);

  { fsNegative }
  CheckFalse(     fsZero = NNormalMin.SpecialType);
  CheckFalse(    fsNZero = NNormalMin.SpecialType);
  CheckFalse( fsDenormal = NNormalMin.SpecialType);
  CheckFalse(fsNDenormal = NNormalMin.SpecialType);
  CheckFalse( fsPositive = NNormalMin.SpecialType);
  CheckTrue(  fsNegative = NNormalMin.SpecialType);
  CheckFalse(      fsInf = NNormalMin.SpecialType);
  CheckFalse(     fsNInf = NNormalMin.SpecialType);
  CheckFalse(      fsNaN = NNormalMin.SpecialType);

  CheckFalse(     fsZero = NNormalMid.SpecialType);
  CheckFalse(    fsNZero = NNormalMid.SpecialType);
  CheckFalse( fsDenormal = NNormalMid.SpecialType);
  CheckFalse(fsNDenormal = NNormalMid.SpecialType);
  CheckFalse( fsPositive = NNormalMid.SpecialType);
  CheckTrue(  fsNegative = NNormalMid.SpecialType);
  CheckFalse(      fsInf = NNormalMid.SpecialType);
  CheckFalse(     fsNInf = NNormalMid.SpecialType);
  CheckFalse(      fsNaN = NNormalMid.SpecialType);

  CheckFalse(     fsZero = NNormalMax.SpecialType);
  CheckFalse(    fsNZero = NNormalMax.SpecialType);
  CheckFalse( fsDenormal = NNormalMax.SpecialType);
  CheckFalse(fsNDenormal = NNormalMax.SpecialType);
  CheckFalse( fsPositive = NNormalMax.SpecialType);
  CheckTrue(  fsNegative = NNormalMax.SpecialType);
  CheckFalse(      fsInf = NNormalMax.SpecialType);
  CheckFalse(     fsNInf = NNormalMax.SpecialType);
  CheckFalse(      fsNaN = NNormalMax.SpecialType);

  { fsInf }
  CheckFalse(     fsZero = Inf.SpecialType);
  CheckFalse(    fsNZero = Inf.SpecialType);
  CheckFalse( fsDenormal = Inf.SpecialType);
  CheckFalse(fsNDenormal = Inf.SpecialType);
  CheckFalse( fsPositive = Inf.SpecialType);
  CheckFalse( fsNegative = Inf.SpecialType);
  CheckTrue(       fsInf = Inf.SpecialType);
  CheckFalse(     fsNInf = Inf.SpecialType);
  CheckFalse(      fsNaN = Inf.SpecialType);

  { fsNInf }
  CheckFalse(     fsZero = NInf.SpecialType);
  CheckFalse(    fsNZero = NInf.SpecialType);
  CheckFalse( fsDenormal = NInf.SpecialType);
  CheckFalse(fsNDenormal = NInf.SpecialType);
  CheckFalse( fsPositive = NInf.SpecialType);
  CheckFalse( fsNegative = NInf.SpecialType);
  CheckFalse(      fsInf = NInf.SpecialType);
  CheckTrue(      fsNInf = NInf.SpecialType);
  CheckFalse(      fsNaN = NInf.SpecialType);

  { fsNaN }
  CheckFalse(     fsZero = NaN1.SpecialType);
  CheckFalse(    fsNZero = NaN1.SpecialType);
  CheckFalse( fsDenormal = NaN1.SpecialType);
  CheckFalse(fsNDenormal = NaN1.SpecialType);
  CheckFalse( fsPositive = NaN1.SpecialType);
  CheckFalse( fsNegative = NaN1.SpecialType);
  CheckFalse(      fsInf = NaN1.SpecialType);
  CheckFalse(     fsNInf = NaN1.SpecialType);
  CheckTrue(       fsNaN = NaN1.SpecialType);

  CheckFalse(     fsZero = NaN2.SpecialType);
  CheckFalse(    fsNZero = NaN2.SpecialType);
  CheckFalse( fsDenormal = NaN2.SpecialType);
  CheckFalse(fsNDenormal = NaN2.SpecialType);
  CheckFalse( fsPositive = NaN2.SpecialType);
  CheckFalse( fsNegative = NaN2.SpecialType);
  CheckFalse(      fsInf = NaN2.SpecialType);
  CheckFalse(     fsNInf = NaN2.SpecialType);
  CheckTrue(       fsNaN = NaN2.SpecialType);

  CheckFalse(     fsZero = NaN3.SpecialType);
  CheckFalse(    fsNZero = NaN3.SpecialType);
  CheckFalse( fsDenormal = NaN3.SpecialType);
  CheckFalse(fsNDenormal = NaN3.SpecialType);
  CheckFalse( fsPositive = NaN3.SpecialType);
  CheckFalse( fsNegative = NaN3.SpecialType);
  CheckFalse(      fsInf = NaN3.SpecialType);
  CheckFalse(     fsNInf = NaN3.SpecialType);
  CheckTrue(       fsNaN = NaN3.SpecialType);

  CheckFalse(     fsZero = NaN4.SpecialType);
  CheckFalse(    fsNZero = NaN4.SpecialType);
  CheckFalse( fsDenormal = NaN4.SpecialType);
  CheckFalse(fsNDenormal = NaN4.SpecialType);
  CheckFalse( fsPositive = NaN4.SpecialType);
  CheckFalse( fsNegative = NaN4.SpecialType);
  CheckFalse(      fsInf = NaN4.SpecialType);
  CheckFalse(     fsNInf = NaN4.SpecialType);
  CheckTrue(       fsNaN = NaN4.SpecialType);

  CheckFalse(     fsZero = NaN5.SpecialType);
  CheckFalse(    fsNZero = NaN5.SpecialType);
  CheckFalse( fsDenormal = NaN5.SpecialType);
  CheckFalse(fsNDenormal = NaN5.SpecialType);
  CheckFalse( fsPositive = NaN5.SpecialType);
  CheckFalse( fsNegative = NaN5.SpecialType);
  CheckFalse(      fsInf = NaN5.SpecialType);
  CheckFalse(     fsNInf = NaN5.SpecialType);
  CheckTrue(       fsNaN = NaN5.SpecialType);

  CheckFalse(     fsZero = NaN6.SpecialType);
  CheckFalse(    fsNZero = NaN6.SpecialType);
  CheckFalse( fsDenormal = NaN6.SpecialType);
  CheckFalse(fsNDenormal = NaN6.SpecialType);
  CheckFalse( fsPositive = NaN6.SpecialType);
  CheckFalse( fsNegative = NaN6.SpecialType);
  CheckFalse(      fsInf = NaN6.SpecialType);
  CheckFalse(     fsNInf = NaN6.SpecialType);
  CheckTrue(       fsNaN = NaN6.SpecialType);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestBuildUp;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  Value.BuildUp(False, 0, 128);
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0]);
  CheckEquals($80, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);

  Value.BuildUp(True, $7fffff, -127);
  SwapToBig(ValueArray);

  CheckEquals($80, ValueArray[0]);
  CheckEquals($7f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);


  { Overflow }

  Value.BuildUp(False, 0, 256);
  SwapToBig(ValueArray);

  CheckEquals($3f, ValueArray[0]);
  CheckEquals($80, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);

  Value.BuildUp(False, 0, $7fffffff);
  SwapToBig(ValueArray);

  CheckEquals($3f, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);

  Value.BuildUp(False, UInt64($ffffffffffffffff), -127);
  SwapToBig(ValueArray);

  CheckEquals($00, ValueArray[0]);
  CheckEquals($7f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestToString1;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($3f, $e0, $00, $00); { 1.75, normal }
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Value.ToString);
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Single.ToString(Value));

  ValueArray := MakeSingle($be, $80, $00, $00); { -0.25, normal }
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Value.ToString);
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Single.ToString(Value));

  ValueArray := MakeSingle($00, $04, $d6, $01); { 4.44112121e-40, subnormal }
  CheckEquals('4' + FormatSettings.DecimalSeparator + '44112121E-40', UpperCase(Value.ToString));
  CheckEquals('4' + FormatSettings.DecimalSeparator + '44112121E-40', UpperCase(Single.ToString(Value)));

  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString));
  CheckEquals('INF', UpperCase(Single.ToString(Value)));

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString));
  CheckEquals('-INF', UpperCase(Single.ToString(Value)));

  ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString));
  CheckEquals('NAN', UpperCase(Single.ToString(Value)));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestToString2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.DecimalSeparator := ';';

  ValueArray := MakeSingle($3f, $e0, $00, $00); { 1.75, normal }
  CheckEquals('1;75', Value.ToString(LocalFormat));
  CheckEquals('1;75', Single.ToString(Value, LocalFormat));

  ValueArray := MakeSingle($be, $80, $00, $00); { -0.25, normal }
  CheckEquals('-0;25', Value.ToString(LocalFormat));
  CheckEquals('-0;25', Single.ToString(Value, LocalFormat));

  ValueArray := MakeSingle($00, $04, $d6, $01); { 4.44112121e-40, subnormal }
  CheckEquals('4;44112121E-40', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('4;44112121E-40', UpperCase(Single.ToString(Value, LocalFormat)));

  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, LocalFormat)));

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, LocalFormat)));

  ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, LocalFormat)));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestToString3;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
  TestStr: string;
begin
  Value := 2.8e32;
  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Single.ToString(Value, ffGeneral, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '800000E+32', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '800000E+32', UpperCase(Single.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Single.ToString(Value, ffFixed, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Single.ToString(Value, ffNumber, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '8E32', UpperCase(Single.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeSingle($bf, $e0, $00, $00); { -1.75 }
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffGeneral, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Single.ToString(Value, ffGeneral, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Single.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffFixed, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Single.ToString(Value, ffFixed, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Value.ToString(ffFixed, 7, 3));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Single.ToString(Value, ffFixed, 7, 3));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Single.ToString(Value, ffNumber, 7, 2));

  ValueArray := MakeSingle($c9, $74, $24, $0c); { -1000000.75 }
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Single.ToString(Value, ffNumber, 7, 2));

  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 9, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Single.ToString(Value, ffNumber, 9, 2));

  ValueArray := MakeSingle($3f, $e0, $00, $00); { 1.75 }
  case FormatSettings.CurrencyFormat of
    0:
      TestStr := FormatSettings.CurrencyString + '1' + FormatSettings.DecimalSeparator + '75';
    1:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75' + FormatSettings.CurrencyString;
    2:
      TestStr := FormatSettings.CurrencyString + ' 1' + FormatSettings.DecimalSeparator + '75';
    3:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75 ' + FormatSettings.CurrencyString;
    else
      Fail('Unexpected FormatSettings.CurrencyFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals(TestStr, UpperCase(Single.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeSingle($c9, $74, $24, $0c); { -1000000.75 }
  TestStr := '1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75';
  case FormatSettings.NegCurrFormat of
    0:
      TestStr := '(' + FormatSettings.CurrencyString + TestStr +')';
    1:
      TestStr := '-' + FormatSettings.CurrencyString + TestStr;
    2:
      TestStr := '' + FormatSettings.CurrencyString + '-' + TestStr;
    3:
      TestStr := '' + FormatSettings.CurrencyString + TestStr + '-';
    4:
      TestStr := '(' + TestStr + FormatSettings.CurrencyString + ')';
    5:
      TestStr := '-' + TestStr + FormatSettings.CurrencyString;
    6:
      TestStr := TestStr +'-' + FormatSettings.CurrencyString;
    7:
      TestStr := TestStr + FormatSettings.CurrencyString + '-';
    8:
      TestStr := '-' + TestStr + ' ' + FormatSettings.CurrencyString;
    9:
      TestStr := '-' + FormatSettings.CurrencyString + ' ' + TestStr;
    10:
      TestStr := TestStr +' ' + FormatSettings.CurrencyString + '-';
    11:
      TestStr := FormatSettings.CurrencyString + ' ' + TestStr + '-';
    12:
      TestStr := FormatSettings.CurrencyString + ' -' + TestStr;
    13:
      TestStr := TestStr +'- ' + FormatSettings.CurrencyString;
    14:
      TestStr := '(' + FormatSettings.CurrencyString + ' ' + TestStr + ')';
    15:
      TestStr := '(' + TestStr + ' ' + FormatSettings.CurrencyString + ')';
    else
      Fail('Unexpected FormatSettings.NegCurrFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 9, 2)));
  CheckEquals(TestStr, UpperCase(Single.ToString(Value, ffCurrency, 9, 2)));

  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffCurrency, 7, 2)));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestToString4;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Single;
  ValueArray: TSingleArray absolute Value;
  i: Byte;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := '~';
  LocalFormat.DecimalSeparator := ';';
  LocalFormat.CurrencyString := '[@]';
  LocalFormat.CurrencyDecimals := 1;
  LocalFormat.CurrencyFormat := 0;
  LocalFormat.NegCurrFormat := 0;

  ValueArray := MakeSingle($c9, $74, $24, $0c); { -1000000.75 }

  CheckEquals('-1000000;75', Value.ToString(ffGeneral, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Single.ToString(Value, ffGeneral, 9, 2, LocalFormat));

  CheckEquals('-1;00000075E+06', UpperCase(Value.ToString(ffExponent, 9, 2, LocalFormat)));
  CheckEquals('-1;00000075E+06', UpperCase(Single.ToString(Value, ffExponent, 9, 2, LocalFormat)));

  CheckEquals('-1000000;75', Value.ToString(ffFixed, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Single.ToString(Value, ffFixed, 9, 2, LocalFormat));

  CheckEquals('-1000000;750', Value.ToString(ffFixed, 9, 3, LocalFormat));
  CheckEquals('-1000000;750', Single.ToString(Value, ffFixed, 9, 3, LocalFormat));

  CheckEquals('-1~000~000;75', Value.ToString(ffNumber, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75', Single.ToString(Value, ffNumber, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 15;
  CheckEquals('(1~000~000;75 [@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75 [@])', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 14;
  CheckEquals('([@] 1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@] 1~000~000;75)', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 13;
  CheckEquals('1~000~000;75- [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75- [@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 12;
  CheckEquals('[@] -1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] -1~000~000;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 11;
  CheckEquals('[@] 1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1~000~000;75-', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 10;
  CheckEquals('1~000~000;75 [@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75 [@]-', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 9;
  CheckEquals('-[@] 1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@] 1~000~000;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 8;
  CheckEquals('-1~000~000;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75 [@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 7;
  CheckEquals('1~000~000;75[@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75[@]-', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 6;
  CheckEquals('1~000~000;75-[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75-[@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 5;
  CheckEquals('-1~000~000;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75[@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 4;
  CheckEquals('(1~000~000;75[@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75[@])', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 3;
  CheckEquals('[@]1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1~000~000;75-', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 2;
  CheckEquals('[@]-1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]-1~000~000;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 1;
  CheckEquals('-[@]1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@]1~000~000;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 0;
  CheckEquals('([@]1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@]1~000~000;75)', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  ValueArray := MakeSingle($3f, $e0, $00, $00); { 1.75 }

  LocalFormat.CurrencyFormat := 3;
  CheckEquals('1;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75 [@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 2;
  CheckEquals('[@] 1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 1;
  CheckEquals('1;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75[@]', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 0;
  CheckEquals('[@]1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1;75', Single.ToString(Value, ffCurrency, 9, 2, LocalFormat));


  ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Single.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Single.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Single.ToString(Value, ffNumber, 7, 2, LocalFormat)));


  for i := 3 downto 0 do
  begin
    LocalFormat.CurrencyFormat := i;

    ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;

  for i := 15 downto 0 do
  begin
    LocalFormat.NegCurrFormat := i;

    ValueArray := MakeSingle($7f, $80, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeSingle($ff, $80, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeSingle($7f, $c0, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Single.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestIsNan;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsNan);
  CheckFalse(NZero.IsNan);
  CheckFalse(SubNormalMin.IsNan);
  CheckFalse(SubNormalMid.IsNan);
  CheckFalse(SubNormalMax.IsNan);
  CheckFalse(NSubNormalMin.IsNan);
  CheckFalse(NSubNormalMid.IsNan);
  CheckFalse(NSubNormalMax.IsNan);
  CheckFalse(NormalMin.IsNan);
  CheckFalse(NormalMid.IsNan);
  CheckFalse(NormalMax.IsNan);
  CheckFalse(NNormalMin.IsNan);
  CheckFalse(NNormalMid.IsNan);
  CheckFalse(NNormalMax.IsNan);
  CheckFalse(Inf.IsNan);
  CheckFalse(NInf.IsNan);
  CheckTrue(NaN1.IsNan);
  CheckTrue(NaN2.IsNan);
  CheckTrue(NaN3.IsNan);
  CheckTrue(NaN4.IsNan);
  CheckTrue(NaN5.IsNan);
  CheckTrue(NaN6.IsNan);

  CheckFalse(Single.IsNan(Zero));
  CheckFalse(Single.IsNan(NZero));
  CheckFalse(Single.IsNan(SubNormalMin));
  CheckFalse(Single.IsNan(SubNormalMid));
  CheckFalse(Single.IsNan(SubNormalMax));
  CheckFalse(Single.IsNan(NSubNormalMin));
  CheckFalse(Single.IsNan(NSubNormalMid));
  CheckFalse(Single.IsNan(NSubNormalMax));
  CheckFalse(Single.IsNan(NormalMin));
  CheckFalse(Single.IsNan(NormalMid));
  CheckFalse(Single.IsNan(NormalMax));
  CheckFalse(Single.IsNan(NNormalMin));
  CheckFalse(Single.IsNan(NNormalMid));
  CheckFalse(Single.IsNan(NNormalMax));
  CheckFalse(Single.IsNan(Inf));
  CheckFalse(Single.IsNan(NInf));
  CheckTrue(Single.IsNan(NaN1));
  CheckTrue(Single.IsNan(NaN2));
  CheckTrue(Single.IsNan(NaN3));
  CheckTrue(Single.IsNan(NaN4));
  CheckTrue(Single.IsNan(NaN5));
  CheckTrue(Single.IsNan(NaN6));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestIsInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsInfinity);
  CheckFalse(NZero.IsInfinity);
  CheckFalse(SubNormalMin.IsInfinity);
  CheckFalse(SubNormalMid.IsInfinity);
  CheckFalse(SubNormalMax.IsInfinity);
  CheckFalse(NSubNormalMin.IsInfinity);
  CheckFalse(NSubNormalMid.IsInfinity);
  CheckFalse(NSubNormalMax.IsInfinity);
  CheckFalse(NormalMin.IsInfinity);
  CheckFalse(NormalMid.IsInfinity);
  CheckFalse(NormalMax.IsInfinity);
  CheckFalse(NNormalMin.IsInfinity);
  CheckFalse(NNormalMid.IsInfinity);
  CheckFalse(NNormalMax.IsInfinity);
  CheckTrue(Inf.IsInfinity);
  CheckTrue(NInf.IsInfinity);
  CheckFalse(NaN1.IsInfinity);
  CheckFalse(NaN2.IsInfinity);
  CheckFalse(NaN3.IsInfinity);
  CheckFalse(NaN4.IsInfinity);
  CheckFalse(NaN5.IsInfinity);
  CheckFalse(NaN6.IsInfinity);

  CheckFalse(Single.IsInfinity(Zero));
  CheckFalse(Single.IsInfinity(NZero));
  CheckFalse(Single.IsInfinity(SubNormalMin));
  CheckFalse(Single.IsInfinity(SubNormalMid));
  CheckFalse(Single.IsInfinity(SubNormalMax));
  CheckFalse(Single.IsInfinity(NSubNormalMin));
  CheckFalse(Single.IsInfinity(NSubNormalMid));
  CheckFalse(Single.IsInfinity(NSubNormalMax));
  CheckFalse(Single.IsInfinity(NormalMin));
  CheckFalse(Single.IsInfinity(NormalMid));
  CheckFalse(Single.IsInfinity(NormalMax));
  CheckFalse(Single.IsInfinity(NNormalMin));
  CheckFalse(Single.IsInfinity(NNormalMid));
  CheckFalse(Single.IsInfinity(NNormalMax));
  CheckTrue(Single.IsInfinity(Inf));
  CheckTrue(Single.IsInfinity(NInf));
  CheckFalse(Single.IsInfinity(NaN1));
  CheckFalse(Single.IsInfinity(NaN2));
  CheckFalse(Single.IsInfinity(NaN3));
  CheckFalse(Single.IsInfinity(NaN4));
  CheckFalse(Single.IsInfinity(NaN5));
  CheckFalse(Single.IsInfinity(NaN6));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestIsNegativeInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsNegativeInfinity);
  CheckFalse(NZero.IsNegativeInfinity);
  CheckFalse(SubNormalMin.IsNegativeInfinity);
  CheckFalse(SubNormalMid.IsNegativeInfinity);
  CheckFalse(SubNormalMax.IsNegativeInfinity);
  CheckFalse(NSubNormalMin.IsNegativeInfinity);
  CheckFalse(NSubNormalMid.IsNegativeInfinity);
  CheckFalse(NSubNormalMax.IsNegativeInfinity);
  CheckFalse(NormalMin.IsNegativeInfinity);
  CheckFalse(NormalMid.IsNegativeInfinity);
  CheckFalse(NormalMax.IsNegativeInfinity);
  CheckFalse(NNormalMin.IsNegativeInfinity);
  CheckFalse(NNormalMid.IsNegativeInfinity);
  CheckFalse(NNormalMax.IsNegativeInfinity);
  CheckFalse(Inf.IsNegativeInfinity);
  CheckTrue(NInf.IsNegativeInfinity);
  CheckFalse(NaN1.IsNegativeInfinity);
  CheckFalse(NaN2.IsNegativeInfinity);
  CheckFalse(NaN3.IsNegativeInfinity);
  CheckFalse(NaN4.IsNegativeInfinity);
  CheckFalse(NaN5.IsNegativeInfinity);
  CheckFalse(NaN6.IsNegativeInfinity);

  CheckFalse(Single.IsNegativeInfinity(Zero));
  CheckFalse(Single.IsNegativeInfinity(NZero));
  CheckFalse(Single.IsNegativeInfinity(SubNormalMin));
  CheckFalse(Single.IsNegativeInfinity(SubNormalMid));
  CheckFalse(Single.IsNegativeInfinity(SubNormalMax));
  CheckFalse(Single.IsNegativeInfinity(NSubNormalMin));
  CheckFalse(Single.IsNegativeInfinity(NSubNormalMid));
  CheckFalse(Single.IsNegativeInfinity(NSubNormalMax));
  CheckFalse(Single.IsNegativeInfinity(NormalMin));
  CheckFalse(Single.IsNegativeInfinity(NormalMid));
  CheckFalse(Single.IsNegativeInfinity(NormalMax));
  CheckFalse(Single.IsNegativeInfinity(NNormalMin));
  CheckFalse(Single.IsNegativeInfinity(NNormalMid));
  CheckFalse(Single.IsNegativeInfinity(NNormalMax));
  CheckFalse(Single.IsNegativeInfinity(Inf));
  CheckTrue(Single.IsNegativeInfinity(NInf));
  CheckFalse(Single.IsNegativeInfinity(NaN1));
  CheckFalse(Single.IsNegativeInfinity(NaN2));
  CheckFalse(Single.IsNegativeInfinity(NaN3));
  CheckFalse(Single.IsNegativeInfinity(NaN4));
  CheckFalse(Single.IsNegativeInfinity(NaN5));
  CheckFalse(Single.IsNegativeInfinity(NaN6));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestIsPositiveInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Single;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsPositiveInfinity);
  CheckFalse(NZero.IsPositiveInfinity);
  CheckFalse(SubNormalMin.IsPositiveInfinity);
  CheckFalse(SubNormalMid.IsPositiveInfinity);
  CheckFalse(SubNormalMax.IsPositiveInfinity);
  CheckFalse(NSubNormalMin.IsPositiveInfinity);
  CheckFalse(NSubNormalMid.IsPositiveInfinity);
  CheckFalse(NSubNormalMax.IsPositiveInfinity);
  CheckFalse(NormalMin.IsPositiveInfinity);
  CheckFalse(NormalMid.IsPositiveInfinity);
  CheckFalse(NormalMax.IsPositiveInfinity);
  CheckFalse(NNormalMin.IsPositiveInfinity);
  CheckFalse(NNormalMid.IsPositiveInfinity);
  CheckFalse(NNormalMax.IsPositiveInfinity);
  CheckTrue(Inf.IsPositiveInfinity);
  CheckFalse(NInf.IsPositiveInfinity);
  CheckFalse(NaN1.IsPositiveInfinity);
  CheckFalse(NaN2.IsPositiveInfinity);
  CheckFalse(NaN3.IsPositiveInfinity);
  CheckFalse(NaN4.IsPositiveInfinity);
  CheckFalse(NaN5.IsPositiveInfinity);
  CheckFalse(NaN6.IsPositiveInfinity);

  CheckFalse(Single.IsPositiveInfinity(Zero));
  CheckFalse(Single.IsPositiveInfinity(NZero));
  CheckFalse(Single.IsPositiveInfinity(SubNormalMin));
  CheckFalse(Single.IsPositiveInfinity(SubNormalMid));
  CheckFalse(Single.IsPositiveInfinity(SubNormalMax));
  CheckFalse(Single.IsPositiveInfinity(NSubNormalMin));
  CheckFalse(Single.IsPositiveInfinity(NSubNormalMid));
  CheckFalse(Single.IsPositiveInfinity(NSubNormalMax));
  CheckFalse(Single.IsPositiveInfinity(NormalMin));
  CheckFalse(Single.IsPositiveInfinity(NormalMid));
  CheckFalse(Single.IsPositiveInfinity(NormalMax));
  CheckFalse(Single.IsPositiveInfinity(NNormalMin));
  CheckFalse(Single.IsPositiveInfinity(NNormalMid));
  CheckFalse(Single.IsPositiveInfinity(NNormalMax));
  CheckTrue(Single.IsPositiveInfinity(Inf));
  CheckFalse(Single.IsPositiveInfinity(NInf));
  CheckFalse(Single.IsPositiveInfinity(NaN1));
  CheckFalse(Single.IsPositiveInfinity(NaN2));
  CheckFalse(Single.IsPositiveInfinity(NaN3));
  CheckFalse(Single.IsPositiveInfinity(NaN4));
  CheckFalse(Single.IsPositiveInfinity(NaN5));
  CheckFalse(Single.IsPositiveInfinity(NaN6));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
{$IFDEF FPC}{$PUSH}{$WARNINGS OFF}{$ENDIF}
procedure TestTSingleHelper.BytesRangeOverflow;
var
  Value: Single;
begin
  Value.Bytes[SizeOf(Single)] := 1;
end;
{$IFDEF FPC}{$POP}{$ENDIF}
{$ENDIF RUN_TESTS}

procedure TestTSingleHelper.TestBytes;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($c0, $49, $0f, $db); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($db, Value.Bytes[0]);
  CheckEquals($0f, Value.Bytes[1]);
  CheckEquals($49, Value.Bytes[2]);
  CheckEquals($c0, Value.Bytes[3]);
  {$ELSE}
  CheckEquals($c0, Value.Bytes[0]);
  CheckEquals($49, Value.Bytes[1]);
  CheckEquals($0f, Value.Bytes[2]);
  CheckEquals($db, Value.Bytes[3]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Bytes[0] := $54;
  Value.Bytes[1] := $f8;
  Value.Bytes[2] := $2d;
  Value.Bytes[3] := $40;
  {$ELSE}
  Value.Bytes[0] := $40;
  Value.Bytes[1] := $2d;
  Value.Bytes[2] := $f8;
  Value.Bytes[3] := $54;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($2d, ValueArray[1]);
  CheckEquals($f8, ValueArray[2]);
  CheckEquals($54, ValueArray[3]);

  CheckException(BytesRangeOverflow, ERangeError);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
{$IFDEF FPC}{$PUSH}{$WARNINGS OFF}{$ENDIF}
procedure TestTSingleHelper.WordsRangeOverflow;
var
  Value: Single;
begin
  Value.Words[SizeOf(Single) div SizeOf(Word)] := 1;
end;
{$IFDEF FPC}{$POP}{$ENDIF}
{$ENDIF RUN_TESTS}

procedure TestTSingleHelper.TestWords;
{$IFDEF RUN_TESTS}
var
  Value: Single;
  ValueArray: TSingleArray absolute Value;
begin
  ValueArray := MakeSingle($c0, $49, $0f, $db); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($0fdb, Value.Words[0]);
  CheckEquals($c049, Value.Words[1]);
  {$ELSE}
  CheckEquals($c049, Value.Words[0]);
  CheckEquals($0fdb, Value.Words[1]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Words[0] := $f854;
  Value.Words[1] := $402d;
  {$ELSE}
  Value.Words[0] := $402d;
  Value.Words[1] := $f854;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($2d, ValueArray[1]);
  CheckEquals($f8, ValueArray[2]);
  CheckEquals($54, ValueArray[3]);

  CheckException(WordsRangeOverflow, ERangeError);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
procedure TestTSingleHelper.BadParse1;
begin
  Single.Parse(FBadString);
end;
{$ENDIF RUN_TESTS}

procedure TestTSingleHelper.TestParse1;
{$IFDEF RUN_TESTS}
begin
  CheckEquals('0', UpperCase(Single.Parse('0').ToString(TFormatSettings.Invariant)));
  CheckEquals('10', UpperCase(Single.Parse('10').ToString(TFormatSettings.Invariant)));

  CheckEquals('2.800000E+32', UpperCase(Single.Parse('2' + FormatSettings.DecimalSeparator + '8e32').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.800000E+32', UpperCase(Single.Parse('2' + FormatSettings.DecimalSeparator + '8E32').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.800000E-32', UpperCase(Single.Parse('-2' + FormatSettings.DecimalSeparator + '8e-32').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.800000E-32', UpperCase(Single.Parse('-2' + FormatSettings.DecimalSeparator + '8E-32').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-1.75', UpperCase(Single.Parse('-1' + FormatSettings.DecimalSeparator + '75').ToString(TFormatSettings.Invariant)));
  CheckEquals('1.75', UpperCase(Single.Parse('1' + FormatSettings.DecimalSeparator + '75').ToString(TFormatSettings.Invariant)));

  CheckEquals('0', UpperCase(Single.Parse(FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Single.Parse('-' + FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Single.Parse('+' + FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));

  FBadString := '';
  CheckException(BadParse1, EConvertError);

  FBadString := '-';
  CheckException(BadParse1, EConvertError);

  FBadString := '+';
  CheckException(BadParse1, EConvertError);

  FBadString := '1 0000 000.0';
  CheckException(BadParse1, EConvertError);

  FBadString := '#';
  CheckException(BadParse1, EConvertError);

  FBadString := 'f';
  CheckException(BadParse1, EConvertError);

  FBadString := '10#';
  CheckException(BadParse1, EConvertError);

  FBadString := '10f';
  CheckException(BadParse1, EConvertError);

  FBadString := '1,2.3';
  CheckException(BadParse1, EConvertError);

  FBadString := '1.2,3';
  CheckException(BadParse1, EConvertError);

  FBadString := '1' + FormatSettings.DecimalSeparator + '2' + FormatSettings.DecimalSeparator + '3';
  CheckException(BadParse1, EConvertError);

  FBadString := 'INF';
  CheckException(BadParse1, EConvertError);

  FBadString := '+INF';
  CheckException(BadParse1, EConvertError);

  FBadString := '-INF';
  CheckException(BadParse1, EConvertError);

  FBadString := 'NAN';
  CheckException(BadParse1, EConvertError);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
procedure TestTSingleHelper.BadParse2;
begin
  Single.Parse(FBadString, FBadFormat);
end;
{$ENDIF RUN_TESTS}

procedure TestTSingleHelper.TestParse2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := ' ';
  LocalFormat.DecimalSeparator := ';';

  CheckEquals('0', UpperCase(Single.Parse('0', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('10', UpperCase(Single.Parse('10', LocalFormat).ToString(TFormatSettings.Invariant)));

  CheckEquals('2.800000E+32', UpperCase(Single.Parse('2;8e32', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.800000E+32', UpperCase(Single.Parse('2;8E32', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.800000E-32', UpperCase(Single.Parse('-2;8e-32', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.800000E-32', UpperCase(Single.Parse('-2;8E-32', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-1.75', UpperCase(Single.Parse('-1;75', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('1.75', UpperCase(Single.Parse('+1;75', LocalFormat).ToString(TFormatSettings.Invariant)));

  CheckEquals('0', UpperCase(Single.Parse(';', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Single.Parse('-;', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Single.Parse('+;', LocalFormat).ToString(TFormatSettings.Invariant)));

  FBadString := '';
  FBadFormat := LocalFormat;
  CheckException(BadParse2, EConvertError);

  FBadString := '-';
  CheckException(BadParse2, EConvertError);

  FBadString := '+';
  CheckException(BadParse2, EConvertError);

  FBadString := '1 0000 000;0';
  CheckException(BadParse2, EConvertError);

  FBadString := '#';
  CheckException(BadParse2, EConvertError);

  FBadString := 'f';
  CheckException(BadParse2, EConvertError);

  FBadString := '10#';
  CheckException(BadParse2, EConvertError);

  FBadString := '10f';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2.3';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2.3';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2;3';
  CheckException(BadParse2, EConvertError);

  FBadString := 'INF';
  CheckException(BadParse2, EConvertError);

  FBadString := '+INF';
  CheckException(BadParse2, EConvertError);

  FBadString := '-INF';
  CheckException(BadParse2, EConvertError);

  FBadString := 'NAN';
  CheckException(BadParse2, EConvertError);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestTryParse1;
{$IFDEF RUN_TESTS}
var
  Value: Single;
begin
  CheckTrue(Single.TryParse('0', Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('10', Value));
  CheckEquals('10', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('2' + FormatSettings.DecimalSeparator + '8e32', Value));
  CheckEquals('2.800000E+32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Single.TryParse('2' + FormatSettings.DecimalSeparator + '8E32', Value));
  CheckEquals('2.800000E+32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-2' + FormatSettings.DecimalSeparator + '8e-32', Value));
  CheckEquals('-2.800000E-32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Single.TryParse('-2' + FormatSettings.DecimalSeparator + '8E-32', Value));
  CheckEquals('-2.800000E-32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-1' + FormatSettings.DecimalSeparator + '75', Value));
  CheckEquals('-1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('+1' + FormatSettings.DecimalSeparator + '75', Value));
  CheckEquals('1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse(FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-' + FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('+' + FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckFalse(Single.TryParse('', Value));
  CheckFalse(Single.TryParse('-', Value));
  CheckFalse(Single.TryParse('+', Value));
  CheckFalse(Single.TryParse('1 0000 000.0', Value));
  CheckFalse(Single.TryParse('#', Value));
  CheckFalse(Single.TryParse('f', Value));
  CheckFalse(Single.TryParse('10#', Value));
  CheckFalse(Single.TryParse('10f', Value));
  CheckFalse(Single.TryParse('1;2.3', Value));
  CheckFalse(Single.TryParse('1;2,3', Value));
  CheckFalse(Single.TryParse('1;2;3', Value));
  CheckFalse(Single.TryParse('INF', Value));
  CheckFalse(Single.TryParse('+INF', Value));
  CheckFalse(Single.TryParse('-INF', Value));
  CheckFalse(Single.TryParse('NAN', Value));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestTryParse2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Single;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := ' ';
  LocalFormat.DecimalSeparator := ';';

  CheckTrue(Single.TryParse('0', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('10', Value, LocalFormat));
  CheckEquals('10', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('2;8e32', Value, LocalFormat));
  CheckEquals('2.800000E+32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Single.TryParse('2;8E32', Value, LocalFormat));
  CheckEquals('2.800000E+32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-2;8e-32', Value, LocalFormat));
  CheckEquals('-2.800000E-32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Single.TryParse('-2;8E-32', Value, LocalFormat));
  CheckEquals('-2.800000E-32', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-1;75', Value, LocalFormat));
  CheckEquals('-1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('+1;75', Value, LocalFormat));
  CheckEquals('1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse(';', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('-;', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Single.TryParse('+;', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckFalse(Single.TryParse('', Value, LocalFormat));
  CheckFalse(Single.TryParse('-', Value, LocalFormat));
  CheckFalse(Single.TryParse('+', Value, LocalFormat));
  CheckFalse(Single.TryParse('1 0000 000;0', Value, LocalFormat));
  CheckFalse(Single.TryParse('#', Value, LocalFormat));
  CheckFalse(Single.TryParse('f', Value, LocalFormat));
  CheckFalse(Single.TryParse('10#', Value, LocalFormat));
  CheckFalse(Single.TryParse('10f', Value, LocalFormat));
  CheckFalse(Single.TryParse('1,2.3', Value, LocalFormat));
  CheckFalse(Single.TryParse('1.2,3', Value, LocalFormat));
  CheckFalse(Single.TryParse('1' + FormatSettings.DecimalSeparator + '2' + FormatSettings.DecimalSeparator + '3', Value, LocalFormat));
  CheckFalse(Single.TryParse('INF', Value, LocalFormat));
  CheckFalse(Single.TryParse('+INF', Value, LocalFormat));
  CheckFalse(Single.TryParse('-INF', Value, LocalFormat));
  CheckFalse(Single.TryParse('NAN', Value, LocalFormat));
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTSingleHelper.TestSize;
{$IFDEF RUN_TESTS}
begin
  CheckEquals(SizeOf(Single), Single.Size);
{$ELSE}
begin
  Ignore('Single type is not supported.');
{$ENDIF RUN_TESTS}
end;

initialization
  RegisterTest('System.SysUtils', TestTSingleHelper.Suite);

end.

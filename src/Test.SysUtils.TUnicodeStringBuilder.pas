{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit Test.SysUtils.TUnicodeStringBuilder;

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

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE2_PLUS)}
type
  TestUnicodeStringBuilder = class(TTestCase)
  strict private
    FStringBuilder: TStringBuilder;
  private
    procedure AppendRange1;
    procedure AppendRange2;
    procedure AppendRange3;
    procedure AppendRange4;
    procedure AppendRange5;
    procedure CreateRange;
    procedure InsertRange1;
    procedure InsertRange2;
    procedure RemoveRange1;
    procedure RemoveRange2;
    procedure ReplaceRange1;
    procedure ReplaceRange2;
    procedure ReplaceEmpty;
    procedure LengthRange;
    procedure CapacityRange1;
    procedure CapacityRange2;
    procedure CharsRange1;
    procedure CharsRange2;
    procedure CharsRange3;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAppend;
    procedure TestAppendFormat;
    procedure TestAppendLine;
    procedure TestClear;
    procedure TestCreate;
    procedure TestEquals;
    procedure TestInsert;
    procedure TestRemove;
    procedure TestReplace;
    procedure TestToString;
    procedure TestLenght;
    procedure TestCapacity;
    procedure TestChars;
  end;
{$IFEND}

implementation

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE2_PLUS)}
const
  TEST_STR: UnicodeString = 'This is a string.';
  REP_STR: UnicodeString = '1:,2:,3:,4:,5';

{ TestUnicodeStringBuilder }

procedure TestUnicodeStringBuilder.SetUp;
begin
  FStringBuilder := TStringBuilder.Create;
end;

procedure TestUnicodeStringBuilder.TearDown;
begin
  FreeAndNil(FStringBuilder);
end;

procedure TestUnicodeStringBuilder.AppendRange1;
var
  Chars: TCharArray;
begin
  SetLength(Chars, 2);
  Chars[0] := WideChar('A');
  Chars[1] := WideChar('B');

  FStringBuilder.Append(Chars, -1, 2);
end;

procedure TestUnicodeStringBuilder.AppendRange2;
var
  Chars: TCharArray;
begin
  SetLength(Chars, 2);
  Chars[0] := WideChar('A');
  Chars[1] := WideChar('B');

  FStringBuilder.Append(Chars, 1, 2);
end;

procedure TestUnicodeStringBuilder.AppendRange3;
begin
  FStringBuilder.Append('', 0, 1);
end;

procedure TestUnicodeStringBuilder.AppendRange4;
begin
  FStringBuilder.Append('test', -1, 1);
end;

procedure TestUnicodeStringBuilder.AppendRange5;
begin
  FStringBuilder.Append('test', 3, 2);
end;

type
  TCustomObject = class(TObject)
  public
    function ToString: UnicodeString; override;
  end;

function TCustomObject.ToString: UnicodeString;
begin
  Result := TEST_STR;
end;

procedure TestUnicodeStringBuilder.TestAppend;
var
  Chars: TCharArray;
  SVar: Single;
  DVar: Double;
  Obj: TObject;
begin
  FStringBuilder.Append(True);
  FStringBuilder.Append(False);
  CheckEquals('TrueFalse', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Byte(250));
  CheckEquals('250', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Smallint(-120));
  CheckEquals('-120', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Shortint(-128));
  CheckEquals('-128', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Word(65530));
  CheckEquals('65530', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Integer(-2000000000));
  CheckEquals('-2000000000', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(Cardinal(4000000000));
  CheckEquals('4000000000', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(-4000000000);
  CheckEquals('-4000000000', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(18446744073709551615);
  CheckEquals('18446744073709551615', FStringBuilder.ToString);

  FStringBuilder.Clear;
  SVar := 1.5;
  FStringBuilder.Append(SVar);
  CheckEquals('1' + {$IFDEF HAS_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator + '5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  DVar := 1.5;
  FStringBuilder.Append(DVar);
  CheckEquals('1' + {$IFDEF HAS_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator + '5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(WideChar('A'));
  CheckEquals('A', FStringBuilder.ToString);

  FStringBuilder.Append(WideChar('不'), 3);
  {$HINTS OFF}
  CheckEquals('A不不不', FStringBuilder.ToString);
  {$HINTS ON}

  { Fail due Delphi bug RSP-17143
    TODO: Add new test for #0. All code beyound #0 must not be added. }
  SetLength(Chars, 0);
  FStringBuilder.Clear;
  FStringBuilder.Append(Chars);
  CheckEquals('', FStringBuilder.ToString);

  SetLength(Chars, 3);
  Chars[0] := WideChar('A');
  Chars[1] := WideChar('B');
  Chars[2] := WideChar('C');
  FStringBuilder.Clear;
  FStringBuilder.Append(Chars);
  CheckEquals('ABC', FStringBuilder.ToString);

  SetLength(Chars, 5);
  Chars[3] := WideChar('D');
  Chars[4] := WideChar('E');
  FStringBuilder.Clear;
  FStringBuilder.Append(Chars, 1, 3);
  CheckEquals('BCD', FStringBuilder.ToString);

  CheckException(AppendRange1, ERangeError);
  CheckException(AppendRange2, ERangeError);

  FStringBuilder.Clear;
  FStringBuilder.Append('');
  CheckEquals('', FStringBuilder.ToString);

  FStringBuilder.Append(TEST_STR);
  CheckEquals(TEST_STR, FStringBuilder.ToString);

  FStringBuilder.Append(TEST_STR);
  CheckEquals(TEST_STR + TEST_STR, FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(TEST_STR, 5, 2);
  CheckEquals('is', FStringBuilder.ToString);

  CheckException(AppendRange3, ERangeError);
  CheckException(AppendRange4, ERangeError);
  CheckException(AppendRange5, ERangeError);

  FStringBuilder.Clear;
  Obj := TObject.Create;
  try
    FStringBuilder.Append(Obj);
  finally
    FreeAndNil(Obj);
  end;
  CheckEquals('TObject', FStringBuilder.ToString);

  FStringBuilder.Clear;
  Obj := TCustomObject.Create;
  try
    FStringBuilder.Append(Obj);
  finally
    FreeAndNil(Obj);
  end;
  CheckEquals(TEST_STR, FStringBuilder.ToString);
end;

procedure TestUnicodeStringBuilder.TestAppendFormat;
begin
  FStringBuilder.AppendFormat('%s + 2 = %d', ['3', 5]);
  CheckEquals('3 + 2 = 5', FStringBuilder.ToString);
end;

procedure TestUnicodeStringBuilder.TestAppendLine;
begin
  FStringBuilder.AppendLine;
  CheckEquals(sLineBreak, FStringBuilder.ToString);

  FStringBuilder.AppendLine('test');
  CheckEquals(sLineBreak + 'test' + sLineBreak, FStringBuilder.ToString);
end;

procedure TestUnicodeStringBuilder.TestClear;
begin
  FStringBuilder.Append(TEST_STR);
  CheckEquals(TEST_STR, FStringBuilder.ToString);
  CheckTrue(FStringBuilder.Length > 0);

  FStringBuilder.Clear;

  CheckEquals('', FStringBuilder.ToString);
  CheckEquals(0, FStringBuilder.Length);
end;

procedure TestUnicodeStringBuilder.CreateRange;
var
  Mb: TStringBuilder;
begin
  Mb := TStringBuilder.Create(10, 10);
  try
    Mb.Capacity := Mb.Capacity + 1;
  finally
    FreeAndNil(Mb);
  end;
end;

procedure TestUnicodeStringBuilder.TestCreate;
var
  Mb: TStringBuilder;
  TestCapacity: Integer;
begin
  Mb := nil;

  Mb := TStringBuilder.Create;
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
    CheckEquals(MaxInt, Mb.MaxCapacity);
    CheckTrue(Mb.Capacity > 0);

    TestCapacity := Mb.Capacity + 1;
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create(TestCapacity);
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
    CheckEquals(MaxInt, Mb.MaxCapacity);
    CheckEquals(TestCapacity, Mb.Capacity);
  finally
    FreeAndNil(Mb);
  end;

  { RSP-16826 }
  (* Mb := TStringBuilder.Create(TestCapacity, TestCapacity - 1);
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
    CheckEquals(TestCapacity - 1, Mb.MaxCapacity);
    CheckEquals(TestCapacity - 1, Mb.Capacity);
  finally
    FreeAndNil(Mb);
  end; *)

  CheckException(CreateRange, ERangeError);

  Mb := TStringBuilder.Create('12345', 4);
  try
    CheckEquals('12345', Mb.ToString);
    CheckEquals(5, Mb.Length);
    CheckEquals(MaxInt, Mb.MaxCapacity);
    CheckTrue(Mb.Capacity >= Mb.Length);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('12345', 1, 3, 3);
  try
    CheckEquals('234', Mb.ToString);
    CheckEquals(3, Mb.Length);
    CheckEquals(MaxInt, Mb.MaxCapacity);
    CheckEquals(3, Mb.Capacity);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('');
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
    CheckEquals(MaxInt, Mb.MaxCapacity);
    CheckTrue(Mb.Capacity >= 0);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('1234', -2, 4, 10);
  try
    CheckEquals('1234', Mb.ToString);
    CheckEquals(4, Mb.Length);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('1234', 0, 5, 10);
  try
    CheckEquals('1234', Mb.ToString);
    CheckEquals(4, Mb.Length);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('1234', 4, 4, 10);
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create('1234', 0, -4, 10);
  try
    CheckEquals('', Mb.ToString);
    CheckEquals(0, Mb.Length);
  finally
    FreeAndNil(Mb);
  end;
end;

procedure TestUnicodeStringBuilder.TestEquals;
var
  Mb: TStringBuilder;
begin
  FStringBuilder.Capacity := 20;
  FStringBuilder.Append(TEST_STR);

  Mb := TStringBuilder.Create(20, 20);
  try
    Mb.Append(TEST_STR);
    CheckFalse(FStringBuilder.Equals(Mb));
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create(22, FStringBuilder.MaxCapacity);
  try
    Mb.Append(TEST_STR);
    CheckTrue(FStringBuilder.Equals(Mb));
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create(FStringBuilder.Capacity, 22);
  try
    Mb.Append(TEST_STR);
    CheckFalse(FStringBuilder.Equals(Mb));
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create(FStringBuilder.Capacity,
    FStringBuilder.MaxCapacity);
  try
    Mb.Append(TEST_STR);
    CheckTrue(FStringBuilder.Equals(Mb));
  finally
    FreeAndNil(Mb);
  end;

  Mb := TStringBuilder.Create(FStringBuilder.Capacity,
    FStringBuilder.MaxCapacity);
  try
    Mb.Append('This is a string!');
    CheckFalse(FStringBuilder.Equals(Mb));
  finally
    FreeAndNil(Mb);
  end;
end;

procedure TestUnicodeStringBuilder.InsertRange1;
begin
  FStringBuilder.Insert(-1, '!');
end;

procedure TestUnicodeStringBuilder.InsertRange2;
begin
  FStringBuilder.Insert(3, '!');
end;

procedure TestUnicodeStringBuilder.TestInsert;
var
  Chars: TCharArray;
  SVar: Single;
  DVar: Double;
  CVar: Currency;
  Obj: TObject;

  procedure Reset;
  begin
    FStringBuilder.Clear;
    FStringBuilder.Append('ab');
  end;
begin
  Reset;
  FStringBuilder.Insert(1, True);
  CheckEquals('aTrueb', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Byte(250));
  CheckEquals('a250b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Smallint(-120));
  CheckEquals('a-120b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Shortint(-128));
  CheckEquals('a-128b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Word(65530));
  CheckEquals('a65530b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Integer(-2000000000));
  CheckEquals('a-2000000000b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, Cardinal(4000000000));
  CheckEquals('a4000000000b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, -4000000000);
  CheckEquals('a-4000000000b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, 18446744073709551615);
  CheckEquals('a18446744073709551615b', FStringBuilder.ToString);

  Reset;
  SVar := 1.5;
  FStringBuilder.Insert(1, SVar);
  CheckEquals('a1' + {$IFDEF HAS_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator + '5b', FStringBuilder.ToString);

  Reset;
  DVar := 1.5;
  FStringBuilder.Insert(1, DVar);
  CheckEquals('a1' + {$IFDEF HAS_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator + '5b', FStringBuilder.ToString);

  Reset;
  CVar := 1.50;
  FStringBuilder.Insert(1, CVar);
  CheckEquals('a' + SysUtils.CurrToStr(CVar) + 'b', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, WideChar('A'));
  CheckEquals('aAb', FStringBuilder.ToString);

  FStringBuilder.Insert(2, WideChar('B'), 3);
  CheckEquals('aABBBb', FStringBuilder.ToString);

  SetLength(Chars, 0);
  Reset;
  FStringBuilder.Insert(1, Chars);
  CheckEquals('ab', FStringBuilder.ToString);

  SetLength(Chars, 3);
  Chars[0] := WideChar('A');
  Chars[1] := WideChar('B');
  Chars[2] := WideChar('C');
  Reset;
  FStringBuilder.Insert(1, Chars);
  CheckEquals('aABCb', FStringBuilder.ToString);

  SetLength(Chars, 5);
  Chars[3] := WideChar('D');
  Chars[4] := WideChar('E');
  Reset;
  FStringBuilder.Insert(1, Chars, 1, 3);
  CheckEquals('aBCDb', FStringBuilder.ToString);

  Reset;
  FStringBuilder.Insert(1, '');
  CheckEquals('ab', FStringBuilder.ToString);

  FStringBuilder.Insert(1, TEST_STR);
  CheckEquals('a' + TEST_STR + 'b', FStringBuilder.ToString);

  FStringBuilder.Insert(1, TEST_STR);
  CheckEquals('a' + TEST_STR + TEST_STR + 'b', FStringBuilder.ToString);

  Reset;
  CheckException(InsertRange1, ERangeError);

  Reset;
  FStringBuilder.Insert(2, '!');
  CheckEquals('ab!', FStringBuilder.ToString);

  Reset;
  CheckException(InsertRange2, ERangeError);

  Reset;
  Obj := TObject.Create;
  try
    FStringBuilder.Insert(1, Obj);
  finally
    FreeAndNil(Obj);
  end;
  CheckEquals('aTObjectb', FStringBuilder.ToString);

  Reset;
  Obj := TCustomObject.Create;
  try
    FStringBuilder.Insert(1, Obj);
  finally
    FreeAndNil(Obj);
  end;
  CheckEquals('a' + TEST_STR + 'b', FStringBuilder.ToString);
end;

procedure TestUnicodeStringBuilder.RemoveRange1;
begin
  FStringBuilder.Clear;
  FStringBuilder.Append(TEST_STR);
  FStringBuilder.Remove(-1, 1);
end;

procedure TestUnicodeStringBuilder.RemoveRange2;
begin
  FStringBuilder.Clear;
  FStringBuilder.Append(TEST_STR);
  FStringBuilder.Remove(16, 2);
end;

procedure TestUnicodeStringBuilder.TestRemove;
begin
  FStringBuilder.Append(TEST_STR);

  FStringBuilder.Remove(8, 2);
  CheckEquals('This is string.', FStringBuilder.ToString);

  FStringBuilder.Remove(0, 15);
  CheckEquals('', FStringBuilder.ToString);

  CheckException(RemoveRange1, ERangeError);
  CheckException(RemoveRange2, ERangeError);
end;

procedure TestUnicodeStringBuilder.ReplaceRange1;
begin
  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(WideChar(','), WideChar('.'), -1, 2);
end;

procedure TestUnicodeStringBuilder.ReplaceRange2;
begin
  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(WideChar(','), WideChar('.'), 11, 3);
end;

procedure TestUnicodeStringBuilder.ReplaceEmpty;
begin
  FStringBuilder.Clear;
  FStringBuilder.Replace(WideChar(','), WideChar('.'), 0, 1);
end;

procedure TestUnicodeStringBuilder.TestReplace;
begin
  FStringBuilder.Replace(WideChar(','), WideChar('.'), 0, 0);
  CheckEquals('', FStringBuilder.ToString);

  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(WideChar(','), WideChar('.'));
  CheckEquals('1:.2:.3:.4:.5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(':,', '@');
  CheckEquals('1@2@3@4@5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(':,', '@#@');
  CheckEquals('1@#@2@#@3@#@4@#@5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Replace(':,', '@#@');
  CheckEquals('', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(WideChar(','), WideChar('.'), 2, 6);
  CheckEquals('1:.2:.3:,4:,5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(WideChar(','), WideChar('.'), 2, 7);
  CheckEquals('1:.2:.3:.4:,5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR);
  FStringBuilder.Replace(':,', '@', 2, 7);
  CheckEquals('1:,2@3@4:,5', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(REP_STR + ':,');
  FStringBuilder.Replace(':,', '@@');
  CheckEquals('1@@2@@3@@4@@5@@', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(':,' + REP_STR + ':,');
  FStringBuilder.Replace(':,', '@');
  CheckEquals('@1@2@3@4@5@', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(':,' + REP_STR + ':,');
  FStringBuilder.Replace(':,', '@@@');
  CheckEquals('@@@1@@@2@@@3@@@4@@@5@@@', FStringBuilder.ToString);

  FStringBuilder.Clear;
  FStringBuilder.Append(':,' + REP_STR + ':,');
  FStringBuilder.Replace(':,', ':,');
  CheckEquals(':,' + REP_STR + ':,', FStringBuilder.ToString);

  CheckException(ReplaceRange1, ERangeError);
  CheckException(ReplaceRange2, ERangeError);
  CheckException(ReplaceEmpty, ERangeError);
end;

procedure TestUnicodeStringBuilder.TestToString;
begin
  CheckEquals('', FStringBuilder.ToString);

  FStringBuilder.Append(TEST_STR);
  CheckEquals(TEST_STR, FStringBuilder.ToString);
end;

procedure TestUnicodeStringBuilder.LengthRange;
begin
  FStringBuilder.Length := -1;
end;

procedure TestUnicodeStringBuilder.TestLenght;
var
  NewLen: Integer;
begin
  FStringBuilder.Append(TEST_STR);
  CheckEquals(17, FStringBuilder.Length);

  FStringBuilder.Length := FStringBuilder.Length - 1;
  CheckEquals(16, FStringBuilder.Length);
  CheckEquals('This is a string', FStringBuilder.ToString);

  FStringBuilder.Length := FStringBuilder.Length + 1;
  CheckEquals(17, FStringBuilder.Length);
  CheckEquals(TEST_STR, FStringBuilder.ToString);

  NewLen := FStringBuilder.Capacity + 1;
  FStringBuilder.Length := NewLen;
  CheckEquals(NewLen, FStringBuilder.Length);
  CheckTrue(FStringBuilder.Capacity >= NewLen);

  CheckException(LengthRange, ERangeError)
end;

procedure TestUnicodeStringBuilder.CapacityRange1;
begin
  FStringBuilder.Capacity := -1;
end;

procedure TestUnicodeStringBuilder.CapacityRange2;
begin
  FStringBuilder.Capacity := 16;
end;

procedure TestUnicodeStringBuilder.TestCapacity;
begin
  CheckException(CapacityRange1, ERangeError);

  FStringBuilder.Append(TEST_STR);
  CheckTrue(FStringBuilder.Capacity >= 17);

  CheckException(CapacityRange2, ERangeError);
end;

procedure TestUnicodeStringBuilder.CharsRange1;
begin
  CheckEquals('.', FStringBuilder[-1]);
end;

procedure TestUnicodeStringBuilder.CharsRange2;
begin
  CheckEquals('.', FStringBuilder[FStringBuilder.Length]);
end;

procedure TestUnicodeStringBuilder.CharsRange3;
begin
  CheckEquals('.', FStringBuilder[FStringBuilder.Capacity]);
end;

procedure TestUnicodeStringBuilder.TestChars;
begin
  FStringBuilder.Append(TEST_STR);

  CheckEquals('T', FStringBuilder.Chars[0]);
  CheckEquals('.', FStringBuilder[16]);

  CheckException(CharsRange1, ERangeError);
  CheckException(CharsRange2, ERangeError);
  CheckException(CharsRange3, ERangeError);
end;

initialization
  RegisterTest('System.SysUtils', TestUnicodeStringBuilder.Suite);
{$IFEND}

end.

unit IsAnsiStringModule;

interface

Uses System.SysUtils, System.UITypes, System.Classes, System.strutils;

{$IFNDEF NextGen}
// must be an error
Type
  MyError = class;
{$ENDIF}

Const
  MaxLenPAnsiChar: longint = 2000000;
  // http://docwiki.embarcadero.com/RADStudio/Seattle/en/Operator_Overloading_%28Delphi%29

Type
  StrCodeInfoRec = record 
    CodePage: Word; // 2
    ElementLength:
    Word; // 2
    RefCount: Integer; // 4
    Length: Integer; // 4
  end;

  PStrCodeInfoRec = ^StrCodeInfoRec;

  TISBytesArray = Array of Byte;

  AnsiCharSet = Set of Byte;

  AnsiChar = record
  private
    FData: Byte;
    FPtr: Pointer;
    function GetLength: integer; inline;
  Public
    class operator Add(a, b: AnsiChar): String;
    class operator Implicit(a: Byte): AnsiChar;
    class operator Implicit(a: AnsiChar): Char;
    class operator Implicit(a: AnsiChar): Byte;
    class operator Implicit(a: Char): AnsiChar;
    class operator Implicit(a: AnsiChar): Pointer;
    class operator Equal(a, b: AnsiChar): Boolean;
    class operator Equal(a: Byte; b: AnsiChar): Boolean;
    class operator Equal(a: AnsiChar; b: Byte): Boolean;
    class operator Equal(a: Char; b: AnsiChar): Boolean;
    class operator Equal(a: AnsiChar; b: Char): Boolean;
    class operator NotEqual(a, b: AnsiChar): Boolean;
    Property Length: integer Read GetLength;
  end;

  AnsiString = Record
  private
    FData: TISBytesArray;
    function GetData(a: integer): AnsiChar;
    procedure SetData(a: integer; const Value: AnsiChar);
    Procedure SetStrLength(aLen: integer);
  Public
    class operator Add(a, b: AnsiString): AnsiString;
    class operator Add(a: AnsiString; b: Byte): AnsiString;
    class operator Add(a: AnsiString; b: AnsiChar): AnsiString;
    class operator Add(a: String; b: AnsiString): AnsiString;
    class operator Add(a: AnsiString; b: String): AnsiString;
    class operator Subtract(a, b: AnsiString): AnsiString;
    class operator Implicit(a: String): AnsiString;
    class operator Implicit(a: Char): AnsiString;
    class operator Implicit(a: AnsiChar): AnsiString;
    class operator Implicit(a: Byte): AnsiString;
    class operator Implicit(a: AnsiString): String;
    class operator Implicit(a: AnsiString): Pointer;
    class operator Equal(a, b: AnsiString): Boolean;
    class operator NotEqual(a, b: AnsiString): Boolean;
    class operator GreaterThan(a, b: AnsiString): Boolean;
    class operator GreaterThanOrEqual(a, b: AnsiString): Boolean;
    class operator LessThan(a, b: AnsiString): Boolean;
    class operator LessThanOrEqual(a, b: AnsiString): Boolean;
    Procedure Delete(Index: integer; Count: integer);
    Procedure UnicodeAsAnsi(UString: String);
    // For std AnsiChars every second byte is a null
    // Bypasses Conversion Routines
    Function RecoverFullUnicode: String;
    // Reinstates String following UnicodeAsAnsi
    // Bypasses Conversion Routines
    Procedure CompressedUnicode(const AUCode: UnicodeString);
    // Contains Ascii version of Unicode but '' if 2 byte characters found
    // Returns '' if Chars above 255
    // Function DeCompressUnicode: UnicodeString;
    Function UnCompressedToUnicode: String;
    Function ReadBytesFrmStrm(AStm: TStream; ABytes: integer): Int64;
    Procedure ReadOneLineFrmStrm(AStm: TStream);
    function WriteBytesToStrm(AStm: TStream; ABytes: integer = 0;
      AOffset: integer = 0): integer;
    { Offest zero ref }
    function WriteLineToStream(AStm: TStream): integer;
    Procedure CopyBytesFromMemory(ABuffer: Pointer; ACount: integer);
    Function CopyBytesToMemory(ABuffer: Pointer; ABytes: integer = -1;
      AOffset: integer = 0): integer;
    { Offest zero ref }
    function UpperCase: AnsiString; // Makes a copy
    function LowerCase: AnsiString;
    Procedure UniqueString;
    Function AsStringValues: String;
    // 123[0D](^M)5647
    Function GetLength: integer;
    Function IsBlank: Boolean;
    // #2+#5+#13+' ' is blank
    Function High: integer;
    Function Low: integer;
    Function AnsiLastChar: Pointer;
    // Returns a pointer to the last full character in the AnsiStringBase.
    Function OffsetPointer(AByteOffset: integer): Pointer;
    // Returns a pointer to the offset char in the AnsiStringBase zero base.
    Property Length: integer Read GetLength write SetStrLength;
    Property ASString: String read UnCompressedToUnicode
      write CompressedUnicode; // Useful for seeing value in Debug
    Property Data[a: integer]: AnsiChar Read GetData Write SetData; Default;
  end;

  RawByteString = AnsiString;
  UTF8String = AnsiString;

  PAnsiChar = record
  private
    FTempAnsiString: AnsiString;
    FData: Pointer;
    function GetData(a: integer): AnsiChar;
    procedure SetData(a: integer; const Value: AnsiChar);
    function GetTempString: AnsiString;
    procedure SetTempString(const Value: AnsiString);
  Public
    class operator Add(a, b: PAnsiChar): PAnsiChar;
    class operator Add(a: PAnsiChar; b: integer): PAnsiChar;
    class operator Add(a: integer; b: PAnsiChar): PAnsiChar;
    class operator Subtract(a, b: PAnsiChar): Int64;
    class operator Subtract(a: PAnsiChar; b: Pointer): Int64;
    class operator Subtract(a: Pointer; b: PAnsiChar): Int64;
    class operator Subtract(a: PAnsiChar; b: integer): PAnsiChar;
    class operator Subtract(a: Int64; b: PAnsiChar): Int64;
    class operator Implicit(a: Pointer): PAnsiChar;
    class operator Implicit(a: PAnsiChar): AnsiString;
    class operator Implicit(a: PAnsiChar): String;
    class operator Implicit(a: AnsiString): PAnsiChar;
    class operator Explicit(a: PAnsiChar): Pointer;
    class operator Explicit(a: Pointer): PAnsiChar;
    class operator Explicit(a: PAnsiChar): Int64;
    class operator Explicit(a: String): PAnsiChar;
    // class operator Explicit(a: AnsiString): Boolean;
    class operator Equal(a, b: PAnsiChar): Boolean;
    class operator Equal(a: Pointer; b: PAnsiChar): Boolean;
    class operator Equal(a: PAnsiChar; b: Pointer): Boolean;
    class operator NotEqual(a, b: PAnsiChar): Boolean;
    class operator NotEqual(a: Pointer; b: PAnsiChar): Boolean;
    class operator NotEqual(a: PAnsiChar; b: Pointer): Boolean;
    class operator GreaterThan(a: PAnsiChar; b: PAnsiChar): Boolean;
    class operator GreaterThan(a: Pointer; b: PAnsiChar): Boolean;
    class operator GreaterThan(a: PAnsiChar; b: Pointer): Boolean;
    // class operator GreaterThanOrEqual(a: TstPAnsiChar; b: TstPAnsiChar): Boolean;
    class operator LessThan(a: PAnsiChar; b: PAnsiChar): Boolean;
    class operator LessThan(a: Pointer; b: PAnsiChar): Boolean;
    class operator LessThan(a: PAnsiChar; b: Pointer): Boolean;
    // class operator LessThanOrEqual(a: TstPAnsiChar; b: TstPAnsiChar): Boolean;
    class operator Inc(a: PAnsiChar): PAnsiChar;
    class operator Dec(a: PAnsiChar): PAnsiChar;
    Function GetLength: integer;
    Function StrPas: String;
    Function AStrPas: AnsiString;
    function StrUpper: PAnsiChar; // changes Current Value;
    function StrLower: PAnsiChar;
    Function StrScan(Chr: Byte): PAnsiChar;
    { StrScan returns a PAnsiChar to the first occurrence of Chr in Str. If Chr
      does not occur in Str, StrScan returns NIL. The null terminator is
      considered to be part of the string. }
    Function SepStrg(ASep: AnsiString): String;
    Function FieldSep(SepVal: AnsiChar): String;
    Function Copy(Index: integer; ACount: integer;
      ATerminateOnNull: Boolean = True): AnsiString;
    Function WriteBytesToStrm(AStm: TStream; ABytes: integer = -1): integer;
    // Function SubPAnsiChar(AStart: Integer): PAnsiChar;
    Property TempAnsiString: AnsiString Read GetTempString Write SetTempString;
    Property Length: integer Read GetLength;
    Property Data[a: integer]: AnsiChar Read GetData Write SetData; Default;
  end;

function StrUpper(S: PAnsiChar): PAnsiChar; overload;
function UpperCase(const S: AnsiString): AnsiString; overload;
function StrLower(S: PAnsiChar): PAnsiChar; overload;
function LowerCase(const S: AnsiString): AnsiString; overload;

Function StrScan(const Str: PAnsiChar; Chr: Byte): PAnsiChar; overload;
Procedure UniqueString(Var AStg: AnsiString); overload;
function ByteType(const S: AnsiString; Index: integer): TMbcsByteType; overload;
Function Pos(ASubStr, AStr: AnsiString): integer; Overload;
// Pos returns one based index for zero based and one based strings
// Use Index of and Substring for consistent zero based values across

function StrPos(const Str1, Str2: PAnsiChar): PAnsiChar; overload;
// StrPos returns a pointer to the first occurrence of Str2 in Str1. If Str2 does not occur in Str1, StrPos returns nil (Delphi) or NULL (C++).
// Function Low(AData: AnsiString): Integer; overload;
// Function High(AData: AnsiString): Integer; overload;
// Function Length(AData: AnsiString): Integer; overload;
Function Copy(AStr: AnsiString; AFrom: integer { First letter =1 } = 1;
  aLen: integer = 2000): AnsiString; overload;
Function Copy(AStr: PAnsiChar; AOffset: integer= 0; {0 Ref Offset = 1 copy from second letter}
  aLen: integer = 2000): AnsiString; overload;
Function Copy(AStr: String; AFrom: integer { First letter =1 } = 1;
  aLen: integer = 2000): String; overload;
// Provided to overload System.Copy

function StrCopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar;
function StrLCopy(Dest: PAnsiChar; const Source: PAnsiChar; MaxLen: Cardinal)
  : PAnsiChar; overload;
function StrLCopy(Dest: Pointer; const Source: PAnsiChar; MaxLen: Cardinal)
  : PAnsiChar; overload;
function StrComp(const Str1, Str2: PAnsiChar): integer; overload;
function StrLen(const Str1: PAnsiChar): integer; overload;
function StrCodeInfo(const s: UnicodeString): StrCodeInfoRec; overload; inline;

const
  NullStrCodeInfo: StrCodeInfoRec = (CodePage: 0; ElementLength: 0; RefCount: 0;
    Length: 0);
Var
  NullAnsiString: AnsiString; // Do not allocate to???????

implementation

function ByteType(const S: AnsiString; Index: integer): TMbcsByteType; overload;

Begin
  Result := mbSingleByte;
End;

Function Pos(ASubStr, AStr: AnsiString): integer;
// Pos returns one based index for zero based and one based strings
// Use Index of and Substring for consistent zero based values across
Var
  a, b: String;
begin
  a := ASubStr;
  b := AStr;
  Result := PosEx(a, b); // - NewGenPosFirst;
end;

Procedure UniqueString(Var AStg: AnsiString);
Var
  OldCopy, NewCopy: AnsiString;
  Len: integer;
begin
  OldCopy := AStg;
  NewCopy := '';
  Len := OldCopy.Length;
  if Len > 0 then
    NewCopy.CopyBytesFromMemory(Pointer(OldCopy), Len);
  AStg := NewCopy;
end;

Function StrScan(const Str: PAnsiChar; Chr: Byte): PAnsiChar;
begin
  Result := Str.StrScan(Chr);
end;

function StrUpper(S: PAnsiChar): PAnsiChar;
begin
  Result := S.StrUpper;
end;

function UpperCase(const S: AnsiString): AnsiString;
begin
  Result := S.UpperCase;
end;

function StrLower(S: PAnsiChar): PAnsiChar;
begin
  Result := S.StrLower;
end;

function LowerCase(const S: AnsiString): AnsiString;
begin
  Result := S.LowerCase;
end;

function StrPos(const Str1, Str2: PAnsiChar): PAnsiChar; overload;
{ StrPos returns a pointer to the first occurrence of Str2 in Str1.
  If Str2 does not occur in Str1, StrPos returns nil (Delphi) or NULL (C++). }

{ StrScan returns a PAnsiChar to the first occurrence of Chr in Str. If Chr
  does not occur in Str, StrScan returns NIL. The null terminator is
  considered to be part of the string. }

var
  MatchStart, LStr1, LStr2: PAnsiChar;
begin
  Result := nil;
  if (Str1[0] = 0) or (Str2[0] = 0) then
    Exit;

  MatchStart := Str1;
  while (Byte(MatchStart[0]) <> 0) do
  begin
    if MatchStart[0] = Str2[0] then
    begin
      LStr1 := MatchStart;
      LStr2 := Str2;
      Inc(LStr1);
      Inc(LStr2);
      while True do
      begin
        if Byte(LStr2[0]) = 0 then
          Exit(MatchStart); // MarchStart is the result
        if (Byte(LStr1[0]) <> Byte(LStr2[0])) or (LStr1[0] = 0) then
          Break;
        Inc(LStr1);
        Inc(LStr2);
      end;
    end;
    Inc(MatchStart);
  end;
end;

Procedure CopyMemory(ADestination, ASource: Pointer; AMemLen: LongWord);
// : LongWord;
Const
  BufMax = 200000;
Type
  Bfr = Array [0 .. BufMax] of Byte;
  BfrPtr = ^Bfr;
Var
  Src, Dest: BfrPtr;
  i: integer;
begin
  if AMemLen > BufMax then
    raise Exception.Create('CopyMemory Length exceeeded ' + IntToStr(AMemLen));
  Src := ASource;
  Dest := ADestination;
  for i := 0 to AMemLen - 1 do
    Dest[i] := Src[i];
end;

function StrCopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar;
Var
  Src: Pointer;
begin
  Src := Source.FData;
  Result.FData := Dest.FData;
  Result.FTempAnsiString := Dest.FTempAnsiString;
  CopyMemory(Result.FData, Src, Source.Length + 1);
end;

function StrLCopy(Dest: PAnsiChar; const Source: PAnsiChar; MaxLen: Cardinal)
  : PAnsiChar;
var
  Len: Cardinal;
begin
  Result.FData := Dest.FData;
  Result.FTempAnsiString := Dest.FTempAnsiString;
  Len := Source.Length;
  if Len > MaxLen then
    Len := MaxLen;
  CopyMemory(Dest.FData, Source.FData, Len);
  Dest[Len] := #0;
end;

function StrLCopy(Dest: Pointer; const Source: PAnsiChar; MaxLen: Cardinal)
  : PAnsiChar;
var
  Len: Cardinal;
begin
  Result.FData := Dest;
  Len := Source.Length;
  if Len > MaxLen then
    Len := MaxLen;
  // Move(Source.FData, Dest, Len);
  CopyMemory(Dest, Source.FData, Len);
  Result[Len] := #0;
end;

function StrLen(const Str1: PAnsiChar): integer; overload;
var
  Str: PAnsiChar;

begin
  Result := 0;
  if Str1 = nil then
    Exit;

  Str := Str1;
  while (Result < MaxLenPAnsiChar) and (Str[0] <> 0) do
  begin
    Inc(Result);
    // Inc(Str);
    Str := Str + 1;
  end;
end;

function StrComp(const Str1, Str2: PAnsiChar): integer;
var
  P1, P2: ^Byte;
begin
  P1 := Pointer(Str1);
  P2 := Pointer(Str2);
  while True do
  begin
    if (P1^ <> P2^) or (P1^ = 0) then
      Exit(P1^ - P2^);
    Inc(P1);
    Inc(P2);
  end;
end;

Function Copy(AStr: AnsiString; AFrom: integer { First letter =1 };
  aLen: integer): AnsiString; overload;
Begin
  if AFrom < 1 then
    raise Exception.Create('Bad use of AnsiCopy Offest=' + IntToStr(AFrom));
  if (aLen + AFrom) > AStr.Length then
    aLen := AStr.Length - AFrom + 1;
  Result.CopyBytesFromMemory(@AStr.FData[AFrom - 1], aLen);
End;

Function Copy(AStr: String; AFrom: integer { First letter =1 } = 1;
  aLen: integer = 2000): String; overload;
Begin
  // Provided to overload System.Copy
  Result := System.Copy(AStr, AFrom, aLen);
End;

Function Copy(AStr: PAnsiChar; AOffset: integer; {0 Ref Offset = 1 copy from second letter}
  aLen: integer): AnsiString; overload;
Begin
  if AOffset < 0 then
    raise Exception.Create('Bad use of AnsiCopy Offest=' + IntToStr(AOffset));
  if (aLen + AOffset) > AStr.Length then
    aLen := AStr.Length - AOffset;
  Result.CopyBytesFromMemory(Pointer(Int64(AStr.FData) + AOffset), aLen);
End;

{ Function Low(AData: AnsiString): Integer;
  begin
  Result := 0;
  end;

  Function High(AData: AnsiString): Integer;
  begin
  Result := AData.Length - 1;
  end;

  Function Length(AData: AnsiString): Integer;
  begin
  Result := AData.Length;
  end;
}

{ AnsiString }

class operator AnsiString.Add(a, b: AnsiString): AnsiString;
Var
  isrc, idest: integer;
begin
  Result.Length := a.Length + b.Length;
  idest := 0;
  for isrc := 0 to System.High(a.FData) - 1 do
  begin
    Result.FData[idest] := a.FData[isrc];
    Inc(idest);
  end;
  for isrc := 0 to System.High(b.FData) - 1 do
  begin
    Result.FData[idest] := b.FData[isrc];
    Inc(idest);
  end;
end;

class operator AnsiString.Add(a: AnsiString; b: Byte): AnsiString;
Var
  isrc, idest: integer;
begin
  Result.Length := a.Length + 1;
  idest := 0;
  for isrc := 0 to System.High(a.FData) - 1 do
  begin
    Result.FData[idest] := a.FData[isrc];
    Inc(idest);
  end;
  Result.FData[idest] := b;
  Inc(idest);
end;

class operator AnsiString.Add(a: AnsiString; b: AnsiChar): AnsiString;
begin
  Result := a + Byte(b);
end;

class operator AnsiString.Add(a: AnsiString; b: String): AnsiString;
Var
  isrc, idest: integer;
begin
  Result.Length := a.Length + b.Length;
  idest := 0;
  for isrc := 0 to System.High(a.FData) - 1 do
  begin
    Result.FData[idest] := a.FData[isrc];
    Inc(idest);
  end;
  for isrc := System.Low(b) to System.High(b) do
  begin
    Result.FData[idest] := Byte(Ord(b[isrc]));
    Inc(idest);
  end;
end;

class operator AnsiString.Add(a: String; b: AnsiString): AnsiString;
Var
  isrc, idest: integer;
begin
  Result.Length := a.Length + b.Length;
  idest := 0;
  for isrc := System.Low(a) to System.High(a) do
  begin
    Result.FData[idest] := Byte(Ord(a[isrc]));
    Inc(idest);
  end;
  for isrc := 0 to System.High(b.FData) - 1 do
  begin
    Result.FData[idest] := b.FData[isrc];
    Inc(idest);
  end;
end;

{ function AnsiString.AnsiAsUnicode: String;
  //Achieved by class operator implicit
  var
  i: Integer;
  begin
  if Length < 1 then
  Result := ''
  else
  Begin
  SetLength(Result, Length);
  for i := 0 to High do
  Result[i] := Char(FData[i]);
  end;
  end;


  class operator AnsiString.Implicit(a: AnsiString): String;
  Var
  i, hh: Integer;
  begin
  hh := a.Length;
  SetLength(Result, hh);
  Dec(hh);
  for i := 0 to hh do
  Result[i] := Char(a.FData[i]);
  end;


}

function AnsiString.AnsiLastChar: Pointer;
Var
  Nxt: ^Byte;
  Len: integer;
begin
  Len := Length;
  Nxt := @FData[0];
  while (Len > 0) and (Nxt^ <> 0) do
  begin
    Inc(Nxt);
    Dec(Len);
  end;
  if Len < 1 then
    Result := nil
  else
    Result := Nxt;
end;

function AnsiString.AsStringValues: String;
// 123[0D](^M)5647
const
  a: set of #0 .. #255 = [' ' .. '~'];
  Ctrl: set of #0 .. #255 = [#1 .. #31];
var
  i: integer;
  Sub: longint;
  rr: string;
  x: Char;
  GreaterThan127: Boolean;
  DataLength: integer;

begin
  try
    Result := '';
    if Length < 1 then
      Exit;

    i := 0;
    rr := '';
    DataLength := Length;
    if DataLength > 1000 then
      DataLength := 1000;
    while i <= DataLength - 1 do
    begin
      Sub := Ord(FData[i]);
      GreaterThan127 := Sub > 127;
      if GreaterThan127 then
      begin
        Sub := Sub - 128;
        rr := rr + '<';
      end;
      x := Char(Sub);
      if (x in a) then
        rr := rr + x
      else
      begin
        if GreaterThan127 then
          rr := rr + '[' + IntToHex(Sub + 128, 2) + ']'
        else
          rr := rr + '[' + IntToHex(Sub, 2) + ']';
        if (x in Ctrl) then
          rr := rr + '(' + '^' + Chr(Sub + 64) + ')';
      end;
      if GreaterThan127 then
        rr := rr + '>';
      i := i + 1;
    end;
    Result := rr;
  except
    on E: Exception do
      Result := 'AsStringValues Error::' + E.Message;
  end;
end;

procedure AnsiString.CompressedUnicode(const AUCode: UnicodeString);
// Contains Ascii version of Unicode but '' if 2 byte characters found
// Returns '' if Chars above 255
var
  Ri, Ui, Finished: integer;
  CharVal: Word;
  R: StrCodeInfoRec;
begin
  R := StrCodeInfo(AUCode);
  if R.Length < 1 then
    Length := 0
  else
  begin
    Finished := R.Length;
    if R.CodePage <> DefaultUnicodeCodePage then
      raise Exception.Create('Non Unicode Unicode');
    Length := R.Length;

    Ri := 0;
    Ui := 0;
    CharVal := Ord(AUCode[0]);
    while (Ri < Finished) and (CharVal < 256) do
    begin
      CharVal := Ord(AUCode[Ui]);
      FData[Ri] := CharVal;
      Inc(Ui);
      Inc(Ri);
    end;
    if Ri < Finished then
      Length := 0;
  end;
end;

procedure AnsiString.CopyBytesFromMemory(ABuffer: Pointer; ACount: integer);
begin
  Length := ACount;
  CopyMemory(@FData[0], ABuffer, ACount);
end;

function AnsiString.CopyBytesToMemory(ABuffer: Pointer;
  ABytes, AOffset: integer): integer;
{ Offest zero ref }
Var
  ToWrite: Int64;
begin
  ToWrite := Length - AOffset;
  if ToWrite < 0 then
    Result := -1
  else
    try
      if ABytes > 0 then
        if ABytes < ToWrite then
          ToWrite := ABytes;

      CopyMemory(ABuffer, @FData[AOffset], ToWrite);
      Result := ToWrite;
    Except
      Result := -1;
    End;
end;

procedure AnsiString.Delete(Index, Count: integer);
Var
  i, j, NewLength: integer;

begin
  if Index > Length - 1 then
    Exit;

  NewLength := Index + Count - 1;
  if NewLength > Length then
  Begin
    Count := Count - (Length - NewLength);
    NewLength := Index + Count - 1;
    if NewLength <> Length then
      raise Exception.Create('Should be equal Error Message');
  End;
  NewLength := Length - Count;
  j := Index + Count;
  for i := Index to NewLength - 1 do
  begin
    FData[i] := FData[j];
    Inc(j);
  end;
  Length := NewLength;
end;

class operator AnsiString.Equal(a, b: AnsiString): Boolean;
Var
  Finished, i: integer;

begin
  Finished := a.Length;
  Result := Finished = b.Length;

  i := 0;
  while Result and (i < Finished) do
  begin
    Result := a.FData[i] = b.FData[i];
    Inc(i);
  end;
end;

// class operator AnsiString.Explicit(a: AnsiString): String;
// begin
// Result := a.DeCompressUnicode;
// end;

function AnsiString.GetData(a: integer): AnsiChar;
begin
  Result := AnsiChar(Byte(0));
  if a < 0 then
    Exit;
  if (a < Length) then
  begin
    Result.FData := FData[a];
    Result.FPtr := @FData[a];
  end;
end;

function AnsiString.GetLength: integer;
begin
  Result := System.Length(FData) - 1;
  if Result < 0 then
    Result := 0;
end;

class operator AnsiString.GreaterThan(a, b: AnsiString): Boolean;
Var
  i, short: integer;
  Eq: Boolean;
begin
  Result := True;
  short := a.High; // not include null termination
  if b.High < short then
    short := b.High;
  Eq := True;
  i := 0;
  while Result and (i <= short) do
  begin
    Result := a.FData[i] >= b.FData[i];
    if Eq then
      Eq := a.FData[i] = b.FData[i];
    Inc(i);
  end;
  if Eq then
    Result := short = b.High;
end;

class operator AnsiString.GreaterThanOrEqual(a, b: AnsiString): Boolean;
begin
  Result := a = b;
  if Not Result then
    Result := a > b;
end;

function AnsiString.High: integer;
begin
  High := Length - 1;
end;

class operator AnsiString.Implicit(a: String): AnsiString;
begin
  Result.CompressedUnicode(a);
end;

class operator AnsiString.Implicit(a: Char): AnsiString;
Var
  Val: integer;
begin
  Val := Ord(a);
  if Val > 255 then
    Val := Val mod 256;
  Result.Length := 1;
  Result.FData[0] := Byte(Val);
end;

class operator AnsiString.Implicit(a: Byte): AnsiString;
begin
  Result.Length := 1;
  Result.FData[0] := a;
end;

class operator AnsiString.Implicit(a: AnsiString): Pointer;
begin
  if a.Length < 1 then
    Result := nil
  else
    Result := @a.FData[0];
end;

class operator AnsiString.Implicit(a: AnsiString): String;
Var
  i, hh: integer;
begin
  hh := a.Length;
  SetLength(Result, hh);
  Dec(hh);
  for i := 0 to hh do
    Result[i] := Char(a.FData[i]);
end;

class operator AnsiString.Implicit(a: AnsiChar): AnsiString;
begin
  Result.Length := 1;
  Result.FData[0] := a.FData;
end;

function AnsiString.IsBlank: Boolean;
var
  i, Len: integer;
begin
  Result := True;
  Len := Length;
  if Len < 1 then
    Exit;

  i := 0;
  while Result and (i < Len) do
  begin
    Result := FData[i] in [0 .. Ord(' '), 127 .. (Ord(' ') + 128)];
    Inc(i);
  end;
end;

class operator AnsiString.LessThan(a, b: AnsiString): Boolean;
begin
  Result := not(a > b);
end;

class operator AnsiString.LessThanOrEqual(a, b: AnsiString): Boolean;
begin
  Result := a = b;
  if Not Result then
    Result := a < b;
end;

function AnsiString.Low: integer;
begin
  Low := 0;
end;

function AnsiString.LowerCase: AnsiString;
var
  i, Len: integer;
begin
  Len := Length;
  Result.Length := Len;
  for i := 0 to Len - 1 do
    if FData[i] in [Byte(Ord('A')) .. Byte(Ord('Z'))] then
      Result.FData[i] := FData[i] + Byte(Ord('a') - Ord('A'))
    else
      Result.FData[i] := FData[i];
end;

class operator AnsiString.NotEqual(a, b: AnsiString): Boolean;
begin
  Result := not(a = b);
end;

function AnsiString.OffsetPointer(AByteOffset: integer): Pointer;
begin
  If AByteOffset >= Length then
    Result := nil
  else
    Result := @FData[AByteOffset];
end;

Function AnsiString.ReadBytesFrmStrm(AStm: TStream; ABytes: integer): Int64;
begin
  Result := 0;
  Length := 0;
  if (AStm = nil) or (ABytes < 1) then
    Exit;

  Length := ABytes;
  Result := AStm.Read(FData[0], ABytes);
  if Result < ABytes then
    Length := Result;
end;

procedure AnsiString.ReadOneLineFrmStrm(AStm: TStream);
var
  CurPos, EndPos: Int64;
  i, EndSZ: integer;
  Nxt: Byte;
begin
  Length := 0;
  CurPos := AStm.Position;
  EndPos := AStm.seek(0, soFromEnd);
  AStm.seek(CurPos, soFromBeginning);

  if 256 > EndPos - CurPos then
    EndSZ := Word(EndPos - CurPos)
  else
    EndSZ := 256; // Max Line Size
  Length := EndSZ;
  if EndSZ < 1 then
    Exit;

  i := 0;
  AStm.Read(Nxt, 1);
  while not(Nxt in [13, 10, 13 + 128, 10 + 128]) and (i < EndSZ) do
    // CRP = Ansichar(#141); // (13 + 128);
    // LFP = Ansichar(#138); // (10 + 128);
    try
      FData[i] := Nxt;
      Inc(i);
      AStm.Read(Nxt, 1);
    except
      Nxt := 13;
    end;
  Length := i;
  while (Nxt in [13, 10, 13 + 128, 10 + 128]) and (AStm.Position < EndPos) do
    AStm.Read(Nxt, 1);
  CurPos := AStm.Position;
  if CurPos < EndPos then
    AStm.seek(CurPos - 1, soFromBeginning);
end;

function AnsiString.RecoverFullUnicode: String;
var
  MemLen, StrLen: integer;
  Nxt, Dest: Pointer;
begin
  MemLen := Length;
  StrLen := MemLen div 2;
  SetLength(Result, StrLen);
  if StrLen < 1 then
    Exit;

  Dest := @Result[0];
  Nxt := FData;
  CopyMemory(Dest, Nxt, MemLen);
end;

procedure AnsiString.SetData(a: integer; const Value: AnsiChar);
begin
  if a < Length then
    FData[a] := Byte(Value);
end;

procedure AnsiString.SetStrLength(aLen: integer);
begin
  if aLen < 1 then
    System.SetLength(FData, 0)
  else
  begin
    System.SetLength(FData, aLen + 1);
    FData[aLen] := 0;
  end;
end;

class operator AnsiString.Subtract(a, b: AnsiString): AnsiString;
Var
  i, DLen: integer;
begin
  i := Pos(b, a);
  if i < 1 then
    Result := a
  Else
  Begin
    DLen := b.Length;
    Result := a;
    Result.UniqueString;
    Result.Delete(i - 1, DLen);
  End;
end;

function AnsiString.UnCompressedToUnicode: String;
Var
  i, hh: integer;
begin
  Result := '';
  hh := Length;
  if Length > 0 then
  begin
    SetLength(Result, hh);
    Dec(hh);
    for i := 0 to hh do
      Result[i] := Char(FData[i]);
  end;
end;

procedure AnsiString.UnicodeAsAnsi(UString: String);
// For std AnsiChars every second byte is a null
// Bypasses Conversion Routines
var
  MemLen: integer;
  Nxt, Dest: Pointer;
begin
  MemLen := 2 * UString.Length;
  Length := MemLen;
  if MemLen < 1 then
    Exit;

  Nxt := @UString[0];
  Dest := FData;
  CopyMemory(Dest, Nxt, MemLen);
end;

procedure AnsiString.UniqueString;
var
  Len: integer;
begin
  Len := Length;
  Length := Len;
end;

function AnsiString.UpperCase: AnsiString;
var
  i, Len: integer;
begin
  Len := Length;
  Result.Length := Len;
  for i := 0 to Len - 1 do
    if FData[i] in [Byte(Ord('a')) .. Byte(Ord('z'))] then
      Result.FData[i] := FData[i] - Byte(Ord('a') - Ord('A'))
    else
      Result.FData[i] := FData[i];
end;

function AnsiString.WriteBytesToStrm(AStm: TStream; ABytes: integer;
  AOffset: integer): integer;
{ Offest zero ref }
Var
  ToWrite: Int64;
  Src: Pointer;
begin
  ToWrite := Length - AOffset;
  if ToWrite < 0 then
    Result := -1
  else
  Begin
    if ABytes > 0 then
      if ABytes < ToWrite then
        ToWrite := ABytes;
    Src := @FData[AOffset];
    Result := AStm.Write(Src, ToWrite);
  End;
end;

function AnsiString.WriteLineToStream(AStm: TStream): integer;
var
  S: AnsiString;
begin
  if FData[Length] in [13, 10, 138, 141] then
    S := self
  else
    S := self + #10 + #13;
  Result := S.WriteBytesToStrm(AStm);
end;

{ AnsiChar }

class operator AnsiChar.Add(a, b: AnsiChar): String;
begin
  Result := Char(Byte(a)) + Char(Byte(b));
end;

class operator AnsiChar.Equal(a, b: AnsiChar): Boolean;
begin
  Result := Byte(a) = Byte(b);
end;

class operator AnsiChar.Equal(a: Byte; b: AnsiChar): Boolean;
begin
  Result := Byte(a) = Byte(b);
end;

class operator AnsiChar.Equal(a: AnsiChar; b: Byte): Boolean;
begin
  Result := Byte(a) = Byte(b);
end;

class operator AnsiChar.Equal(a: Char; b: AnsiChar): Boolean;
begin
  Result := Byte(Ord(a)) = Byte(b);
end;

class operator AnsiChar.Equal(a: AnsiChar; b: Char): Boolean;
begin
  Result := Byte(a) = Byte(Ord(b));
end;

function AnsiChar.GetLength: integer;
begin
  Result := 1;
end;

class operator AnsiChar.Implicit(a: AnsiChar): Pointer;
begin
  Result := a.FPtr;
end;

{
  class operator AnsiChar.Explicit(a: AnsiChar): Pointer;
  begin
  // possible???
  if a.FData = 0 then
  Result := nil
  Else
  Result := Pointer(9999999);
  end;
}

class operator AnsiChar.Implicit(a: AnsiChar): Byte;
begin
  Result := { Byte } (a.FData);
end;

class operator AnsiChar.Implicit(a: AnsiChar): Char;
begin
  Result := Char(Byte(a.FData));
end;

class operator AnsiChar.Implicit(a: Byte): AnsiChar;
begin
  Result.FData := a;
end;

class operator AnsiChar.Implicit(a: Char): AnsiChar;
Var
  Rslt: Byte;
begin
  Rslt := Byte(Ord(a));
  // if Rslt>127 then
  // Dec(Rslt,128);
  Result.FData := Rslt;
end;

class operator AnsiChar.NotEqual(a, b: AnsiChar): Boolean;
begin
  Result := not(a = b);
end;

{ PAnsiChar }

class operator PAnsiChar.Add(a, b: PAnsiChar): PAnsiChar;
begin
  if Pointer(a) = nil then
    Result := b
  else if Pointer(b) = nil then
    Result := a
  else
  begin
    Result.FTempAnsiString := AnsiString(a) + AnsiString(b);
    Result.FData := @Result.FTempAnsiString.FData[0];
  end;
end;

class operator PAnsiChar.Add(a: PAnsiChar; b: integer): PAnsiChar;
begin
  Result.FTempAnsiString.FData := a.FTempAnsiString.FData; // inc usage count
  Result.FData := Pointer(Int64(a.FData) + b);
end;

class operator PAnsiChar.Add(a: integer; b: PAnsiChar): PAnsiChar;
begin
  Result.FTempAnsiString.FData := b.FTempAnsiString.FData; // inc usage count
  Result.FData := Pointer(Int64(b.FData) + a);
end;

function PAnsiChar.AStrPas: AnsiString;
Var
  i, Len: integer;
begin
  Len := Length;
  Result.Length := Len;

  if Len > 0 then
    for i := 0 to Len - 1 do
      Result.FData[i] := TISBytesArray(FData)[i];
end;

function PAnsiChar.Copy(Index, ACount: integer;
  ATerminateOnNull: Boolean = True): AnsiString;
Var
  dn: integer;
  Nxt: ^Byte;
  Count: integer;

begin
  if ACount < 0 then
    Count := Length
  Else
    Count := ACount;

  if FData = nil then
    Result.Length := 0
  else if (TISBytesArray(FData)[0] = 0) And ATerminateOnNull then
    Result.Length := 0
  else
  Begin
    dn := 0;
    Nxt := Pointer(Int64(FData) + Index);
    Result.Length := Count;
    While ((Nxt^ <> 0) or Not ATerminateOnNull) and (dn < Count) do
    Begin
      TISBytesArray(Result.FData)[dn] := Nxt^;
      Inc(dn);
      Inc(Nxt);
    End;
    if dn < Count then
      Result.Length := dn;
  End;
end;

class operator PAnsiChar.Dec(a: PAnsiChar): PAnsiChar;
begin
  Result.FData := Pointer(Int64(a.FData) - 1);
  Result.FTempAnsiString := a.FTempAnsiString;
end;

class operator PAnsiChar.Equal(a, b: PAnsiChar): Boolean;
Var
  NxtA, NxtB: ^Byte;

begin
  NxtA := Pointer(a.FData);
  NxtB := Pointer(b.FData);
  Result := NxtA = NxtB;
  { if (NxtA = nil) or (NxtB = nil) then
    Exit;

    if Not Result then
    begin
    Result := NxtA^ = NxtB^;
    while Result And (NxtA^ <> 0) And (NxtB^ <> 0) do
    Begin
    Result := NxtA^ = NxtB^;
    Inc(NxtA);
    Inc(NxtB);
    end;
    end;
    if Result then
    Result := NxtA^ = NxtB^; }
end;

class operator PAnsiChar.Explicit(a: PAnsiChar): Int64;
begin
  Result := Int64(a.FData);
end;

class operator PAnsiChar.Equal(a: Pointer; b: PAnsiChar): Boolean;
begin
  Result := a = Pointer(b);
end;

class operator PAnsiChar.Equal(a: PAnsiChar; b: Pointer): Boolean;
begin
  Result := Pointer(a) = b;
end;

class operator PAnsiChar.Explicit(a: String): PAnsiChar;
begin
  Result.FTempAnsiString := a;
  Result.FData := Result.FTempAnsiString.FData;
end;

class operator PAnsiChar.Explicit(a: PAnsiChar): Pointer;
begin
  Result := a.FData;
end;

class operator PAnsiChar.Explicit(a: Pointer): PAnsiChar;
begin
  Result.FData := a;
end;

function PAnsiChar.FieldSep(SepVal: AnsiChar): String;
var
  CharPointer: PAnsiChar;
  j: integer;
  ARslt: AnsiString;
begin
  Result := '';

  if FData = nil then
    Exit;

  if (SepVal = 0) then
    Exit;

  while TISBytesArray(FData)[0] = SepVal do
    Inc(self);

  CharPointer := StrScan(SepVal);

  if CharPointer.FData = nil then
    Result := StrPas { Last Field }
  else
  begin
    j := Int64(CharPointer.FData) - Int64(FData);
    ARslt := Copy(0, j { , False } );
    Result := ARslt;
  end;
  if CharPointer.FData = nil then
    FData := nil
  else
  Begin
    FData := Pointer(Int64(CharPointer.FData) + 1);
  end;
end;

function PAnsiChar.GetData(a: integer): AnsiChar;
begin
  if FData = Nil then
    Result.FData := 0
  else
  begin
    Result.FData := TISBytesArray(FData)[a];
    Result.FPtr := @TISBytesArray(FData)[a];
  end;
end;

function PAnsiChar.GetLength: integer;
var
  // StartPtr: ^TISBytesArray;
  isrc: longint;

begin
  if FData = nil then
    Result := 0
  else
  begin
    // Pointer(StartPtr) := FData;         //pointer bypas usage inc
    // StartPtr := FData;         //pointer bypas usage inc
    isrc := 0;
    if FData = nil then
      Result := 0
    Else if TISBytesArray(FData)[0] = Byte(0) then
      Result := 0
    Else
    Begin
      while (TISBytesArray(FData)[isrc] <> Byte(0)) and
        (isrc < MaxLenPAnsiChar) do
      begin
        Inc(isrc);
      end;
      Result := isrc;
    End;
  end;
end;

function PAnsiChar.GetTempString: AnsiString;
begin
  if FTempAnsiString.Length < 1 then
    FTempAnsiString := self;

  Result := FTempAnsiString;
end;

class operator PAnsiChar.GreaterThan(a, b: PAnsiChar): Boolean;
begin
  Result := Int64(a.FData) > Int64(b.FData);
end;
{ Var
  NxtA, NxtB: ^Byte;
  begin
  Result := True;
  NxtA := Pointer(a.FData);
  NxtB := Pointer(b.FData);
  if (NxtB = nil) or (NxtB^ = 0) then
  begin
  Result := (NxtA <> nil) and (NxtA^ > 0);
  Exit;
  end;
  while Result and (NxtA^ <> 0) And (NxtB^ <> 0) do
  begin
  Result := NxtA^ >= NxtB^;
  if NxtA^ > NxtB^ then
  Exit;
  Inc(NxtA);
  Inc(NxtB);
  end;
  if Result and (NxtA^ = 0) then
  Result := false;
  end;
}

class operator PAnsiChar.GreaterThan(a: Pointer; b: PAnsiChar): Boolean;
begin
  Result := Int64(a) > Int64(b.FData);
end;

class operator PAnsiChar.GreaterThan(a: PAnsiChar; b: Pointer): Boolean;
begin
  Result := Int64(a.FData) > Int64(b);
end;

class operator PAnsiChar.Inc(a: PAnsiChar): PAnsiChar;
begin
  Result.FData := Pointer(Int64(a.FData) + 1);
  Result.FTempAnsiString := a.FTempAnsiString;
end;

class operator PAnsiChar.LessThan(a, b: PAnsiChar): Boolean;
Var
  NxtA, NxtB: ^Byte;
begin
  Result := False;
  NxtA := Pointer(a.FData);
  NxtB := Pointer(b.FData);
  if (NxtA = nil) or (NxtA^ = 0) then
  begin
    Result := (NxtB <> nil) and (NxtB^ > 0);
    Exit;
  end;

  if (NxtB <> nil) and (NxtB^ > 0) then
    Result := Int64(NxtA) < Int64(NxtB);

  {

    while Result and (NxtA^ <> 0) And (NxtB^ <> 0) do
    begin
    Result := NxtA^ <= NxtB^;
    if NxtA^ < NxtB^ then
    Exit;
    Inc(NxtA);
    Inc(NxtB);
    end;
    if Result and (NxtB^ = 0) then
    Result := false; }
end;

class operator PAnsiChar.LessThan(a: Pointer; b: PAnsiChar): Boolean;
begin
  Result := not(Int64(a) = Int64(b.FData)) and not(Int64(a) > Int64(b.FData));
end;

class operator PAnsiChar.LessThan(a: PAnsiChar; b: Pointer): Boolean;
begin
  Result := not(Int64(a.FData) = Int64(b)) and not(Int64(a.FData) > Int64(b));
end;

class operator PAnsiChar.NotEqual(a, b: PAnsiChar): Boolean;
begin
  Result := not(a = b);
end;

class operator PAnsiChar.NotEqual(a: Pointer; b: PAnsiChar): Boolean;
begin
  Result := a <> Pointer(b);
end;

class operator PAnsiChar.NotEqual(a: PAnsiChar; b: Pointer): Boolean;
begin
  Result := Pointer(a) <> b;
end;

class operator PAnsiChar.Implicit(a: PAnsiChar): String;
begin
  Result := a.StrPas;
end;

class operator PAnsiChar.Implicit(a: Pointer): PAnsiChar;
begin
  if a = nil then
    Result.FData := nil
  Else if TISBytesArray(a)[0] = Byte(0) then
    Result.FData := nil
  Else
    Result.FData := a;
end;

class operator PAnsiChar.Implicit(a: PAnsiChar): AnsiString;
begin
  Result := a.AStrPas;
end;

class operator PAnsiChar.Implicit(a: AnsiString): PAnsiChar;
begin
  Result.FTempAnsiString := a;
  Result.FData := @a.FData[0];
end;

function PAnsiChar.SepStrg(ASep: AnsiString): String;
Var
  Len: integer;
  SepAChar: PAnsiChar;
  CharPointer: PAnsiChar;
  Dta, Dtb: Pointer;
  ARslt: AnsiString;

begin
  Result := '';

  if FData = nil then
    Exit;
  if Length < 1 then
    Exit;

  SepAChar := ASep;

  CharPointer := StrPos(self, SepAChar);

  if CharPointer.FData = nil then
  Begin
    Result := StrPas;
    FData := nil;
  End
  else
  begin
    Dta := FData;
    Dtb := CharPointer.FData;
    Len := Int64(Dtb) - Int64(Dta);
    ARslt := Copy(0, Len { , False } );
    Result := ARslt;
    FData := Pointer(Int64(Dtb) + ASep.Length);
  end;
end;

procedure PAnsiChar.SetData(a: integer; const Value: AnsiChar);
begin
  if FData = nil then
    Exit;
  if a < 0 then
    Exit;

  if a > MaxLenPAnsiChar then
    Exit;

  TISBytesArray(FData)[a] := Byte(Value);
end;

procedure PAnsiChar.SetTempString(const Value: AnsiString);
begin
  FTempAnsiString := Value;
  FData := FTempAnsiString.FData;
end;

function PAnsiChar.StrLower: PAnsiChar;
Var
  Nxt: ^Byte;
begin
  Result := self;
  Nxt := FData;
  while Nxt^ <> 0 do
  begin
    if Nxt^ in [Byte(Ord('A')) .. Byte(Ord('Z'))] then
      Inc(Nxt^, 32);
    Inc(Nxt);
  end;
end;

function PAnsiChar.StrPas: String;
Var
  i, Len: integer;
begin
  Len := Length;
  SetLength(Result, Len);

  if Len > 0 then
    for i := 0 to Len - 1 do
      Result[i] := Char(TISBytesArray(FData)[i]);
end;

function PAnsiChar.StrScan(Chr: Byte): PAnsiChar;
{ StrScan returns a PAnsiChar to the first occurrence of Chr in Str. If Chr
  does not occur in Str, StrScan returns NIL. The null terminator is
  considered to be part of the string. }
var
  isrc: longint;
  Found: Boolean;
begin
  Result.FData := nil;
  if FData = nil then
    Exit;
  if TISBytesArray(FData)[0] = 0 then
    Exit;

  Result.FTempAnsiString := FTempAnsiString; // to inc mem counter
  isrc := 0;
  Result.FData := FData;
  Found := False;
  while (TISBytesArray(Result.FData)[0] <> 0) and (isrc < MaxLenPAnsiChar) and
    Not Found do
  Begin
    Found := (TISBytesArray(Result.FData)[0] = Chr);
    if not Found then
      Result.FData := Pointer(Int64(Result.FData) + 1);
    Inc(isrc);
  End;
  if not Found then
  begin
    Result.FData := nil;
    Result.FTempAnsiString := '';
  end;
end;

function PAnsiChar.StrUpper: PAnsiChar;
Var
  Nxt: ^Byte;
begin
  Result := self;
  Nxt := FData;
  while Nxt^ <> 0 do
  begin
    if Nxt^ in [Byte(Ord('a')) .. Byte(Ord('z'))] then
      Dec(Nxt^, 32);
    Inc(Nxt);
  end;
end;

class operator PAnsiChar.Subtract(a: PAnsiChar; b: Pointer): Int64;
begin
  Result := Int64(a.FData) - Int64(b);
  if Result < 0 then
    Result := 0;
end;

class operator PAnsiChar.Subtract(a: Pointer; b: PAnsiChar): Int64;
begin
  Result := Int64(a) - Int64(b.FData);
  if Result < 0 then
    Result := 0;
end;

class operator PAnsiChar.Subtract(a, b: PAnsiChar): Int64;
Var
  Aint, Bint: Int64;
begin
  Aint := Int64(a.FData);
  Bint := Int64(b.FData);
  if Aint < Bint then
    Result := 0
  else
    Result := Aint - Bint;
end;

class operator PAnsiChar.Subtract(a: Int64; b: PAnsiChar): Int64;
begin
  Result := a - Int64(b.FData);
  if Result < 0 then
    Result := 0;
end;

class operator PAnsiChar.Subtract(a: PAnsiChar; b: integer): PAnsiChar;
Var
  Aint: Int64;
begin
  Result.FData := nil;
  Aint := Int64(a.FData);
  if Aint < b then
  begin
    Result.FData := nil;
    // Result.FTempAnsiString := a.FTempAnsiString; //    do not asign
  end
  else
  Begin
    Result.FTempAnsiString.FData := a.FTempAnsiString.FData;
    Result.FData := Pointer(Aint - b);
  End;
end;

function PAnsiChar.WriteBytesToStrm(AStm: TStream; ABytes: integer): integer;
Var
  Len: integer;
begin
  if ABytes < 0 then
    Len := Length
  else
    Len := ABytes;
  if Len > 0 then
    Result := AStm.Write(FData, Len)
  else
    Result := 0;
end;

function StrCodeInfo(const s: UnicodeString): StrCodeInfoRec; overload; inline;
var
  AtS: NativeInt;
begin
  AtS := NativeInt(s);
  if AtS = 0 then
    Result := NullStrCodeInfo
  else
    Result := PStrCodeInfoRec(AtS - 12)^
end;


end.

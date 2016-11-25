unit ISListCnters;
{ Three Containers
  TISObjList = class(TList)
  Accepts and delivers pointers in default Items[] property but manages the reference counting
  so objects inserted are not "Recovered" by ARC while they are contained.

  TISStringPtrList = class(TStrings)
  A copy of TStringList Code but with the default Objects[] property defined
  as a pointer this means AddObject can accept Objects, Integers or Pointers
  without crashing ARC.

  The reference count of "objects" is not managed so Object Life Times must be
  maintaioned else where.


  TIsIntPtrStrings = class(TStringList)
  Has its own internal object structure enabling properties of
  Objects[] Pointers[] and Integers[]
  and (String,Item) Methods of
  AddObject, AddPointer and AddInteger

  Because the actual stored items are objects containing the
  Integers or pointers TStrings.AddStrings works fine and it can be passed to
  components such as list boxes etc to select or sort items based on the "string"
  represenrtation but the associated integer or pointer can be referenced from the
  index once the string is selected.
}

interface

uses
  System.SysUtils, System.Classes, System.RTLConsts;

{ TISObjList class }

Type
  // Minimal Object list extract (from System.Contrs.TObjectList) to
  // Hold object links on AutoRefCount otherwise operate as TList
  // ie accepts pointer references Used in ISMultiuserObjectDb
  // Delivers a pointer reference but ups the ref count?????
  TISObjList = class(TList)
  private
    FOwnsObjects: Boolean;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    // procedure Put(Index: Integer; Item: Pointer);
    // Use notifyto manage RefCount;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    procedure FreeInstance; override;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

  TISStringPtrList = class;

  // I think PStringItemWPtr will only be used by  TISStringPtrList
  // TISStringPtrList class for the FList Array
  PStringItemWPtr = ^TStringItemWPtr;

  TStringItemWPtr = record
    FString: string;
    FObject: Pointer;
  end;

  PStringItemWPtrList = ^TStringItemWPtrList;
  TStringItemWPtrList = array of TStringItemWPtr;

  // TISStringPtrList class for the Compare Function
  TStringPtrListSortCompare = function(List: TISStringPtrList;
    Index1, Index2: Integer): Integer;

  TIsIntPtrStringsObject = class(TObject)
    // used for TIsIntPtrStrings
    // Actually Stores Objects, Pointers or integers allowing on handling as a stringlist
  Public
    StoredObj: TObject;
    StoreInt: Integer;
    StorePointer: Pointer;
    Constructor Create;
    procedure FreeInstance; override;
  end;

  TIsIntPtrStrings = class(TStringList)
    // Does not actually Stores Pointers or integers directly but converts them into
    // TIsIntPtrStringsObjects so TStrings Work
  private
    function IndexToObjectWithInBounds(AIndex: Integer): TIsIntPtrStringsObject;
    function GetActualObject(Index: Integer): TObject;
    function GetInteger(Index: Integer): Integer;
    function GetPointer(Index: Integer): Pointer;
    procedure PutActualObject(Index: Integer; const Value: TObject);
    procedure PutInteger(Index: Integer; const Value: Integer);
    procedure PutPointer(Index: Integer; const Value: Pointer);
    // Does not actually Stores Pointers or integers directly but converts them into
    // TIsIntPtrStringsObjects so TStrings Work
  public
    function AddObject(const S: string; AObject: TObject): Integer; override;
    function AddPointer(const S: string; APtrForObj: Pointer): Integer;
    function AddInteger(const S: string; AIntegerForObj: Integer): Integer;
    Constructor Create;
    Destructor Destroy; override;
    procedure FreeInstance; override;
    Property ApplicationObjects[Index: Integer]: TObject read GetActualObject
      write PutActualObject;
    Property Pointers[Index: Integer]: Pointer read GetPointer write PutPointer;
    Property Integers[Index: Integer]: Integer read GetInteger write PutInteger;
  end;

  TISStringPtrListType = (SplIntegers, SplPointers, SplObjects);

  TISStringPtrList = class(TStrings)
    // Actually Stores Pointers, classes or integers
  private
    FList: TStringItemWPtrList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    FStringsAsList: TIsIntPtrStrings;
    FActiveType: TISStringPtrListType;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TStringPtrListSortCompare);
    procedure SetSorted(Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): Pointer; // override
    procedure Put(Index: Integer; const S: string); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure PutItemPointer(Index: Integer; AItem: Pointer);
    procedure SetCapacity(NewCapacity: Integer); override;
    function CompareStrings(const S1, S2: string): Integer; override;
    procedure InsertItem(Index: Integer; const S: string;
      AObject: Pointer); virtual;
  public
    constructor Create; // overload;
    destructor Destroy; override;
    procedure FreeInstance; override;
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: Pointer): Integer; // override;
    procedure AddStrings(Strings: TStrings); overload; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const S: string; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: string): Integer; override;
    function IndexOfObject(AObject: Pointer): Integer; Virtual;
    // Overloads TString
    function IndexOfPointer(AObject: Pointer): Integer; Virtual;
    function IndexOfInteger(AObjectRef: Integer): Integer; Virtual;
    function AsTStringsOfObjects: TStrings;
    procedure Insert(Index: Integer; const S: string); override;
    procedure InsertObject(Index: Integer; const S: string;
      AObject: TObject); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TStringPtrListSortCompare); virtual;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive;
    property Objects[Index: Integer]: Pointer read GetObject
      write PutItemPointer;
    property ActiveType: TISStringPtrListType Read FActiveType
      Write FActiveType;
  end;

procedure FreeListFO(var ThisList: TISObjList); overload;
procedure FreeSListFO(var AList: TIsIntPtrStrings); overload;
procedure FreeSListFO(var AList: TISStringPtrList); overload;

{ Free and dispose a AnsiString list }

implementation

uses
  ISObjectCounter,
  ISPermObjFileStm;

{ TISObjList }

constructor TISObjList.Create;
{$IFDEF DEBUG}
{$IFDEF AutoRefCount}
Var
  Count: Integer;
{$ENDIF}
{$ENDIF}
begin
  inherited Create;
{$IFDEF DEBUG}
{$IFDEF AutoRefCount}
  Count := RefCount;
{$ENDIF}
{$ENDIF}
  FOwnsObjects := True;
  IncObjectCount(Self);
{$IFDEF DEBUG}
{$IFDEF AutoRefCount}
  Count := RefCount;
{$ENDIF}
{$ENDIF}
end;

constructor TISObjList.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
  IncObjectCount(Self);
end;

procedure TISObjList.FreeInstance;
begin
  inherited;
  DecObjectCount(Self);
end;

(*
  function TISObjList.GetObj(Index: Integer): Pointer;
  {$IFDEF AUTOREFCOUNT}
  Var
  Tst:TObject;
  Count:Integer;
  {$ENDIF AUTOREFCOUNT}
  begin
  {$IFDEF AUTOREFCOUNT}
  Tst:=inherited Items[Index];
  Count:=Tst.RefCount;
  if Count>-1 then
  Count:=RefCount;
  Result:=nil;
  TObject(Result):= inherited Items[Index];
  Count:=Tst.RefCount;
  if Count>-1 then
  Count:=RefCount;
  Tst:=nil;
  Count:=Tst.RefCount;
  if Count>-1 then
  Count:=RefCount;
  {$Else}
  Result:= inherited Items[Index];
  {$ENDIF AUTOREFCOUNT}
  end;
*)

{
  function TISObjList.First: TObject;
  begin
  Result := TObject(inherited First);
  end;

  function TISObjList.GetItem(Index: Integer): TObject;
  begin
  Result := inherited Items[Index];
  end;


  function TISObjList.IndexOf(AObject: TObject): Integer;
  begin
  Result := inherited IndexOf(AObject);
  end;

  function TISObjList.IndexOfItem(AObject: TObject; ADirection: TList.TDirection): Integer;
  begin
  Result := inherited IndexOfItem(AObject, ADirection);
  end;


  procedure TISObjList.Insert(Index: Integer; AObject: TObject);
  begin
  inherited Insert(Index, AObject);
  end;

  {
  function TISObjList.Last: TObject;
  begin
  Result := TObject(inherited Last);
  end;
}
procedure TISObjList.Notify(Ptr: Pointer; Action: TListNotification);
begin
{$IFDEF AUTOREFCOUNT}
  if Ptr <> nil then
    Case Action Of
      lnDeleted:
        Begin
          if OwnsObjects then
            TObject(Ptr).DisposeOf;
          TObject(Ptr).__ObjRelease;
          // __MarkDestroying(Ptr);
        end;
      lnAdded:
        TObject(Ptr).__ObjAddRef;
      lnExtracted:
        TObject(Ptr).__ObjRelease;
    end;
{$ELSE}
  if (Action = lnDeleted) and OwnsObjects then
    TObject(Ptr).Free;
{$ENDIF AUTOREFCOUNT}
  inherited Notify(Ptr, Action);
end;

(*
  procedure TISObjList.PutObj(Index: Integer; Item: Pointer);
  var
  Temp: Pointer;
  begin
  if (Index < 0) or (Index >= Count) then
  Error(@SListIndexError, Index);

  if Item <> Items[Index] then
  begin
  if Items[Index]<>nil then
  {$IFDEF AUTOREFCOUNT}
  TObject(Items[Index]).__ObjRelease;
  {$ENDIF AUTOREFCOUNT}
  Inherited Put(Index,Item);
  end;
  {$IFDEF AUTOREFCOUNT}
  if Item<>nil then
  TObject(Item).__ObjAddRef;
  {$ENDIF AUTOREFCOUNT}
  end;

  function TISObjList.Remove(AObject: TObject): Integer;
  begin
  Result := inherited Remove(AObject);
  {$IFDEF AUTOREFCOUNT} ? ?
  if Result <> 01 then
  AObject.__ObjRelease;
  {$ENDIF AUTOREFCOUNT}
  end;

  function TISObjList.RemoveItem(AObject: TObject;
  ADirection: TList.TDirection): Integer;
  begin
  Result := inherited RemoveItem(AObject, ADirection);
  {$IFDEF AUTOREFCOUNT}
  if Result <> 01 then
  AObject.__ObjRelease;
  {$ENDIF AUTOREFCOUNT}
  end;

  procedure TISObjList.SetItem(Index: Integer; AObject: TObject);
  begin
  inherited Items[Index] := AObject;
  end;
*)

{ TISStringPtrList }

destructor TISStringPtrList.Destroy;
{ var
  I: Integer;
  Temp: TArray<TObject>; }
begin
  { FOnChange := nil;
    FOnChanging := nil;

    // If the list owns the Objects gather them and free after the list is disposed
    if OwnsObjects then
    begin
    SetLength(Temp, FCount);
    for I := 0 to FCount - 1 do
    Temp[I] := FList[I].FObject;
    end;
  }
  Try
    DisposeOfAndNil(TObject(FStringsAsList));
  Except
  end;
  inherited Destroy;
  FCount := 0;
  SetCapacity(0);

  { // Free the objects that were owned by the list
    if Length(Temp) > 0 then
    for I := 0 to Length(Temp) - 1 do
    Temp[I].DisposeOf; }
end;

function TISStringPtrList.Add(const S: string): Integer;
begin
  Result := AddObject(S, nil);
end;

function TISStringPtrList.AddObject(const S: string; AObject: Pointer): Integer;
begin
  if not Sorted then
    Result := FCount
  else if Find(S, Result) then
    case Duplicates of
      dupIgnore:
        Exit;
      dupError:
        Error(@SDuplicateString, 0);
    end;
  InsertItem(Result, S, AObject);
end;

procedure TISStringPtrList.AddStrings(Strings: TStrings);
var
  I: Integer;
begin
  if Strings is TISStringPtrList then
  Begin
    BeginUpdate;
    try
      for I := 0 to Strings.Count - 1 do
        AddObject(Strings[I], TISStringPtrList(Strings).Objects[I]);
    finally
      EndUpdate;
    end;
  End
  Else
    Inherited;
end;

procedure TISStringPtrList.Assign(Source: TPersistent);
begin
  if Source is TISStringPtrList then
  begin
    FCaseSensitive := TISStringPtrList(Source).FCaseSensitive;
    FDuplicates := TISStringPtrList(Source).FDuplicates;
    FSorted := TISStringPtrList(Source).FSorted;
  end;
  inherited Assign(Source);
end;

function TISStringPtrList.AsTStringsOfObjects: TStrings;
Var
  I: Integer;
  ThisList: TIsIntPtrStrings;
  StoreObj: TIsIntPtrStringsObject;
begin
  FreeAndNil(FStringsAsList);
  ThisList := TIsIntPtrStrings.Create;
  FStringsAsList := ThisList;
  FStringsAsList.Duplicates := Duplicates;
  FStringsAsList.Sorted := Sorted;
  FStringsAsList.CaseSensitive := CaseSensitive;

  for I := 0 to Count - 1 do
  begin
    case FActiveType of
      SplPointers:
        FStringsAsList.AddPointer(Strings[I], Objects[I]);
      SplIntegers:
        FStringsAsList.AddInteger(Strings[I], Integer(Objects[I]));
      SplObjects:
        FStringsAsList.AddObject(Strings[I], TObject(Objects[I]));
    end;
  end;

  Result := FStringsAsList;
end;

procedure TISStringPtrList.Clear;
{ var
  I: Integer;
  Temp: TArray<TObject>; }
begin
  if FCount <> 0 then
  begin
    FCount := 0;
    SetCapacity(0);
  end;
end;

procedure TISStringPtrList.Delete(Index: Integer);
// var
// Obj: TObject;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  { Changing;
    // If this list owns its objects then free the associated TObject with this index
    if OwnsObjects then
    Obj := FList[Index].FObject
    else
    Obj := nil;
  }
  // Direct memory writing to managed array follows
  // see http://dn.embarcadero.com/article/33423
  // Explicitly finalize the element we about to stomp on with move
  Finalize(FList[Index]);
  Dec(FCount);
  if Index < FCount then
  begin
    System.Move(FList[Index + 1], FList[Index],
      (FCount - Index) * SizeOf(TStringItemWPtr));
    // Make sure there is no danglng pointer in the last (now unused) element
    PPointer(@FList[FCount].FString)^ := nil;
    PPointer(@FList[FCount].FObject)^ := nil;
  end;
  { if Obj <> nil then
    Obj.Free;
    Changed; }
end;

procedure TISStringPtrList.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then
    Error(@SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then
    Error(@SListIndexError, Index2);
  // Changing;
  ExchangeItems(Index1, Index2);
  // Changed;
end;

procedure TISStringPtrList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Pointer;
  Item1, Item2: PStringItemWPtr;
begin
  Item1 := @FList[Index1];
  Item2 := @FList[Index2];
  Temp := Pointer(Item1^.FString);
  Pointer(Item1^.FString) := Pointer(Item2^.FString);
  Pointer(Item2^.FString) := Temp;
  Temp := Pointer(Item1^.FObject);
  Pointer(Item1^.FObject) := Pointer(Item2^.FObject);
  Pointer(Item2^.FObject) := Temp;
end;

function TISStringPtrList.Find(const S: string; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList[I].FString, S);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then
          L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure TISStringPtrList.FreeInstance;
begin
  inherited;
  DecObjectCount(Self);
end;

function TISStringPtrList.Get(Index: Integer): string;
begin
  if Cardinal(Index) >= Cardinal(FCount) then
    Error(@SListIndexError, Index);
  Result := FList[Index].FString;
end;

function TISStringPtrList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TISStringPtrList.GetCount: Integer;
begin
  Result := FCount;
end;

function TISStringPtrList.GetObject(Index: Integer): Pointer;
begin
  if Cardinal(Index) >= Cardinal(FCount) then
    Error(@SListIndexError, Index);
  Result := FList[Index].FObject;
end;

procedure TISStringPtrList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else if FCapacity > 8 then
    Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TISStringPtrList.IndexOf(const S: string): Integer;
begin
  if not Sorted then
    Result := inherited IndexOf(S)
  else if not Find(S, Result) then
    Result := -1;
end;

function TISStringPtrList.IndexOfInteger(AObjectRef: Integer): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if (Integer(GetObject(Result)) = AObjectRef) then
      Exit;
  Result := -1;
end;

function TISStringPtrList.IndexOfObject(AObject: Pointer): Integer;
begin
  Result := IndexOfPointer(AObject);
end;

function TISStringPtrList.IndexOfPointer(AObject: Pointer): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then
      Exit;
  Result := -1;
end;

procedure TISStringPtrList.Insert(Index: Integer; const S: string);
begin
  InsertObject(Index, S, nil);
end;

procedure TISStringPtrList.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
begin
  if Sorted then
    Error(@SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then
    Error(@SListIndexError, Index);
  InsertItem(Index, S, AObject);
end;

procedure TISStringPtrList.InsertItem(Index: Integer; const S: string;
  AObject: Pointer);
begin
  if FCount = FCapacity then
    Grow;
  if Index < FCount then
    System.Move(FList[Index], FList[Index + 1],
      (FCount - Index) * SizeOf(TStringItemWPtr));
  Pointer(FList[Index].FString) := nil;
  Pointer(FList[Index].FObject) := nil;
  FList[Index].FObject := AObject;

  FList[Index].FString := S;
  Inc(FCount);
end;

procedure TISStringPtrList.Put(Index: Integer; const S: string);
begin
  if Sorted then
    Error(@SSortedListError, 0);
  if Cardinal(Index) >= Cardinal(FCount) then
    Error(@SListIndexError, Index);
  FList[Index].FString := S;
end;

procedure TISStringPtrList.PutItemPointer(Index: Integer; AItem: Pointer);
begin
  if Cardinal(Index) >= Cardinal(FCount) then
    Error(@SListIndexError, Index);
  FList[Index].FObject := AItem;
end;

procedure TISStringPtrList.PutObject(Index: Integer; AObject: TObject);
begin
  if Cardinal(Index) >= Cardinal(FCount) then
    Error(@SListIndexError, Index);
  FList[Index].FObject := AObject;
end;

procedure TISStringPtrList.QuickSort(L, R: Integer;
  SCompare: TStringPtrListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do
        Inc(I);
      while SCompare(Self, J, P) > 0 do
        Dec(J);
      if I <= J then
      begin
        if I <> J then
          ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TISStringPtrList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity < FCount then
    Error(@SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    SetLength(FList, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;

procedure TISStringPtrList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then
      Sort;
    FSorted := Value;
  end;
end;

procedure FreeListFO(var ThisList: TISObjList); overload;
Var
  LList: TISObjList;
begin
  if ThisList = nil then
    Exit;
  if ThisList.OwnsObjects then
{$IFDEF AUTOREFCOUNT}
  begin
    LList := ThisList;
    ThisList := nil;
    LList.DisposeOf;
  end
{$ELSE}
  FreeAndNil(ThisList)
{$ENDIF}
  else
    FreeListFO(TList(ThisList));
  // FreeListFO is used to dispose all contained objects
end;

procedure FreeSListFO(var AList: TIsIntPtrStrings); overload;
var
  I: Integer;
  ThisList: TIsIntPtrStrings;
  Obj: TObject;
  S: string;
begin
  if AList = nil then
    Exit;

  ThisList := AList;
  AList := nil;
  for I := 0 to ThisList.Count - 1 do
    if ThisList.Objects[I] is TIsIntPtrStringsObject then
    Begin
{$IFDEF DEBUG}
      S := inttostr(I);
{$ENDIF}
      Obj := TIsIntPtrStringsObject(ThisList.Objects[I]).StoredObj;
      try
        TIsIntPtrStringsObject(ThisList.Objects[I]).StoredObj := nil;
        Obj.Free;
      except
        S := 'bbbbb ' + S;
      end;
    End;
  ThisList.Free;
end;

procedure FreeSListFO(var AList: TISStringPtrList); overload;
// implies we want to delete any obects in objects
var
  I: Integer;
  ThisList: TISStringPtrList;
  Obj: TObject;
  S: string;
begin
  if AList = nil then
    Exit;

  ThisList := AList;
  AList := nil;
  for I := 0 to ThisList.Count - 1 do
    if ThisList.Objects[I] <> nil then
    Begin
{$IFDEF DEBUG}
      S := inttostr(I);
{$ENDIF}
      try
        Obj := TObject(ThisList.Objects[I]);
        ThisList.Objects[I] := nil;
        Obj.DisposeOf;
      except
        S := 'bbbbb ' + S;
      end;
    End;
  ThisList.DisposeOf;
end;

function StringPtrListCompareStrings(List: TISStringPtrList;
  Index1, Index2: Integer): Integer;
begin
  Result := List.CompareStrings(List.FList[Index1].FString,
    List.FList[Index2].FString);
end;

procedure TISStringPtrList.Sort;
begin
  CustomSort(StringPtrListCompareStrings);
end;

procedure TISStringPtrList.CustomSort(Compare: TStringPtrListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    // Changing;
    QuickSort(0, FCount - 1, Compare);
    // Changed;
  end;
end;

function TISStringPtrList.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TISStringPtrList.Create;
begin
  FActiveType := SplPointers;
  inherited Create;
  IncObjectCount(Self);
end;

{ constructor TISStringPtrList.Create(OwnsObjects: Boolean);
  begin
  inherited Create;
  FOwnsObject := OwnsObjects;
  end;
}

procedure TISStringPtrList.SetCaseSensitive(const Value: Boolean);
begin
  if Value <> FCaseSensitive then
  begin
    FCaseSensitive := Value;
    if Sorted then
    begin
      // Calling Sort won't sort the list because CustomSort will
      // only sort the list if it's not already sorted
      Sorted := False;
      Sorted := True;
    end;
  end;
end;

{ TIsIntPtrStrings }

function TIsIntPtrStrings.AddInteger(const S: string;
  AIntegerForObj: Integer): Integer;
Var
  Obj: TIsIntPtrStringsObject;
begin
  Obj := TIsIntPtrStringsObject.Create;
  Obj.StoreInt := AIntegerForObj;
  Result := AddObject(S, Obj);
  if Result < 0 then
    Obj.Free;
end;

function TIsIntPtrStrings.AddObject(const S: string; AObject: TObject): Integer;
Var
  Obj: TIsIntPtrStringsObject;
  // Ref counting works as objects are stored?
begin
  if AObject is TIsIntPtrStringsObject then
    Result := inherited AddObject(S, AObject)
  Else
  begin
    Obj := TIsIntPtrStringsObject.Create;
    Obj.StoredObj := AObject;
    Result := inherited AddObject(S, Obj);
    if Result < 0 then
      Obj.Free;
  end;
end;

function TIsIntPtrStrings.AddPointer(const S: string;
  APtrForObj: Pointer): Integer;
Var
  Obj: TIsIntPtrStringsObject;
  // Ref counting works as object is stored and it holds the pointer
begin
  Obj := TIsIntPtrStringsObject.Create;
  Obj.StorePointer := APtrForObj;
  Result := AddObject(S, Obj);
  if Result < 0 then
    Obj.Free;
end;

constructor TIsIntPtrStrings.Create;
begin
  inherited;
  IncObjectCount(Self);
end;

destructor TIsIntPtrStrings.Destroy;
Var
  I: Integer;
  Obj: TObject;
begin
  for I := Count - 1 downto 0 do
  Begin
    Obj := Objects[I];
    Objects[I] := nil;
    If Obj <> nil then
      try
        Obj.DisposeOf;
      except
      end;
  End;
  inherited;
end;

procedure TIsIntPtrStrings.FreeInstance;
begin
  DecObjectCount(Self);
  inherited;
end;

function TIsIntPtrStrings.GetActualObject(Index: Integer): TObject;
Var
  ListObj: TIsIntPtrStringsObject;
begin
  Result := nil;
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    Result := ListObj.StoredObj;
end;

function TIsIntPtrStrings.GetInteger(Index: Integer): Integer;
Var
  ListObj: TIsIntPtrStringsObject;
begin
  Result := 0;
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    Result := ListObj.StoreInt;
end;

function TIsIntPtrStrings.GetPointer(Index: Integer): Pointer;
Var
  ListObj: TIsIntPtrStringsObject;
begin
  Result := nil;
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    Result := ListObj.StorePointer;
end;

function TIsIntPtrStrings.IndexToObjectWithInBounds(AIndex: Integer)
  : TIsIntPtrStringsObject;
Var
  ListObj: TIsIntPtrStringsObject;
  Obj: TObject;
begin
  Result := nil;
  if (AIndex > 0) and (AIndex < Count) then
    Obj := Objects[AIndex]
  Else
    Obj := nil;
  if Obj = nil then
    Exit;

  if (Obj is TIsIntPtrStringsObject) then
    Result := Obj as TIsIntPtrStringsObject
  else
    Raise Exception.Create('Non TIsIntPtrStringsObject on List');

end;

procedure TIsIntPtrStrings.PutActualObject(Index: Integer;
  const Value: TObject);
Var
  ListObj: TIsIntPtrStringsObject;
begin
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    ListObj.StoredObj := Value
  Else
    Raise Exception.Create('No Storeage Object at Index');
end;

procedure TIsIntPtrStrings.PutInteger(Index: Integer; const Value: Integer);
Var
  ListObj: TIsIntPtrStringsObject;
begin
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    ListObj.StoreInt := Value
  Else
    Raise Exception.Create('No Storeage Object at Index');
end;

procedure TIsIntPtrStrings.PutPointer(Index: Integer; const Value: Pointer);
Var
  ListObj: TIsIntPtrStringsObject;
begin
  ListObj := IndexToObjectWithInBounds(Index);
  if ListObj <> nil then
    ListObj.StorePointer := Value
  Else
    Raise Exception.Create('No Storeage Object at Index');
end;

{ TIsIntPtrStringsObject }

constructor TIsIntPtrStringsObject.Create;
begin
  inherited;
  IncObjectCount(Self);
end;

procedure TIsIntPtrStringsObject.FreeInstance;
begin
  DecObjectCount(Self);
  inherited;
end;

end.

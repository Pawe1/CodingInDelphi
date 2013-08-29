unit RttiContext_GetTypes_vs_GetType_on_Interfaces_ConsoleUnit;

interface

uses
  System.SysUtils,
  System.Rtti;

type
  IPublicImplementedInterface = interface(IInterface)
  ['{E1962EFF-64CD-4ABB-9C44-1503E3CE77A9}']
  end;

  IPublicNonImplementedInterface = interface(IInterface)
  ['{AD72354C-BD8D-4453-8838-A9C261115A25}']
  end;

  IPublicNonImplementedInterfaceThatHasNoTypeInfoCalls = interface(IInterface)
  ['{A846E993-EF55-4463-93F1-E7979D17F605}']
  end;

  TPublicImplementingObject = class(TInterfacedObject, IPublicImplementedInterface)
  end;

  IPublicImplementedInterfaceThatHasNoTypeInfoCalls = interface(IInterface)
  ['{D471001B-77CA-4B8E-87D4-1AF1F17C0128}']
  end;

  TPublicImplementingObjectWithoutTypeInfoCalls = class(TInterfacedObject, IPublicImplementedInterfaceThatHasNoTypeInfoCalls)
  end;

procedure Main();

implementation

uses
  RttiHelpers, System.TypInfo;

type
  IPrivateImplementedInterface = interface(IInterface)
  ['{E1962EFF-64CD-4ABB-9C44-1503E3CE77A9}']
  end;

  IPrivateNonImplementedInterface = interface(IInterface)
  ['{AD72354C-BD8D-4453-8838-A9C261115A25}']
  end;

  IPrivateNonImplementedInterfaceThatHasNoTypeInfoCalls = interface(IInterface)
  ['{A846E993-EF55-4463-93F1-E7979D17F605}']
  end;

  TPrivateImplementingObject = class(TInterfacedObject, IPrivateImplementedInterface)
  end;

  IPrivateImplementedInterfaceThatHasNoTypeInfoCalls = interface(IInterface)
  ['{D471001B-77CA-4B8E-87D4-1AF1F17C0128}']
  end;

  TPrivateImplementingObjectWithoutTypeInfoCalls = class(TInterfacedObject, IPrivateImplementedInterfaceThatHasNoTypeInfoCalls)
  end;

procedure Log(const RttiInterfaceType: TRttiInterfaceType);
begin
  Writeln(Format('Found GUID "%s" with best name "%s"', [RttiInterfaceType.GUID.ToString(), RttiInterfaceType.GetBestName()]));
end;

function GetRttiInterfaceType(const RttiContext: TRttiContext; const ATypeInfo: Pointer): TRttiInterfaceType; overload;
begin
  Result := RttiContext.GetType(ATypeInfo) as TRttiInterfaceType;
//  if Assigned(Result) then
//    Log(Result);
end;

procedure ReportRttiTypesComparison(const RttiType_ByGUID, RttiType_ByInterfaceTypeInfo: TRttiInterfaceType; const InterfaceName: string);
var
  GUIDbyGUID: string;
begin
  if Assigned(RttiType_ByGUID) then
  begin
    GUIDbyGUID := GUIDToString(RttiType_ByGUID.GUID);
    if Assigned(RttiType_ByInterfaceTypeInfo) then
    begin
      Write('RTTI by GUID and RTTI by TypeInfo have ');
      if (RttiType_ByGUID.GUID = RttiType_ByInterfaceTypeInfo.GUID) then
        Writeln('the same GUID: ', GUIDbyGUID)
      else
        Writeln(Format('different GUIDs; by GUID: %s, byte TypeInfo: %s', [GUIDbyGUID, GUIDToString(RttiType_ByInterfaceTypeInfo.GUID)]));
    end
    else
      Writeln('RTTI by TypeInfo is nil, but RTTI by GUID has a GUID: ', GUIDbyGUID);
  end
  else
  begin
    if Assigned(RttiType_ByInterfaceTypeInfo) then
      Writeln('RTTI by GUID is nil, but RTTI by TypeInfo has a GUID: ', GUIDToString(RttiType_ByInterfaceTypeInfo.GUID))
    else
      Writeln('RTTI by GUID and RTTI by TypeInfo are both nil.');
  end;
end;

procedure ReportRttiTypes(const RttiContext: TRttiContext; const
    AInterfaceGUID: TGUID; const InterfaceName: string; const
    InterfaceTypeInfo: Pointer);
var
  RttiType_ByInterfaceTypeInfo: TRttiInterfaceType;
  RttiType_ByGUID: TRttiInterfaceType;
  NameFromTypeInfo: string;
  NameFromGuid: string;
begin
  Writeln(Format('TRttiType occurances for interface "%s" with GUID "%s"', [InterfaceName, AInterfaceGUID.ToString()]));

  if Assigned(InterfaceTypeInfo) then
  begin
    RttiType_ByInterfaceTypeInfo := GetRttiInterfaceType(RttiContext, InterfaceTypeInfo);
    if (nil = RttiType_ByInterfaceTypeInfo) then
      Writeln('  no RttiInterfaceType from InterfaceTypeInfo')
    else
      Writeln('  GUID from InterfaceTypeInfo: ', RttiType_ByInterfaceTypeInfo.GUID.ToString());
  end
  else
  begin
    Writeln('  no InterfaceTypeInfo');
    RttiType_ByInterfaceTypeInfo := nil;
  end;

  RttiType_ByGUID := RttiContext.FindType(AInterfaceGUID);
  if (nil = RttiType_ByGUID) then
    Writeln(Format('  RttiInterfaceType not found through GUID "%s"', [GUIDToString(AInterfaceGUID)]))
  else
  begin
    if (nil <> RttiType_ByInterfaceTypeInfo) then
    begin
      if (RttiType_ByGUID.GUID <> RttiType_ByInterfaceTypeInfo.GUID) then
        Writeln('  GUID mismatch: ', RttiType_ByGUID.GUID.ToString());

      NameFromGuid := RttiType_ByGUID.GetBestName();
      NameFromTypeInfo := RttiType_ByInterfaceTypeInfo.GetBestName();
      if (NameFromGuid <> NameFromTypeInfo) then
        Writeln('  name mismatch: ', NameFromGuid, ' <> ', NameFromTypeInfo);
      Writeln('  RttiInterfaceType found by TypeInfo:');
      Write('    ');
      Log(RttiType_ByInterfaceTypeInfo);
    end;
    Writeln('  RttiInterfaceType found by GUID:');
    Write('    ');
    Log(RttiType_ByGUID);
  end;

  ReportRttiTypesComparison(RttiType_ByGUID, RttiType_ByInterfaceTypeInfo, InterfaceName);

  Writeln;
end;

procedure ReportImplementedInterfacesByClass(const RttiContext: TRttiContext; const ClassReference: TClass);
type
  PIntfs = ^TIntfs;
  TIntfs = array[0..9999{EntryCount - 1}] of PPTypeInfo;
  // From the System unit; Intfs is right after the TInterfaceEntry.Entries table
  //    {Intfs: array[0..EntryCount - 1] of PPTypeInfo;}
var
  CurrentClassReference: TClass;
  EntryCount: Integer;
  Index : integer;
  InterfaceTable: PInterfaceTable;
  InterfaceTable_Intfs: PIntfs;
  InterfaceEntry: PInterfaceEntry;
  InterfaceGUID: TGUID;
  RttiType_ByGUID: TRttiInterfaceType;
begin
  CurrentClassReference := ClassReference;
  while Assigned(CurrentClassReference) do
  begin
    InterfaceTable := CurrentClassReference.GetInterfaceTable;
    if Assigned(InterfaceTable) then
    begin
      EntryCount := InterfaceTable.EntryCount;
      Writeln(Format('"%s" implements %d interfaces:', [CurrentClassReference.QualifiedClassName, EntryCount]));
      InterfaceTable_Intfs := @InterfaceTable.Entries[EntryCount]; // right after the final Entries entry.
      for Index := 0 to EntryCount-1 do
      begin
        InterfaceEntry := @InterfaceTable.Entries[Index];
        InterfaceGUID := InterfaceEntry.IID;
        Writeln(Format('  Interface at index %d has GUID "%s"', [Index, GUIDToString(InterfaceGUID)]));

        RttiType_ByGUID := RttiContext.FindType(InterfaceGUID);
        if (nil = RttiType_ByGUID) then
          Writeln(Format('  interface RTTI not found through GUID "%s"', [GUIDToString(InterfaceGUID)]))
        else
        begin
          Write('  ');
          Log(RttiType_ByGUID);
        end;
      end;
    end
    else
      Writeln(CurrentClassReference.QualifiedClassName, ' implements no interfaces');
    CurrentClassReference := CurrentClassReference.ClassParent;
  end;
  Writeln;
end;

procedure Main();
var
  PublicImplementedInterfaceReference: IPublicImplementedInterface;
  PublicImplementedInterfaceThatHasNoTypeInfoCallsReference: IPublicImplementedInterfaceThatHasNoTypeInfoCalls;
  PrivateImplementedInterfaceReference: IPrivateImplementedInterface;
  PrivateImplementedInterfaceThatHasNoTypeInfoCallsReference: IPrivateImplementedInterfaceThatHasNoTypeInfoCalls;
  RttiContext: TRttiContext;
begin
  PublicImplementedInterfaceReference := TPublicImplementingObject.Create();
  PublicImplementedInterfaceThatHasNoTypeInfoCallsReference := TPublicImplementingObjectWithoutTypeInfoCalls.Create();

  PrivateImplementedInterfaceReference := TPrivateImplementingObject.Create();
  PrivateImplementedInterfaceThatHasNoTypeInfoCallsReference := TPrivateImplementingObjectWithoutTypeInfoCalls.Create();

  RttiContext := TRttiContext.Create();
  try
    // interface from other unit
    ReportRttiTypes(RttiContext, IInterface, 'IInterface', TypeInfo(IInterface));

    Writeln;
    ReportRttiTypes(RttiContext, IPublicImplementedInterface, 'IPublicImplementedInterface', TypeInfo(IPublicImplementedInterface));
    ReportRttiTypes(RttiContext, IPublicNonImplementedInterface, 'IPublicNonImplementedInterface', TypeInfo(IPublicNonImplementedInterface));
    // we don't want to call TypeInfo on IPublicNonImplementedInterfaceThatHasNoTypeInfoCalls and IPublicImplementedInterfaceThatHasNoTypeInfoCalls
    ReportRttiTypes(RttiContext, IPublicNonImplementedInterfaceThatHasNoTypeInfoCalls, 'IPublicNonImplementedInterfaceThatHasNoTypeInfoCalls', nil);
    ReportRttiTypes(RttiContext, IPublicImplementedInterfaceThatHasNoTypeInfoCalls, 'IPublicImplementedInterfaceThatHasNoTypeInfoCalls', nil);

    Writeln;
    ReportRttiTypes(RttiContext, IPrivateImplementedInterface, 'IPrivateImplementedInterface', TypeInfo(IPrivateImplementedInterface));
    ReportRttiTypes(RttiContext, IPrivateNonImplementedInterface, 'IPrivateNonImplementedInterface', TypeInfo(IPrivateNonImplementedInterface));
    // we don't want to call TypeInfo on IPrivateNonImplementedInterfaceThatHasNoTypeInfoCalls and IPrivateImplementedInterfaceThatHasNoTypeInfoCalls
    ReportRttiTypes(RttiContext, IPrivateNonImplementedInterfaceThatHasNoTypeInfoCalls, 'IPrivateNonImplementedInterfaceThatHasNoTypeInfoCalls', nil);
    ReportRttiTypes(RttiContext, IPrivateImplementedInterfaceThatHasNoTypeInfoCalls, 'IPrivateImplementedInterfaceThatHasNoTypeInfoCalls', nil);

    Writeln;
    ReportImplementedInterfacesByClass(RttiContext, TPublicImplementingObject);
    ReportImplementedInterfacesByClass(RttiContext, TPublicImplementingObjectWithoutTypeInfoCalls);

    Writeln;
    ReportImplementedInterfacesByClass(RttiContext, TPrivateImplementingObject);
    ReportImplementedInterfacesByClass(RttiContext, TPrivateImplementingObjectWithoutTypeInfoCalls);
  finally
    RttiContext.Free;
  end;
end;

end.

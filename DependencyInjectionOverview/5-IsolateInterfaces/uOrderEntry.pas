unit uOrderEntry;

interface

uses
  uOrder,
  uOrderInterfaces;

type
  TOrderEntry = class(TInterfacedObject, IOrderEntry)
  public
    function EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
  end;

implementation

function TOrderEntry.EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
begin
  Result := Assigned(aOrder);
  {$IFDEF CONSOLEAPP}
  Writeln('Entering order into the database, at a cost of $1....');
  {$ENDIF}
end;

end.
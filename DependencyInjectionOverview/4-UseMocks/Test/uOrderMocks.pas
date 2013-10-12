unit uOrderMocks;

interface

uses
  uOrderEntry, uOrder, uOrderValidator;

type
  TMockOrderEntry = class(TInterfacedObject, IOrderEntry)
    function EnterOrderIntoDatabase(aOrder: TOrder): Boolean;
  end;

  TMockOrderValidator = class(TInterfacedObject, IOrderValidator)
    function ValidateOrder(aOrder: TOrder): Boolean;
  end;

implementation


{ TMockOrderEntry }

function TMockOrderEntry.EnterOrderIntoDatabase(aOrder: TOrder): Boolean;
begin
  Result := True;
end;

{ TMockOrderValidator }

function TMockOrderValidator.ValidateOrder(aOrder: TOrder): Boolean;
begin
  Result := True;
end;

end.

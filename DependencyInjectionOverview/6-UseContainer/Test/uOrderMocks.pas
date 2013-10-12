unit uOrderMocks;

interface


implementation

uses
      uOrder
    , uOrderInterfaces
    , Spring.Container
    ;


type
  TMockOrderEntry = class(TInterfacedObject, IOrderEntry)
    function EnterOrderIntoDatabase(aOrder: TOrder): Boolean;
  end;

  TMockOrderValidator = class(TInterfacedObject, IOrderValidator)
    function ValidateOrder(aOrder: TOrder): Boolean;
  end;

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

initialization
  GlobalContainer.RegisterComponent<TMockOrderEntry>.Implements<IOrderEntry>;
  GlobalContainer.RegisterComponent<TMockOrderValidator>.Implements<IOrderValidator>;

end.

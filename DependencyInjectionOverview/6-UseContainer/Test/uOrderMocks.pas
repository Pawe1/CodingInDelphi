unit uOrderMocks;

interface

implementation

uses
  uOrder,
  uOrderInterfaces,
  Spring.Container;

type
  TMockOrderEntry = class(TInterfacedObject, IOrderEntry)
    function EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
  end;

  TMockOrderValidator = class(TInterfacedObject, IOrderValidator)
    function ValidateOrder(const aOrder: TOrder): Boolean;
  end;

function TMockOrderEntry.EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
begin
  Result := True;
end;

function TMockOrderValidator.ValidateOrder(const aOrder: TOrder): Boolean;
begin
  Result := True;
end;

initialization
  GlobalContainer.RegisterType<TMockOrderEntry>();
  GlobalContainer.RegisterType<TMockOrderValidator>();
{ There is no need for the .Implements<T> part, as that is inferred within RegisterType.
  GlobalContainer.RegisterComponent<TMockOrderEntry>.Implements<IOrderEntry>;
  GlobalContainer.RegisterComponent<TMockOrderValidator>.Implements<IOrderValidator>;
}
end.

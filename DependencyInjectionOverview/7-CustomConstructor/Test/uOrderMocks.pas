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
end.

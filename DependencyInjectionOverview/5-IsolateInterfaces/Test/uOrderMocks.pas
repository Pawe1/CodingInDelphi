unit uOrderMocks;

interface

uses
  uOrder,
  uOrderInterfaces;

type
  TMockOrderEntry = class(TInterfacedObject, IOrderEntry)
    function EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
  end;

  TMockOrderValidator = class(TInterfacedObject, IOrderValidator)
    function ValidateOrder(const aOrder: TOrder): Boolean;
  end;

implementation

function TMockOrderEntry.EnterOrderIntoDatabase(const aOrder: TOrder): Boolean;
begin
  Result := True;
end;

function TMockOrderValidator.ValidateOrder(const aOrder: TOrder): Boolean;
begin
  Result := True;
end;

end.

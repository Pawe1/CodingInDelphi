unit TestuOrderProcessor;

interface

uses
  TestFramework,
  uOrderInterfaces;

type
  TestTOrderProcessor = class(TTestCase)
  strict private
    FOrderProcessor: IOrderProcessor;
  public
    procedure SetUp(); override;
  published
    procedure TestProcessOrder;
  end;

implementation

uses
  uOrder,
  uOrderValidator,
  uOrderEntry,
  uOrderProcessor;

procedure TestTOrderProcessor.SetUp();
var
  OrderEntry: IOrderEntry;
  OrderValidator: IOrderValidator;
begin
  OrderValidator := TOrderValidator.Create();
  OrderEntry := TOrderEntry.Create();
  FOrderProcessor := TOrderProcessor.Create(OrderValidator, OrderEntry);
end;

procedure TestTOrderProcessor.TestProcessOrder;
var
  Order: TOrder;
begin
  Order := TOrder.Create();
  try
    // We can check success, but...
    Check(FOrderProcessor.ProcessOrder(Order));
    // how do we check that the order really made it to the database?
    // Or do we even want to....?
  finally
    Order.Free;
  end;
end;

initialization
  RegisterTest(TestTOrderProcessor.Suite);
end.


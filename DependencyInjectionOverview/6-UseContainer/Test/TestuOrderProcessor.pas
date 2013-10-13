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
    procedure TestProcessOrder();
  end;

implementation

uses
  uOrder,
  uOrderProcessor,
  Spring.Container,
  Spring.Services;

procedure TestTOrderProcessor.SetUp();
var
  OrderEntry: IOrderEntry;
  OrderValidator: IOrderValidator;
begin
  GlobalContainer.Build();
  OrderValidator := ServiceLocator.GetService<IOrderValidator>();
  OrderEntry := ServiceLocator.GetService<IOrderEntry>();
  FOrderProcessor := TOrderProcessor.Create(OrderValidator, OrderEntry);
end;

procedure TestTOrderProcessor.TestProcessOrder();
var
  Order: TOrder;
  ResultValue: Boolean;
begin
  Order := TOrder.Create();
  try
    ResultValue := FOrderProcessor.ProcessOrder(Order);
    Check(ResultValue);
  finally
    Order.Free;
  end;
end;

initialization
  RegisterTest(TestTOrderProcessor.Suite);
end.

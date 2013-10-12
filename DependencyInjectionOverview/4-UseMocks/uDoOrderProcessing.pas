unit uDoOrderProcessing;

interface

procedure DoOrderProcessing;

implementation

uses
  uOrder,
  uOrderProcessor,
  uOrderValidatorMock,
  uOrderEntryMock;

procedure DoOrderProcessing;
var
  Order: TOrder;
  OrderProcessor: IOrderProcessor;
begin
  Order := TOrder.Create;
  try
    OrderProcessor := TOrderProcessor.Create(TOrderValidatorMock.Create, TOrderEntryMock.Create);
    if OrderProcessor.ProcessOrder(Order) then
    begin
      {$IFDEF CONSOLEAPP}
      Writeln('Order successfully processed....');
      {$ENDIF}
    end;
  finally
    Order.Free;
  end;
end;

end.

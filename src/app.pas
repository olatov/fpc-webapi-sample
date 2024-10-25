program FpcWebApiSample;

{$mode objfpc}{$H+}

uses
  {$ifdef UNIX}
  cthreads, cmem,
  {$endif}
  DateUtils,
  SysUtils,
  FPHttpApp, HttpDefs, HttpRoute,
  FPJson;

const
    DefaultPort = 8080;

var
    Port: Integer = DefaultPort;

procedure HomePageRoute(Request: TRequest; Response: TResponse);
begin
    Response.Content :=
        '<!DOCTYPE html><html><body>' +
        '<h1>Hello!</h1>' + 
        '<p>See the API under <a href="/api">/api</a></p>' +
        '</body></html>';
end;

procedure ApiEndpointRoute(Request: TRequest; Response: TResponse);
var
    Data: TJsonObject;
    RequestId: TGuid;
begin
    Data := TJsonObject.Create();
    try
        CreateGuid(RequestId);
        Data.Strings['requestId'] := GuidToString(RequestId);
        Data.Strings['dateTime'] := DateToIso8601(Now());
        Data.Booleans['success'] := true;
        Data.Integers['version'] := 1;

        Response.Content := Data.AsJson;  // change to data.FormatJson for pretty JSON
        Response.ContentType := 'application/json';
    finally
        FreeAndNil(Data);
    end;
end;


begin
    Writeln('Starting...');

    HttpRouter.RegisterRoute('/', @HomePageRoute);
    HttpRouter.RegisterRoute('/api', @ApiEndpointRoute);

    if ParamCount > 0 then
        Port := StrToInt(ParamStr(1));

    Application.Port := Port;
    Application.Threaded := true;

    Application.Initialize();

    Writeln('Listening port ', Port);
    // Application.QueueSize := 50;

    Flush(Output);  // Force the above Writelns to print out

    Application.Run();
end.

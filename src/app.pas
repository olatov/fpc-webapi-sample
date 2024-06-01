program FpcWebApiSample;

{$mode objfpc}{$H+}

uses
  {$ifdef UNIX}
  cthreads, cmem,
  {$endif}
  fphttpapp, httpdefs, httproute,
  fpjson,
  SysUtils;

const
    DefaultPort = 8080;

var
    port: integer = DefaultPort;

procedure HomePageRoute(request: TRequest; response: TResponse);
begin
    response.Content := 
        '<!DOCTYPE html><html><body>' +
        '<h1>Hello!</h1>' + 
        '<p>See the API under <a href="/api">/api</a></p>' +
        '</body></html>';
end;

procedure ApiEndpointRoute(request: TRequest; response: TResponse);
var
    data: TJsonObject;
    requestId: TGuid;
begin
    data := TJsonObject.Create();

    CreateGUID(requestId);
    data.Strings['requestId'] := GUIDToString(requestId);
    data.Strings['dateTime'] := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Now);
    data.Booleans['success'] := true;
    data.Integers['version'] := 1;

    response.Content := data.AsJson;  // change to data.FormatJson for pretty JSON
    response.ContentType := 'application/json';

    data.Free();
end;


begin
    Writeln('Starting...');

    HTTPRouter.RegisterRoute('/', @HomePageRoute);
    HTTPRouter.RegisterRoute('/api', @ApiEndpointRoute);

    if ParamCount > 0 then
        port := StrToInt(ParamStr(1));

    Application.Port := port;
    Application.Threaded := true;

    Application.Initialize();

    Writeln('Listening port ' + IntToStr(port));
    // Application.QueueSize := 50;

    Application.Run();
end.

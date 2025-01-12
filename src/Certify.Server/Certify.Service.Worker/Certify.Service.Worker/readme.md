﻿Certify Service Worker (Cross Platform)
-----------------

# Architecture
- Certify.Server.Core, running as a hosted internal API app within a Worker (Certify.Service.Worker). This is a re-implementation of the original service usedby the desktop UI.
- Certify.Server.Api.Public, running as a API for public consumption, wrapping calls to the core internal API

The advantage of this structure is that the public API can be exposed to the network for Web UI access, without client machines talking directly to the core service. The public API can run as the least prvilelged service user, while the core service may require elevated privileges depending on how it is used.


Development workflow



Running Manually:

dotnet ./Certify.Service.Worker.dll

API will listen on http://localhost:32768 and https://localhost:44360
HTTPS certificate setup is configured in Program.cs
Initial setup should use invalid pfx for https, with valid PFX to be acquired from own API. API status should flag https cert status for UI to report.

WSL debug
---------
- set DebugType to portable in build.props to enable debugging
- in debug service will run from host pc with a mnt
- database and log are in /usr/share/certify from Environment.SpecialFolder.CommonApplicationData


Linux Install
------------

`apt-get certifytheweb`

`sudo mkdir /opt/certifytheweb`

Systemd
-----------
```
[Unit]
Description=Certify The Web

[Service]
ExecStart=dotnet /opt/certifytheweb/certify.service
WorkingDirectory=/opt/certifytheweb/
User=certifytheweb
Restart=on-failure
SyslogIdentifier=certifytheweb
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Windows Service
-----------------

` sc create "Certify Certificate Manager [dotnet]" binpath="C:\Work\GIT\certify_dev\certify\src\Certify.Server\Certify.Service.Worker\Certify.Service.Worker\bin\Debug\net8.0\Certify.Service.Worker.exe"`


Publishing:

-

Windows:

dotnet publish -c Release -r win-x64 --self-contained true

Linux:

dotnet publish -c Release -r linux-x64 --self-contained true

Single File:

dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true


Docker
---------
Requires a dockerfile to define how to build the images. certify-manager/docker for more dockerfile examples
Requries Microsoft.VisualStudio.Azure.Containers.Tools.Targets NuGet package installed in the project to hook up docker integration.

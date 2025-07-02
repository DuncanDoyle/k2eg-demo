# Kong 2 EG - Demo

## Installation

To install Envoy Gateway on your Kubernetes cluster, run the `install/install-envoy-gateway-with-helm.sh` setup script:

```
cd install
./install-envoy-gateway-with-helm.sh
```

Once Envoy Gateway is installed, run the `install/setup.sh` script to install both the `quickstart.yaml` file, which will deploy the quickstart files, and the `kong2eg-generated-resources.yaml` file, which will deploy an example Kong 2 Envoy Gateway deployment.

```
cd install
./setup.sh
```

> [!NOTE]
> In this example we have already generated the Kong2EG resources. To generate these resources yourself, you'll need the `kong2eg` command line tool. An example how to use this tool can be found in the `install/run-kong2eg.sh` script in this repository.


Once the resources have been created succesfully, check that your Envoy Gateway pod now has 3 containers, the `envoy` container, the `shutdown-manager` container and the `kong2envoy` container:

```
kubectl -n envoy-gateway-system get pod {envoy gateway pod name} -o="custom-columns=NAME:.metadata.name,INIT-CONTAINERS:.spec.initContainers[*].name,CONTAINERS:.spec.containers[*].name"
```

## Running the Demo

The example listens for traffic on hostname "http://www.example.com", so we run the followig cURL request to get some output. Make sure that "www.example.com" points to the IP of the Envoy Gateway, for example by configuring the correct mapping in your `/etc/hosts` file.

```
curl -v http://www.example.com
```

You should get an output that looks somewhat like this:

```
* Host www.example.com:80 was resolved.
* IPv6: (none)
* IPv4: 127.0.0.1
*   Trying 127.0.0.1:80...
* Connected to www.example.com (127.0.0.1) port 80
> GET / HTTP/1.1
> Host: www.example.com
> User-Agent: curl/8.7.1
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< date: Wed, 02 Jul 2025 08:41:51 GMT
< x-content-type-options: nosniff
< x-kong-response-header-2: bar
< x-kong-upstream-latency: 3
< content-type: application/json
< server: kong/3.9.0
< x-kong-response-header-1: foo
< x-kong-proxy-latency: 0
< via: 1.1 kong/3.9.0
< x-kong-request-id: 92ab232cbe138a514cc9d22795b8d76b
< transfer-encoding: chunked
< 
{
 "path": "/",
 "host": "www.example.com",
 "method": "GET",
 "proto": "HTTP/1.1",
 "headers": {
  "Accept": [
   "*/*"
  ],
  "Accept-Encoding": [
   "gzip"
  ],
  "Connection": [
   "keep-alive"
  ],
  "Kong2envoy-Ext-Proc-Id": [
   "904380803650397778"
  ],
  "User-Agent": [
   "curl/8.7.1"
  ],
  "Via": [
   "1.1 kong/3.9.0"
  ],
  "X-Envoy-External-Address": [
   "10.244.0.1"
  ],
  "X-Forwarded-For": [
   "10.244.0.1, 127.0.0.1"
  ],
  "X-Forwarded-Host": [
   "www.example.com"
  ],
  "X-Forwarded-Path": [
   "/"
  ],
  "X-Forwarded-Port": [
   "16001"
  ],
  "X-Forwarded-Proto": [
   "http"
  ],
  "X-Kong-Request-Header-1": [
   "foo"
  ],
  "X-Kong-Request-Header-2": [
   "bar"
  ],
  "X-Kong-Request-Id": [
   "92ab232cbe138a514cc9d22795b8d76b"
  ],
  "X-Real-Ip": [
   "127.0.0.1"
  ],
  "X-Request-Id": [
   "6ac49339-0765-4957-a22f-fc8d9ecc3f6a"
  ]
 },
 "namespace": "default",
 "ingress": "",
 "service": "",
 "pod": "backend-765694d47f-z94j4"
* Connection #0 to host www.example.com left intact
}
```

Note the `X-Kong-Request-*` headers in the output that have been added by the Kong instance running in the init-container, which is integrated with Envoy via ExtProc.
import httpclient, jsony, strformat

type
  Country* = object
    code*: string
    name*: string

  Location* = object
    lat: float
    lon: float

  ASN* = object
    number*: int
    name*: string
    network*: string

  IP* = object
    success*: bool
    ip*: string
    version*: string
    country*: Country
    region*: string
    city*: string
    location*: Location
    timezone*: string
    asn*: ASN

proc renameHook(ip: var IP, fieldName: var string) =
  if fieldName == "type": fieldName = "version"
  if fieldName == "timeZone": fieldName = "timezone"

let client = newHTTPClient()
client.headers["User-Agent"] = "myip/0.1.0 (Nim)"

proc makeRequest(subdomain: string): IP =
  let url = fmt"https://{subdomain}.my-ip.io/v2/ip.json"
  let resp = client.getContent(url)
  resp.fromJson(IP)

proc getIp*(): IP =
  makeRequest("api")

proc getIpv4*(): IP =
  makeRequest("api4")

proc getIpv6*(): IP =
  makeRequest("api6")

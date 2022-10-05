const jwa = require("jwa");
const fs = require("fs");
const keyPath = "./private_maps_key.p8";
const privateKey = fs.readFileSync(keyPath);
const { team_id: teamId, key_id: keyId } = require("./settings.json");
const mappingHost = "https://snapshot.apple-mapkit.com";
const mappingPath = "/api/v1/snapshot";

function signRequest(polyline) {
  const mapParams = "center=auto&scale=2&t=standard&poi=0";
  const overlays = [
    {
      points: polyline,
      strokeColor: "02B26B",
      lineWidth: 5,
    },
  ];

  const overlaysURL = encodeURIComponent(JSON.stringify(overlays));
  const params = `${mapParams}&overlays=${overlaysURL}`;
  const snapshotPath = `${mappingPath}?${params}`;
  const completePath = `${snapshotPath}&teamId=${teamId}&keyId=${keyId}`;
  console.log({ completePath });
  const hmac = jwa("ES256");
  const signature = hmac.sign(completePath, privateKey);
  return `${mappingHost}/${completePath}&signature=${signature}`;
}

console.log(signRequest("gvr~F~gruOyS~eYxiLuaY_GxtX{qJa{WbbAxzJf~BxyH"));

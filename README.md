# Apple Maps Snapshot URL Signing Issues

## Background

- We were moving an endpoint to generate snapshots using the Apple MapKit Api from NodeJS to Elixir
- The docs have a [working example](https://developer.apple.com/documentation/snapshots/generating_a_url_and_signature_to_create_a_maps_web_snapshot#3314798) on how to implement the signing logic in NodeJS
- Following the same steps with Elixir/Erlang crypto functions, we could not produce a valid signature
- The documentation also state that the URL should be signed using ECDSA (P-256 curve with SHA256 hash)
  - Erlang/Elixir have sets of modules that expose these algorithms but they did not seem to work
    - We tried base64 encoding the signature as well
  - `openssl` also did not seem to work

## Setup

- In this repo are two runnable files:

  - [`index.js`](./index.js)
  - [`main.exs`](./main.exs)

- Fill in the [`settings.json`](./settings.json) file with your team and key id
- Both files expect a `private_maps_key.p8` to be present at the root
- Important! Once a polyline has been encoded and viewed with a valid signature, the signature is no longer necessary to view the image
  - This means if you generate a valid signature/url with node and try the same string with elixir, _it will work no matter what_
- To test, generate a new unique encoded polyline string using [this Google tool](https://developers.google.com/maps/documentation/utilities/polylineutility)
- Paste the polyline string into the functions present at the bottom of the file and run it with either:
  - `node index.js`
  - `elixir main.exs`
- Both files will output the path for signing (they are identical) and the full URL

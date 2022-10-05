Mix.install([
  {:jason, "~> 1.4"},
  {:jose, "~> 1.11"}
])

defmodule Signer do
  @mapping_host "https://snapshot.apple-mapkit.com"
  @mapping_path "/api/v1/snapshot"
  @default_map_params "center=auto&scale=2&t=standard&poi=0"
  @key_path "./private_maps_key.p8"
  @settings "./settings.json"
            |> File.read!()
            |> Jason.decode!(keys: :atoms)

  def snapshot_url(polyline) do
    overlays =
      URI.encode_www_form(~s([{"points":"#{polyline}","strokeColor":"02B26B","lineWidth":5}]))

    complete_path =
      "#{@mapping_path}?#{@default_map_params}&overlays=#{overlays}&teamId=#{@settings.team_id}&keyId=#{@settings.key_id}"

    IO.inspect(complete_path, label: "complete_path")
    IO.puts("\n")

    {_, %{"signature" => signature}} =
      @key_path
      |> JOSE.JWK.from_pem_file()
      |> JOSE.JWS.sign(complete_path, %{"alg" => "ES256"})

    IO.inspect("#{@mapping_host}#{complete_path}&signature=#{signature}", label: "signed url")
  end
end

Signer.snapshot_url("gvr~F~gruOyS~eYxiLuaY_GxtX{qJa{WbbAxzJf~BxyHbaCjvD")

external api_url : string = "import.meta.env.VITE_API_URL"

let headers =
  let dict = Js.Dict.empty () in
  Js.Dict.set dict "Content-Type" "application/json";
  Fetch.HeadersInit.makeWithDict dict
;;

let get url_path ~decoder =
  Js.Promise.(
    Fetch.fetchWithInit
      (api_url ^ url_path)
      (Fetch.RequestInit.make () ~method_:Get ~credentials:Include ~headers)
    |> then_ Fetch.Response.json
    |> then_ (fun json -> decoder json |> resolve))
;;

let req_with_body url_path ~method_ ~payload =
  Js.Promise.(
    Fetch.fetchWithInit
      (api_url ^ url_path)
      (Fetch.RequestInit.make
         ()
         ~method_
         ~credentials:Include
         ~headers
         ~body:
           (Fetch.BodyInit.make (Js.Json.stringify (Js.Json.object_ payload))))
    |> then_ (fun response -> Fetch.Response.json response)
    |> then_ (fun json -> json |> resolve)
    |> catch (fun error ->
      Js.Console.error2 "Fetch error:" error;
      Js.Json.string (Js.String.make error) |> resolve))
;;

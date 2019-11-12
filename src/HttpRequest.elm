module HttpRequest exposing (create_post, handle_reply)

import Http
import Json.Decode as D
import Json.Encode as E


create_post : String -> model -> (model -> a) -> (Result Http.Error b -> msg) -> (a -> E.Value) -> D.Decoder b -> Cmd msg
create_post url_string model request_extractor msg encoder decoder =
    let
        body =
            Http.jsonBody (encoder (request_extractor model))
    in
    Http.post
        { url = url_string
        , body = body
        , expect = expectJson msg decoder
        }

expectJson : (Result Http.Error a -> msg) -> D.Decoder a -> Http.Expect msg
expectJson to_msg decoder =
    Http.expectStringResponse to_msg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata body ->
                    Err (Http.BadStatus metadata.statusCode)

                Http.GoodStatus_ metadata body ->
                    case D.decodeString decoder body of
                        Ok v ->
                            Ok v

                        Err e ->
                            Err (Http.BadBody (D.errorToString e))


handle_reply : Result Http.Error a -> mod -> (mod -> a -> mod) -> Result String mod
handle_reply result model model_updater =
    case result of
        Ok a ->
            Ok (model_updater model a)

        Err e ->
            case e of
                Http.BadUrl msg ->
                    Err (String.concat [ "BadUrl: ", msg ])

                Http.Timeout ->
                    Err "Timeout"

                Http.NetworkError ->
                    Err "Network Error"

                Http.BadStatus code ->
                    Err "BadStatus"

                Http.BadBody msg ->
                    Err (String.concat [ "BadBody: ", msg ])

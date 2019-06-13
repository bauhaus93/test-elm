module Api.Session exposing (Session, decoder, encode)

import Json.Decode as D
import Json.Encode as E

type alias Session =
    { id: String
    }

decoder : D.Decoder Session
decoder =
    D.map Session
        (D.field "id" D.string)

encode : Session -> E.Value
encode session =
    E.object
        [ ("id", E.string session.id)
        ]

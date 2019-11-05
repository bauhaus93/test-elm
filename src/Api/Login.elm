module Api.Login exposing (Login, decoder, encode)

import Api.User as User
import Json.Decode as D
import Json.Encode as E


type alias Login =
    { user : User.User
    , password : String
    }


decoder : D.Decoder Login
decoder =
    D.map2 Login
        User.decoder
        (D.field "password" D.string)


encode : Login -> E.Value
encode login =
    E.object
        [ ( "user", User.encode login.user )
        , ( "password", E.string login.password )
        ]

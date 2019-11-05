module Api.User exposing (User, decoder, encode)

import Json.Decode as D
import Json.Encode as E


type alias User =
    { name : String
    , email : String
    }


decoder : D.Decoder User
decoder =
    D.map2 User
        (D.field "name" D.string)
        (D.field "email" D.string)


encode : User -> E.Value
encode user =
    E.object
        [ ( "name", E.string user.name )
        , ( "email", E.string user.email )
        ]

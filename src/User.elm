module User exposing (User, login, decoder)

import Json.Decode exposing (Decoder, field, string, map2)

type alias User =
    {   name: String
    ,   session_id: String
    }

login : String -> String -> User
login name id =
    { name = name
    , session_id = id
    }

decoder : Decoder User
decoder =
    map2 User
        (field "username" string)
        (field "session_id" string)
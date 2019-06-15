module Route exposing (Route(..), from_url, replace_url, to_string)

import Browser.Navigation as Nav
import Url
import Url.Parser as Parser


type Route
    = Home
    | Signup
    | Signin


parser: Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Signup (Parser.s "signup")
        , Parser.map Signin (Parser.s "signin")
        ]

from_url: Url.Url -> Maybe Route
from_url url =
    Parser.parse parser url

replace_url : Nav.Key -> Route -> Cmd msg
replace_url key route =
    Nav.replaceUrl key (to_string route)

to_string : Route -> String
to_string route =
    case route of
        Home ->
            "/"
        Signup ->
            "/signup"
        Signin ->
            "/signin"
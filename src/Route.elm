module Route exposing (Route(..), from_url)

import Url
import Url.Parser as Parser


type Route
    = Home
    | Signup


parser: Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Signup (Parser.s "signup")
        ]

from_url: Url.Url -> Maybe Route
from_url url =
    Parser.parse parser url
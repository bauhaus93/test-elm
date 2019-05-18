module Signup exposing (..)

import Html exposing (Html, h1, form, div, text, input, button)
import Html.Attributes exposing (id, type_, class, style)

type alias User =
    { name: String
    , email: String
    , password: String
    }


initial_model: User
initial_model = 
    { name = ""
    , email = ""
    , password = ""
    }

view: User -> Html msg
view user =
    div [class "container"] [
        h1 [][text "Sign up"],
        div [class "input-group"] [
            Html.form[] [
                (text_entry_field "Name" "name"),
                (email_entry_field "Email" "email"),
                (password_entry_field "Password" "password"),
                (submit_button "Create")
            ]
        ]
    ]

submit_button: String -> Html msg
submit_button caption =
    div [class "row"] [ div [class "col pt-2"] [button [type_ "submit", class "btn btn-primary btn-block"][text caption]]]

entry_field: String -> String -> String -> Html msg
entry_field name field_id field_type =
    div [] [
        div [class "row"] [ div [class "col"] [text name]],
        div [class "row"] [ div [class "col pb-2"] [input [id field_id, type_ field_type][]]]
    ]

text_entry_field: String -> String -> Html msg
text_entry_field name id =
    entry_field name id "text"

email_entry_field: String -> String -> Html msg
email_entry_field name id =
    entry_field name id "email"

password_entry_field: String -> String -> Html msg
password_entry_field name id =
    entry_field name id "password"
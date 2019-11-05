module Page.Fields exposing (email_entry_field, password_entry_field, submit_button, user_entry_field)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


submit_button : String -> Html msg
submit_button caption =
    div [ class "row" ] [ div [ class "col pt-2" ] [ button [ type_ "submit", class "btn btn-primary btn-block" ] [ text caption ] ] ]


entry_field : String -> String -> String -> (String -> msg) -> Html msg
entry_field name field_id field_type change_msg =
    div []
        [ div [ class "row" ] [ div [ class "col" ] [ text name ] ]
        , div [ class "row" ] [ div [ class "col pb-2", onInput change_msg ] [ input [ id field_id, type_ field_type ] [] ] ]
        ]


user_entry_field : String -> String -> (String -> msg) -> Html msg
user_entry_field name id msg =
    entry_field name id "text" msg


email_entry_field : String -> String -> (String -> msg) -> Html msg
email_entry_field name id msg =
    entry_field name id "email" msg


password_entry_field : String -> String -> (String -> msg) -> Html msg
password_entry_field name id msg =
    entry_field name id "password" msg

module Views.Report.View exposing (view)

import Html exposing (Html)
import Model exposing (Model)
import Models.Record exposing (Records)


view : Model -> Maybe Records -> Html msg
view _ =
    Maybe.map (List.map (toString >> Html.text))
        >> Maybe.withDefault [ Html.text "No Records" ]
        >> Html.div []

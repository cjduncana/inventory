module View exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Model exposing (Model, Msg(Mdl))
import Views.Body as BodyView
import Views.Drawer as DrawerView
import Views.Header as HeaderView


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header = HeaderView.view
        , drawer = DrawerView.view
        , tabs = ( [], [] )
        , main = BodyView.view
        }

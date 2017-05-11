module View exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Material.Options as Options
import Model exposing (Model, Msg(Mdl))
import Views.Body as BodyView
import Views.Drawer as DrawerView
import Views.Header as HeaderView


view : Model -> Html Msg
view model =
    Html.div []
        [ stylesheet
        , mdlView model
        ]


mdlView : Model -> Html Msg
mdlView model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header = HeaderView.view model
        , drawer = DrawerView.view model
        , tabs = ( [], [] )
        , main = BodyView.view model
        }


stylesheet : Html a
stylesheet =
    Options.stylesheet """
    .mdl-layout__drawer-button {
      display: flex;
      justify-content: center;
      align-items: center;
      margin: 8px 12px;
    }
  """

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (Decoder, field, float)
import Maybe

-- custom imports
import Constants

-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type WeatherLoad
  = Failure
  | Loading
  | Success Float

type alias Model =
    { weatherLoadStatus: WeatherLoad
    , evanstonTemperature: Maybe Float
    , irkutskTemperature: Maybe Float
    }

init : () -> (Model, Cmd Msg)
init _ =
  ( {weatherLoadStatus = Loading, evanstonTemperature = Nothing, irkutskTemperature = Nothing}
  , Cmd.batch [evanstonWeatherRequest, irkutskWeatherRequest]
  )


-- UPDATE

type Msg
  = GotEvanstonWeather (Result Http.Error Float)
  | GotIrkutskWeather (Result Http.Error Float)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    GotEvanstonWeather result ->
      case result of
        Ok weather ->
          case model.irkutskTemperature of
            Nothing ->
              ( { model | evanstonTemperature = Just weather, weatherLoadStatus = Loading }
              , Cmd.none
              )
            Just irkutskTemperature ->
              ( { model | evanstonTemperature = Just weather
                , weatherLoadStatus = Success (weather - irkutskTemperature) }
              , Cmd.none
              )

        Err _ ->
          ({ model | weatherLoadStatus = Failure }, Cmd.none)

    GotIrkutskWeather result ->
      case result of
        Ok weather ->
          case model.evanstonTemperature of
            Nothing ->
              ( { model | irkutskTemperature = Just weather, weatherLoadStatus = Loading }
              , Cmd.none
              )
            Just evanstonTemperature ->
              ( { model | irkutskTemperature = Just weather
                , weatherLoadStatus = Success (evanstonTemperature - weather) }
              , Cmd.none
              )
        Err _ ->
          ({ model | weatherLoadStatus = Failure }, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

view : Model -> Html Msg
view model =
  div [] [viewComparison model]


viewComparison : Model -> Html Msg
viewComparison model =
  case model.weatherLoadStatus of
    Failure ->
      div [] [ text Constants.failureText ]

    Loading ->
      text Constants.loadingText

    Success difference ->
      div [ classList [("weather-information-text", True)] ]
        [ span [] [text "Evanston, Illinois is currently "]
        , (generateComparisonText difference)
        , span [] [text "than Irkutsk, Siberia."]
        ]

generateComparisonText: Float -> Html msg
generateComparisonText difference = 
    span [ classList [("warmer-accent-text", difference >= 0)
                      ,("colder-accent-text", difference < 0)] ] 
          [ text ((String.fromInt (abs (round difference))) ++ (if difference >= 0 then "° warmer " else "° colder ")) ]

-- HTTP


evanstonWeatherRequest : Cmd Msg
evanstonWeatherRequest =
  Http.get 
    { url = Constants.evanstonWeatherEndpoint
    , expect = Http.expectJson GotEvanstonWeather weatherDecoder
    }

irkutskWeatherRequest : Cmd Msg
irkutskWeatherRequest =
  Http.get 
    { url = Constants.irkutskWeatherEndpoint
    , expect = Http.expectJson GotIrkutskWeather weatherDecoder
    }

weatherDecoder : Decoder Float
weatherDecoder =
    field "main" (field "temp" float)
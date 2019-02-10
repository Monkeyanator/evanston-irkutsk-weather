module Constants exposing (evanstonWeatherEndpoint, irkutskWeatherEndpoint, failureText, loadingText)

-- vendored non standard imports
import String.Interpolate exposing(interpolate)


weatherAPIKey = "a3a63bb055705a67ca2ca018348f3d91"
baseWeatherAPIUrl = "https://api.openweathermap.org/data/2.5/weather?q={0},{1}&units=imperial&APPID={2}"

evanstonWeatherEndpoint = interpolate baseWeatherAPIUrl ["Evanston", "us", weatherAPIKey] 
irkutskWeatherEndpoint = interpolate baseWeatherAPIUrl ["Irkutsk", "ru", weatherAPIKey]

failureText
    = "Failed to load the reports!"

loadingText
    = "Loading..."
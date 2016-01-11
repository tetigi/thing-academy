module Handler.About where
import Import

getAboutR :: Handler Html
getAboutR = do
    conf <- liftIO $ getAppSettings
    let noun    = appNoun conf

    -- Start laying out the webpage
    defaultLayout $ do
        -- Fill in the rest with about.hamlet
        $(widgetFile "about")

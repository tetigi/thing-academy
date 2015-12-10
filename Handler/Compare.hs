module Handler.Compare where
import Import

data This = This
    deriving Show

getCompareR :: Handler Html
getCompareR = do
    entityID <- runDB $ insert $ ComparisonEntity "abcdef" "ZOMG" 100
    entity <- runDB $ get404 entityID

    thisValue <- lookupGetParam "this"
    thatValue <- lookupGetParam "that"
    whichValue <- lookupGetParam "which"
    let thisThing = "THIS" :: Text
        thatThing = "THAT" :: Text

    defaultLayout $ do
        setTitle $ case (thisValue, thatValue, whichValue) of
            (Just this, Just that, Just which)  -> "OH GOD"
            _                                   -> "Welcome to X-compare"
        thisButton <- newIdent
        $(widgetFile "compare")

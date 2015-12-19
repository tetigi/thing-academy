module Handler.Compare where
import Import

import Data.Random
import Data.Random.Source.DevRandom
import Data.Random.Extras

import Logic.Elo

getCompareR :: Handler Html
getCompareR = do
    conf <- liftIO $ getAppSettings

    let noun    = appNoun conf
        plural  = appPlural conf

    -- Get all entities from the db
    entities <- runDB $ selectList [] []

    -- Pick an entity at random
    Entity _ thisThingEntity <- liftIO $ runRVar (choice entities) DevRandom

    -- Pull out everything NOT the thing we just picked
    otherEntities <- runDB $ selectList [ComparisonHash !=. (comparisonHash thisThingEntity)] []

    -- Pick one at random
    Entity _ thatThingEntity <- liftIO $ runRVar (choice otherEntities) DevRandom

    -- Expose the variables for insertion into the HTML
    let thisThing = comparisonValue thisThingEntity
        thisHash  = comparisonHash thisThingEntity
        thatThing = comparisonValue thatThingEntity
        thatHash  = comparisonHash thatThingEntity

    -- Check for provided query parameters for a previous comparison
    thisValue <- lookupGetParam "this"
    thatValue <- lookupGetParam "that"
    whichValue <- lookupGetParam "which"

    -- Check if the query parameters actually contain anything
    _ <- case (thisValue, thatValue, whichValue) of
        (Just this, Just that, Just which)  -> do
            -- Extract the relevant entities from the DB, throwing 404 if they don't exist
            Entity thisId thisThingEntity' <- runDB $ getBy404 $ UniqueHash this
            Entity thatId thatThingEntity' <- runDB $ getBy404 $ UniqueHash that
            -- Switch on which they picked (this or that)
            case which of
                "this"  ->
                    let (thisElo, thatElo) = getNewEloPair (comparisonElo thisThingEntity') (comparisonElo thatThingEntity') PlayerOneWin in
                    runDB $ sequence [update thisId [ComparisonElo =. thisElo], update thatId [ComparisonElo =. thatElo]]
                "that"  ->
                    let (thisElo, thatElo) = getNewEloPair (comparisonElo thisThingEntity') (comparisonElo thatThingEntity') PlayerTwoWin in
                    runDB $ sequence [update thisId [ComparisonElo =. thisElo], update thatId [ComparisonElo =. thatElo]]
                -- If it's anything else, just return nothing
                _       -> return [()]
        _               -> return [()]

    -- Start laying out the webpage
    defaultLayout $ do
        -- Fill in the rest with compare.hamlet
        $(widgetFile "compare")

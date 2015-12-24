module Handler.CompareSpec (spec) where

import TestImport

seedDB :: YesodExample App [Key Comparison]
seedDB = runDB $ sequence
    [insert $ Comparison "abc123" "foo" 1500, insert $ Comparison "xyz987" "bar" 1500]

spec :: Spec
spec = withApp $ do
    it "loads the index successfully" $ do
        _ <- seedDB
        get CompareR
        statusIs 200
    it "loads the new hash successfully if present" $ do
        _ <- seedDB
        request $ do
            setMethod "GET"
            setUrl CompareR
            addGetParam "this" "abc123"
            addGetParam "that" "xyz987"
            addGetParam "which" "that"
        statusIs 200
    it "still works when invalid which is provided" $ do
        _ <- seedDB
        request $ do
            setMethod "GET"
            setUrl CompareR
            addGetParam "this" "abc123"
            addGetParam "that" "xyz987"
            addGetParam "which" "foobarbaz"
        statusIs 200
    it "updates the ELO correctly" $ do
        _ <- seedDB
        request $ do
            setMethod "GET"
            setUrl CompareR
            addGetParam "this" "abc123"
            addGetParam "that" "xyz987"
            addGetParam "which" "this"
        Just (Entity _ thisThingEntity) <- runDB $ getBy $ UniqueHash "abc123"
        assertEqual "incorrect hash value" 1516 (comparisonElo thisThingEntity)
    it "throws a 500 error with incorrect hash" $ do
        _ <- seedDB
        request $ do
            setMethod "GET"
            setUrl CompareR
            addGetParam "this" "a"
            addGetParam "that" "b"
            addGetParam "which" "that"
        statusIs 500

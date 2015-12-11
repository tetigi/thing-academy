# boob-academy

## Set-up

1. Check out this repo
2. Install stack (http://docs.haskellstack.org/en/stable/README.html)
3. `cd` into the repo
4. Run `stack setup`
5. Install yesod - `stack install yesod-bin cabal-install --install-ghc`
6. Run `stack build`
7. Run `stack exec -- yesod devel` - this will start up the development server


## TODO

1. Replace words with images - just replace the words with urls to images.
2. Add logic to check if an image 404s
3. Image sources - perhaps start with just google searches, moving on to stupid image searching algorithm.
4. Add image ranking page
5. Prettify

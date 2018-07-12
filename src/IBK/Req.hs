module IBK.Req where

import           Control.Lens         hiding (Context, (.=))
import           Data.Aeson
import           Data.ByteString.Lazy
import           Data.Text
import           IBK.Context
import           Network.Wreq
import           Text.Printf

{-# INLINE githubAPIRoot #-}
githubAPIRoot :: String
githubAPIRoot = "https://api.github.com"

class Request a where
  req :: a -> Context -> IO (Response ByteString)

data CreateIssue = CreateIssue { title :: String
                               , body  :: String
                               }

instance Request CreateIssue where
  req CreateIssue{..} Context{..} = let
    url = printf "%s/repos/%s/%s/issues" githubAPIRoot targetUser targetRepo
    opts = defaults & auth ?~ basicAuth username password
    in
    postWith opts url $ object [ "title" .= title
                               , "body" .= body
                               ]

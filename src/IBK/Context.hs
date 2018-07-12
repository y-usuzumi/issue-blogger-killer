module IBK.Context where

import           Data.ByteString

data Context = Context { username   :: ByteString
                       , password   :: ByteString
                       , targetUser :: String
                       , targetRepo :: String
                       }

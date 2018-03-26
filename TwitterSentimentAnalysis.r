#Twitter 1 - Working using my Keys
library("curl")
library("twitteR")
library("ROAuth")

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

#different for each account
consumerKey="6aSNYZjWCnFkfzyZzCRiq6CJt"
consumerSecret="jYSimNtsKnuwRC5Y5Puxg2xXR0a0nJS608hNEZXYFopY56gc5X
"
AccessToken="977597742028591106-ihULDizrfFSqPfxLrR2HVVuk3wsEDoZ"
AccessTokenSecret="LKE0OXbqgPhAyNB2A6hsLoyGrBuB194MLiG7TZfk2yK8v
"

#Commont for all accounts except the keys

cred <- OAuthFactory$new(consumerKey=consumerKey, consumerSecret=consumerSecret, requestURL='https://api.twitter.com/oauth/request_token', accessURL='https://api.twitter.com/oauth/access_token', authURL='https://api.twitter.com/oauth/authorize')


cred$handshake(cainfo="cacert.pem") # it will take browser
save(cred, file="twitter authentication.Rdata") # store this to avoid asking again


#Load saved authentication cert
load("twitter authentication.Rdata")
#registerTwitterOAuth(cred)

setup_twitter_oauth(consumerKey, consumerSecret, AccessToken, AccessTokenSecret)

search.string <- "#businessanalytics"
no.of.tweets <- 100

tweets <- searchTwitter(search.string, n=no.of.tweets,lang="en")
tweets


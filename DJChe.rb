
require 'dotenv'
require 'base64'
require 'httparty'
Dotenv.load

def encode (id, secret)
	## je transforme mes clés de cette manière client_id:secret_id
	 code = id + ':' + secret

    ## j'encode en base 64 (regarde la doc, Ruby a plusieurs méthodes pour ça
    encode = Base64.strict_encode64(code)

    ## Je rajoute "Basic " devant mon ma string encodé (n'oublie pas l'espace)
    phrase = 'Basic ' + encode

    return phrase
end



def gettoken

	tokenreply = HTTParty.post(
	  "https://accounts.spotify.com/api/token",

	  :headers => {"Authorization" => encode(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])},

	  :body => {:grant_type => "client_credentials"}
	)

	token = tokenreply["access_token"]
	return token

end


def getnewtracks
	newtracks = HTTParty.get(
		"https://api.spotify.com/v1/browse/new-releases?limit=2",
		:headers => {"Authorization" => "Bearer #{gettoken()}" }
		)
	
	#newtracks.each do |newtrack|
	   puts newtracks
	#end
end

def create_playlist
	answer = HTTParty.post(
 	"https://api.spotify.com/v1/users/zlr06j4p1epxb46ibkb874xn4/playlists",
 	:headers => {"Authorization" => "Bearer #{gettoken()}",
 	"Content-Type" => 'application/json'}
 	)
 	puts answer
end

#######  PERFORM ##########
# gettoken
getnewtracks
create_playlist
###########################

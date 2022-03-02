  # Real Time Programming 
  _Streaming Twitter sentiment score analyzer_
  ## About
  This application receives 2 streams of tweets from Twitter API. Every tweet is being analyzed by the sentiment score analyzer and tweet text in pair with its score is stored in database After that the tweet is being published to the client by the __tweeter__ topic.

  ## Launch (docker)
  - Run docker containers with `docker-compose up -d` in root project path;
  - Connect the server by running `netcat localhost 4444`;
  - Subscribe to a __tweeter__ topic by executing `SUBSCRIBE tweeter`;
  ### In order to update images and rebuild containers
  - `docker-compose up -d --force-recreate --build`
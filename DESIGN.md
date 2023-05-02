**NOTE: This is me thinking out loud as much as it is a final design for the project and is subject to change**

# DECISIONS BEFORE STARTING

* I decided to make this a subcommand based CLI tool to begin with.  I did this with thought that the tool could then be packaged up as an RPM, DEB, or otherwise.  From there, we could then build an API layer around the CLI tool and the API layer would not necessarily have to be the same language.

* The second thought before getting started here was basically "why just San Francisco?".  With that in mind, I am building the tool with the thought that SF is the first city that I am adding support for and that I could later go back and add support for other cities as they follow SF's lead in making this data available online.

# DECISIONS WHILE CODING

* For now, we default the city to SF since it is the only city currently supported.  As we add support for other cities, we should remove this default.

* We allow listing of multiple cities at once.  The reason for this is so that as we add support for filtering, then someone could list out every truck in every supported city that serves a certain type of food

* We use the 'mirror' method from LWP::UserAgent to pull down the data from the end point.  This lets us cache the data locally and ensures that we only pull the data down if it has changed since the last time we pulled it down which also saves bandwidth.

* While processing the csv, I assumed that the separator was a ',' and that the csv file started with headers.  This may need to be revisited as we add support for other cities.

# OUTPUT DECISION

* The subcommands should encode the return data as json and print it to STDOUT.  This will allow the API layer to easily consume the data returned from each subcommand call

# TODO

* The next step is to add sort/search options for the list subcommand so that an end user can do things such as
- Search for specific types of food
- Sort by business name
- Filter by zip code

* We should then see if other end points exist for other cities and work on adding support for more cities

* From there, we should look at adding other subcommands such as adding the ability to mark a food truck as a favorite and the ability to give ratings to the food trucks

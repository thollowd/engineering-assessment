**NOTE: This is me thinking out loud as much as it is a final design for the project and is subject to change**

# DECISIONS BEFORE STARTING

* I decided to make this a subcommand based CLI tool to begin with.  I did this with thought that the tool could then be packaged up as an RPM, DEB, or otherwise.  From there, we could then build an API layer around the CLI tool and the API layer would not necessarily have to be the same language.

* The second thought before getting started here was basically "why just San Francisco?".  With that in mind, I am building the tool with the thought that SF is the first city that I am adding support for and that I could later go back and add support for other cities as they follow SF's lead in making this data available online.

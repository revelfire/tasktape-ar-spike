# What is This?

A Spike to produce proof-of-concept AR/AI features for the TaskTape program.

These demo features when tightened up will be included in [Walkthrough by TaskTape](https://itunes.apple.com/us/app/walkthrough-by-tasktape/id1336050583?ls=1&mt=8) 

# What Does It Do?

* Job Finder (AR + Core Location)
* Job Distance (Core Location)
* Area Finder  (AR + Core Location)
* Tape Creator (AR + Core Location)
* Tape Finder
* Tape Namer (CNN + Object Detection)

# Done
## Job Finder
Intended for use when the user is looking at the Job List and deciding where to go next. 
Job Finder uses Core Location + AR & the ARCL library to present job images, names, and distance in a AR context (live camera + AR) to let the user
"take a look around" to see roughly the direction their jobs are in, and how far away.
Once the user selects a job they can tap on it, and from there be given the option to "open in maps" or "view job details".

[![Job Finder](https://img.youtube.com/vi/aN9jG288RSU/0.jpg)](https://youtu.be/aN9jG288RSU "Job Finder")



## Area Finder
Intended for use when the user is new to the job and trying to locate where on the job site a particular Area is located.
Area Finder uses Core Location heading data + ARKit to create a "finder arrow" that constant updates relative to the users position
to literally "point them in the right direction".


[![Area Finder](https://img.youtube.com/vi/1F_MFQ8amDg/0.jpg)](https://youtu.be/1F_MFQ8amDg "Area Finder")


# TODO

* Tape Creator
** Alternative UI & workflow for placing tapes using either feature point or vertical plane anchoring

* Tape Finder
** Ability to reset presumed tape locations by "guessing" anchors based on GPS-as-origin + stored world coordinates of placed tapes
** Ability to adjust presumed world origin to fix all tapes.

* Tape Namer

# Tools:
* ARKit...
* ARCL: https://github.com/ProjectDent/ARKit-CoreLocation
* Core Location

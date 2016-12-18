# [MovieNight](https://teamtreehouse.com/projects/movie-night-for-ios)
###by Alexey Papin  [![StackShare](https://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/zzheads/zzheads-at-gmail-com) [![Build Status](https://travis-ci.org/Jintin/Swimat.svg?branch=master)](https://travis-ci.org/Jintin/Swimat)

###The logic of choosing films for two (a few) people.

1) Each member in turn puts down the weights the importance of the following parameters of the movie:

- Film genre (weightGenre)
- The actors involved in the film (weightActors)
- The popularity of the film (weightPopularity)
- Prescription of the film's release (weightNew)

<img src="Снимок экрана 2016-12-19 в 0.30.21.png">


And the sum of all weights must be equal to 1. (weightGenre + weightActors + weightPopularity + weightNew = 1.0)
Implementation:
Four sliders UISlider, connected to each other (with an increase in the value of one, so that the sum is greater than 1 
then decrease the value of the other three as long as the sum of all the sliders will not be equal to 1)

2) Then, each participant chooses five (some) genres (genres = [Genre]) and five (some) actors (actors = [Actor])

<img src="Снимок экрана 2016-12-19 в 0.30.43.png">

3) The requested topRated 100 films each are counting usefulMovie value for a particular member using the formula:

> Watcher1: (weightGenre, weightActors, weightPopularity, weightNew), ([Genre], [Actor])
> Maximum popularity maxPopularity (maximum popularity in the source array of films)
> Lowest popularity minPopularity
> Newest film newestMovie
> The oldest film oldestMovie

> all four parameters leads to a common denominator
> maxPopularity - minPopularity = 1
> newestMovie - oldestMovie = 1
> movie genre in [Genre] = 1 or 0
> actors of movie in [Actor] = 1 or 0
> Multiplied by the weighting factors of each parameter and sum - each film corresponds to the numerical value of "how this film fits for watcher"

4) Find the intersection of arrays (sorted by useful) - create the final list and sorted according to the minimum amount
position of the film in both lists.

<img src="Снимок экрана 2016-12-19 в 0.31.17.png">
<img src="Снимок экрана 2016-12-19 в 0.31.38.png">


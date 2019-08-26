---
title: The missing question in supervised learning
summary: 
tags:
- supervised learning
- mean
- quantile
- median
- probabilistic forecasting
date: "2018-02-18T00:00:00Z"

# Optional external URL for project (replaces project detail page).
external_link: ""

image:
  caption: "[Photo by pixabay on Pexels](https://www.pexels.com/photo/abstract-blackboard-bulb-chalk-355948/)"
  focal_point: Smart

links:
- icon: twitter
  icon_pack: fab
  name: Follow
  url: https://twitter.com/VincenzoCoia
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""

# Slides (optional).
#   Associate this project with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides = "example-slides"` references `content/slides/example-slides.md`.
#   Otherwise, set `slides = ""`.
slides: example
---




You all know the drill -- you're asked to make predictions of a continuous variable, so you turn to your favourite supervised learning method to do the trick. But have you ever suspected that you could be after the wrong type of output before you even begin?

[Regression trees](https://en.wikipedia.org/wiki/Decision_tree_learning), [loess](https://en.wikipedia.org/wiki/Local_regression), [linear regression](https://en.wikipedia.org/wiki/Linear_regression)... you name it, they're all in pursuit of the [mean](https://en.wikipedia.org/wiki/Expected_value) (well, almost all). But the true outcome is random. It has a distribution. Are you sure you want the mean of that distribution?

You might say "Yes! It ensures my prediction is as close as possible to the outcome!" If this is indeed what you want, the mean still might not be your best choice -- it only ensures the [mean squared error](https://en.wikipedia.org/wiki/Mean_squared_error) is minimized.

There are a suite of other options that might be more appropriate than the mean. The good thing is, your favourite supervised learning method probably has a natural extension for estimating these alternatives. Let's investigate the quantities you might care about.

### The Median

No, the median _isn't_ just an inferior version of the mean, to be used under the unfortunate presence of outliers. 

If I randomly pick a data scientist, what do you think their salary would be? This distribution has a right-skew, so chances are, your data scientist earns less than the mean. Predict the [median](https://en.wikipedia.org/wiki/Median), and you'll have a 50% chance that your data scientist _does_ earn at least what you predict.

In short, use the median when you want your prediction to be exceeded with a coin toss.

Minimize the [mean absolute error](https://en.wikipedia.org/wiki/Mean_absolute_error) to get this prediction.

### Higher (or lower) Quantiles

Want to make it to an interview on time? You add some "buffer time" to the expected travel time, right? What you're after is a high [quantile](https://en.wikipedia.org/wiki/Quantile) of travel time -- something like the 0.99-quantile, so that there is only a small chance you'll be late (1% in this case). 

Use a high (or low) quantile if you want a conservative (or liberal) prediction -- or both, if you want a prediction interval.

Minimize the mean [rho function](https://en.wikipedia.org/wiki/Quantile_regression#Quantiles) to get this prediction.

### The Mean

The mean is useful when we care about _totals_. Want to know how much gas a vehicle uses?  You're after the mean, because the total quantity drawn out over time is what matters.

Minimize the mean squared error to get this prediction.

### Other Options

Do you really need to distill your prediction down to a single number? Consider looking at the entire distribution of the outcome as your prediction (typically conditional on predictors) -- after all, this conveys the entire uncertainty about the outcome. This is known as [probabilistic forecasting](https://en.wikipedia.org/wiki/Probabilistic_forecasting). 

There are other measures, too. [Expected shortfall](https://en.wikipedia.org/wiki/Expected_shortfall) is useful for risk analysis, or even [expectiles](http://www.statcan.gc.ca/pub/12-001-x/2016001/article/14545/03-eng.htm). Maybe you care about variance or skewness for some reason. Whatever you want to get at, just make sure you ask yourself what you actually care about. You have an entire distribution to distill!

([Photo from Pexels](https://www.pexels.com/photo/abstract-blackboard-bulb-chalk-355948/))
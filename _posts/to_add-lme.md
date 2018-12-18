From Linear Regression to Mixed Effects Models
================

--- layout: post title: "The missing question in supervised learning" bigimg: /img/2018-09-14-lme-lever.png tags: \[lme, lmer, regression, groups\] ---

Motivation for LME
------------------

Let's take a look at the `esoph` data set, to see how the number of controls `ncontrols` affects the number of cases `ncases` of cancer for each age group `agegp`. Here's what the data look like (with a tad bit of vertical jitter):

<img src="2018-09-14-lme_files/figure-markdown_github/unnamed-chunk-1-1.png" style="display: block; margin: auto;" />

It seems each age group has a different relationship. Should we then fit regression lines for each group separately? Here's what we get, if we do:

<img src="2018-09-14-lme_files/figure-markdown_github/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

But, each group has so few observations, making the regression less powerful:

    ##   agegp  n
    ## 1 25-34 15
    ## 2 35-44 15
    ## 3 45-54 16
    ## 4 55-64 16
    ## 5 65-74 15
    ## 6   75+ 11

**Question**: can we borrow information across groups to strengthen regression, while still allowing each group to have its own regression line?

Yes -- we can use *Linear Mixed Effects* (LME) models. An LME model is just a linear regression model for each group, with different slopes and intercepts, but the collection of slopes and intercepts *is assumed to come from some normal distribution*.

Definition
----------

With one predictor (*X*), we can write an LME as follows:
*Y* = (*β*<sub>0</sub>+*b*<sub>0</sub>) + (*β*<sub>1</sub>+*b*<sub>1</sub>)*X* + *ε*,
 where the error term *ε* has mean zero, and the *b*<sub>0</sub> and *b*<sub>1</sub> terms are normally distributed having a mean of zero, and some unknown variances and correlation. The *β* terms are called the *fixed effects*, and the *b* terms are called the *random effects*. Since the model has both types of effects, it's said to be a *mixed* model -- hence the name of "LME".

Note that we don't have to make *both* the slope and intercept random. For example, we can remove the *b*<sub>0</sub> term, which would mean that each group is forced to have the same (fixed) intercept *β*<sub>0</sub>. Also, we can add more predictors (*X* variables).

R Tools for Fitting
-------------------

Two R packages exist for working with mixed effects models: `lme4` and `nlme`. We'll be using the `lme4` package (check out [this](http://stats.stackexchange.com/questions/5344/how-to-choose-nlme-or-lme4-r-library-for-mixed-effects-models) discussion on Cross Validated for a comparison of the two packages).

Let's fit the model. We need to indicate a formula first in the `lmer` function, and indicate the data set we're using.

``` r
library(lme4)
```

    ## Loading required package: Matrix

``` r
fit <- lmer(ncases ~ ncontrols + (ncontrols | agegp), 
            data=dat)
```

Let's take a closer look at the *formula*, which in this case is `ncases ~ ncontrols + (ncontrols | agegp)`.

On the left of the `~` is the response variable, as usual (just like for `lm`). On the right, we need to specify both the fixed and random effects. The fixed effects part is the same as usual: `ncontrols` indicates the explanatory variables that get a fixed effect. Then, we need to indicate which explanatory variables get a random effect. The random effects can be indicated in parentheses, separated by `+`, followed by a `|`, after which the variable(s) that you wish to group by are indicated. So `|` can be interpreted as "grouped by".

Now let's look at the model output:

``` r
summary(fit)
```

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: ncases ~ ncontrols + (ncontrols | agegp)
    ##    Data: dat
    ## 
    ## REML criterion at convergence: 388.6
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.6510 -0.3710 -0.1301  0.3683  4.8056 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev. Corr
    ##  agegp    (Intercept) 1.694453 1.30171      
    ##           ncontrols   0.005729 0.07569  0.26
    ##  Residual             3.732899 1.93207      
    ## Number of obs: 88, groups:  agegp, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  1.63379    0.59994   2.723
    ## ncontrols    0.04971    0.03676   1.352
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## ncontrols 0.038

The random and fixed effects are indicated here.

-   Under the "Random effects:" section, we have the variance of each random effect, and the lower part of the correlation matrix of these random effects.
-   Under the "Fixed effects:" section, we have the estimates of the fixed effects, as well as the uncertainty in the estimate (indicated by the Std. Error).

We can extract the collection of slopes and intercepts for each group using the `coef` function:

``` r
(par_coll <- coef(fit))
```

    ## $agegp
    ##       (Intercept)    ncontrols
    ## 25-34   0.2674067 -0.002914520
    ## 35-44   0.7227280 -0.001127293
    ## 45-54   2.2834139  0.036587885
    ## 55-64   3.5108403  0.064242966
    ## 65-74   1.8699415  0.171918181
    ## 75+     1.1484332  0.029581764
    ## 
    ## attr(,"class")
    ## [1] "coef.mer"

Let's put these regression lines on the plot:

<img src="2018-09-14-lme_files/figure-markdown_github/unnamed-chunk-7-1.png" style="display: block; margin: auto;" />

So, each group still gets its own regression line, but tying the parameters together with a normal distribution gives us a more powerful regression.

library(tidyverse)
set.seed(2)
## Define corners of 4:
#'     4
#'   / |
#'  1----2
#'     |
#'     3
x1 <- c(-3, 0)
x2 <- c(1, 0)
x3 <- c(0, -3)
x4 <- c(0, 4)
## Standard deviation of "scatter" about the digits:
sd <- 0.2
## Density of points contained in 1 unit length:
dens <- 50
## Gap between letter boxes:
gap <- 1.5
## --------------------
## Letters contained in boxes with lenght and width:
width <- x2[1] - x1[1]
height <- x4[2] - x3[2]
## Shift a matrix (of 2-vectors) right or up, or by a 2-vector
shift <- function(nx2mat, vec) {
    multivec <- matrix(vec, byrow=TRUE, ncol=2, nrow=nrow(nx2mat))
    nx2mat + multivec
}
shift_right <- function(nx2mat, x) {
    multivec <- matrix(c(x, 0), byrow=TRUE, ncol=2, nrow=nrow(nx2mat))
    nx2mat + multivec
}
shift_up <- function(nx2mat, y) {
    multivec <- matrix(c(0, y), byrow=TRUE, ncol=2, nrow=nrow(nx2mat))
    nx2mat + multivec
}
## Make a scatterplot rod.
rod <- function(x1, x2, denspts=dens, sigma=sd) {
    len <- sqrt(sum((x2-x1)^2))
    adj <- x2[1] - x1[1]
    opp <- x2[2] - x1[2]
    n <- denspts*len
    x <- runif(n) * len
    y <- rnorm(n) * sigma
    rotation <- matrix(c(adj, opp,
                         -opp, adj),
                       byrow=TRUE,
                       ncol=2) / len
    matrix(c(x, y), ncol=2) %*% 
        rotation %>% 
        shift(x1)
}
oh <- function(width, height, denspts=dens, sigma=sd) {
    len <- 2*pi*mean(c(width, height))
    n <- len * denspts
    theta <- runif(n)*2*pi
    r_adj <- rnorm(n)*sigma
    x <- (r_adj + width/2)*sin(theta)
    y <- (r_adj + height/2)*cos(theta)
    matrix(c(x, y), ncol=2)
}
four <- function() 
    rbind(rod(x1, x2),
          rod(x1, x4),
          rod(x3, x4)) %>% 
    shift_up(-x3[2] - height/2)

dat404 <- rbind(four() %>% 
                    shift_right(-width/2 - gap - width/4),
                oh(width, height-2*2*sd),
                four() %>% 
                    shift_right(width/2 + gap + 3*width/4)) %>% 
    as.tibble

n_lm <- 50
datlm <- tibble(V1 = runif(n_lm)*13-7.5+4, 
                V2= -1.5 + 0.5*V1 + rnorm(n_lm)*0.7)

p <- ggplot() +
    geom_point(data=datlm, mapping=aes(x=V1, y=V2),
               colour="blue", alpha=0.2) +
    geom_point(data=dat404, mapping=aes(x=V1, y=V2),
               colour="red", alpha=0.2) +
    labs(x="", y="") +
    lims(y=c(-4.5, 4.5), x=c(NA, 10.5)) + # Excuse the magic numbers. 
    coord_equal() +
    theme_minimal() +
    theme(axis.text=element_blank())
p
ggsave(p, filename="404.png", width=5, height=2.5)



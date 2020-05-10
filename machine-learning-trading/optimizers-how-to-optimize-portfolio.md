---
id: machine-learning-trading-optimizers-how-to-optimize-portfolio
title: "Optimizers: How to Optimize a Portfolio"
course: machine-learning-trading
lecture: optimizers-how-to-optimize-portfolio
---

# Optimizers: How to Optimize a Portfolio

## What is Portfolio Optimization

Given a set of assets and a time period, **portfolio optimization** seeks to find an allocation of funds to assets that maximize performance. We can choose to optimize for one of several different performance metrics, such as cumulative return, volatility/risk, or Sharpe ratio.

## The Difference Optimization can Make

Consider this portfolio, which contains equal allocations to four stocks - GOOG, AAPL, GLD, and XOM - held from the beginning to the end of 2010.

![](https://assets.omscs.io/notes/2020-01-21-16-05-44.png)

Note that the performance of this unoptimized portfolio, plotted in blue, outperforms SPY, plotted in green.

Let's optimize this portfolio for Sharpe ratio and see how the returns change.

![](https://assets.omscs.io/notes/2020-01-21-16-08-29.png)

We can see that this optimized portfolio outperforms both SPY and the previous, unoptimized portfolio. 

Note the blend of asset allocations required for this performance. Whereas before we had equal allocations between assets, here we have a 40/60 split between AAPL and GLD, with GOOG and XOM receiving no allocation.

Of course, it's easy to go into the past and optimize for values that we know. The important question is: does this type of optimization help us in the future? Indeed, if we optimize our portfolio for Sharpe ratio and reoptimize, or **rebalance**, our allocations month by month, we often see higher returns than we would have if we stuck with equal allocations.

## Which Criteria is Easiest to Solve For Quiz

Let's assume we have a portfolio of four stocks, and we want to find the optimal allocations that maximize some performance metric. Which of the following metrics would be easiest to optimize for?

![](https://assets.omscs.io/notes/2020-01-21-16-35-00.png)

## Which Criteria is Easiest to Solve For Quiz Solution

![](https://assets.omscs.io/notes/2020-01-21-16-35-19.png)

It would be easiest to write an optimizer for cumulative return. To do so, all we need to do is allocate 100% of our portfolio into whichever stock had the highest cumulative return.

Optimizing for minimum volatility or Sharpe ratio involves evaluating various combinations of stocks, which is more complicated than simply putting all our eggs in one basket.

## Framing the Problem

As we've said, we want to optimize our portfolio such that we maximize Sharpe ratio. We've solved optimization problems using minimizers in the past, and so we need to reframe our Sharpe ratio maximization task as a minimization problem.

Recall that using a minimizer involves three steps. First, we define a function $f(x)$ that we want to minimize. Second, we define an initial guess for $x$. Finally, we pass $f(x)$ and $x$ to the optimizer and let it find the value of $x$ that minimizes $f(x)$.

In this case, $x$ is a list of the asset allocations in our portfolio. We want the optimizer to vary these values to discover the set of allocations that minimizes $f(x)$.

We might think to set $f(x)$ equal to the Sharpe ratio expression, but this is incorrect. Remember that the minimizer *minimizes* $f(x)$, so setting $f(x)$ equal to the Sharpe ratio results in an allocation that produces the smallest Sharpe ratio. We can fix this by instead setting $f(x)$ equal to the negative Sharpe ratio.

## Ranges and Constraints

Before we start tweaking our portfolio allocations, we have to consider two other concepts: ranges and constraints.

We need to tell the optimizer that it should only look for candidate values of $x$ within specific ranges. For example, for each of the various allocations in $x$, it only makes sense to look at values between 0 and 1. We can't have a negative allocation, and we can't allocate more than 100% of our portfolio to a particular asset.

Limiting the range of values the optimizer has to search over allows the optimizer to converge much more quickly to the solution.

Additionally, we can give the optimizer constraints: properties of $x$ that must be true for that $x$ to be considered a solution. In our case, we have the constraint that the sum of our allocations - the values in $x$ - must equal 1.

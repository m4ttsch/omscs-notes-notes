---
id: machine-learning-trading-assessing-learning-algorithm
title: Histograms and Scatter Plots
course: machine-learning-trading
lecture: histograms-scatter-plots
---

# Assessing a Learning Algorithm

## A Closer Look at KNN Solutions

Assume we have the following training examples plotted below, and we want to use the KNN algorithm to provide predictions for new observations.

![](2020-01-27-15-03-36.png)

Now suppose we query the KNN model at the following point, near $x = 0$, using the three nearest neighbors to make our prediction.

![](2020-01-27-15-10-45.png)

We calculate the predicted $y$ value for this $x$ as the mean of the $y$ values of these three neighbors. As $x$ gets larger, the set of nearest neighbors, and therefore the predicted $y$ value, shifts. We can plot the predicted $y$ values throughout the following continuous range of $x$ values.

![](2020-01-27-15-14-42.png)

A helpful feature of this model is that it doesn't overfit the data. Since we consider multiple neighbors for each prediction, a prediction is never disproportionately influenced by a single training example.

However, this model is not without its shortcomings. For example, we see flat lines at either end of the plot. After a certain point, the model returns the same prediction for any $x$ because the neighbors don't change. In other words, the model is unable to extrapolate any trends present in the data.


## What Happens as K Varies Quiz

Consider the following three models, each generated using a different value for $K$.

![](2020-01-27-16-18-46.png)

Our first task is to match the value of $K$ with the corresponding plot. Our second task is to decide whether we increase the chances of overfitting as we increase $K$. A **overfit** model matches the training set very well but fails to generalize to new examples.

## What Happens as K Varies Quiz Solution

![](2020-01-27-16-36-13.png)

Let's consider the case where $K = 1$. In this case, the model passes through every point $P$ directly, since near $P$, the only point that has any influence is $P$.

Now consider the case where $K = N$. In this case, every point considers all of the neighbors. Thus, the generated model is a straight line passing through the mean of the $y$ values of all the points.

Of course, when $1 < K < N$, the graph lies between these two extremes. For $K = 3$, the graph roughly follows the points without passing through them directly.

As a result, we see that increases in $K$ decrease the probability of overfitting.

## What Happens as D Varies Quiz

Consider the following three polynomial models. The difference between each model is the [degree of the polynomial](https://en.wikipedia.org/wiki/Degree_of_a_polynomial) $d$.

![](2020-01-27-17-08-58.png)

Our first task is to match the value of $d$ with the corresponding plot. Our second task is to decide whether we increase the chances of overfitting as we increase $d$.

## What Happens as D Varies Quiz Solution

![](2020-01-27-17-23-47.png)

A polynomial of degree one matches the equation $y = m_1x + b$, which is the equation of a line and corresponds to the third plot.

A polynomial of degree two matches the equation $y = m_1x + m_2x^2 + b$, which is the equation of a parabola and corresponds to the first plot.

A third-order polynomial matches the equation $y = m_1x + m_2x^2 + m_3x^3 + b$, which corresponds to the second plot.

We see that as we increase $d$, our model begins to follow the points more closely. Indeed, it can be shown that for $N$ points, a parabola of degree $N$ exists that passes through each point.

Notice that for each of these models, we can extrapolate beyond the data given. This ability to extrapolate is a property of parametric models that instance-based models lack.

## Metric 1: RMS Error

We've looked at different graphs of models and visually evaluated how well they fit sets of data. A more quantitative approach to measuring fit is to measure **error**.

Let's assume we want to build a linear model from the following data.

![](2020-01-28-22-45-51.png)

The model might look something like this.

![](2020-01-28-22-46-23.png)

We can assess this model at each real data point $d$ and measure the difference between the y-value of $d$ and the $y$ value of the model for the $x$ value of $d$. This difference is the error.

![](2020-01-28-22-48-07.png)

Accordingly, we have an error for every single data point in our data set.

![](2020-01-28-22-48-34.png)

A common type of error is the **root-mean-square error** (RMSE), which we compute by taking the square root of the mean of the squared errors for each point.

Formally, given a model fit to $N$ data points, each with an error $e_i$, we can calculate RMSE as:

$$ \sqrt{\frac{\sum_i{e_i}}{N}} $$

The RMSE formulation gives us an approximation of the average error, although it emphasizes larger errors slightly more than smaller ones.

## In Sample Vs. Out of Sample

Remember from our KNN discussion that it's possible to build models that can perfectly fit an arbitrary data set. In other words, we can create a model that has virtually zero error against our training set.

As a result, it doesn't make sense to evaluate our model against the data on which it trained. Instead, we train our model on one set of data and test it on another, previously unseen set of data: the *test set*.

We minimize the **in-sample** error between the training set and the model during training. We then compute the **out-of-sample** error between the test set and the model to evaluate how well the model generalizes to new data.

![](2020-01-28-23-16-48.png)

## Which is Worse Quiz

Suppose we just built a model. Which error would you expect to be larger: in-sample or out-of-sample?

![](2020-01-28-23-28-25.png)

## Which is Worse Quiz Solution

In general, the out-of-sample error is worse than the in-sample error.

![](2020-01-28-23-29-18.png)

## Cross Validation

Usually, when researchers are evaluating a model, they split their data into two sets. 60% of the data goes into a training set, and the remaining 40% goes into a test set.

We can think of the process of training and testing a model as a **trial**. In many cases, a single trial is sufficient to assess a model.

One problem researchers sometimes encounter, however, is that they don't have enough data to analyze their model effectively. They can mitigate this problem by partitioning their data set into different subsets such that they can run multiple trials.

For example, we can slice our data set into five different partitions. In trial one, we train on the first four slices and test on the fifth. In trial two, we train on the last four slices and test on the first. We can follow this approach to generate a total of five unique train/test splits from our single set of data.

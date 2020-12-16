---
id: simulation-input-analysis
title: Input Analysis
course: simulation
lecture: input-analysis
---

# Input Analysis

## Introduction

The goal of input analysis is to ensure that the random variables we use in our simulations adequately approximate the real-world phenomena we are modeling. We might use random variables to model interarrival times, service times, breakdown times, or maintenance times, among other things. These variables don't come out of thin air; we have to specify them appropriately.

### Why Worry? GIGO!

If we specify our random variables improperly, we can end up with a GIGO simulation: garbage-in-garbage-out. This situation can ruin the entire model and invalidate any results we might obtain.

### GIGO Example

Let's consider a single-server queueing system with *constant* service times of ten minutes. Let's incorrectly assume that we have *constant* interarrival times of twelve minutes. We should expect to never have a line under this assumption because the service times are always shorter than the interarrival times.

However, suppose that, in reality, we have Exp(12) interarrival times. In this case, the simulation never sees the line that actually occurs. In fact, the line might get quite long, and the simulation has no way of surfacing that fact.

### So What To Do?

Here's the high-level game plan for performing input analysis. First, we'll collect some data for analysis for any random variable of interest. Next, we'll determine, or at least estimate, the underlying distribution along with associated parameters: for example, Nor(30,8). We will then conduct a formal statistical test to see if the distribution we chose is "approximately" correct. If we fail the test, then our guess is wrong, and we have to go back to the drawing board.

## Identifying Distributions

In this lesson, we will look at some high-level methods for examining data and guessing the underlying distribution.

### Three Little Bears

We can always present data in the form of a histogram. Suppose we collect one hundred observations, and we plot the following histogram. We can't really determine the underlying distribution because we don't have enough cells.

![](https://assets.omscs.io/notes/2020-10-27-21-36-33.png)

Suppose we plot the following histogram. The resolution on this plot is too granular. We can potentially see the underlying distribution, but we risk missing the forest for the trees.

![](https://assets.omscs.io/notes/2020-10-27-21-57-17.png)

If we take the following histogram, we get a much clearer picture of the underlying distribution.

![](https://assets.omscs.io/notes/2020-10-27-21-57-57.png)

It turns out that, if we take enough observations, the histogram will eventually converge to the true pdf/pmf of the random variable we are trying to model, according to the [Glivenko–Cantelli theorem](https://en.wikipedia.org/wiki/Glivenko%E2%80%93Cantelli_theorem).

### Stem-and-Leaf

If we turn the histogram on its side and add some numerical information, we get a **stem-and-leaf diagram**, where each stem represents the common root shared among a collection of observations, and each leaf represents the observation itself.

![](https://assets.omscs.io/notes/2020-10-27-22-00-43.png)

### Which Distribution?

When looking at empirical data, what questions might we ask to arrive at the underlying distribution? For example, can we at least tell if the observations are discrete or continuous?

We might want to ask whether the distribution is univariate or multivariate. We might be interested in someone's weight, but perhaps we need to generate height and weight observations simultaneously.

Additionally, we might need to check how much data we have available. Certain distributions lend themselves more easily to smaller samples of data.

Furthermore, we might need to communicate with experts regarding the nature of the data. For example, we might want to know if the arrival rate changes at our facility as the day progresses. While we might observe the rate directly, we might want to ask the floor supervisor what to expect beforehand.

Finally, what happens when we don't have much or any data? What if the system we want to model doesn't exist yet? How might we guess a good distribution?

### Which Distribution, II?

Let's suppose we know that we have a discrete distribution. For example, we might realize that we only see a finite number of observations during our data collection process. How do we determine which discrete distribution to use?

If we want to model success and failures, we might use a Bernoulli random variable and estimate $p$. If we want to look at the number of successes in $n$ trials, we need to consider using a binomial random variable. 

Perhaps we want to understand how many trials we need until we get our first success. In that case, we need to look at a geometric random variable. Alternatively, if we want to know how many trials we need until the $n$th success, we need a negative binomial random variable.

We can use the Poisson($\lambda$) distribution to count the number of arrivals over time, assuming that the arrival process satisfies certain elementary assumptions.

If we honestly don't have a good model for the discrete data, perhaps we can use an empirical or sample distribution.

### Which Distribution, III?

What if the distribution is continuous?

We might consider the uniform distribution if all we know about the data is the minimum and maximum possible values. If we know the most likely value as well, we might use the triangular distribution.

If we are looking at interarrival times from a Poisson process, then we know we should be looking at the Exp($\lambda$) distribution. If the process is nonhomogeneous, we might have to do more work, but the exponential distribution is a good starting point.

We might consider the normal distribution if we are looking at heights, weights, or IQs. Furthermore, if we are looking at sample means or sums, the normal distribution is a good choice because of the central limit theorem. 

We can use the Beta distribution, which generalizes the uniform distribution, to specify bounded data. We might use the gamma, Weibull, Gumbel, or lognormal distribution if we are dealing with reliability data. 

When in doubt, we can use the empirical distribution, which is based solely on the sample.

### Game Plan

As we said, we will choose a "reasonable" distribution, and then we'll perform a hypothesis test to make sure that our choice is not too ridiculous.

For example, suppose we hypothesize that some data is normal. This data should fall approximately on a straight line when we graph it on a [normal probability plot](https://en.wikipedia.org/wiki/Normal_probability_plot), and it should look normal when we graph it on a standard plot. At the very least, it should also pass a goodness-of-fit test for normality, of which there are several.

## Unbiased Point Estimation

It's not enough to decide that some sequence of observations is normal; we still have to estimate $\mu$ and $\sigma^2$. In the next few lessons, we will look at point estimation, which lets us understand how to estimate these unknown parameters. We'll cover the concept of unbiased estimation first.

### Statistic Definition

  A **statistic** is a function of the observations $X_1,...,X_n$ that is not explicitly dependent on any unknown parameters. For example, the sample mean, $\bar{X}$, and the sample variance, $S^2$, are two statistics:

$$
\begin{alignedat}{1}
\bar{X} = &\frac{1}{n} \sum_{i=1}^n X_i \\[2ex]
S^2 = &\frac{1}{n-1} \sum_{i=1}^x(X_i - \bar{X})^2
\end{alignedat}
$$

Statistics are random variables. In other words, if we take two different samples, we should expect to see two different values for a given statistic.

We usually use statistics to estimate some unknown **parameter** from the underlying probability distribution of the $X_i$'s. For instance, we use the sample mean, $\bar{X}$, to estimate the true mean, $\mu$, of the underlying distribution, which we won't normally know. If $\mu$ is the true mean, then we can take a bunch of samples and use $\bar{X}$ to estimate $\mu$. We know, via the law of large numbers that, as $n \to \infty$, $\bar{X} \to \mu$.

### Point Estimator

Let's suppose that we have a collection of iid random variables, $X_1,...,X_n$. Let $T(\bold{X}) \equiv T(X_1,...,X_n)$  be a function that we can compute based only on the observations. Therefore, $T(\bold{X})$ is a statistic. If we use $T(\bold{X})$ to estimate some unknown parameter $\theta$, then $T(\bold{X})$ is known as a **point estimator** for $\theta$.

For example, $\bar{X}$ is usually a point estimator for the true mean, $\mu = E[X_i]$, and $S^2$  is often a point estimator for the true variance, $\sigma^2 = \text{Var}(X)$.

$T(\bold{X})$ should have specific properties:

- Its expected value should equal the parameter it's trying to estimate. This property is known as *unbiasedness*.
- It should have a low variance. It doesn't do us any good if $T(\bold{X})$ is bouncing around depending on the sample we take.

### Unbiasedness

We say that $T(\bold{X})$ is **unbiased** for $\theta$ if $E[T(\bold{X})] = \theta$. For example, suppose that random variables, $X_1,...,X_n$ are iid *anything* with mean $\mu$. Then:

$$
\begin{alignedat}{1}
E[\bar{X}] & = E\left[\frac{1}{n}\sum_{i=1}^nX_i\right] \\[3ex]
& = \frac{1}{n}\sum_{i=1}^nE[X_i] \\[3ex]
& = \frac{nE[X_i]}{n} \\[2ex]
& = E[X_i] = \mu
\end{alignedat}
$$

Since $E[\bar{X}] = \mu$, $\bar{X}$ is always unbiased for $\mu$. That's why we call it the *sample mean*.

Similarly, suppose we have random variables, $X_1,...,X_n$ which are iid $\text{Exp}(\lambda)$. Then, $\bar{X}$ is unbiased for $\mu = E[X_i] = 1 / \lambda$. Even though $\lambda$ is unknown, we know that $\bar{X}$ is a good estimator for $1/ \lambda$.

Be careful, though. Just because $\bar{X}$ is unbiased for $1 / \lambda$ does **not** mean that $1 / \bar{X}$ is unbiased for $\lambda$: $E[1/\bar{X}] \neq 1 /E[\bar{X}] = \lambda$. In fact, $1/\bar{X}$ is biased for $\lambda$ in this exponential case.

Here's another example. Suppose that random variables, $X_1,...,X_n$ are iid *anything* with mean $\mu$ and variance $\sigma^2$. Then:

$$
E[S^2] = E\left[\frac{\sum_{i=1}^n(X_i - \bar{X})^2}{n - 1}\right] = \text{Var}(X_i) = \sigma^2
$$

Since $E[S^2] = \sigma^2$, $S^2$ is always unbiased for $\sigma^2$. That's why we called it the *sample variance*.

For example, suppose random variables $X_1,...,X_n$ are iid $\text{Exp}(\lambda)$. Then $S^2$ is unbiased for $\text{Var}(X_i) = 1 / \lambda^2$.

Let's give a proof for the unbiasedness of $S^2$ as an estimate for $\sigma^2$. First, let's convert $S^2$ into a better form:

$$
\begin{alignedat}{1}
S^2 & = \frac{\sum_{i=1}^n(X_i - \bar{X})^2}{n - 1} \\[3ex]
& = \frac{\sum_{i=1}^n X_i^2  -2X_i\bar{X} + \bar{X}^2}{n - 1} \\[3ex]
& = \frac{1}{n-1}\left(\sum_{i=1}^n X_i^2  -2X_i\bar{X} + \bar{X}^2\right) \\[3ex]
& = \frac{1}{n-1}\left(\sum_{i=1}^n X_i^2  - \sum_{i=1}^n 2X_i\bar{X} + \sum_{i=1}^n \bar{X}^2\right) \\[3ex]
\end{alignedat}
$$

Let's rearrange the middle sum:

$$
 \sum_{i=1}^n 2X_i\bar{X} =  2\bar{X}\sum_{i=1}^n X_i
$$

Remember that $\bar{X}$ represents the average of all the $X_i$'s: $\sum X_i / n$. Thus, if we just sum the $X_i$'s and don't divide by $n$, we have a quantity equal to $n\bar{X}$:

$$
2\bar{X}\sum_{i=1}^n X_i = 2\bar{X}n\bar{X} = 2n\bar{X}^2
$$

Now, back to action:

$$
\begin{alignedat}{1}
S^2 & = \frac{1}{n-1}\left(\sum_{i=1}^n X_i^2  - \sum_{i=1}^n 2X_i\bar{X} + \sum_{i=1}^n \bar{X}^2\right) \\[3ex]
& = \frac{1}{n-1}\left(\sum_{i=1}^n X_i^2  - 2n\bar{X}^2 + n\bar{X}^2\right) \\[3ex]
& = \frac{1}{n-1}\left(\sum_{i=1}^n X_i^2  - n\bar{X}^2 \right) \\[3ex]
& = \frac{\sum_{i=1}^n X_i^2  - n\bar{X}^2}{n-1} \\[3ex]
\end{alignedat}
$$

Let's take the expected value:

$$
\begin{alignedat}{1}
E[S^2] & = \frac{\sum_{i=1}^n E[X_i^2] - nE[\bar{X}^2]}{n-1}
\end{alignedat}
$$

Note that $E[X_i^2]$ is the same for all $X_i$, so the sum is just $nE[X_1^2]$:

$$
\begin{alignedat}{1}
E[S^2] & = \frac{n E[X_1^2] - nE[\bar{X}^2]}{n-1} \\[2ex]
& = \frac{n}{n-1} \left(E[X_1^2] - E[\bar{X}^2]\right)
\end{alignedat}
$$

We know that $\text{Var}(X) = E[X^2] - (E[X])^2$, so $E[X^2] = \text{Var}(X) + (E[X])^2$. Therefore:

$$
\begin{alignedat}{1}
E[S^2] & = \frac{n}{n-1} \left(\text{Var}(X_1) + (E[X_1]^2) - \text{Var}(\bar{X}) - (E[\bar{X}]^2)\right)
\end{alignedat}
$$

Remember that $E[X_1] = E[\bar{X}]$, so: 

$$
\begin{alignedat}{1}
E[S^2] & = \frac{n}{n-1} \left(\text{Var}(X_1) - \text{Var}(\bar{X}) \right) \\[3ex]
\end{alignedat}
$$

Furthermore, remember that $\text{Var}(\bar{X}) = \text{Var}(X_1) /n = \sigma_2 / n$. Therefore:

$$
\begin{alignedat}{1}
& = \frac{1}{n-1} \left(\sigma^2 - \sigma^2/n) \right) \\[3ex]
& = \frac{n\sigma^2}{n-1} - \frac{\sigma^2}{n-1} \\[3ex]
& = \frac{n\sigma^2- \sigma^2}{n-1} = \frac{\sigma^2(n-1)}{n-1} = \sigma^2
\end{alignedat}
$$

Unfortunately, while $S^2$ is unbiased for the variance $\sigma^2$, $S$ is *biased* for the standard deviation $\sigma$.

## Mean Squared Error

In this lesson, we'll look at mean squared error, a performance measure that evaluates an estimator by combining its bias and variance.

### Bias and Variance

We want to choose an estimator with the following properties:

- Low bias (defined as the difference between the estimator's expected value and the true parameter value)
- Low variance

Furthermore, we want the estimator to have both of these properties simultaneously. If the estimator has low bias but high variance, then its estimates are meaninglessly noisy. Its average estimate is correct, but any individual estimate may be way off the mark. On the other hand, an estimator with low variance but high bias is very confident about the wrong answer.

### Example

Suppose that we have $n$ random variables, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Unif}(0,\theta)$.  We know that our observations have a lower bound of $0$, but we don't know the value of the upper bound, $\theta$. As is often the case, we sample many observations from the distribution and use that sample to estimate the unknown parameter.

Consider two estimators for $\theta$:

$$
\begin{alignedat}{1}
Y_1 &\equiv 2\bar{X} \\[2ex]
Y_2 &\equiv \frac{n+1}{n} \max_{1 \leq i \leq X_i}X_i
\end{alignedat}
$$

Let's look at the first estimator. We know that $E[Y_1] = 2E[\bar{X}]$, by definition. Similarly, we know that $2E[\bar{X}] = 2E[X_i]$, since $\bar{X}$ is always unbiased for the mean. Recall how we compute the expected value for a uniform random variable:

$$
E[A] = (b - a) / 2, \quad A \sim \text{Unif}(a,b)
$$

Therefore:

$$
2E[X_i]  = 2\left(\frac{\theta - 0}{2}\right) = \theta = E[Y_1]
$$

As we can see, $Y_1$ is unbiased for $\theta$.

It's also the case that $Y_2$ is unbiased, but it takes more work to demonstrate. As a first step, take the cdf of the maximum of the $X_i$'s, $M \equiv \max_iX_i$. Here's what $P(M \leq y)$ looks like:

$$
P(M \leq y) = P(X_1 \leq y \text{ and } X_2 \leq y \text{ and } \dots \text{ and } X_n \leq y)
$$

If $M \leq y$, and $M$ is the maximum, then $P(M \leq y)$ is the probability that all the $X_i$'s are less than $y$. Since the $X_i$'s are independent, we can take the product of the individual probabilities:

$$
P(M \leq y) = \prod_{i = i}^n P(X_i \leq y) = [P(X_1 \leq y)]^n
$$

Now, we know, by definition, that the cdf is the integral of the pdf. Remember that the pdf for a uniform distribution, $\text{Unif}(a,b)$, is:

$$
f(x) = \frac{1}{b-a}, a < x < b
$$

Let's rewrite $P(M \leq y)$:

$$
\begin{alignedat}{1}
P(M \leq y) &= \left[\int_0^yf_{X_1}(x)dx\right]^n \\[2ex]
& = \left[\int_0^y\frac{1}{\theta}dx\right]^n \\[2ex]
& = \left(\frac{y}{\theta}\right)^n
\end{alignedat}
$$

Again, we know that the pdf is the derivative of the cdf, so:

$$
\begin{alignedat}{1}
f_M(y) & = F_M(y)dy \\[2ex]
& = \frac{d}{dy} \frac{y^n}{\theta^n} \\[2ex]
& = \frac{ny^{n-1}}{\theta^n}
\end{alignedat}
$$

With the pdf in hand, we can get the expected value of $M$:

$$
\begin{alignedat}{1}
E[M] & = \int_0^\theta yf_M(y)dy \\[2ex]
& = \int_0^\theta \frac{ny^n}{\theta^n} dy \\[2ex]
& = \frac{ny^{n+1}}{(n+1)\theta^n}\Big|_0^\theta \\[2ex]
& = \frac{n\theta^{n+1}}{(n+1)\theta^n} \\[2ex]
& = \frac{n\theta}{n+1} \\[2ex]
\end{alignedat}
$$

Note that $E[M] \neq \theta$, so $M$ is not an unbiased estimator for $\theta$. However, remember how we defined $Y_2$:

$$
Y_2 \equiv \frac{n+1}{n} \max_{1 \leq i \leq X_i}X_i
$$

Thus:

$$
\begin{alignedat}{1}
E[Y_2] & = \frac{n+1}{n}E[M] \\[2ex]
& = \frac{n+1}{n} \left(\frac{n\theta}{n+1}\right) \\[2ex]
& = \theta
\end{alignedat}
$$

Therefore, $Y_2$ is unbiased for $\theta$.

Both indicators are unbiased, so which is better? Let's compare variances now. After similar algebra, we see:

$$
\text{Var}(Y_1) = \frac{\theta^2}{3n}, \quad \text{Var}(Y_2) = \frac{\theta^2}{n(n+2)}
$$

Since the variance of $Y_2$ involves dividing by $n^2$, while the variance of $Y_1$ only divides by $n$, $Y_2$ has a much lower variance than $Y_1$ and is, therefore, the better indicator.

### Bias and Mean Squared Error

The **bias** of an estimator, $T[\bold{X}]$, is the difference between the estimator's expected value and the value of the parameter its trying to estimate: $\text{Bias}(T) \equiv E[T] - \theta$. When $E[T] = \theta$, then the bias is $0$ and the estimator is unbiased.

The **mean squared error** of an estimator, $T[\bold{X}]$, the expected value of the squared deviation of the estimator from the parameter: $\text{MSE}(T) \equiv E[(T-\theta)^2]$.

Remember the equation for variance:

$$
\text{Var}(X) = E[X^2] - (E[X])^2
$$

Using this equation, we can rewrite $\text{MSE}(T)$:

$$
\begin{alignedat}{1}
\text{MSE}(T) & = E[(T-\theta)^2] \\[2ex]
& = \text{Var}(T) + (E[T] - \theta)^2 \\[2ex]
& = \text{Var}(T) + \text{Bias}^2 \\[2ex]
\end{alignedat}
$$

Usually, we use mean squared error to evaluate estimators. As a result, when selecting between multiple estimators, we might not choose the unbiased estimator, so long as that estimator's MSE is the lowest among the options.

### Relative Efficiency

The **relative efficiency** of one estimator, $T_1$, to another, $T_2$, is the ratio of the mean squared errors: $\text{MSE}(T_1) / \text{MSE}(T_2)$. If the relative efficiency is less than one, we want $T_1$; otherwise, we want $T_2$.

Let's compute the relative efficiency of the two estimators we used in the previous example: 

$$
\begin{alignedat}{1}
Y_1 &\equiv 2\bar{X} \\[2ex]
Y_2 &\equiv \frac{n+1}{n} \max_{1 \leq i \leq X_i}X_i
\end{alignedat}
$$ 

Remember that both estimators are unbiased, so the bias is zero by definition. As a result, the mean squared errors of the two estimators is determined solely by the variance:

$$
\text{MSE}(Y_1) = \text{Var}(Y_1) = \frac{\theta^2}{3n}, \quad \text{MSE}(Y_2) = \text{Var}(Y_2) =  \frac{\theta^2}{n(n+2)}
$$

Let's calculate the relative efficiency:

$$
\begin{alignedat}{1}
e(Y_1, Y_2) & = \frac{\frac{\theta^2}{3n}}{\frac{\theta^2}{n(n+2)}} \\[3ex]
& = \frac{\theta^2 * n(n+2)}{3n\theta^2} \\[2ex]
& = \frac{n(n+2)}{3n} \\[2ex]
& = \frac{n+2}{3} \\[2ex]
\end{alignedat}
$$

The relative efficiency is greater than one for all $n > 1$, so $Y_2$ is the better estimator just about all the time.

## Maximum Likelihood Estimation

In this lesson, we are going to talk about maximum likelihood estimation, which is perhaps the most important point estimation method. It's a very flexible technique that many software packages use to help estimate parameters from various distributions.

### Likelihood Function and Maximum Likelihood Estimator

Consider an iid random sample, $X_1,...,X_n$, where each $X_i$ has pdf/pmf $f(x)$. Additionally, suppose that $\theta$ is some unknown parameter from $X_i$ that we would like to estimate. We can define a **likelihood function**, $L(\theta)$ as:

$$
L(\theta) \equiv \prod_{i=1}^n f(x_i)
$$

The **maximum likelihood estimator** (MLE) of $\theta$ is the value of $\theta$ that maximizes $L(\theta)$. The MLE is a function of the $X_i$'s and is itself a random variable.

### Exponential Example

Consider a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)$. Find the MLE for $\lambda$. Note that, in this case, $\lambda$, is taking the place of the abstract parameter, $\theta$. Now:

$$
L(\lambda) \equiv \prod_{i=1}^n f(x_i)
$$

We know that exponential random variables have the following pdf: 

$$
f(x, \lambda) = \lambda e^{-\lambda x}
$$

Therefore:

$$
L(\lambda) \equiv \prod_{i=1}^n \lambda e^{-\lambda x_i}
$$

Let's expand the product:

$$
L(\lambda) =  (\lambda e^{-\lambda x_1}) * (\lambda e^{-\lambda x_2}) * \dots * (\lambda e^{-\lambda x_n})
$$

We can pull out a $\lambda^n$ term:

$$
L(\lambda) = \lambda^n * (e^{-\lambda x_1}) * (e^{-\lambda x_2}) * \dots * (e^{-\lambda x_n})
$$

Remember what happens to exponents when we multiply bases: 

$$
a^x * a^y = a^{x+y}
$$

Let's apply this to our product (and we can swap in $\exp$ notation to make things easier to read):

$$
L(\lambda) = \lambda^n \exp\left[-\lambda \sum_{i=1}^nx_i\right]
$$

Now, we need to maximize $L(\lambda)$ with respect to $\lambda$. We could take the derivative of $L(\lambda)$, but we can use a trick! Since the natural log function is one-to-one, the $\lambda$ that maximizes $L(\lambda)$ also maximizes $\ln(L(\lambda))$. Let's take the natural log of $L(\lambda)$:

$$
\ln(L(\lambda)) = \ln\left(\lambda^n \exp\left[-\lambda \sum_{i=1}^nx_i\right]\right)
$$

Let's remember three different rules here:

$$
\ln(ab) = \ln(a) + \ln(b), \quad \ln(a^b) = b\ln(a), \quad \ln(e^x) = x
$$

Therefore:

$$
\begin{alignedat}{1}
\ln(L(\lambda)) & = \ln(\lambda^n) +\ln\left(\exp\left[-\lambda \sum_{i=1}^nx_i\right]\right) \\[2ex]
& = n\ln(\lambda) +\ln\left(\exp\left[-\lambda \sum_{i=1}^nx_i\right]\right) \\[2ex]
& = n\ln(\lambda) -\lambda \sum_{i=1}^nx_i \\[2ex]
\end{alignedat}
$$

Now, let's take the derivative:

$$
\begin{alignedat}{1}
\frac{d}{d\lambda}\ln(L(\lambda)) & = \frac{d}{d\lambda}\left(n\ln(\lambda) -\lambda \sum_{i=1}^nx_i\right) \\[2ex]
& = \frac{n}{\lambda} - \sum_{i=1}^nx_i \\[2ex]
\end{alignedat}
$$

Finally, we set the derivative equal to $0$ and solve for $\lambda$:

$$
\begin{alignedat}{1}
0 \equiv \frac{n}{\lambda} & - \sum_{i=1}^nx_i \\[2ex]
\frac{n}{\lambda} & = \sum_{i=1}^nx_i \\[3ex]
\lambda & = \frac{n}{\sum_{i=1}^nx_i} \\[2ex]
\lambda & = \frac{1}{\bar{X}} \\[2ex]
\end{alignedat}
$$

Thus, the maximum likelihood estimator for $\lambda$ is $1 / \bar{X}$, which makes a lot of sense. The mean of the exponential distribution is $1 / \lambda$, and we usually estimate that mean by $\bar{X}$. Since $\bar{X}$ is a good estimator for $\lambda$, it stands to reason that a good estimator for $\lambda$ is $1 / \bar{X}$.

Conventionally, we put a "hat" over the $\lambda$ that maximizes the likelihood function to indicate that it is the MLE. Such notation looks like this: $\widehat{\lambda}$.

Note that we went from "little x's", $x_i$, to "big x", $\bar{X}$, in the equation. We do this to indicate that $\widehat{\lambda}$ is a random variable.

Just to be careful, we probably should have performed a second-derivative test on the function, $\ln(L(\lambda))$, to ensure that we found a maximum likelihood estimator and not a minimum likelihood estimator.

### Bernoulli Example

Let's look at a discrete example. Suppose we have $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Bern}(p)$. Let's find the MLE for $p$. We might remember that the expected value of Bern($p$) random variable is $p$, so we shouldn't be surprised if $\bar X$ is our MLE.

Let's remember the values that $X_i$ can take:

$$
X_i = \begin{cases}
1 & \text{w.p. } p \\
0 & \text{w.p. } 1-p
\end{cases}
$$

Therefore, we can write the pmf for a Bern($p$) random variable as follows:

$$
f(x) = p^x(1-p)^{1-x}, \quad x = 0, 1
$$

Now, let's calculate $L(p)$. First:

$$
L(p) = \prod_{i=1}^n f(x_i) = \prod p^{x_i}(1-p)^{1-x_i}
$$

Remember that $a^x * a^y = a^{x+y}$. So:

$$
\prod p^{x_i}(1-p)^{1-x_i} = p^{\sum_{i=1}^n x_i}(1-p)^{n-\sum_{i=1}^n x_i}
$$

Let's take the natural log of both sides, remembering that $\ln(ab) = \ln(a) + \ln(b)$:

$$
\ln(L(p)) = \sum_{i=1}^n x_i\ln(p) + (n-\sum_{i=1}^n x_i)\ln(1-p)
$$

Let's take the derivative, remembering that the derivative of $\ln(1-p)$ equals $-1/(1-p)$:

$$
\frac{d}{dp}\ln(L(p)) = \frac{\sum_{i=1}^n x_i}{p} - \frac{n-\sum_{i=1}^n x_i}{1-p}
$$

Now we can set the derivative equal to zero, and solve for $\widehat p$:

$$
\begin{alignedat}{1}
\frac{\sum_{i=1}^n x_i}{\widehat p} &- \frac{n-\sum_{i=1}^n x_i}{1-\widehat p} = 0 \\
\frac{\sum_{i=1}^n x_i}{\widehat p} &= \frac{n-\sum_{i=1}^n x_i}{1-\widehat p} \\
\frac{\sum_{i=1}^n x_i}{n-\sum_{i=1}^n x_i} &= \frac{\widehat p}{1-\widehat p} \\[3ex]
\bar X - 1 &= \widehat p - 1 \\
\bar X &= \widehat p
\end{alignedat}
$$

## MLE Examples

In this lesson, we'll look at some additional MLE examples. MLEs will become very important when we eventually carry out goodness-of-fit tests.

### Normal Example

Suppose we have $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Nor}(\mu, \sigma^2)$. Let's find the simultaneous MLE's for $\mu$ and $\sigma^2$:

$$
\begin{alignedat}{1}
L(\mu, \sigma^2) &= \prod_{i=1}^n f(x_i) \\
&= \prod_{i=1}^n \frac{1}{\sqrt{2\pi\sigma^2}}\exp\left\{-\frac{1}{2}\frac{(x_i - \mu)^2}{\sigma^2}\right\} \\
&= \frac{1}{(2\pi\sigma^2)^{n/2}}\exp\left\{-\frac{1}{2}\sum_{i=1}^n\frac{(x_i - \mu)^2}{\sigma^2}\right\}
\end{alignedat}
$$

Let's take the natural log:

$$
\ln(L(\mu, \sigma^2)) = -\frac{n}{2}\ln(2\pi) - \frac{n}{2}\ln(\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^n (x_i - \mu)^2
$$

Let's take the first derivative with respect to $\mu$, to find the MLE, $\widehat\mu$, for $\mu$. Remember that the derivative of terms that don't contain $\mu$ are zero:

$$
\frac{\partial}{\partial\mu} \ln(L(\mu, \sigma^2)) = \frac{\partial}{\partial\mu} \frac{-1}{2\sigma^2}\sum_{i=1}^n(x_i - \mu)^2
$$

What's the derivative of $(x_i - \mu)^2$ with respect to $\mu$? Naturally, it's $-2(x_i - \mu)$. Therefore:

$$
\frac{\partial}{\partial\mu} \ln(L(\mu, \sigma^2)) = \frac{1}{\sigma^2}\sum_{i=1}^n(x_i - \mu)
$$

We can set the expression on the right equal to zero and solve for $\widehat\mu$:

$$
0 = \frac{1}{\sigma^2}\sum_{i=1}^n(x_i - \widehat\mu)
$$

If we solve for $\widehat\mu$, we see that $\widehat\mu = \bar X$, which we expect. In other words, the MLE for the true mean, $\mu$, is the sample mean, $\bar X$.

Now, let's take the derivative of $\ln(L(\mu,\sigma^2))$ with respect to $\sigma^2$. Consider:

$$
\frac{\partial}{\partial\sigma^2} \ln(L(\mu, \sigma^2)) = -\frac{n}{2\sigma^2} + \frac{1}{2\sigma^4}\sum_{i=1}^n (x_i - \widehat\mu)^2
$$

We can set the expression on the right equal to zero and solve for $\widehat{\sigma^2}$:

$$
\begin{alignedat}{1}
-\frac{n}{2\widehat{\sigma^2}} + \frac{1}{2\widehat{\sigma^4}}\sum_{i=1}^n (x_i - \widehat\mu)^2 &= 0 \\
\frac{1}{2\widehat{\sigma^4}}\sum_{i=1}^n (x_i - \widehat\mu)^2 &= \frac{n}{2\widehat{\sigma^2}} \\
\frac{1}{n}\sum_{i=1}^n (x_i - \widehat\mu)^2 &= \frac{2\widehat{\sigma^4}}{2\widehat{\sigma^2}} \\
\frac{\sum_{i=1}^n(X_i - \bar X)^2}{n} &= \widehat{\sigma^2}
\end{alignedat}
$$

Notice how close $\widehat{\sigma^2}$ is to the unbiased sample variance:

$$
S^2 = \frac{\sum_{i=1}^n(X_i - \bar X)^2}{n - 1} = \frac{n\widehat{\sigma^2}}{n-1}
$$

Because $S^2$ is unbiased, we have to expect that $\widehat{\sigma^2}$ is slightly biased. However, $\widehat{\sigma^2}$ has slightly less variance than $S^2$, making it the MLE. Regardless, the two quantities converge as $n$ grows.

### Gamma Example

Let's look at the Gamma distribution, parameterized by $r$ and $\theta$. The pdf for this distribution is shown below. Recall that $\Gamma(r)$ is the [gamma function](https://en.wikipedia.org/wiki/Gamma_function).

$$
f(x) = \frac{\lambda^r}{\Gamma(r)}x^{r-1}e^{-\lambda x}, \quad x > 0
$$

Suppose we have $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Gam}(r, \lambda)$. Let's find the MLE's for $r$ and $\lambda$:

$$
\begin{alignedat}{1}
L(r, \lambda) &= \prod_{i=1}^n f(x_i) \\[3ex]
&= \frac{\lambda^{nr}}{[\Gamma(r)]^n} \left(\prod_{i=1}^n x_i\right)^{r-1}e^{-\lambda\sum_i x_i}
\end{alignedat}
$$

Let's take the natural logarithm of both sides, remembering that $\ln(a/b) = \ln(a) - \ln(b)$:

$$
\ln(L) = rn\ln(\lambda) - n\ln(\Gamma(r)) + (r-1)\ln\left(\prod_ix_i\right) - \lambda\sum_ix_i
$$

Let's get the MLE of $\lambda$ first by taking the derivative with respect to $\lambda$. Notice that the middle two terms disappear:

$$
\frac{\partial}{\partial\lambda}\ln(L) = \frac{rn}{\lambda} - \sum_{i=1}^n x_i
$$

Let's set the expression on the right equal to zero and solve for $\widehat\lambda$:

$$
\begin{alignedat}{1}
0 &= \frac{\widehat rn}{\widehat\lambda} - \sum_{i=1}^n x_i \\
\sum_{i=1}^n x_i &= \frac{\widehat rn}{\widehat\lambda} \\
\widehat\lambda &= \frac{\widehat rn}{\sum_{i=1}^n x_i}  = \widehat r / \bar X\\
\end{alignedat}
$$

It turns out the mean of the Gamma distribution is $r / \lambda$. If we pretend that $\bar X = \mu$ then we can see how, with a simple rearrangement, that $\widehat\lambda = \widehat r / \bar X$.

Now let's find the MLE of $r$. First, we take the derivative with respect to $r$:

$$
\frac{\partial}{\partial r}\ln(L) = n\ln(\lambda) - \frac{n}{\Gamma(r)}\frac{d}{dr}\Gamma(r) + \ln\left(\prod_ix_i\right)
$$

We can define the digamma function, $\Psi(r)$, to help us with the term involving the gamma function and it's derivative:

$$
\Psi(r) \equiv \Gamma'(r) / \Gamma(r)
$$

At this point, we can substitute in $\widehat\lambda = \widehat r/\bar X$, and then use a computer to solve the following equation, either by bisection, Newton's method, or some other method:

$$
n\ln(\widehat r/\bar X) - n\Psi(r) + \ln\left(\prod_ix_i\right) = 0
$$

The challenging part of evaluating the digamma function is computing the derivative of the gamma function. We can use the definition of the derivative here to help us, choosing our favorite small $h$ and then evaluating:

$$
\Gamma'(r) \approx \frac{\Gamma(r+h) - \Gamma(r)}{h}
$$

### Uniform Example

Suppose we have $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Unif}(0, \theta)$. Let's find the MLE for $\theta$.

Remember that the pdf $f(x) = 1/\theta, 0 < x < \theta$. We can take the likelihood function as the product of the $f(x_i)$'s:

$$
L(\theta) = \prod_{i=1}^n f(x_i) = \begin{cases}
1/\theta^n,& \text{if } 0 \leq x_i \leq \theta, \forall i \\
0 & \text{otherwise}
\end{cases}
$$

In order to have $L(\theta) > 0$, we must have $0 \leq x_i \leq \theta, \forall i$. In other words, $\theta$ must be at least as large as the largest observation we've seen yet: $\theta \geq \max_i x_i$.

Subject to this constraint, $L(\theta) = 1 / \theta^n$ is **not** maximized at $\theta = 0$. Instead $L(\theta) = 1 / \theta^n$ is maximized at the smallest possible $\theta$ value, namely $\widehat\theta = \max_i X_i$.

This result makes sense in light of the similar (unbiased) estimator $Y_2 = (n+1)\max_i X_i/n$ that we saw previously.

## Invariance Properties of MLEs

In this lesson, we will expand the vocabulary of maximum likelihood estimators by looking at the invariance property of MLEs. In a nutshell, if we have the MLE for some parameter, then we can use the invariance property to determine the MLE for any reasonable function of that parameter.

### Invariance Property of MLE's
If $\widehat{\theta}$ is the MLE of some parameter, $\theta$, and $h(\cdot)$ is a 1:1 function, then $h(\widehat{\theta})$ is the MLE of $h(\theta)$.

Remember that this invariance property does *not* hold for unbiasedness. For instance, we said previously that the sample variance is an unbiased estimator for the true variance because $E[S^2] = \sigma^2$. However, $E[\sqrt{S^2}] \neq \sigma$, so we cannot use the sample standard deviation as an unbiased estimator for the true standard deviation.

### Examples

Suppose we have a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Bern}(p)$. We might remember that the MLE of $p$ is $\widehat p = \bar X$. If we consider the 1:1 function $h(\theta) = \theta^2, \theta > 0$, then the invariance property says that the MLE of $p^2$ is $\bar X^2$.

Suppose we have a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Nor}(\mu, \sigma^2)$. We saw previously that the MLE for $\sigma^2$ is:

$$
\widehat{\sigma^2} = \frac{1}{n} \sum_{i=1}^n (X_i - \bar X)^2
$$

We just said that we couldn't take the square root of $S^2$ to estimate $
\sigma$ in an unbiased way. However, we can use the square root of $\widehat{\sigma^2}$ to get the MLE for $\sigma$.

If we consider the 1:1 function $h(\theta) = +\sqrt\theta$, then the invariance property says that the MLE of $\sigma$ is:

$$
\widehat\sigma = \sqrt{\widehat{\sigma^2}} = \sqrt\frac{\sum_{i=1}^n (X_i - \bar X)^2}{n}
$$

Suppose we have a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)$. The **survival function**, $\bar{F}(x)$, is:

$$
\bar{F}(x) = P(X > x) = 1 - F(x) = 1 - (1 - e^{-\lambda x}) = e^{-\lambda x}
$$

We saw previously the the MLE for $\lambda$ is $\widehat\lambda = 1/\bar X$.Therefore, using the invariance property, we can see that the MLE for $\bar{F}(x)$ is $\bar{F}(\widehat{\lambda})$:

$$
\widehat{\bar{F}(x)} = e^{-\widehat{\lambda}x} = e^{-x / \bar{X}}
$$

The MLE for the survival function is used all the time in actuarial sciences to determine - somewhat gruesomely, perhaps - the probability that people will live past a certain age.

## The Method of Moments (Optional)

In this lesson, we'll finish off our discussion on estimators by talking about the Method of Moments.

### The Method Of Moments

The $k$th **moment** of a random variable $X$ is:

$$
E[X^k] = \begin{cases}
\sum_x x^k f(x) & \text{if X is discrete} \\
\int_{\mathbb{R}} x^k f(x)dx & \text{if X is continuous} 
\end{cases}
$$

Suppose we have a sequence of random variables, $X_1,...,X_n$, which are iid from pmf/pdf $f(x)$. The **method of moments** (MOM) estimator for $E[X^k]$, $m_k$, is:

$$
m_k = \frac{1}{n} \sum_{i=1}^n X_i^k
$$

Note that $m_k$ is equal to the sample average of the $X_i^k$'s. Indeed, the MOM estimator for $\mu = E[X_i]$, is the sample mean, $\bar X$:

$$
m_1 = \frac{1}{n} \sum_{i=1}^n X_i = \bar X = E[X_i]
$$

Similarly, we can find the MOM estimator for $k=2$:

$$
m_2 = \frac{1}{n}\sum_{i=1}^n X_i^2 = E[X_i^2]
$$


We can combine the MOM estimators for $k=1,2$ to produce an expression for the variance of $X_i$:

$$
\begin{alignedat}{1}
\text{Var}(X_i) &= E[X_i^2] - (E[X_i])^2 \\
&= \frac{1}{n}\sum_{i=1}^n X_i^2 - \bar X^2 \\
&= \sum_{i=1}^n\left(\frac{X_i^2}{n}\right) - \bar X^2 \\
&= \sum_{i=1}^n\left(\frac{X_i^2}{n} - \frac{\bar X^2}{n} \right)  \\
&= \frac{1}{n}\sum_{i=1}^n\left(X_i^2 - \bar X^2 \right)  \\
&= \frac{n-1}{n}S^2
\end{alignedat}
$$

Of course, it's perfectly okay to use $S^2$ to estimate the variance, and the two quantities converge as $n$ grows.

### Poisson Example

Suppose that $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Pois}(\lambda)$. We know that, for the Poisson distribution, $E[X_i] = \lambda$, so a MOM estimator for $\lambda$ is $\bar X$.

We might remember that the variance of the Poisson distribution is also $\lambda$, so another MOM estimator for $\lambda$ is:

$$
\frac{n-1}{n}S^2
$$

As we can see, we have two different estimators for $\lambda$, both of which are MOM estimators. In practice, we usually will use the easier-looking estimator if we have a choice.

### Normal Example

Suppose that $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Nor}(\mu, \sigma^2)$. We know that the MOM estimators for $\mu$ and $\sigma^2$ are $\bar X$ and $(n-1)S^2 / n$, respectively. For this example, these estimators happen to be the same as the MLEs.

### Beta Example

Now let's look at a less trivial example. Here we might really rely on MOM estimators because we cannot find the MLEs so easily.

Suppose that $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Beta}(a, b)$. The beta distribution has the following pdf:

$$
f(x) = \frac{\Gamma(a+b)}{\Gamma(a)\Gamma(b)}x^{a-1}(1-x)^{b-1}, \quad 0 < x < 1
$$

After much algebra, it turns out that:

$$
\begin{alignedat}{1}
E[X] &= \frac{a}{a+b} \\[2ex]
\text{Var}(X) &= \frac{ab}{(a+b)^2(a+b+1)} = \frac{E[X]b}{(a+b)(a+b+1)}
\end{alignedat}
$$

Let's find MOM estimators for $a$ and $b$. Given the expected value above, let's solve for $a$:

$$
\begin{alignedat}{1}
E[X] &= \frac{a}{a+b} \\
(a+b)E[X] &= a \\
aE[X] + bE[X] &= a \\
bE[X] &= a - aE[X] \\
bE[X] &= a(1 - E[X]) \\
\frac{bE[X]}{1 - E[X]} &= a
\end{alignedat}
$$

Since we know that $\bar X$ is the MOM estimator for $E[X]$, we have a reasonable approximation for $a$:

$$
a \approx \frac{b\bar X}{1-\bar X}
$$

We can solve for $b$ by making the following substitutions into the variance equation above: $\bar X$ for $E[X]$, $S^2$ for $\text{Var}(X)$, and the approximation of $a$, in terms of $\bar X$ and $b$, for $a$. After a bunch of algebra, we have the MOM estimator for $b$:

$$
b \approx \frac{(1 - \bar X)^2\bar X}{S^2} - 1 + \bar X
$$


Let's plug $b$ back into our approximation for $a$ to get $a$ in terms of $S^2$ and $\bar X$:

$$
\begin{alignedat}{1}
a &\approx \frac{\left(\frac{(1 - \bar X)^2\bar X}{S^2} - 1 + \bar X\right)\bar X}{1-\bar X} \\[3ex]
&\approx \frac{\frac{(1 - \bar X)^2\bar X^2}{S^2} + \bar X^2 - \bar X }{1-\bar X} \\[3ex]
&\approx \frac{(1 - \bar X)^2\bar X^2}{S^2(1 - \bar X)} + \frac{\bar X^2}{1 - \bar X} - \frac{\bar X}{1 - \bar X} \\[3ex]
&\approx \frac{(1 - \bar X)\bar X^2}{S^2} + \frac{\bar X^2 - \bar X}{1 - 
\bar X} \\[3ex]
&\approx \frac{(1 - \bar X)\bar X^2}{S^2} + \frac{\bar X^2 - \bar X}{1 - 
\bar X} \\[3ex]
&\approx \bar X \left[\frac{(1 - \bar X)\bar X}{S^2} + \frac{\bar X - 1}{1 - \bar X}\right] \\
&\approx \bar X \left[\frac{(1 - \bar X)\bar X}{S^2} - 1\right]
\end{alignedat}
$$

If we plug and chug with the following $\bar X$ and $S^2$, we should get the following values for the MOM estimators for $a$ and $b$.

![](https://assets.omscs.io/notes/2020-10-29-21-08-53.png)

## Goodness-of-Fit Tests

In this lesson, we'll start our discussion on goodness-of-fit tests. We use these tests to assess whether a particular simulation input distribution accurately reflects reality.

### What We've Done So Far

Until now, we've guessed at reasonable distributions and estimated the relevant parameters based on the data. We've used different estimators, such as MLEs and MOM estimators. Now we will conduct a formal test to validate the work we've done. If our guesses and estimations are close, our tests should reflect that.

In particular, we will conduct a formal hypothesis test to determine whether a series of observations, $X_1,...,X_n$, come from a particular distribution with pmf/pdf, $f(x)$. Here's our null hypothesis:

$$
H_0: X_1,...,X_n \overset{\text{iid}}{\sim} \text{ p.m.f, / p.d.f. } f(x)
$$

We will perform this hypothesis test at a level of significance, $\alpha$, where:

$$
\alpha \equiv P(\text{Reject } H_0 | H_0 \text{ true}) = P(\text{Type I error})
$$

As usual, we assume that $H_0$ is true, only rejecting it if we get ample evidence to the contrary. The distribution is innocent until proven guilty. Usually, we choose $\alpha$ to be $0.05$ or $0.01$.

### High-Level View of Goodness-Of-Fit Test Procedure

Let's first divide the domain of $f(x)$ into $k$ sets, $A_1, A_2,...,A_k$. If $X$ is discrete, then each set will consist of distinct points. If $X$ is continuous, then each set will contain an interval.

Second, we will tally the number of observations that fall into each set. We refer to this tally as $O_i, i = 1, 2, ..., k$. For example, $O_1$ refers to the number of observations we see in $A_1$. Remember that $\sum_i O_i = n$, where $n$ is the total number of observations we collect.

If $p_i \equiv P(X \in A_i)$, then $O_i \sim \text{Bin}(n, p_i)$. In other words $O_i$ counts the number of sucesses - landing in set $A_i$ - given $n$ trials, where the probability of success is $p_i$. Because $O_i$ is binomial, the expected number of observations that fall in each set, assuming $H_0$ is $E_i = E[O_i] = np_i, i = 1,2,...,k$.

Next, we calculate a test statistic based on the differences between the $E_i$'s and $O_i$'s. The **chi-squared g-o-f** test statistic is:

$$
\chi^2_0 \equiv \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i}
$$

If the distribution we've guessed fits the data well, then the $E_i$'s and $O_i$'s will be very close, and $\chi^2_0$ will be small. On the other hand, if we've made a bad guess, $\chi^2_0$ will be large.

As we said, a large value of $\chi^2_0$ indicates a bad fit. In particular, we *reject* $H_0$ if:

$$
X^2_0 > X^2_{\alpha, k-1-s}
$$

Remember that $k$ refers to the number of sets we have generated from the domain of $f(x)$, and $\alpha$ refers to the level of significance at which we wish to conduct our test.

Here, $s$ refers to the number of unknown parameters from $f(x)$ that have to be estimated. For example, if $X \sim \text{Exp}(\lambda)$, then $s= 1$. If $X \sim \text{Nor}(\mu, \sigma^2)$, then $s = 2$.

Additionally, $\chi^2_{\alpha, v}$ refers to the $(1 - \alpha)$ quantile of the $\chi^2_v$ distribution. Specifically:

$$
P(X^2_v < \chi^2_{\alpha, v}) = 1 - \alpha
$$

If $\chi^2_0 \leq X^2_{\alpha, k-1-s}$, we *fail to reject* $H_0$.

### Remarks

In order to ensure that the test gives good results, we want to select $k$ such that $E_i \geq 5$ and pick $n \geq 30$. 

If the degrees of freedom, $v = k - 1 - s$, is large, than we can approximate $\chi^2_{a,v}$ using the corresponding standard normal quantile, $z_\alpha$:

$$
\chi^2_{\alpha, v} \approx v\left[1 - \frac{2}{9v} + z_\alpha \sqrt\frac{2}{9v}\right]^3
$$ 

If we don't want to use the $\chi^2$ goodness-of-fit test, we can use a different test, such as Kolmogorov-Smirnov, Anderson-Darling, or Shapiro-Wilk, among others.

### Uniform Example

Let's test our null hypothesis that a series of observations, $X_1,...X_n$, are iid Unif(0,1). Suppose we collect $n=1000$ observations, where $0 \leq X_i \leq 1$, and we divide the unit interval into $k=5$ sets. Consider the following $O_i$'s and $E_i$'s below:

$$
\begin{array}{c|ccccc}
\text{interval} & [0,0.2] & (0.2, 0.4] & (0.4, 0.6] & (0.6, 0.8] & (0.8, 1.0] \\ \hline
E_i & 200 & 200 & 200 & 200 & 200 \\
O_i & 179 & 208 & 222 & 199 & 192 \\
\end{array}
$$

The $O_i$'s refer to the actual number of observations that landed in each interval. Remember that, since $O_i \sim \text{Bin}(n, p_i)$, $E[O_i] = np_i = 1000 * 0.2 = 200$. 

Let's calculate our goodness-of-fit statistic:

$$
\begin{alignedat}{1}
\chi^2_0 &= \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i} \\
&= \frac{1}{200} ((179 - 200)^2 + ... + (192 - 200)^2) \\
&= 5.27
\end{alignedat}
$$

Let's set our significance level to $\alpha = 0.05$. Since there are no unknown parameters, $s = 0$, so $k - 1 - s = 4$. Therefore:

$$
\chi^2_{\alpha, k - 1 - s} = \chi^2_{0.05, 4} = 9.49 \text{ (tabled) } 
$$ 

Since $\chi^2_0 \leq \chi^2_{0.05, 4}$, we fail to reject the null hypothesis and begrudgingly accept that the $X_i$'s are iid Unif(0,1).

### Discrete Example

Let's hypothesize that the number of defects in a printed circuit board follows a Geometric($p$) distribution. Let's look at a random sample of $n = 70$ boards and observe the number of defects. Consider the following table:

$$
\begin{array}{cc}
\text{\# defects} & \text{frequency} \\ \hline
1 & 34 \\
2 & 18 \\
3 & 2 \\
4 & 9 \\ 
5 & 7 \\ \hline
& 70
\end{array}
$$

Now let's test the null hypothesis that $X_1,...,X_{70} \sim \text{Geom}(p)$. We can start by estimating $p$ via the MLE. The likelihood function is:

$$
\begin{alignedat}{1}
L(p) &= \prod_{i = 1}^nf(x_i) \\
&= \prod_{i = 1}^n(1-p)^{x_i - 1}p \\
&= (1-p)^{\sum_{i=1}^n x_i - n}p^n
\end{alignedat}
$$

Let's take the natural log of both sides:

$$
\begin{alignedat}{1}
\ln(L(p)) &= \ln((1-p)^{\sum_{i=1}^n x_i - n}p^n) \\
&= \left(\sum_{i=1}^n x_i - n\right)\ln(1-p) + n\ln(p) \\
\end{alignedat}
$$

Now, let's take the derivative:

$$
\frac{d\ln(L(p))}{dp} = \frac{-\sum_{i=1}^n x_i - n}{1-p} + \frac{n}{p}
$$

Now, let's set the expression on the right to zero and solve for $\widehat p$:

$$
\begin{alignedat}{1}
0 = \frac{-\sum_{i=1}^n x_i - n}{1-\widehat p} & + \frac{n}{\widehat p} \\[3ex]
\frac{\sum_{i=1}^n x_i - n}{1-\widehat p} & = \frac{n}{\widehat p} \\[3ex]
\frac{\sum_{i=1}^n x_i - n}{n} & = \frac{1-\widehat p}{\widehat p} \\[3ex]
\bar X - 1 &= \frac{1}{\widehat p} - 1 \\[3ex]
\widehat{p} &= \frac{1}{\bar X}
\end{alignedat}
$$

We know that, for $X \sim \text{Geom}(p)$, $E[X] = 1 / p$. Therefore, it makes sense that our estimator, $\widehat p$, is equal to $1 / \bar X$. Anyway, let's compute $\widehat p$:

$$
\widehat p = \frac{1}{\bar X} = \frac{70}{1(34) + 2(18) + 3(2) + 4(9) + 5(7)} = 0.476
$$

Given $\widehat p = 0.476$, let's turn to the goodness-of-fit test statistic. We have our $O_i$'s, and now we can compute our $E_i$'s. By the invariance property of MLEs, the MLE for the expected number of boards, $\widehat E_x$, having a particular number of defects, $x$, is equal to $nP(X=x) = n(1-\widehat p)^{x-1}\widehat p$.

Consider the following table. Of course, $X$ can take values from $1$ to $\infty$, so we'll condense $P(X \in [5, \infty))$ into the last row of the table.

$$
\begin{array}{cccc}
x & P(X = x) & \widehat E_x & O_x \\ \hline
1 & 0.4762 & 33.33 & 34 \\
2 & 0.2494 & 17.46 & 18 \\
3 & 0.1307 & 9.15 & 2 \\
4 & 0.0684 & 4.79 & 9 \\
\geq 5 & 0.0752 & 5.27 & 7 \\ \hline
& 1.0000 & 70 & 70
\end{array}
$$

Remember that we said we'd like to ensure that $E_i \geq 5$ in order for the goodness-of-fit test to work correctly. Unfortunately, in this case, $E_4 < 5$. No problem. Let's just roll $X = 4$ into $X \geq 5$:

$$
\begin{array}{cccc}
x & P(X = x) & E_x & O_x \\ \hline
1 & 0.4762 & 33.33 & 34 \\
2 & 0.2494 & 17.46 & 18 \\
3 & 0.1307 & 9.15 & 2 \\
\geq 4 & 0.1436 & 10.06 & 16 \\ \hline
& 1.0000 & 70 & 70
\end{array}
$$

Let's compute the test statistic:

$$
\chi^2_0 = \sum_{x=1}^4 \frac{(E_x - O_x)^2}{E_x} = \frac{(33.33 - 34)^2}{33.33} + ... = 9.12
$$

Now, let's compare our test statistic to the appropriate $\chi^2$ quantile. We know that $k = 4$, since we partitioned the values that $X$ can take into four sets. We also know that $s = 1$, since we had to estimate one parameter. Given $\alpha = 0.05$:

$$
\chi^2_{\alpha, k-1-s} = \chi^2_{0.05, 2} = 5.99
$$

Since $\chi^2_0 = 9.12 > \chi^2_{0.05, 2} = 5.99$, we reject $H_0$ and conclude that the number of defects in circuit boards probably isn't geometric.

## Exponential Example

In this lesson, we'll apply a goodness-of-fit test for the exponential distribution. It turns out that we can apply the general recipe we'll walk through here to other distributions as well.

### Continuous Distributions

For continuous distributions, let's denote the intervals $A_i \equiv (a_{i-1}, a_i], i = 1,2,...,k$. For convenience, we want to choose the $a_i$'s such that $X$ has an equal probability of landing in any interval, $A_i$. In other words:

$$
p_i = P(X \in A_i) = P(a_{i-1} < X \leq a_i) = 1/k, \quad \text{for all } i
$$

### Example

Suppose that we're interested in fitting a distribution to a series of interarrival times. Let's assume that the observations are exponential:

$$
H_0 : X_1, X_2,...,X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)
$$

We want to perform a $\chi^2$ goodness-of-fit test with *equal-probability intervals*, which means we must choose $a_i$'s such that:

$$
F(a_i) = P(X \leq a_i) = 1 - e^{-\lambda a_i} = \frac{i}{k}, \quad i = 1,2,...,k
$$

If the intervals are equal probability, then the probability that an observation falls in any of the $k$ intervals must equal $1 / k$. Correspondingly, $F(x)$ must increase by $1/k$ as it sweeps through each interval, until $F(a_n) = 1$.

In any event, let's solve for $a_i$:

$$
\begin{alignedat}{1}
\frac{i}{k} &= 1 - e^{-\lambda a_i} \\
e^{-\lambda a_i} &= 1 - \frac{i}{k} \\
-\lambda a_i &= \ln\left(1 - \frac{i}{k}\right) \\
a_i &= \frac{-1}{\lambda}\ln\left(1 - \frac{i}{k}\right) \\
\end{alignedat}
$$

Unfortunately, $\lambda$ is unknown, so we cannot calculate the $a_i$'s. We have to estimate $\lambda$. Thankfully, we might remember that the MLE is $\widehat\lambda = 1 / \bar X$. Thus, by the invariance property, the MLEs of the $a_i$'s are:

$$
\begin{alignedat}{1}
\widehat a_i &= \frac{-1}{\widehat\lambda}\ln\left(1 - \frac{i}{k}\right) \\
&= -\bar X \ln\left(1 - \frac{i}{k}\right), \quad i = 1,2,...,k
\end{alignedat}
$$

Suppose that we take $n = 100$ observations and divide them into $k=5$ equal-probability intervals. Let's also suppose that the same mean based on these observations is $\bar X = 9.0$. Then:

$$
\widehat a_i = -9.0\ln\left(1 - 0.2i\right), \quad i = 1,...,5
$$

Given this formula, let's compute our first equal-probability interval:

$$
\begin{alignedat}{1}
(\widehat a_0, \widehat a_1] &= (-9.0\ln\left(1 - 0.2(0)\right), -9.0\ln\left(1 - 0.2(1)\right)] \\
&= (-9.0\ln\left(1\right), -9.0\ln\left(0.8\right)] \\
&= (0, 2.01]
\end{alignedat}
$$

What's the expected number of observations in each interval? Well, since we made sure to create equal-probability intervals, the expected value for each interval is:

$$
E_i = np_i = \frac{n}{k}
$$

Now let's tally up how many observations fall in each interval, and record our $O_i$'s. Consider the following table:

$$
\begin{array}{c|cc}
\text{interval }(a_{i-1}, a_i] & O_i & E_i = n/k \\ \hline
(0,2.01] & 25 & 20 \\
(2.01,4.60] & 27 & 20 \\
(4.60, 8.25] & 23 & 20 \\
(8.25,14.48] & 13 & 20 \\
(14.48, \infty) & 12 & 20 \\ \hline
& 100 & 100
\end{array}
$$

Given these observations and expectations, we can compute our $\chi^2_0$ goodness-of-fit statistic:

$$
\chi^2_0 = \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i} = 9.80
$$

Let's choose the appropriate $\chi^2$ quantile. We'll use $\alpha = 0.05$ and $v = k - 1 - s$. Since $s = 1$ - remember, we estimated $\lambda$ - then $v = 5 - 1 - 1 = 3$. Therefore:

$$
\chi^2_{\alpha, k-1-s} = \chi^2_{0.05,3} = 7.81
$$

Since our test statistic is greater than our quantile, we must reject $H_0$ and conclude that the observations are not exponential.

## Weibull Example

In this lesson, we'll carry out a goodness-of-fit test for observations supposedly coming from the Weibull distribution. This procedure will take more work than the exponential, but it's more general, as the Weibull generalizes the exponential.

### Weibull Example

Let's suppose that we have a series of observations, $X_1, X_2,...,X_n$, and we hypothesize that they are coming from a Weibull($r$, $\lambda$) distribution. The Weibull distribution has the following cdf:

$$
F(x) = 1 - e^{-(\lambda x)^r}, \quad x \geq 0
$$

We say that the Weibull generalizes the exponential because, for $r=1$, $F(x)$ is the cdf of the exponential distribution:

$$
F(x) = 1 - e^{-\lambda x}, \quad x \geq 0
$$

Like we did with the exponential, we'd like to conduct a $\chi^2$ goodness-of-fit test with *equal-probability intervals*. In other words, we will choose interval boundaries, $a_i$'s, such that:

$$
F(a_i) = 1 - e^{-(\lambda a_i)^r} = \frac{i}{k}
$$

If the intervals are equal probability, then the probability that an observation falls in any of the $k$ intervals must equal $1 / k$. Correspondingly, $F(x)$ must increase by $1/k$ as it sweeps through each interval, until $F(a_n) = 1$.

Let's now solve for $a_i$:

$$
\begin{alignedat}{1}
1 - e^{-(\lambda a_i)^r} &= \frac{i}{k} \\
1 - \frac{i}{k} &= e^{-(\lambda a_i)^r} \\
\ln\left[1 - \frac{i}{k}\right] &= -(\lambda a_i)^r \\
\ln\left[1 - \frac{i}{k}\right]^{1/r} &= -\lambda a_i \\
\frac{-1}{\lambda}\ln\left[1 - \frac{i}{k}\right]^{1/r} &= a_i, \quad i = 1,2,...,k
\end{alignedat}
$$

Since $\lambda$ and $r$ are unknown, we'll have two MLEs, so $s=2$. Remember that $s$ is a parameter whose value we subtract from the degrees of freedom of the $\chi^2$ distribution whose quantile we take during our test.

Let's differentiate the cdf, $F(x)$, to get the pdf, $f(x)$:

$$
f(x) = \lambda r (\lambda x)^{r-1}e^{-(\lambda x)^r}, \quad x \geq 0
$$

From there, we can take the likelihood function for an iid sample of size $n$:

$$
L(r, \lambda) = \prod_{i=1}^n f(x_i) = \lambda^{nr}r^n\prod_{i=1}^n x_i^{r-1} \exp\left[-\lambda^r \sum_{i=1}^n x^r_i\right]
$$

If we take the natural logarithm of the likelihood function, we get:

$$
\ln(L) = n\ln(r) + (r-1)\ln\left(\prod^n_{i=1}x_i\right) + nr\ln(\lambda) - \lambda^r \sum_{i=1}^n x_i^r
$$

Now, we have to maximize $L$ with respect to $r$ and $\lambda$. To do so, we take the partial derivative of $L$ with respect to the appropriate parameter, set it to zero, and solve for that parameter. After a bunch of algebra, we get this value for $\lambda$:

$$
\lambda = \left(\sum_{i=1}^n x_i^r\right)^{-1/r}
$$

Correspondingly, we get the following function for $r$, such that $f(\widehat r) = 0$:

$$
g(r) = \frac{n}{r} + \sum_{i=1}^n \ln(x_i) - \frac{n \sum_i x_i^r \ln(x_i)}{\sum_i x_i^r}
$$

How do we find the zero? Let's try Newton's method. Of course, to use this method, we need to know the derivative of $g(r)$:

$$
g'(r) = -\frac{n}{r^2} - \frac{n\sum_ix^r_i[\ln(x_i)]^2}{\sum_ix_i^r} + \frac{n\left[\sum_i x^r_i \ln(x_i)\right]^2}{\left[\sum_i x^r_i\right]^2}
$$

Here's a reasonable implementation of Newton's method. Let's initialize $\widehat r_0 = \bar X / S$, where $\bar X$ is the sample mean, and $S^2$ is the sample variance. Then, we iteratively improve our guess for $\widehat r$, using Newton's method:

$$
\widehat r_j \leftarrow \widehat r_{j-1} - \frac{g(\widehat r_{j-1})}{g'(\widehat r_{j-1})}
$$

If $|g(\widehat r_{j-1})| < 0.001$, then we stop and set the MLE $\widehat r = \widehat r_j$. Otherwise, we continue refining $\widehat r_j$. Once we have $\widehat r$, to which Newton's method converges after only three or four iterations, we can immediately get $\widehat \lambda$:

$$
\widehat \lambda = \left(\sum_{i=1}^n x_i^{\widehat r}\right)^{-1/\widehat r}
$$

Then, by invariance, we finally have the MLEs for the equal-probability interval endpoints:

$$
\widehat a_i = \frac{1}{\widehat \lambda} \left[-\ln\left(1 - \frac{i}{k}\right) \right]^{1 / \widehat r}, i = 1,2,...,k
$$

Let's suppose we take $n=50$ observations and divide them into $k= 8$ equal-probability intervals. Moreover, let's suppose that we calculate that $\widehat r = 0.525$ and $\widehat \lambda = 0.161$. Given these parameters:

$$
\widehat a_i = 6.23 \left[-\ln\left(1 - \frac{i}{8}\right) \right]^{1.905}, i = 1,2,...,k
$$

Further suppose that we get the following $O_i$'s:

$$
\begin{array}{c|cc}
(\hat a_{i-1}, \hat a_i] & O_i & E_i = n / k \\ \hline
(0,0.134] & 6 & 6.25 \\
(0.134,0.578] & 5 & 6.25 \\
\vdots \\
(11.54,24.97] & 5 & 6.25 \\
(24.97, \infty] & 6 & 6.25 \\ \hline
& 50 & 50
\end{array}
$$

Let's compute our $\chi^2$ goodness-of-fit statistic: 

$$
\chi^2_0 = \sum_{i=1}^k = \frac{(O_i - E_i)^2}{E_i} = 1.20
$$

Given $\alpha = 0.05$ and $v = 8 - 1 - 2 = 5$, our quantile is:

$$
\chi^2_{0.05, 5} = 11.1
$$

Since our test statistic is less than our quantile, we fail to reject the null hypothesis and assume that the observations are coming from a Weibull distribution.

## Still More Goodness-of-Fit Tests

In this lesson, we'll look at other types of goodness-of-fit tests. In particular, we will look at Kolmogorov-Smirnov, which works well when we have small samples.

### Kolmogorov-Smirnov Goodness-of-Fit Test

There are plenty of goodness-of-fit tests that we can use instead of the $\chi^2$ test. The advantage of the **Kolmogorov-Smirnov test** (K-S) is that it works well in low-data situations, although we can use it perfectly well when we have ample data, too.

As usual, we'll test the following null hypothesis:

$$
H_0: X_1, X_2,...,X_n \overset{\text{iid}}{\sim} \text{some distribution with cdf } F(x)
$$

Recall that the *empirical cdf*, or *sample cdf*, of a series of observations, $X_1,...,X_n$, is defined as:

$$
\hat{F}_n(x) \equiv \frac{\text{number of } X_i'\text{s} \leq x}{n}
$$ 

In other words, the cdf of the sample, evaluated at $x$, is equal to the ratio of observations less than or equal to $x$ to the total number of observations. Remember that $\hat F_n(x)$ is a step function that jumps by $1 / n$ at each $X_i$.

For example, consider the empirical cdf of ten Exp(1) observations - in blue below - on which we've superimposed the Exp(1) cdf, in red:

![](https://assets.omscs.io/notes/2020-11-02-19-22-59.png)

Notice that every time the empirical cdf encounters an observation, it jumps up by $1/10$, or $10\%$. If we look at the superimposed red line, we can see that the empirical cdf (generated from just ten observations) and the actual cdf fit each other quite well.

Indeed, the **Glivenko-Cantelli Lemma** says that the empirical cdf converges to the true cdf as the sample size increases: $\hat F_n(x) \to F(x)$ as $n \to \infty$. If $H_0$ is true, then the empirical cdf, $\hat F_n(x)$, should be a good approximation to the true cdf, $F(x)$, for large $n$.

We want to answer the main question: Does the empirical distribution actually support the assumption that $H_0$ is true? If the empirical distribution doesn't closely resemble the distribution that $H_0$ is supposing, we should reject $H_0$.

In particular, the K-S test rejects $H_0$ if the following inequality holds:

$$
D \equiv \max_{x \in \mathbb R} |F(x) - \hat F_n(x)| > D_{\alpha, n}
$$

In other words, we define our test statistic, $D$, as the maximum deviation between the hypothesized cdf, $F(x)$, and the empirical cdf, $\hat F_n(x)$. Note here that $\alpha$ is our level of significance, and $D_{\alpha, n}$ is a tabled K-S quantile. Interestingly, the value of $D_{\alpha, n}$ depends on the particular distribution we are hypothesizing, in addition to $\alpha$ and $n$.

If the empirical cdf diverges significantly from the supposed true cdf, then $D$ will be large. In that case, we will likely reject the null hypothesis and conclude that the observations are probably not coming from the hypothesized cdf.

### K-S Example

Let's test the following null hypothesis:

$$
H_0: X_1, X_2,...,X_n \overset{\text{iid}}{\sim} \text{Unif}(0,1)
$$

Of course, we've used the $\chi^2$ goodness-of-fit test previously to test uniformity. Also, we probably wouldn't test the uniformity of numbers coming from an RNG using K-S because, in that case, we'd likely have millions of observations, and a $\chi^2$ test would be just fine.

However, let's pretend that these $X_i$'s are expensive to obtain, and therefore we only have a few of them; perhaps they are service times that we observed over the course of a day.

Remember the K-S statistic:

$$
D \equiv \max_{x \in \mathbb R} | F(x) - \hat F_n(x)|
$$

Now, remember the cdf for the uniform distribution:

$$
F(x) = \begin{cases}
0, & x < a \\
\frac{x-a}{b-a} & a, \leq x \leq b \\
0, & x > b
\end{cases}
$$

For $a = 0, b = 1$:

$$
F(x) = \begin{cases}
0, & x < 0 \\
x, & 0 \leq x \leq 1 \\
0, & x > 1
\end{cases}
$$

As a result, we can tighten the range of $x$ and substitute in the cdf. Consider:

$$
D = \max_{0 \leq x \leq 1} | x - \hat F_n(x)|
$$

The maximum can only occur when $x$ equals one of the observations, $X_1, X_2, ...,X_n$. At any $X_i$, $\hat F_n(x)$ jumps suddenly from $(i-1) / n$ to $i / n$. Since $x$ doesn't experience a jump itself at this point, the distance between $x$ and $\hat F(x)$ is maximized when $x$ equals some  $X_i$.

Let's first define the ordered points, $X_{(1)} \leq X_{(2)} \leq \cdots \leq X_{(n)}$. For example, if $X_1 = 4$, $X_2 = 1$, and $X_3 = 6$, then $X_{(1)} = 1$, $X_{(2)} = 4$ and $X_{(3)} = 6$.

Instead of computing the maximum over all the $x$-values between zero and one, we only have to compute the maximum taken at the jump points. We can calculate the two potential maximum values:

$$
D^+ \equiv \max_{1 \leq i \leq n}\left\{\frac{i}{n} - X_{(i)}\right\}, \quad D^- \equiv \max_{1 \leq i \leq n}\left\{X_{(i)} - \frac{i-1}{n}\right\}
$$

Given those two values, it turns out that $D = \max(D^+, D^-)$. 

Let's look at a numerical example. Consider:

$$
\begin{array}{c|ccccc}
X_i & 0.039 & 0.706 & 0.016 & 0.198 & 0.793 \\
X_{(i)} & 0.016 & 0.039 & 0.198 & 0.706 & 0.793
\end{array}
$$

Let's calculate the $D^+$ and $D^-$ components:

$$
\begin{array}{c|ccccc}
X_i & 0.039 & 0.706 & 0.016 & 0.198 & 0.793 \\
X_{(i)} & 0.016 & 0.039 & 0.198 & 0.706 & 0.793 \\ \hline
\frac{i}{n} & 0.2 & 0.4 & 0.6 & 0.8 & 1.0 \\
\frac{i-1}{n} & 0 & 0.2 & 0.4 & 0.6 & 0.8 \\
\frac{i}{n} - X_{(i)} & 0.184 & 0.361 & \textbf{0.402} & 0.094 & 0.207 \\
X_{(i)} - \frac{i-1}{n}  & 0.016 & - & - & \textbf{0.106} & - \\
\end{array}
$$

As we can see from the bolded cells, $D^+ = 0.402$, and $D^- = 0.106$, so $D = 0.402$. Now, we can go to a K-S table for the uniform distribution. We set $n=5$ and chose $\alpha = 0.05$, and $D_{0.05, 5} = 0.565$. Because the statistic is less than the quantile, we fail to reject uniformity.

That being said, we encountered several small numbers in our sample, leading us to perhaps intuitively feel as though these $X_i$'s are not uniform. One of the properties of the K-S test is that it is quite conservative: it needs a lot of evidence to reject $H_0$.

### Other Tests

There are many other goodness-of-fit tests, such as:

- Anderson-Darling
- Cramér-von Mises
- Shapiro-Wilk (especially appropriate for testing normality)

We can also use graphical techniques, such as [Q-Q plots](https://en.wikipedia.org/wiki/Q%E2%80%93Q_plot), to evaluate normality. If observations don't fall on a $y= x$ line on a Q-Q plot, we have to question normality.

## Problem Children

In this lesson, we will talk about performing input analysis under problematic circumstances.

### Problem Children

We might think that we can always find a good distribution to fit our data. This assumption is not exactly true, and there are some situations where we have to be careful. For example, we might have little to no data or data that doesn't look like one of our usual distributions. We could also be working with nonstationary data; that is, data whose distribution changes over time. Finally, we might be dealing with multivariate or correlated data.

### No / Little Data

Believe it or not, this issue turns up all the time. For example, at the beginning of every project, there simply are no observations available. Additionally, even if we have data, the data might not be useful when we receive it: it might contain unrealistic, or flat-out wrong, values, or it might not have been cleaned properly. As a concrete example, we can imagine receiving airport data that shows planes arriving before they depart.

What do we do in these situations? We can interview so-called "domain experts" and try to get at least the minimum, maximum, and "most likely" values from them so that we can guess at uniform or triangular distributions. If the experts can provide us with quantiles - what value we should expect 95% of the observations to fall below, for example - that's even better. At the very least, we can discuss the nature of the observations with the expert and try to extract some information that will allow us to make a good guess at the distribution.

If we have some idea about the nature of the random variables, perhaps we can start to make good guesses at the distribution. For example, if we know that the data is continuous, we know that a geometric distribution doesn't make sense. If we know that the observations have to do with arrival times, then we will treat them differently than if they are success/failure binaries. 

Do the observations adhere to Poisson assumptions? If so, then we are looking at the Poisson distribution, if we are counting arrivals, or the exponential distribution, if we are working with interarrival times. Are the observations averages or sums? We might be able to use the central limit theorem and consider the normal distribution. If the observations are bounded, we might consider the beta distribution, which generalizes the uniform and triangular. We might consider the gamma, Weibull, or lognormal distributions if we are working with reliability data or job time data.

Perhaps we can understand something about the physical characteristics underlying the random variable. For example, the distribution of the particulate matter after an explosion falls in a lognormal distribution. We also might know that the price of a stock could follow the lognormal distribution.

### Goofy Distributions

Let's consider a poorly designed exam with two modes: students either did quite well or very poorly. We can represent this distribution using some combination of two normal random variables, but most commercial software packages cannot fit distributions like this. For example, consider Minitab fitting a normal to the data below.

![](https://assets.omscs.io/notes/2020-11-03-16-15-35.png)

We can attempt to model such a distribution as a mixture of other reasonable distributions. Even easier, we can sample directly from the empirical distribution, or perhaps a smoothed version thereof, which is called **bootstrapping**.

### Nonstationary Data

Arrival rates change over time. For example, consider restaurant occupancy, traffic on the highway, call center activity, and seasonal demand for products. We have to take this variability into account, or else we will get garbage-in-garbage-out.

One strategy we might use is to model the arrivals as a nonhomogeneous Poisson process, and we explored NHPPs back when we discussed random variate generation. Of course, we have to model the rate function properly. Arena uses a **piecewise-constant rate function**, which remains constant within an interval, but can jump up or down in between intervals.

### Multivariate / Correlated Data

Of course, data don't have to be iid! Data is often multivariate. For example, a person's height and weight are correlated. When modeling people, we have to ensure that we generate the correlated height and weight simultaneously, lest we generate a seven-foot-tall person who weighs ninety pounds.

Data can also be serially correlated. For example, monthly unemployment rates are correlated: the unemployment rate next month is correlated with the rate this month (and likely the past several months). As another example, arrivals to a social media site might be correlated if something interesting gets posted, and the public hears about it. As a third example, a badly damaged part may require more service than usual at a series of stations, so the consecutive service times are likely correlated. Finally, if a server gets tired, his service times may be longer than usual.

What can we do? First, we need to identify situations in which data is multivariate or serially correlated, and we can conduct various statistical tests to surface these relationships. From there, we can propose appropriate models. For example, we can use the multivariate normal distribution if we are looking at heights and weights. We can also use time series models for serially correlated observations, such as the ARMA(p,q), EAR(1), and ARP processes we discussed previously.

Even if we guess at the model successfully, we still need to estimate the relevant parameters. For example, in the multivariate normal distribution, we have to estimate the marginal means and variances, as well as the covariances. Some parameters are easier to estimate than others. For a simple time series, like AR(1), we only have to estimate the coefficient, $\phi$. For more complicated models, like ARMA(p,q) processes where p and q are greater than one, we have to use software, such as [Box-Jenkins](https://en.wikipedia.org/wiki/Box%E2%80%93Jenkins_method) technology.

After we've guessed at the distribution and estimated that relevant parameters, we have to finally validate our estimated model to see if it is any good. If we run a simulation and see something that looks drastically different from the original process, we have to reevaluate.

Alternatively, we can bootstrap samples from an empirical distribution if we are fortunate enough to have a lot of data.

## Demo Time

In this lesson, we will demonstrate how we carry out an elementary input analysis using Arena.

### Software Interlude
Arena has functionality that automatically fits simple distributions to our data, which we can access from *Tools > Input Analyzer*. This input analyzer purportedly gives us the best distribution from its library, along with relevant sample and goodness-of-fit statistics.

[ExpertFit](https://www.flexsim.com/expertfit/) is a specialty product that performs distribution fitting against a much larger library of distributions. Both Minitab and R have some distribution fitting functionality, but they are not as convenient as Arena and ExpertFit. 

The only drawback to some of these programs is that they have issues dealing with the problem children we discussed previously. 

### Demo Time

Let's hop over to Arena. First, we click *Tools > Input Analyzer*. Next, we select *File > New* and then *File > Data File > Use Existing...* to get started. From there, we can select the relevant .dst file. Let's click on normal.dst and take a look at the data.

![](https://assets.omscs.io/notes/2020-11-05-11-13-00.png)

We can see that Arena gives us several pieces of information about our data, such as:

- number of observations (5000)
- minimum value (0.284)
- maximum value (7.29)
- sample mean (3.99)
- sample standard deviation (1)

We can try to fit various distributions by selecting from the *Fit* menu. Let's select *Fit > Triangular* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-11-37-34.png)

This distribution tries to fit the minimum, maximum, and modal values of the data, and, as we can see, it's a terrible fit. Arena believes that the best fit is a TRIA(0,3.99,7.99) distribution. The $\chi^2$ test statistic for this fit is 1680, and the corresponding p-value is less than 0.005. The K-S statistic is 0.134 and has a corresponding p-value of less than 0.01. In plain English, the data is not triangular.

Let's try again. We can select *Fit > Weibull* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-11-43-58.png)

Arena believes that the best fit is a WEIB(4.33, 4.3) distribution. The $\chi^2$ test statistic for this fit is 66.2, and the corresponding p-value is less than 0.005. The K-S statistic is 0.0294 and has a corresponding p-value of less than 0.01. Again, even though the fit "looks" decent, we would still reject this data as being Weibull per the numbers.

Let's try again. We can select *Fit > Erlang* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-11-48-44.png)

Arena believes that the best fit is an ERLA(0.285, 14) distribution. The $\chi^2$ test statistic for this fit is 248, and the corresponding p-value is less than 0.005. The K-S statistic is 0.0414 and has a corresponding p-value of less than 0.01. The Erlang distribution does not fit this data.

Let's try again. We can select *Fit > Normal* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-11-49-58.png)

Arena believes that the best fit is a NORM(3.99, 1) distribution. The $\chi^2$ test statistic for this fit is 22.1, and the corresponding p-value is 0.732. The K-S statistic is 0.00789 and has a corresponding p-value greater than 0.15. We would fail to reject the null hypothesis in this case and conclude that this data is normal.

As a shortcut, we can select *Fit > Fit All*, and Arena will choose the best distribution from its entire library. If we select this option, Arena chooses the exact same normal distribution.

Let's look at some new data. We can click *File > Data File > Use Existing...* and then select the lognormal.dst file. Let's select *Fit > Beta* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-12-13-51.png)

Arena believes that the best fit is a shifted, widened BETA(3.34, 8.82) distribution. The $\chi^2$ test statistic for this fit is 126, and the corresponding p-value is less than 0.005. The K-S statistic is 0.0239 and has a corresponding p-value of less than 0.01. The beta distribution is not a good fit.

Let's try again. We can select *Fit > Exponential* and see what we get - what a joke.

![](https://assets.omscs.io/notes/2020-11-05-12-35-19.png)

Let's try again. We can select *Fit > Weibull* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-12-35-58.png)

Arena believes that the best fit is a shifted WEIB(2.49, 2.25) distribution. The $\chi^2$ test statistic for this fit is 237, and the corresponding p-value is less than 0.005. The K-S statistic is 0.0393 and has a corresponding p-value of less than 0.01. Clearly, Weibull is out.

Let's try again. We can select *Fit > Lognormal* and see what we get.

![](https://assets.omscs.io/notes/2020-11-05-12-37-17.png)

Arena believes that the best fit is a shifted LOGN(2.22, 1.14) distribution. The $\chi^2$ test statistic for this fit is 257, and the corresponding p-value is less than 0.005. The K-S statistic is 0.0458 and has a corresponding p-value of less than 0.01. Surprisingly, we would reject these observations as being lognormal, even though we know we sampled them from that distribution.

Let's select *Fit > Fit All* to see what Arena thinks is the best fit.

![](https://assets.omscs.io/notes/2020-11-05-12-39-09.png)

Arena believes that the best overall fit is a shifted ERLA(0.44, 5) distribution. The $\chi^2$ test statistic for this fit is 42.3, and the corresponding p-value is 0.0182. The K-S statistic is 0.0122 and has a corresponding p-value greater than 0.15. Depending on our significance level, we may reject or fail to reject this data as coming from the Erlang distribution.

Let's look at a final example. We can click *File > Data File > Use Existing...* and then select partbprp.dst file. Note that we don't know what distribution this data is coming from ahead of time.

Let's select *Fit > Fit All* to see what Arena thinks is the best fit.

![](https://assets.omscs.io/notes/2020-11-05-12-46-48.png)

Arena believes that the best overall fit is a shifted GAMM(0.775, 4.29) distribution. The $\chi^2$ test statistic for this fit is 4.68, and the corresponding p-value is 0.337. The K-S statistic is 0.0727 and has a corresponding p-value greater than 0.15. We would fail to reject that this data is coming from the Gamma distribution.

If we click on *Data File > Generate New...*, we can generate a file of observations according to some distribution. Let's write 5000 TRIA(2,5,10) observations to a file called triang2.dst.

![](https://assets.omscs.io/notes/2020-11-05-12-53-32.png)

Let's load these observations and then select *Fit > Fit All*.

![](https://assets.omscs.io/notes/2020-11-05-12-54-19.png)

Arena believes that the best overall fit is a TRIA(2,5,10) distribution. The $\chi^2$ test statistic for this fit is 33.6, and the corresponding p-value is 0.565. The K-S statistic is 0.00932 and has a corresponding p-value greater than 0.15. Perfect.

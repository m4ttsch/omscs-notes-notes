---
id: simulation-comparing-systems
title: Comparing Systems
course: simulation
lecture: comparing-systems
---

# Comparing Systems

## Introduction

Statistics and simulation experiments are typically performed to analyze or compare a small number of systems, say fewer than 200. The exact method of analysis depends on the type of comparison and the properties of the data. For example, we might analyze exponential interarrival data differently than multivariate normal data.

We can use traditional confidence intervals based on the normal or t-distribution - from an introductory statistics class - to analyze one system. If we want to analyze two systems, we could again use confidence intervals for differences.

However, if we want to analyze more than two systems, we need to use more sophisticated ranking and selection approaches.

### Confidence Intervals

We can take confidence intervals for:

- means
- variances
- quantiles
- one-sample, two-sample, > two samples
- classical statistics environment (iid normal observations)
- simulation environment (non-iid normal observations)

## Confidence Interval for the Mean

In this lesson, we will review and derive the confidence interval for the mean of iid normal data. This review will allow us to move forward and compare two systems.

### Confidence Intervals

In the one-sample case, we are interested in obtaining a two-sided $100(1-\alpha)\%$ confidence interval for the unknown mean, $\mu$, of a normal distribution.

Suppose we have iid normal data $X_1, X_2,...,X_n$. Further, assume we have an unknown variance, $\sigma^2$. Given this information, we will use the well-known $t$-distribution based confidence interval.

Let's recall the expression for the sample mean, $\bar X_n$:

$$
\bar X_n \equiv \frac{1}{n}\sum_{i=1}^n X_i
$$

We might remember that the sample mean is itself a normal random variable: $\bar X_n \sim \text{Nor}(\mu, \sigma^2 / n)$.

Recall the expression for the sample variance, $S_X^2$:

$$
S_X^2 \equiv \frac{1}{n-1} \sum_{i=1}^n (X_i - \bar X_n)^2
$$

We might remember that the sample variance is a $\chi^2$ random variable: $S^2_X \sim \sigma^2 \chi^2(n-1) / (n-1)$.

As it turns out, $\bar X_n$ and $S^2_X$ are independent. Remember that if $X \sim \text{Nor}(\mu, \sigma^2)$, we can standardize $X$ with the following transformation:

$$
\frac{X - \mu}{\sigma} \sim \text{Nor}(0,1)
$$

Let's apply this rule to $\bar X_n$. Note that we don't know the true variance, $\sigma^2 / n$, so we have to use $S^2_X / n$. Consider:

$$
T = \frac{\bar X_n - \mu}{\sqrt{S^2_X / n}}
$$

Let's divide each side by $\sqrt{\sigma^2 / n}$:

$$
\begin{alignedat}{1}
T &= \frac{\frac{\bar X_n - \mu}{\sqrt{\sigma^2 / n}}}{\frac{\sqrt{S^2_X / n}}{\sqrt{\sigma^2 / n}}} \\[5ex]
&= \frac{\frac{\bar X_n - \mu}{\sqrt{\sigma^2 / n}}}{\sqrt{S^2_X / \sigma^2}}
\end{alignedat}
$$

We can see that the expression in the numerator is the standardization of $\bar X_n$. Let's also substitute in the $\chi^2$ expression for $S^2_X$ in the denominator:

$$
T = \frac{\text{Nor}(0,1)}{\sqrt{\chi^2(n-1) / (n-1)}}
$$

Since $T$ is the ratio of a normal random variable and a $\chi^2$ random variable, [we know](https://en.wikipedia.org/wiki/Student%27s_t-distribution#Related_distributions) that $T$ comes from the $t$-distribution:

$$
T = \frac{\text{Nor}(0,1)}{\sqrt{\chi^2(n-1) / (n-1)}} \sim t(n-1)
$$

This result immediately lets us compute the confidence interval. Let the notation $t_{\gamma, \nu}$ denote the $1-\gamma$ quantile of a $t$-distribution with $\nu$ degrees of freedom. By definition:

$$
1 - \alpha = P(-t_{\alpha/2, n-1} \leq T \leq t_{\alpha/2, n-1})
$$

Let's substitute in the expression for $T$:

$$
1 - \alpha = P(-t_{\alpha/2, n-1} \leq \frac{\bar X_n - \mu}{\sqrt{S^2_X / n}} \leq t_{\alpha/2, n-1})
$$

Using some simple algebra, we can express the probability in terms of $\mu$:

$$
1 - \alpha = P(\bar X_n - t_{\alpha/2, n-1}S_X / \sqrt{n}\leq \mu \leq \bar X_n + t_{\alpha/2, n-1}S_X / \sqrt{n})
$$

Therefore, we have the following $100(1-\alpha)\%$ confidence interval for $\mu$:

$$
\mu \in \bar X_n \pm t_{\alpha/2, n-1}S_X / \sqrt{n}
$$

## Confidence Intervals for the Difference in Two Means

In this lesson, we will compare two systems via two-sample confidence intervals for the difference in two normal means.

### Two-Sample Case

Let's suppose that we have two series of observations. The observations $X_1,X_2,...,X_n$ are iid normal with mean $\mu_X$ and variance $\sigma^2_X$, and the observations $Y_1, Y_2,..., Y_m$ are iid normal with mean $\mu_Y$ and variance $\sigma^2_Y$.

We have a few techniques at our disposal for producing a confidence interval for the difference between $\mu_X$ and $\mu_Y$. We can use the *pooled* confidence interval method when we assume $\sigma^2_X$ and $\sigma^2_Y$ are equal but unknown. If both variances are unequal and unknown, we can use the *approximate* confidence interval method. Finally, we can use a *paired* confidence interval when we suspect that the $X_i$'s and $Y_i$'s are correlated.

### Pooled Confidence Interval

If the $X$'s and $Y$'s are independent but have common, unknown variance, then the usual confidence interval for the difference in the means is:

$$
\mu_x - \mu_y \in \bar X_n - \bar Y_m \pm t_{\alpha/2, n + m - 2} S_P \sqrt{\frac{1}{n} + \frac{1}{m}}
$$

Here, $S_P^2$ refers to the pooled variance estimator for $\sigma^2$, which is a linear combination of the individual sample variances:

$$
S^2_P \equiv \frac{(n-1)S^2_X + (m-1)S^2_Y}{n+m+2}
$$

### Approximate Confidence Interval

If the $X$'s and $Y$'s are independent but have uncommon, unknown variance, then the usual confidence interval for the difference in the means is:

$$
\mu_x - \mu_y \in \bar X - \bar Y \pm t_{\alpha/2, \nu}\sqrt{\frac{S^2_X}{n} + \frac{S^2_Y}{m}}
$$

Note that we can't use the pooled variance estimator in this case because the variances are different for the $Y$'s and the $X$'s.

This confidence interval is not quite exact, since it uses an approximate degrees of freedom, $\nu$, where:

$$
\nu \equiv \frac{\left(\frac{S^2_X}{n} + \frac{S^2_Y}{m} \right)^2}{\frac{(S^2_X / n)^2}{n+1} + \frac{(S^2_Y / m)^2}{m+1}} - 2
$$

### Example

Let's look at how long it takes two different guys to parallel park two different cars. We will assume all parking times are normal. Consider:

$$
\begin{array}{c|c}
\text{A guy parks} & \text{Different (indep)} \\
\text{Honda } X_i & \text{guy parks Caddy } Y_i \\ \hline
10 & 30 \\
25 & 15 \\
5 & 40 \\
20 & 10 \\
15 & 25 \\
\end{array}
$$

After some algebra, we have the following statistics:

$$
\bar X = 15, \quad \bar Y = 24, \quad S^2_X = 62.5 \quad S^2_Y = 142.5
$$

More algebra gives:

$$
\nu = \frac{6(62.5 + 142.5)^2}{(62.5)^2 + (142.5)^2} - 2 = 8.4
$$

We always round down non-integer degrees of freedom since most tables only include integer values, so $\nu = 8$. 

We can plug and chug these values into our expression for the confidence interval. If we want a $90\%$ confidence interval:

$$
\mu_x - \mu_y \in 15 - 24 \pm v_{0.05, 8}\sqrt{\frac{62.5}{5}  + \frac{142.5}{5}} = -9 \pm 11.91
$$

Note that this confidence interval includes zero. Informally speaking, the confidence interval is *inconclusive* regarding which of $\mu_x$ and $\mu_y$ is bigger.

## Paired Confidence Interval for the Difference in Two Means

In this lesson, we will look at computing confidence intervals for the difference of two means when the observations are correlated. In this case, we use a paired confidence interval.

### Paired Confidence Interval

Let's consider two competing normal populations with unknown means, $\mu_X$ and $\mu_Y$. Suppose we collect observations from the two populations in pairs. While the different pairs may be independent, it might be the case that the observations in each pair are correlated with one another.

### Paired-$t$ Setup

For example, let's think of sets of twins in a drug trial. One twin takes a new drug, and the other takes a placebo. We expect that, since the twins are so similar, the difference in their reactions arises solely from the drug's influence. 

In other words, we hope to capture the difference between two normal populations more precisely than if we had chosen pairs of random people since this setup eliminates extraneous noise from nature.

We will see this trick again shortly when we use the simulation technique of common random numbers, which involves using the same random numbers as much as possible between competing scenario runs.

Here's our setup. Let's take $n$ pairs of observations:

$$
X_1, X_2, ... , X_n \overset{\text{iid}}{\sim} \text{Nor}(\mu_X, \sigma^2_X) \newline
Y_1, Y_2, ... , Y_n \overset{\text{iid}}{\sim} \text{Nor}(\mu_Y, \sigma^2_Y)
$$

> Note that we need to assume that all the $X_i$'s and $Y_i$'s are jointly normal.

We assume that the variances $\sigma^2_X$ and $\sigma^2_Y$ are unknown and possibly unequal. Furthermore, we assume that pair $i$ is independent of pair $j$, but we *cannot* assume that, within a pair, $X_i$ is independent of $Y_i$.

We can define the **pair-wise** differences as the difference between the observations in a pair:

$$
D_i \equiv X_i - Y_i, i = 1,2,...n
$$

It turns out that the pairwise differences are themselves iid normal with mean $\mu_D$ and variance $\sigma^2_D$, where:

$$
\mu_D \equiv \mu_X - \mu_Y \newline
\sigma_D^2 \equiv \sigma_X^2 + \sigma^2_Y - 2 \text{Cov}(X_i, Y_i)
$$

Ideally, we want the covariance between $X_i$ and $Y_i$ to be very positive, as this will result in a lower value of $\sigma^2_D$. Having a low variance is always good.

Now the problem reduces to the old single-sample case of iid normal observations with unknown mean, $\mu$, and variance, $\sigma^2$. Let's calculate the sample mean and sample variance as before:

$$
\bar D \equiv \frac{1}{n} \sum_{i=1}^n D_i \sim \text{Nor}(\mu_D, \sigma^2_D / n) \newline
S^2_D \equiv \frac{1}{n-1} \sum_{i=1}^n (D_i - \bar D)^2 \sim \frac{\sigma^2_D \chi^2(n-1)}{n-1}
$$

Just like before, we get the single-sample confidence interval for the difference of the means $\mu_X$ and $\mu_Y$:

$$
\mu_D \in \bar D \pm t_{\alpha/2,n-1}\sqrt{S^2_D / n}
$$

### Example

Let's look at the parallel parking example from the previous lesson, but, in this case, we will have the same person parking both cars. As a result, we expect the times within a pair to be correlated.

$$
\begin{array}{c|c|c|c}
\text{Person} & \text{Park Honda} & \text{Park Cadillac} & \text{Difference} \\ \hline
1 & 10 & 20 & -10 \\
2 & 25 & 40 & -15 \\
3 & 5 & 5 & 0 \\
4 & 20 & 35 & -15 \\
5 & 15 & 20 & -5
\end{array}
$$

By using the same people to park both cars, there will be some correlation between parking times. If we were to compare the differences in this example from those in the previous example, we would notice that we have much more consistent values in this example because we removed the extraneous noise associated with two different individuals.

As we said, the individual people are independent, and the pairs themselves are independent, but the times for the same person to park the two cars are not independent: they are positively correlated.

The $90\%$ two-sided confidence interval is therefore:

$$
\begin{alignedat}{1}
\mu_D &\in \bar D \pm t_{0.025,4}\sqrt{S^2_D/n} \\
&= -9 \pm 2.13 \sqrt{42.5 / 5} = -9 \pm 6.21
\end{alignedat}
$$

The interval is entirely to the left of zero, indicating that $\mu_D < 0$: the Cadillac takes longer to park, on average.

This confidence interval is quite a bit shorter - more informative, in other words - than the previous "approximate" two-sample confidence interval, which was $-9 \pm 11.91$. The reason for this difference is that the paired-$t$ interval takes advantage of the correlation within observation pairs.

The moral of the story is that we should use the paired-$t$ confidence interval when we can.

## Confidence Intervals for Mean Differences in Simulations

In this lesson, we will learn how to apply the confidence intervals in a simulation environment where the observations aren't iid normal. The idea here is to use replicate or even batch means as iid normal observations.

### Comparison of Simulated Systems

One of the most important uses of simulation output analysis is the comparison of competing systems or alternative system configurations.

For example, we might evaluate two different "restart" strategies that an airline can run following a disrupting snowstorm in the Northeast. We might want to compare the two strategies to see which minimizes a certain cost function associated with the restart.

Simulation is uniquely equipped to help with these types of situations, and many techniques are available. We can use classical confidence intervals adapted to simulations, variance reduction methods, and ranking and selection procedures.

### Confidence Intervals for Mean Differences

Let's continue with the airline example we just described. Let $Z_{i,j}$ represent the cost of the $j$th simulation replication of strategy $i$. Since we are only comparing two strategies, $i = 1,2$. If we run $b_i$ simulation runs in total then $j = 1,2,...,b_i$.

We can assume that, within a particular strategy, the replicate means $Z_{i,1}, Z_{i,2}, ... , Z_{i,b_i}$ are iid normal with unknown mean $\mu_i$ and unknown variance, where $i=1,2$.

What's the justification for the iid normal assumption? First, we get independent data by controlling the random numbers between replications. We get identically distributed costs between replications by performing them under identical conditions. Finally, we get approximately normal data by adding up (averaging) many sub-costs to get the overall costs for both strategies.

Our goal now is to obtain a $100(1-\alpha)\%$ confidence interval for the difference in means, $\mu_1 - \mu_2$.

We will suppose that all the $Z_{1,j}$'s are independent of the $Z_{2,j}$'s. In other words, scenario one runs are all independent of scenario two runs.

We can define the sample mean, $\bar Z_{i,b_i}$:

$$
\bar Z_{i,b_i} \equiv \frac{1}{b_i} \sum_{j=1}^{b_i} Z_{i,j}, \quad i = 1,2
$$


We can define the sample variance, $S_i^2$:

$$
S^2_i \equiv \frac{1}{b_i - 1} \sum_{j=1}^{b_i} (Z_{i,j} - \bar Z_{i, b_i})^2, \quad i = 1,2
$$

An approximate $100(1-\alpha)\%$ confidence interval for the difference of the means is:

$$
\mu_1 - \mu_2 \in \bar Z_{1,b_1} - \bar Z_{2,b_2} \pm t_{\alpha/2, \nu}\sqrt{\frac{S^2_1}{b_1} + \frac{S^2_2}{b_2}}
$$

Remember the formula for the approximate degrees of freedom, $\nu$, which we saw earlier:

$$
\nu \equiv \frac{\left(\frac{S^2_X}{n} + \frac{S^2_Y}{m} \right)}{\frac{(S^2_X / n)^2}{n+1} + \frac{(S^2_Y / m)^2}{m+1}} - 2
$$

Suppose that in our airline example, a smaller cost is better - as is usually the case. If the interval lies entirely to the left of zero, then system one is better. If the interval lies entirely to the right of zero, then system two is better. If the interval contains zero, then, statistically, the two systems are about the same.

### Alternative Strategy

As an alternative strategy, we can use a confidence interval analogous to the paired-$t$ test, especially if we can pair up the two scenarios during each replication.

Specifically, we can take $b$ replications from *both* strategies, and then set difference $D_j \equiv Z_{1,j} - Z_{2,j}, j = 1,2,...,b$.

We can take the sample mean and sample variance of the differences:

$$
\bar D_b \equiv \frac{1}{b} \sum_{j=1}^b D_j, \quad S^2_D \equiv \frac{1}{b-1} \sum_{j=1}^b (D_j - \bar D_b)^2
$$

The $100(1-\alpha)\%$ paired-$t$ confidence interval is very efficient if the correlation between $Z_{1,j}$ and $Z_{2,j}$ is greater than zero:

$$
\mu_1 - \mu_2 \in \bar D_b \pm t_{\alpha/2,b-1}\sqrt{S^2_D / b}
$$

## Common Random Numbers

In this lesson, we will start our discussion of variance reduction techniques. We will begin with common random numbers, which are similar to paired-$t$ confidence intervals.

### Common Random Numbers

The idea behind common random number is the same as that behind a paired-$t$ confidence interval. We will use the same pseudo-random numbers in exactly the same ways for corresponding runs of the competing systems.

For example, we might use the same service times or the same interarrival times when simulating different proposed configurations of a particular job shop.

By subjecting the alternative systems to identical experimental conditions, we hope to make it easy to distinguish which system is best even though the respective estimators have sampling error.

Let's consider the case in which we compare two queueing systems, $A$ and $B$, based on their expected customer transit times, $\theta_A$ and $\theta_B$. In this case, the smaller $\theta$-value corresponds to the better system.

Suppose we have estimators, $\widehat \theta_A$ and $\widehat \theta_B$, for $\theta_A$ and $\theta_B$, respectively. We'll declare that $A$ is the better system if $\widehat \theta_A < \widehat \theta_B$. If the two estimators are simulated independently, then the variance of their difference is:

$$
\text{Var}(\widehat \theta_A - \widehat \theta_B) = \text{Var}(\widehat \theta_A) + \text{Var}(\widehat \theta_B)
$$

This sum could be very large, and, if it is, our declaration about which system is better might lack conviction. If we could reduce $\text{Var}(\widehat \theta_A - \widehat \theta_B)$, then we could be much more confident about our declaration. The technique of common random numbers sometimes induces a high positive correlation between the point estimators $\widehat \theta_A$ and $\widehat \theta_B$.

Since the two estimators are no longer simulated independently, their covariance is greater than zero. Therefore:

$$
\text{Var}(\widehat \theta_A - \widehat \theta_B) = \text{Var}(\widehat \theta_A) + \text{Var}(\widehat \theta_B) - 2 \text{Cov}(\widehat \theta_A, \widehat \theta_B)
$$

Indeed, for any covariance greater than zero:

$$
\text{Var}(\widehat \theta_A - \widehat \theta_B) < \text{Var}(\widehat \theta_A) + \text{Var}(\widehat \theta_B)
$$

We can think about this result as a savings in variance. By introducing correlation between the observations, we reduce the variance in the difference of the estimators for the parameter in question.

### Demo

In this demo, we will analyze two queueing systems, each with exponential interarrival times and service times, to see which one yields shorter cycle times.

The first strategy involves one line feeding into two parallel servers, and the second strategy involves customers making a 50-50 choice between two lines, each feeding into a single server. We will simulate each alternative for 20 replications of 1000 minutes.

Here's our setup in Arena. On the top, we see one line feeding into two parallel servers. On the bottom, we see the fifty-fifty split between two lines, each feeding into one server.

![](https://assets.omscs.io/notes/2020-11-16-21-50-38.png)

We might guess that the top scenario is better than the bottom scenario because it might be the case that in the second scenario, we choose to wait in a line even though the other server is free.

In this setup, the arrivals and the service times are generated independently. They are both configured with the same parameters, but the stream of random numbers generated in both systems is distinct.

Let's run the simulation to completion and look at some confidence intervals for the mean cycle time.

![](https://assets.omscs.io/notes/2020-11-16-22-06-44.png)

For the difference of two means, we get the following confidence interval:

$$
\mu_A - \mu_B \in -16.19 \pm 9.26
$$

As we expect, this result favors the first system with regard to cycle length.

Now let's look at the same example, but with a slightly different setup.

![](https://assets.omscs.io/notes/2020-11-16-22-09-19.png)

Here, we generate the arrival times and service times from the *same* stream of random numbers. Then we duplicate the customers and send each copy to each strategy. We are now simulating the system using common random numbers.

Let's run the simulation to completion and look at some confidence intervals for the mean cycle time.

![](https://assets.omscs.io/notes/2020-11-16-22-11-51.png)

For the difference of two means, we get the following confidence interval:

$$
\mu_A - \mu_B \in -15.05 \pm 3.37
$$

As we expect, this result favors the first system with regard to cycle length. What's more, the half-width of the confidence interval is almost one-third that of the setup that didn't use common random numbers.

## Antithetic Random Numbers

In this lesson, we will look at the antithetic random numbers method, which intentionally introduces a negative correlation between estimators. This method can be very useful for estimating certain means.

### Antithetic Random Numbers

Let's suppose that $\widehat \theta_1$ and $\widehat \theta_2$ are iid unbiased estimators for some parameter $\theta$. If we can induce a *negative* correlation between the two estimators, then their average is also unbiased and may have very low variance.

We can express the variance of the average of the two estimators with the following equation:

$$
\text{Var}\left(\frac{\widehat \theta_1 + \widehat \theta_2}{2}\right) = \frac{1}{4} \left[\text{Var}(\widehat \theta_1) + \text{Var}(\widehat \theta_2) + 2\text{Cov}(\widehat \theta_1, \widehat \theta_2)\right] 
$$

Since the estimators are identically distributed, $\text{Var}(\widehat \theta_1) = \text{Var}(\widehat \theta_2)$, so:

$$
\text{Var}\left(\frac{\widehat \theta_1 + \widehat \theta_2}{2}\right) = \frac{1}{2} \left[\text{Var}(\widehat \theta_1) + 2\text{Cov}(\widehat \theta_1, \widehat \theta_2)\right] 
$$

Because we have induced negative correlation, $2\text{Cov}(\widehat \theta_1, \widehat \theta_2) < 0$, which means:

$$
\text{Var}\left(\frac{\widehat \theta_1 + \widehat \theta_2}{2}\right) < \frac{\text{Var}(\widehat \theta_1)}{2}
$$

Remember that $\text{Var}(\widehat \theta_1) / 2$ is the usual variance for two iid replications. As we can see, introducing negative correlation results in a variance reduction.

### Example

Let's do some Monte Carlo integration using antithetic random numbers to obtain variance reduction. Consider the following integral:

$$
I = \int_1^2 (1/x)dx
$$

Of course, we know that the true answer of this integral is $\ln(2) \approx 0.693$. Let's use the following $n = 5$ Unif(0,1) random numbers, to come up with our usual estimator, $\bar I_n$, for $I$:

$$
0.85 \quad 0.53 \quad 0.98 \quad 0.12 \quad 0.45
$$

Using the Monte Carlo integration notation from a previous lesson, we have:

$$
\widehat \theta_1 = \bar I_n = \frac{b-a}{n} \sum_{i=1}^n g(a + (b-a) U_i)
$$

Given $a = 1$, $b = 2$, and $g(x) = 1/x$, we have:

$$
\widehat \theta_1 = \frac{1}{5}\sum_{i=1}^5\frac{1}{1+U_i} = 0.6563
$$

Now, we'll use the following *antithetic* random numbers, where each $U_j$ here is equal to one minus the corresponding $U_i$ from above:

$$
0.15 (= 1-0.85) \quad 0.47 \quad 0.02 \quad 0.88 \quad 0.55
$$

Then, the antithetic version of the new estimator is:

$$
\widehat \theta_2 = \bar I_n = \frac{b-a}{n} \sum_{i=1}^n g(a + (b-a) U_j)
$$

Again, $a = 1$, $b = 2$, and $g(x) = 1/1-x$. If we substitute $1 - U_i = U_j$, we have:

$$
\widehat \theta_1 = \frac{1}{5}\sum_{i=1}^5\frac{1}{1+(1 - U_i)} = 0.7475
$$

If we take the average of the two answers, we get:

$$
\frac{\widehat \theta_1 + \widehat \theta_2}{2} = 0.6989
$$

This average is very close to the true answer of 0.693. Using antithetic random numbers, we have introduced a negative correlation between the two estimators and produced an average whose variance is smaller than the average of two iid estimators.

## Control Variates

In this lesson, we will look at a final variance reduction technique: control variates. This method is reminiscent of regression methods from an introductory statistics class. This approach takes advantage of knowledge about other random variables related to the one we are interested in simulating.

### Control Variates

Suppose our goal is to estimate the mean, $\mu$, of some simulation output process, $X_1, X_2,...,X_n$. Suppose we somehow know the expected value of some other random variable, $Y$. Furthermore, suppose we also know that the covariance between the sample mean, $\bar X$, and $Y$ is greater than zero.

Obviously, $\bar X$ is the usual estimator for $\mu$, but another estimator for $\mu$ is the so-called **control-variate** estimator, $C$:

$$
C = \bar X - \beta(Y - E[Y])
$$

Let's first note the expected value of the control-variate estimator:

$$
E[C] = E[\bar X] - \beta(E[Y] - E[Y]) = E[\bar X] = \mu
$$

Since $E[C] = \mu$, we can see that $C$ is unbiased for $\mu$. Now let's take a look at the variance of $C$:

$$
\text{Var}(C) = \text{Var}(\bar X) + \beta^2 \text{Var}(Y) - 2 \beta \text{Cov}(\bar X, Y)
$$

We are hoping that $\beta^2 \text{Var}(Y) - 2 \beta \text{Cov}(\bar X, Y) < 0$ so $\text{Var}(C) < \text{Var}(\bar X)$. Otherwise, we might as well just use $\text{Var}(\bar X)$ by itself.

Now we'd like to minimize $\text{Var}(C)$ with respect to $\beta$. After some algebra, we see that:

$$
\beta = \frac{\text{Cov}(\bar X, Y)}{\text{Var}(Y)}
$$

Let's plug in this expression for $\beta$ into our equation for $\text{Var}(C)$:

$$
\begin{alignedat}{1}
\text{Var}(C) &= \text{Var}(\bar X) + \frac{\text{Cov}^2(\bar X, Y)}{\text{Var}^2(Y)} \text{Var}(Y) - 2 \frac{\text{Cov}(\bar X, Y)}{\text{Var}(Y)} \text{Cov}(\bar X, Y) \\
&= \text{Var}(\bar X) + \frac{\text{Cov}^2(\bar X, Y)}{\text{Var}(Y)} - 2 \frac{\text{Cov}^2(\bar X, Y)}{\text{Var}(Y)} \\ 
&= \text{Var}(\bar X) - \frac{\text{Cov}^2(\bar X, Y)}{\text{Var}(Y)}
\end{alignedat}
$$

Since the second term above is greater than zero, we can see that $\text{Var}(C) < \text{Var}(\bar X)$, which is the result we wanted.

### Examples

We might try to estimate a population's mean weight $\mu$ using observed weights $X_1,X_2,...$ with corresponding heights $Y_1, Y_2,...$. If we can assume the expected height, $E[Y]$, is known, then we can use the control-variate estimator because heights and weights are correlated.

We can also estimate the price of an American stock option, which is tough to estimate, using the corresponding European option price, which is much easier to estimate, as a control.

In any case, many simulation texts give advice on running the simulations of competing systems using common random numbers, antithetic random numbers, and control variates in a useful, efficient way.

## Ranking and Selection Methods

In this lesson, we will talk about ranking and selection methods. This lesson aims to give easy-to-use procedures for finding the best system, along with a statistical guarantee that we indeed chose the best system.

### Intro to Ranking and Selection

Ranking, selection, and multiple comparison methods form another class of statistical techniques used to compare alternative systems. Here, the experimenter wants to select the best option from a number ($\geq 2$) of competing processes.

As the experimenter, we specify the desired probability of correctly selecting the best process. We want to get it right, especially if the best process is significantly better than its competitors. These methods are simple to use, somewhat general, and intuitively appealing.

For more than two systems, we could use methods such as simultaneous confidence intervals and ANOVA. However, these methods don't tell us much except that at least one system is different from the others. We want to know specifically which system is best.

What measures might we use to compare different systems? We can ask which system has the biggest mean or the smallest variance. We can ask which treatment has the highest probability of yielding a success or which gives the lowest risk. If we want, we can even select a system based on a combination of criteria.

One example we will look at is determining which of ten fertilizers produces the largest mean crop yield. Another example we will look at involves finding the pain reliever with the highest probability of giving relief for a cough. As a final example, we will determine the most popular former New England football player.

Ranking and selection methods select the best system, or a subset of systems that includes the best, guaranteeing a probability of correct selection that we specify.

Ranking and selection methods are relevant in simulation:

- Normally distributed data by batching
- Independence by controlling random numbers
- Multiple-stage sampling by retaining the seeds
 
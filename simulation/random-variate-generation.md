---
id: simulation-random-variate-generation
title: Random Variate Generation
course: simulation
lecture: random-variate-generation
---

# Random Variate Generation

## Inverse Transform Method

In this lesson, we'll go into some additional detail regarding the inverse transform method.

### Inverse Transform Method

The inverse transform method states that, if $X$ is a continuous random variable with cdf $F(x)$, then $F(X) \sim \mathcal{U}(0,1)$. In other words, if we plug a random variable, from any distribution, into its own cdf, we get a Unif(0,1) random variable.

We can prove the inverse transform method. Let $Y = F(X)$. Since $Y$ is a random variable, it has a cdf, which we can denote $G(y)$. By definition:

$$
G(y) = P(Y \leq y)
$$

Since $Y = F(X)$:

$$
G(y) = P(F(X) \leq y)
$$

Since $X$ is a continuous random variable, its cdf is continuous. Therefore, we can apply the inverse, $F^{-1}$, to both sides of the inequality:

$$
G(y) = P(F^{-1}(F(X)) \leq F^{-1}(y))
$$

What is $F^{-1}(F(X))$? Simply, $X$:

$$
G(y) = P(X \leq F^{-1}(y))
$$

Notice that we have an expression of the form $P(X \leq x$), where $x = F^{-1}(y)$. We know, by definition, $F(x) = P(X \leq x)$, so:

$$
G(y) = F(F^{-1}(y)) = y
$$

In summary, the cdf of $Y$ is $G(y) = y$. If we take the derivative of the cdf to get the pdf, we see that $g(y) = 1$. Let's remember the pdf for a uniform random variable:

$$
f(x) = \left\{
  \begin{matrix}
  \frac{1}{b-a} & x \in [a,b] \\
  0 & \text{otherwise}
  \end{matrix}
\right.
$$

If $a = 0, b = 1$, then $f(x) = 1 = g(y)$. Therefore, $Y \sim \mathcal{U}(0,1)$.

### How Do We Use This Result

Let $U \sim \mathcal{U}(0,1)$. Since $F(X) = U$, then $F^{-1}(U) = X$. In other words, if we set $F(X) = U$, and then solve for $X$, we get a random variable from the same distribution as $X$, but in terms of $U$.

Here is how we use the inverse transform method for generating a random variable $X$ having cdf $F(x)$:
1. Sample $U$ from $\mathcal{U}(0,1)$
2. Return $X = F^{-1}(U)$

### Illustration

Consider the following cdf, $F(x)$.

![](https://assets.omscs.io/notes/2020-10-13-17-58-09.png)

Let's think about the range of $F(x)$. Since we are dealing with a cdf, we know that $0 \leq F(x) \leq 1$. Note that, correspondingly, $0 \leq \mathcal{U} < 1$. This means that, for a given Unif(0,1) random variable, $U$, we can generate an $x$, such that $F(x) = U$, by taking the inverse of $F$ with $U$: $x = F^{-1}(U)$.

Let's look at an example. Suppose we generate $U = 0.9$. Let's draw a horizontal line $(0, 0.9)$ to the graph of $F(x)$. From there, if we draw a vertical line down to the $x$-axis, the $x$-coordinate of the intersection is $F^{-1}(U)$. In this case, $F^{-1}(0.9) = 3$.

![](https://assets.omscs.io/notes/2020-10-13-18-09-41.png)

### Uniform Example

Consider the $\mathcal{U}(a,b)$ distribution, which has the following cdf:

$$
F(x) = \frac{x - a}{b - a}, \quad a \leq x \leq b
$$

Let's set $F(X) = U$ and solve for $X$:

$$
\begin{alignedat}{1}
U &= \frac{X - a}{b - a} \\[2ex]
(b - a)U &= X - a \\
a + (b - a )U &= X
\end{alignedat}
$$

Intuitively, this result makes perfect sense. If we take a Unif(0,1) random variable, and multiply it by $b-a$, we end up with a Unif(0, $b-a$) random variable. Then, if we add $a$ to each end, we get a Unif($a$, $b$) random variable.

### Exponential Example

Consider the $\text{Exp}(\lambda)$ distribution, which has the following cdf:

$$
F(x) = 1 - e^{-\lambda x}, x \geq 0
$$

Let's set $F(X) = U$ and solve for $X$:

$$
\begin{alignedat}{1}
U &= 1 - e^{-\lambda X} \\
U - 1 &= e^{-\lambda X} \\
\ln(U - 1) &= -\lambda X \\
\frac{\ln(U - 1)}{-\lambda} &= X
\end{alignedat}
$$

Also, we know that the expression $U-1$ is itself uniform, so we can simplify:

$$
X = \frac{\ln(U)}{-\lambda}
$$

## Inverse Transform Method - Continuous Examples

In this lesson, we'll apply the inverse transform method to trickier continuous examples.

### Weibull Example

Let's start with the Weibull distribution, which has the following cdf:

$$
F(x) = 1 - e ^{(-\lambda x)^\beta}
$$

We can solve $F(X) = U$ for $X$:

$$
\begin{alignedat}{1}
U &= 1 - e ^{(-\lambda X)^\beta} \\
1 - U &= e ^{(-\lambda X)^\beta} \\
\ln(1 - U) &= -\lambda X^\beta \\
\ln(1 - U)^{1/\beta} &= -\lambda X \\
\frac{-1}{\lambda}\ln(1 - U)^{1/\beta} &= X \\
\end{alignedat}
$$

As we saw before, we know that the expression $U-1$ is itself uniform, so we can simplify:

$$
X = \frac{-1}{\lambda}\ln(U)^{1/\beta}
$$

Notice that, if $\beta = 1$, $X = -\ln(U) / \lambda \sim \text{Exp}(\lambda)$. We say that the Weibull distribution *generalizes* the exponential distribution.

### Triangular Example

Now let's look at the triangular distribution. This distribution is important when we don't have a lot of data. For example, suppose we ask someone how long it takes to complete a particular job. Without much data, all they might be able to tell us is the minimum, maximum, and most common (mode) amounts of time. A triangular distribution - parameterized by these three values - is often a good first approximation.

Let's specifically consider the triangular(0,1,2) distribution, which has the following pdf:

$$
f(x) = \left\{
  \begin{matrix}
  x & 0 \leq x < 1 \\
  2 - x & 1 \leq x \leq 2
  \end{matrix}
  \right.
$$

If we integrate, we get the following cdf:

$$
F(x) = \left\{
  \begin{matrix}
  x^2 / 2 & 0 \leq x < 1 \\
  1 - (x-2)^2 / 2 & 1 \leq x \leq 2
  \end{matrix}
  \right.
$$

Since the cdf contains distinct expressions for different ranges of $x$, we need to transform each expression independently. How do we know which uniforms belong to which expressions? Well, the cdf evaluates the top expression for the first half of the possible $x$-values and the bottom expression for the second half, so we can similarly divide the unit interval in half.

Specifically, if $U < 1/2$, we solve $X^2/2 = U$ to get $X = \sqrt{2U}$. Note that the square root technically contains both negative and positive roots, but we only consider the positive root since we know that $X$ must be between zero and one.

If $U \geq 1/2$, we solve the second expression for $X$:

$$
\begin{alignedat}{1}
U &= 1 - (X-2)^2 / 2 \\
1 - U &= (X-2)^2 / 2 \\
2\ln(1 - U) &= (X-2)^2 \\
\sqrt{2\ln(1 - U)} &= X-2 \\
2 - \sqrt{2\ln(1 - U)} &= X \\
\end{alignedat}
$$

Technically, we could have a $\pm$ in front of the square root, but it doesn't make sense to consider the positive root since $X$ must be between one and two. In this case, we only consider the negative root to keep $X$ within bounds.

Be aware that we cannot replace $1-U$ with $U$ in this example. We need $1-U$ to keep $X$ bounded appropriately. For example, suppose we made the replacement and drew $U = 1$. Then, $X = 2 - \sqrt{2} < 1$, which doesn't make sense since we know that $X$ must be between one and two.

In any event, let's look at two simple examples. If $U = 0.4$, we evaluate $X = \sqrt{2U} = \sqrt{0.8}$. Alternatively, if $U = 0.5$, then $X = 2 - \sqrt{2(1-0.5)} = 2 - 1 = 1$.

## Inverse Transform Method - Continuous Examples - DEMO 1

In this demo, we'll look at some Matlab code that applies the inverse transform method to simulate a triangular(0,1,2) random variable. Here's the code.

```bash
m = 100;
X = [];
for i=1:m
  U = rand;
  if U < 0.5
    X(i) = sqrt(2 * U);
  else
    X(i) = 2 - sqrt(2 * (1-U));
  end
  i = i+1;
end
histogram(X)
```

First, we initialize an empty array, `X`, and then we iterate one hundred times. On each iteration, we sample a uniform random variable with the `rand` function, perform the appropriate transform depending on whether `U < 0.5`, and then store the result in `X`. After we finish iterating, we plot a histogram of the elements in `X`.

Let's take a look at the histogram we created, which slightly resembles a triangle.

![](https://assets.omscs.io/notes/2020-10-14-18-33-43.png)

Now, let's iterate one hundred thousand times and look at the resulting histogram. This result looks much nicer.

![](https://assets.omscs.io/notes/2020-10-14-18-35-04.png)

## Inverse Transform Method - Continuous Examples - DEMO 2

Now, let's talk about generating standard normal random variates. Remember our general formula: to compute $F^{-1}(U)$, we first set $F(X) = U$ and then solve for $X$.

Unfortunately, the inverse cdf of the normal distribution, $\Phi^{-1}(\cdot)$, does not have an analytical form, which means we can't use our normal approach. This obstacle frequently occurs when working with the inverse transform method.

### Generating Standard Normal Random Variables

One easy solution to get around this issue is to look up the values in a standard normal table. For instance, if $U = 0.975$, then the value of $Z$, for which $\Phi(Z) = 0.975$, is $1.96$. If we want to compute $\Phi^{-1}(0.975)$ in Excel, we can execute this function: `NORMSINV(0.975)`.

We can also use the following crude approximation for $Z$, which gives at least one decimal place of accuracy for $0.00134 \leq U \leq 0.98865$:

$$
Z = \Phi^{-1}(U) \approx \frac{U^{0.135} - (1-U)^{0.135}}{0.1975}
$$

Here's a more accurate, albeit significantly more complicated, approximation, which has an absolute error $\leq 0.45 \times 10^{-3}$:

$$
\begin{aligned}
& Z = \text{sign}(U - 1/2)\left(t-  \frac{c_0 + c_1t + c_2t^2}{1 + d_1t + d_2t^2 + d_3t^3}\right) \\[2ex]
& \text{where} \\[2ex]
& \text{sign}(x) = \left\{
    \begin{matrix}
    -1 & x < 0 \\
    0 & x = 0 \\
    1 & x > 0
    \end{matrix}
  \right., \\[5ex]
& t = \sqrt{-\ln[\min(U, 1-U)]^2}, \\[2ex]
&c_0 = 2.515517, \quad c_1 = 0.802853, \quad 0.010328 \\
&d_1 = 1.432788, \quad d_2 = 0.189269 \quad d_3 = 0.001308
\end{aligned}
$$

### Transforming Standard Normals to Other Normals

Now, suppose we have $Z \sim \text{Nor}(0,1)$, and we want $X \sim \text{Nor}(\mu, \sigma^2)$. We can apply the following transformation:

$$
X \leftarrow \mu + \sigma Z
$$

> Note that we multiply $Z$ by $\sigma$, not $\sigma^2$!

Let's look at an example. Suppose we want to generate $X \sim \text{Nor}(3,16)$, and we start with $U = 0.59$. We know that:

$$
X = \mu + \sigma Z
$$

Remember that $Z = \Phi^{-1}(U)$:

$$
X = \mu + \sigma \Phi^{-1}(U) = \mu + \sigma \Phi^{-1}(0.59)
$$

If we compute $\Phi^{-1}(0.59)$, using one of the methods above, we get $\Phi^{-1}(0.59) = 0.2275$. Now we can plug and chug:

$$
X = 3 + 4(0.2275) = 3.91
$$

### Matlab Demonstration

Let's look at some Matlab code to generate standard normal random variables from Unif(0,1) observations. Consider the following:

```bash

m = 100;
x = [];
for i=1:m
  X(i) = norminv(rand, 0, 1);
  i = i + 1;
end
histogram(X)
```

First, we initialize an empty array, `X`, and then we iterate one hundred times. On each iteration, we first sample a Unif(0,1) random variable with the `rand` function. Next, we transform it into a Nor(0,1) random variable using the `norminv` function, which receives a real number, a mean, and a standard deviation and returns the transformed value. Finally, we store the result in `X`. After we finish iterating, we plot a histogram of the elements in `X`.

Let's look at the resulting histogram, which doesn't look like the famous bell curve since we are only drawing one hundred observations.

![](https://assets.omscs.io/notes/2020-10-14-22-11-22.png)

Let's now sample one hundred thousand uniforms and plot the corresponding histogram. This result looks much prettier.

![](https://assets.omscs.io/notes/2020-10-14-22-12-28.png)

## Inverse Transform Method - Discrete Examples

In this lesson, we will use the inverse transform method to generate discrete random variables.

### Discrete Examples

It's often best to construct a table for discrete distributions when looking to apply the inverse transform method, especially if the distribution doesn't take on too many values.

### Bernoulli Example

Let's look at the Bern($p$) distribution. $X \sim \text{Bern}(p)$ takes on the value of one with probability $p$ and the value zero with probability $1 - p$.

The cdf, $F(x)$, takes on the value $1-p$ for $x = 0$ since $P(X \leq 0) = P(0) = 1 - p$. For $x = 1$, $F(x) = 1$, since $P(X \leq 1) = P(X = 0) + P(X = 1) = 1 - p + p = 1$.

Let's construct a table to see how we might map the unit interval onto these two values of $X$:

$$
\begin{array}{cccc}
x & P(X = x) & F(x) & \mathcal{U}(0,1)\text{'s} \\ \hline
0 & 1 - p & 1 - p & [0, 1 - p] \\
1 & p & 1 & (1 - p, 1]
\end{array}
$$

Since $P(X = 0)$ occurs with probability $1-p$, we transform all uniforms on the range $[0, 1-p]$ to $X = 0$. This leaves a range of uniforms of width $p$, which map to $X = 1$, from which we draw values with probability $p$.

Here's a simple implementation. If we draw a uniform $U \leq 1 - p$, then we take $X = 0$; otherwise, we take $X = 1$. For example, if $p = 0.75$, and $U - 0.13$, we take $X = 0$ since $U \leq (1 - p = 0.25)$.

Alternatively, we can construct the following "backwards" table, starting with $X = 1$ instead of $X = 0$, which isn't a strict application of the inverse transform method. However, this approach slices the uniforms in a much more intuitive manner. Here's the table:

$$
\begin{array}{cccc}
x & P(X = x) & F(x) & \mathcal{U}(0,1)\text{'s} \\ \hline
1 & p & 1 & [0, p] \\
0 & 1 - p & 1 - p & (p, 1]
\end{array}
$$

Here, we take $X = 1$ if $U \leq p$, which occurs with probability $p$, and we take $X = 0$ if $U > p$, which occurs with probability $1 - p$.

### Generic Example

Consider this slightly less-trivial pmf:

$$
\begin{array}{cccc}
x & P(X = x) & F(x) & \mathcal{U}(0,1)\text{'s} \\ \hline
-1 & 0.6 & 0.6 & [0.0, 0.6] \\
2.5 & 0.3 & 0.9 & (0.6, 0.9] \\
4 & 0.1 & 1.0 & (0.9, 1.0]
\end{array}
$$

Remember that, for a discrete distribution, $F(x_i) = P(X = x_i) + F(x_{i-1})$, where $F(x_0) = 0$. Correspondingly, the range of uniforms that maps to $x_i$ is bounded by $[F(x_{i-1}), F(x_i)]$. For example, if $U = 0.63$, we take $X = 2.5$.

### Discrete Uniform Example

Sometimes, there's an easy way to avoid constructing a table. For example, consider the discrete uniform distribution over $\{1,2,...,n\}$, which has the following pmf:

$$
P(X = k) = \frac{1}{n}, \quad k = 1,2,...,n
$$

We can think of this random variable as an $n$-sided die toss. How do we transform a Unif(0,1) correctly? If we take a real number between zero and one and multiply it by $n$, we get a real number between zero and $n$. If we round up, we get an integer between one and $n$. For example, if $n = 10$ and $U = 0.376$, then $X = \lceil 3.76 \rceil = 4$, where $\lceil\cdot\rceil$ is the ceiling/"round up" function.

### Geometric Example

Now let's look at the geometric distribution. Intuitively, this distribution represents the number of Bern($p$) trials until the first success. Therefore, the pmf, $f(k)$, represents the probability that the first success occurs on the $k$-th try: $k - 1$ failures, with probability $q^{k-1}$, followed by a single success, with probability $p$.

Accordingly, this distribution has the following pmf and cdf:

$$
f(k) = q^{k-1}p, \quad F(k) = 1 - q^k, k = 1,2,...,
$$

Let's set $F(X) = U$ and solve for $X$, finding the minimum $k$ such that $1 - q^k \geq U$. After some algebra, we see that:

$$
X = \min[k : 1 - q^k \geq U] = \left\lceil\frac{\ln(1-U)}{\ln(1-p)}\right\rceil
$$

As we've seen in the past, we can also replace $1-U$ with $U$:

$$
X = \min[k : 1 - q^k \geq U] = \left\lceil\frac{\ln(U)}{\ln(1-p)}\right\rceil
$$

For instance, if $p = 0.3$, and $U = 0.72$, we obtain:

$$
X = \left\lceil\frac{\ln(1- U)}{\ln(1-p)}\right\rceil = \left\lceil\frac{\ln(0.28)}{\ln(0.7)}\right\rceil = 4
$$

We can also generate a Geom($p$) random variable by counting Bern($p$) trials until we see a success. Suppose we want to generate $X \sim \text{Geom}(1/6)$. We can generate Bern($1/6$) random variables until we see a one. For instance, if we generate $0,0,0,0,1$, then $X = 5$.

More generally, we generate a Geom($p$) random variable by counting the number of trials until $U_i \leq p$, which occurs with probability $p$ for each $U_i$. For example, if $p=0.3$, and we draw $U_1 = 0.71$, $U_2 = 0.96$, and $U_3 = 0.12$, then $X=3$.

### Poisson Example

If we have a discrete distribution, like Pois($\lambda$), which has an infinite number of values, we could write out table entries until the cdf is *nearly* one, generate a uniform, $U$, and then search the table to find $X = x_i = F^{-1}(U)$, such that $U \in (F(x_{i-1}), F(x_i)]$. Consider the following table:

$$
\begin{array}{cccc}
x & P(X = x) & F(x) & \mathcal{U}(0,1)\text{'s} \\ \hline
x_1 & f(x_1) & F(x_1) & [0.0, F(x_1)] \\
x_2 & f(x_2) & F(x_2) & (F(x_1), F(x_2)] \\
x_3 & f(x_3) & F(x_3) & (F(x_2), F(x_3)] \\
\vdots
\end{array}
$$

For example, if we generate a uniform in the range $(F(x_1), F(x_2)]$, we select $X = x_2$.

Let's look at a concrete example, in which we will generate $X \sim \text{Pois}(2)$, which has the following pmf:

$$
f(x) = \frac{e^{-2}2^x}{x!}, \quad x = 0,1,2,...
$$

We can construct the following table:

$$
\begin{array}{cccc}
x & P(X = x) & F(x) & \mathcal{U}(0,1)\text{'s} \\ \hline
0 & 0.1353 & 0.1353 & [0.0, 0.1353] \\
1 & 0.2706 & 0.4059 & (0.1353, 0.4059] \\
2 & 0.2706 & 0.6765 & (0.4059, 0.6765] \\
\vdots
\end{array}
$$

For example, if $U = 0.313$, then $X = 1$.

## Inverse Transform Method - Empirical Distributions (OPTIONAL)

In this lesson, we will look at how to apply the inverse transform method to *unknown*, empirical, continuous distributions. Here, we don't know $F(x)$, so we have to approximate it. We will blend continuous and discrete strategies to transform these random variables.

### Continuous Empirical Distributions

If we can't find a good theoretical distribution to model a certain random variable, or we don't have enough data, we can use the **empirical cdf** of the data, $X_1, X_2,...,X_n$:

$$
\hat F_n(x) \equiv \frac{\text{number of } X_i\text{'s} \leq x}{n}
$$

Each $X_i$ has a probability $1/n$ of being drawn from our unknown continuous distribution. As a result, we can construct a cdf, $\hat F_n$, where $\hat F_n(x)$ is equal to the number of observations less than or equal to $x$, divided by the total number of observations.

Note that $\hat F_n(x)$ is a step function, which jumps by $1/n$ at every $X_i$.

Even though $X$ is continuous, the [Glivenko-Cantelli Lemma](https://en.wikipedia.org/wiki/Glivenko%E2%80%93Cantelli_theorem) states that $\hat F_n(x) \to F(x)$ for all $x$ as $x \to \infty$. As a result, $\hat F_n(x)$ is a good approximation to the true cdf, $F(x)$.

We can use the ARENA functions `DISC` and `CONT` to generate random variables from the empirical cdf's of discrete and random distributions, respectively.

To generate these random variables ourselves, let's first define the *ordered* points $X_{(1)} \leq X_{(2)} \leq X_{(n)}$, also called **order statistics**. Note that we wrap the subscripts in parentheses to differentiate them from the order in which they arrived. For example, if $X_1 = 4$, $X_2 = 1$, and $X_3 = 6$, then $X_{(1)} = 1$, $X_{(2)} = 4$, and $X_{(3)} = 6$.

Here's what the empirical cdf looks like, shown in red below:

![](https://assets.omscs.io/notes/2020-10-15-22-03-53.png)

Notice that we step from zero to $1/3$ at $X=1$, from $1/3$ to $2/3$ at $X=4$, and $2/3$ to $1$ at $X=6$. If we were to take many observations, then the empirical cdf would approach the true cdf, shown above in green.

### Linear Interpolation

Given that we only have a finite number, $n$, of data points, we can attempt to transform the empirical cdf into a continuous function by using linear interpolation between the $X_{(i)}$'s. Here is the corresponding interpolated cdf (which is not the true cdf even though we denote it as $F(x)$):

$$
F(x) = \left\{
  \begin{matrix}
    0 & \text{if } x < X_{(1)} \\
    \frac{i - 1}{n - 1} + \frac{x - X_{(i)}}{(n-1)(X_{(n+1)} - X_{(i)})} & \text{if } X_{(i)} \leq x \leq X_{(i+1)}, \forall i \\
    1 & \text{if } x \geq X_{(n)}
  \end{matrix}
  \right.
$$

If $x$ is less than the first order statistic, then $F(x) = 0$. Given our current observations, we have no evidence that we will encounter a value smaller than our current minimum. Similarly, if $x$ is greater than our last order statistic, then $F(x) = 1$. Again, we have no evidence that we will encounter a value greater than our current maximum. For all other points, we interpolate.

Here's the interpolation algorithm. First, we set $F(X) = U \sim \mathcal U(0,1)$. Next, we set $P = (n-1)U$ and $I = \lceil P \rceil$. Note that $I$ is a discrete uniform random variable over $\{1,2,...,n\}$. Finally, we evaluate the following equation for $X$:

$$
X = X_{(I)} + (P - I + 1)(X_{(I+1)} - X_{(I)})
$$

Let's break down the above equation. $X_{(I)}$ corresponds to our random starting order statistic. The expression $P - I + 1$ turns out to be Unif(0,1): we subtract an integer from the uniform from which it was rounded up and then add one. We multiply that uniform random value by $X_{(I+1)} - X_{(I)}$ to move the appropriate distance between our starting point and the next order statistic.

For example, suppose $X_{(1)} = 1$, $X_{(2)} = 4$ and $X_{(3)} = 6$. If $U = 0.73$, then $P = (n-1)U = 1.46$ and $I = \lceil P \rceil = 2$. Then:

$$
\begin{alignedat}{1}
X &= X_{(I)} + (P - I + 1)(X_{(I+1)} - X_{(I)}) \\
&= X_{(2)} + (1.46 - 2 + 1)(X_{(3)} - X_{(2)}) \\
&= 4 + (0.46)(6 - 4) \\
&= 4.92
\end{alignedat}
$$

Let's see what the linearly interpolated cdf looks like, shown below in orange. Notice that, between $X = 1$ and $X=6$, we have two line segments: one from $X = 1$ to $X=4$, and one from $X=4$ to $X=6$.

![](https://assets.omscs.io/notes/2020-10-15-22-29-13.png)

Suppose we draw a uniform, $U = 0.73$.

![](https://assets.omscs.io/notes/2020-10-15-22-31-54.png)

If we drop a line from the intersection point with the cdf vertically down, the $x$-coordinate of the intersection with the $x$-axis is $F^{-1}(U)$.

![](https://assets.omscs.io/notes/2020-10-15-22-33-29.png)

Alternatively, we can write the interpolated cdf explicitly by using the equation we saw previously and enumerating the two $[X_{(i)}, X_{(i+1)}]$ ranges:

$$
F(x) = \left\{
  \begin{matrix}
    0 + \frac{x-1}{2(4-1)} & \text{if } 1 \leq x < 4 \quad \text{(i = 1 case)} \\[2ex]
    \frac{1}{2} + \frac{x-4}{2(6-4)} & \text{if } 4 \leq x < 6 \quad \text{(i = 2 case)}  \\
  \end{matrix}
  \right.
$$

If we set $F(X) = U$ and solve for both cases, we have:

$$
X = \left\{\begin{matrix}
    1 + 6U & \text{if } U < 1/2 \\[2ex]
    2 + 4U & \text{if } U \geq 1/2  \\
  \end{matrix}
  \right.
$$

Again, if $U = 0.73$, then $X = 2 + 4(0.73) = 4.92$.

## Convolution Method

In this lesson, we'll look at an alternative to the inverse transform method: the convolution method.

### Binomial Example

The term **convolution** refers to adding things up. For example, if we add up $n$ iid Bern($p$) random variables, we get a Binomial($n$, $p$) random variable:

$$
Y = \sum_{i=1}^n (X_i \sim \text{Bern}(p)) \sim \text{Bin}(n,p)
$$

We already know how to generate Bern($p$) random variables using the inverse transform method. Suppose we have a collection of uniforms, $U_1,...,U_n \overset{\text{iid}}{\sim} \mathcal{U}(0,1)$. If $U_i \leq p$, we set $X_i = 1$; otherwise, $X_i = 0$. If we repeat this process for all $X_i$ and then add up the $X_i$'s, we get $Y$.

For instance, suppose we want to generate $Y \sim \text{Bin}(3, 0.4)$. Let's draw three uniforms: $U_1 = 0.63$, $U_2 = 0.17$, and $U_3 = 0.81$. We transform these uniforms into the respective Bern($p$) random variables: $X_1 = 0$, $X_2 = 1$, and $X_3 = 0$. If we add these values together, we get $Y = 1$.

### Triangular Example

Now let's turn to the Tria(0,1,2) distribution. Remember, we generated triangular random variables using the inverse transform method previously. Alternatively, we can add two iid uniforms together to generate a Tria(0,1,2). In other words, if $U_1, U_2 \overset{\text{iid}}{\sim} \mathcal U(0,1)$, then $U_1 + U_2 \sim \text{Tria}(0,1,2)$.

Let's look at a pictorial representation of this result.

![](https://assets.omscs.io/notes/2020-10-16-21-55-26.png)

In the Tria(0,1,2) distribution, values close to either end of the range are quite rare. Indeed, it is highly unlikely that two iid uniforms will both have a value very close to zero or one. Values closer to 0.5 are much more likely, and the resulting distribution, which has a maximum probability at $X = 1$, reflects this fact.

This result should remind us of dice toss outcomes. Suppose we toss two six-sided dice. It's highly unlikely for us to see a two or a twelve, each of which occurs with probability $1/36$, but it's much more common to see a seven, which occurs with probability $1/6$. There are just more ways to roll a seven.

### Erlang Example

Suppose $X_1,..., X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)$. By definition, the sum of these exponential random variables forms an Erlang$_n$($\lambda$) random variable:

$$
Y = \sum_{i=1}^n X_i \sim \text{Erlang}_n(\lambda)
$$

Let's use the inverse transform method with convolution to express $Y$ in terms of uniform random variables. First, let's remember how we transform uniforms into exponential random variables:

$$
\begin{alignedat}{1}
F(x) &= 1 - e^{-\lambda x} \\
U &= 1 - e^{-\lambda X} \\
\vdots \\
X &= \frac{-1}{\lambda}\ln(U)
\end{alignedat}
$$

Let's rewrite our summation expression to reflect this transformation:

$$
Y = \sum_{i=1}^n X_i = \frac{-1}{\lambda}\sum_{i=1}^n \ln(U_i)
$$

Now, we can take advantage of the fact that $\ln(a) + \ln(b) = \ln(ab)$ and replace $n$ natural log invocations with just one. Why might we do this? Natural logarithms are expensive to evaluate on a computer, so we want to reduce them where possible. Consider the following manipulation:

$$
Y = \sum_{i=1}^n \left[\frac{-1}{\lambda}\ln(U_i)\right] = \frac{-1}{\lambda}\ln\left(\prod_{i=1}^n U_i\right)
$$

### Desert Island Nor(0,1) Approximate Generator

Suppose we have the random variables $U_1,...,U_n \overset{\text{iid}}{\sim} \mathcal U(0,1)$, and we let $Y$ equal the summation of the $U_i$'s: $Y = \sum_{i=1}^n U_i$. The central limit theorem tells us that, for large enough $n$, $Y$ is approximately normal. Furthermore, we know that the mean of $Y$ is $nE[U_i]$ and the variance of $Y$ is $n\text{Var}(U_i)$. As a result, $Y \approx \text{Nor}(n/2, n/12)$.

Let's choose $n=12$ and assume that it's "large enough". Then $Y \approx \text{Nor}(6, 1)$. If we subtract $6$ from $Y$, then the resulting mean is $0$, and we end up with a standard normal random variable:

$$
Y - 6 = \sum_{i=1}^{12} U_i - 6 \approx \text{Nor}(0,1)
$$

### Other Convolution-Related Tidbits

If $X_1,...,X_n$ are iid Geom($p$) random variables, then the sum of the $X_i$'s is a negative binomial random variable:

$$
\sum_{i=1}^{n} X_i \sim \text{NegBin}(n,p)
$$

If $Z_1,..., Z_n$ are iid Nor(0, 1) random variables, then sum of the squares of the $Z_i$'s is a $\chi^2$ random variable:

$$
\sum_{i=1}^{n} Z_i^2 \sim \chi^2(n)
$$

If $X_i,...,X_n$ are iid Cauchy random variables, then the sample mean, $\bar X$, is also a Cauchy random variable. We might think that $\bar X$ is normal for large $n$, but this is not the case as the Cauchy distribution violates the central limit theorem.

## Convolution Method DEMO

In this demo, we will look at some of the random variables we can generate using convolution. First, we'll look at how we generate a uniform distribution, which, admittedly, involves no convolution. Consider the following code:

```bash
n = 1;
m = 1000000;
Z = 0 * unifrnd(0,1,[1 m]));

for i=1:n
  Z=Z+(unifrnd(0,1,[1 m]));
  i=i+1;
end
Z=Z/n;
hist(Z,100);
```

This code generates the following histogram, which indeed appears uniform.

![](https://assets.omscs.io/notes/2020-10-16-23-04-49.png)

If we change `n` from one to two, then `Z` becomes the sum of two uniforms. This code generates the following histogram, which appears triangular, as expected.

![](https://assets.omscs.io/notes/2020-10-16-23-08-07.png)

Let's change `n` to three and repeat. The following histogram appears to be taking on a normal shape.

![](https://assets.omscs.io/notes/2020-10-16-23-08-46.png)

Let's change `n` to 12 to emulate the "desert island" normal random variable generator we discussed previously. This histogram resembles the normal distribution even more closely.

![](https://assets.omscs.io/notes/2020-10-16-23-11-41.png)

Now, let's look at generating Exp(1) random variables. Consider the following code:

```bash
n = 1;
m = 1000000;
Z = 0 * unifrnd(0,1,[1 m]));

for i=1:n
  Z=Z-log(unifrnd(0,1,[1 m])); % This is the only line that changes
  i=i+1;
end
Z=Z/n;
hist(Z,100);
```

Here's the corresponding histogram.

![](https://assets.omscs.io/notes/2020-10-16-23-14-37.png)

Now, if we change `n` from one to two, then `Z` becomes the sum of two exponential random variables, itself an Erlang random variable. Here's the corresponding histogram.

![](https://assets.omscs.io/notes/2020-10-16-23-15-53.png)

Let's add `n=30` exponential random variables, which the central limit theorem tells us will produce an approximately normal result. Here's the histogram. This histogram is clearly *not* the normal distribution, as it contains considerable right skew.

![](https://assets.omscs.io/notes/2020-10-16-23-17-09.png)

For a much better approximation, we likely need to add several hundred observations together. Here's the histogram for `n=200`.

![](https://assets.omscs.io/notes/2020-10-16-23-18-58.png)

Finally, let's look at generating Cauchy random variables. Consider the following code:

```bash
n = 1;
m = 1000;
Z = 0 * unifrnd(0,1,[1 m]));

for i=1:n
  Z=Z + normrnd(0.0, 1.0, [1 m]) ./normrnd(0.0, 1.0, [1 m]) % This is the only line that changes
  i=i+1;
end
Z=Z/n;
hist(Z,100);
```

If we generate `m = 1000` of these random variables, we get the following histogram. The Cauchy distribution has a large variance so, even though most of the observations are close to zero, there are a few observations far out on either side.

![](https://assets.omscs.io/notes/2020-10-16-23-22-41.png)

If we add `n = 1000` Cauchy random variables, we might expect to see a histogram approximating the normal distribution. However, as we can see from the following plot, the Cauchy distribution violates the central limit theorem.

![](https://assets.omscs.io/notes/2020-10-16-23-24-59.png)

## Acceptance-Rejection Method

In this lesson, we'll talk about the acceptance-rejection method, which is an alternative to the inverse transform method and the convolution technique we studied previously. In contrast to those two methods, acceptance-rejection is very general, and it always works regardless of the random variate we want to generate.

### Acceptance-Rejection Method

The motivation for the acceptance-rejection method is that most cdf's cannot be inverted efficiently, which means that the inverse transform method has limited applicability.

The **acceptance-rejection** method samples from an "easier" distribution, which is close to but not identical to the one we want. Then, it adjusts for this discrepancy by "accepting" (keeping) only a certain proportion of the variates it generates from the approximating distribution.

The acceptance proportion is based on how close the approximate distribution is to the one we want. If the sampling distribution resembles the desired distribution closely, we keep a high proportion of the samples.

Let's look at a simple example. Suppose we want to generate $X \sim \mathcal U(2/3, 1)$. Of course, we'd usually use the inverse transform method for something so trivial, but let's see how we'd generate $X$ using acceptance-rejection.

Here's the algorithm. First, we generate $U \sim \mathcal U(0, 1)$. Next, we check to see if $U \geq 2/3$. If so, we *accept* $U$ and set $X=U$, because the conditional distribution of $X$ given that $U \geq 2/3$ is $\mathcal U (2/3, 1)$. If $U < 2/3$, we *reject* the observation, and we return to step one, where we draw another uniform. Eventually, we'll get $U \geq 2/3$, at which point we stop.

### Notation

Suppose we want to simulate a continuous random variable, $X$, with pdf $f(x)$, but $X$ is difficult to generate directly. Also suppose that we can easily generate a random variable that has a distinct pdf, $h(x) \equiv t(x)/c$, where $c$ is a constant and $t(x)$ majorizes f(x).

> When we say that $t(x)$ **majorizes** $f(x)$, we mean that $t(x) \geq f(x)$, for all $x$.

Note that only $h(x)$, not $t(x)$, is a pdf. Since $t(x) \geq f(x)$, and the integral of $f(x)$ over the real line equals one - by virtue of $f(x)$ being a pdf - then the corresponding integral of $t(x)$ must be greater than or equal to one. Since $t(x)$ doesn't strictly integrate to one, it cannot be a pdf.

Let's look at the constant, $c$. We define $c$, which we assume to be finite, as the integral of $t(x)$ over the real line, which we just said was greater than or equal to the corresponding integral of $f(x)$:

$$
c \equiv \int_{\mathbb{R}} t(x)dx \geq \int_{\mathbb{R}} f(x)dx = 1, \quad c < \infty
$$

### Theorem

Let's define a function $g(x) \equiv f(x)/t(x)$. We can notice that, since $f(x) \leq t(x)$, $0 \leq g(x) \leq 1$ for all $x$. Additionally, let's sample $U \sim \mathcal U(0,1)$, and let $Y$ be a random variable (independent of $U$), with the pdf we defined earlier: $h(y) \equiv t(y) / c$.

If $U \leq g(Y)$, then the conditional distribution of $Y$ has pdf $f(y)$. Remember, the random variable we are trying to generate has pdf $f(y)$. In other words, we accept that $Y$ has the pdf of the random variable we want when $U \leq g(Y)$.

This result suggests the following acceptance-rejection algorithm for generating a random variable $X$ with pdf $f(x)$. First, we generate $U \sim \mathcal U(0,1)$ and $Y$ with pdf $h(y)$, independent of $U$. If $U \leq g(Y)$, we accept $Y$ and we return $X = Y$; otherwise, we reject $Y$ and start over, continuing until we produce an acceptable $(U, Y)$ pair. We refer to the event $U \leq g(Y)$ as the **acceptance event**, which always happens eventually.

### Visual Walkthrough

Consider the following pdf, outlined in green, which is the pdf of the random variable we want to generate.

![](https://assets.omscs.io/notes/2020-10-18-19-31-08.png)

Now consider $t(x)$, shown in red below, which majorizes $f(x)$. As we can see: $t(x) \geq f(x)$, for all $x$.

![](https://assets.omscs.io/notes/2020-10-18-19-32-06.png)

Finally, let's consider $h(x)$, which is defined as $t(x) / c$, where $c$ is the area under $t(x)$. As a result, $h(x)$ is proportional to $t(x)$, but has an area equal to one, which makes it a valid pdf.

![](https://assets.omscs.io/notes/2020-10-18-19-34-07.png)

Let's generate a point, $Y$, uniformly under $t(x)$. We accept that point with probability $g(Y) = f(Y)/t(Y) = f(Y)/ch(Y)$. For the point below, we can see the corresponding values of $t(Y)$ and $f(Y)$. As the distance between $t(Y)$ and $f(Y)$ decreases, the probability of accepting $Y$ as a valid value of $X$ increases.

![](https://assets.omscs.io/notes/2020-10-18-19-36-52.png)

## Proof of Acceptance-Rejection Method (OPTIONAL)

In this lesson, we will prove the acceptance-rejection method.

### A-R Method Recap

Let's define $g(x) \equiv f(x)/t(x)$. Remember that $f(x)$ is the pdf of the random variable, $X$, that we wish to generate, and $t(x)$ majorizes $f(x)$. Let $U \sim \mathcal U(0,1)$, and let $Y$ be a random variable, independent of $U$, with pdf $h(y) = t(y)/c$.

Note that $t(y)$ is not a pdf, but we can transform it into a pdf by dividing it by $c$ - the area under $t(y)$ - which guarantees that it integrates to one.

If $U \leq g(Y)$, we set $X=Y$ because the conditional distribution of $Y$, given $U \leq  g(Y)$, is $f(x)$. Again, we refer to $U \leq g(Y)$ as the acceptance event. We continue sampling $U$ and $Y$ until we have an acceptance, at which point we set $X=Y$ and stop.

### Proof

We need to prove that the value that comes out of this algorithm, which we claim has pdf $f(x)$, indeed has pdf $f(x)$.

Let $A$ be the acceptance event. The cdf of $X$ is, by definition:

$$
P(X \leq x)
$$

Given that we have experienced $A$, we have set $Y = X$. As a result, we can express the cdf of $X$ with a conditional probability concerning $Y$ and $A$:

$$
P(X \leq x) = P(Y \leq x | A)
$$

We can expand the conditional probability:

$$
P(X \leq x) = P(Y \leq x | A) = \frac{P(A, Y \leq X)}{P(A)} \quad (1)
$$

Now, what's the probability of the acceptance event, $A$, given $Y$? Well, from the definition of $A$, we see that:

$$
P(A|Y=y) = P(U \leq g(Y)|Y=y)
$$

Since $Y=y$, we can substitute $y$ for $Y$:

$$
P(U \leq g(Y)|Y=y) = P(U \leq g(y)|Y=y)
$$

Earlier, we stated that $U$ and $Y$ are independent. As a result, information about $Y$ gives us no information about $U$, so:

$$
P(U \leq g(y)|Y=y) = P(U \leq g(y))
$$

Additionally, we know that $U$ is uniform, so, by definition, $P(U \leq x) = x, 0 \leq x \leq 1$. Since $g(y)$ also has a range of $[0,1]$, by definition, then:

$$
P(U \leq g(y)) = g(y) \quad (2)
$$

Now let's consider the joint probability $P(A, Y \leq x)$. Here, we can use the law of total probability, also known as the standard conditioning argument:

$$
P(A, Y \leq x) = \int_{-\infty}^\infty P(A, Y \leq x | Y=y)h(y)dy
$$

We can express $Y \leq x$ directly in the limits of integration, instead of in the conditional probability expression inside the integral. If we integrate over all $y$, such that $-\infty \leq y \leq x$, then we are still only considering values of $Y$ such that $Y \leq x$:

$$
P(A, Y \leq x) = \int_{-\infty}^x P(A | Y=y)h(y)dy
$$

We can substitute $t(y)/c = h(y)$:

$$
P(A, Y \leq x) = \frac{1}{c}\int_{-\infty}^x P(A | Y=y)t(y)dy
$$

We might remember, from result $(2)$ above, that $P(A|Y=y) = g(y)$. Therefore:

$$
P(A, Y \leq x) = \frac{1}{c}\int_{-\infty}^x g(y)t(y)dy
$$

Also remember that, by definition, $g(y) = f(y)/t(x)$. Therefore:

$$
P(A, Y \leq x) = \frac{1}{c}\int_{-\infty}^x f(y)dy \quad (3)
$$

If we let $x \to \infty$, then we have:

$$
P(A) = \frac{1}{c}\int_{-\infty}^\infty f(y)dy
$$

Notice that two things changed here. First, we changed the upper limit of integration from $x$ to $\infty$. Second, we changed the probability expression from $P(A, Y \leq x)$ to $P(A)$. Why? If $x \to \infty$, $P(Y \leq x) \to 1$, so $P(A, Y \leq x) \to P(A)$.

We know that $f(x)$ is a pdf, and the integral of a pdf over the real line is equal to one, so:

$$
P(A) = \frac{1}{c}\int_{-\infty}^\infty f(y)dy = \frac{1}{c} \quad (4)
$$

Together, facts $(1)$, $(3)$, and $(4)$ imply that:

$$
P(X \leq x) = \frac{P(A, Y \leq x)}{P(A)} = \int_{-\infty}^x f(y)dy
$$

Essentially, we have shown that the cdf of $X$ is equal to the integral of $f(y)$, from $-\infty$ to $x$. If we take the derivative of both sides, we see that the pdf of $X$ is equal to $f(x)$.

![](https://assets.omscs.io/notes/2020-10-18-21-58-21.png)

There are two main issues here. First, we need the ability to sample $Y$ from $h(y)$ quickly since we can't sample $X$ from $f(x)$ easily. Second, $c$ must be small since the probability of the acceptance event is:

$$
P(U \leq g(Y)) = \frac{1}{c}
$$

Now, $c$ is bounded by one from below - $f(x) = t(x), c = 1$ - so we want $c$ to be as close to one as possible. If so, then:

$$
P(U \leq g(Y)) = \frac{1}{c} \approx 1
$$

If $c \approx 1$, then we accept almost every $Y$ we sample. If $c$ is very large, then $1/c$ is very small, and we will likely have to draw many $(U, Y)$ pairs before acceptance. In fact, the number of trials until "success", defined as $U \leq g(Y)$, is Geom($1/c$), which has an expected value of $c$ trials.

## A-R Method - Continuous Examples

In this lesson, we will look at some examples of applying the acceptance-rejection method on continuous distributions. As we said, acceptance-rejection is a general method that always works, even when other methods may be difficult to apply.

### Theorem Refresher

Define $g(x) \equiv f(x)/t(x)$, and note that $0 \leq g(x) \leq 1$ for all $x$. We sample $U \sim \mathcal U(0,1)$ and $Y$ from pdf $h(y) = t(y)/c$, where $t(y)$ majorizes $f(x)$ and $c$ is the integral of $t(y)$ over the real line. If $U \leq g(Y)$, then $Y$ has the conditional pdf $f(y)$.

Here's the basic algorithm, which we repeat until acceptance. First, we draw $U$ from $\mathcal U(0,1)$ and $Y$ from $h(y)$ independent of $U$. If $U \leq g(Y)$, we return $X \leftarrow Y$. Otherwise, we repeat, sampling $U$ and $Y$ again.

### Example

Let's generate a random variable with pdf $f(x) = 60x^3(1-x)^2, 0 \leq x \leq 1$. This pdf is shown below.

![](https://assets.omscs.io/notes/2020-10-19-22-12-00.png)

We can't invert this pdf analytically, so we cannot use the inverse transform method; we must use acceptance-rejection. We can use some calculus to determine that the maximum of $f(x)$ occurs at $x = 0.6$: $f(0.6) = 2.0736$. With this knowledge, we can generate a basic majorizer, $t(x) = 2.0736$.

![](https://assets.omscs.io/notes/2020-10-19-22-15-11.png)

Remember that we said we wanted $c$ to be as close to one as possible so that we accept samples from $h(y)$ with high probability. We know that $c$ equals the integral of $t(x)$ from zero to one, so, in this case, $c = 2.0736$. All this to say, $t(x)$ is a relatively inefficient majorizer.

Like we said, $h(x) = t(x)/c$. In this case, $h(x) = 1$, since $t(x) = 2.0736 = c$. This result means that $Y$ is a Unif(0,1) random variable, since it's pdf is one.

![](https://assets.omscs.io/notes/2020-10-19-22-20-29.png)

Finally, let's compute $g(x)$:

$$
g(x) = \frac{f(x)}{t(x)} = \frac{60x^3(1-x)^2}{2.0736}
$$

Let's look at a simple example. Let's draw two uniforms, $U = 0.13$ and $Y = 0.25$. If we plug and chug, we see that $g(Y) \approx 0.25$. Therefore, $U \leq g(Y)$ and we take $X \leftarrow 0.25$.

## A-R Method - Continuous Examples DEMO

### Previous Example

Let's demo the acceptance-rejection example we looked at previously. We wanted to generate $X$ with pdf $f(x) = 60x^3(1-x)^2, 0 \leq x \leq 1$. Let's recall $g(x)$:

$$
g(x) = \frac{f(x)}{t(x)} = \frac{60x^3(1-x)^2}{2.0736}
$$

Additionally, remember that our acceptance event is $U \leq g(Y)$. Consider the following code:

```bash
m = 10000;
X = [];
for i=1:m
  U = 1; % Initialize to known failing condition
  Y = 0; % Initialize to known failing condition
  while U > 60 * (Y^3) * (1-Y)^2 / 2.0736
    U = rand;
    Y = rand;
  end
  X(i) = Y;
  i=i+1
end
histogram(X)
```

This code iterates for `m=10000` iterations and, on each iteration, generates Unif(0,1) random variables, `Y` and `U`, until the acceptance event occurs. Once it does, we store away the accepted value of `Y` and proceed to the next iteration. Finally, we generate a histogram of the `m` accepted values of `Y`.

Let's look at the generated histogram after 10,000 samples.

![](https://assets.omscs.io/notes/2020-10-19-23-26-35.png)

Here's the histogram after 100,000 samples. As we can see, the histogram of generated values looks quite close to the graph of $f(x)$.

![](https://assets.omscs.io/notes/2020-10-19-23-27-10.png)

### Half-Normal Example

In this example, we are going to generate a standard *half-normal* random variable, which has the following pdf:

$$
f(x) = \frac{2}{\sqrt{2\pi}}e^{\frac{-x^2}{2}}, \quad x \geq 0
$$

This random variable closely resembles a standard normal random variable, except that we've "flipped" the negative portion of the distribution over the $y$-axis and doubled $f(x)$, for all $x \geq 0$.

We can use the following majorizing function, $t(x)$, as it is always greater than $f(x)$:

$$
t(x) = \sqrt{\frac{2e}{\pi}}e^{-x} \geq f(x)
$$

If we take the integral of $t(x)$ over the domain of $f(x)$, we get $c$:

$$
c = \int_0^{\infty} t(x)dx = \sqrt{\frac{2e}{\pi}}
$$

Now, let's compute $h(x)$:

$$
h(x) = \frac{t(x)}{c} = e^{-x}
$$

Let's remember the pdf for an exponential random variable:

$$
f(x) = e^{-\lambda x}
$$

We can see that $h(x)$ is simply the pdf of an Exp(1) random variable, which we can generate easily!

Finally, let's look at $g(x)$:

$$
g(x) = \frac{f(x)}{t(x)} = e^{-(x-1)^2/2}
$$

To generate a half normal, we simply generate $U \sim \mathcal U(0,1)$ and $Y \sim \text{Exp}(1)$ and accept $Y$ if $U \leq g(Y)$.

We can use the half-normal result to generate a Nor(0,1) random variable. We simply have to "flip back" half of the $X$ values over the $y$-axis. Given $U \sim \mathcal U(0,1)$ and $X$ from the half-normal distribution, we can see that:

$$
Z = \left\{
  \begin{matrix}
  -X & U \leq 1/2 \\
  X & U > 1/2
  \end{matrix}
  \right. \sim \text{Nor}(0,1)
$$

As always, we can generate a Nor($\mu$, $\sigma^2$) by applying the transformation $\mu + \sigma Z$.

## A-R Method - Poisson Distribution

In this lesson, we will use a method similar to acceptance-rejection to generate a discrete random variable.

### Poisson Distribution

The Poisson distribution has the following pmf:

$$
P(X=n) = e^{-\lambda}\frac{\lambda^n}{n!}, \quad n = 0, 1,...
$$

We'll use a variation of the acceptance-rejection method here to generate a realization of $X$. The algorithm will go through a series of equivalent statements to arrive at a rule that gives $X = n$ for some $n$.

Remember that, by definition, $X = n$ if and only if we observe exactly $n$ arrivals from a Poisson($\lambda$) process in one time unit. We can define $A_i$ as the $i$th interarrival time from a Pois($\lambda$) process: the time between arrivals $i-1$ and $i$.

Like we said, $X=n$ if and only if we see exactly $n$ Pois($\lambda$) arrivals by $t = 1$. We can express this requirement as an inequality of sums:

$$
X = n \iff \sum_{i=1}^n A_i \leq 1 < \sum_{i=1}^{n+1} A_i
$$

In other words, the sum of the first $n$ interarrival times must be less than or equal to one, and, correspondingly, the sum of the first $n+1$ interarrival times must be greater than one. Put another way, the $n$th arrival occurs by time $t=1$, but the $(n+1)$th arrival occurs after time $t=1$.

We might recall that interarrival times from a Pois($\lambda$) are generated from an Exp($\lambda$) distribution, and we know how to transform uniforms into Exp($\lambda$) random variables:

$$
X = n \iff \sum_{i=1}^n \left[\frac{-1}{\lambda}\ln U_i\right] \leq 1 < \sum_{i=1}^{n+1} \left[\frac{-1}{\lambda}\ln U_i\right]
$$

As we saw previously, we can move the natural logarithm outside of the sum and convert the sum to a product: $\ln(a) + \ln(b) = \ln(ab)$. Consider:

$$
X = n \iff \frac{-1}{\lambda}\ln\left(\prod_{i=1}^nU_i\right) \leq 1 < \frac{-1}{\lambda}\ln\left(\prod_{i=1}^{n+1}U_i\right)
$$

Let's multiply through by $-\lambda$ - make sure to flip the inequalities when multiplying by a negative - and raise the whole thing by $e$:

$$
X = n \iff \prod_{i=1}^nU_i \geq e^{-\lambda} > \prod_{i=1}^{n+1}U_i
$$

To generate a Pois($\lambda$) random variable, we will generate $n+1$ uniforms until the above inequality holds, and then we'll set $X=n$.

### Poisson Generation Algorithm

Let's set $a = e^{-\lambda}$, $p=1$, and $X=-1$. Note that even though we set $X$ to $-1$, the first thing we do is increment it. As long as $p < a$, we generate a uniform, $U$. Next, we update our running product, $p = pU$, and we increment $X$ by one. Once $p < a$, we return $X$.

### Example

Let's obtain a Pois(2) random variable. We will sample uniforms until the following condition holds:

$$
e^{-\lambda} = e^{-2} = 0.1353 > \prod_{i=1}^{n+1}U_i
$$

Consider the following table:

$$
\begin{array}{cccc}
n & U_{n+1} & \prod_{i=1}^{n+1}U_i & \text{Stop?} \\ \hline
0 & 0.3911 & 0.3911 & \text{No} \\
1 & 0.9451 & 0.3696 & \text{No} \\
2 & 0.5033 & 0.1860 & \text{No} \\
3 & 0.7003 & 0.1303 & \text{Yes}
\end{array}
$$

From our iterative sampling above, we see that we take $X=3$ since the inequality above holds for $n=3$.

### Remark

It turns out the the expected number of $U$'s required to generate one realization of $X$ is $E[X+1] = \lambda + 1$. For example, if $\lambda = 8.3$, then we need to sample, on average, $9.3$ uniforms before we realize $X$.

This sampling process becomes tedious; thankfully, for large values of $\lambda$, we can take a shortcut. When $\lambda \geq 20$, then $X$ is approximately Nor($\lambda$, $\lambda$). We can standardize $X$ to get a Nor(0,1) random variable:

$$
\frac{X - \lambda}{\sqrt \lambda} \approx \text{Nor}(0,1)
$$

Given this fact, we can use the following algorithm to generate a Pois($\lambda$) random variable. First, generate $Z$ from Nor(0,1). Next, return:

$$
X = \max(0, \lfloor \lambda + \sqrt \lambda Z + 0.5\rfloor)
$$

Let's walk through the above expression. The term $\sqrt \lambda Z$ turns our Nor(0,1) random variable into a Nor(0, $\lambda$) random variable. If we add $\lambda$, we get a Nor($\lambda$, $\lambda$) random variable.

Remember that the normal distribution is continuous, and the Poisson distribution is discrete. We need to discretize our real-valued transformation of $Z$, which we accomplish by rounding down. However, if we always round down, then we will underestimate $X$, on average.

We perform a **continuity correction** by adding $0.5$ before we round, which means that if $\lambda + \sqrt \lambda Z$ is between two numbers, we choose the larger number with probability $0.5$ and the lower number with probability $0.5$.

Finally, we have to take the maximum of our computed value and zero. Why? The standard normal distribution can return negative values, but the Poisson can only return zero or larger.

Let's look at a simple example. If $\lambda = 30$ and $Z = 1.46$, then $X = \lfloor 30.5 + \sqrt 30(1.46) = 38$.

Of course, we could have also used the discrete version of the inverse transform method to generate Pois($\lambda$) random variables by tabling the cdf values and mapping them to the appropriate uniform ranges.

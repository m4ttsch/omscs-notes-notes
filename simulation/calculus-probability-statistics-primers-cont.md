---
id: simulation-notes-calculus-probability-statistics-primers-cont
title: Calculus, Probability, and Statistics Primers, Continued
course: simulation
lecture: calculus-probability-statistics-primers-cont
---

# Calculus, Probability, and Statistics Primers, Continued

## Conditional Expectation (OPTIONAL)

In this lesson, we are going to continue our exploration of conditional expectation and look at several cool applications. This lesson will likely be the toughest one for the foreseeable future, but don't panic!

### Conditional Expectation Recap

Let's revisit the conditional expectation of $Y$ given $X = x$. The definition of this expectation is as follows:

$$
E[Y|X = x] = \left\{\begin{matrix}
\sum_y y f(y|x) & \text{discrete} \\
\int_{\mathbb{R}} y f(y|x)dy & \text{continuous}
\end{matrix}\right.
$$

For example, suppose $f(x,y) \ 21x^2y / 4$ for $x^2 \leq y \leq 1$. Then, by definition:

$$
f(y|x) = \frac{f(x,y)}{f_X(x)}
$$

We calculated the marginal pdf, $f_X(x)$, previously, as the integral of $f(x,y)$ over all possible values of $y \in [x^2, 1]$. We can plug in $f_X(x)$ and $f(x, y)$ below:

$$
f(y|x) = \frac{\frac{21}{4}x^2y}{\frac{21}{8}(1- x^4)} = \frac{2y}{1 - x^4}, \quad x^2 \leq y \leq 1
$$

Given $f(y|x)$, we can now compute $E[Y | X = x]$:

$$
E[Y | X = x] = \int_{\mathbb{R}} y * \left(\frac{2y}{1 - x^4}\right)dy
$$

We adjust the limits of integration to match the limits of $y$:

$$
E[Y | X = x] = \int_{x^2}^1 y * \left(\frac{2y}{1 - x^4}\right)dy
$$

Now, complete the integration:

$$
E[Y | X = x] = \int_{x^2}^1 \frac{2y^2}{1 - x^4}dy
$$

$$
E[Y | X = x] = \frac{2}{1 - x^4} \int_{x^2}^1 y^2dy
$$

$$
E[Y | X = x] = \frac{2}{1 - x^4} \frac{y^3}{3}\Big|^1_{x^2}
$$

$$
E[Y | X = x] = \frac{2}{3(1 - x^4)} y^3\Big|^1_{x^2} = \frac{2(1 - x^6)}{3(1 - x^4)}
$$

### Double Expectations

We just looked at the expected value of $Y$ given a particular value $X = x$. Now we are going to average the expected value of $Y$ over all values of $X$. In other words, we are going to take the average expected value of all the conditional expected values, which will give us the overall population average for $Y$.

The theorem of **double expectations** states that the expected value of the expected value of $Y$ given $X$ is the expected value of $Y$. In other words:

$$
E[E(Y|X)] = E[Y]
$$

Let's look at $E[Y|X]$. We can use the formula that we used to calculate $E[Y|X=x]$ to find $E[Y|X]$, replacing $x$ with $X$. Let's look back at our conditional expectation from the previous slide:

$$
E[Y | X = x] = \frac{2(1 - x^6)}{3(1 - x^4)}
$$

If we set $X = X$, we get the following expression:

$$
E[Y | X = X] = E[Y | X] = \frac{2(1 - X^6)}{3(1 - X^4)}
$$

What does this mean? $E[Y|X]$ is itself a random variable that is a function of the random variable $X$. Let's call this function $h$:

$$
h(X) = \frac{2(1 - X^6)}{3(1 - X^4)}
$$

We now have to calculate $E[h(X)]$, which we can accomplish using the definition of LOTUS:

$$
E[h(X)] = \int_{\mathbb{R}} h(x)f_X(x)dx
$$

Let's substitute in for $h(x)$ and $h(X)$:

$$
E[E[Y|X]] = \int_{\mathbb{R}} E(Y|x)f_X(x)dx
$$

Remember the definition for $E[Y|X = x]$:

$$
E[Y|X = x] = \left\{\begin{matrix}
\sum_y y f(y|x) & \text{discrete} \\
\int_{\mathbb{R}} y f(y|x)dy & \text{continuous}
\end{matrix}\right.
$$

Thus:

$$
E[E[Y|X]] = \int_{\mathbb{R}} \left(\int_{\mathbb{R}} y f(y|x)dy\right)f_X(x)dx
$$

We can rearrange the right-hand side. Note that we can move $y$ outside of the first integral since it is a constant value when we integrate with respect to $dx$:

$$
E[E[Y|X]] = \int_{\mathbb{R}} \int_{\mathbb{R}} y f(y|x)f_X(x)dx dy = \int_{\mathbb{R}} y \int_{\mathbb{R}} f(y|x)f_X(x)dx dy
$$

Remember now the definition for the conditional pdf:

$$
f(y|x) = \frac{f(x,y)}{f_X(x)}; \quad f(y|x)f_X(x) = f(x, y)
$$

We can substitute in $f(x,y)$ for $f(y|x)f_X(x)$:

$$
E[E[Y|X]] = \int_{\mathbb{R}} y \int_{\mathbb{R}} f(x,y)dx dy
$$

Let's remember the definition for the marginal pdf of $Y$:

$$
f_Y(y) = \int_{\mathbb{R}} f(x,y)dx
$$

Let's substitute:

$$
E[E[Y|X]] = \int_{\mathbb{R}} y f_Y(y)dy
$$

Of course, the expected value of $Y$, $E[Y]$ equals:

$$
E[Y] = \int_{\mathbb{R}} y f_Y(y) dy
$$

Thus:

$$
E[E[Y|X]] = E[Y]
$$

### Example

Let's apply this theorem using our favorite joint pdf: $f(x,y) = 21x^2y / 4, x^2 \leq y \leq 1$. Through previous examples, we know $f_X(x)$, $f_Y(y)$ and $E[Y|x]$:

$$
f_X(x) = \frac{21}{8}x^2(1-x^4)
$$

$$
f_Y(y) = \frac{7}{2}y^{\frac{5}{2}}
$$

$$
E[Y|x] = \frac{2(1 - x^6)}{3(1 - x^4)}
$$

We are going to look at two ways to compute $E[Y]$. First, we can just use the definition of expected value and integrate the product $yF_Y(y)dy$ over the real line:

$$
E[Y] = \int_{\mathbb{R}} y f_Y(y)dy
$$

$$
E[Y] = \int_0^1 y  * \frac{7}{2}y^{\frac{5}{2}} dy
$$

$$
E[Y] = \int_0^1 \frac{7}{2}y^{\frac{7}{2}} dy
$$

$$
E[Y] = \frac{7}{2} \int_0^1 y^{\frac{7}{2}} dy
$$

$$
E[Y] = \frac{7}{2} \frac{2}{9}y^\frac{9}{2}\Big|_0^1 = \frac{7}{9} y^\frac{9}{2}\Big|_0^1 = \frac{7}{9}
$$

Now, let's calculate $E[Y]$ using the double expectation theorem we just learned:

$$
E[Y] = E[E(Y|X)] = \int_{\mathbb{R}} E(Y|x) f_X(x)dx
$$

$$
E[Y] = \int_{-1}^1 \frac{2(1 - x^6)}{3(1 - x^4)} \times \frac{21}{8}x^2(1-x^4) dx
$$

$$
E[Y] = \frac{42}{24}\int_{-1}^1 \frac{(1 - x^6)}{(1 - x^4)} \times x^2(1-x^4) dx
$$

$$
E[Y] = \frac{42}{24}\int_{-1}^1 x^2(1 - x^6) dx
$$

$$
E[Y] = \frac{42}{24}\int_{-1}^1 x^2 - x^8 dx
$$

$$
E[Y] = \frac{42}{24} \left(\frac{x^3}{3} - \frac{x^9}{9}\right) \Big|_{-1}^1
$$

$$
E[Y] = \frac{42}{24} \left(\frac{3x^3 - x^9}{9} \right) \Big|_{-1}^1
$$

$$
E[Y] = \frac{42}{24} \left(\frac{3 - 1 - (-3+1)}{9} \right) = \frac{42}{24} * \frac{4}{9} = \frac{7}{9}
$$

### Mean of the Geometric Distribution

In this application, we are going to see how we can use double expectation to calculate the mean of a geometric distribution.

Let $Y$ equal the number of coin flips before a head, $H$, appears, where $P(H) = p$. Thus, $Y$ is distributed as a geometric random variable parameterized by $p$: $Y \sim \text{Geom}(p)$. We know that the pmf of $Y$ is $f_Y(y) = P(Y = y) = (1-p)^{y-1}p, y = 1,2,...$. In other words, $P(Y = y)$ is the product of the probability of $y-1$ failures and the probability of one success.

Let's calculate the expected value of $Y$ using the summation equation we've used previously (take the result on faith):

$$
E[Y] = \sum_y y f_Y(y) = \sum_1^\infty y(1-p)^{y-1}p = \frac{1}{p}
$$

Now we are going to use double expectation and a _standard one-step conditioning argument_ to compute $E[Y]$. First, let's define $X = 1$ if the first flip is $H$ and $X = 0$ otherwise. Let's pretend that we have knowledge of the first flip. We don't really have this knowledge, but we do know that the first flip can either be heads or tails: $P(X = 1) = p, P(X = 0) = 1 - p$.

Let's remember the double expectation formula:

$$
E[Y] = E[E(Y|X)] = \sum_x E(Y|x)f_X(x)
$$

What are the $x$-values? $X$ can only equal $0$ or $1$, so:

$$
E[Y] = E(Y|X = 0)P(X = 0) + E(Y|X=1)P(X=1)
$$

Now, if $X= 0$, the first flip was tails, and I have to start counting all over again. The expected number of flips I have to make before I see heads is $E[Y]$. However, I have already flipped once, and I flipped tails: that's what $X = 0$ means. So, the expected number of flips I need, given that I already flipped tails is $1 + E[Y]$: $P(Y|X=0) = 1 + E[Y]$ What is $P(0)$? It's just $1 - p$. Thus:

$$
E[Y|X = 0]P(X = 0) = (1 + E[Y])(1 - p)
$$

Now, if $X = 1$, the first flip was heads. I won! Given that $X = 1$, the expected value of $Y$ is one. If I know that I flipped heads on the first try, the expected number of trials before I flip heads is that one trial: $P(Y|X=1) = 1$. What is $P(1)$? It's just $p$. Thus:

$$
E[Y|X = 1]P(X = 1) = (1)(p) = p
$$

Let's solve for $E[Y]$:

$$
E[Y] = (1 + E[Y])(1 - p) + p
$$

$$
E[Y] = 1 + E[Y] -p -pE[Y] + p
$$

$$
E[Y] = 1 + E[Y] - pE[Y]
$$

$$
pE[Y] = 1; \quad E[Y] = \frac{1}{p}
$$

### Computing Probabilities by Conditioning

Let $A$ be some event. We define the random variable $Y=1$ if $A$ occurs, and $Y = 0$ otherwise. We refer to $Y$ as an [indicator function](<[https://en.wikipedia.org/wiki/Indicator_function](https://en.wikipedia.org/wiki/Indicator_function)>) of $A$; that is, the value of $Y$ indicates the occurrence of $A$. The expected value of $Y$ is given by:

$$
E[Y] = \sum_y y f_Y(y)dy
$$

Let's enumerate the $y$-values:

$$
E[Y] = 0(P(Y = 0)) + 1(P(Y = 1)) = P(Y = 1)
$$

What is $P(Y = 1)$? Well, $Y = 1$ when $A$ occurs, so $P(Y = 1) = P(A) = E[Y]$. Indeed, the expected value of an indicator function is the probability of the corresponding event.

Similarly, for any random variable, $X$, we have:

$$
E[Y | X = x] = \sum_y y f_Y(y|x)
$$

If we enumerate the $y$-values, we have:

$$
\begin{alignedat}{1}
E[Y | X = x] & = 0(f_Y(Y = 0|X= x)) + 1(f_Y(Y = 1|X = x)) \\[2ex]
& = f_Y(Y = 1|X = x)
\end{alignedat}
$$

Since we know that $f(Y = 1) = P(A)$, then:

$$
E[Y = 1 | X = x] = P(A|X = 1)
$$

Let's look at an implication of the above result. By definition:

$$
P[A] = E[Y] = E[E(Y | X)]
$$

Using LOTUS:

$$
P[A] = \int_{\mathbb{R}} E[Y|X=x]dF_X(x)
$$

Since we saw that $E[Y|X=x] = P(A|X=x)$, then:

$$
P[A] = \int_{\mathbb{R}} P(A|X=x)dF_X(x)
$$

### Theorem

The result above implies that, if $X$ and $Y$ are independent, continuous random variables, then:

$$
P(Y < X) = \int_{\mathbb{R}} P(Y < x)f_X(x)dx
$$

To prove, let $A = \{Y < X\}$. Then:

$$
P[A] = \int_{\mathbb{R}} P(A|X=x)dF_X(x)
$$

Substitute $A = \{Y < X\}$:

$$
P[A] = \int_{\mathbb{R}} P(Y < X|X=x)dF_X(x)
$$

What's $P(Y < X|X=x)$? In other words, for a given $X = x$, what's the probability that $Y < X$? That's a long way of saying $P(Y < x)$:

$$
P[A] = \int_{\mathbb{R}} P(Y < x)dF_X(x)
$$

$$
P[A] = P[Y < X] = \int_{\mathbb{R}} P(Y < x)f_X(x)dx, \quad F_x'(x) = f_X(x)dx
$$

### Example

Suppose we have two random variables, $X \sim \text{Exp}(\mu)$ and $Y \sim \text{Exp}(\lambda)$. Then:

$$
P(Y < X) = \int_{\mathbb{R}} P(Y < x)f_X(x)dx
$$

Note that $P(Y < x)$ is the cdf of $Y$ at $x$: $F_Y(x)$. Thus:

$$
P(Y < X) = \int_{\mathbb{R}} F_Y(x)f_X(x)dx
$$

Since $X$ and $Y$ are both exponentially distributed, we know that they have the following pdf and cdf, by definition:

$$
f(x; \lambda) = 	\lambda e^{-\lambda x}, x \geq 0
$$

$$
F(x; \lambda) = 	1 - e^{-\lambda x}, x \geq 0
$$

Let's substitute these values in, adjusting the limits of integration appropriately:

$$
P(Y < X) = \int_0^\infty 1 - e^{-\lambda x}(\mu e^{-\mu x})dx
$$

Let's rearrange:

$$
P(Y < X) = \mu \int_0^\infty e^{-\mu x}  - e^{-\lambda x - \mu x} dx
$$

$$
P(Y < X) = \mu \left[\int_0^\infty e^{-\mu x} dx - \int_0^\infty e^{-\lambda x - \mu x} dx\right]
$$

Let $u_1 = -\mu x$. Then $du_1 = -\mu dx$. Let $u_2 = -\lambda x - \mu x$. Then $du_2 = -(\lambda + \mu)dx$. Thus:

$$
P(Y < X) = \mu \left[-\int_0^\infty \frac{e^{u_1}}{\mu} du_1 + \int_0^\infty \frac{e^{u_2}}{\lambda + \mu} du_2\right]
$$

Now we can integrate:

$$
P(Y < X) = \mu \left[\int_0^\infty \frac{e^{u_2}}{\lambda + \mu} du_2 - \int_0^\infty \frac{e^{u_1} }{\mu}du_1 \right]
$$

$$
P(Y < X) = \mu \left[\frac{e^{u_2}}{\lambda + \mu} - \frac{e^{u_1}}{\mu} \right]_0^\infty
$$

$$
P(Y < X) = \mu \left[\frac{e^{-\lambda x - \mu x}}{\lambda + \mu} - \frac{e^{-\mu x}}{\mu} \right]_0^\infty
$$

$$
P(Y < X) = \mu \left[0 - \frac{1}{\lambda + \mu} + \frac{1}{\mu} \right]
$$

$$
P(Y < X) = \mu \left[\frac{1}{\mu} - \frac{1}{\lambda + \mu} \right]
$$

$$
P(Y < X) = \frac{\mu}{\mu} - \frac{\mu}{\lambda + \mu}
$$

$$
P(Y < X) = \frac{\lambda + \mu}{\lambda + \mu} - \frac{\mu}{\lambda + \mu} = \frac{\lambda}{\lambda + \mu}
$$

As it turns out, this result makes sense because $X$ and $Y$ correspond to arrivals from a [poisson process](<[https://en.wikipedia.org/wiki/Poisson_point_process](https://en.wikipedia.org/wiki/Poisson_point_process)>) and $\mu$ and $\lambda$ are the arrival rates. For example, suppose that $X$ corresponds to arrival times for women to a store, and $Y$ corresponds to arrival times for men. If women are coming in at a rate of three per hour - $\lambda = 3$ - and men are coming in at a rate of nine per hour - $\mu = 9$ - then the probability of a woman arriving before a man is going to be $3/4$.

### Variance Decomposition

Just as we can use double expectation for the expected value of $Y$, we can express the variance of $Y$, $\text{Var}(Y)$ in a similar fashion, which we refer to as **variance decomposition**:

$$
\text{Var}(Y) = E[\text{Var}(Y|X)] + \text{Var}[E(Y|X)]
$$

### Proof

Let's start with the first term: $E[\text{Var}(Y|X)]$. Remember the definition of variance, as the second central moment:

$$
\text{Var}(X) = E[X^2] - (E[X])^2
$$

Thus, we can express $E[\text{Var}(Y|X)]$ as:

$$
E[\text{Var}(Y|X)] = E[E[Y^2 | X] - (E[Y|X])^2]
$$

Note that, since expectation is linear:

$$
E[\text{Var}(Y|X)] = E[E[Y^2 | X]] - E[(E[Y|X])^2]
$$

Notice the first expression on the right-hand side. That's a double expectation, and we know how to simplify that:

$$
E[\text{Var}(Y|X)] = E[Y^2] - E[(E[Y|X])^2], \quad 1.
$$

Now let's look at the second term in the variance decomposition: $\text{Var}[E(Y|X)]$. Considering again the definition for variance above, we can transform this term:

$$
\text{Var}[E(Y|X)] = E[(E[Y | X)^2] - (E[E[Y|X]])^2
$$

In this equation, we again see a double expectation, quantity squared. So:

$$
\text{Var}[E(Y|X)] = E[(E[Y| X)^2] - E[Y]^2, \quad 2.
$$

Remember the equation for variance decomposition:

$$
\text{Var}(Y) = E[\text{Var}(Y|X)] + \text{Var}[E(Y|X)]
$$

Let's plug in $1$ and $2$ for the first and second term, respectively:

$$
\text{Var}(Y) =E[Y^2] - E[(E[Y|X])^2] + E[(E[Y | X)^2] - E[Y]^2
$$

Notice the cancellation of the two scary inner terms to reveal the definition for variance:

$$
\text{Var}(Y) = E[Y^2] - E[Y]^2 = \text{Var}(Y)
$$

## Covariance and Correlation

In this lesson, we are going to talk about independence, covariance, correlation, and some related results. Correlation shows up all over the place in simulation, from inputs to outputs to everywhere in between.

### LOTUS in 2D

Suppose that $h(X,Y)$ is some function of two random variables, $X$ and $Y$. Then, via LOTUS, we know how to calculate the expected value, $E[h(X,Y)]$:

$$
E[h(X,Y)] = \left\{\begin{matrix}
\sum_x \sum_y h(x,y)f(x,y) & \text{if (X,Y) is discrete} \\
\int_{\mathbb{R}} \int_{\mathbb{R}} h(x,y)f(x,y)dx dy & \text{if (X,Y) is continuous} \\
\end{matrix}\right.
$$

### Expected Value, Variance of Sum

Whether or not $X$ and $Y$ are independent, the sum of the expected values equals the expected value of the sum:

$$
E[X+Y] = E[X] + E[Y]
$$

If $X$ and $Y$ are independent, then the sum of the variances equals the variance of the sum:

$$
\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y)
$$

Note that we need the equations for LOTUS in two dimensions to prove both of these theorems.

> Aside: I tried to prove these theorems. It went terribly! Check out the proper proofs [here](<[http://www.milefoot.com/math/stat/rv-sums.htm](http://www.milefoot.com/math/stat/rv-sums.htm)>).

### Random Sample

Let's suppose we have a set of $n$ random variables: $X_1,...,X_n$. This set is said to form a **random sample** from the pmf/pdf $f(x)$ if all the variables are (i) independent and (ii) each $X_i$ has the same pdf/pmf $f(x)$.

We can use the following notation to refer to such a random sample:

$$
X_1,...,X_n \overset{\text{iid}}{\sim} f(x)
$$

Note that "iid" means "independent and identically distributed", which is what (i) and (ii) mean, respectively, in our definition above.

### Theorem

Given a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} f(x)$, the sample mean, $\bar{X_n}$ equals the following:

$$
\bar{X_n} \equiv \sum_{i =1}^n \frac{X_i}{n}
$$

Given the sample mean, the expected value of the sample mean is the expected value of any of the individual variables, and the variance of the sample mean is the variance of any of the individual variables divided by $n$:

$$
E[\bar{X_n}] =E[X_i]; \quad\text{Var}(\bar{X_n}) = \text{Var}(X_i) / n
$$

We can observe that as $n$ increases, $E[\bar{X_n}]$ is unaffected, but $\text{Var}(\bar{X_n})$ decreases.

### Covariance

Covariance is one of the most fundamental measures of non-independence between two random variables. The **covariance** between $X$ and $Y$, $\text{Cov}(X, Y)$ is defined as:

$$
\text{Cov}(X,Y) \equiv E[(X-E[X])(Y - E[Y])]
$$

The right-hand side of this equation looks daunting, so let's see if we can simplify it. We can first expand the product:

$$
\begin{alignedat}{1}
& E[(X-E[X])(Y - E[Y]) = \\
& E[XY - XE[Y] - YE[X] + E[Y]E[X]]
\end{alignedat}
$$

Since expectation is linear, we can rewrite the right-hand side as a difference of expected values:

$$
\begin{alignedat}{1}
& E[(X-E[X])(Y - E[Y]) = \\
& E[XY] - E[XE[Y]] - E[YE[X]] + E[E[Y]E[X]]
\end{alignedat}
$$

Note that both $E[X]$ and $E[Y]$ are just numbers: the expected values of the corresponding random variables. As a result, we can apply two principles here: $E[aX] = aE[X]$ and $E[a] = a$. Consider the following rearrangement:

$$
\begin{alignedat}{1}
& E[(X-E[X])(Y - E[Y]) = \\
& E[XY] - E[Y]E[X] - E[X]E[Y] + E[Y]E[X]
\end{alignedat}
$$

The last three terms are the same, they and sum to $-E[Y]E[X]$. Thus:

$$
\begin{alignedat}{1}
\text{Cov}(X,Y) & \equiv E[(X-E[X])(Y - E[Y])] \\[2ex]
& = E[XY] - E[Y]E[X]
\end{alignedat}
$$

This equation is much easier to work with; namely, $h(X,Y) = XY$ is a much simpler function than $h(X,Y) = (X-E[X])(Y - E[Y])$ when it comes time to apply LOTUS.

Let's understand what happens when we take the covariance of $X$ with itself:

$$
\begin{alignedat}{1}
\text{Cov}(X,X) & = E[X * X] - E[X]E[X] \\[2ex]
& = E[X^2] - (E[X])^2 \\[2ex]
& = \text{Var}(X)
\end{alignedat}
$$

### Theorem

If $X$ and $Y$ are independent random variables, then $\text{Cov}(X, Y) = 0$. On the other hand, a covariance of $0$ does **not** mean that $X$ and $Y$ are independent.

For example, consider two random variables, $X \sim \text{Unif}(-1,1)$ and $Y = X^2$. Since $Y$ is a function of $X$, the two random variables are dependent: if you know $X$, you know $Y$. However, take a look at the covariance:

$$
\text{Cov}(X, Y) = E[X^3] - E[X]E[X^2]
$$

What is $E[X]$? Well, we can integrate the pdf from $-1$ to $1$, or we can understand that the expected value of a uniform random variable is the average of the bounds of the distribution. That's a long way of saying that $E[X] =(-1 + 1) / 2 = 0$.

Now, what is $E[X^3]$? We can apply LOTUS:

$$
E[X^3] = \int_{-1}^1 x^3f(x)dx
$$

What is the pdf of a uniform random variable? By definition, it's one over the difference of the bounds:

$$
E[X^3] = \frac{1}{1 - - 1}\int_{-1}^1 x^3f(x)dx
$$

Let's integrate and evaluate:

$$
E[X^3] = \frac{1}{2} \frac{x^4}{4}\Big|_{-1}^1 = \frac{1^4}{8} - \frac{(-1)^4}{8} = 0
$$

Thus:

$$
\text{Cov}(X, Y) = E[X^3] - E[X]E[X^2] = 0
$$

Just because the covariance between $X$ and $Y$ is $0$ does not mean that they are independent!

### More Theorems

Suppose that we have two random variables, $X$ and $Y$, as well as two constants, $a$ and $b$. We have the following theorem:

$$
\text{Cov}(aX, bY) = ab\text{Cov}(X,Y)
$$

Whether or not $X$ and $Y$ are independent,

$$
\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y) + 2\text{Cov}(X, Y)
$$

$$
\text{Var}(X - Y) = \text{Var}(X) + \text{Var}(Y) - 2\text{Cov}(X, Y)
$$

Note that we looked at a theorem previously which gave an equation for the variance of $X + Y$ when both variables are independent: $\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y)$. That equation was a special case of the theorem above, where $\text{Cov}(X,Y) = 0$ as is the case between two independent random variables.

### Correlation

The **correlation** between $X$ and $Y$, $\rho$, is equal to:

$$
\rho \equiv \frac{\text{Cov}(X, Y)}{\sqrt{\text{Var}(X)\text{Var}(Y)}}
$$

Note that correlation is _standardized covariance_. In other words, for any $X$ and $Y$, $-1 \leq \rho \leq 1$.

If two variables are highly correlated, then $\rho$ will be close to $1$. If two variables are highly negatively correlated, then $\rho$ will be close to $-1$. Two variables with low correlation will have a $\rho$ close to $0$.

### Example

Consider the following joint pmf:

$$
\begin{array}{c|ccc|c}
f(x,y) & X = 2 & X = 3 & X = 4 & f_Y(y) \\ \hline
Y = 40 & 0.00 & 0.20 & 0.10 & 0.3 \\
Y = 50 & 0.15 & 0.10 & 0.05 & 0.3 \\
Y = 60 & 0.30 & 0.00 & 0.10 & 0.4 \\ \hline
f_X(x) & 0.45 & 0.30 & 0.25 & 1 \\
\end{array}
$$

For this pmf, $X$ can take values in $\{2, 3, 4\}$ and $Y$ can take values in $\{40, 50, 60\}$. Note the marginal pmfs along the table's right and bottom, and remember that all pmfs sum to one when calculated over all appropriate values.

What is the expected value of $X$? Let's use $f_X(x)$:

$$
E[X] = 2(0.45) + 3(0.3) + 4(0.25) = 2.8
$$

Now let's calculate the variance:

$$
\text{Var}(X) = E[X^2] - (E[X])^2
$$

$$
\text{Var}(X) = 4(0.45) + 9(0.3) + 16(0.25) - (2.8)^2 = 0.66
$$

What is the expected value of $Y$? Let's use $f_Y(y)$:

$$
E[Y] = 40(0.3) + 50(0.3) + 60(0.4) = 51
$$

Now let's calculate the variance:

$$
\text{Var}(Y) = E[Y^2] - (E[Y])^2
$$

$$
\text{Var}(X) = 1600(0.3) + 2500(0.3) + 3600(0.4) - (51)^2 = 69
$$

If we want to calculate the covariance of $X$ and $Y$, we need to know $E[XY]$, which we can calculate using two-dimensional LOTUS:

$$
E[XY] = \sum_x \sum_y xy f(x,y)
$$

$$
E[XY] = (2 * 40 * 0.00) + (2 * 50 * 0.15) + ... + (4 * 60 * 0.1) = 140
$$

With $E[XY]$ in hand, we can calculate the covariance of $X$ and $Y$:

$$
\text{Cov}(X,Y) = E[XY] - E[X]E[Y] = 140 - (2.8 * 51) = -2.8
$$

Finally, we can calculate the correlation:

$$
\rho = \frac{\text{Cov}(X, Y)}{\sqrt{\text{Var}(X)\text{Var}(Y)}}
$$

$$
\rho = \frac{-2.8}{\sqrt{0.66(69)}} \approx -0.415
$$

### Portfolio Example

Let's look at two different assets, $S_1$ and $S_2$, that we hold in our portfolio. The expected yearly returns of the assets are $E[S_1] = \mu_1$ and $E[S_2] = \mu_2$, and the variances are $\text{Var}(S_1) = \sigma_1^2$ and $\text{Var}(S_2) = \sigma_2^2$. The covariance between the assets is $\sigma_{12}$.

A portfolio is just a weighted combination of assets, and we can define our portfolio, $P$, as:

$$
P = wS_1 + (1 - w)S_2, \quad w \in [0,1]
$$

The portfolio's expected value is the sum of the expected values of the assets times their corresponding weights:

$$
E[P] = E[wS_1 + (1 - w)S_2]
$$

$$
E[P] = E[wS_1] + E[(1 - w)S_2]
$$

$$
E[P] = wE[S_1] + (1 - w)E[S_2]
$$

$$
E[P] = w\mu_1 + (1-w)\mu_2
$$

Let's calculate the variance of the portfolio:

$$
\text{Var}(P) = \text{Var}(wS_1 + (1-w)S_2)
$$

Remember how we express $\text{Var}(X + Y)$:

$$
\text{Var}(P) = \text{Var}(wS_1) + \text{Var}((1-w)S_2) + 2\text{Cov}(wS_1, (1-w)S_2)
$$

Remember that $\text{Var}(aX) = a^2\text{Var}(X)$ and $\text{Cov}(aX, bY) = ab\text{Cov}(X,Y)$. Thus:

$$
\text{Var}(P) = w^2\text{Var}(S_1) + (1-w)^2\text{Var}(S_2) + 2w(1-w)\text{Cov}(S_1, S_2)
$$

Finally, let's substitute in the appropriate variables:

$$
\text{Var}(P) = w^2\sigma^2_1 + (1-w)^2\sigma^2_2 + 2w(1-w)\sigma_{12}
$$

How might we optimize this portfolio? One thing we might want to optimize for is minimal variance: many people want their portfolios to have as little volatility as possible.

Let's recap. Given a function $f(x)$, how do we find the $x$ that minimizes $f(x)$? We can take the derivative, $f'(x)$, set it to $0$ and then solve for $x$. Let's apply this logic to $\text{Var}(P)$. First, we take the derivative with respect to $w$:

$$
\frac{d}{dw}\text{Var}(P) = 2w\sigma^2_1 - 2(1-w)\sigma^2_2 + 2\sigma_{12} - 4w\sigma_{12}
$$

$$
\frac{d}{dw}\text{Var}(P) = 2w\sigma^2_1 - 2\sigma^2_2 +2w\sigma^2_2 + 2\sigma_{12} - 4w\sigma_{12}
$$

Then, we set the derivative equal to $0$ and solve for $w$:

$$
0 = 2w\sigma^2_1 - 2\sigma^2_2 +2w\sigma^2_2 + 2\sigma_{12} - 4w\sigma_{12}
$$

$$
0 = w\sigma^2_1 - \sigma^2_2 +w\sigma^2_2 + \sigma_{12} - 2w\sigma_{12}
$$

$$
\sigma^2_2 - \sigma_{12} = w\sigma^2_1 +w\sigma^2_2 - 2w\sigma_{12}
$$

$$
\sigma^2_2 - \sigma_{12} = w(\sigma^2_1 +\sigma^2_2 - 2\sigma_{12})
$$

$$
\frac{\sigma^2_2 - \sigma_{12}}{\sigma^2_1 +\sigma^2_2 - 2\sigma_{12}} = w
$$

### Example

Suppose $E[S_1] = 0.2$, $E[S_2] = 0.1$, $\text{Var}(S_1) = 0.2$, $\text{Var}(S_2) = 0.4$, and $\text{Cov}(S_1, S_2) = -0.1$.

What value of $w$ maximizes the expected return of this portfolio? We don't even have to do any math: just allocate 100% of the portfolio to the asset with the higher expected return - $S_1$. Since we define our portfolio as $wS_1 + (1 - w)S_2$, the correct value for $w$ is $1$.

What value of $w$ minimizes the variance? Let's plug and chug:

$$
w = \frac{\sigma^2_2 - \sigma_{12}}{\sigma^2_1 +\sigma^2_2 - 2\sigma_{12}}
$$

$$
w = \frac{0.4 + 0.1}{0.2 + 0.4 + 0.2} = 0.5 / 0.8 = 0.625
$$

To minimize variance, we should hold a portfolio consisting of $5/8$ $S_1$ and $3/8$ $S_2$.

There are tradeoffs in any optimization. For example, optimizing for maximal expected return may introduce high levels of volatility into the portfolio. Conversely, optimizing for minimal variance may result in paltry returns.

## Probability Distributions

In this lesson, we are going to review several popular discrete and continuous distributions.

### Bernoulli (Discrete)

Suppose we have a random variable, $X \sim \text{Bernoulli}(p)$. $X$ has the following pmf:

$$
f(x) = \left\{\begin{matrix}
p & \text{if } x = 1 \\
1 - p (= q) & \text{if } x = 0
\end{matrix}\right.
$$

Additionally, $X$ has the following properties:

$$
E[X] = p
$$

$$
\text{Var}(X) = pq
$$

$$
M_X(t) = pe^t + q
$$

### Binomial (Discrete)

The Bernoulli distribution generalizes to the binomial distribution. Suppose we have $n$ iid Bernoulli random variables: $X_1,X_2,...,X_n \overset{\text{iid}}\sim \text{Bern}(p)$. Each $X_i$ takes on the value $1$ with probability $p$ and $0$ with probability $1-p$. If we take the sum of the successes, we have the following random variable, $Y$:

$$
Y = \sum_{i = 1}^n X_i \sim \text{Bin}(n,p)
$$

$Y$ has the following pmf:

$$
f(y) = \binom{n}{y}p^yq^{n-y}, \quad y = 0, 1,...,n.
$$

Notice the binomial coefficient in this equation. We read this as "n choose k", which is defined as:

$$
\binom{n}{y} = \frac{n!}{k!(n-k)!}
$$

What's going on here? First, what is the probability of $y$ successes? Well, completely, it's the probability of $y$ successes and $n-y$ failures: $p^yq^{n-y}$. Of course, the outcome of $y$ _consecutive_ successes followed by $n-y$ _consecutive_ failures is just one particular arrangement of many. How many? $n$ choose $k$. This is what the binomial coefficient expresses.

Additionally, $Y$ has the following properties:

$$
E[Y] = np
$$

$$
\text{Var}(Y) = npq
$$

$$
M_Y(t) = (pe^t + q)^n
$$

Note that the variance and the expected value are equal to $n$ times the variance and the expected value of the Bernoulli random variable. This relationship makes sense: a binomial random variable is the sum of $n$ Bernoulli's. The moment-generating function looks a little bit different. As it turns out, we multiply the moment-generating functions when we sum the random variables.

### Geometric (Discrete)

Suppose we have a random variable, $X \sim \text{Geometric}(p)$. A geometric random variable corresponds to the number of $\text{Bern}(p)$ trials until a success occurs. For example, three failures followed by a success ("FFFS") implies that $X = 4$. A geometric random variable has the following pmf:

$$
f(x) = q^{x-1}p, \quad x = 1,2,...
$$

We can see that this equation directly corresponds to the probability of $x - 1$ failures, each with probability $q$ followed by one success, with probability $p$.

Additionally, $X$ has the following properties:

$$
E[X] = \frac{1}{p}
$$

$$
\text{Var}(X) = \frac{q}{p^2}
$$

$$
M_X(t) = \frac{pe^t}{1-qe^t}
$$

### Negative Binomial (Discrete)

The geometric distribution generalizes to the negative binomial distribution. Suppose that we are interested in the number of trials it takes to see $r$ successes. We can add $r$ iid $\text{Geom}(p)$ random variables to get the random variable $Y \sim \text{NegBin}(r, p)$. For example, if $r = 3$, then a run of "FFFSSFS" implies that $Y \sim \text{NegBin}(3, p) = 7$. $Y$ has the following pmf:

$$
f(y) = \binom{y-1}{r-1}q^{y-r}p^{r}, \quad y = r, r + 1,...
$$

Additionally, $Y$ has the following properties:

$$
E[Y] = \frac{r}{p}
$$

$$
\text{Var}(Y) = \frac{qr}{p^2}
$$

Note that the variance and the expected value are equal to $r$ times the variance and the expected value of the geometric random variable. This relationship makes sense: a negative binomial random variable is the sum of $r$ geometric random variables.

### Poisson (Discrete)

A **counting process**, $N(t)$ keeps track of the number of "arrivals" observed between time $0$ and time $t$. For example, if $7$ people show up to a store by time $t=3$, then $N(3) = 7$. A **Poisson process** is a counting process that satisfies the following criteria.

1. Arrivals must occur one-at-a-time at a rate, $\lambda$. For example, $\lambda = 4 / \text{hr}$ means that, on average, arrivals occur every fifteen minutes, yet no two arrivals coincide.

2. Disjoint time increments are independent. Suppose we are looking at arrivals on the intervals 12 am - 2 am and 5 am - 10 am. Independent increments means that the arrivals in the first interval don't impact arrivals in the second.

3. Increments are stationary; in other words, the distribution of the number of arrivals in the interval $[s, s + t]$ depends only on the interval's length, $t$. It does not depend on where the interval starts, $s$.

A random variable $X \sim \text{Pois}(\lambda)$ describes the number of arrivals that a Poisson process experiences in one time unit, i.e., $N(1)$. $X$ has the following pmf:

$$
f(x) = \frac{e^{-\lambda}\lambda^x}{x!}, \quad x = 0,1,...
$$

Additionally, $X$ has the following properties:

$$
E[X] = \text{Var}(X) = \lambda
$$

$$
M_X(t) = e^{\lambda(e^t - 1)}
$$

### Uniform (Continuous)

A uniform random variable, $X \sim \text{Uniform}(a,b)$, has the following pdf:

$$
f(x) = \frac{1}{b - a}, \quad a \leq x \leq b
$$

Additionally, $X$ has the following properties:

$$
E[X] = \frac{a + b}{2}
$$

$$
\text{Var}(X) = \frac{(b-a)^2}{12}
$$

$$
M_X(t) = \frac{e^{tb} - e^{ta}}{tb - ta}
$$

### Exponential (Continuous)

A continuous, exponential random variable $X \sim \text{Exponential}(\lambda)$ has the following pdf:

$$
f(x) = \lambda e^{-\lambda x}, \quad x \geq 0
$$

Additionally, $X$ has the following properties:

$$
E[X] = \frac{1}{\lambda}
$$

$$
\text{Var}(X) = \frac{1}{\lambda^2}
$$

$$
M_X(t) = \frac{\lambda}{\lambda - t}, \quad t < \lambda
$$

The exponential distribution also has a _memoryless property_, which means that for $s, t > 0$, $P(X > s + t | X > s) = P(X > t)$. For example, if we have a light bulb, and we know that it has lived for $s$ time units, the conditional probability that it will live for $s + t$ time units (an additional $t$ units), is the unconditional probability that it will live for $t$ time units. Analogously, there is no "memory" of the prior $s$ time units.

Let's look at a concrete example. If $X \sim \text{Exp}(1/100)$, then:

$$
P(X > 200 | X > 50) = P(X > 150) = e^{\lambda t} = e^{-150/100}
$$

### Gamma (Continuous)

Recall the gamma function, $\Gamma(\alpha)$:

$$
\Gamma(\alpha) \equiv \int_0^\infty t^{a-1}e^{-t}dt
$$

A gamma random variable, $X \sim \text{Gamma}(\alpha, \lambda)$, has the following pdf:

$$
f(x) = \frac{\lambda^\alpha x^{\alpha - 1} e^{-\lambda x}}{\Gamma(\alpha)}, \quad x \geq 0
$$

Additionally, $X$ has the following properties:

$$
E[X] = \frac{\alpha}{\lambda}
$$

$$
\text{Var}(X) = \frac{\alpha}{\lambda^2}
$$

$$
M_X(t) = \left[\lambda /(\lambda - t)\right]^\alpha, \quad t < \lambda
$$

Note what happens when $\alpha = 1$: the gamma random variable reduces to an exponential random variable. Another way to say this is that the gamma distribution generalizes the exponential distribution.

If $X_1, X_2,...,X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)$, then we can express a new random variable, $Y$:

$$
Y \equiv \sum_{i=1}^n X_i \sim \text{Gamma}(n, \lambda)
$$

The $\text{Gamma}(n,\lambda)$ distribution is also called the $\text{Erlang}_n(\lambda)$ distribution, and has the following cdf:

$$
F_Y(y) = 1- e^{-\lambda y}\sum_{j=0}^{n-1}\frac{(\lambda y)^j}{j!}, \quad y \geq0
$$

### Triangular (Continuous)

Suppose that we have a random variable, $X \sim \text{Triangular}(a,b,c)$. The triangular distribution is parameterized by three fields - the smallest possible observation, $a$, the "most likely" observation, $b$, and the largest possible observation, $c$ - and is useful for models with limited data. $X$ has the following pdf:

$$
f(x) = \left\{\begin{matrix}
\frac{2(x-a)}{(b-a)(c-a)} & \text{if } a < x \leq b \\
\frac{2(c - x)}{(c-b)(c-a)} & \text{if } b < x \leq c \\
0 & \text{otherwise}
\end{matrix}\right.
$$

Additionally, $X$ has the following property:

$$
E[X] = \frac{a + b + c}{3}
$$

### Beta (Continuous)

Suppose we have a random variable, $X \sim \text{Beta}(a,b)$. $X$ has the following pdf:

$$
f(x) = \frac{\Gamma(a+b)}{\Gamma(a) + \Gamma(b)}x^{a-1}(1-x)^{b-1}, \quad 0 \leq x \leq 1, a, b> 0
$$

Additionally, $X$ has the following properties:

$$
E[X] = \frac{a}{a+b}
$$

$$
\text{Var}(X) = \frac{ab}{(a+b)^2(a+b+1)}
$$

### Normal (Continuous)

Suppose we have a random variable, $X \sim \text{Normal}(\mu, \sigma^2)$. $X$ has the following pdf, which, when graphed, produces the famous bell curve:

$$
f(x) = \frac{1}{\sqrt{2\pi\sigma^2}}\exp\left[\frac{-(x - \mu)^2}{2\sigma^2}\right], \quad x \in \mathbb{R}, \quad \text{ where } \exp(x) = e^x
$$

Additionally, $X$ has the following properties:

$$
\begin{alignedat}{1}
E[X] &= \mu \\[2ex]
\text{Var}(X) &= \sigma^2 \\[2ex]
M_X(t) &= \exp\left(\mu t + \frac{1}{2}\sigma^2t^2\right)
\end{alignedat}
$$

### Theorem

If $X \sim \text{Nor}(\mu, \sigma^2)$, then a linear function of $X$ is also normal: $aX + b \sim \text{Nor}\left(a\mu + b, a^2 \sigma^2\right)$. Interestingly, if we set $a = 1 / \sigma$ and $b = -\mu / \sigma$, then $Z = aX + b$ is:

$$
Z \equiv \frac{X - \mu}{\sigma} \sim \text{Nor}(0, 1)
$$

$Z$ is drawn from the **standard normal distribution**, which has the following pdf:

$$
\phi(z) \equiv \frac{1}{\sqrt{2\pi}}e^{-z^2 / 2}
$$

This distribution also has the cdf $\Phi(z)$, which is [tabled](https://www.math.arizona.edu/~rsims/ma464/standardnormaltable.pdf). For example, $\Phi(1.96) \doteq 0.975$.

### Theorem

If $X_1$ and $X_2$ are _independent_ with $X_i \sim \text{Nor}(\mu_i,\sigma_i^2), i = 1,2$, then $X_1 + X_2 \sim \text{Nor}(\mu_1 + \mu_2, \sigma_1^2 + \sigma_2^2)$.

For example, suppose that we have two random variables, $X \sim \text{Nor}(3,4)$ and $Y \sim \text{Nor}(4,6)$ and $X$ and $Y$ are independent. How is $Z = 2X - 3Y + 1$ distributed? Let's first start with $2X$:

$$
2X ~ \sim (\text{Nor}(2 * 3, 2 * 2 * 4) \equiv \text{Nor}(6, 16)
$$

Now, let's find the distribution of $-3Y + 1$:

$$
-3Y + 1 \sim (\text{Nor}(-3 * 4 + 1, -3 * -3 * 6) \equiv \text{Nor}(-11, 54)
$$

Finally, we combine the two distributions linearly:

$$
2X - 3Y + 1 \sim (\text{Nor}(6 - 11, 54 + 16) \equiv \text{Nor}(-5, 70))
$$

Let's look at the corollary of a previous theorem. If $X_1, ..., X_n$ are iid $\text{Nor}(\mu, \sigma^2)$, then the sample mean $\bar{X}_n \sim \text{Nor}(\mu, \sigma^2 / n)$. While the sample mean has the same mean as the distribution from which the observations were sampled, its variance has decreased by a factor of $n$. As we get more information, the sample mean becomes less variable. This observation is a special case of the [law of large numbers](https://en.wikipedia.org/wiki/Law_of_large_numbers), which states that $\bar{X}_n$ approximates $\mu$ as $n$ becomes large.

## Limit Theorems

In this lesson, we are going to see what happens when we sample a large number of iid random variables. As we will see, normality happens, and, in particular, we will be looking at the central limit theorem.

### Corollary (of a previous theorem)

If $X_1,..., X_n$ are iid $\text{Nor}(\mu, \sigma^2)$, then the sample mean, $\bar{X}_n$, is distributed as $\text{Nor}(\mu, \sigma^2 / n)$. In other words:

$$
\bar{X}_n \equiv \frac{1}{n}\sum_{i =1}\left[X_i \sim \text{Nor}(\mu, \sigma^2) \right] \sim \text{Nor}(\mu, \sigma^2 / n)
$$

Notice that $\bar{X}$ has the same mean as the distribution from which the observations were sampled, but the variance decreases as a factor of the number of samples, $n$. Said another way, the variability of $\bar{X}$ decreases as $n$ increases, driving $\bar{X}$ toward $\mu$.

As we said before, this observation is a special case of the _law of large numbers_, which states that $\bar{X}$ approximates $\mu$ as $n$ becomes large.

### Definition

Suppose we have a sequence of random variables, $Y_1, Y_2,...$, with respective cdf's, $F_{Y_1}(y), F_{Y_2}(y),....$ This series of random variables **converges in distribution** to the random variable $Y$ having cdf $F_Y(y)$ if $\lim_{n \to \infty}F_{Y_n}(y) = F_Y(y)$ for all $y$. We express this idea of converging in distribution with the following notation:

$$
Y_n \overset{d}{\to} Y
$$

How do we use this? Well, if $Y_n \overset{d}{\to} Y$, and $n$ is large, then we can approximate the distribution of $Y_n$ by the limit distribution of $Y$.

### Central Limit Theorem

Suppose $X_1, X_2,...,X_n$ are iid random variables sampled from some distribution with pdf/pmf $f(x)$ having mean $\mu$ and variance $\sigma^2$. Let's define a random variable $Z_n$:

$$
Z_n \equiv \frac{\sum_{i=1}^n X_i - n\mu}{\sqrt{n}\sigma}
$$

We can simplify this expression. Let's first split the sum:

$$
Z_n \equiv \frac{\sum_{i=1}^n X_i}{\sqrt{n}\sigma} - \frac{n\mu}{\sqrt{n}\sigma}s
$$

Let's work on the first term:

$$
\begin{aligned}
\frac{\sum_{i=1}^n X_i}{\sqrt{n}\sigma} = \frac{\sqrt{n}\sum_{i=1}^n X_i}{n\sigma} \\[2ex]
\end{aligned}
$$

Note that the sum the random variables divided by $n$ equals $\bar{X_n}$:

$$
\begin{aligned}
\frac{\sqrt{n}\sum_{i=1}^n X_i}{n\sigma}= \frac{\sqrt{n}\bar{X_n}}{\sigma}
\end{aligned}
$$

Now, let's work on the second term, dividing $n$ by $\sqrt{n}$:

$$
\begin{aligned}
\frac{\mu n}{\sqrt{n}\sigma} = \frac{\sqrt{n}\mu}{\sigma}
\end{aligned}
$$

Let's combine the two terms:

$$
\begin{aligned}
Z_n \equiv \frac{\sum_{i=1}^n X_i - n\mu}{\sqrt{n}\sigma} = \frac{\sqrt{n}\bar{X_n}}{\sigma} -  \frac{\sqrt{n}\mu}{\sigma}  \\[2ex]
= \frac{\sqrt{n}(\bar{X_n} - \mu)}{\sigma}
\end{aligned}
$$

The expression above converges in distribution to a $\text{Nor}(0, 1)$ distribution:

$$
Z_n \equiv \frac{\sqrt{n}(\bar{X_n} - \mu)}{\sigma} \overset{d}{\to} \text{Nor}(0, 1).
$$

Thus, the cdf of $Z_n$ approaches $\phi(z)$ as $n$ increases.

The central limit theorem works well if the pdf/pmf is fairly symmetric and the number of samples, $n$, is greater than fifteen.

### Example

Suppose that we have $100$ observations, $X_1, X_2,...,X_{100} \overset{\text{iid}}{\sim} \text{Exp}(1)$. Note that, with $\lambda = 1$, $\mu = \sigma^2 = 1$. What is the probability that the sum of all $100$ random variables falls between $90$ and $100$:

$$
P\left(90 \leq \sum_{i =1}^{100} X_i \leq 110 \right) = \quad ?
$$

We can use the central limit theorem to approximate this probability. Let's apply $f(x) = (x - n\mu) / \sqrt{n}\sigma$ to the inequality, converting the sum of our observations to $Z_{100}$:

$$
P\left(90 \leq \sum_{i =1}^{100} X_i \leq 110 \right) = P\left(\frac{90-100}{\sqrt{100}} \leq Z_{100} \leq \frac{110 - 100}{\sqrt{100}} \right)
$$

Since $Z_n \overset{d}{\to} \text{Nor}(0,1)$, we can approximate that $Z_{100} \sim \text{Nor}(0,1)$:

$$
P\left(\frac{90-100}{\sqrt{100}} \leq Z_{100} \leq \frac{110 - 100}{\sqrt{100}} \right) \approx P(-1 \leq Z_{100} \sim \text{Nor}(0,1) \leq 1)
$$

This final expression is asking for the probability that a $\text{Nor}(0,1)$ random variable falls between $-1$ and $1$. The standard normal distribution has a standard deviation of $1$, and we know that the probability of falling within one standard deviation of the mean is $0.6827 \approx 68\%$.

Now, remember that the sum of exponential random variables is itself an erlang random variable:

$$
\sum_{i = 1}^{100} X_i \sim \text{Erlang}_{k=100}(\lambda)
$$

Erlang random variables have cdf's, which we can use - directly or through software such as [Minitab](minitab.com/en-us/) - to obtain the _exact_ value of the probability above:

$$
P\left(90 \leq \sum_{i =1}^{100} X_i \leq 110 \right) = 0.6835
$$

Not bad.

### Exercises

![](https://assets.omscs.io/notes/2020-09-04-16-16-36.png)

## Introduction to Estimation (OPTIONAL)

In this lesson, we are going to start our review of basic statistics. In particular, we are going to talk about unbiased estimation and mean squared error.

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
& = \frac{1}{n-1} \left(E[X_1^2] - E[\bar{X}^2]\right)
\end{alignedat}
$$

We know that $\text{Var}(X) = E[X^2] - (E[X])^2$, so $E[X^2] = \text{Var}(X) + (E[X])^2$. Therefore:

$$
\begin{alignedat}{1}
E[S^2] & = \frac{1}{n-1} \left(\text{Var}(X_1) + (E[X_1]^2) - \text{Var}(\bar{X}) - (E[\bar{X}]^2)\right)
\end{alignedat}
$$

Remember that $E[X_1] = E[\bar{X}]$, so: 

$$
\begin{alignedat}{1}
E[S^2] & = \frac{1}{n-1} \left(\text{Var}(X_1) - \text{Var}(\bar{X}) \right) \\[3ex]
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

## Maximum Likelihood Estimation (OPTIONAL)

In this lesson, we are going to talk about maximum likelihood estimation, which is perhaps the most important point estimation method. It's a very flexible technique that many software packages use to help estimate parameters from various distributions.

### Likelihood Function and Maximum Likelihood Estimator

Consider an iid random sample, $X_1,...,X_n$, where each $X_i$ has pdf/pmf $f(x)$. Additionally, suppose that $\theta$ is some unknown parameter from $X_i$ that we would like to estimate. We can define a **likelihood function**, $L(\theta)$ as:

$$
L(\theta) \equiv \prod_{i=1}^n f(x_i)
$$

The **maximum likelihood estimator** (MLE) of $\theta$ is the value of $\theta$ that maximizes $L(\theta)$. The MLE is a function of the $X_i$'s and is itself a random variable.

### Example

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

Conventionally, we put a "hat" over the $\lambda$ that maximizes the likelihood function to indicate that it is the MLE. Such notation looks like this: $\hat{\lambda}$.

Note that we went from "little x's", $x_i$, to "big x", $\bar{X}$, in the equation. We do this to indicate that $\hat{\lambda}$ is a random variable.

Just to be careful, we probably should have performed a second-derivative test on the function, $\ln(L(\lambda))$, to ensure that we found a maximum likelihood estimator and not a minimum likelihood estimator.

### Invariance Property of MLE's
If $\hat{\theta}$ is the MLE of some parameter, $\theta$, and $h(\cdot)$ is a 1:1 function, then $h(\hat{\theta})$ is the MLE of $h(\theta)$.

For example, suppose we have a random sample, $X_1,...,X_n \overset{\text{iid}}{\sim} \text{Exp}(\lambda)$. The **survival function**, $\bar{F}(x)$, is:

$$
\bar{F}(x) = P(X > x) = 1 - F(x) = 1 - (1 - e^{-\lambda x}) = e^{-\lambda x}
$$

In addition, we saw that the MLE for $\lambda$ is $\hat{\lambda} = 1 / \bar{X}$. Therefore, using the invariance property, we can see that the MLE for $\bar{F}(x)$ is $\bar{F}(\hat{\lambda})$:

$$
\hat{\bar{F}}(x) = e^{-\hat{\lambda}x} = e^{-x / \bar{X}}
$$

## Confidence Intervals (OPTIONAL)

In this lesson, we are going to expand on the idea of point estimators for parameters and look at confidence intervals. We will use confidence intervals through this course, especially when we look at output analysis.

### Important Distributions

Suppose we have a random sample, $Z_1, Z_2,...,Z_k$, that is iid $\text{Nor}(0,1)$. Then, $Y = \sum_{i=1}^k Z_i^2$ has the $\chi^2$ distribution with $k$ [degrees of freedom](https://en.wikipedia.org/wiki/Degrees_of_freedom_(statistics)). We can express $Y$ as $Y \sim \chi^2(k)$, and $Y$ has an expected value of $k$ and a variance of $2k$.

If $Z \sim \text{Nor}(0,1), Y \sim \chi^2{k}$, and $Z$ and $Y$ are independent, then $T = Z / \sqrt{Y /k}$ has the [Student's t distribution](https://en.wikipedia.org/wiki/Student%27s_t-distribution) with $k$ degrees of freedom. We can express $T$ as $T \sim t(k)$. Note that $t(1)$ is the [Cauchy distribution](https://en.wikipedia.org/wiki/Cauchy_distribution).

If $Y_1 \sim \chi^2(m), Y_2 \sim \chi^2(n)$, and $Y_1$ and $Y_2$ are independent, then $F = (Y_1 /m)/(Y_2/n)$ has the [F distribution](https://en.wikipedia.org/wiki/F-distribution) with $m$ and $n$ degrees of freedom. Notation: $F \sim F(m,n)$.

We can use these distributions to construct confidence intervals for $\mu$ and $\sigma^2$ under a variety of assumptions.

### Confidence Interval

A $100(1-\alpha)\%$ two-sided **confidence interval** for an unknown parameter, $\theta$, is a random interval, $[L, U]$, such that $P(L \leq \theta \leq U) = 1 - \alpha$.

Here is an example of a confidence interval. We might say that we believe that the proportion of people voting for some candidate is between 47% and 51%, and we believe that statement to be true with probability 0.95.

### Common Confidence Intervals

Suppose that we know the variance of a distribution, $\sigma^2$. Then a $100(1-\alpha)\%$ confidence interval for $\mu$ is:

$$
\bar{X}_n - z_{\alpha/2}\sqrt{\frac{\sigma^2}{n}} \leq \mu \leq \bar{X}_n + z_{\alpha/2}\sqrt{\frac{\sigma^2}{n}}
$$

Notice the structure of the inequality here: $\bar{X}_n - H \leq \mu \leq \bar{X}_n + H$. The expression $H$, known as the *half-length*, is almost always a product of a constant and the square root of $S^2 /n$. In this rare case, since we know $\sigma^2$, we can use it directly.

What is $z$? $z_\gamma$ is the $1 - \gamma$ quantile of the standard normal distribution, which we can look up:

$$
z_\gamma \equiv \Phi^{-1}(1-\gamma)
$$

Let's look at another example. If $\sigma^2$ is unknown, then a $100(1-\alpha)\%$ confidence interval for $\mu$ is:

$$
\bar{X}_n - t_{\alpha/2,n-1}\sqrt{\frac{S^2}{n}} \leq \mu \leq \bar{X}_n + t_{\alpha/2,n-1}\sqrt{\frac{S^2}{n}}
$$

This example looks very similar to the previous example except that we are using $S^2$ (because we don't know $\sigma^2$), and we are using a $t$ quantile instead of a normal quantile. Note that $t_{\gamma, \nu}$ is the $1 - \gamma$ quantile of the $t(\nu)$ distribution.

Finally, let's look at the $100(1-\alpha)\%$ confidence interval for $\sigma^2$:

$$
\frac{(n-1)S^2}{\chi^2_{\frac{\alpha}{2}, n-1}} \leq \sigma^2 \leq \frac{(n-1)S^2}{\chi^2_{1- \frac{\alpha}{2}, n-1}}
$$

Note that $\chi^2_{\gamma, \nu}$ is the $1 - \gamma$ quantile of the $\chi^2(\nu)$ distribution.

### Example
We are going to look at a sample of 20 residual flame times, in seconds, of treated specimens of children's nightwear, where a residual flame time measures how long it takes for something to burst into flames.  Don't worry; there were no children in the nightwear during this experiment.

Here's the data:

$$
\begin{array}{ccccc}
9.85 & 9.93 &9.75 & 9.77  &9.67 \\
9.87 & 9.67 &9.94 & 9.85  &9.75 \\
9.83 & 9.92 &9.74 & 9.99  &9.88 \\
9.95 & 9.95 &9.93 & 9.92  &9.89 \\
\end{array}
$$

Let's compute a $95\%$ confidence interval for the mean residual flame time. After performing the necessary algebra, we can calculate the following statistics:

$$
\bar{X} = 9.8475, \quad S = 0.0954
$$

Remember the equation for computing confidence intervals for $\mu$ when $\sigma^2$ is unknown:

$$
\bar{X}_n - t_{\alpha/2,n-1}\sqrt{\frac{S^2}{n}} \leq \mu \leq \bar{X}_n + t_{\alpha/2,n-1}\sqrt{\frac{S^2}{n}}
$$

Since we are constructing a $95\%$ confidence interval, $\alpha = 0.05$ Additionally, since we have 20 samples,  $n = 20$. Let's plug in:

$$
9.8475 - t_{0.025,19}\sqrt{\frac{0.0954^2}{20}} \leq \mu \leq 9.8475 + t_{0.025, 19}\sqrt{\frac{0.0954^2}{20}}
$$

Now, we need to look up the $1-\gamma = 1 - 0.025 = 0.975$ quantile for the $t(19)$ distribution. I found this [table](http://dept.stat.lsa.umich.edu/~kshedden/Courses/Stat401/Notes/t-quantiles.pdf), which gives $t_{0.025,19} = 2.093$. Thus:

$$
9.8475 - \frac{(2.093)0.0954)}{\sqrt{20}} \leq \mu \leq 9.8475 + \frac{(2.093)0.0954)}{\sqrt{20}}
$$

After the final arithmetic, we see that the confidence interval is:

$$
9.8029 \leq \mu \leq 9.8921
$$

We would say that we are 95% confident that the true mean, $\mu$, (of the underlying distribution from which our $20$ observations were sampled) is between $9.8029$ and $9.8921$.

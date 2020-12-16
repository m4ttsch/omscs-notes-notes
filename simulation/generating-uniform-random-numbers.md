---
id: simulation-generating-uniform-random-numbers
title: Generating Uniform Random Numbers
course: simulation
lecture: generating-uniform-random-numbers
---

# Generating Uniform Random Numbers


## Introduction

Uniform(0,1) random numbers are the key to all random variate generation and simulation. As we have discussed previously, we transform uniforms to get other random variables - exponential, normal, and so on.

The goal is to produce an algorithm that can generate a sequence of pseudo-random numbers (PRNs) $R_1, R_2, ...$ that "appear" to be i.i.d Uniform(0,1). Of course, these numbers are not truly uniform because they are neither independent of one another, nor are they random. However, they will appear random to humans, and they will have all the statistical properties of i.i.d Uniform(0,1) random numbers, so we are allowed to use them.

Such an algorithm has a few desired properties. As we said, we need to produce output that appears to be i.i.d Unif(0,1). We also need the algorithm to execute quickly because we might want to generate billions of PRNs. Moreover, we need the algorithm to be able to reproduce any sequence it generates. This property allows us to replicate experiments and simulation runs that rely on streams of random numbers.

In the next few lessons, we will look at different classes of Unif(0,1) generators. We'll start with some lousy generators, such as

- the output of a random device
- a table of random numbers
- the mid-square method
- the Fibonacci method

We will then move on to the more common methods used in practice: the linear congruential generators and the Tausworthe generator. Finally, we'll talk about hybrid models, which most people use today.

## Some Lousy Generators

In this lesson, we will spend some time talking about poor generators. Obviously, we won't use these generators in practice, but we can study them briefly both for a historical perspective and to understand why they are so bad.

### Random Devices

We'll start our discussion by looking at random devices. A coin toss is a random device that can help us generate values of zero or one randomly. Similarly, we can roll a die to generate a random number between one and six. More sophisticated random devices include Geiger counters and atomic clocks.

Naturally, random devices have strong randomness properties; however, we cannot reproduce their results easily. For example, suppose we ran an experiment based off of one billion die rolls. We'd have to store the results of those rolls somewhere if we ever wanted to replicate the experiment. This storage requirement makes random devices unwieldy in practice.

### Random Number Tables

We can also use random number tables. These tables are relatively ubiquitous, although they have fallen out of use since the 1950s. [This table](https://www.rand.org/pubs/monograph_reports/MR1418/MR1418.digits.pdf), published by the RAND corporation, contains one million random digits and one hundred thousand normal random variates. Basically, folks used a random device to generate random numbers, and then they wrote them down in a book.

How do we use this book? Well, we can simply flip to a random page, put our finger down in the middle of the page, and start reading off the digits.

While this approach has strong reproducibility and randomness properties, it hasn't scaled to meet today's needs. More specifically, a finite sequence of one million random numbers is just not sufficient for most applications. We can consume a billion random numbers in seconds on modern hardware. Additionally, once the digits were tabled, they were no longer random.

### Mid-Square Method

The mid-square method was created by the famous mathematician John von Neumann. The main idea here is we take an integer, square it, and then use the middle part of that integer as our next random integer, repeating the process as many times as we need. To generate the Uniform(0,1) random variable, we would divide each generated integer by the appropriate power of ten.

Let's look at an example. Suppose we have the seed $X_0 = 6632$. If we square $X_0$, we get $6632^2 = 43983424$, and we set $X_1$ equal to the middle four digits: $X_1 = 9834$. We can generate $X_2$ in a similar fashion: $X_1^2 = 9834^2 = 96707556$, so $X_2 = 7075$. Now, since we are taking the middle four integers, we generate the corresponding Uniform(0,1) random variate, $R_i$, by dividing $X_i$ by $10000$. For example, $R_1 = X_1 / 10000 = 9834 / 10000 = 0.9834$, and $R_2 = 0.7075$ by similar arithmetic.

Unfortunately, it turns out that there is a positive serial correlation in the $R_i$'s. For example, a very small $X_{i+1}$ often follows a very small $X_i$, more so than we would expect by random chance. More tragically, the sequence occasionally degenerates. For example, if $X_i = 0003$, then the sequence ends up producing only zeros after a certain point.

### Fibonacci and Additive Congruential Generators

The Fibonacci and additive congruential generators, not to be confused with the linear congruential generators, are also no good.

Here is the expression for the Fibonacci generator, which got its name got its name from the famed sequence that involves adding the previous two numbers to get the current number.

$$
\begin{alignedat}{1}
X_i &= (X_{i-1} + X_{i-2})\bmod m, \quad i = 1,2,... \\
R_i &= X_i / m
\end{alignedat}
$$

For this sequence, $X_{-1}$ and $X_0$ are seeds, and $m$ is the modulus. Remember that $a = b \bmod m$ if and only if $a$ is the remainder of $b/m$. For example, $6 = 13 \bmod 7$.

Like the mid-square method, this generator has a problem where small numbers frequently follow small numbers. Worse, it turns out the one-third of the values for each subsequent uniform are impossible to calculate. Particularly, it is impossible to compute an $X_{i+1}$, such that $X_{i-1} < X_{i+1} < X_i$, or $X_i < X_{i+1} < X_{i-1}$. Those two configurations should occur one-third of the time, which means that this generator does not have strong randomness properties.

## Linear Congruential Generator

In this lesson, we will ditch the lousy pseudo-random number generators and turn to a much better alternative: the **linear congruential generator** (LCG). Variations of LCGs are the most commonly used generators today in practice.

### LCGs

Here is the general form for an LCG. Given a modulus, $m$, and the constants $a$ and $c$, we generate a pseudo-random integer, $X_i$, and its corresponding Uniform(0,1) counterpart, $R_i$, using the following equations:

$$
\begin{alignedat}{1}
X_i &= (aX_{i-1}+c) \bmod m, \text{where } X_0 \text{ is the seed.} \\
R_i &= X_i / m, \quad i = 1,2,...
\end{alignedat}
$$

We choose $a$, $c$, and $m$ carefully to ensure both that the $R_i$'s appear to be i.i.d uniforms and that the generator has long periods or **cycle lengths**: the amount of time until the LCG starts to repeat.

**Multiplicative generators** are LCGs where $c=0$.

### Trivial Example

Let's look at an example. Consider the following LCG:

$$
X_i = (5X_{i-1} + 3) \bmod 8
$$

Starting with the seed, $X_0 = 0$, we can generate the following sequence of values:

$$
\begin{array}{c|cccccccc|cc}
i & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 \\ \hline
X_i & 0 & 3 & 2 & 5 & 4 & 7 & 6 & 1 & 0 & 3 \\ \hline
R_i & 0 & 3/8 & 2/8 & 5/8 & 4/8 & 7/8 & 6/8 & 1/8 & 0 & 3/8 \\
\end{array}
$$

Notice that this sequence starts repeating with after eight observations: $X_8 = X_0 = 0$. This generator is a **full-period generator** since it has a cycle length equal to $m$. Generally speaking, we prefer full-period generators, but we would never use this particular generator in practice because the modulus is much too small.

Let's consider the following plot of all $(X_{i-1}, X_i)$ coordinate pairs. For example, the point $(0, 3)$ corresponds to $(X_0, X_1)$. Notice that we also include the point $(-2, 1)$. We can observe that $-2 \bmod 8 = 6 \bmod 8 = 6$.

![](https://assets.omscs.io/notes/2020-10-09-22-14-37.png)

What's interesting about this plot is that the pseudo-random numbers appear to fall on lines. This feature is a general property of the linear congruential generators.

### Easy Exercise

Consider the following generator:

$$
X_i = (5X_{i-1} + 2) \bmod 8
$$

Does this generator achieve full cycle? Let's find out:

$$
\begin{array}{c|cccc|c}
i & 0 & 1 & 2 & 3 & 4 \\ \hline
X_i & 0 & 2 & 4 & 6 & 0  \\ \hline
R_i & 0 & 2/8 & 4/8 & 6/8 & 0  \\
\end{array}
$$

If we seed this sequence with an odd number, we only see odd numbers. Similarly, if we seed this sequence with an even number, we only see even numbers. Regardless, this sequence repeats after four observations, and, since the modulus is eight, this generator does not achieve full cycle.

### Better Example

Let's look at a much better generator, which we have seen before:

$$
X_i = 16807X_{i-1} \bmod 2^{31}-1
$$

This particular generator has a full-period (greater than two billion) cycle length, except when $X_0 = 0$.

Let's look at the algorithm for generating each $X_i$ and $R_i$:

$$
\begin{alignedat}{1}
& K \leftarrow \lfloor X_{i-1} / 237773 \rfloor \\
& X_i \leftarrow 16807(X_{i-1} - 127773K) - 2836K \\
& \text{if } X_i < 0, \text{then set } X_i \leftarrow X_i + 214748367 \\
& R_i \leftarrow X_i * 4.656612875\text{E-}10
\end{alignedat}
$$

As an example, if $X_0 = 12345678$, then:

$$
\begin{alignedat}{1}
& K \leftarrow \lfloor 12345678 / 237773 \rfloor = 96 \\
& X_1 \leftarrow 16807[12345678 - 127773(96)] - 2836(96) = 1335380034 \\
& R_1 \leftarrow 1335380034 * 4.656612875\text{E-}10 = 0.621835
\end{alignedat}
$$

### What Can Go Wrong?

As we saw, we can have generators like $X_i = (5X_{i-1} + 2) \bmod 8$, which only produce even integers and are therefore not full-period. Alternatively, the generator $X_i = (X_{i-1} + 1) \bmod 8$ *is* full-period, but it produces very non-random output: $X_1 = 1$, $X_2 = 2$, and so on.

In any case, if the modulus $m$ is "small", we'll get unusably short cycling whether or not the generator is full period. By small, we mean anything less than two billion or so. However, just because $m$ is big, we still have to be careful because subtle problems can arise.

### RANDU Generator

Let's take a look at the RANDU generator, which was popular during the 1960s:

$$
X_i = 65539 X_{i-1} \bmod 2^{31}
$$

Unfortunately, the numbers that this LCG generates are provably not i.i.d., even from a statistical point of view. 

Let's take a sufficiently large $i$ and plot the points $(R_{i-2}, R_{i-1}, R_i)$ within a unit cube. If the numbers generated from this sequence were truly random, we would see a random dispersion of dots within the cube. However, the random numbers fall entirely on fifteen hyperplanes.

![](https://assets.omscs.io/notes/2020-10-09-22-45-35.png)

### Exercises

![](https://assets.omscs.io/notes/2020-10-09-22-46-20.png)

## Tausworthe Generators

In this lesson, we will look at the Tausworthe generator.

### Tausworthe Generator

Let's take a look at the Tausworthe generator. We will define a sequence of binary digits, $B_1, B_2,...,$ as:

$$
B_i = \left(\sum_{j=1}^q c_j B_{i-j}\right) \bmod 2
$$

In other words, we calculate each $B_i$ by taking the sum of the $q$ previous $c_j B_{i -j}$ products, where $c_j \in \{0,1\}$. We take the entire sum $\bmod 2$, so every $B_i$ is either a one or a zero.

Instead of using the previous $q$ entries in the sequence to compute $B_i$, we can use a shortcut that saves a lot of computational effort, which takes the same amount of time regardless of the size of $q$:

$$
B_i = (B_{i-r} + B_{i-q}) \bmod 2 = B_{i-r} \text{ XOR } B_{i-q} \quad 0 < r < q
$$

Remember that any $B_i$ can only be either $0$ or $1$. Consider the following table:

$$
\begin{array}{cc|cc}
B_{i-r} & B_{i-q} & B_{i-r} + B_{i-q} & (B_{i-r} + B_{i-q}) \bmod 2 \\ \hline
0 & 0 & 0 & 0 \\
0 & 1 & 1 & 1 \\
1 & 0 & 1 & 1 \\
1 & 1 & 10 & 0
\end{array}
$$

Now, let's consider the $\text{XOR}$ operator. If we think of the $\text{OR}$ operator as, colloquially, "either this or that", we can think of the $\text{XOR}$ as "either this or that, but not both"; indeed, $\text{XOR}$ is an abbreviation of "eXclusive OR". Let's look at the truth table:

$$
\begin{array}{cc|c}
B_{i-r} & B_{i-q} & B_{i-r} \text{ XOR } B_{i-q}  \\ \hline
0 & 0 & 0 \\
0 & 1 & 1 \\
1 & 0 & 1 \\
1 & 1 & 0
\end{array}
$$

Thus, we can see that $(B_{i-r} + B_{i-q}) \bmod 2$ and $B_{i-r} \text{ XOR } B_{i-q}$ are indeed equivalent. Of course, we might use an even simpler expression to compute $B_i$, which doesn't involve $\text{XOR}$:

$$
B_i = \left\{
    \begin{matrix}
    0 & B_{i-r} = B_{i-q} \\
    1 & B_{i-r} \neq B_{i-q}
    \end{matrix}
  \right.
$$

To initialize the $B_i$ sequence, we need to specify, $B_1, B_2,..., B_q$.

### Example

Let's look at an example. Consider $r=3, q=5; B_1 = \cdots = B_5 = 1$. Thus, for $i > 5$, $B_i = B_{i-3} \text{ XOR } B_{i-5}$. For example, $B_6 = B_3 \text{ XOR } B_1 = 0$ and $B_7 = B_4 \text{ XOR } B_2 = 0$. Let's look at the first 36 values in the sequence:

$$
1111 \quad 1000 \quad 1101 \quad 1101 \quad 0100 \quad 0010 \quad 0101 \quad 1111
$$

Generally, the period of these bit sequences is $2^q - 1$. In our case, $q = 5$, so $2^5 - 1 = 31$. Indeed, the thirty-second bit restarts the sequence of five ones that we see starting from the first bit.

### Generating Uniforms

How do we get Unif(0,1) random variables from the $B_i$'s? We can take a sequence of $l$ bits and divide them by $2^l$ to compute a real number between zero and one.

For example, suppose $l=4$. Given the sequence of bits in the previous sequence, we get the following sequence of randoms:

$$
1111_2, 1000_2, 1101_2, 1101_2,... \to \frac{15}{16}, \frac{8}{16}, \frac{13}{16}, \frac{13}{16}, ...
$$

Tausworthe generators have a lot of potential. They have many nice properties, including long periods and fast calculations. Like with the LCGs, we have to make sure to choose our parameters - $q$, $r$, $B_1, \cdots, B_q$, and $l$ - with care.

## Generalizations of LCGs

In this lesson, we will return to the LCGs and look at several generalizations, some of which have remarkable properties.

### A Simple Generalization

Let's consider the following generalization:

$$
X_i = \left(\sum_{j=1}^q a_i X_{i-j}\right) \bmod m
$$

Generators of this form can have extremely large periods - up to $m^q - 1$ if we choose the parameters correctly. However, we need to be careful. The Fibonacci generator, which we saw earlier, is a special case of this generalization, and it's a terrible generator, as we demonstrated previously.

### Combinations of Generators

We can combine two generators, $X_1, X_2, ...$ and $Y_1, Y_2,...$, to construct a third generator, $Z_1, Z_2,...$. We might use one of the following techniques to construct the $Z_i$'s:

- Set $Z_i$ equal to $(X_i + Y_i) \bmod m$
- Shuffling the $X_i$'s and $Y_i$'s
- Set $Z_i$ conditionally equal to $X_i$ or $Y_i$

However, the properties for these composite generators are challenging to prove, and we should not use these simple tricks to combine generators.

### A Really Good Combined Generator

The following is a very strong combined generator. First, we initialize $X_{1,0}, X_{1,1}, X_{1,2}, X_{2,0}, X_{2,1}, X_{2,2}$. Next, for $i \geq 3$:

$$
\begin{aligned}
& X_{1,i} = (1,403,580X_{1, i-2} - 810,728X_{1,i-3}) \bmod (2^{32} - 209) \\
& X_{2,i} = (527,612X_{2, i-1} - 1,370,589X_{2,i-3}) \bmod (2^{32} - 22,853) \\
& Y_i = (X_{1,i} - X_{2,i}) \bmod(2^{32} - 209) \\
& R_i = Y_i / (2^{32} - 209)
\end{aligned}
$$

As crazy as this generator looks, it only requires simple mathematical operations. It works well, it's easy to implement, and it has an amazing cycle length of about $2^{191}$.

### Some Remarks

Matsumoto and Nishimura have developed the "Mersenne Twister" generator, which has a period of $2^{19937} - 1$. This period is beyond sufficient for any modern application; we will often need several billion PRNs, but never more than even $2^{100}$. All standard packages - Excel, Python, Arena, etc. - use one of these "good" generators.

## Choosing a Good Generator - Theory

In this lesson, we will discuss some PRN generator properties from a theoretical perspective, and we'll look at an amalgamation of typical results to aid our discussion.

### Theorem

Suppose we have the following multiplicative generator:

$$
X_i = aX_{i-1} \bmod 2^n
$$

This generator can have a cycle length of at most $2^{n-2}$, which means that this generator is not full-cycle. To make matters worse, we can only achieve this maximum cycle length when $X_0$ is odd and $a = 8k + 3$ or $a = 8k + 5$, for some $k$.

For example, suppose $X_i = 13X_{i-1}\bmod64$. Note that $a = 8k + 5, k = 1$ and $n = 2^6 = 64$. Consider the following sequence of values:

$$
\begin{array}{c|cccccccc}
X_0 & X_1 & X_2 & X_3 & X_4 & \cdots & X_8 & \cdots & X_{16} \\ \hline
1 & 13 & 41 & 21 & 17 & \cdots & 33 & \cdots & 1
\end{array}
$$

We can see that we have cycled after $2^{n-2} = 2^4 = 16$ entries. What happens to the cycle length if $X_0$ is even?

$$
\begin{array}{c|cccccc}
X_0 & X_1 & X_2 & X_3 & X_4 & \cdots & X_8  \\ \hline
2& 26 & 18 & 42 & 34 & \cdots & 33
\end{array}
$$

Here, we cycle after $2^{n-3} = 8$ entries. Let's look at the cycle for $X_0 = 3$. As we can see, our cycle length increases back to $2^{n-2}$:

$$
\begin{array}{c|cccccccc}
X_0 & X_1 & X_2 & X_3 & X_4 & \cdots & X_8 & \cdots & X_{16} \\ \hline
3 & 39 & 56 & 63 & 51 & \cdots & 35 & \cdots & 3
\end{array}
$$

Finally, let's look at the sequence when $X_0 = 4$. As we can see, when we seed the generator with this value, our cycle length drops to four.

$$
\begin{array}{c|cccc}
X_0 & X_1 & X_2 & X_3 & X_4 \\ \hline
4 & 52 & 36 & 20 & 4
\end{array}
$$

### Theorem

Suppose we have the following linear congruential generator:

$$
X_i = (aX_{i-1} + c) \mod m, \quad c > 0
$$

This generator has full cycle if the following three conditions hold:

- $c$ and $m$ are [relatively prime](https://en.wikipedia.org/wiki/Coprime_integers)
- $a - 1$ is a multiple of every prime which divides $m$
- $a - 1$ is a multiple of $4$ if $4$ divides $m$

Let's look at a corollary to this theorem. Consider the following special case of the general LCG above:

$$
X_i = (aX_{i-1} + c) \mod 2^n, \quad (c, n > 1)
$$

This generator has full cycle if $c$ is odd and $a = 4k+1$ for some $k$.

### Theorem

Suppose we have the following multiplicative generator:

$$
X_i = aX_{i=1} \bmod m, \quad m \text{ is prime}
$$

This generator has full period ($m - 1$, in this case), if and only if the following two conditions hold:

- $m$ divides $a^{m-1} - 1$
- for all integers $i < m - 1$, $m$ does not divide $a^i - 1$

We define the full period as $m - 1$ in this case because, if we start at $X_0 = 0$, we just cycle at zero.

For $m = 2^{31} - 1$, it can be shown that $534,600,000$ multipliers yield full period. In some sense, $a = 950,706,376$ is the "best" multiplier, according to [this paper](https://apps.dtic.mil/dtic/tr/fulltext/u2/a143085.pdf) by Fishman and Moore from 1986.

### Geometric Considerations

Let's look at $k$ consecutive PRNs, $(R_i,...,R_{i+k-1}), i \geq 1$, generated from a multiplicative generator. As it turns out, these $k$-tuples lie on parallel hyperplanes in a $k$-dimensional unit cube.

We might be interested in the following geometric optimizations:

- maximizing the minimum number of hyperplanes in all directions 
- minimizing the maximum distance between parallel hyperplanes 
- maximizing the minimum Euclidean distance between adjacent $k$-tuples

Remember that the RANDU generator is particularly bad because the PRNs it generates only lie on 15 hyperplanes.

### One-Step Serial Correlation

We can also look at a property called **one-step serial correlation**, which measures how adjacent are correlated with each other. Here's a result from [this paper](https://www.ams.org/journals/mcom/1961-15-076/S0025-5718-1961-0144489-8/S0025-5718-1961-0144489-8.pdf) by Greenberg from 1961:

$$
\text{Corr}(R_1, R_2) \leq \frac{1}{a}\left(1 - \frac{6c}{m} + 6\left(\frac{c}{m}\right)^2\right) + \frac{a+6}{m}
$$

Remember that $a$ is the multiplicative constant, $c$ is the additive constant, and $m$ is the modulus.

This upper bound is very small when $m$ is in the range of two billion, and $a$ is, say, $16807$. This result is good because it demonstrates that small $X_i$'s don't necessarily follow small $X_{i-1}$'s, and large $X_i$'s don't necessarily follow large $X_{i-1}$'s.

## Choosing a Good Generator - Stats Test

In this lesson, we'll give an overview of various statistical tests for goodness-of-fit and independence. We'll conduct specific tests in subsequent lessons.

### Statistical Tests Intro

We will look at two general classes of tests because we have a couple of goals we want to accomplish when examining how well pseudo-random number generators perform. 

We run **goodness-of-fit tests** to ensure that the PRNs are approximately Unif(0,1). Generally speaking, we will look at the **chi-squared test** to measure goodness-of-fit, though there are other tests available. We also run **independence tests** to determine whether the PRNs are approximately independent. If a generator passes both tests, we can assume that it generates approximately i.i.d Unif(0,1) random variables.

All the tests that we will look at are hypothesis tests: we will test our **null hypothesis** ($H_0$) against an **alternative hypothesis** ($H_1$). 

We regard $H_0$ as the status quo - "that which we currently believe to be true". In this case, $H_0$ refers to the belief that the numbers we are currently generating are, in fact, i.i.d Unif(0,1). 

If we get substantial, observational evidence that $H_0$ is wrong, then we will reject it in favor of $H_1$. In other words, we are innocent until proven guilty, at least from a statistical point of view.

When we design a hypothesis test, we need to set the **level of significance**, $\alpha$, which is the probability that we reject $H_0$, given it is true: $\alpha = P(\text{Reject } H_0 | H_0 \text{ true})$. Typically, we set $\alpha$ equal to $0.05$ or $0.1$. Rejecting a true $H_0$ is known as a **Type I Error**.

Selecting a value for $\alpha$ informs us of the number of observations we need to take to achieve the conditional probability to which $\alpha$ refers. For example, if we set $\alpha$ to a very small number, we typically have to draw more observations than if we were more flexible with $\alpha$.

We can also specify the probability of a **Type II Error**, which is the probability, $\beta$, of accepting $H_0$, given that it is false: $\beta = P(\text{Accept } H_0 | H_0 \text{ false})$. We won't focus on $\beta$ much in these lessons.

Usually, we are much more concerned with avoiding incorrect rejections of $H_0$, so $\alpha$ tends to be the more important of the two measures.

For instance, suppose we have a new anti-cancer drug, and it's competing against our current anti-cancer drug, which has average performance. Our null hypothesis would likely be that the current drug is better than the new drug because we want to keep the status quo. It's a big problem if we reject this hypothesis and replace it with a less effective drug; indeed, it's a much worse situation than not replacing it with a superior drug.

## Choosing a Good Generator - Goodness-of-Fit Tests

In this lesson, we'll look at the chi-squared goodness-of-fit test to check whether or not the PRNs we generate are indeed Unif(0,1). There are many goodness-of-fit tests in the wild, such as the [Kolmogorov-Smirnov](https://en.wikipedia.org/wiki/Kolmogorov%E2%80%93Smirnov_test) test and the [Anderson-Darling](https://en.wikipedia.org/wiki/Anderson%E2%80%93Darling_test) test, but chi-squared is the most tried-and-true. We'll look at how to do goodness-of-fit tests for other distributions later.

### Chi-Squared Goodness-of-Fit Test

The first thing we need to consider when designing this test is what our null hypothesis ought to be. In this case, we assume that our PRNs are Unif(0,1). Formally, $H_0$: $R_1, R_2,...,R_n \sim \text{Unif}(0,1)$. As with all hypothesis tests, we assume that $H_0$ is true until we have ample evidence to the contrary, at which point we reject $H_0$.

To start, let's divide the unit interval, $[0,1]$, into $k$ adjacent sub-intervals of equal width: $[0, 1/k), [1/k, 2/k),..., [(k-1)/k, 1]$. If our alleged uniforms are truly uniform, then the probability that any one observation $R_j$ will fall in a particular sub-interval is $1/k$.

Next, we'll draw $n$ observations, $R_1,...,R_n$, and observe how many fall into each of the $k$ cells. Let $O_i$ equal the number of $R_j$'s that fall in sub-interval $i$. Given $n$ trials, and a probability of $1/k$ of landing in sub-interval $i$, we see that each $O_i$ is distributed as a binomial random variable: $O_i \sim \text{Bin}(n, 1/k), i = 1,2,...,k$. Note that we can only describe $O_i$ in this way if we assume that the $R_j$'s are i.i.d.

Since $O_i$ is a binomial random variable, we can define the expected number of $R_j$'s that will fall in cell $i$ as: $E_i = E[O_i] = n/k, i = 1,2,...,k$. Remember that, by definition, the expected value of a Bin($n,p$) random variable is $np$.

We reject the null hypothesis that the PRNs are uniform if the $O_i$'s don't match the $E_i$'s well. In other words, if our observations don't match our expectations, under the assumption that $H_0$ is true, then something is wrong. The only thing that could be wrong is the null hypothesis.

The goodness-of-fit statistic, $\chi^2$, gives us some insight into how well our observations match our expectations. Here's how we compute $\chi^2$:

$$
\chi_0^2 = \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i}
$$

> Note the subscript of $0$. All this means is that $\chi^2_0$ is a statistic that we collect by observation.

In layman's terms, we take the sum of the squared differences of each of our observations and expectations, and we standardize each squared difference by the expectation. Note that we square the difference so that negative and positive deviations don't cancel. 

If the observations don't match the expectations, then $\chi_0^2$ will be a large number, which indicates a bad fit. When we talk about "bad fit" here, what we are saying is that describing the sequence of PRNs as being approximately Unif(0,1) is inappropriate: the claim doesn't fit the data.

As we said, $O_i$ is a binomial random variable. For large values of $n$ and $k$, binomial random variables are [approximately normal](https://en.wikipedia.org/wiki/Binomial_distribution#Normal_approximation). If $E_i$ is the expected value of $O_i$, then $(O_i - E_i) \sim \text{Nor}(0, \sigma^2)$. 

As it turns out, the quantity $(O_i - E_i)^2$ is a $\chi^2$ random variable, and, by dividing it by $E_i$, we standardize it to a $\chi^2$ random variable with one degree of freedom. If we add up $k$ $\chi^2$ random variables, we get a $\chi^2$ random variable with $k$ degrees of freedom.

Note that the $O_i$'s are correlated with one another; in other words, if $R_j$ falls in one sub-interval, it cannot fall in another sub-interval. The number of observations that land in one sub-interval is obviously dependent on the number that land in the other sub-intervals. 

All this to say: we don't actually get $k$ degrees of freedom, in our resulting $\chi^2$ random variable, we only get $k-1$. We have to pay a penalty of one degree of freedom for the correlation. In summary, by the central limit theorem, $\chi^2_0 \sim \chi^2_{k-1}$, if $H_0$ is true.

Now, we can [look up]((https://en.wikipedia.org/wiki/Chi-square_distribution#Table_of_%CF%872_values_vs_p-values)) various $(1-a)$ quantiles for $\chi^2$ distributions with varying degrees of freedom, $n$, where we define a quantile, $\chi^2_{\alpha, n}$ as: $P(\chi^2_n < \chi^2_{\alpha, n}) = 1 - \alpha$. In our case, we reject the null hypothesis if our test statistic, $\chi^2_0$, is larger than $\chi^2_{\alpha, k-1}$, and we fail to reject $H_0$ if $\chi^2_0 \leq \chi^2_{\alpha, k-1}$.

The usual recommendation from an introductory statistics class for the $\chi^2$ goodness-of-fit test is to pick large values for $k$ and $n$: $E_i = n/k$ should be at least five, and $n$ should be at least 30.

However, when we test PRN generators, we usually have massive values for both $n$ and $k$. When $k$ is so large we can't find tables with values for $\chi^2_{a,k-1}$, we can approximate the $\chi^2$ quantile using the following expression:

$$
\chi^2_{\alpha, k-1} \approx (k-1) \left[1 - \frac{2}{9(k-1)} + z_a \sqrt{\frac{2}{9(k-1)}}\right]^3
$$

Note that $z_a$ is the appropriate standard normal quantile.

### Illustrative Example

Suppose we draw $n = 1000$ observations, and we've divided the unit interval into $k=5$ equal sub-intervals. The expected number of observations that fall into each interval is $E_i = n/k = 200$. Let's look at the observations we gathered:

$$
\begin{array}{c|ccccc}
\text{interval} & [0,0.2] & (0.2,0.4] & (0.4, 0.6] & (0.6, 0.8] & (0.8, 1.0] \\ \hline
E_i & 200 & 200 & 200 & 200 & 200 \\
O_i & 179 & 208 & 222 & 199 & 192
\end{array}
$$

Let's compute the goodness-of-fit statistic:

$$
\begin{alignedat}{1}
\chi_0^2 &= \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i} \\
&= \frac{1}{200}((-21)^2 + 8^2 + 22^2 + (-1)^2 + (-8)^2) \\[2ex]
& =  \frac{1054}{200} = 5.27
\end{alignedat}
$$

Since $k=5$, we are looking at a $\chi^2$ distribution with four degrees of freedom. Let's choose $\alpha = 0.05$. Now, we need to look up the $\chi^2_{0.05, 4}$ quantile in a table, which has a value of 9.49. Since our test statistic is less than the quantile, we fail to reject $H_0$. We can assume that these observations are approximately uniform.

## Choosing a Good Generator - Independence Tests I

In this lesson, we'll look at the so-called "runs" tests for independence of PRNs. There are many other tests - correlation tests, gap test, poker tests, birthday tests, etc. - but we'll focus specifically on two types of runs tests.

Interestingly, we find ourselves in something of a catch-22: the independence tests all assume that the PRNs are Unif(0,1), while the goodness-of-fit tests all assume that the PRNs are independent.

### Independence - Runs Tests

Let's consider three different sequences of coin tosses:

$$
\begin{aligned}
\text{A. H,T,H,T,H,T,H,T,H,T} \\
\text{B. H,H,H,H,H,T,T,T,T,T} \\
\text{C. H,H,H,T,T,H,T,T,H,T} \\
\end{aligned}
$$

In example A, we have a high negative correlation between the coin tosses since tails always follows heads and vice versa. In example B, we have a high positive correlation, since similar outcomes tend to follow one another. We can't see a discernible pattern among the coin tosses in example C, so observations might be independent in this sequence.

A **run** is a series of similar observations. In example A above, there are ten runs: "H", "T", "H", "T", "H", "T", "H", "T", "H", "T". In example B, there are two runs: "HHHHH", "TTTTT". Finally, in example C, there are six runs: "HHH", "TT", "H", "TT", "H", "T".

In independence testing, our null hypothesis is that the PRNs $R_1, R_2,...,R_n$ are independent. A **runs test** rejects the null hypothesis if there are "too many" or "too few" runs, provided we quantify the terms "too many" and "too few". There are several types of runs tests, and we'll look at two of them.

### Runs Test "Up and Down"

Consider the following PRNs:

$$
.41 \quad .68 \quad .89 \quad .84 \quad .74 \quad .91 \quad .55 \quad .71 \quad .36 \quad .30 \quad .09
$$

In the **"up and down" runs test**, we look to see whether we go "up" or "down" as we move from PRN to PRN. Going from $.41$ to $.68$, we go up. Going from $.68$ to $0.89$, we go up. Going from $0.89$ to $0.84$, we go down. From $0.84$ to $0.74$, we go down again.

Let's transform our sequence of PRNs into one of plusses and minuses, where a plus sign indicates going up, and a minus sign indicates going down:

$$
++--+-+--- ...
$$

Here are the associated runs - there are six in total - demarcated by commas:

$$
++,--,+,-,+,---, ...
$$

Let $A$ denote the total number of up and down runs out of the $n$ observations. Like we said, $A = 6$ in this example. If $n$ is large (say, $\geq 20$), and the $R_j$'s are indeed independent, then $A$ is approximately normal, with the following parameters:

$$
A \approx \text{Nor}\left(\frac{2n-1}{3}, \frac{16n-29}{90}\right)
$$

Let's transform $A$ into a standard normal random variable, $Z_0$, which we accomplish with the following manipulation:

$$
Z_0 = \frac{A - E[A]}{\sqrt{\text{Var}(A)}}
$$

Now we can finally quantify "too large" and "too small". Specifically, we reject $H_0$ if the absolute value of $Z_0$ is greater than the $\alpha/2$ standard normal quantile:

$$
f(Z_0) = \left\{
  \begin{matrix}
    \text{Reject } H_0 & |Z_0| > z_{\alpha/2} \\
    \text{Accept } H_0 & |Z_0| \leq z_{\alpha/2}
  \end{matrix}
\right. 
$$


### Up and Down Example

Suppose we have observed $A = 55$ runs over $n = 100$ observations. Given these variables, $A$ is approximately normal with the following parameters:

$$
\begin{alignedat}{1}
A &\approx \text{Nor}\left(\frac{2(100)-1}{3}, \frac{16(100)-29}{90}\right) \\
& \approx \text{Nor}\left(\frac{199}{3}, \frac{1571}{90}\right) \\
& \approx \text{Nor}\left(66.33, 17.46\right)
\end{alignedat}
$$

Let's compute $Z_0$:

$$
\begin{alignedat}{1}
Z_0 &= \frac{A - E[A]}{\sqrt{\text{Var}(A)}} \\[3ex]
&= \frac{55 - 66.33}{\sqrt{17.46}} \\[3ex]
&\approx \frac{-11.33}{4.1785} \approx -2.71
\end{alignedat}
$$

If $\alpha = 0.05$, then $z_{\alpha/2} = 1.96$ and we reject $H_0$, thereby rejecting independence.

### Runs Test "Above and Below the Mean"

Let's look at the same sequence of PRNs:

$$
.41 \quad .68 \quad .89 \quad .84 \quad .74 \quad .91 \quad .55 \quad .71 \quad .36 \quad .30 \quad .09
$$

Let's transform our sequence of PRNs into one of plusses and minuses, where a plus sign indicates that $R_i \geq 0.5$, and a minus sign indicates that $R_i < 0.5$:

$$
-+++++++---...
$$

Here are the associated runs - there are three in total - demarcated by commas:

$$
-,+++++++,---
$$

If $n$ is large (say, $\geq 20$), and the $R_j$'s are indeed independent, then the number of runs, $B$, is again approximately normal, with the following parameters:

$$
B \approx \text{Nor}\left(\frac{2n_1n_2}{n} + \frac{1}{2}, \frac{2n_1n_2(2n_1n_2 - n)}{n^2(n-1)}\right)
$$

Note that $n_1$ refers to the number of observations greater than or equal to the mean and $n_2 = n - n_1$.

Let's transform $B$ into a standard normal random variable, $Z_0$, which we accomplish with the following manipulation:

$$
Z_0 = \frac{B - E[B]}{\sqrt{\text{Var}(B)}}
$$

Again, we reject $H_0$ if the absolute value of $Z_0$ is greater than the $\alpha/2$ standard normal quantile:

$$
f(Z_0) = \left\{
  \begin{matrix}
    \text{Reject } H_0 & |Z_0| > z_{\alpha/2} \\
    \text{Accept } H_0 & |Z_0| \leq z_{\alpha/2}
  \end{matrix}
\right. 
$$

### Above and Below the Mean Example

Consider the following $+/-$ sequence of $n=40$ observations:

$$
\begin{aligned}
-+++++++---++-+----- \\
--++----++--+-+--++-
\end{aligned}
$$

In this case, we have $n_1 = 18$ observations above the mean and $n_2 = 22$ observations below the mean, as well as $B=17$ runs. Without walking through the algebra, we can compute that $B \approx \text{Nor}(20.3, 9.54)$.

Let's compute $Z_0$:

$$
\begin{alignedat}{1}
Z_0 &= \frac{B - E[B]}{\sqrt{\text{Var}(B)}} \\[3ex]
&= \frac{17 - 20.3}{\sqrt{9.54}} \\[3ex]
&\approx \frac{-3.3}{3.0887} \approx -1.07
\end{alignedat}
$$

If $\alpha = 0.05$, then $z_{\alpha/2} = 1.96$, and we fail to reject $H_0$. Therefore, we can treat the observations in this sequence as being independent.

## Choosing a Good Generator - Independence Tests II (OPTIONAL)

In this lesson, we'll look at another class of tests, autocorrelation tests, that we can use to evaluate whether pseudo-random numbers are independent.

### Correlation Test

Given a sequence of PRNs, $R_1, R_2, ... R_n$, and assuming that each $R_i$ is Unif(0,1), we can conduct a **correlation test** against the null hypothesis that the $R_i$'s are indeed independent.

We define the **lag-1 correlation** of the $R_i$'s by $\rho \equiv \text{Corr}(R_i, R_{i+1})$. In other words, the lag-1 correlation measures the correlation between one PRN and its immediate successor. Ideally, if the PRNs are uncorrelated, $\rho$ should be zero.

A good estimator for $\rho$ is given by:

$$
\hat\rho \equiv \left(\frac{12}{n-1}\sum_{k=1}^{n-1}R_kR_{1+k}\right) - 3
$$

In particular, if $n$ is large, and $H_0$ is true:

$$
\hat\rho \approx \text{Nor}\left(0, \frac{13n- 19}{(n-1)^2}\right)
$$

Let's transform $\hat{\rho}$ into a standard normal random variable, $Z_0$, which we accomplish with the following manipulation:

$$
Z_0 = \frac{\hat\rho - E[\hat\rho]}{\sqrt{\text{Var}(\hat\rho)}} = \frac{\hat\rho}{\sqrt{\text{Var}(\hat\rho)}}
$$

We reject $H_0$ if the absolute value of $Z_0$ is greater than the $\alpha/2$ standard normal quantile:

$$
f(Z_0) = \left\{
  \begin{matrix}
    \text{Reject } H_0 & |Z_0| > z_{\alpha/2} \\
    \text{Accept } H_0 & |Z_0| \leq z_{\alpha/2}
  \end{matrix}
\right.
$$

### Example

Consider the following $n=30$ PRNs:

$$
\begin{aligned}
0.29 \quad 0.38 \quad 0.46 \quad 0.29 \quad 0.69 \quad 0.73 \quad 0.80 \quad 0.74 \quad 0.99 \quad 0.74 \\
0.88 \quad 0.66 \quad 0.56 \quad 0.41 \quad 0.35 \quad 0.22 \quad 0.18 \quad 0.05 \quad 0.25 \quad 0.36 \\
0.39 \quad 0.45 \quad 0.50 \quad 0.62 \quad 0.76 \quad 0.81 \quad 0.97 \quad 0.72 \quad 0.11 \quad 0.55 \\
\end{aligned}
$$

After some algebra, we get $\hat\rho = 0.950$ and $\text{Var}(\hat\rho) = 0.441$. Notice how high our correlation estimator is; we might expect a robust rejection of the null hypothesis.


Let's compute $Z_0$:

$$
\begin{alignedat}{1}
Z_0 &= \frac{\hat\rho}{\sqrt{\text{Var}(B)}} \\[3ex]
&= \frac{0.950}{\sqrt{0.441}} \approx 1.43
\end{alignedat}
$$

If $\alpha = 0.05$, then $z_{\alpha/2} = 1.96$, and we fail to reject $H_0$. Therefore, we can treat the observations in this sequence as being independent. In this case, $n=30$ observations is quite small, and we might indeed reject $H_0$, given such a high correlation, if we were to collect more observations.
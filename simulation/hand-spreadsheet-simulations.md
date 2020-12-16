---
id: simulation-hand-and-spreadsheet-simulations
title: Hand and Spreadsheet Simulations
course: simulation
lecture: hand-and-spreadsheet-simulations
---

# Hand and Spreadsheet Simulations

## Stepping Through a Differential Equation

In this lesson, we are going to solve a differential equation by hand.

### Stepping Through a Differential Equation Numerically

If $f(x)$ is continuous, then the **derivative** at $x$ - assuming that it exists and is well-defined for any $x$ - is:

$$
\frac{d}{dx} f(x) \equiv f'(x) \equiv \lim_{h \to\ 0} \frac{f(x + h) - f(x)}{h}
$$

Note that we also refer to the derivative at $x$ as the instantaneous slope at $x$. The expression $f(x + h) - f(x)$ represents the "rise", and $h$ represents the "run". As $h \to 0$, the slope between $(x, f(x))$ and $(x + h, f(x + h))$ approaches the instantaneous slope at $(x, f(x))$.

Thus, for small $h$:

$$
f'(x) \approx \frac{f(x+h) - f(x)}{h}
$$

We can manipulate this expression to get the following approximation:

$$
f(x+h) \approx f(x) + hf'(x)
$$

### Example

Let's suppose that we have a differential equation - perhaps of some population growth model - of the form: $f'(x) = 2f(x)$, with an initial condition that $f(0) = 10$. We are going to find an approximate solution to this differential equation using a **fixed-increment time approach** with $h = 0.01$. This approach is known as [Euler's method](https://en.wikipedia.org/wiki/Euler_method).

Let's approximate $f(x+h)$, using the relationship between $f(x)$ and $f'(x)$ from the differential equation:

$$
f(x+h) \approx f(x) + hf'(x) = f(x) +2hf(x) = (1 + 2h)f(x)
$$

We can repeat this exercise for $f(x + 2h)$. First:

$$
f(x + 2h) = f((x + h) + h)
$$

What do we know about $f((x+h) + h)$? Let's plug back in to our approximation for $f(x+h)$, using $x+h$ as $x$ and $h$ as $h$. Consider:

$$
f((x+h) + h) \approx f(x + h) + hf'(x + h) \\[2ex] 
$$

Recall the approximation for $f(x +h)$ that we just found, and remember that $f'(x) = 2f(x)$. So:

$$
f((x+h) + h) \approx (1+2h)f(x) + 2hf(x + h) \\[2ex] 
$$

Again, we have an $f(x+h)$ term that we can substitute for:

$$
\begin{alignedat}{1}
f((x+h) + h) & \approx (1+2h)f(x) + 2h (1+2h)f(x) \\[2ex]
& \approx (1+2h)(1+2h)(fx) \\[2ex]
& \approx (1+2h)^2(fx)
\end{alignedat}
$$

If we go through this approximation again and again, we will see the following formula arise:

$$
f(x + ih) \approx (1+2h)^if(x), \quad i = 0,1,2,...,
$$

This strategy works well, although it may deteriorate as $i$ gets large since we are compounding approximations (and thus propagating approximation errors) as a function of $i$.

Now, If we plug in $x = 0, f(x = 0) = 10, h = 0.01$, to the generalized equation above, we have:

$$
\begin{alignedat}{1}
& f(0.01i) \approx 10(1.02)^i  \quad i = 0,1,2,..., \\
& f(x) \approx 10(1.02)^x \quad x = 0, 0.01, 0.02,...,
\end{alignedat}
$$

Now, the precise solution for this differential equation is $f(x) = 10e^{2x}$. We can use a Taylor series to express $e^y$:

$$
e^y = \sum_{l=0}^\infty \frac{y^l}{l!}
$$

Let's take the first two terms:

$$
e^y \approx \sum_{l=0}^1 \frac{y^l}{l!} = 1 + y
$$

Note that $(1+y) \approx (1+y)^i$ for small values of both $y$ and $i$.

Let's see how well the approximation performs as we increase $i$. Remember that, for any $i \in 0,1,2,...$, $x = ih = 0.01i$. Therefore:

$$
\begin{array}{c|cccccc}
x = ih = 0.01i & 0&0.01&0.02&0.03&\cdots& 0.10 \\ \hline
f(x) \approx 10(1.02)^i &10&10.20&10.40&10.61& \cdots & 12.19 \\
f(x) = 10e^{2x} &10&10.20&10.41&10.62& \cdots & 12.21 \\
\end{array}
$$

As we can see, our approximation works quite well.

## Monte Carlo Integration

In this lesson, we are going to look at how we can use random numbers to perform integration. This technique is known as Monte Carlo integration and is used in many disciplines - from physics to finance - to find integrals that cannot be computed analytically.

### Integration

A function, $F(x)$, having derivative $f(x)$ is called the antiderivative. The antiderivative, also referred to as the indefinite integral of $f(x)$, is denoted $F(x) = \int{f(x)dx}$.

The [fundamental theorem of calculus](https://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus) states that if $f(x)$ is continuous, then the area under the curve for $x \in [a, b]$ is given by the definite integral:  

$$
\int^b_a f(x)dx \equiv F(x) \Big|^b_a \equiv F(b) - F(a)
$$

### Monte Carlo Integration

Let's integrate an arbitrary (continuous and well-defined) function, $g(x)$ from $a$ to $b$:

$$
I = \int_a^b g(x)dx
$$

However, we'd like to integrate from $0$ to $1$ instead of from $a$ to $b$ for reasons that will make sense shortly. We can accomplish this limit change using the following substitution:

$$
u = \frac{x-a}{b-a}; \quad \frac{du}{dx} = \frac{1}{b-a}
$$

Thus, $g(x) = g(a + (b-a)u)$ and $dx = (b-a)du$. Additionally, and this is what gets us our limit change, when $x = a$, $u = 0$, and, when $x = b$, $u = 1$. Putting the whole thing together, we get:

$$
I = \int_a^b g(x)dx = (b-a)\int_0^1g(a + (b-a)u)du
$$

Of course, we can often compute these types of integrals using the analytical methods we learned in calculus. Alternatively, we can use numerical methods like the rectangle and trapezoid rules or something more exotic like [Gauss-Laguerre integration](https://en.wikipedia.org/wiki/Gauss%E2%80%93Laguerre_quadrature). However, if these methods aren't possible, we can always use Monte Carlo integration.

Suppose that we have a random sample, $U_1, U_2,..., \overset{\text{iid}}{\sim} \text{Unif}(0,1)$. Let's define a random variable, $I_i$, as:

$$
I_i \equiv (b-a)g(a+(b-a)U_i),\quad i = 1,2,...,n
$$

Note that this expression looks precisely like the interior of the integral above, except that $g$ is evaluated at $U_i$, not $u$.

Given our random sample, let's find the sample mean, $\bar{I}_n$:

$$
\bar{I}_n \equiv \frac{1}{n}\sum_{i=1}^nI_i = \frac{b-a}{n}\sum_{i=1}^n g(a+(b-a)U_i)
$$

What we'd like to do now is demonstrate that $\bar{I}_n$ is an effective estimator for $I$. We can appeal to the Law of Large Numbers, which says that if an estimator is asymptotically unbiased and its variance goes to zero, then it's a good estimator.

Let's see if $\bar{I}_n$ is unbiased for $I$. First, we take the expected value:

$$
E[\bar{I}_n] = E\left[ \frac{b-a}{n}\sum_{i=1}^n g(a+(b-a)U_i)\right]
$$

Note that, since the $U_i$'s are iid, the summation and the $1/n$ cancel out:

$$
E[\bar{I}_n] = (b-a)E[g(a+(b-a)U_i)] \\[2ex]
$$

Remember the Law of The Unconscious Statistician:

$$
E[h(X)] = \int_{\mathbb{R}} h(x)f(x)
$$

Therefore:

$$
E[\bar{I}_n] = (b-a)\int_{\mathbb{R}} g(a+(b-a)u)f(u)du
$$

Notice that $f(u)$ is the pdf of the $\text{Unif}(0,1)$ distribution. This pdf is only defined over $[0,1]$ and is equal to $1$. So:

$$
E[\bar{I}_n] = (b-a)\int_0^1g(a+(b-a)u)du = I
$$

We can see that, since $E[\bar{I}_n] = I$, then $\bar{I}_n$ is an unbiased estimator for $I$. Additionally, it can be shown that $\text{Var}(I_n) = O(1/n)$, where $O(1/n)$ means that $1/n \to 0$ as $n \to \infty$.  With these two conditions met, the Law of Large Numbers implies that $\bar{I}_n \to I$ as $n \to \infty$. In short, $\bar{I}_n$ is an effective estimator for $I$, given a large enough $n$.

### Approximate Confidence Interval for $I$

We can also approximate a confidence interval for $I$. Using the central limit theorem, we can see that:

$$
\bar{I}_n \approx \text{Nor}(E[\bar{I}_n], \text{Var}(\bar{I}_n)) \sim \text{Nor}(I, \text{Var}(I_i) /n)
$$

This result suggests that a reasonable $100(1-\alpha)\%$ confidence interval for $I$ is:

$$
I \in \bar{I}_n \pm z_{\alpha/2}\sqrt{S^2_I / n}
$$

Remember from the statistics boot camp that $z_{\alpha/2}$ is the standard normal quantile, parameterized by $\alpha$. Also remember that $S^2_I$ is the sample variance of the $I_i$'s, defined as:

$$
S^2_I = \frac{1}{n-1} \sum_{i=1}^n(I_i - \bar{I}_n)^2
$$

### Example

Suppose $I = \int_0^1\sin(\pi x)dx$. Let's start our approximation by taking the random sample $U_1, U_2, U_3, U_4 \overset{\text{iid}}{\sim} \text{Unif}(0,1)$:

$$
U_1 = 0.79, \quad U_2 = 0.11, \quad U_3 = 0.68, \quad U_4 = 0.31
$$

Let's define $I_i$ and reduce, taking note that $b=1$ and $a=0$:

$$
I_i = (b-a)g(a+(b-a)U_i) = g(U_i) = \sin(\pi U_i)
$$

Now let's compute the sample mean, $\bar{I}$, which we have previously demonstrated is a good estimator for $I$:

$$
\bar{I}_n = \frac{1}{4}\sum_{i=1}^4 I_i = \frac{1}{4}\sum_{i=1}^4 \sin(\pi U_i) = 0.656
$$

Of course, we know that the precise value for $I$ is $2/\pi = 0.6366$, but our estimation is not far off. Though to be fair, we cheated in our selection from the $\text{Unif}(0,1)$: notice how nice and spread out the values are.

Now let's compute the approximate $95\%$ confidence interval for $I$. First, let's calculate the sample variance, $S^2_I$:

$$
S^2_I = \frac{1}{n-1} \sum_{i=1}^n(I_i - \bar{I}_n)^2 = 0.0557
$$

Now, given $\alpha = 0.05$, we can compute the confidence interval:

$$
I \in 0.656 \pm 1.96\sqrt{0.0057 / 4} = [0.596, 0.716]
$$

This confidence interval is "fat", given that we created it from just four samples. Confidence intervals usually improve as $n$ increases, though sometimes convergence is choppy due to good or bad luck with respect to randomness.

### Demo

Let's look at a demo for estimating $I = \int_0^1\sin(\pi x)dx \approx 0.6366$. We've seen this application in a previous lesson. Basically, we are going to draw $n$ random rectangles, each with width $1/n$ and centered about a point, $x_i$, with height $f(x_i)$. We will add up the areas of the rectangles to approximate the integral.

Here is an approximation, $I \approx 0.8665$, using $n=4$ rectangles.

![](https://assets.omscs.io/notes/2020-09-09-12-23-53.png)

Here is another approximation, $I \approx 0.2212$, using $n=4$ rectangles. What a terrible estimate!

![](https://assets.omscs.io/notes/2020-09-09-12-25-10.png)

Remember that we can improve our approximation by taking more samples. Here is a third approximation, $I \approx 0.6397$, using $n=128$ rectangles. Much better.

![](https://assets.omscs.io/notes/2020-09-09-12-27-29.png)

Let's see how we would run this simulation in Excel. Consider the following spreadsheet.

![](https://assets.omscs.io/notes/2020-09-09-12-35-13.png)

In the first column, we draw our iid $\text{Unif}(0,1)$ random variables with the `RAND()` function. In the second column, we generate our $I_i$'s: $I_i = \sin(\pi U_i)$. In the third column, we compute $\bar{I}_n$, the sample mean. For this example, when $n=2000$, $\bar{I}_n = 0.6361 \approx I = 0.6366$.

Let's try a slightly more complicated example that we can't integrate easily:

$$
\int_0^1 \ln(u) \ln(1-u)du
$$

Consider the following spreadsheet, focusing only on the "Random Riemann Sum" section.

![](https://assets.omscs.io/notes/2020-09-09-12-40-47.png)

Again, we go through the same process. In the first column, we draw our iid $\text{Unif}(0,1)$ random variables with the `RAND()` function. In the second column, we generate our $I_i$'s: $I_i = \ln(U_i)\ln(1-U_i)$. In the third column, we compute $\bar{I}_n$, the sample mean. For this example, when $n=2000$, $\bar{I}_n = 0.3548$. The true value of the integral is $I = \pi^2 / 6 = 0.3551$, so our approximation was close.

## Making Some Pi

In this lesson, we are going to use Monte Carlo simulation to estimate $\pi$. This approach is slightly different than Monte Carlo integration, but it uses the same general techniques.

### Description

Consider a unit square (with area one, by definition). Inside the square, we inscribe a circle with radius $1/2$ (with corresponding area $\pi / 4$). Suppose that we toss darts randomly at the square. The probability that a particular dart lands in the inscribed circle is obviously $(\pi / 4) / 1 = \pi / 4$. We can use this fact to estimate $\pi$.

Let's toss $n$ darts at the square and calculate the proportion, $\hat{p}_n$, of darts that land in the circle. From this proportion, we can estimate $\pi$ using $\hat{\pi} = 4\hat{p}_n$. Using the law of large numbers, we know that $\hat{\pi} \to \pi$ as $n \to \infty$.

For instance, suppose that we throw $n = 500$ darts at the square and $397$ land in the circle. Then $\hat{p}_n = 397 / 500 = 0.794$, and our estimate for for $\pi$ is $\hat{\pi} = 3.176$. Not bad.

### Simulation

Consider the following simulation.

![](https://assets.omscs.io/notes/2020-09-09-21-53-42.png)

Like we discussed, we throw $n$ darts at the square - $500$, in this case - on the left and then use four times the proportion of darts that hit the circle as an estimator for $\pi$. Our estimate was $3.176$ in this simulation. Note the running estimate for $\pi$ on the chart on the left. As we include more observations, the estimate begins to converge.

Let's see what happens when we increase $n$ to $200000$.

![](https://assets.omscs.io/notes/2020-09-09-21-58-47.png)

In this example, we've completely covered the square with darts. Our estimate for $\pi$ is $3.136$, and we can see what appears to be convergence in the chart on the right.

### Conducting the Experiment

How do we actually conduct this type of experiment?

To simulate a dart toss, suppose we draw two random variables, $U_1, U_2 \overset{\text{iid}}{\sim} \text{Unif}(0,1)$. The ordered pair $(U_1, U_2)$ represents the random position of the dart on the unit square. The dart lands in the inscribed circle if:

$$
\left(U_1 - \frac{1}{2} \right)^2 + \left(U_2 - \frac{1}{2} \right)^2 \leq \frac{1}{4}
$$

We can generate $n$ such pairs of uniforms and compute the proportion of those that satisfies this inequality. From there, we multiply by four, and we have $\hat{\pi}_n$. For example, suppose we generate $1000$ uniforms, and $787$ are inside the circle. Then $\hat{\pi}_n = 4 * (787 / 1000) = 3.148$.

## A Single Server Queue

In this lesson, we will simulate the line that forms in front of the single server at the $\pi$ bakery. This example is going to be our first simulation model that involves non-static customers arriving and receiving service.

### Description

Suppose that customers arrive at a single-server queue with iid interarrival times and receive service according to iid service times. Customers must wait in a FIFO (first-in-first-out) line if the server is busy. As the server processes customers, the line advances one customer at a time.

We will simulate this single-server queue setup and then estimate particular performance characteristics of the system, such as:

- the expected customer waiting time
- the expected number of people in the system
-  the expected server utilization (proportion of time server spends serving)

Of course, these metrics all matter in the real world. For example, a customer may decide against shopping at a store that has a high expected waiting time. A store owner might not be able to fit a large number of people in their store, and therefore may need the expected number of people in the system to be low. Additionally, a store owner might look at server utilization when considering adding or removing a server.

### Notation

The interarrival time between customers $i - 1$ and $i$ is $I_i$. Customer $i$'s arrival, $A_i$, is the sum of all of the preceding interarrival times:

$$
A_i = \sum_{j=1}^{i} I_j
$$

Customer $i$ starts service at time $T_i = \max(A_i, D_{i-1})$. In other words, customer $i$ is going to start service at either his arrival time, $A_i$, or when the customer ahead of him leaves, $D_{i-1}$, whichever is later. We can think of $D_i$ as the departure time of customer $i$.

Customer $i$'s waiting time, $W_i^Q$, is equal to the service time minus the arrival time: $W_i^Q = T_i - A_i$. Similarly, customer $i$'s time in the system, $W_i$, is equal to the departure time minus the arrival time: $W_i = D_i - A_i$.

Customer $i$'s service time is $S_i$, which we will generate randomly along with interarrival times. Finally, customer $i$'s departure time equals the time that service starts plus the service time: $D_i = T_i + S_i$.

### Example

Consider the following table of events:

$$
\begin{array}{c|cc|ccc|c}
i & I_i & A_i & T_i & W_i^Q & S_i & D_i \\ \hline
1 & 3 & 3 & 3 & 0 & 7 & 10 \\
2 & 1 & 4 & 10 & 6 & 6 & 16 \\
3 & 2 & 6 & 16 & 10 & 4 & 20 \\
4 & 4 & 10 & 20 & 10 & 6 & 26 \\
5 & 5 & 15 & 26 & 11 & 1 & 27 \\
6 & 5 & 20 & 27 & 7 & 2 & 29 \\
\end{array}
$$

Let's walk through a few customer journeys. Customer one has an interarrival time, $I_1 = 3$, and, assuming that we start the simulation at time $t=0$, he arrives at time $A_1=3$. Since there is no one in from of him, he starts service at $T_1 = 3$, which means his wait time is $W^Q_1 = 0$. His randomly generated service time is $S_1 = 7$, which means his departure time is $D_1 = 3 + 7 = 10$.

Meanwhile, we have randomly selected an interarrival time, $I_2 = 1$, for customer two. Since customer one arrived at $A_1 = 3$, customer two arrives one minute later at $A_2 = 4$. Now, when does customer two start service? He has to wait for customer one to leave, which happens at $D_1 = 10 = T_2$. Six minutes have elapsed since customer two arrived, so $W^Q_2 = 6$. We randomly generate a service time $S_2 = 6$, so customer two departs at $D_2 = 16$.

We randomly selected an interarrival time, $I_3 = 2$, for customer three, who arrives at $A_3 = A_2 + I_3 = 6$. Customer three has to wait to be served until $D_2 = 16 = T_3$, at which point he has waited $W_3^Q = 10$ minutes. His service time is drawn randomly at $S_3 = 4$ minutes, and he departs at $D_3 = 16 + 4 = 20$.

### Average Waiting Time

We can compute the average waiting time for these six customers by taking the average of the $W^Q_i$'s:

$$
\bar{W^Q_6} = \sum_{i=1}^6 W^Q_i = 7.33
$$

### Average Number of Customers in the System

Now we'd like to compute the average number of customers in the system, which includes both folks in line and in service. Note that the only possible times that the number of customers in the system, $L(t)$, can change is an arrival or a departure time.

These times (and the associated things that happen) are called **events**, and the type of simulation that we are looking at is **discrete event simulation**.

Let's look at the following table of events. The first column shows the time $t$ that the event occurred. The second column shows the name of the event(s) that occur at that time. The third column shows the number of people in the system, $L(t)$, after the event(s) occurs.

$$
\begin{array}{ccc}
\text{time } t & \text{event} & L(t) \\ \hline
0 & \text{simulation begins} & 0 \\
3 & \text{customer 1 arrives} & 1 \\
4 & \text{2 arrives} & 2 \\
6 & \text{3 arrives} & 3 \\
10 & \text{1 departs; 4 arrives} & 3 \\
15 & \text{5 arrives} & 4 \\
16 & \text{2 departs} & 3 \\
20 & \text{3 departs; 6 arrives} & 3 \\
26 & \text{4 departs} & 2 \\
27 & \text{5 departs} & 1 \\
29 & \text{6 departs} & 0 \\
\end{array}
$$

Note that, as a technicality, the first event is the start of the simulation, which occurs at time $t=0$. There are no people in the system when the simulation starts, so $L(0) = 0$.

The first time anything interesting happens is at time $t=3$, when customer one arrives. Since this customer is the first in the system, $L(3) = 1$. Nothing changes until time $t=4$, when customer two arrives. At this point, one customer is being served, and one customer is in line, so $L(4) = 2$. At time $t=6$, customer three arrives. Since neither customer two nor customer one has left the system, customer three gets in line, and $L(6) = 3$.

Notice that at time $t=10$, two events occur simultaneously: customer one departs and customer four arrives. Usually, we handle departures before arrivals because we like to clean people out of the system; regardless, the net effect is that $L(10)$ is unchanged from $L(6)$. Of course, in real life, customers rarely depart and arrive simultaneously because arrival times and departure times are not usually marked in integer minute increments.

Eventually, the system clears out at time $t=29$, when customer six departs. As a result, $L(29) = 0$.

### Average Number of Customers in the System (Graph)

Consider the following graphical representation of the queue. The x-axis measures time $t$, and the y-axis corresponds to $L(t)$. Each rectangle represents a customer, and the number of customers stacked at any given time-step, $t$, is $L(t)$. The integer subscripts below the x-axis mark events, and the bottom row of rectangles represents the customer receiving service during that interval.

![](https://assets.omscs.io/notes/2020-09-10-18-38-25.png)

At time $t=3$, customer one shows up and immediately begins to receive service. At time $t=4$, customer two arrives and joins the end of the queue while customer one is in service. At time $t=6$, customer three shows up and the queue has a depth of three. At time $t=10$, we can see that customer one leaves and customer four arrives, and $L(10)$ is unchanged from $L(6)$ as customer two begins service.

We can formulate an equation for the average number of people in the system, $\bar{L}$:

$$
\bar{L} = \frac{1}{29} \int_0^{29}L(t)dt = \frac{70}{29}
$$

How do we take the integral of such a "weird-looking" function, like $L(t)$? As it turns out, $L(t)$ is a step function, and we integrate a step function by adding up the integrals of all the steps. In this case, we just add up the areas of the rectangles. We can add them up individually or take vertical or horizontal slabs.

Let's take horizontal slabs as an example. The bottom rectangle has height $1$ and width $29 - 3 = 26$. The rectangle above it has height $1$ and width $27 - 4 = 23$. The rectangle above that has height $1$ and width $26 - 6 = 20$. Finally the rectangle on top has height $1$ and width $15 - 16 = 1$. Taken together, the area under $L(t)$ between $0$ and $29$ equals $26 + 23 + 20 + 1 = 70$.

### Average Number of Customers in the System (Alternate)

Another way to compute the average number of customers in the system is to compute the total customer time in the system and divide that by the total time. We defined a customer's time in the system, $W_i$, as the difference between their arrival time and departure time: $W_i = D_i - A_i$. Therefore:

$$
\begin{alignedat}{1}
\bar{L} & = \frac{\text{total customer-time in system}}{29} \\[2ex]
& = \frac{\sum_{i=1}^6(D_i - A_i)}{29} \\[2ex]
& = \frac{7 + 12 + 14 + 16 + 12 + 9}{29} \\[2ex]
& = \frac{70}{29}
\end{alignedat}
$$

### Server Utilization 

Finally, we can obtain the estimated server utilization by looking again at the graph of $L(t)$. The simulation runs for $29$ minutes, and the server is giving service for $26$ minutes, so the estimated server utilization is $\hat{\rho} = 26 / 29$.

### LIFO

Let's do another example, using the same arrival and service times, but with a last-in-first-out (LIFO) structure instead of first-in-first-out (FIFO).

$$
\begin{array}{c|cc|ccc|c}
i & I_i & A_i & T_i & W_i^Q & S_i & D_i \\ \hline
1 & 3 & 3 & 3 & 0 & 7 & 10 \\
2 & 1 & 4 & 23 & 19 & 6 & 29 \\
3 & 2 & 6 & 17 & 11 & 4 & 21 \\
4 & 4 & 10 & 10 & 0 & 6 & 16 \\
5 & 5 & 15 & 16 & 1 & 1 & 17 \\
6 & 5 & 20 & 21 & 1 & 2 & 23 \\
\end{array}
$$

Compare this table with the previous: all of the $I_i$'s, $A_i$'s, and $S_i$'s are the same. However, in this example, customers at the end of the queue are served before customers at the head.

For example, consider customer two (nothing changes with customer one). Customer two shows up while customer one is receiving service, but customer three shows up before customer two can begin service. Additionally, customer four shows up before customer one leaves. Since this is a LIFO structure, customer four begins to receive service when customer one is complete, at time $t=10$.

Customer four receives service in six minutes, so he leaves at time $t=16$. However, customer five has shown up, so his service begins before customer three's service. Customer five receives service in one minute and departs at time $t=17$, at which point customer three starts service.

Customer three receives service in four minutes, during which customer six has arrived. Customer three departs at time $t=21$ and, two minutes later, customer six departs at time $t=23$. Finally, customer two receives service in six minutes and leaves at time $t=29$.

As it turns out, the average waiting time using a LIFO structure is $5.33$ (as compared to $7.33$), and the average number of people in the system turns out to be $58 / 29 = 2$ (as compared to $70 / 29 \approx 2.41$). Thus, in this case, LIFO appears to be a better structure than FIFO, at least concerning these metrics.

## An (s, S) Inventory System

In this lesson, we will focus on a more challenging simulation example: an (s, S) inventory system. After this example, we'll have an understanding of why we don't want to run complex simulations by hand.

### Description of (s, S)

Let's suppose that a store sells some product at $\$d$ per unit. The inventory policy is to have a least $s$ units in stock at the start of each day. If the stock slips to less than $s$ by the end of the day, we place an order with our supplier to push our stock up to $S$ by the beginning of the next day.

There are various costs associated with this policy. For example, it costs us money to order inventory from our supplier. Additionally, there will be a penalty cost if we fail to satisfy customer demand. As well, there is a holding cost if we stock more inventory than we should.

### Notation

Let $I_i$ denote the inventory we have in store at the *end* of day $i$, and let $Z_i$ denote the amount of inventory we order at the end of day $i$. Since we want to top off our inventory to $S$ units if $Z_i$ falls below $s$, then:

$$
Z_i = \left\{\begin{matrix}
S - I_i & \text{if } I_i < s \\
0 & \text{otherwise}
\end{matrix}\right.
$$

If an order is placed to the supplier at the end of day $i$, it costs the store $K + cZ_i$. We incur cost $K$ just for calling up the supplier and nagging them for more product. Additionally, we incur the unit cost $c$ $Z_i$ times; for example, if we have to order 17 items, this cost is $17c$.

Moreover, we incur a cost of $\$h$/unit to hold unsold inventory overnight. We can think of this cost both in literal terms - refrigerating an item overnight costs a certain amount of electricity - or in terms of opportunity cost - had we not purchased that inventory, we could have put the money elsewhere.

Finally, we incur a penalty cost of $\$p$/unit if demand can't be met. If we run out of products and a customer cannot make a purchase, perhaps they get mad and damage the store or simply don't return to make purchases.

In this example, we aren't going to allow any backlogs. If a customer comes in and we don't have the products that they want on hand, we cannot satisfy their demand.

The only random component in this example is the demand on day $i$, $D_i$.

### Daily Profit

In English, the total profit for a given day is the sales revenue we generate minus the three costs we incur: ordering cost, holding cost, and penalty cost. Let's translate this expression into a formal equation.

First, what is the total sales revenue? Well, given demand $D_i$, we can make either $D_i$ sales, or we can sell out our entire inventory, whichever is smaller. For example, if the demand is 15 units, but we only have ten units in inventory, we can only sell ten units.  At $\$d$/unit, we can express this revenue as:

$$
\text{Revenue} = d \min(D_i, \text{inventory at beginning of day }i)
$$

What is the ordering cost? If $I_i$ falls below $s$, it is $K + cZ_i$, where $Z_i = S - I_i$ and $c$ is the unit cost. Otherwise, the order cost is zero. In other words:

$$
\text{Ordering Cost} = \left\{\begin{matrix}
K + cZ_i & \text{if } I_i < s \\
0 & \text{otherwise}
\end{matrix}\right.
$$

What is the holding cost? It's $\$h$/unit times the inventory we have at the end of day $i$, $I_i$:

$$
\text{Holding Cost} = hI_i
$$

What is the penalty cost? Well, if the inventory is greater than or equal to the demand, then our penalty cost is nothing: we've completely satisfied customer demand. Otherwise, we incur at penalty cost at $\$p$/unit for each product greater than our inventory demanded:

$$
\text{Penalty Cost} = p\max(0, D_i - \text{inventory at beginning of day }i)
$$

As a final piece, what is the inventory at the beginning of day $i$? It's merely the inventory at the end of the day $i - 1$, $I_{i-1}$, plus the order placed at the end of that day: $Z_{i - 1}$.

Thus, for a given day $i$, we express the total profit, $P_i$, as:

$$
\begin{alignedat}{1}
P_i = & d\min(D_i, I_{i-1} + Z_{i-1}) \\
& - \left\{\begin{matrix}
K + cZ_i & \text{if } I_i < s \\
0 & \text{otherwise}
\end{matrix}\right. \\
& - hI_i \\
& - p\max(0, D_i - (I_{i-1} + Z_{i-1}))
\end{alignedat}
$$

### Example

Let's look at an example of an $(s = 3, S = 10)$ inventory system. Suppose we sell each unit at $d = 10$ and we purchase each unit at $c = 4$. Further, suppose that we incur a fixed ordering cost $K = 2$, a holding cost $h=1$ per unit, and a penalty cost $p = 2$ per unit.

Additionally, consider the following sequence of randomly generated $\lceil\text{Unif}(0,8)\rceil$ demands:

$$
D_1 = 5 \\ 
D_2 = 2 \\
D_3 = 8 \\ 
D_4 = 6 \\
D_5 = 2 \\ 
D_6 = 1 \\
$$

Finally, let's suppose we start with an initial stock, $I_0 + Z_0 = 10$.

Consider the following table, which tracks inventory, demand, orders, revenue, costs, and profit over six days:

$$
\begin{array}{c|cccc|cccc|c}
\text{Day} & \text{begin} &  &  & & \text{sales} & \text{order} & \text{hold} & \text{penalty} & \text{TOTAL} \\
i & \text{stock} &  D_i & I_i &  Z_i & \text{rev} & \text{cost} & \text{cost} & \text{cost} & \text{rev} \\ \hline
1 & 10 & 5 & 5 & 0 & 50 & 0 & -5 & 0 & 45 \\
2 & 5 & 2 & 3 & 0 & 20 & 0 & -3 & 0 & 17 \\
3 & 3 & 8 & 0 & 10 & 30 & -42 & 0 & -10 & -22 \\
4 & 10 & 6 & 4 & 0 & 60 & 0 & -4 & 0 & 56 \\
5 & 4 & 2 & 2 & 8 & 20 & -34 & -2 & 0 & -16 \\
6 & 10 & 1 & 9 & 0 & 10 & 0 & -9 & 0 & 1 \\
\end{array}
$$

On day one, we start with ten units in stock, and we experience a demand for five units. Therefore, our inventory at the end of the day, $I_1$, equals $5$. Because $I_1 \geq s = 3$, we don't place an order, so $Z_1 = 0$. Our sales revenue is $5 * 10 = 50$, our order cost is $0$, our holding cost is $5 * 1 = 5$, and our penalty cost is $0$. Finally, our profit for the day is $50 - 5 = 45$.

At the beginning of day two, we have five items in stock, and we experience a demand for two units. Therefore, our inventory at the end of the day, $I_2$, equals $3$. Because $I_2 \geq s = 3$, we don't place an order, so $Z_2 = 0$. Our sales revenue is $2 * 10 = 20$, our order cost is $0$, our holding cost is $3 * 1 = 3$, and our penalty cost is $0$. Finally, our profit for the day is $20 - 3 = 17$.

At the beginning of day three, we have three items in stock and we experience a demand for eight units. Therefore, our inventory at the end of the day, $I_3$, equals $0$. Because $I_3 < s = 3$, we place an order for $Z_i = S - I_3 = 10$ units, so $Z_3 = 10$. Our sales revenue is $3 * 10 = 30$, our order cost is $K + cZ_i = 2 + 4(10) = 42$. Our hold cost is $0$, because we have no items in stock, and our penalty cost is $5p = 5(2) = 10$ because we couldn't satisfy the demand for five units. Finally, our profit for the day is $30 - 42 - 10 = -22$.

### Demo

This demo expands on the example we just discussed for an additional $1700$ days or so. There isn't really any new information to summarize here. Below is a screenshot of the spreadsheet, which you can download from Canvas.

![](https://assets.omscs.io/notes/2020-09-12-13-37-18.png)

## Simulating Random Variables

In this lesson, we will be simulating specific random variables. Much of this material in this lesson was covered in the boot camps.

### Discrete Uniform Example

For the simplest example, let's consider a discrete uniform distribution, $DU$, from $1$ to $n$: $DU = \{1, 2, ..., n\}$. Let $X = i$ with probability $1/n$ for $i \in DU$. This example might look complicated, but we can think of it basically as an $n$-sided die toss.

If $U$ is a uniform $(0, 1)$ random variable - that is, $U \sim \text{Unif}(0, 1)$ - we can obtain $X \sim DU(1, n)$ through the following transformation: $X = \lceil{nU}\rceil$, where $\lceil\cdot\rceil$ is the "ceiling", or "round up" function.

For example, suppose $n = 10$ and $U \sim \text{Unif}(0, 1)$. If $U = 0.73$, then $X = \lceil{10(0.73)}\rceil = \lceil{7.3}\rceil = 8$.

### Another Discrete Random Variable Example

Let's look at another discrete random variable. Consider the following pmf, $f(x)$ for $X$:

$$
f(x) \equiv P(X = x) = \left\{
        \begin{matrix}
            0.25 & \text{if } x -2\\
            0.10 & \text{if } x = 3 \\
            0.65 & \text{if } x = 4.2 \\ 
            0 & \text{otherwise}
        \end{matrix}
    \right. 
$$

We can't use a die toss to simulate this random variable. Instead, we have to use the inverse transform method.

Consider the following table:

| $x$  | $f(x)$ | $P(X \leq x)$ | $\text{Unif(0,1)}$ |
|------|--------|---------------|--------------------|
| $-2$ | $0.25$ | $0.25$        | $[0.00, 0.25]$     |
| $3$  | $0.10$ | $0.35$        | $(0.25, 0.35]$     |
| $4.2$| $0.65$ | $1.00$        | $(0.35, 1.00)$     |

In this first column, we see the three discrete values that $X$ can take: $\{-2, 3, 4.2\}$. In the second column, we see the values for $f(x) = P(X = x)$ as defined by the pmf above. In the third column, we see the cdf, $F(x) = P(X \leq x)$, which we obtain by accumulating the pmf.

We need to associate uniforms with $x$-values using both the pmf and the cdf. We accomplish this task in the fourth column.

Consider $x = -2$. $f(x) = 0.25$ and $P(X \leq x) = 0.25$. With this information, we can associate the uniforms on $[0.00, 0.25]$ to $x = -2$. In other words, if we draw a uniform, and it falls on $[0.00, 0.25]$ - which occurs with probability 0.25 - we select $x = -2$, which has a corresponding $f(x)$ of 0.25.

Consider $x = 3$. $f(x) = 0.10$ and $P(X \leq x) = 0.35$. With this information, we can associate the uniforms on $(0.25, 0.35]$ to $x = 3$. In other words, if we draw a uniform, and it falls on $(0.25, 0.35]$ - which occurs with probability 0.1 - we select $x = 3$, which has a corresponding $f(x)$ of 0.25.

Finally, consider $x = 4.2$. $f(x) = 0.65$ and $P(X \leq x) = 1$. With this information, we can associate the uniforms on $(0.35, 1.00)$ to $x = 4.2$. In other words, if we draw a uniform, and it falls on $(0.35, 1.00)$ - which occurs with probability 0.65 - we select $x = 4.2$, which has a corresponding $f(x)$ of 0.65

For a concrete example, let's sample $U \sim \text{Unif}(0,1)$. Given a function, $F(x)$ that maps $x$-values to the associated set of uniforms, we can compute, $X$, given $U$, by taking the inverse: $X = F^{-1}(U)$. For instance, suppose we draw $U = 0.46$. Since $F(4.2) = (0.35, 1.00)$, $X = F^{-1}(0.46) = 4.2$.

### Inverse Transform Method

Let's now use the inverse transform method to generate a continuous random variable. Consider the following theorem: if $X$ is a continuous random variable with cdf, $F(x)$, then the random variable $F(X) \sim \text{Unif}(0, 1)$.

Notice that $F(X)$ is not a cdf because $X$ is a random variable, not a particular value. $F(X)$ itself is a random variable distributed as $\text{Unif}(0,1)$.

Given this theorem, we can set $F(X) = U \sim \text{Unif}(0, 1)$, and then solve backwards for $X$ using the inverse of $F$: $X = F^{-1}(U)$. If we can compute $F^{-1}(U)$, we can generate a value for $X$ given a uniform.

For example, suppose we have a random variable $X \sim \text{Exp}(\lambda)$. The cdf of $X$ is given by the function $F(x) = 1 - e^{-\lambda x}, x > 0$. Correspondingly, $F(X) = 1 - e^{-\lambda X}$. However, we also know, according to the theorem, $F(X) = U$, so $1 - e^{-\lambda X} = U$. Let's solve for $X$:

$$
\begin{alignedat}{1}
1 - e^{-\lambda X} & = U \\
-e^{-\lambda X} & = U - 1 \\
e^{-\lambda X} & = 1 - U \\
-\lambda X & = \ln(1 - U) \\
X & = \frac{-\ln(1 - U)}{\lambda} \sim \text{Exp}(\lambda)
\end{alignedat}
$$

What's the point? Computer programs give us one particular type of randomness. When we use `RAND()` in Excel, or `random.random` in Python, we always get a random variable $U \sim \text{Unif}(0, 1)$. We have shown here that we can take this random variable - the one tool we have available to us - and transform it into any other type of random variable we want. In this particular example, we have shown how to transform $U \sim \text{Unif}(0,1)$ into $X \sim \text{Exp}(\lambda)$.

### Generating Uniforms

All of the examples that we have looked at so far require us to generate "practically" independent and identically distributed (iid) $\text{Unif}(0, 1)$ random variables.

How do we do that? For the less programmatically savvy, one way is to use the `RAND()` function in Excel.

Alternatively, we can use an algorithm to generate *pseudo-random numbers* (PRNs); in other words, a series $R_1, R_2, ...$ of *deterministic* numbers that *appear* to be iid $\text{Unif}(0,1)$. Pick a *seed* integer, $X_0$, and calculate:

$$
X_i = 16087X_{i - 1} \bmod{2^{31} - 1}, \quad i = 1, 2,...
$$

A given value of $X_i$ exists on $[0, 2^{31} - 1)$. To transform a given $X_i$ into the corresponding $R_i$, which exists on $[0, 1)$, we use the following formula:

$$
R_i = X_i /(2^{31} - 1), \quad i = 1, 2,...
$$

Here is how we might program this RNG in Python:

```python
# Tested with Python 3.8.3
# I've done this with a generator. There is probably a better way. I am not a Python expert.

def rng(seed):
    x_i = seed
    while True:
        x_i = 16807 * x_i % (2 ** 31 - 1)
        yield x_i / (2 ** 31 - 1)

gen = rng(12345678)
print(next(gen)) # 0.621834785967057
print(next(gen)) # 0.17724774832709123
print(next(gen)) # 0.0029061334221186738
print(next(gen)) # 0.84338442554855
print(next(gen)) # 0.762040194478836
```

Alternatively, we can use this Fortran implementation.

![](https://assets.omscs.io/notes/2020-08-28-16-37-30.png)

### Demo

In this demo, we will generate exponential random variables using the inverse transform method.

![](https://assets.omscs.io/notes/2020-09-12-17-03-50.png)

In the first column, we generate several thousand uniform random variables using the `RAND()` function. In the second column, we apply the inverse transform method to transform these uniforms into exponential random variables using the following equation, which we derived earlier:

$$
X_i = \frac{-\ln(1 - U_i)}{\lambda} \sim \text{Exp}(\lambda)
$$

Note that since we are looking at exponential random variables for which $\lambda = 1$, the transformation equation simplifies:

$$
X_i = -\ln(1 - U_i) \sim \text{Exp}(1)
$$

On the right-hand side of the spreadsheet, we have constructed a histogram using the exponential random variables with bins of width $0.1$ going from $[0.0, 0.1)$ to $[5.9, 6.0)$. 

Unsurprisingly, the graph resembles that of the pdf for the exponential distribution with $\lambda = 1$. Additionally, the observed mean value is $1.018$, which is quite close to the expected value of this distribution: $1 / \lambda = 1$.

## Spreadsheet Simulation

In this lesson, we will conduct a spreadsheet simulation. These spreadsheets are very useful in business and other applications, and we can use them in certain discrete-event scenarios, such as an MM1 queue.

### Stock Portfolio

We are going to simulate a fake stock portfolio consisting of six stocks from different sectors. We will start out with $\$5000$ worth of each stock, and a stock increases or decreases in value each year according to this expression:

$$
\text{Previous Value } * \max\left[0, \text{Nor}(\mu_i, \sigma_i^2) * \text{Nor}(1, (0.2)^2) \right]
$$

The first normal term describes the behavior of stock $i$. For example, if we are looking at a telecommunications stock, we might expect this stock to increase in value, on average, by 8%, so $\mu_i$ might be $1.08$. On the other hand, the stock might also be highly volatile, so we might expect the standard deviation of the returns might be 20%: $\sigma_i = 0.2$.

The second normal term captures market movement as a whole. Stocks tend to move with the market. Perhaps the entire market is up for all stock sectors, or perhaps it is a bad year, and the whole market is down. In this case, the market on average stays about the same - $\mu_M = 1$ - but it experiences high volatility: $\sigma_M = 0.2$.

Of course, stock prices can't dip below zero. As a result, we have to take the maximum of zero and the computed stock price to ensure that we don't calculate a negative value.

### Generating Normals in Excel

To generate a normal random variable in Excel, we can use the following command:

```bash
NORM.INV(RAND(), mu, sigma)
```

Remember that `RAND()` gives us a uniform random variable between $0$ and $1$, so we are essentially using the inverse transform method here to turn a uniform random variable into a normal random variable parameterized by `mu` and `sigma`.

### Example

Consider the following spreadsheet.

![](https://assets.omscs.io/notes/2020-09-12-22-26-36.png)

For each sector, we can see the mean and standard deviation for the expected returns in the first two columns. For example, energy has an expected return of $5\%$ but has a standard deviation of $30\%$.

Across the top, we see the overall market movement. For these five years, the market returned $18\%$, $-8\%$, $-4\%$, $11\%$, and $-15\%$.

For each sector, we can see the year over year returns, and we can see the total portfolio returns at the bottom of each year column. Finally, we see the final portfolio value in the bottom-left cell, and we see a chart plotting the portfolio performance below.

Our portfolio performed excellently for this particular simulation: starting with $\$30000$ and ending with $\$85454$ marks an almost $200\%$ return.

Notice that both the yearly performances of the individual stocks, as well as the yearly market performances, are normal random variables. If we rerun the simulation, these values will change, and we should expect to see a different overall portfolio performance.

Let's look at a second simulation. We did even better this time, returning $\$92289$ on a $\$30000$ investment.

![](https://assets.omscs.io/notes/2020-09-12-22-35-59.png)

Let's look at a final example. This time, we lost money. We started with $\$30000$ and lost more than a third, ending at $\$18789$.

![](https://assets.omscs.io/notes/2020-09-12-22-38-27.png)

We can repeat this experiment thousands of times and generate statistics to describe this portfolio.

---
id: simulation-notes-calculus-probability-statistics-primers
title: Calculus, Probability, and Statistics Primers
course: simulation
lecture: calculus-probability-statistics-primers
---

# Calculus, Probability, and Statistics Primers

## Calculus Primer (OPTIONAL)

In this lesson, we are going to take a quick review of calculus. If you are already familiar with basic calculus, there is nothing new here; regardless, it may be helpful to revisit these concepts.

### Calculus Primer

Suppose that we have a function, $f(x)$, that maps values of $x$ from a domain, $X$, to a range, $Y$. We can represent this in shorthand as: $f(x) : X \to Y$.

For example, if $f(x) = x^2$, then $f(x)$ maps values from the set of real numbers, $\mathbb{R}$, to the nonnegative portion of that set, $\mathbb{R^+}$.

We say that $f(x)$ is **continuous** if, $f(x)$ exists for all $x \in X$ and, for any $x_0, x \in X$, $\lim_{x \to\ x_0} f(x) = f(x_0)$. Here, "lim" refers to [limit](https://en.wikipedia.org/wiki/Limit_(mathematics)).

For example, the function $f(x) = 3x^2$ is continuous for all $x$. However, consider the function $f(x) = \lfloor{x}\rfloor$, which rounds down $x$ to the nearest integer. This function is not continuous and has a [jump discontinuity](https://en.wikipedia.org/wiki/Classification_of_discontinuities#Jump_discontinuity) for any integer $x$. Here is a [graph](https://en.wikipedia.org/wiki/Floor_and_ceiling_functions#/media/File:Floor_function.svg).

If $f(x)$ is continuous, then the **derivative** at $x$ - assuming that it exists and is well-defined for any $x$ - is:

$$
\frac{d}{dx} f(x) \equiv f'(x) \equiv \lim_{h \to\ 0} \frac{f(x + h) - f(x)}{h}
$$

Note that we also refer to the derivative at $x$ as the instantaneous slope at $x$. The expression $f(x + h) - f(x)$ represents the "rise", and $h$ represents the "run". As $h \to 0$, the slope between $(x, f(x))$ and $(x + h, f(x + h))$ approaches the instantaneous slope at $(x, f(x))$.

### Some Old Friends

Let's revisit the derivative of some common expressions.

- The derivative of a constant, $a$, is $0$. 
- The derivative of a polynomial term, $x^k$, is $kx^{k-1}$. 
- The derivative of $e^x$ is $e^x$.
- The derivative of $\sin(x)$ is $\cos(x)$.
- The derivative of $\cos(x)$ is $-\sin(x)$. 
- The derivative of the natural log of $x$, $\ln(x)$ is $\frac{1}{x}$. 
- Finally, the derivative of $\arctan(x)$ is equal to $\frac{1}{1+x^2}$

Now let's look at some well-known properties of derivatives. The derivative of a function times a constant value is equal to the derivative of the function times the constant:

$$
\left[af(x)\right]' = af'(x)
$$

The derivative of the sum of two functions is equal to the sum of the derivatives of the functions:

$$
\left[f(x) + g(x)\right]' = f'(x) + g'(x)
$$

The derivative of the product of two functions follows this rule:

$$
\left[f(x)g(x)\right]' = f'(x)g(x) + g'(x)f(x)
$$

The derivative of the quotient of two functions follows this rule:

$$
\left[\frac{f(x)}{g(x)}\right]' = \frac{g(x)f'(x) - f(x)g'(x)}{g^2(x)}
$$

We can remember this quotient rule with the following pneumonic, referring to the numerator as "hi" and the denominator as "lo": "lo dee hi minus hi dee lo over lo lo".

Finally, the derivative of the composition of two functions follows this rule:

$$
\left[f(g(x))\right]' = f'(g(x))g'(x)
$$

### Example

Let's look at an example. Suppose that $f(x) = x^2$ and $g(x) = \ln(x)$. From our initial derivative rules, we know that $f'(x) = 2x$ and $g'(x) = \frac{1}{x}$.

Let's calculate the derivative of the product of $f(x)$ and $g(x)$:

$$
\left[f(x)g(x)\right]' = f'(x)g(x) + g'(x)f(x)
$$

$$
\left[f(x)g(x)\right]' = 2x\ln{x} + \frac{x^2}{x} = 2x\ln{x} + x
$$

Let's calculate the derivative of the quotient of $f(x)$ and $g(x)$:

$$
\left[\frac{f(x)}{g(x)}\right]' = \frac{g(x)f'(x) - f(x)g'(x)}{g^2(x)}
$$

$$
\left[\frac{f(x)}{g(x)}\right]' = \frac{2x\ln{x} - x}{\ln^2{x}}
$$

Let's calculate the derivative of the composition $f(g(x))$:

$$
\left[f(g(x))\right]' = f'(g(x))g'(x)
$$

$$
\left[f(g(x))\right]' = \frac{2\ln(x)}{x}
$$

The expression $f'(g(x))$ might look tricky at first. Remember that $f(x) = x^2$, so $f'(x) = 2x$. Thus, $f'(g(x)) = 2g(x) = 2\ln(x)$.

### Second Derivatives

The second derivative of $f(x)$ equals the derivative of the first derivative of $f(x)$: $f^{\prime\prime}(x) = \frac{d}{dx}f'(x)$. We spoke of the first derivative as the instantaneous slope of $f(x)$ at $x$. We can think of the second derivative as the slope of the slope.

A classic example comes from physics. If $f(x)$ describes the position of an object, then $f'(x)$ describes the object's velocity and $f^{\prime\prime}(x)$ describes the object's acceleration.

So why do we care about second derivatives?

A minimum or maximum of $f(x)$ can only occur when the slope of $f(x)$ equals $0$; in other words, when $f'(x) = 0$. Mentally visualizing the peaks and valleys of graphs of certain functions may help in understanding why this is true.

Consider a point, $x_0$, such that $f'(x_0) = 0$. If $f^{\prime\prime}(x_0) < 0$, then $f(x_0)$ is a maximum. If $f^{\prime\prime}(x_0) > 0$, then $f(x_0)$ is a minimum. If $f^{\prime\prime}(x_0) = 0$, then $f(x_0)$ is an [inflection point](https://en.wikipedia.org/wiki/Inflection_point).

### Example

Consider the function $f(x) = e^{2x} + e^{-x}$. We want to find a point, $x_0$, that minimizes $f$. Let's first compute the derivative, using the composition rule for each term:

$$
f'(x) = \left[e^{2x} + e^{-x}\right]' = 2e^{2x} - e^{-x}
$$

Let's find $x_0$ such that $f'(x_0) = 0$. 

$$
2e^{2x} - e^{-x} = 0
$$

$$
2e^{2x} = e^{-x}
$$

$$
\frac{e^{-x}}{e^{2x}} = 2
$$

$$
\ln(\frac{e^{-x}}{e^{2x}}) = \ln(2)
$$

$$
\ln(e^{-x}) - \ln({e^{2x}}) = \ln(2)
$$

$$
-x - 2x = \ln(2)
$$

$$
-3x = \ln(2)
$$

$$
x = \frac{\ln(2)}{-3} \approx -0.231
$$

Now, let's calculate $f^{\prime\prime}(x)$:

$$
f^{\prime\prime}(x) = \left[2e^{2x} - e^{-x}\right]' = 4e^{2x} + e^{-x}
$$

Let's plug in $x_0$:

$$
f^{\prime\prime}(-0.231) = 4e^{2 * -0.231} + e^{0.231}\approx 3.78
$$

Since this value is positive, $f(x_0)$ is a minimum. Furthermore, since $e^x > 0$ for all $x$, $f^{\prime\prime}(x) > 0$ for all $x$. This means that $f(x_0)$ is not only a *local* minimum, but specifically is the *global* minimum of $f(x)$.

## Saved By Zero! Solving Equations (OPTIONAL)

In this lesson, we are going to look at formal ways to find solutions to nonlinear equations. We will use these techniques several times throughout the course, as solving equations is useful in a lot of different methodologies within simulation.

### Finding Zeroes

When we talk about solving a nonlinear equation, $f$, what we mean is finding a value, $x$, such that $f(x) = 0$.

There are a few methods by which we might find such an $x$:

- trial and error (not so good)
- bisection (divide and conquer)
- [Newton's method](https://en.wikibooks.org/wiki/Calculus/Newton%27s_Method) or some variation
- Fixed-point method

### Example

Let's remind ourselves of an example from the previous lesson.

Consider the function $f(x) = e^{2x} + e^{-x}$. We want to find a point, $x_0$, that minimizes $f$. Let's first compute the derivative, using the composition rule for each term:

$$
f'(x) = \left[e^{2x} + e^{-x}\right]' = 2e^{2x} - e^{-x}
$$

Let's find $x_0$ such that $f'(x_0) = 0$. 

$$
2e^{2x} - e^{-x} = 0
$$

$$
2e^{2x} = e^{-x}
$$

$$
\frac{e^{-x}}{e^{2x}} = 2
$$

$$
\ln(\frac{e^{-x}}{e^{2x}}) = \ln(2)
$$

$$
\ln(e^{-x}) - \ln({e^{2x}}) = \ln(2)
$$

$$
-x - 2x = \ln(2)
$$

$$
-3x = \ln(2)
$$

$$
x = \frac{\ln(2)}{-3} \approx -0.231
$$

Now, let's calculate $f^{\prime\prime}(x)$:

$$
f^{\prime\prime}(x) = \left[2e^{2x} - e^{-x}\right]' = 4e^{2x} + e^{-x}
$$

Let's plug in $x_0$:

$$
f^{\prime\prime}(-0.231) = 4e^{2 * -0.231} + e^{0.231}\approx 3.78
$$

Since this value is positive, $f(x_0)$ is a minimum. Furthermore, since $e^x > 0$ for all $x$, $f^{\prime\prime}(x) > 0$ for all $x$. This means that $f(x_0)$ is not only a *local* minimum, but specifically is the *global* minimum of $f(x)$.

### Bisection

Suppose we have a function, $g(x)$, and suppose that we can find two values, $x_1$ and $x_2$, such that $g(x_1) < 0$ and $g(x_2) > 0$. Given these conditions, we know, via the [intermediate value theorem](https://en.wikipedia.org/wiki/Intermediate_value_theorem), that there must be a solution in between $x_1$ and $x_2$. In other words, there exists $x^* \in [x_1, x_2]$ such that $g(x^*) = 0$.

To find $x^*$, we first compute $x_3 = \frac{x_1 + x_2}{2}$. If $g(x_3) < 0$, then we know that $x^*$ exists on $[x_3, x_2]$. Otherwise, if $g(x_3) > 0$, then $x^*$ exists on $[x_1, x_3]$. We call this method **bisection** because we bisect the search interval - we cut it in half - on each round. We continue bisecting until the length of the search interval is as small as desired. See [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm).

### Example

Now we are going to use bisection to find the solution to $g(x) = x^2 - 2$. Of course, we know analytically that $g(\sqrt{2}) = 0$, so we are essentially using bisection here to approximate $\sqrt{2}$.

Let's pick our two starting points, $x_1 = 1$ and $x_2 = 2$. Since $f(x_1) = -1$ and $f(x_2) = 2$, we know, from the intermediate value theorem, that there must exist an $x^* \in [1, 2]$ such that $f(x^*) = 0$.

We consider a point, $x_3$, halfway between $x_1$ and $x_2$: $x_3 = \frac{1 + 2}{2} = 1.5$. Since $f(x_3) = 0.25$, we know that $x^*$ lies on the interval $[1, 1.5]$.

Similarly, we can consider a point, $x_4$, halfway between $x_1$ and $x_3$: $x_4 = \frac{1 + 1.5}{2} = 1.25$. Since $f(x_4) = -0.4375$, we know that $x^*$ lies on the interval $[1.25, 1.5]$.

Let's do this twice more. $x_5 = \frac{1.25 + 1.5}{2} = 1.375$. $f(x_5) = -0.109$, so $x^*$ lies on the interval $[1.375, 1.5]$. $x_6 = \frac{1.375 + 1.5}{2} = 1.4375$. $f(x_6) = 0.0664$, so $x^*$ lies on the interval $[1.375, 1.4375]$.

We can see that our search is converging to $\sqrt{2} \approx 1.414$.

### Newton's Method

Suppose that, for a function $g(x)$, we can find a reasonable first guess, $x_0$, for the solution of $g(x)$. If $g(x)$ has a derivative that isn't too flat near the solution, then we can iteratively refine our estimate of the solution using the following sequence:

$$
x_{i+1} = x_i - \frac{g(x_i)}{g'(x_i)}
$$

We continue iterating until the sequence appears to converge.

### Example

Let's try out Newton's method for $g(x) = x^2 - 2$. We can re-express the sequence above as follows:

$$
x_{i+1} = x_i - \frac{x_i^2 - 2}{2x_i}
$$

$$
x_{i+1} = x_i - (\frac{x_i}{2} - \frac{1}{x_i})
$$

$$
x_{i+1} = \frac{x_i}{2} + \frac{1}{x_i}
$$


Let's start with a bad guess, $x_0 = 1$. Then:

$$
x_1 = \frac{x_0}{2} + \frac{1}{x_0} = \frac{1}{2} + \frac{1}{1} = 1.5
$$

$$
x_2 = \frac{x_1}{2} + \frac{1}{x_1} = \frac{1.5}{2} + \frac{1}{1.5} \approx 1.4167
$$

$$
x_3 = \frac{x_2}{2} + \frac{1}{x_2} = \frac{1.4167}{2} + \frac{1}{1.4167} \approx 1.4142
$$

After just three iterations, we have approximated $\sqrt{2}$ to four decimal places!

## Integration (OPTIONAL)

What goes up, must come down. A few lessons ago, we looked at derivatives. In this lesson, we will focus on integration.

### Integration

A function, $F(x)$, having derivative $f(x)$ is called the **antiderivative**. The antiderivative, also referred to as the **indefinite integral** of $f(x)$, is denoted $F(x) = \int{f(x)dx}$.

The [fundamental theorem of calculus](https://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus) states that if $f(x)$ is continuous, then the area under the curve for $x \in [a, b]$ is given by the **definite integral**:

$$
\int^b_a f(x)dx \equiv F(x) \Big|^b_a \equiv F(b) - F(a)
$$

### Friends of Mine

Let's look at some indefinite integrals:

$$
\int x^kdx = \frac{x^{k + 1}}{k+ 1} + C, k \neq -1
$$

$$
\int \frac{dx}{x} = \ln|x| + C
$$

$$
\int e^xdx = e^x + C
$$

$$
\int cos(x)dx = sin(x) + C
$$

$$
\int \frac{dx}{1 + x^2} = \arctan(x) + C
$$

Note that $C$ is a constant value. Consider a function $f(x)$. Since the derivative of a constant value is zero, $f'(x) = \left[f(x) + C\right]'$. When we integrate $f'(x)$, we need to re-include this constant expression: $\int f'(x) = f(x) + C$.

Let's look at some well-known properties of definite integrals.

The integral of a function from $a$ to $a$ is zero:

$$
\int_a^a f(x)dx = 0
$$

The integral of a function from $a$ to $b$ is the negative of the integral from $b$ to $a$:

$$
\int_a^b f(x)dx = -\int_b^a f(x)dx
$$

Given a third point, $c$, the integral of a function from $a$ to $b$ is the sum of the integrals from $a$ to $c$ and $c$ to $b$:

$$
\int_a^b f(x)dx = \int_a^c f(x)dx + \int_c^b f(x)dx
$$

Furthermore, the integral of a sum is the sum of the integrals:

$$
\int \left[f(x) + g(x) \right]dx = \int f(x)dx + \int g(x)dx
$$

Similar to the product rule for derivatives, we integrate products using [integration by parts](https://en.wikipedia.org/wiki/Integration_by_parts):

$$
\int f(x)g'(x)dx = f(x)g(x) - \int g(x)f'(x)dx
$$

Similar to the chain rule for derivatives, we integrate composed functions using the [substitution rule](https://en.wikipedia.org/wiki/Integration_by_substitution), substituting $u$ for $g(x)$:

$$
\int f(g(x))g'(x)dx = \int f(u)du, \text{ where } u = g(x) 
$$

### Example

Let's look at an example. Given $f(x) = x$ and $g'(x) = e^{2x}$, let's compute the integral of $f(x)g'(x)dx$ from $[0, 1]$.

We know, via integration by parts, that:

$$
\int_0^1 f(x)g'(x)dx = f(x)g(x)\Big|_0^1 - \int_0^1 g(x)f'(x)dx
$$

Notice that we need to take the integral of $g'(x)$. We can calculate this using u-substitution. Let $a(x) = 2x$ and $b(x) = e^x$. Then, using the substitution rule above:

$$
\int b(a(x))a'(x)dx = \int b(u)du, \text{ where } u = a(x) 
$$

Note that $a'(x) = 2$, and $b(a(x)) = b(2x) = e^{2x} = g'(x)$. Thus,

$$
\int 2g'(x)dx = \int e^udu, \text{ where } u = a(x)
$$

Divide both sides by two:

$$
\int g'(x)dx = \frac{1}{2}\int e^udu, \text{ where } u = a(x)
$$

Integrate:

$$
g(x) + C = \frac{1}{2} e^u + C, \text{ where } u = a(x)
$$

Subtract $C$ from both sides and substitute:

$$
g(x) = \frac{1}{2} e^{2x}
$$

Now that we know $g(x)$, let's return to our integration by parts:

$$
\int_0^1 f(x)g'(x)dx = f(x)g(x)\Big|_0^1 - \int_0^1 g(x)f'(x)dx
$$

Let's substitute in the appropriate values for $f(x)$, $f'(x)$ and $g(x)$:

$$
\int_0^1 xe^{2x}dx = \frac{1}{2} xe^{2x}\Big|_0^1 - \int_0^1 \frac{1}{2} e^{2x}dx
$$

Let's pull out the $\frac{1}{2}$:

$$
\int_0^1 xe^{2x}dx = \frac{1}{2} \left(xe^{2x}\Big|_0^1 - \int_0^1 e^{2x}dx\right)
$$

Of course, we already know how to integrate $e^{2x}$:

$$
\int_0^1 xe^{2x}dx = \frac{1}{2} \left(xe^{2x}\Big|_0^1 - \frac{1}{2}e^{2x}\Big|_0^1\right)
$$

Now, let's solve:

$$
\int_0^1 xe^{2x}dx = \frac{1}{2} \left(\left(e^{2} - \frac{1}{2}e^{2}\right) - \left(0 - \frac{1}{2}e^0\right)\right)
$$

$$
\int_0^1 xe^{2x}dx = \frac{1}{2} \left(\frac{e^{2}}{2} + \frac{1}{2}\right)
$$

$$
\int_0^1 xe^{2x}dx = \frac{e^{2}}{4} + \frac{1}{4}
$$

### Taylor and Maclaurin Series

Derivatives of arbitrary order $k$ can be written as $f^{(k)}(x)$ or $\frac{d^k}{dx^k}f(x)$. By convention, $f^{(0)}(x) = f(x)$.

The **Taylor series expansion** of $f(x)$ about a point $a$ is given by the following infinite sum:

$$
f(x) = \sum_{k = 0}^\infty \frac{f^{(k)}(a)(x - a)^k}{k!}
$$

The **Maclaurin series expansion** of $f(x)$ is simply the Taylor series about $a = 0$:

$$
f(x) = \sum_{k = 0}^\infty \frac{f^{(k)}(0) * x^k}{k!}
$$

### Maclaurin Friends

Let's look at some familiar Maclaurin series:

$$
\sin(x) = \sum_{k = 0}^\infty \frac{-1^{k + 1} * x^{2k + 1}}{(2k + 1)!}
$$

$$
\cos(x) = \sum_{k = 0}^\infty \frac{-1^{k} * x^{2k}}{(2k)!}
$$

$$
e^x = \sum_{k = 0}^\infty \frac{x^{k}}{k!}
$$

### While We're At It...

Let's look at some other sums, unrelated to Taylor or Maclaurin series, that are helpful to know.

The sum of all the integers between 1 and $n$ is given by the following equation:

$$
\sum_{k = 1}^\infty k = \frac{n(n + 1)}{2}
$$

Similarly, if we want to add the sum of the squares of all the integers between 1 and $n$, we can use this equation:

$$
\sum_{k = 1}^\infty k^2 = \frac{n(n + 1)(2n + 1)}{6}
$$

Finally, if we want to sum all of the powers of $p$, and $-1 < p < 1$, we can use this equation:

$$
\sum_{k = 0}^\infty p^k = \frac{1}{1 - p}
$$

### L'Hôspital's Rule

Occasionally, we run into trouble when we encounter indeterminate ratios of the form $0/0$ or $\infty/\infty$. L'Hôspital's Rule states that, when $\lim_{x \to a}f(x)$ and $\lim_{x \to a}g(x)$ both go to zero or both go to infinity, then:

$$
\lim_{x \to a}\frac{f(x)}{g(x)} = \lim_{x \to a}\frac{f'(x)}{g'(x)}
$$

For example, consider the following limit:

$$
\lim_{x \to 0}\frac{\sin(x)}{x}
$$

As $x \to 0$, $\sin(x) \to 0$. Thus, we can apply L'Hôspital's Rule:

$$
\lim_{x \to 0}\frac{\sin(x)}{x} = \lim_{x \to 0}\frac{\cos(x)}{1} = 1
$$

## Integration Computer Exercises (OPTIONAL)

In this lesson, we will demonstrate several numerical techniques that we might need to use if we can't find a closed-form solution to a function we are integrating. One of these techniques incorporates simulation! 

### Riemann Sums

Suppose we have a continuous function, $f(x)$, under which we'd like to approximate the area from $a$ to $b$. We can fit $n$ adjacent rectangles between $a$ and $b$, such that each rectangle has a width $\Delta x = (b - a) / n$ and a height $f(x_i)$, where $x_i$ = $a + i\Delta x$ is the right-hand endpoint of the $i$th rectangle.

The sum of the areas of the rectangles approximates the area under $f(x)$ from $a$ to $b$, which is equal to the integral of $f(x)$ from $a$ to $b$:

$$
\int_a^b f(x)dx \approx \sum_{i = 1}^{n}\left[f(x_i)\Delta x)\right]
$$

We can simplify the right-hand side of the equation by pulling the $\Delta x$ term out in front of the sum and substituting in the appropriate values for $x_i$:

$$
\sum_{i = 1}^{n}\left[f(x_i)\Delta x)\right] = \frac{b - a}{n} \sum_{i = 1}^{n} f\left(a + \frac{i(b-a)}{n}\right) \approx \int_a^b f(x)dx
$$

As $n \to \infty$, this approximation becomes an equality.

### Example

Suppose we have a function, $f(x) = \sin((\pi x) / 2)$, which we would like to integrate from $0$ to $1$. In other words, we want to compute:

$$
\int_0^1\sin\left(\frac{\pi x}{2}\right)
$$

We can approximate the area under this curve using the following formula:

$$
\int_a^b f(x)dx \approx \frac{b - a}{n} \sum_{i = 1}^{n} f\left(a + \frac{i(b-a)}{n}\right)
$$

Let's plug in $a = 0$ and $b = 1$:

$$
\int_0^1 f(x)dx \approx \frac{1}{n} \sum_{i = 1}^{n} f\left(\frac{i}{n}\right)
$$

Finally, let's replace $f$:

$$ 
\int_0^1 f(x)dx \approx  \frac{1}{n} \sum_{i = 1}^{n} \sin\left(\frac{\pi i}{2n}\right)
$$

For $n = 100$, this sum calculates out to approximately $0.6416$, which is pretty close to the true answer of $2/\pi \approx 0.6366$. For $n = 1000$, our estimate improves to approximately $0.6371$.

### Trapezoid Rule

Here we are going to perform the same type of numerical integration, but we are going to use the trapezoid rule instead of the rectangle rule/Reimann sum. Under this rule:

$$
\int_a^b f(x)dx \approx \left[\frac{f(x_0)}{2} + \sum_{i = 1}^{n - 1} f(x_i) + \frac{f(x_n)}{2} \right]\Delta x
$$

Substituting $a$ and $b$ simplifies the right-hand side of the formula:

$$
 \int_a^b f(x)dx \approx \frac{b - a}{n} \left[\frac{f(a)}{2} + \sum_{i = 1}^{n - 1} f\left(a + \frac{i(b-a)}{n}\right) + \frac{f(b)}{2}\right]
$$

### Example

Suppose we have a function, $f(x) = \sin((\pi x) / 2)$, which we would like to integrate from $0$ to $1$. In other words, we want to compute:

$$
\int_0^1\sin\left(\frac{\pi x}{2}\right)
$$

We can approximate the area under this curve using the following formula:

$$
\int_a^b f(x)dx \approx \frac{b - a}{n} \left[\frac{f(a)}{2} + \sum_{i = 1}^{n - 1} f\left(a + \frac{i(b-a)}{n}\right) + \frac{f(b)}{2}\right]
$$

Let's plug in $a = 0$ and $b = 1$:

$$
\int_0^1 f(x)dx \approx \frac{1}{n} \left[\frac{f(0)}{2} + \sum_{i = 1}^{n - 1} f\left(\frac{i}{n}\right) + \frac{f(1)}{2}\right]
$$

Let's replace $f$:

$$ 
\int_0^1 f(x)dx \approx \frac{1}{n} \left[\frac{\sin(0)}{2} + \sum_{i = 1}^{n - 1} \sin\left(\frac{\pi i}{2n}\right) + \frac{\sin(\pi / 2)}{2}\right]
$$

Finally, let's evaluate and simplify:

$$ 
\int_0^1 f(x)dx \approx \frac{1}{n} \left[\sum_{i = 1}^{n - 1} \sin\left(\frac{\pi i}{2n}\right) + \frac{1}{2}\right]
$$

For $n = 100$, this sum calculates out to approximately $0.63661$, which is very close to the true answer of $2/\pi \approx 0.63662$. Note that, even when $n = 1000$, the Reimann estimation was not this precise;  indeed, integration via the trapezoid rule often converges faster than the Reimann approach.

### Monte Carlo Approximation

Suppose that we can generate an independent and identically distributed sequence of numbers, $U_1, U_2, ..., U_n$, sampled randomly from a uniform $(0, 1)$ distribution. If so, it can be shown that we can approximate the integral of $f(x)$ from $a$ to $b$ according to the following formula:

$$
\int_a^b f(x)dx \approx \frac{b - a}{n} \sum_{i = 1}^n f(a + U_i(b - a))
$$

Note that this looks a lot like the Reimann integral summation. The difference is that these rectangles are not adjacent, but rather scattered randomly between $a$ and $b$. As $n \to \infty$, the approximation converges to an equality, and it does so about as quickly as the Reimann approach.

### Example
Suppose we have a function, $f(x) = \sin((\pi x) / 2)$, which we would like to integrate from $0$ to $1$. In other words, we want to compute:

$$
\int_0^1\sin\left(\frac{\pi x}{2}\right)
$$

We can approximate the area under this curve using the following formula:

$$
\int_a^b f(x)dx \approx \frac{b - a}{n} \sum_{i = 1}^n f(a + U_i(b - a))
$$

Let's plug in $a = 0$ and $b = 1$:

$$
\int_0^1 f(x)dx \approx \frac{1}{n} \sum_{i = 1}^n f(U_i)
$$

Let's replace $f$:

$$
\int_0^1 f(x)dx \approx \frac{1}{n} \sum_{i = 1}^n \sin\left(\frac{\pi U_i}{2}\right)
$$

Here is some python code for how we might simulate this:
```python
# Tested with Python 3.8.3

from random import random
from math import pi, sin

def simulate(n):
  result = 0
  
  for _ in range(n):
    result += sin(pi * random() / 2)
  
  return result / n

trials_100  = sum([simulate(100) for _ in range(100)]) / 100
print(trials_100)

trials_1000 = sum([simulate(100) for _ in range(1000)]) / 1000
print(trials_1000)
```
After running this script once on my laptop, `trials_100` equals approximately $0.6355$, and `trials_1000` equals approximately $0.6366$.

## Probability Basics

In this lesson, we will start our review of probability.

### Basics

Hopefully, we already know the very basics, such as sample spaces, events, and the definition of probability. For example, if someone tells us that some event has a probability greater than one or less than zero, we should immediately know that what they are saying is false.

### Conditional Probability

The probability of some event, $A$, given some other event, $B$, equals the probability of the intersection of $A$ and $B$, divided by the probability of $B$. In other words, the **conditional probability** of $A$ given $B$ is:

$$
P(A|B) = \frac{P(A \cap B)}{P(B)}
$$

Note that we assume that $P(B) > 0$ so we can avoid any division-by-zero errors.

A non-mathematical way to think about conditional probability is the probability that $A$ will occur given some updated information $B$.
For example, think about the probability that your best friend is asleep at any point in time. Now, consider that same probability, given that it's Tuesday at 3 am.

### Example

Let's toss a fair die. Let $A = \{1,2,3\}$ and $B = \{3,4,5,6\}$. What is the probability that the dice roll is in $A$ given that we know it is in $B$? 

We can think about this problem intuitively first. There are four values in $B$, each of which is equally likely to occur. One of those values, three, is also in $A$. If we know that the roll is one of the values in $B$, then there is a one in four chance that the roll is three. Thus, the probability is $1/4$.

We can also use the conditional probability equation to calculate $P(A|B)$:

$$
P(A | B) = \frac{P(A \cap B)}{P(B)}
$$

Let's calculate $P(A \cap B)$. There are six possible rolls total, and $A$ and $B$ share one of them. Therefore, $P(A \cap B) = 1/6$. Now, let's calculate $P(B)$. There are six possible rolls total, and $B$ contains four of them, so $P(B) = 4/6$. As a result: 

$$
P(A | B) = \frac{P(A \cap B)}{P(B)} = \frac{1/6}{4/6} = \frac{1}{4}
$$

Note that $P(A | B) \neq P(A)$. $P(A) = 1/2$. Prior information changes probabilities.

### Independent Events

If $P(A \cap B) = P(A)P(B)$, then $A$ and $B$ are **independent events**. 

For instance, consider the temperature on Mars and the stock price of IBM. Those two events are independent; in other words, the temperature on Mars has no impact on IBM stock, and vice versa.

Let's consider a theorem: if $A$ and $B$ are independent, then $P(A|B) = P(A)$. This means that if $A$ and $B$ are independent, then prior information about $B$ in no way influences that probability of $A$ occurring. 

For example, consider two consecutive coin flips. Knowing that you just flipped heads has no impact on the probability that you will flip heads again: successive coin flips are independent events. However, knowing that it rained yesterday almost certainly impacts the probability that it will rain today. Today's weather is often very much dependent on yesterday's weather.

### Example

Toss two dice. Let $A = \text{Sum is 7}$ and $B = \text{First die is 4}$. Since there are six ways to roll a seven with two dice among thirty-six possible outcomes, $P(A) = 1/6$. Similarly, since there is one way to roll a four among six possible rolls, $P(B) = 1/6$. 

Out of all thirty-six possible dice rolls, only one meets both criteria: rolling a four followed by a three. As a result:

$$
P(A \cap B) = P((4, 3)) = \frac{1}{36} = P(A)P(B)
$$

Because of this equality, we can conclude that $A$ and $B$ are independent events.

### Random Variables

A **random variable**, $X$, is a function that maps the sample space, $\Omega$, to the real line: $X: \Omega \to \mathbb{R}$.

For example, let $X$ be the sum of two dice rolls. What is the sample space? Well, it's the set of all possible combinations of two dice rolls: $\{ (1,1), (1,2), ..., (6,5), (6,6)\}$. What is the output of $X$? It's a real number: the sum of the two rolls. Thus, the function $X$ maps an element from the sample space to a real number. As a concrete example, $X((4,6)) = 10$.

Additionally, we can enumerate the probabilities that our random value takes any specific value within the sample space. We refer to this as $P(X = x)$, where $X$ is the random variable, and $x$ is the observation we are interested in. 

Consider our $X$ above. What is the probability that the sum of two dice rolls takes on any of the possible values?

$$
P(X = x) = \left\{
        \begin{array}{ll}
            1/36 \quad \text{ if } x = 2 \\
            2/36 \quad \text{ if } x = 3 \\
            \vdots \\
            6/36 \quad \text{ if } x = 7 \\
            \vdots \\
            1/36 \quad \text { if } x = 12 \\
            0 \quad\quad \text { otherwise }
        \end{array}
    \right. 
$$

### Discrete Random Variables

If the number of possible values of a random variable, $X$, is finite or countably infinite, then $X$ is a **discrete random variable**. The  **probability mass function** (pmf) of a discrete random variable is given by a function, $f(x) = P(X = x)$. Note that, necessarily, $\sum_xf(x) = 1$.

>By countably infinite, we mean that there could be an infinite number of possible values for $x$, but they have a one-to-one correspondence with the integers.

For example, flip two coins. Let $X$ be the number of heads. We can define the pmf, $f(x)$ as:

$$
f(x) = \left\{
        \begin{array}{ll}
            1/4 \quad \text{ if } x = 0\\
            1/2 \quad \text{ if } x = 1 \\
            1/4 \quad \text{ if } x = 2 \\ 
            0 \quad\quad \text{ otherwise }
        \end{array}
    \right. 
$$

Out of the four possible pairs of coin flips, one includes no heads, two includes one head, and one includes two heads. All other values are impossible, so we assign them all a probability of zero. As expected, the sum of all $f(x)$ for all $x$ equals one.

Some other well-known discrete random variables include Bernoulli($p$), Binomial($n$, $p$), Geometric($p$) and Poisson($\lambda$). We will talk about each of these types of random variables as we need them.

### Continuous Random Variables

We are also interested in continuous random variables. A **continuous random variable** is one that has probability zero for every individual point, and for which there exists a **probability density function** (pdf), $f(x)$, such that $P(X \in A) = \int_A f(x)dx$ for every set $A$. Note that, necessarily, $\int_{\mathbb{R}} f(x) = 1$.

To reiterate, the pdf does not provide probabilities directly like the pmf; instead, we integrate the pdf over the set of events $A$ to determine $P(X \in A)$.

For example, pick a random real number between three and seven. There is an uncountably infinite number of real numbers in this range, and the probability that I pick any particular value is zero. The pdf, $f(x)$, for this continuous random variable is

$$
f(x) = \left\{
        \begin{array}{ll}
            1/4 \quad \text{ if } 3 \leq x \leq 7\\
            0 \quad\quad \text{ otherwise }
        \end{array}
    \right. 
$$

Even though $f(x)$ does not give us probabilities directly, it's the pdf, which means we can integrate it to calculate probabilities.

For instance, what is $P(X \leq 5)$? To calculate this, we need to integrate $f(x)$ from $-\infty$ to $5$. The integral of $f(x)$ from $-\infty$ to $3$ is zero, since the integral of 0 is 0. The integral of $f(x)$ from $3$ to $5$ is $5/4 - 3/4 = 2/4 = 1/2$. Thus, $P(X \leq 5) = 1/2$, which makes sense as we are splitting our range of numbers in half.

Notice that our function describes a rectangle of width $4$ and height $1/4$. If we take the area under the curve of this function - if we integrate it - we get 1.

Some other well-known continuous random variables include Uniform($a$, $b$), Exponential($\lambda$) and Normal($\mu$, $\sigma^2$). We will talk about each of these types of random variables as we need them.

### Notation

Just a note on notation. The symbol $\sim$ means "is distributed as". For instance, $X \sim{\text{Unif}(0,1)}$ means that a random variable, $X$ is distributed according to the uniform $(0, 1)$ probability distribution.

### Cumulative Distribution Function

For a random variable, $X$, either discrete or continuous, the **cumulative distribution function** (cdf), $F(x)$ is the probability that $X \leq x$. In other words,

$$
F(x) \equiv P(X \leq x) = \left\{
        \begin{array}{ll}
            \sum_{y \leq x}f(y) \quad \text{ if } X \text{ is discrete } \\ \\
            \int_{-\infty}^xf(y)dy \quad \text{ if } X \text{ is continuous }
        \end{array}
    \right. 
$$

For discrete random variables, $F(x)$ is equal to the sum of the discrete probabilities for all $y \leq x$. For continuous random variables, $F(x)$ is equal to the integral of the pdf from $-\infty$ to $x$.

Note that as $x \to -\infty$, $F(x) \to 0$ and as $x \to \infty$, $F(x) \to 1$. In other words, $P(x \leq -\infty) = 0$ and $P(x \leq \infty) = 1$. Additionally, if $X$ is continuous, then $F'(x) = f(x)$.

Let's look at a discrete example. Flip two coins and let $X$ be the number of heads. $X$ has the following cdf:

$$
F(x) = \left\{
        \begin{array}{ll}
            0 \quad\quad \text{ if } X < 0 \\
            1/4 \quad \text{ if } 0 \leq X < 1 \\
            3/4 \quad \text{ if } 1 \leq X < 2 \\
            1 \quad\quad \text{ if } X \geq 2 \\
        \end{array}
    \right. 
$$

For any $x < 0$, $P(X \leq x) = 0$. We can't observe fewer than zero heads. For any $0 \leq x < 1$, $P(X \leq x) = 1/4$. $P(X \leq x)$ covers $P(X = 0)$, which is $1/4$. For any $1 \leq x < 2$. $P(X \leq x)$ covers $P(X = 1)$, which is $1/2$, which we add to the previous $1/4$ to get $3/4$. Finally, for $x \geq 2$, $F(x) = 1$, since we have covered all possible outcomes. 

Let's consider a continuous example. Suppose we have $X \sim \text{Exp}(\lambda)$. By definition, $f(x) = \lambda e^{-\lambda x}, x \geq 0$. If we integrate $f(x)$ from $0$ to $x$, we get the cdf $F(x) = 1 - e^{\lambda x}$.

## Simulating Random Variables

In this lesson, we are going to look at simulating some simple random variables using a computer.

### Discrete Uniform Example

For the simplest example, let's consider a discrete uniform distribution, $DU$, from $1$ to $n$: $DU = \{1, 2, ..., n\}$. Let $X = i$ with probability $1/n$ for $i \in DU$. This example might look complicated, but we can think of it basically as an $n$-sided die toss.

If $U$ is a uniform $(0, 1)$ random variable - that is, $U \sim \text{Unif}(0, 1)$ - we can obtain $X \sim DU(1, n)$ through the following transformation: $X = \lceil{nU}\rceil$, where $\lceil\cdot\rceil$ is the "ceiling", or "round up" function.

For example, suppose $n = 10$ and $U \sim \text{Unif}(0, 1)$. If $U = 0.73$, then $X = \lceil{10(0.73)}\rceil = \lceil{7.3}\rceil = 8$.

### Another Discrete Random Variable Example

Let's look at another discrete random variable. Consider the following pmf, $f(x)$ for $X$:

$$
f(x) \equiv P(X = x) = \left\{
        \begin{array}{ll}
            0.25 \quad \text{ if } x -2\\
            0.10 \quad \text{ if } x = 3 \\
            0.65 \quad \text{ if } x = 4.2 \\ 
            0 \quad\quad \text{ otherwise }
        \end{array}
    \right. 
$$

We can't use a die toss to simulate this random variable. Instead, we have to use the **inverse transform method**.

Consider the following table:

$$
\begin{array}{c|c|c|c}
x & f(x) & P(X \leq x) & \text{Unif}(0,1) \\ \hline
-2 & 0.25 & 0.25 & [0.00, 0.25] \\
3 & 0.1 & 0.35 & (0.25, 0.35] \\
4.2 & 0.65 & 1.00 & (0.35, 1.00) \\
\end{array}
$$

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
1 - e^{-\lambda X} = U
$$

$$
-e^{-\lambda X} = U - 1
$$

$$
e^{-\lambda X} = 1 - U
$$

$$
-\lambda X = \ln(1 - U)
$$

$$
X = \frac{-\ln(1 - U)}{\lambda} \sim \text{Exp}(\lambda)
$$

What's the point? Computer programs give us one particular type of randomness. When we use `RAND()` in Excel, or `random.random` in Python, we always get a random variable $U \sim \text{Unif}(0, 1)$. We have shown here that we can take this random variable - the one tool we have available to us - and transform it into any other type of random variable we want. In this particular example, we have shown how to transform $U \sim \text{Unif}(0,1)$ into $X \sim \text{Exp}(\lambda)$.

### Generating Uniforms

All of the examples that we have looked at so far require us to generate "practically" independent and identically distributed (iid) $\text{Unif}(0, 1)$ random variables.

How do we do that? For the less programmatically savvy, one way is to use the `RAND()` function in Excel.

Alternatively, we can use an algorithm to generate *pseudo-random numbers* (PRNs); in other words, a series $R_1, R_2, ...$ of *deterministic* numbers that *appear* to be iid $\text{Unif}(0,1)$. Pick a *seed* integer, $X_0$, and calculate:

$$
X_i = 16087X_{i - 1} \bmod{2^{31} - 1}, \quad i = 1, 2,...
$$

> Note that we saw this random number generator (RNG) in a previous lesson. 

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

### Exercises

![](https://assets.omscs.io/notes/2020-08-28-17-01-39.png)

## Great Expectations

In this lesson, we are going to talk about computing the expected values of random variables. We are going to pay particular attention to something called LOTUS, which we will learn about soon.

### Expected Value

The **expected value** (or mean), of a random variable, $X$ is defined as:

$$
E[X] = \left\{
        \begin{array}{ll}
            \sum_x x f(x) \quad \text{ if X is discrete}\\
            \int_{\mathbb{R}} x f(x) \quad \text{ if X is continuous}
        \end{array}
    \right.
$$

For discrete random variables, the expected value is the sum of $x P(X = x)$ for all possible values of $x$. Likewise, for continuous random variables, the expected value is the integral of $x f(x)dx$ over the real line, $\mathbb{R}$.

In either case, we can think of the expected value as the weighted average of the possible values of $X$, where $x$ is the value and $f(x)$ is the weight given to that value.

### Bernoulli (Discrete) Example

Suppose that $X \sim \text{Bernoulli}(p)$. Then, $X = 1$ with probability $p$ and $X = 0$ with probability $q = 1 - p$. In other words,

$$
X = \left\{
        \begin{array}{ll}
            1 \quad \text{with prob. } p \\
            0 \quad \text{with prob. } q = 1 - p
        \end{array}
    \right. 
$$

What is $E[X]$? Since $X$ is a discrete random variable, we take the weighted average of the discrete values:

$$
E[X] = \sum_x x f(x) = (1 * p) + (0 * q) = p
$$

### Uniform (Continuous) Example

Suppose that we have a random variable $X \sim \text{Unif}(a, b)$. This random variable has the following pdf:

$$
f(x) = \left\{
        \begin{array}{ll}
            \frac{1}{b-a} \quad \text{if } a < x < b \\
            0 \quad\quad \text{otherwise}
        \end{array}
    \right. 
$$

> If this looks foreign to you, recall the example where we generated the pdf for $X \sim \text{Unif}(3,7)$

If we integrate $f(x)$ over $\mathbb{R}$, we get $E[X]$. Note that we really only need to integrate over $(a, b)$ because $f(x)$ evaluates to 0 everywhere else:

$$
E[X] = \int_{\mathbb{R}}x f(x)dx
$$

$$
E[X] = 0 + \int_a^b x f(x)dx + 0
$$

$$
E[X] = \int_a^b \frac{x}{b - a}dx
$$

$$
E[X] = \frac{1}{b-a}\int_a^b xdx
$$

$$
E[X] = \frac{1}{b-a}\left(\frac{x^2}{2}\right)\Big|^b_a
$$

$$
E[X] = \frac{1}{b-a}\left(\frac{b^2}{2} - \frac{a^2}{2}\right)
$$

$$
E[X] = \frac{1}{b-a}\left(\frac{b^2 - a^2}{2}\right)
$$

$$
E[X] = \frac{b^2 - a^2}{2(b-a)}
$$

$$
E[X] = \frac{(b - a)(b + a)}{2(b-a)}
$$

$$
E[X] = \frac{(b + a)}{2}
$$

This result makes sense. Given a random uniform sampling over a range $(a, b)$, the expected value or weighted mean lies in the middle of the range: $(a + b) / 2$.

### Exponential (Continuous) Example

Suppose that we have a random variable, $X \sim \text{Exponential}(\lambda)$. This random variable has the following pdf:

$$
f(x) = \left\{
        \begin{array}{ll}
            \lambda e^{-\lambda x} \quad \text{if } x > 0 \\
            0 \quad\quad\quad \text{otherwise}
        \end{array}
    \right. 
$$

If we integrate $f(x)$ over $\mathbb{R}$, we get $E[X]$. Note that we really only need to integrate over $(0, \infty)$ because $f(x)$ is undefined for $x \leq 0$:

$$
E[X] = \int_{\mathbb{R}} x f(x)dx = \int_0^{\infty} x \lambda e^{-\lambda x}dx = \frac{1}{\lambda}
$$

Computing this integral is left as an exercise to the reader. I am not typing out this whole thing.

### Law of the Unconscious Statistician

Let's look at the **Law of the Unconscious Statistician** (LOTUS). This theorem gives us the expected value of some arbitrary function, $h(X)$, applied to a random variable, $X$. In short,

$$
E[h(X)] = \left\{
        \begin{array}{ll}
            \sum_x h(x)f(x) \quad \text{ if X is discrete}\\
            \int_{\mathbb{R}} h(x)f(x) \quad \text{ if X is continuous}
        \end{array}
    \right.
$$

The function $h(X)$ can be anything "nice" (continuous? differentiable?), like $h(X) = X^2$ or $h(X) = 1/X$ or $h(X) = \sin(X)$ or $h(X) = \ln(X)$.

### Discrete Example

Suppose $X$ is a discrete random variable with the following pmf:

$$
f(x) = \left\{
        \begin{array}{ll}
            0.3 \quad \text{ if } x = 2\\
            0.6 \quad \text{ if } x = 3 \\
            0.1 \quad \text{ if } x = 4 \\ 
            0 \quad\quad \text{ otherwise }
        \end{array}
    \right. 
$$

Suppose we have a function $h(X) = X^3$. We can calculate $E[h(X)] = E[X^3]$ as follows:

$$
E[X^3] = \sum_x x^3 f(x) = 2^3(0.3) + 3^3(0.6) + 4^3(0.1) = 25
$$

### Continuous Example

Suppose we have a random variable $X \sim \text{Unif}(0, 2)$. $X$ has the following pdf:

$$
f(x) = \left\{
        \begin{array}{ll}
            0.5 \quad 0 < x < 2
            0 \quad\quad \text{ otherwise }
        \end{array}
    \right. 
$$

Suppose we have a function $h(X) = X^n$. We can calculate $E[h(X)] = E[X^n]$ by integrating $h(x)f(x)dx$ over the real line, although since we are dealing with a uniform distribution, we only need to integrate from 0 to 2:

$$
E[X^n] = \int_{\mathbb{R}} x^n f(x)dx
$$

$$
E[X^n] = 0 + \int_0^2 \frac{x^n}{2}dx + 0
$$

$$
E[X^n] = \frac{x^{n+1}}{2(n + 1)} \Big|_0^2
$$

$$
E[X^n] = \frac{2^{n+1}}{2(n + 1)} - 0
$$

$$
E[X^n] = \frac{2^{n}}{n + 1}
$$

### Moment, Variance, and Standard Deviation

Given a random variable, $X$, the expected value of $X$ raised to the $n$th power, $E[X^n]$, is the **nth moment** of $X$. Relatedly, the **nth central moment** of $X$ is given as $E[(X - E[X])^n]$.

The **variance** of $X$ is defined as the second central moment of $X$: $\text{Var}(X) = E[(X - E[X])^2]$. From the equation, we can see that the variance of $X$ is the expected value of the squared deviation of $X$ from its mean.

Let's break it down from the inside out. $E[X]$ is the expected value of $X$. $X - E[X]$ captures how far the $X$ tends to deviate from the mean. That deviation could be positive or negative, so we square it to make it positive. Finally, we take the average over all the squared deviances to compute the variance.

Whereas the expected value of $X$ is a measure of the middle of the distribution, the variance of $X$ measures the spread of the distribution.

With a little bit of algebra, we can come up with an alternative equation for the variance: $\text{Var}(X) = E[X^2] - (E[X])^2$.

The **standard deviation** of $X$ is simply the positive square root of the variance of $X$.

### Discrete Example

Suppose we have a random variable $X \sim \text{Bernoulli}(p)$. Recall that $E[X] = p$. Via LOTUS, we know that:

$$
E[X^2] = \sum_x x^2 f(x) = p
$$

Given $E[X^2]$, we can calculate the variance of $X$:

$$
\text{Var}(X) = E[X^2] - E[X]^2 = p - p^2 = p(1 - p)
$$

### Continuous Example

Suppose we have a random variable $X \sim \text{Exp}(\lambda)$. By LOTUS,

$$
E[X^n] = \int_0^\infty x^n \lambda e^{-\lambda x} dx = \frac{n!}{\lambda^n}
$$

Given $E[X^n]$, we can calculate the variance of $X$ using $E[X^2]$ and $E[X]$:

$$
\text{Var}(X) = E[X^2] - E[X]^2 = \frac{2}{\lambda^2} - \left(\frac{1}{\lambda}\right)^2 = \frac{1}{\lambda^2}
$$

### Theorem

Let's consider the following theorem, which shows that expectation is a linear function. In other words:

$$
E[aX + b] = aE[X] + b
$$

Variance works slightly differently:

$$
\text{Var}(aX + b) = a^2 \text{Var}(X)
$$

Note that for variance, the $b$ goes away, and this elimination makes sense. If we have a random variable and we shift if by some constant factor $b$, we haven't changed how much it is spread out, only where it is centered.

### Example

Consider a random variable $X \sim \text{Exp}(3)$. Then:

$$
E[-2X + 7] = -2E[X] + 7 = -2 * \frac{1}{3} + 7 = \frac{19}{3}
$$

$$
\text{Var}(-2X + 7) = (-2)^2\text{Var}(X) = 4 * \frac{1}{9} = \frac{4}{9}
$$

### Moment Generating Functions (Bonus)

Given a random variable, $X$, the **moment generating function** (mgf) of $X$ is defined as $M_X(t) = E[e^{tX}]$. Note that $M_X(t)$ is a function of $t$, not $X$.

### Bernoulli Example

Consider a random variable $X \sim \text{Bernoulli}(p)$. Remember the pmf for $X$:

$$
X = \left\{
        \begin{array}{ll}
            1 \quad \text{with prob. } p \\
            0 \quad \text{with prob. } q = 1 - p
        \end{array}
    \right. 
$$

We can use LOTUS to find $M_X(t)$:

$$
M_X(t) = E[e^{tX}] = \sum_x e^{tx} f(x) = e^t * p + e^0 * q = pe^t + q
$$

### Exponential Example

Consider a random variable $X \sim \text{Exp}(\lambda)$, which has a pdf $f(x) = \lambda e^{-\lambda x}, x > 0$. Again we can use LOTUS to find $M_X(t)$:

$$
M_X(t) = \int_{\mathbb{R}} e^{tx}f(x)dx
$$

$$
M_X(t) = \int_0^\infty e^{tx} \lambda e^{-\lambda x}dx
$$

$$
M_X(t) = \lambda \int_0^\infty e^{tx} e^{-\lambda x}dx
$$

$$
M_X(t) = \lambda \int_0^\infty e^{(t - \lambda)x}dx
$$

$$
M_X(t) = \frac{\lambda}{\lambda - t}, \text{ if } \lambda > t
$$

Note that if $\lambda \leq t$, then the definite integral goes to infinity, so we have to set the constraint that $\lambda > t$.

### Generating Moments (Theorem)

Why do we care about the moment generating function? Well, under certain technical assumptions, the $k$th moment of $X$ is a function of the moment generating function. Specifically,

$$
E[X^k] = \frac{d^k}{dt^k}M_x(t)\Big|_{t = 0} \quad k = 1, 2, ...
$$

In other words, the $k$th moment of $X$ is equal to the $k$th derivative of the mgf (with respect to $t$), evaluated at $t = 0$.

Naturally, we name the moment generating function so because we can use it to generate moments!

### Example

Consider a random variable $X \sim \text{Exp}(\lambda)$, which has an mgf $M_X(t) = \lambda / (\lambda - t), \lambda > t$. Let's generate the first moment of $X$, which is just the expected value, $E[X]$:

$$
E[X] = \frac{d}{dt}M_X(t)\Big|_{t = 0}
$$

$$
E[X] = \frac{d}{dt}\frac{\lambda}{\lambda - t}\Big|_{t = 0}
$$

$$
E[X] = \frac{\lambda}{(\lambda - t)^2}\Big|_{t = 0}
$$

$$
E[X] = \frac{\lambda}{\lambda^2} = \frac{1}{\lambda}
$$

Let's calculate the second moment of $X$, $E[X^2]$:

$$
E[X] = \frac{d^2}{dt^2}M_X(t)\Big|_{t = 0}
$$

$$
E[X] = \frac{d^2}{dt^2}\frac{\lambda}{\lambda - t}\Big|_{t = 0}
$$

$$
E[X] = \frac{d}{dt}\frac{\lambda}{(\lambda - t)^2}\Big|_{t = 0}
$$

$$
E[X] = \frac{\lambda * 2(\lambda - t)}{(\lambda - t)^4}\Big|_{t = 0}
$$

$$
E[X] = \frac{2\lambda}{(\lambda - t)^3}\Big|_{t = 0}
$$

$$
E[X] = \frac{2\lambda}{\lambda^3} = \frac{2}{\lambda^2}
$$

Given the second moment of $X$, we can calculate the variance of $X$:

$$
\text{Var}(X) = E[X^2] - (E[X])^2 = \frac{2}{\lambda^2} - \frac{1}{\lambda^2} = \frac{1}{\lambda^2}
$$

## Functions of a Random Variable

In this lesson, we will explore functions of random variables. In particular, we will focus on how functions change the distribution of the underlying random variable. This analysis has huge implications for the course, especially regarding random variate generation.

### Problem

Suppose we have a random variable, $X$, and we know the pmf/pdf, $f(x)$. Now, let's look at a new random variable, which is a function of $X$, $Y = h(X)$. Our task is to find $g(y)$, the pmf/pdf of Y.

Here are some basic examples, which we won't prove now: 

- If $X \sim \text{Normal}(0, 1)$, then $Y = X^2 \sim \chi^2(1)$, where $\chi^2(k)$ refers to a [chi-square distribution](https://en.wikipedia.org/wiki/Chi-square_distribution). 
- If $U \sim \text{Unif}(0, 1)$, then $Y = -\ln(U) / \lambda \sim \text{Exp}(\lambda)$. We have seen this transformation before.

### Discrete Example

Let $X$ denote the number of heads seen from two coin tosses. We know that $X$ has the following pmf, $f(x)$:

$$
f(x) = \left\{
        \begin{array}{ll}
            1/4, \quad \text{ if } x = 0 \\
            1/2, \quad \text{ if } x = 1 \\
            1/4, \quad \text{ if } x = 2
        \end{array}
    \right. 
$$

How do we compute the pmf, $g(y)$, for $Y = X^3 - X$? Let's map $x$ to $y$:

$$
y = x^3 - x = \left\{
        \begin{array}{ll}
            0, \quad \text{ if } x = 0 \\ 
            0, \quad \text{ if } x = 1 \\
            6, \quad \text{ if } x = 2
        \end{array}
    \right. 
$$

With this correspondence between $x$ and $y$, we can now relate $f(x)$ to $g(y)$. For example, $g(0) = P(Y = 0) = P(X = 0) + P(X = 1) = 3/4$. Similarly, $g(6) = P(Y = 6) = P(X = 2) = 1/4$. Thus, we have the pmf for $Y$:

$$
g(y) = \left\{
        \begin{array}{ll}
            3/4, \quad \text{ if } y = 0 \\
            1/4, \quad \text{ if } y = 6
        \end{array}
    \right. 
$$

### Continuous Example

Suppose a random variable $X$ has a pdf $f(x) = |x|, -1 \leq x \leq 1$. Find the pdf of $Y = X^2$.

First, let's find the cdf of $Y$, $G(y)$. Remember that, for a given value of $y$, the cdf at $y$ is equal to the pdf of all $Y \leq y$. In other words:

$$
G(y) = P(Y \leq y)
$$

Let's substitute $X^2 = Y$:

$$
G(y) = P(X^2 \leq y)
$$

Note that we only know about $X$, not $X^2$, so we take the square root, and rearrange the inequality:

$$
G(y) = P(-\sqrt{y} \leq X \leq \sqrt{y})
$$

By definition, this probability equals the integral of the pdf of $X$ between these two bounds, so we integrate. 

$$
G(y) = \int_{-\sqrt{y}}^{\sqrt{y}} |x|dx
$$

$$
G(y) = \int_{-\sqrt{y}}^{0} -xdx + \int_{0}^{\sqrt{y}} xdx
$$

$$
G(y) = \frac{-x^2}{2} \Big|_{-\sqrt{y}}^0 + \frac{x^2}{2} \Big|_{0}^{\sqrt{y}}
$$

$$
G(y) = 0 + \frac{y}{2} + \frac{y}{2} - 0 = y, \quad 0 < y < 1 
$$

Note that since $x$ is constrained to $[-1, 1]$, $y = x^2$ is constrained to $(0, 1)$.

Remember, the pdf is the derivative of the cdf: $g(y) = G'(y) = 1$. Note that because of the constraint on $y$:

$$
g(y) = \left\{
        \begin{array}{ll}
            1, \quad 0 < y < 1 \\
            0, \quad \text{otherwise}
        \end{array}
    \right. 
$$

This pdf, which should look familiar, describes the random variable $Y \sim \text{Unif}(0,1)$.

### Inverse Transform Method

Let's suppose that $X$ is a continuous random variable with cdf $F(x)$. Then, amazingly, the *random variable* $F(X)$ is a $\text{Unif}(0, 1)$ random variable: $F(X) \sim \text{Unif}(0, 1)$.

### Proof

Let $Y = F(X)$. Then the cdf of $Y$ is, by definition:

$$
P(Y \leq y) 
$$

Let's plug in what $Y$ equals:

$$
P(Y \leq y) = P(F(X) \leq y)
$$

We only know about $X$, not $F(X)$. Let's apply $F^{-1}$ to both sides of the inequality to free up the $X$:

$$
P(Y \leq y) = P(F^{-1}(F(X)) \leq F^{-1}(y)) = P(X \leq F^{-1}(y))
$$

Remember, $F(x) = P(X \leq x)$. Correspondingly, $P(X \leq F^{-1}(y)) = F(F^{-1}(y))$:

$$
P(Y \leq y) = F(F^{-1}(y)) = y
$$

We have just shown that the cdf of $Y = F(X)$ is equal to $y$. The pdf, given that cdf, is 1, which is the pdf for a $\text{Unif}(0, 1)$ random variable. Thus, $F(X) \sim \text{Unif}(0, 1)$.

### Exponential Example

Let's do a simple example to show we can generate random variables. In particular, we want to generate $X \sim \text{Exp}(\lambda)$, and we are going to use the inverse transform method to do this.

Suppose that $X \sim \text{Exp}(\lambda)$, with cdf $F(x) = 1 - e^{-\lambda x}, x \geq 0$. The inverse transform theorem implies that:

$$
F(X) = 1 - e^{-\lambda X} \sim \text{Unif}(0,1)
$$

Let $U \sim \text{Unif}(0, 1)$. Since $F(X)$ is uniform, we can set $F(X) = U$. Now, we can solve for $X$:

$$
F(X) = 1 - e^{-\lambda X} = U
$$

$$
1 - e^{-\lambda X} = U
$$

$$
1 - U = e^{-\lambda X}U
$$

$$
\ln(1 - U) = -\lambda X
$$

$$
\frac{-\ln(1 - U)}{\lambda} = X \sim \text{Exp}(\lambda)
$$

Again, we have just demonstrated how we can transform a random variable from one distribution, $U \sim \text{Unif}(0, 1)$, into a random variable from another distribution: $X \sim \text{Exp}(\lambda)$.

For instance $\lambda = 2$ and $U = 0.27$, then $X = 0.157$ is an $\text{Exp}(2)$ realization.

### Weibull Example

Suppose we have a random variable $X$ with the [Weibull distribution](https://en.wikipedia.org/wiki/Weibull_distribution). $X$ has the following cdf:

$$
F(x) = 1 - e^{-(\lambda x)^\Beta}, x > 0
$$

> Note that if we set $\Beta = 1$, we have the cdf for $X \sim \text{Exp}$ as a special case.

Under the inverse transform method, we can set $F(X) = U$ and then solve for $X$:

$$
U = 1 - e^{-(\lambda X)^\Beta}
$$

$$
1 - U = e^{-(\lambda X)^\Beta}
$$

$$
\ln(1 - U) = -(\lambda X)^\Beta
$$

$$
\left[\ln(1 - U)\right]^{1/\Beta} = -\lambda X
$$

$$
X = \frac{1}{\lambda}\left[\ln(1 - U)\right]^{1/\Beta}
$$

### Bonus Theorem

Here's another way to get the pdf of $Y = h(X)$ for some continuous function $h$. The cdf of $Y$ is:

$$
F_Y(y) = P(Y \leq y) = P(h(X) \leq y) = P(X \leq h^{-1}(y))
$$

Remember, $F_X(x) = P(X \leq x)$. Correspondingly, $P(X \leq h^{-1}(y)) = F_X(h^{-1}(y))$. In other words,

$$
f_Y(y) = \frac{d}{dy}F_Y(y) = \frac{d}{dy} F_X(h^{-1}(y))
$$

Taking advantage of the fact that the derivative of the cdf is the pdf, we can compute the derivative using the chain rule:

$$
\frac{d}{dy} F_X(h^{-1}(y)) = f_X(h^{-1}(y)) \Big|\frac{d}{dy}h^{-1}(y)\Big|
$$

Since the pdf has to be greater than or equal to zero, we have to take the absolute value of the derivative of $h^{-1}(y)$. That way, the product of the two terms is always 0 or positive.

Armed with this result, we can prove LOTUS. Remember the definition for the expected value of a random variable, $Y$:

$$
E[Y] = \int_{\mathbb{R}} y f_Ydy
$$

Remember, we have an expression for $f_Y$:

$$
f_Y(y) = f_X(h^{-1}(y)) \Big|\frac{d}{dy}h^{-1}(y)\Big|
$$

Thus:

$$
E[Y] = \int_{\mathbb{R}} y f_X(h^{-1}(y)) \Big|\frac{d}{dy}h^{-1}(y)\Big| dy
$$

Take it on faith that this expression simplifies to:

$$
E[Y] = \int_{\mathbb{R}} y f_X(h^{-1}(y)) dh^{-1}(y)
$$

If we set $x = h^{-1}(y)$, then you get LOTUS:

$$
E[Y] = \int_{\mathbb{R}} h(x) f_X(x)dx
$$

## Jointly Distributed Random Variables

In this lesson, we will review two-dimensional random variables that may or may not be correlated with each other. As a basic example, think height and weight! 

In simulation, we might be concerned with consecutive correlated waiting times. If we have customers in a line, then obviously the waiting times between customers will be correlated with each other.

### Joint and Marginal CDF

Let's consider two random variables, $X$ and $Y$, interacting together - think height and weight. We can define the **joint cdf** of $X$ and $Y$ as:

$$
F(x, y) \equiv P(X \leq x, Y \leq y), \quad \text{for all } x, y
$$

The **marginal cdf** of $X$ is the cdf of $X$, regardless of $Y$: $F_X(x) = F(x, \infty)$. Similarly, the marginal cdf of $Y$ is $F_Y(y) = F(\infty, y)$.

Let's consider the marginal cdf in the context of height in inches ($X$) and weight in pounds ($Y$). Say we want to compute $F(72, \infty)$. This expression describes the probability of sampling an observation with a height less than 72 inches and a weight less than $\infty$. However, we know that every observation must have a weight less than $\infty$ by the definition of a cdf. As a result, we essentially are removing $Y$ from consideration and focusing just on $X$.

### Joint PMF

If $X$ and $Y$ are discrete random variables, then the **joint pmf** of $X$ and $Y$ is $f(x, y) \equiv P(X = x, Y = y)$. Of course, the sum of the pmf over all $x$ and $y$ is  equal to 1: $\sum_x\sum_y f(x,y) = 1$.

Just as we computed the marginal cdf of $X$ and $Y$, we can also compute the **marginal pmf** of $X$ and $Y$. The marginal pmf of $X$ is $f_X(x) = P(X = x) = \sum_y f(x, y)$. Similarly, the marginal pmf of $Y$ is $f_Y(y) = P(Y = y) = \sum_x f(x,y)$. In either case, we fix one of the two random variables at a certain value and then sum the probabilities over all values of the other random variable at that value.

### Example

Consider the following table, with gives the joint pmf, $f(x,y)$ along with the accompanying marginal pmfs, $f_X(x)$ and $f_Y(y)$ for two random variables, $X$ and $Y$:

$$
\begin{array}{c|ccc|c}
f(x, y) & X = 2 & X = 3 & X = 4 & f_Y(y)  \\ \hline
Y = 4 & 0.3 & 0.2 & 0.1 & 0.6  \\
Y = 6 & 0.1 & 0.2 & 0.1 & 0.4 \\ \hline
f_X(x) & 0.4 & 0.4 & 0.2 & 0.1 \\  
\end{array}
$$

The possible values for $X$ are 2, 3, and 4, and the possible values of $Y$ are 4 and 6. The numbers in the interior of the table give the joint pmf for the corresponding $(Y = y, X = x)$ pair. For example, $f(X = 2, Y = 4) = 0.3$, the upper-leftmost cell in the interior. If we add the interior entries, we get 1: $\sum_x\sum_y f(x, y) = 1$.

Let's look at the marginal pmf for $X$, $f_X(x)$. For $X = 2$, $f_X(2) = \sum_y f(2, y)$. If we expand out the sum, we get $f_X(2) = f(2, 4) + f(2,6) = 0.3 + 0.1 = 0.4$. We can apply similar sums to compute $f_X(3)$ and $f_X(4)$. Of course, $\sum_x f_X(x) = 1$.

Let's look at the marginal pmf for $Y$, $f_Y(y)$. For $Y = 4$, $f_Y(4) = \sum_x f(x, 4)$. If we expand out the sum, we get $f_Y(4) = f(2, 4) + f(3,4) + f(4,4) = 0.3 + 0.2 + 0.1 = 0.6$. We can apply the same logic to compute $f_Y(6)$. Of course, $\sum_y f_Y(y) = 1$.

### Joint PDF

If $X$ and $Y$ are continuous, then the **joint pdf** of $X$ and $Y$ is the second partial derivative of the cdf: $f(x, y) \equiv \partial^2 / \partial x \partial y F(x, y)$. Note that if we take the double integral of the pdf over the real line, we get 1, as per the definition of the pdf: $\int_{\mathbb{R}} \int_{\mathbb{R}} f(x, y)dxdy = 1$. Note that since our pdf is two-dimensional, we need to integrate in both dimensions to sum the probabilities for all possible $(x, y)$ pairs.

Just as we saw with the marginal pmfs previously, we can calculate the **marginal pdfs** of $X$ and $Y$ as:

$$
f_X(x) = \int_{\mathbb{R}} f(x,y)dy, \quad f_Y(y) = \int_{\mathbb{R}} f(x,y)dx
$$

Note that this construction matches the marginal pmf for the discrete variables. The marginal pdf for $X$, $f_X(x)$ equals the sum of the probabilities of $f(x, y)$, over all values of $y$. Similarly, the marginal pdf for $Y$, $f_Y(y)$ equals the sum of the probabilities of $f(x, y)$, over all values of $x$.

### Example

Suppose we have two random variables, $X$ and $Y$, whose joint pdf is the following:

$$
f(x,y) = \frac{21}{4}x^2y, \quad x^2 \leq y \leq 1
$$

Note the limits of $x$ and $y$: $x^2 \leq y \leq 1$. Limits like these have ramifications when it comes to independence, which we are going to talk about shortly.

Let's take a look at the marginal pdfs, $f_X(x)$ and $f_Y(y)$. First, $f_X(x)$:

$$
f_X(x) = \int_{\mathbb{R}} f(x,y)dy
$$

Note that, since we are integrating with respect to $y$, the limits of integration become the limits of $y$. In other words, we integrate from $x^2$ to 1:

$$
f_X(x) = \int_{x^2}^1 \frac{21}{4}x^2ydy
$$

Now, since we are integrating with respect to $y$, the expression $21x^2 / 4$ is a constant, which can move outside the integral:

$$
f_X(x) = \frac{21}{4}x^2 \int_{x^2}^1 ydy
$$

Let's complete the integration:

$$
f_X(x) = \frac{21}{4}x^2 \frac{y^2}{2} \Big|_{x^2}^1
$$

$$
f_X(x) = \frac{21}{4}x^2 \left(\frac{1}{2} - \frac{x^4}{2}\right)
$$

$$
f_X(x) = \frac{21}{8}x^2 \left(1 - x^4\right)
$$

Note that since $x^2 \leq y \leq 1$, $f_X(x)$ is only defined for $-1 \leq x \leq 1$. If $|x| >1$, then $x^2 > 1 > y$, which breaks the inequality.

Now, let's find $f_Y(y)$:

 $$
f_Y(y) = \int_{\mathbb{R}} f(x,y)dx
$$

Note that, since we are integrating with respect to $x$, the limits of integration become the limits of $x$. In other words, since $x^2 \leq y$, then $-\sqrt{y} \leq x \leq \sqrt{y}$, which become our new limits of integration:

$$
f_Y(y) = \int_{-\sqrt{y}}^{\sqrt{y}} \frac{21}{4}x^2ydx
$$

Because we are integrating with respect to $x$, the expression $21y / 4$ is a constant, which can move outside the integral: 

$$
f_Y(y) = \frac{21}{4}y \int_{-\sqrt{y}}^{\sqrt{y}} x^2dx
$$

Let's complete the integration:

$$
f_Y(y) = \frac{21}{4}y \frac{x^3}{3}\Big|_{-\sqrt{y}}^{\sqrt{y}}
$$

$$
f_Y(y) = \frac{21}{4}y \left(\frac{(\sqrt{y})^3}{3} - \frac{(-\sqrt{y})^3}{3}\right)
$$

$$
f_Y(y) = \frac{21}{4}y \left(\frac{y^{3/2}}{3} + \frac{y^{3/2}}{3}\right)
$$

$$
f_Y(y) = \frac{21}{4}y \left(\frac{2y^{3/2}}{3}\right)
$$

$$
f_Y(y) = \frac{42}{12}y^{5/2} = \frac{7}{2}y^{5/2}
$$

Remember the limits: $x^2 \leq y \leq 1$. Since $x^2$ cannot be negative, and $y$ cannot be greater than one, $f_Y(y)$ is only defined for $0 \leq y \leq 1$.

### Independence

Random variables $X$ and $Y$ are **independent** if $f(x, y) = f_X(x)f_Y(y)$ for all $x, y$. Consider the following theorem: $X$ and $Y$ are independent if we can write their joint pdf as $f(x,y) = a(x)b(y)$ for some functions $a(x)$ and $b(y)$ *and* $x$ and $y$ don't have funny limits (their domains don't depend on each other).

### Examples

If $f(x, y) = cxy$ for $0 \leq x \leq 2, 0 \leq y \leq 3$, then $X$ and $Y$ are independent. How can we tell? First of all, if $a(x) = cx$ and $b(y) = y$ then $f(x,y) = a(x)b(y)$. Second, we don't have any funny limits; that is, $x$ and $y$ don't depend on each other.

Let's revisit the pdf $f(x) = 21x^2y/4$, for $x^2 \leq y \leq 1$. In this case, $X$ and $Y$ are not independent. How can we tell? First of all, if $a(x) =  21x^2/4$ and $b(y) = y$, then $f(x,y) = a(x)b(y)$. However, we do have funny limits: $x^2 \leq y \leq 1$ indicates that $x$ constrains $y$, and vice versa.

As a final example, consider $f(x, y) = c/(x + y)$ for $1 \leq x \leq 2, 1 \leq y \leq 3$. In this case, $X$ and $Y$ are not independent. Even though we don't have any funny limits, there are no $a(x)$ and $b(y)$, such that $f(x, y) = a(x)b(y)$.

### Conditional PDF/PMF

The **conditional pdf** (or **pmf**) of $Y$ given $X = x$ is $f(y | x) \equiv f(x,y) / f_X(x)$, assuming $f_X(x) > 0$. This is a legit pdf/pmf. For example, in the continuous case, $\int_{\mathbb{R}} f(y|x)dy = 1$, for any $x$.

### Example

For example, suppose $f(x,y) = 21x^2y/4$ for $x^2 \leq y \leq 1$. We can calculate $f(y|x)$ using $f(x)$ and $f_X(x)$, which we calculated previously:

$$
f(y|x) = \frac{f(x,y)}{f_X(x)}
$$

$$
f(y|x) = \frac{\frac{21}{4}x^2y}{\frac{21}{8}x^2(1-x^4)}
$$

$$
f(y|x) = \frac{\frac{21}{4}y}{\frac{21}{8}(1-x^4)}
$$

$$
f(y|x) = \frac{\frac{21}{4}}{\frac{21}{8}}\frac{y}{(1-x^4)}
$$

$$
f(y|x) = \frac{2y}{1-x^4}, \quad x^2 \leq y \leq 1
$$

Note that the final equation contains both the variables $x$ and $y$. We are querying about $y$, and we have information about $x$ - that's the whole "given $x$" part of the conditional - so the presence of the two variables makes sense.

### Theorem

If $X$ and $Y$ are independent, then $f(y|x) = f_Y(y)$ for all $x,y$. In other words, information about $X$ contributes nothing to the distribution of $Y$. For example, let $X$ equal the current IBM stock price, and $Y$ equal the current temperature on Mars. The information $Y = 30^{\circ}$ gives us no information regarding IBM stock.

Let's prove this theorem. Remember the formula for the conditional pdf, $f(y | x)$:

$$
f(y|x) = \frac{f(x,y)}{f_X(x)}
$$

Remember that if $X$ and $Y$ are independent, then $f(x,y) = f_X(x)f_Y(y)$. So:

$$
f(y|x) = \frac{f_X(x)f_Y(y)}{f_X(x)} = f_Y(y). \quad \square
$$

### Conditional Expectation

If we can compute the conditional pdf/pmf $f(y|x)$, then we can compute the **conditional expection** of $Y$ given $X = x$ as the following:

$$
E[Y|X = x] = \left\{\begin{matrix}
	\sum_yyf(y|x) & \text{discrete} \\
	\int_{\mathbb{R}} yf(y|x)dy & \text{continuous}
\end{matrix}\right.
$$

Conditional expectation is very important as it allows us to update our expectation about $Y$ given information about $X$. For example, suppose that we have a person who is seven feet tall, and we are interested in his expected weight: $E[Y | X = 7]$. The information that he is seven feet tall will give us an expected value for his weight that is probably going to be greater than the expected weight of some random person, about whom we have no height information: $E[Y]$.

### Example

Let $f(x,y) = 21x^2y/4$, if $x^2 \leq y \leq 1$. Then:

$$
E[Y|X] = \int_{\mathbb{R}} yf(y|x)dy
$$

$$
E[Y|X] = \int_{x^2}^1 \frac{2y^2}{1-x^4}dy
$$

$$
E[Y|X] = \frac{2}{1-x^4}\int_{x^2}^1 y^2dy
$$

$$
E[Y|X] = \frac{2}{1-x^4} \left(\frac{y^3}{3}\Big|_{x^2}^1\right)
$$

$$
E[Y|X] = \frac{2}{1-x^4} \left(\frac{1^3}{3} - \frac{x^6}{3}\right) = \frac{2}{3} \times \frac{1-x^6}{1-x^4}
$$

Note that the conditional expectation is a function of $x$, which makes sense: prior information about $x$ changes the expected value of $Y$, and the degree to which this information updates the expected value is a function of $x$.

---
id: robotics-ai-techniques-localization-overview
title: Localization Overview
course: robotics-ai-techniques
lecture: localization-overview
---

# Localization Overview

## Localization

Suppose we are driving a car on a highway, and we'd like to know where we are. These days, many cars and cellphones have applications that interact with the global positioning system, GPS. After receiving a few satellite signals, these apps can show us cruising along as little dots on virtual maps.

Now suppose we are building a self-driving car. Just like a human driver, a robot driver needs to understand where it is within the world. Is it driving inside the lane markers, or is it veering off a cliff?

**Localization** is the process by which the robot establishes its position in the world.

A self-driving car might need to localize on several different scales. For example, to know if it has arrived in its destination city, the car might use GPS.

If the car needs to determine whether it is driving within lane markers, however, GPS is a terrible choice. The margin of error for GPS is 10 meters, which is roughly the width of three highway lanes in the United States. For self-driving cars to be able to stay in lanes using localization, we need a margin of error on the order of magnitude of 2-10cm.

## Total Probability

Let's begin our story with a robot. This robot lives in a world, but, alas, it has no idea where it is in the world.

We can represent the robot's understanding of its current location in the world with a probability distribution, $P(X)$, where $X$ is a location in the world, and $P(X)$ represents the probability that the robot is currently at location $X$.

The probability distribution that our robot starts with - assuming no prior knowledge - is a **discrete uniform distribution**. In other words, the robot is equally likely to be in any of the $n$ locations in the world, each with a probability of $\frac{1}{n}$.

For localization to be possible, the world has to have some distinctive features. Let's assume that there are three different landmarks in the robot's world: the three doors drawn below.

![](https://assets.omscs.io/notes/2020-05-11-18-28-58.png)

Let's also assume that the robot cannot distinguish one door from another but can distinguish a door from a "non-door".

Now suppose that the robot "open its eyes" and senses that it is standing next to a door. This measurement transforms our discrete uniform distribution - the "naive" understanding - into a new probability distribution that looks like this.

![](https://assets.omscs.io/notes/2020-05-11-18-33-58.png)

Relative to the previous understanding of the world, this new understanding associates a higher probability to locations adjacent to doors and a lower probability to all other locations. We refer to this belief about the world as a **posterior belief**, as it was formed after a measurement was taken.

One key aspect of this belief is that the robot still doesn't know where it is; after all, there are three doors. On top of that, we can't rule out the possibility that the sensors are erroneous and the robot saw a door where there was none. While these three bumps express the robot's best belief about where it is, there is a residual probability that the robot is in a non-door location.

Now let's assume the robot moves to the right by a certain distance. We can shift our belief according to the motion. Technically, this "shifting" operation is known as a **convolution**.

![](https://assets.omscs.io/notes/2020-05-11-18-38-58.png)

The robot knows both the direction and magnitude of its movement. Robot motion is somewhat uncertain, however, so the shifted probability distribution has peaks that are shorter and wider.

Assume that the robot senses again, and it senses that it is right next to a door. To obtain our second posterior belief, we multiply our shifted probability distribution with a distribution that looks very similar to our first posterior belief; that is, a distribution with high probabilities at locations associated with doors.

![](https://assets.omscs.io/notes/2020-05-11-18-43-04.png)

In this second posterior belief, the only significant probability peak corresponds to the position of the second door. From the three locations associated with relatively high probability in the prior belief, only one of them corresponds to a door. As a result, this posterior belief amplifies the prior peak associated with the door while effectively muting the other prior peaks.

At this point, our robot has localized itself.

## Uniform Probability Quiz

Consider a robot in a world made up of five cells. The robot is equally likely to occupy any one of the five cells. If we select a cell at random, what is the probability that the robot is occupying that cell?

![](https://assets.omscs.io/notes/2020-05-11-18-52-39.png)

## Uniform Probability Quiz Solution

![](https://assets.omscs.io/notes/2020-05-11-19-23-01.png)

## Uniform Distribution Quiz

Consider a robot in a world made up of five cells. The robot is equally likely to occupy any one of the five cells. Can we modify the list, `p`, below to represent the discrete uniform distribution that describes the probability of finding the robot in each of the five cells?

![](https://assets.omscs.io/notes/2020-05-12-01-33-10.png)

## Uniform Distribution Solution

![](https://assets.omscs.io/notes/2020-05-11-19-33-01.png)

## Generalized Uniform Distribution Quiz

Let's assume that we don't know the dimensions of the world ahead of time. Given a variable, `n`, representing the number of cells in the world, let's write some code to create a list representing the discrete uniform distribution parameterized by `n`.

![](https://assets.omscs.io/notes/2020-05-11-19-35-08.png)

## Generalized Uniform Distribution Solution

![](https://assets.omscs.io/notes/2020-05-11-19-35-59.png)

Note that if we used `1` instead of `1.` in the numerator, we would have a list of zeros because the `/` operator performs integer division in Python 2.7. In Python 3+, this casting is unnecessary as `/` performs float division. 

Alternatively, we can use a list comprehension to create `p`:

```python
p = [1. / n for _ in range(n)]
```

If that wasn't terse enough, this is also valid.

```python
p [1. / n] * n
```

## Probability After Sense Quiz

It's time to add some color to our five-celled world. Let's assume that two of the cells in this world are colored red, whereas the other three are green.

![](https://assets.omscs.io/notes/2020-05-11-20-49-17.png)

As before, we assign a uniform probability of 0.2 to each cell. Now let's assume we allow our robot to sense, and it sees a red color.

How will this affect the robot's belief about where it is located? Intuitively, the probabilities associated with $x_2$ and $x_3$ should increase while the probabilities associated with $x_1$, $x_4$, and $x_5$ should decrease.

We can incorporate this measurement of "red" into our belief using a product. We can multiply the current probability associated with a cell by a large number - say, 0.6 - when the color of the cell is red. Similarly, we can multiply the current probability associated with a cell by a small number - say, 0.2 - when the color of the cell is green.

Looking at the ratio between these two factors, 0.2 and 0.6, we can see that our posterior belief is going to assign probabilities to red cells that are three times larger than those associated with green cells.

For each of these five cells, what is the resulting probability if we apply this update rule?

![](https://assets.omscs.io/notes/2020-05-11-20-54-03.png)

## Probability After Sense Solution

![](https://assets.omscs.io/notes/2020-05-11-20-54-59.png)

We multiply each green cell by 0.2 and each red cell by 0.6. Each red cell becomes 0.04, while each green cell becomes 0.12.

## Compute Sum Quiz

In principle, this new probability function is our next belief. The only problem is that it's not a valid probability distribution because the probabilities do not add up to 1. What is the sum of these probabilities?

![](https://assets.omscs.io/notes/2020-05-11-20-58-03.png)

## Compute Sum Solution

![](https://assets.omscs.io/notes/2020-05-11-20-58-18.png)

## Normalize Distribution Quiz

To turn this probability function into a probability distribution, we normalize the individual probabilities by dividing them by 0.36. What are the normalized values?

![](https://assets.omscs.io/notes/2020-05-11-20-59-32.png)

## Normalize Distribution Solution

![](https://assets.omscs.io/notes/2020-05-11-21-00-32.png)

If we divide 0.12 by 0.36, we get $\frac{1}{3}$. If we divide 0.04 by 0.36, we get $\frac{1}{9}$. The sum of the five probabilities shown above equals 1, which indicates that we have a valid probability distribution.

## pHit and pMiss Quiz

Let `pHit` be the factor by which we multiply cells that match our measurement, and `pMiss` be the factor by which we multiply cells that don't match our measurement. Our task is to write code that outputs the non-normalized posterior probability distribution, using `p`, `pHit`, and `pMiss`, given that positions $x_2$ and $x_3$ are hits.

## pHit and pMiss Solution

![](https://assets.omscs.io/notes/2020-05-11-21-07-11.png)

We can explicitly multiply each value by `pHit` or `pMiss` depending on its index. This solution is not particularly elegant.

Alternatively, we could use the `enumerate` function in Python:

```python
for idx, prob in enumerate(p):
    if idx in [1,2]:
        p[idx] *= pHit
    else:
        p[idx] *= pMiss
```

## Sum of Probabilities Quiz

Since we need the sum of the probabilities to normalize them, let's write some code to compute the sum of the values in `p`.

![](https://assets.omscs.io/notes/2020-05-11-21-10-17.png)

## Sum of Probabilities Solution

![](https://assets.omscs.io/notes/2020-05-11-21-10-37.png)

We can use the builtin `sum` function to sum the elements in `p`.

## Sense Function Quiz

Let's make this code a little bit better. First, we are going to introduce a variable, `world`, which is a list of the colors of the cells in the robot's one-dimensional world.

![](https://assets.omscs.io/notes/2020-05-11-21-12-52.png)

Further, we can define a measurement, `Z`, to be `'"red"`.

![](https://assets.omscs.io/notes/2020-05-11-21-13-50.png)

Now let's define a function, `sense`, which takes as input the initial distribution, `p`, and the measurement, `Z`, and outputs the normalized distribution, `q`. `q` reflects the non-normalized posterior belief created by multiplying the appropriate elements in `p` by `pHit` or `pMiss` in accordance with `Z` and the corresponding elements in `world`.

Our task is to implement `sense`.

![](https://assets.omscs.io/notes/2020-05-11-21-17-10.png)

## Sense Function Solution

![](https://assets.omscs.io/notes/2020-05-11-21-17-31.png)

Alternatively, we can use the `zip` function to combine `p` and `world` and make our lives a little bit easier:

```python
def sense(p, Z):
    q = []

    for pi, loc in zip(p, world):
        q.append(pi * (pHit if Z == loc else pMiss))

    return q
```

If we want to get real fancy, we can even one-line it:

```python
def sense(p, Z):
    return [pi * (pHit if Z == loc else pMiss) for pi, loc in zip(p, world)]
```

## Normalized Sense Function Quiz

Let's modify the `sense` function to return a valid probability distribution. We need to normalize the values in `q` so that they add up to 1.

## Normalized Sense Function Solution

![](https://assets.omscs.io/notes/2020-05-11-21-29-32.png)

We can compute the sum of `q` using the `sum` function and then divide each value in `q` by that sum. With that, we've implemented the critical function of localization, which is called the **measurement update**.

## Test Sense Function Quiz

What happens if our measurement is "green" instead of "red"? Let's change the value of `Z` to `"green"` and see how our new posterior distribution looks.

![](https://assets.omscs.io/notes/2020-05-11-21-36-09.png)

## Test Sense Function Solution

![](https://assets.omscs.io/notes/2020-05-11-21-36-29.png)

We can see that the first, fourth, and fifth values have a much larger value than the second and third; in fact, three times larger.

## Multiple Measurements Quiz

Let's modify the code now to support multiple measurements. Instead of using `Z` to represent a single measurement, let's create a list of measurements, `measurements`.

Our task is to write some code that uses `measurements` and `sense` to return the posterior probability distribution after multiple measurement updates.

![](https://assets.omscs.io/notes/2020-05-11-21-40-23.png)

## Multiple Measurements Solution

![](https://assets.omscs.io/notes/2020-05-11-21-40-43.png)

Since `sense` takes in a probability distribution and a measurement and returns a probability distribution, we can simply iterate over all the measurements in `measurements` and continuously transform the original distribution `p` on each iteration.

## Exact Motion Quiz

Before we finish with localization, let's talk about robot motion. Suppose we have the following probability distribution associated with the five cells in our world.

![](https://assets.omscs.io/notes/2020-05-11-21-45-01.png)

Suppose we know for a fact that the robot moved exactly one grid cell to the right. What is the posterior probability for each of the following cells after that motion?

> Note: We assume that the world is cyclic so that if the robot moves past the leftmost cell, it finds itself in the rightmost cell.

![](https://assets.omscs.io/notes/2020-05-11-21-46-42.png)

## Exact Motion Solution

![](https://assets.omscs.io/notes/2020-05-11-21-47-29.png)

In the case of exact motion, we shift the probabilities by the direction and magnitude of the motion.


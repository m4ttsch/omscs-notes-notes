---
id: robotics-ai-techniques-kinematic-bicycle-model
title: "Kinematic Bicycle Model: 101"
course: robotics-ai-techniques
lecture: kinematic-bicycle-model
---

# Kinematic Bicycle Model: 101

## Topics

This lecture introduces a kinematic motion model known as the **bicycle model**. After we learn the basics of the model, we will examine the types of problems it can help us solve, and we will step through one such problem to solidify our grasp of the material. Along the way, we will derive all the necessary formulas.

## Representation

We typically represent our robots as cars; however, we won't derive the kinematic formulas for a four-wheeled vehicle in this lecture. Instead, we use the bicycle model, which models a two-wheeled vehicle. This model approximates the four-wheeled model while also making the calculations easier.

## Controls

The bicycle model has two controls. The **steering angle**, $\alpha$, is the angle that the front wheel makes with the orientation of the vehicle. $\alpha$ is positive if the wheel is turned to the left, negative if the wheel is turned to the right, and zero if the wheel is straight. The **forward movement**, $\text{d}$, is the difference between the position of the rear axle before and after movement. Unlike the front axle, the rear axle remains parallel to the orientation of the robot and does not swivel.

![The bicycle model controls: steering angle and forward movement.](https://assets.omscs.io/notes/20230220190241.png)

## Robot Pose

The **robot pose** consists of three properties:

- $\text{x}$, the x-coordinate of the robot's position
- $\text{y}$, the y-coordinate of the robot's position
- $\theta$, the robot's orientation (measured from the x-axis)

In the following picture, robots A and C have the same orientation, as do robots B and E, while robots D and E have the same position. None of the robots have the same pose.

![A collection of robots in the (x,y) plane with different poses.](https://assets.omscs.io/notes/20230220191806.png)

> Confused as to why robots D and E have the same position? D and E are moving away from each other horizontally, so the image above shows their back axles overlapping, *not* the front axle of D overlapping the back axle of E. Remember that the arrows indicate the direction of motion.

## Simple Movement - Horizontal

We can choose to engage only one of the controls when using the bicycle model. Let's apply a forward movement. The diagram below shows a robot whose current pose is $(\text{x}=2,\text{y}=2,\theta=0)$. After applying a forward movement of ten, what is the robot's pose? Since the robot's current orientation is parallel to the x-axis, the forward movement only affects the horizontal component of the pose. We add ten to that component for a final pose of $(\text{x}=12, \text{y}=2, \theta=0)$.

![A forward movement of ten imposed on a vehicle with an orientation of zero, an x-position of 2, and a y-position of 2.](https://assets.omscs.io/notes/20230220200104.png)

## Simple Movement - Vertical

The diagram below shows a robot whose current pose is $(\text{x}=2,\text{y}=2,\theta=\pi/2)$. After applying a forward movement of ten, what is the robot's pose? Since the robot's current orientation is parallel to the y-axis, the forward movement only affects the vertical component of the pose. We add ten to that component for a final pose of $(\text{x}=2, \text{y}=12, \theta=\pi/2)$.

![A forward movement of ten imposed on a vehicle with an orientation of 90 degrees, an x-position of 2, and a y-position of 2.](https://assets.omscs.io/notes/20230220201036.png)

## Quiz: Simple Movement - Diagonal

When the robot is not parallel to either axis, we need trigonometry to determine the result of applying the forward movement. Given a robot with an initial pose of $(\text{x}=2, \text{y}=2, \theta=\pi/3)$, what is the robot's pose after applying a forward motion of ten?

![A forward movement of ten imposed on a vehicle with an orientation of 60 degrees, an x-position of 2, and a y-position of 2.](https://assets.omscs.io/notes/20230220201927.png)

## Quiz Solution: Simple Movement - Diagonal

The horizontal component of the forward movement, $d$, is the product of $d$ and the cosine of $\theta$; that is: $\text{dx} = 10\cos(\pi/3) = 5$. Similarly, the vertical component of $d$ is $d$ times the sine of $\theta$: $\text{dy} = 10\sin(\pi/3) \approx 8.7$. Adding the deltas to their corresponding components of the original pose gives us the final pose: $(\text{x} = 5 + 2 = 7, \text{y} = 2 + 8.7 = 10.7, \theta = \pi/3)$.

![A forward movement of ten imposed on a vehicle with an orientation of 60 degrees, an x-position of 2, and a y-position of 2 results in an orientation of 60 degrees, an x-position of 7, and a y-position of 10.7.](https://assets.omscs.io/notes/20230220202051.png)

## Quiz: Distinct Tracks A

Imagine that our robot's wheels emit ink as they roll across a surface during a movement. If the robot has a zero steering angle, would we expect to see one or two lines of ink (tracks) after a movement? Assume we are using a two-wheeled bicycle, not a four-wheeled car.

## Quiz Solution: Distinct Tracks A

We expect to see a single track after the movement.

## Quiz: Track Shape

Now let's engage both controls in the model. If the robot uses a positive steering angle and travels forward, what shape will the track it leaves behind generate?

- A heart
- A triangle
- A circle
- An oval

## Quiz Solution: Track Shape

The track left behind by a robot with a constant, non-zero steering angle and enough forward movement forms a circle.

## Quiz: Distinct Tracks B

If we engage in this compound movement involving both the steering angle and the forward motion, would we expect to see a single track or two tracks after the movement?

## Quiz Solution: Distinct Tracks B

In this case, the movement will produce two distinct circular tracks with the same center. The rear axle always creates the track with the smaller radius, and it is this track we concern ourselves with for this lesson.

## Problem to Solve

Here is the general problem we can solve using the bicycle model: given a starting robot pose and a set of controls - some forward motion and some constant, fixed steering angle - what is the resulting pose after applying these controls?

## Solution Steps

We solve the general problem described above in four steps.

1. Determine the radius of the circle.
2. Calculate the center of the circle using the radius and robot orientation. This point serves as our reference point.
3. Determine the turning angle around the circle using the distance traveled.
4. Determine the offset using the original orientation and the turning angle.

> What is "the circle"? Remember, robot movement that combines forward motion with a nonzero steering angle produces circular motion, just as pedaling a bicycle with the handlebars turned causes you to ride in circles.

## Quiz: Circle Center

What happens to the center of the circle as the steering angle increases?

- It moves closer to the robot
- It moves further from the robot
- It stays in the same place
- None of the above

## Quiz Solution: Circle Center

As we increase the steering angle, the center of the circle moves closer to the robot.

## Circle Center Examples

The following diagram illustrates the relationship between the magnitude of the steering angle and the radius of the circle drawn by the rear axle of the robot. The smallest steering angle produces the largest circle, while the largest steering angle produces the smallest circle. As the radius of the circle decreases, its center moves closer to the robot.

![Four diagrams arranged from smallest to largest steering angle illustrating the inverse relationship between steering angle and radius.](https://assets.omscs.io/notes/20230222010815.png)

## Step 1: Radius

To calculate the final pose after the compound movement, we must first determine the radius of the circle drawn by the rear axle. Consider the following figure.

![A triangle drawn from the bicycle's axles to the center of the circle, with several angles and sides of interest annotated.](https://assets.omscs.io/notes/20230223002309.png)

We construct a triangle by drawing lines from each axle - perpendicular to each axle - that intersect at the center of the circle. The length of the shortest side of this triangle is the length, $\text{L}$, of the robot, and the length of the line from the rear axle to the center of the circle is the radius, $\text{radius}$.

We know that the lines connecting the axles to the center of the circle form right angles with the axles they intersect. Additionally, we label the steering angle, $\alpha$, as the angle the front axle makes with the robot's orientation. Because the sum of angles on a straight line must equal $\pi$ radians, the interior angle of our triangle must equal $\pi - \pi / 2 - \alpha = \pi / 2 - \alpha$ radians. The sum of the angles in a triangle must also equal $\pi$ radians, so the third angle in our triangle must equal $\pi - \pi/2 - (\pi/2 - \alpha) = \alpha$ radians.

We now use trigonometry to calculate the radius of the circle. Since $\tan(\alpha) = \text{L} / \text{radius}$, then $\text{radius} = \text{L} / \tan(\alpha)$.

## Step 2: Center Point Location

Next, we need to determine the coordinates, $(\text{center\_x}, \text{center\_y})$, of the center of the circle whose radius we just computed. Consider the following diagram.

![A diagram of a triangle whose hypotenuse is the radius of the circle and whose other sides are the difference between the x- and y-coordinates of the robot and the center of the circle.](https://assets.omscs.io/notes/20230223011555.png)

We start by constructing a new right triangle with the circle's radius, $\text{radius}$, as its hypotenuse. The length of the triangle's horizontal side, $\text{x\_dist}$, is the difference between the x-coordinates of the robot and the circle's center. Similarly, the length of the triangle's vertical side, $\text{y\_dist}$, is the difference between the y-coordinates of the circle's center and the robot.

How do we calculate the interior angles of the triangle? We know that the robot's angle with the horizontal is the orientation, $\theta$. Because the sum of angles on a straight line must equal $\pi$ radians, the interior angle of our triangle must equal $\pi - \pi / 2 - \theta = \pi / 2 - \theta$ radians. The sum of the angles in a triangle must also equal $\pi$ radians, so the third angle in our triangle must equal $\pi - \pi/2 - (\pi/2 - \theta) = \theta$ radians.

We now use trigonometry to compute the length of the triangle's sides: since $\cos(\theta) = \text{y\_dist / radius}$, and $\sin(\theta) = \text{x\_dist / radius}$, then $\text{y\_dist} = \text{radius}*\cos(\theta)$ and $\text{x\_dist} = \text{radius}*\sin(\theta)$. Finally, we calculate $\text{center\_x} = \text{x} - \text{x\_dist}$ and $\text{center\_y} = \text{y} + \text{y\_dist}$. Note that we must travel a *negative* horizontal distance and a *positive* verticle distance from the robot to reach the circle's center.

## Quiz: Return to Same Point

Given what we know so far, what distance must the robot travel to return to its current position? Assume a fixed steering angle.

## Quiz Solution: Return to Same Point

The robot must traverse the circumference of the circle, $\text{C} = 2\pi \text{r}$, to return to its original position. Here, $\text{r}$ is the radius we found by dividing the robot's length by the tangent of its steering angle.

## Step 3: Arc Length

An **arc length**, $\text{A}$, is the distance between two points on the circumference of a circle. Given a central angle, $\beta$, and a radius, $\text{radius}$, $\text{A} = \beta * \text{radius}$. In our case, we know $\text{R}$ and $\text{A}$, so $\beta = \text{A / radius}$.

> How do we know $\text{A}$? Remember the forward distance, $\text{d}$? When we issue a forward motion, that motion takes place along the circle's circumference. In other words, $\text{A} = \text{d}$.

![A diagram relating the arced forward distance traveled by the robot, the radius of the circle, and the central angle through which that arc sweeps.](https://assets.omscs.io/notes/20230223015057.png)  

## Step 4: Offset from Center

We determine the robot's final location by calculating the robot's x- and y-offset from the center of the circle using the central angle we just computed. Consider the following diagram.

![Computing the new x- and y-position of the robot using theta, beta, and the circle's radius and center point.](https://assets.omscs.io/notes/20230223233216.png)

First, we draw a right triangle with one vertex at the circle's center and another at the robot's rear axle. This triangle's hypotenuse is $\text{radius}$. The angle associated with the vertex at the circle's center is $\theta + \beta$.

> Confused why $\theta$ appears here? Revisit the circle center calculation step and compare that right triangle to the one involving $\theta$ in this step.

We first calculate the length of the horizontal and vertical sides of the triangle using trigonometry. Next, we travel those distances from the circle's center to arrive at the robot. Using the diagram above, we must travel in the negative y-direction and positive x-direction. Our final set of equations is:

$$
\begin{align}
\text{x\_dist\_new} = \sin(\theta + \beta)*\text{radius} \\
\text{y\_dist\_new} = \cos(\theta + \beta)*\text{radius} \\
\text{x\_new} = \text{center\_x} + \text{x\_dist\_new} \\
\text{y\_new} = \text{center\_y} - \text{y\_dist\_new} \\
\end{align}
$$

## New Orientation

Calculating the robot's new orientation is the last step in computing the robot's final pose. Consider the following diagram.

![A diagram demonstrating that the robot's new orientation is beta plus theta.](https://assets.omscs.io/notes/20230224000645.png)

Let's start with the triangle we just drew. What is the value of its third interior angle? The sum of the angles in a triangle must equal $\pi$ radians, so the missing angle must equal $\pi - \pi/2 - (\beta + \theta) = \pi/2 - (\beta+ \theta)$ radians.

Recall that the robot's orientation is its angle with the positive x-axis. Because the sum of the angles on a straight line must equal $\pi$ radians, the interior angle of our triangle must equal $\pi - \pi / 2 - (\pi/2 - (\beta+ \theta)) = \beta + \theta$ radians.

> Confused about how we got the second right angle? The rear axle forms a tangent line to the circle, which we know must be perpendicular to its radius.

Our final equation is:

$$
\theta\text{\_new} = (\theta + \beta)\bmod(2\pi)
$$

## Formulas

![The collection of formulas needed to solve problems involving the bicycle model.](https://assets.omscs.io/notes/20230222012528.png)

## Quiz: Example Problem

Consider a robot of length $\text{L}=0.2$ with starting pose $(\text{x}=0.118, \text{y}=-0.54,\theta=0.1)$. After applying a steering angle of $0.166$ and a forward motion of $1.07$, what is the final pose of the robot?

## Quiz Solution: Example Problem

![Plugging the variables from the problem into the equations we derived yields a final robot pose of (x=1,y=0,theta=1).](https://assets.omscs.io/notes/20230223020134.png)

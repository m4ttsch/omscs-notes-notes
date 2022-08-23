---
id: machine-learning-trading-optimizers-how-hedge-funds-use-capm
title: How Hedge Funds Use the CAPM
course: machine-learning-trading
lecture: how-hedge-funds-use-capm
---

# How Hedge Funds Use the CAPM

## Risks for Hedge Funds

A typical hedge fund develops methods to find performant stocks. The informational edge they are seeking is usually market-relative, meaning that they are looking for stocks that rise more than the market when the market goes up or stocks that fall less than the market when the market goes down. If the information they have is reliable, they can take advantage of the CAPM to virtually guarantee a positive return.

## Two Stock Scenario

As an illustration of how hedge funds use CAPM, let's consider a two-stock scenario.

Suppose our hedge fund has done some research and they think that stock A is going to go up 1% over the market in the next 10 days; in other words, they are predicting an $\alpha$ of 0.01 for stock A. As well, they have used historical pricing information to observe a $\beta$ of 1.0 for stock A.

Our hedge fund has also done some research on stock B, and they are predicting an $\alpha$ value of -0.01 for this stock. Additionally, they have observed a historical $\beta$ of 2.0 for stock B.

We should long stock A and short stock B since we think the former is going to go up relative to the market, while the latter is going to go down. This type of long-short portfolio is widespread amongst hedge funds.

Consider the following scenario. Let's assume that the market stays flat, returning 0%, over the next 10 days and that we enter the following positions today: a $50 long position in stock A and a $50 short position in stock B. Let's also assume that our predictions are perfect. Stock A rises 1% above the market, and stock B falls 1% below the market.

Consider the returns of stock A, using the CAPM equation.

$$
r_A = \beta_Ar_m + \alpha_A
$$

Since the market returned 0%, the equation simplifies.

$$
r_A = \alpha_A
$$

Since $\alpha_A$ is 0.01, our return is 1% of $50, or $0.50.

Now, consider the returns of stock B, using the CAPM equation.

$$
r_B = \beta_Br_m + \alpha_B
$$

Again, since the market returned 0%, the equation simplifies.

$$
r_B = \alpha_B
$$

Since both $\alpha_B$ and our investment in stock B are negative, we actually made a profit: -1% of -$50, or $0.50.

Altogether we made $1, a 1% return on our total investment.

## Two Stock Scenario Quiz

Let's consider another scenario now.

Instead of staying flat, suppose that the market went up 10%. What are the relative and absolute returns for both stocks, and what is our total return, both relative and absolute?

![](https://assets.omscs.io/notes/2020-02-21-22-10-17.png)

Let's also consider the scenario where the market goes down 10%. What are the relative and absolute returns for both stocks, and what is our total return, both relative and absolute?

![](https://assets.omscs.io/notes/2020-02-21-22-21-24.png)

## Two Stock Scenario Quiz Solution

Let's first look at the case where the market rises by 10%.

![](https://assets.omscs.io/notes/2020-02-21-22-13-24.png)

Consider stock A, which has a $\beta$ of 1.0 and an $\alpha$ of 0.01. A $\beta$ of 1.0 tells us that for every percentage point that the market moves, stock A moves one percent. An $\alpha$ of 0.01 tells us that stock A will move 1% above its movement with the market.

As a result, stock A moves 10% plus 1%, for a total relative return of 11%, and a total absolute return of $5.50, 11% on a $50 investment.

Let's consider stock B now, which has a $\beta$ of 2.0 and an $\alpha$ of -0.01. A $\beta$ of 2.0 tells us that for every percentage point the market moves, stock A moves two percent. An $\alpha$ of -0.01 tells us that stock B will move 1% below its movement with the market.

As a result, stock B moves 20% minus 1%, for a total relative return of 19%. However, since we shorted stock B, this return is actually -19%, and we have lost $9.50.

Let's compute the total return. Since we gained $5.50 on stock A and lost $9.50 on stock B, our total absolute return is -$4.

Calculating the relative return is a little tricky; that is, we can't just add 11% and -19% to get -8%. Instead, since we split our investment across stock A and stock B, our actual return is one-half of 11% plus one-half of -19%, or -4%.

Now, let's look at the case where the market falls 10%.

![](https://assets.omscs.io/notes/2020-02-21-22-25-50.png)

In this case, stock A falls with the market, but does 1% better, for a total relative loss of 9%, which equates to a $4.50 loss on a $50 investment.

Stock B falls twice as hard as the market, and does 1% worse on top of that, for a total relative loss of 21%. However, since we shorted stock B, this loss is actually a 21% gain, or a gain of $10.50 on a $50 investment.

Overall, this market scenario nets us 6%, or $6 on a $100 investment.

## Two Stock CAPM Math

Recall how we use the CAPM to represent the return, $r_p$, for our overall portfolio. For each individual stock, $i$, we compute return, $r_i$, as the product of $\beta_i$ and the return on the market, $r_m$, plus $\alpha_i$. The value of $r_p$ is the sum of each $r_i$ multiplied by its corresponding weight, $w_i$.

$$
r_p = \sum_iw_i(\beta_ir_m + \alpha_i)
$$

Let's expand this sum, considering our two stocks, A and B, from before.

$$
r_p = (w_A\beta_A + w_B\beta_B)r_m + w_A\alpha_A + w_B\alpha_B
$$

Stock A has a $\beta$ of 1.0 and an $\alpha$ of 0.01. Stock B has a $\beta$ of 2.0 and an $\alpha$ of -0.01. Our portfolio has a 50% investment in stock A and a -50% investment in stock B. Let's plug these values into the CAPM equation.

$$
r_p = (0.5 * 1.0 - 0.5 * 2.0)r_m + 0.5 * 0.01 - 0.5 * -0.01
$$

$$
r_p = 0.01 - 0.5r_m
$$

Using the CAPM, we have determined that our expected return for this portfolio is equal to 1% minus one-half of the market return.

We can double-check this result by plugging in the market return from one of our previous examples. Let's look at the case where the market went up 10%.

$$
r_p = 0.01 - 0.5r_m
$$

$$
r_p = 0.01 - (0.5 * 0.1)
$$

$$
r_p = 0.01 - 0.05
$$

$$
r_p = -0.04
$$

Remember how we arrived at the 1% portfolio $\alpha$. We researched the stocks that we selected for our portfolio and found information that led us to believe that one would outperform the market by 1% and that the other would underperform the market by 1%.

On the other hand, we don't have any knowledge about what is going to happen in the market overall; that is, we have no control over the component of CAPM that incorporates market return. If we can eliminate this component, we can guarantee our 1% return, *regardless* of market movement.

We can eliminate market risk by making $\beta_p = 0$. Since we can't change the individual $\beta_A$ and $\beta_B$ values to make this happen, we need to adjust our allocations instead. Essentially, we need to solve the following equation for $w_A$ and $w_B$.

$$
0 = w_A\beta_A + w_B\beta_B
$$

## Allocations Remove Market Risk Quiz

Let's look at our two stocks again. Stock A has a $\beta$ of 1.0 and an $\alpha$ of 0.01. Stock B has a $\beta$ of 2.0 and an $\alpha$ of -0.01. What should the weights be for stock A and stock B so that we can minimize market risk?

![](https://assets.omscs.io/notes/2020-02-22-12-44-41.png)

## Allocations Remove Market Risk Quiz Solution

![](https://assets.omscs.io/notes/2020-02-22-12-45-05.png)

We need to solve the following equation.

$$
0 = 0.01w_A + 0.02w_B
$$

$$
w_A = -2w_B
$$

We also know that the sum of the absolute values $w_A$ and $w_B$ should equal one.

$$
|w_A| + |w_B| = 1
$$

If we substitute $-2w_B$ for $w_A$, we can solve for $w_B$.

$$
|-2w_B| + |w_B| = 1
$$

$$
|-3w_B| = 1
$$

$$
|w_B| = \frac{1}{3}
$$

However, since we want to short B, $w_B$ is actually $\frac{-1}{3}$, not $\frac{1}{3}$. We can now solve for $w_A$.

$$
|w_A| + |w_B| = 1
$$

$$
|w_A| + |-\frac{1}{3}| = 1
$$

$$
|w_A| = \frac{2}{3}
$$

If we plug these two weights back into our original equation, we can verify that we do get an overall $\beta_p$ of 0.

$$
\beta_p = 0.01w_A + 0.02w_B
$$

$$
\beta_p = (0.01 * 0.66) + (0.02 * -0.33)
$$

$$
\beta_p = 0.66 - 0.66
$$

$$
\beta_p = 0
$$

## How Does It Work

Now that we have calculated weights for stock A and stock B that eliminate market risk let's see how they work using the market conditions we have been examining.

Let's look at the scenario where the market goes up 10%. Using weights $w_A = 0.66$ and $w_B = -0.33$, we can use the CAPM to compute portfolio return.

$$
r_p = w_A\beta_Ar_m + w_A\alpha_A + w_B\beta_Br_m + w_B\alpha_B
$$

Because of the work we have already done, we know that the sum of the components that consider market return equals zero, so we can drop them from the equation.

$$
r_p = w_A\alpha_A + w_B\alpha_B
$$

Let's plug in the appropriate variables.

$$
r_p = 0.66 * 0.01 + -0.33 * -0.01
$$

$$
r_p = 0.01
$$

We can see that the expected return for our portfolio is 1%, *irrespective* of market movement.

We need to add some caveats here. Specifically, the values of $\beta$ and $\alpha$ that we calculated using historical data are *not* guaranteed to carry into the future. This portfolio is not a guaranteed investment, by any means, but rather an example of how we can use long-short investing to reduce overall exposure to the market.

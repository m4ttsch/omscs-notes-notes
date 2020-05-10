---
id: machine-learning-trading-hedge-fund-manager
title: So You Want to be a Hedge Fund Manager
course: machine-learning-trading
lecture: hedge-fund-manager
---

# So You Want to be a Hedge Fund Manager

## Types of Funds

There are many different types of funds, but three broad classes that we are going to look at are **exchange-traded funds** (ETFs), **mutual funds**, and **hedge funds**.

ETFs represent baskets of stocks, yet can be bought and sold as if they were individual stocks. ETF prices change throughout the day, and we can buy or sell ETF shares whenever the market is open. In other words, ETFs are very liquid. Additionally, ETF managers are very transparent concerning investment goals - for instance, tracking the S&P 500 - and holdings.

Mutual funds are less liquid than ETFs. At the end of the trading day, a mutual fund adds up all of its holdings to compute a *net asset value*, and it's from this value that the buy/sell price is derived. Unlike ETFs, which investors can trade intraday, mutual funds can only be bought or sold at the end of the day.

Additionally, mutual funds are less transparent then ETFs. Mutual funds only have to disclose their holdings once every quarter. As a result, investing in a mutual fund can be somewhat of a black box in the middle of the quarter, as investors are unsure of the composition of the fund at the time of investment.

Still, mutual funds are somewhat transparent because they have stated goals. For example, a mutual fund might strive to track the S&P 500, and it would publish the goal to inform investors.

Hedge funds are even less transparent than mutual funds. Buying shares in a hedge fund often involves first entering into a secret agreement that prohibits the disclosure of any details regarding which assets are being bought or sold.

Hedge funds are hard to exit, as they usually require investors to lock their money in for some number of months or years. When investors do exit, they may not be able to withdraw all of their money at once.

Finally, hedge funds don't have to disclose what they are holding, not even to their investors, making hedge funds both the least transparent and least liquid of the three.

![](https://assets.omscs.io/notes/2020-02-03-22-25-26.png)

## Liquidity and Capitalization

**Liquidity** refers to the ease with which one can buy or sell shares in a particular holding. Stocks and ETFs, which have hundreds of thousands or even millions of investors, are often very liquid; in other words, you can almost always find someone looking to buy or sell shares. Indeed, we can look up the *trading volume* of stocks and ETFs on platforms like [Google Finance](https://www.google.com/finance) or [Yahoo Finance](https://finance.yahoo.com/) to confirm this liquidity.

**Capitalization** refers to the worth of a company defined as the product of the number of outstanding shares and the share price. Some stocks, like Apple, have capitalizations in the hundreds of billions (trillions) of dollars, and we refer to these stocks are **large-cap** stocks. Correspondingly, **small-cap** stocks are those with smaller capitalizations.

Note that the price of a stock only relates to the price of one share, not the overall *value* of the company.

## What Type of Fund is it Quiz

For each of the following five funds, determine if the fund is an ETF, mutual fund, or hedge fund. Use [Google Finance](https://www.google.com/finance) or [Yahoo Finance](https://finance.yahoo.com/) for help.

![](https://assets.omscs.io/notes/2020-02-03-22-32-48.png)

## What Type of Fund is it Quiz Solution

![](https://assets.omscs.io/notes/2020-02-03-22-36-01.png)

Typically, symbols for ETFs have three or four letters, while mutual fund symbols usually have five. Hedge funds don't have symbols; instead, we refer to them by their full name.

## Incentives for Fund Managers

We've discussed differences regarding transparency and liquidity among ETFs, mutual funds, and hedge funds. Now, let's focus on how the managers of these funds are compensated.

Each type of fund has different rules for how managers receive compensation, and it's essential to investigate these compensation mechanisms because they incentivize managers to act in specific ways.

Before we can discuss these compensation structures, we have to introduce one concept: **assets under management** (AUM). AUM refers to the amount of money managed by the fund and is important because, for each type of fund, part of the compensation is derived from AUM.

The managers of ETFs are compensated according to an **expense ratio**, which is essentially a percentage of AUM. Expense ratios are typically quite low and vary from 0.01% to 1%.

Mutual fund managers are also compensated according to an expense ratio, and the range of expense ratios for these managers is slightly higher than for those who manage ETFs, varying from about 0.5% to 3%.

Remember that ETFs are typically tied to an index. For example, SPY is a popular ETF that is supposed to track the S&P 500. As a result, an SPY manager has to "simply" make sure they are holding all of the stocks in the S&P 500.

Mutual fund managers typically have much more discretion than ETF managers, and therefore can command a higher expense ratio, both for the cost of their research and for their skill.

Hedge funds are a completely different breed in terms of how their managers are compensated. These funds typically follow a **two and twenty** model, whereby the manager receives an expense ratio of 2% as well as 20% of the profits.

We've been examining how fund managers are compensated, but we can also look at how fund investors are compensated. If we invest in a fund, our return is based on the increase in the value of that fund. In most cases, that increase is subject to macroeconomic and market activity.

## Two and Twenty

Consider that we are managing a hedge fund with $100,000,000 AUM. Over a year, our investment skill results in an increase in the value of that fund by 15%; in other words, the fund grew from $100,000,000 to $115,000,000.

What's our compensation?

Two percent of AUM comes out to $0.02 * 100,000,000 = 2,000,000$ and twenty percent of profits equals $0.2 * 15,000,000 = 3,000,000$. In total, our compensation for the year would be about $5,000,000.

One question we might ask: when determining our compensation, should we use an AUM of $100,000,000 or $115,000,000? It depends on the hedge fund, of course, and when they take accounting snapshots, but the AUM used for compensation will likely fall somewhere between the two values.

The two and twenty model has been assailed lately, and it's rare to find a hedge fund today that compensates that highly. Typical rates these days are much lower, closer to "one and ten". There are some star hedge funds that charge more; for instance, [SAC Capital](https://en.wikipedia.org/wiki/S.A.C._Capital_Advisors), which is no longer operating to the public, charged as much as "four and forty."

## Incentives Quiz

So far, we've looked at two different incentive structures: expense ratios and the two and twenty rule. Which of the following actions might these compensation mechanisms incentivize?

![](https://assets.omscs.io/notes/2020-02-04-22-29-02.png)

## Incentives Quiz Solution

![](https://assets.omscs.io/notes/2020-02-04-22-29-24.png)

The expense ratio, which is derived entirely from AUM, primarily incentivizes AUM accumulation. Additionally, since the "two" of two and twenty is based on AUM, that incentive structure overall slightly incentivizes AUM accumulation.

ETF managers and mutual fund managers are not compensated for making profits. ETFs, for example, are specifically designed to track an index, and they don't particularly care whether an index goes up or down. The two and twenty rule incentivizes profit, as the "twenty" component is earned through profit gains.

Funds that compensate according to expense ratios are not incentivized to take risks at all. Under the two and twenty model, however, risk-taking is incentivized since significant profit gains can be realized by undertaking considerable risk.

Additionally, fund managers under the two and twenty rule are insulated from risk by the 2% expense ratio that they receive no matter what. As a result, they experience the upside of risk and a minimized downside.

## How Funds Attract Investors

There are three major types of investors in hedge funds: individuals, institutions, and funds of funds.

Individuals may wish to deploy a portion of their personal wealth into a hedge fund. Hedge funds usually can only have up to 100 investors, and managers want to maximize AUM, so hedge funds typically only consider very wealthy people who make sizable investments.

When we talk about institutions, we are referring to entities such as large retirement funds - [CalPERS](https://www.calpers.ca.gov/) in California, for example - and university foundations, like those associated with Harvard or Georgia Tech.

These institutions, often non-profit in nature, have large sums of money that they need to keep somewhere. Since they'd like to see their money accrue in value, they might look to hedge funds as an investment strategy.

Funds of funds group together the funds of many individuals or institutions. For instance, an individual might be wealthy enough to invest in one hedge fund but would like the advantage of investing in several funds. This person might invest their money into a fund of funds, which spreads the investments it receives across several hedge funds.

Besides knowing the types of investors that might be interested in our fund, it's critically important to know *why* they would invest, as this directs how we might present our case to potential investors.

Some of the most persuasive evidence we can present to potential investors is the track record of our fund, as this serves as an indication that our fund will continue to perform. Indeed, many institutional investors will want to see a track record for at least five years before they will invest in a particular fund.

Of course, younger hedge fund managers might not have this track record, so they simulate/backtest their strategy instead. Investors will consider these simulations; however, they must be backed by a convincing story demonstrating that the proposed strategy will be successful in the wild.

Finally, potential investors consider how our strategy fits within their portfolio. In other words, if our strategy is for large-cap S&P 500 stocks, and they've already covered that ground with another fund, they might not consider our fund. If our strategy aligns with a particular investment need that their portfolio is missing, they might be inclined to give our fund more thought.

## Hedge Fund Goals and Metrics

Hedge funds typically try to achieve one of two goals: beat a benchmark or provide an absolute return.

For example, if we are good at picking stocks from the S&P 500, we might build a hedge fund whose goal is to beat the S&P 500. Here, the S&P 500 is the benchmark, and we hope to beat this benchmark by selectively investing in those stocks we expect to outperform.

The benchmark we choose should depend on our expertise. For example, if we are an expert in selecting stocks in emerging markets in Eastern Europe, we should pick a benchmark that represents that type of investing, such as an index comprised of companies in emerging markets in Eastern Europe.

One thing to note is that many benchmarks, such as indexes, can go down in value. Of course, it's natural for a portfolio associated with a losing benchmark to also lose money, but the fund can still beat the benchmark by losing less value.

Funds that strive for absolute returns seek to provide positive returns no matter what. These funds are usually long/short, which means they make positive bets on stocks they think are going to go up and negative bets on stocks they think are going to go down.

The objective of these funds is to make slow, consistent, positive returns. Often, these funds don't make the same percentage gains as the funds that are pegged to a benchmark, but they have lower drawdowns; in other words, when the market takes a big hit, they don't.

How do we measure how well a fund is meeting its goals? We use the metrics that we've discussed previously - cumulative return, volatility, and Sharpe ratio - which we talk about at length [here](../sharpe-ratio-other-portfolio-statistics).

## The Computing Inside a Hedge Fund

Hedge funds are among the most computationally demanding environments, with infrastructural requirements like massive databases, low latency,  high-bandwidth connectivity, and real-time processing.

Let's examine the different components of a hedge fund, from both a data-centric and an algorithmic perspective, by working backward from the market.

![](https://assets.omscs.io/notes/2020-02-08-22-58-20.png)

One component that a hedge fund needs to keep track of is its *live portfolio*. Just like any other investor, a hedge fund has a collection of positive and negative positions in various stocks.

In addition to the live portfolio, which describes currently held stock positions, the hedge fund also maintains a *target portfolio*. The target portfolio describes the positions that the hedge fund would like to hold.

The *trading algorithm* is one of the most central pieces of the hedge fund. This algorithm interacts with the market, and issues *orders* to move the positions in the live portfolio to match those in the target portfolio.

At first glance, it might seem like a hedge fund doesn't need a sophisticated algorithm to acquire the positions in its target portfolio; instead, they can simply buy what they lack and sell what they have in excess.

In reality, hedge funds rarely execute everything all at once, as massive buy or sell orders can have detrimental impacts on execution prices. The trading algorithm seeks to enter and exit positions as quietly as possible. Indeed, it can take days to shift holdings substantially.

Now, let's step back further into the hedge fund and see how we derive the target portfolio.

![](https://assets.omscs.io/notes/2020-02-08-23-03-14.png)

One important piece of data that informs the makeup of a hedge fund's target portfolio is a *forecast*. A forecast predicts prices for a group of stocks some $N$ days into the future and informs a hedge fund as to the optimal positions to take regarding those stocks today.

Another valuable set of data to consider is the *historical data* - open, high, low, close, and volume - for the group of stocks under consideration. Historical data can often reveal correlations between individual stocks, which may, in turn, inform buying or selling decisions.

The current portfolio is also of critical importance. A hedge fund may be penalized for rapidly opening and closing positions and may want to weigh these penalties against forecast predictions.

These three data sources feed into an algorithm called a *portfolio optimizer* that searches for a portfolio that maximizes rewards given a set of risk constraints. The resulting portfolio then becomes the target portfolio.

Let's now look at how to calculate an $N$-day forecast. A hedge fund might train a machine-learning-based forecasting model using a combination of proprietary information alongside public, historical data.

![](https://assets.omscs.io/notes/2020-02-08-23-09-29.png)

---
id: machine-learning-trading-efficient-markets-hypothesis
title: Efficient Markets Hypothesis
course: machine-learning-trading
lecture: efficient-markets-hypothesis
---

# Efficient Markets Hypothesis

## Our Hypothesis

Up until now, we have been operating under some assumptions. For technical analysis, we assumed that there is information in historical price and volume data that we can discover and exploit in advance of the market. For fundamental analysis, we assumed that there is information in fundamental data, like earnings, that we can exploit and trade upon in advance of the market. The efficient markets hypothesis says that both of these assumptions are wrong.

## EMH Assumptions

The foundational ideas that formed the backbone of the efficient markets hypothesis were postulated by [Jules Regnault](https://en.wikipedia.org/wiki/Jules_Regnault) in 1863. [Eugene Fama](https://en.wikipedia.org/wiki/Eugene_Fama) carried those ideas further in the 1960s, and the subject became his Ph.D. thesis. Fama recently received the Nobel prize for his work.

To understand the efficient markets hypothesis, let's first understand some of the assumptions that it makes.

Probably the most critical assumption is that there are a large number of investors interacting in the market. These investors are looking to make a profit; therefore, they have an incentive to find opportunities where the price of a stock is out of line with its actual value. 

The next assumption is that new information arrives randomly. Information about a particular stock arrives at random intervals and random rates.

Because there are so many of these investors operating simultaneously, the price is going to move any time new information emerges. As a result, the third assumption is that prices adjust quickly to new information. The final assumption takes the third assumption further and assumes that the current price reflects all available information.

In summary, the efficient markets hypothesis supposes a large number of investors reacting to randomly emerging information. Furthermore, it assumes that information impacts price so quickly that the current price of a stock reflects all available information about that stock.

## Origin of Information

Information that might impact the price of a stock can come from several different sources.

For example, the information might come from public data points about the company itself. Price and volume data, which form the basis of technical analysis, can affect the price of a stock. Additionally, quarterly reports on fundamental data, such as earnings, can also have an impact.

The information does not have to come from the company itself; instead, **exogenous** information concerns external factors that might impact a company. 

For example, if we are looking at the stock of an airline company, we might see that the stock price rises when the price of oil drops. In this case, the price of oil is an exogenous piece of information.

Information can also come from company insiders. Suppose that the CEO of a pharmaceutical company tells us privately that a particular drug of theirs is about to be approved. We might buy shares in that company because we think the price of its stock is going to go up.

Depending on the circumstance, this action may or may not be legal. Regardless, inside information is one of the few private sources of information that may impact the price of a stock.

## 3 Forms of the EMH

There are three forms of the efficient markets hypothesis: weak, semi-strong, and strong.

The **weak form of the EMH** says that future prices cannot be predicted by analyzing historical prices. Notice that this form rules out technical analysis as a way to make money; however, it does leave room for fundamental analysis.

The **semi-strong form of the EMH** states that prices adjust immediately to new public information. For instance, when companies release their quarterly reports, which contain fundamental information, prices react immediately.

If the semi-strong version of the EMH is true, then we cannot make money using fundamental analysis. However, we might still be able to make money using private, insider information.

Unfortunately, the **strong form of the EMH** says that prices reflect *all* information, public and private, thus ruling out insider information as a means of making money.

![](https://assets.omscs.io/notes/2020-03-08-21-48-24.png)

If the strong form of the EMH is true, then it is virtually impossible to make money by holding a portfolio other than the market portfolio. 

## The EMH Prohibits Quiz

Consider the three forms of the efficient markets hypothesis: weak, semi-strong, and strong. Which forms prohibit which of the following different analyses?

![](https://assets.omscs.io/notes/2020-03-08-22-25-06.png)

## The EMH Prohibits Quiz Solution

![](https://assets.omscs.io/notes/2020-03-08-22-31-43.png)

The weak version of the EMH prohibits us from profiting using technical analysis but is silent on fundamental analysis and insider knowledge. The semi-strong version prohibits technical and fundamental analysis but is silent on insider knowledge. The strong version prohibits all three.

## Is the EMH Correct

If the efficient markets hypothesis is correct, then a lot of what we are trying to do in this course is not possible; namely, we can't beat the market using any of the strategies we have examined.

There is evidence that specific versions of the efficient markets hypothesis are not correct. The presence of many very successful hedge funds would seem to indicate that we can make money in the market by investing in portfolios other than the market portfolio.

The strong version of the EMH, which says that we can't profit from insider information, is the least solid. There have been many reports of people making money from insider information; clearly, it's a method that can provide profit even though it is often illegal.

Let's look at a dataset that would seem to refute the semi-strong version of the EMH.

![](https://assets.omscs.io/notes/2020-03-09-09-13-16.png)

Here we see a plot of P/E - price to earnings - ratios against twenty year annualized returns. Recall that lower P/E ratios are generally a better buy, as we expect a stock that has a relatively lower price and relatively higher earnings to increase in price in the future.

Each group of colors represents a different decade over which data was sampled. For every decade, we see that low P/E ratios corresponded with higher returns. This consistency shows that P/E ratios are very predictive across many decades of future returns, which would tend to refute the semi-strong version of the EMH.

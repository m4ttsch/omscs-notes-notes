---
id: machine-learning-trading-dealing-with-data
title: Dealing With Data
course: machine-learning-trading
lecture: dealing-with-data
---

# Dealing With Data

## How Data Is Aggregated

Many stocks are being traded across many different exchanges, and it's essential to understand how that data is aggregated and reported to us so that we can consume it appropriately.

The finest resolution of data is a tick. A **tick** represents a successful match between a buyer and a seller: in other words, a successful transaction.

Consider the following plot, which shows share price along with share volume over time.

![](2020-02-24-22-24-50.png)

Keep in mind that none of these transactions happens at a specific time or during a specific time slice. There is no guarantee regarding the number of ticks during any particular minute or hour. An exchange only records a tick when a successful transaction occurs.

Each exchange provides its own data feed regarding these transactions, and we can subscribe to multiple feeds to see ticks across different markets.

Let's add in the ticks from another exchange, shown in red, to our plot. Remember that all of these transactions are happening simultaneously, and prices at different exchanges aren't guaranteed to be the same.

![](2020-02-24-22-27-07.png)

Highly liquid stocks might experience hundreds of thousands of transactions occurring every second. Collecting ticks across all of the exchanges over a long period of time for stocks like these might result in an incomprehensible amount of data.

As a result, exchanges usually consolidate tick data into time slices - minute-by-minute or hour-by-hour, for example - and we can see such slices, demarcated by the dotted lines, in our plot.

![](2020-02-24-22-31-08.png)

We can describe each chunk using five data points: open, high, low, close, and volume. Let's consider the first chunk.

The **open** is the price of the first transaction within the chunk, which is $100.00. The **high** is the highest transaction price within the chunk, which is also $100.00. The **low** is the lowest transaction price within the chunk, which is $99.05. The **close** is the price of the last transaction within the chunk, which is $99.50. Finally, the **volume** represents the total number of shares transacted within the chunk, which is 600.

![](2020-02-24-22-38-26.png)

We can similarly consolidate the next chunk. Both the open and the low are $99.00, while the high and the close are $99.95. The volume is 300.

![](2020-02-24-22-39-33.png)

The data that we are going to work with is daily data; in other words, we are working with chunks that aggregate ticks on a daily frequency.

All of the concepts that we discuss apply to finer time slices, such as milliseconds, but analyzing and acting on chunks of this size requires faster computers and larger databases than we have access to in this course.

## Price Anomaly Quiz

Consider the following plot of IBM stock prices over time.

![](2020-02-24-22-42-38.png)

Notice the sudden drops in price. In one example, the price drops from $300 per share to $75 per share; in another, the price drops from $250 per share to $125 per share. These drops represent a 75% and a 50% price decline, respectively.

Undoubtedly, the value of IBM did not drop that much in one day, so, which of the following reasons might explain the sudden drop in stock price?

![](2020-02-24-22-45-08.png)

## Price Anomaly Quiz Solution

![](2020-02-24-22-51-28.png)

What we see here is a **stock split**, whereby a single share becomes $n$ shares, and the price of each share is divided by $n$.

For example, consider the drop in price from $300 per share to $75 per share. This 75% drop in price is consistent with a 4-for-1 stock split, whereby one share becomes four shares. Note that the total value of the shares is preserved - four $75 shares still equals $300 worth of IBM - but the number of overall shares has increased.

## Stock Splits
## Split Adjustment Quiz
## Split Adjustment Quiz Solution

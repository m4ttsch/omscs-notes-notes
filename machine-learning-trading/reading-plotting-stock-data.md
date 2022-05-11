---
id: machine-learning-trading-reading-plotting-stock-data
title: Reading and Plotting Stock Data
course: machine-learning-trading
lecture: reading-plotting-stock-data
---

# Reading and Plotting Stock Data

## Data in CSV files
In this class, we work almost exclusively with data that comes from **comma-separated values** (CSV) files. As the name suggests, every data point in a CSV is separated by a comma.

Here is an example of a CSV that contains data related to weather conditions.

![](https://assets.omscs.io/notes/1005DC91-1238-455A-96AF-6B012BF6746C.png)

Most CSV files start with a header line, which describes the data present in the file. In this example, the header line is:

```bash
temperature,pressure,humidity
```

This header tells us that we have data points corresponding to temperature, pressure, and humidity.

Following the header line, we have several rows of data. Each row contains data points, separated by commas, corresponding to the values in the header. For example, the first row lists a temperature of 100, a pressure of 760, and a humidity of 50.

## Which Fields Should Be In A CSV File Quiz
![](https://assets.omscs.io/notes/BED27ABE-D85D-4358-A2A3-FAE24EEDE5F6.png)

## Which Fields Should Be In A CSV File Quiz Solution
![](https://assets.omscs.io/notes/EFB7C1BB-0A52-4357-83E9-D5BCCB262559.png)

We want to include data that changes frequently; otherwise, we are wasting space including redundant data. Of the options given, both "date/time" and "price of the stock" are good fits. The other data points are either static or change relatively infrequently.

## Real Stock Data
Let's take a look at real stock data, presented in the following CSV.

![](https://assets.omscs.io/notes/C130E72B-C33B-4754-A070-17F77EF8BA4F.png)

As always, we have a header row, which describes the columns in our data set.

The *Date* column refers to the date the data was captured. The *Open* column refers to the first price of the day for the stock. *High* and *Low* refer to the highest and lowest price the stock reached during the day, respectively. When the market closes, the last price recorded is the *Close* price. Finally, the number of shares traded is captured in the *Volume* column.

The **adjusted close** is a number that the data provider - Yahoo, in this case - calculates after considering [stock splits](https://www.investopedia.com/articles/01/072501.asp) and [dividend payments](https://en.wikipedia.org/wiki/Dividend). The *Adj. Close* column reflects this value.

Today (imagining we are in late 2012), the adjusted close and the close are the same. Naturally, no splits or dividends occurred between 4 P.M. and now.  As we go back in time, however, we begin to encounter these events, and the close and adjusted close values correspondingly diverge.

If we look back to the first trading day in 2000, we see a close of $25.00 and an adjusted close of $5.36. The most recent close we see is $46.73.

If we compare just the closing prices, it seems like an investment in 2000 would have grown by less than 100%. If we instead compare the adjusted closes, the same investment would have grown almost 800%. The adjusted close allows us to incorporate events like splits and dividends into our ROI calculations.

## Pandas DataFrame
In this course, we make heavy use of a python library called [pandas](https://pandas.pydata.org/), created by Wes McKinney. Pandas is used widely at hedge funds and by many different types of financial professionals.

One of the key components of pandas is the **DataFrame**. Here is a representation of a DataFrame containing closing prices.

![](https://assets.omscs.io/notes/98E7550D-F948-4589-BB90-8212A6DA6930.png)

Across the top are the columns, and each column holds the symbol of a tradable entity, such as SPY (an ETF representing the S&P 500), AAPL (Apple), GOOG (Google), and GLD (a precious metals ETF). There is one row for each tradable day between 2000 and 2015.

The `NaN` values stand for "Not a Number", which pandas can use as a placeholder in the absence of meaningful data. We see `NaN` values for GOOG and GLD because neither existed as a publicly-traded entity in early 2000.

Pandas can also handle three-dimensional data. For example, we can build multiple DataFrames for the same symbols and dates, where each DataFrame contains information related to a different data point, such as close, volume, and adjusted close.

![](https://assets.omscs.io/notes/02457F2A-0843-4515-A2A0-4926B575E2C6.png)

## Example CSV File
![](https://assets.omscs.io/notes/0ED02ACC-F69C-4C39-9D94-E5739390D268.png)

## Read CSV
Pandas provides several functions that make it easy to read in data like the CSV we just saw. The following code reads in the data from a file `data/AAPL.csv` into a DataFrame `df`:

```python
import pandas as pd

df = pd.read_csv("data/AAPL.csv")
```

Note that we `import pandas as pd` to avoid having to write out the full `pandas` every time we want to call a method.

We can think of `df` as a 2D array that takes roughly the same shape as the CSV we see above, and if we print it out - `print df` - we see the following.

![](https://assets.omscs.io/notes/4BE39ECF-50CD-410A-B3B6-2D38D624DEC8.png)

Printing an entire DataFrame is unwieldy, especially as our DataFrames grow in size, so we can use the following code to print out just the first five rows of the `df`:

```python
print df.head()
```

If we execute this code, we see the following.

![](https://assets.omscs.io/notes/0E3D5989-D6A6-444A-9A7E-AC3FB8EB67BB.png)

In addition to the named columns that we see in the CSV, we also see an unnamed column containing the values 0, 1, 2, 3, 4. This column is the *index* for the DataFrame, which we can use to access rows. 

Similarly, we can use the following code to see the last five rows of `df`:

```python
print df.tail()
```

### Documentation 

- [pandas.read_csv](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html)
- [pandas.DataFrame.head](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.head.html)
- [pandas.DataFrame.tail](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.tail.html)

## Select Rows
Of course, we would like to be able to access more than just the first five or last five rows of our DataFrame. For more flexible row accesses, we need to look at *slicing*.

The following code demonstrates how to print the tenth through the twentieth rows of `df`:

```python
print df[10:21]
```

This code generates the following output.

![](https://assets.omscs.io/notes/B98B5D8A-6187-454C-9AF0-E89BE25A0B15.png)

Generally, if we want to access rows `n` through `m` in `df`, we use the following syntax:

```python
df[n:m + 1]
```

Note that the range is upper-bound exclusive, which means it won't include the `m`-th row by default. Thus, we must slice up to, but not including, `m + 1`. 

### Documentation

- [Slicing ranges](https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#slicing-ranges)

## Compute Max Closing Price
Let's assume we have a DataFrame `df` containing columns such as "Open", "High", "Low" and "Close", among others. If we'd like to retrieve just the "Close" column from `df`, we can use the following code:

```python
close = df['Close']
```

Given this object (technically a pandas Series), we can find  the maximum value with the following code:

```python
close.max()
```

### Documentation

- [Indexing Basics](https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#basics)
* [pandas.DataFrame.max](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.max.html)

## Compute Mean Volume Quiz
![](https://assets.omscs.io/notes/9C27B65A-7816-42FF-880F-93D981E0A193.png)

Your task is to calculate the mean volume for each of the given symbols.

## Compute Mean Volume Quiz Solution
![](https://assets.omscs.io/notes/99A66C8E-4B8E-413B-9713-22E7762069D9.png)

Given a DataFrame `df` containing a "Volume" column, the following code returns the mean of the values in that column.

```python
df['Volume'].mean()
```

### Documentation

- [pandas.DataFrame.mean](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.mean.html)

## Plotting Stock Price Data
It's easy to plot data in a DataFrame.

First, we need a library called [matplotlib](https://matplotlib.org/). To plot the adjusted close of `df`, we can run the following code:

```python
import matplotlib.pyplot as plt

df['Adj Close'].plot()
plt.show()
```

The generated plot looks like this.

![](https://assets.omscs.io/notes/54CD488F-DBFF-467C-9541-89B4A041B5F4.png)

Note how simple this graph is: there is no x-axis label, no y-axis label, no legend, and no title.

### Documentation

- [Plotting DataFrames](https://pandas.pydata.org/pandas-docs/stable/reference/frame.html#plotting)
- [matplotlib.axes.Axes.plot](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib-axes-axes-plot) 

## Plot High Prices for IBM Quiz
![](https://assets.omscs.io/notes/6217684A-EBD2-4031-9155-E2306FB95161.png)

Your task is to plot the high prices for IBM.

## Plot High Prices for IBM Quiz Solution
![](https://assets.omscs.io/notes/D4229E90-CE7E-4317-AC11-555F0D1701ED.png)

First, we need to make sure that we read in the right CSV, which we can accomplish with:

```python
df = pd.read_csv('data/IBM.csv')
```

Next, we can retrieve the "High" column and plot it:

```python
df['High'].plot()
```

## Plot Two Columns
We don't have to plot only one column at a time. We can plot both the adjusted close and close of `df` with the following code:

```python
df[['Close', 'Adj Close']].plot()
plt.show()
```

Here is the resulting graph.

![](https://assets.omscs.io/notes/25792257-B96C-43BB-8E90-E699F48E631D.png)

We can see the blue line, which corresponds to 'Close', and the green line, which corresponds to 'Adj Close'. Note that we didn't have to write any extra code to get these colors or the legend.

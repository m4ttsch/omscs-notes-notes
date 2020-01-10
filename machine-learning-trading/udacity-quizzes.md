---
id: machine-learning-trading-udacity-quizzes
title: Udacity Quizzes
course: machine-learning-trading
lecture: udacity-quizzes
---

# Udacity Quizzes - ML4T

## Reading and Plotting Stock Data

### Which Fields Should Be In A CSV File Quiz
![](https://assets.omscs.io/BED27ABE-D85D-4358-A2A3-FAE24EEDE5F6.png)

### Which Fields Should Be In A CSV File Quiz Solution
![](https://assets.omscs.io/EFB7C1BB-0A52-4357-83E9-D5BCCB262559.png)

We want to include data that changes frequently; otherwise, we are wasting space including redundant data. Of the options given, both “date/time” and “price of the stock” are good fits. The other data points are either static or change relatively infrequently.

### Compute Mean Volume Quiz
![](https://assets.omscs.io/9C27B65A-7816-42FF-880F-93D981E0A193.png)

Your task is to calculate the mean volume for each of the given symbols.

### Compute Mean Volume Quiz Solution
![](https://assets.omscs.io/99A66C8E-4B8E-413B-9713-22E7762069D9.png)

Given a DataFrame `df` containing a "Volume” column, the following code returns the mean of the values in that column.

```python
df[‘Values’].mean()
```

#### Documentation
- [pandas.DataFrame.mean](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.mean.html)

### Plot High Prices for IBM Quiz
![](https://assets.omscs.io/6217684A-EBD2-4031-9155-E2306FB95161.png)

Your task is to plot the high prices for IBM.

### Plot High Prices for IBM Quiz Solution
![](https://assets.omscs.io/D4229E90-CE7E-4317-AC11-555F0D1701ED.png)

First, we need to make sure that we read in the right CSV, which we can accomplish with:

```python
df = pd.read_csv(‘data/IBM.csv’)
```

Next, we can retrieve the “High” column and plot it:

```python
df[‘High’].plot()
```

## Working With Multiple Stocks
### NYSE Trading Days Quiz
![](https://assets.omscs.io/5A7D6772-A997-4543-BFBF-5DC11F911F1F.png)

### NYSE Trading Days Quiz Solution
![](https://assets.omscs.io/1569B3C1-4D74-44D9-895F-57F66260BDCD.png)

See the breakdown [here](https://www.nyse.com/publicdocs/Trading_Days.pdf) (for 2018 and 2019).

### Types of Joins Quiz
![](https://assets.omscs.io/C6F35EA2-BEB7-44C2-914E-73C3F8A4414F.png)

We can avoid having to explicitly call `dropna` on line 22 by passing a certain value for the ‘how’ parameter of the `join` call on line 19. 

What is the value of that parameter?

### Types of Joins Quiz Solution
![](https://assets.omscs.io/24945379-86BC-488E-85FD-C9E88E049F00.png)

#### Documentation
- [pandas.DataFrame.join](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.join.html)

### Utility Functions for Reading Data Quiz
If we look at the code we have written so far, we see some duplication.

![](https://assets.omscs.io/B6F23728-810F-4698-8918-B0753B06C098.png)

Your task is to consolidate this code into one location: the utility function `get_data`.

![](https://assets.omscs.io/967D338A-969A-4343-A6BC-63A9269C4486.png)

### Utility Functions for Reading Data Quiz Solution
We have consolidated both the DataFrame initialization code and the joining code. 

![](https://assets.omscs.io/7BB55353-D82C-4369-AFFC-3CFB0A873D21.png)

Additionally, since we are using SPY as our baseline, we drop all rows from `df` where SPY has not traded - that is, where the SPY column has `NaN` values - with the following code:

```python
df = df.dropna(subset=[“SPY”])
```

#### Documentation
- [pandas.DataFrame.dropna](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.dropna.html)
 
### How to Plot on “Equal Footing” Quiz
![](https://assets.omscs.io/533F01B4-36B8-4898-A860-8B735E1ADA08.png)

### How to Plot on “Equal Footing" Quiz Solution
![](https://assets.omscs.io/EF3D7A60-CF3B-4769-A3F8-D5157B461134.png)

While both of these are technically correct, the second approach leverages *vectorization* which is must faster than the iterative approach. Read more about vectorization [here](https://engineering.upside.com/a-beginners-guide-to-optimizing-pandas-code-for-speed-c09ef2c6a4d6).

### Slice and Plot Two Stocks Quiz
![](https://assets.omscs.io/5E5020D1-2E8C-422B-8867-733B8E88945C.png)

Your task is to write code that first slices `df` along the rows bounded by `start_index` and `end_index` and across `columns`, and then passes the slice to the `plot_selected` method.

### Slice and Plot Two Stocks Quiz Solution
![](https://assets.omscs.io/B76701D9-2822-4191-9B93-E49454905AD8.png)

We can create our slice using the following code, which we then pass to the `plot_data` method:

```python
df.ix[start_index:end_index, columns]
```

#### Documentation
- [pandas.DataFrame.ix - DEPRECATED](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.ix.html)
- [pandas.DataFrame.loc](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.loc.html)
- [pandas.DataFrame.iloc](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.iloc.html)

#Scott Otto Homework 3 pybank

#import OS module
import os

#import pandas
import pandas as pd

#pull in csv file
file = "Resources/budget_data.csv"

#read csv file
df = pd.read_csv(file)

#number of months in range
totalMonths = df["Date"].count()

#total of profit/loss column
totalRevenue = df["Profit/Losses"].sum()

#get first and last month values
firstMonth = df.iat[0,1]
lastMonth = df.iat[-1,1]

#calculate total change over data from 1st to last month
averageChange = (lastMonth - firstMonth) / max(df.index)

#find maximum increase month
index_increase = df["Profit/Losses"].diff().idxmax()
amtIncrease = df["Profit/Losses"].diff().max()
monthIncrease = df["Date"][index_increase]

#find maximum decrease month
index_decrease = df["Profit/Losses"].diff().idxmin()
amtDecrease = df["Profit/Losses"].diff().min()
monthDecrease = df["Date"][index_decrease]

#create output string
output_string = f"""\
---------------------------------------
Financial Analysis
---------------------------------------
Total Months:  {totalMonths}
Total:  ${totalRevenue:,}
Average Change:  ${averageChange:,.2f}
Greatest Increase in Profits:  {monthIncrease}  (${int(amtIncrease):,})
Greatest Decrease in Profits:  {monthDecrease} (${int(amtDecrease):,})
---------------------------------------"""

#print results to terminal
print(output_string)

#print results to text file
text_file = open("pybankOutput.txt","w")
text_file.write(output_string)
text_file.close()
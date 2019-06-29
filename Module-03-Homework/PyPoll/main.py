#Scott Otto Homework 3 pypoll

#import OS module
import os

#import pandas and numpy
import pandas as pd
import numpy as np

#pull in csv file
file = "Resources/election_data.csv"

#read csv file
df_electionData = pd.read_csv(file)

#determine the number of votes by determining the number of rows
rows = max(df_electionData.index) + 1

#create dictionary and loop through to count votes
res_dict = {}
for candidateName in df_electionData["Candidate"]:
    if candidateName in res_dict:
        res_dict[candidateName] += 1
    else:
        res_dict[candidateName] = 1

#sort votes from greatest to least      
sorted_votes = sorted(((value, key) for (key, value) in res_dict.items()), reverse=True)

winner = sorted_votes[0][1]




#print results to terminal using output string
output_string = f"""\
---------------------------------------
Election Results
---------------------------------------
Total Votes:  {rows:,}
---------------------------------------
"""
#output rows of results
for candidate in sorted_votes:
    votes = candidate[0]
    name = candidate[1]
    output_string += f"{name}: {votes/rows * 100:.2f}%  ({votes:,})\n"

output_string += f"""\
---------------------------------------
Winner: {winner}
---------------------------------------
"""
#print results to terminal
print(output_string)

#print results to text file
text_file = open("pypollOutput.txt","w")
text_file.write(output_string)
text_file.close()

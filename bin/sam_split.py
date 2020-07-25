import sys
import time
import string	
import random
import pandas as pd


file = sys.argv[1]

# read in file 
print('Reading file')

df = pd.read_csv(file, sep='\t', header=None)

print(len(df))


splitNum = int(sys.argv[2])

split_add = 0



split_count = int(len(df) / splitNum)

if len(df)%splitNum != 0:
	split_add = split_add + 1 

fileBase = sys.argv[3]

def generate_letters(y):
	return ''.join(random.choice(string.ascii_letters) for x in range(y))

count = 0
#print(split_add)
print('Splitting file')
print(splitNum + split_add )
split_add = 0
for x in range(splitNum + split_add ):
	x += 1
	print(x)
	temp_df = pd.DataFrame()
	lines_needed = False
	split_now = False


	#print('x * split_count', str((x*split_count)))
	#saving previous count
	previous_count = count
	count = x * split_count
	if( x == 1 ):
		previous_count = 0
		temp_data = df.iloc[previous_count:count]
		#print(temp_data

	#number of lines in each split
	while split_now == False:	


		# has reached minimum number of lines needed
		if count >= (x * split_count):
			lines_needed = True
			# only true when count == total number of lines in the file. Has to split here
			#print('count = ', str(count))
			#temp = ((splitNum ) * split_count)
			#print('(splitNum + split_add) * split_count) = ', str(temp ))

			#splitnum * split_count is total number of lines in the file 
			if count >= ((splitNum ) * split_count): 
				#print('here')
				split_now = True
				temp_data = df.iloc[previous_count:len(df)]
				break

			else:
				#if current read != read before it its ok to split
				#if df.get_value(count,0) != df.get_value((count-1),0): 
				if df.at[count,0] != df.at[(count-1),0]: 
					split_now = True
					break

				
		count+=1

	if count < ((splitNum ) * split_count): 
		temp_data = df.iloc[previous_count:count]
	temp_df = temp_df.append(temp_data)
	#tempFilename = str(x) + fileBase 
	tempFilename = fileBase + generate_letters(5) + '.sam'
	temp_df.to_csv(tempFilename, sep = '\t', index=False, header=False)










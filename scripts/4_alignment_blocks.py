import subprocess

def makeblocks():

	input_str = subprocess.check_output("cat data/TAIR10_chrC.fas| awk '{print}' ORS=''", shell=True)
	n = 10000
	blocks = []
	i = 0
	while i < len(input_str):
	    name="chrC_"+str(i)
	    myfile = open(name+".fas", 'w')
	    if i+n < len(input_str):
	        blocks.append(input_str[i:i+n].decode())
	        myfile.write("%s\n" % input_str[i:i+n])
	    else:
	        blocks.append(input_str[i:len(input_str)].decode())
	        myfile.write("%s\n" % input_str[i:len(input_str)])
	    myfile.close()
	    i += n
if __name__ == "__main__":
   makeblocks()
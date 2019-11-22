### convert encoding ###
# encoding: utf-8

import sys, re, json, csv, codecs,time, os,pdb
import pandas as pd
import numpy as np
import xlwt
csv.field_size_limit(sys.maxsize)

inFileName = "../data/170110_instore16gb2312.csv"
infile = open(inFileName, 'rb')
reader = csv.reader(infile, delimiter=',')

outFileName = "../data/170110_instore16utf.csv"
outfile = open(outFileName, 'wb')
#writer = csv.writer(outfile, delimiter=',')
writer = csv.writer(outfile, delimiter=',', quoting=csv.QUOTE_ALL)

#old = reader.next()
#new = [elem.decode('gb2312') for elem in old]

cnt = 0
for line in reader:
	#outline = [elem.decode('gb2312', 'replace').encode('utf-8', 'replace') for elem in line]
	outline = [elem.decode('gb2312', 'ignore').encode('utf-8') for elem in line]
	writer.writerow(outline)
	cnt = cnt + 1

infile.close
outfile.close







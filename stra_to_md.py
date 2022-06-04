import pandas as pd
import numpy as np

import os
from pandas import DataFrame, Series
import re
df = pd.read_excel(io=r'table.xlsx', sheet_name=0)

columns = df.columns.values.tolist()



for idx, row in df.iterrows():
    i = 0
    paple_md = ''
    for colum in columns:
        colum_tal = row[colum]
        paple_md += '\n # {}\n {}'.format(colum, colum_tal)
        if i == 0:
            colum_name = colum_tal
        i += 1

    f = open(colum_name + '.md', 'a',encoding='utf-8')
    f.write(paple_md)

times = ['Bahia','Vitoria',"Ypiranga"]
i = 0

for time in times:
    new = times[i]
    new = new.upper()
    times[i]= new
    i += 1

print(times)

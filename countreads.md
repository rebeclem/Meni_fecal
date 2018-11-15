# Count number of raw and cleaned reads

For this part you will need this [python script](pulling_readcount.py)

### *__Pulling number of raw reads and cleaned reads__*
```
cd Analysis &&
for f in Konzo*; do
    cd $f &&
    python ../../scripts/pulling_readcount.py &&
    cd .. &&
    echo $f
done

echo -e "Samp\tRaw\tCleaned" >> read_count.txt
for f in Konzo*; do
    reads=$(cat $f/flexbar_reads.txt) &&
    echo -e "${f}\t${reads}" >> read_count.txt &&
    echo $f
done
```
<br />

You will need to edit the `read_count.txt` file in excel prior to using it in R. See the file: [`EVKonzo_readcount.csv`](https://github.com/kmgibson/EV_konzo/blob/master/EVKonzo_readcount.csv). Basically you need to stack the "cleaned" reads below the raw.

Format needs to be as such:<br />

| Samp     | Reads   | Status | Group |
| -------------- | ----------- | ------ | ------- |
| Konzo01 | 5652615    | raw    | Kinshasa Control|
| Konzo90	| 7062682	| cleaned	| Kahemba Cases |

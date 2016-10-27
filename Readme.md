## Press Kit

Yet another attempt at creating a full-stack parsing/analysis framework.
We do it for fun anyway.

**Datasets**
- [Fetched pages - 4.7 Gb (updated 29-06-2014)](https://mega.co.nz/#!asQHTJ6D!VYiKiKKZISQsYPlAa0XeodcO1ImxrTd-oTIzrwjCIx4)
- [Parsed pages - 100 Mb (mongo dump, updated 29-06-2014)](https://mega.co.nz/#!iwYTSJoK!nhlFpGNYxpafyUoh1KDNViirjXzK3GQ7oz0inXmmwfg)

## Running

There are several steps:

- Obtain the URLs
- Save the articles in a folder
- Parse the articles
- Squash the results into one big JSON
- Analyze the full data set
- Create a visualization

Use rake tasks to trigger fetchers and parsers. 
Ex. `rake fetch:publika` or `rake parse:unimedia`

Currently in stock:

- ProTv
- Unimedia
- Publika
- Timpul
- Agora

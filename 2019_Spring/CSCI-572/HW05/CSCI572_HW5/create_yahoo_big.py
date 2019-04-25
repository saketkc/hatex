import pandas as pd
from bs4 import BeautifulSoup


import glob
import ntpath
from bs4.element import Comment


def path_leaf(path):
    head, tail = ntpath.split(path)
    return tail or ntpath.basename(head)


csv_file = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/URLtoHTML_yahoo_news.csv"
mapping_file_df = (
    pd.read_csv(csv_file).sort_values(by=["filename", "URL"]).reset_index(drop=True)
)

crawl_data_dir = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/yahoo/"
list_of_html_files = glob.glob("{}/*.html".format(crawl_data_dir))


# Credits: https://stackoverflow.com/a/1983219/756986
def tag_visible(element):
    if element.parent.name in [
        "style",
        "script",
        "head",
        "title",
        "meta",
        "[document]",
    ]:
        return False
    if isinstance(element, Comment):
        return False
    return True


def text_from_html(body):
    soup = BeautifulSoup(body, "html.parser")
    texts = soup.findAll(text=True)
    visible_texts = filter(tag_visible, texts)
    return u" ".join(t.strip() for t in visible_texts)


def is_likely_a_word(string):
    return string.isalpha()


big = []
with open("./yahoo_big.txt", "w") as fh:
    for f in list_of_html_files:
        html = open(f).read()
        text = text_from_html(html).split()
        words = filter(is_likely_a_word, text)
        for line in words:
            fh.write("{}\n".format(line.lower()))

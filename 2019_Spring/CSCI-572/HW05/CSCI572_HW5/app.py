from flask import Flask, Response, render_template, request
import json
import re
from textwrap import dedent
from wtforms import TextField, Form, RadioField
from spell import candidates, correction
import solr
import pandas as pd
from bs4.element import Comment

from bs4 import BeautifulSoup
import ntpath


def path_leaf(path):
    head, tail = ntpath.split(path)
    return tail or ntpath.basename(head)


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


def get_snippet(html_file, search_query):
    """Get list of outgoing links for the input html file.

    Parameters
    ----------
    html_file: str
               Path to html file

    Returns
    -------
    list_of_urls: list
                  List of outgoing urls

    """
    # search_query = search_query.strip()
    html = open(html_file).read()
    # soup = BeautifulSoup(open(html_file).read().encode("utf-8"))
    # text = soup.get_text()
    text = text_from_html(html)
    sentences = text.split(".")
    snippet = "None"
    # First search for all words
    for sentence in sentences:
        if search_query.lower() in sentence.lower():
            # index = sentence.find(search_query)
            snippet = sentence
            for term in search_query.split(" "):
                insensitive_term = re.compile(r"\b{}\b".format(term), re.IGNORECASE)
                # snippet = snippet.replace(r'\b{}\b'.format(term), "<strong>{}</strong>".format(term))
                for m in insensitive_term.findall(snippet):
                    snippet = snippet.replace(m, "<strong>{}</strong>".format(m))
            break
    terms = [r"\b{}\b".format(term) for term in search_query.split(" ")]
    search_regex = (r" | ").join(terms)
    regex = re.compile(r"{}".format(search_regex), flags=re.I | re.X)
    for sentence in sentences:
        if regex.search(sentence):
            snippet = sentence
            for term in search_query.split(" "):
                insensitive_term = re.compile(r"\b{}\b".format(term), re.IGNORECASE)
                for m in insensitive_term.findall(snippet):
                    snippet = snippet.replace(m, "<strong>{}</strong>".format(m))
    return snippet


CRAWL_DATA_DIR = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/yahoo"
CRAWL_CSV_MAP = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/URLtoHTML_yahoo_news.csv"

FILENAME_TO_URL_DF = pd.read_csv(CRAWL_CSV_MAP)

COLUMNS = ["Title", "URL", "ID", "Description"]
SOLR_CONNECTION_URL = "http://nucleus.usc.edu:8894/solr/myexample"
SOLR = solr.SolrConnection(SOLR_CONNECTION_URL)

app = Flask(__name__)


class SearchForm(Form):
    search_query = TextField("Search: ", id="autocomplete")
    search_strategy = RadioField(
        "",
        choices=[("solr", "Lucene (Solr Default)"), ("pageRank", "PageRank")],
        default="solr",
    )


@app.route("/_autocomplete", methods=["GET", "POST"])
def autocomplete():
    if request.method == "POST":
        data = str(request.get_data())
        search_term = data.split("=")[1]

    if search_term:
        options = candidates(search_term)
    else:
        options = []
    return Response(json.dumps(options), mimetype="application/json")


def get_corrected_search_query(search_query):
    search_query_terms = search_query.split(" ")
    search_query_corrected = list(map(lambda x: correction(x), search_query_terms))
    return " ".join(search_query_corrected).lower()


@app.route("/", methods=["GET", "POST"])
def index():
    form = SearchForm(request.form)
    if request.method == "POST" or request.args.get("q"):
        if request.method == "POST":
            search_query = form.search_query.data
            search_strategy = form.search_strategy.data
            search_query_corrected = get_corrected_search_query(search_query)
        elif request.method == "GET" and request.args.get("q"):
            search_query = request.args.get("q")
            search_strategy = request.args.get("sort")
            search_query_corrected = get_corrected_search_query(search_query)
            form.search_query.data = search_query
            form.search_strategy.data = search_strategy

        if search_query_corrected == search_query:
            message = ""
        else:
            message = '<p>Did you mean <a href="?q={0}&sort={1}">{0}</a>?</p>'.format(
                search_query_corrected, search_strategy
            )
        if search_strategy == "solr":
            response = SOLR.query(search_query)
        else:
            response = SOLR.query(search_query.strip(), sort="pageRankFile desc")
        data = []
        for hit in response.results:
            html_file = hit["id"]
            filename = hit["id"].replace(CRAWL_DATA_DIR, "")[1:]
            url = FILENAME_TO_URL_DF[FILENAME_TO_URL_DF.filename == filename].URL.iloc[
                0
            ]
            url_text = "<a href='{0}'>{0}</a>".format(url)
            try:
                description = hit["description"]
            except KeyError:
                description = ""
            if isinstance(description, list):
                description = description[0]
            snippet = get_snippet(html_file, search_query)
            record = {
                "Title": hit["title"][0],
                "ID": hit["id"],
                "Description": description,
                "URL": url_text,
                "Snippet": snippet,
            }
            data.append(record)

        df = pd.DataFrame(data)
        table = ""  # <div><hr>'
        for record in data:
            table += "<div>\n"
            table += "<hr>\n"
            table += "<table>\n"
            for key in ["Title", "ID", "Description", "URL", "Snippet"]:
                table += "<tr><td>{}</td><td>{}</td></tr>\n".format(
                    key, str(record[key])
                )
            table += "</table>\n"
            table += "<hr>\n"
            table += "</div>\n"

        # table += '</div>'
        table = dedent(table)
        return render_template(
            "search.html",
            form=form,
            table=table,  # df.to_html(classes="data", header="true", index=False),
            titles=df.columns.values,
            message=message,
        )

    return render_template("search.html", form=form)


if __name__ == "__main__":
    app.run(debug=True)

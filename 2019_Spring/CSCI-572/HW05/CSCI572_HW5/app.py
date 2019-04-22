from flask import Flask, Response, render_template, request
import json
from wtforms import TextField, Form, RadioField
from spell import candidates  # , correction
import solr
import pandas as pd

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


@app.route("/", methods=["GET", "POST"])
def index():
    form = SearchForm(request.form)
    if request.method == "POST":
        search_query = form.search_query.data
        search_strategy = form.search_strategy.data
        if search_strategy == "solr":
            response = SOLR.query(search_query)
        else:
            response = SOLR.query(search_query.strip(), sort="pageRankFile desc")
        data = []
        for hit in response.results:
            filename = hit["id"].replace(CRAWL_DATA_DIR, "")[1:]
            url = FILENAME_TO_URL_DF[FILENAME_TO_URL_DF.filename == filename].URL.iloc[
                0
            ]
            url_text = url  # "<a href='{0}'>{0}</a>".format(url)
            try:
                description = hit["description"]
            except KeyError:
                description = ""
            record = {
                "Title": hit["title"],
                "ID": hit["id"],
                "Description": description,
                "URL": url_text,
            }
            data.append(record)

        df = pd.DataFrame(data)
        return render_template(
            "search.html",
            form=form,
            table=df.to_html(classes="data", header="true"),
            titles=df.columns.values,
        )

    return render_template("search.html", form=form)


if __name__ == "__main__":
    app.run(debug=True)

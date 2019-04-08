import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import dash_table as dt
import solr
import pandas as pd

CRAWL_DATA_DIR = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/yahoo"
CRAWL_CSV_MAP = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/URLtoHTML_yahoo_news.csv"

FILENAME_TO_URL_DF = pd.read_csv(CRAWL_CSV_MAP)

COLUMNS = ["Title", "URL", "ID", "Description"]

SOLR_CONNECTION_URL = "http://nucleus.usc.edu:8983/solr/myexample"
SOLR = solr.SolrConnection(SOLR_CONNECTION_URL)

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]


def Table(dataframe):
    rows = []
    for i in range(len(dataframe)):
        row = []
        for col in dataframe.columns:
            value = dataframe.iloc[i][col]
            # update this depending on which
            # columns you want to show links for
            # and what you want those links to be
            if col == "URL":
                cell = html.Td(html.A(href=value, children=value))
            else:
                cell = html.Td(children=value)
            row.append(cell)
        rows.append(html.Tr(row))
    return html.Table(
        # Header
        [html.Tr([html.Th(col) for col in dataframe.columns])]
        + rows
    )


# app = dash.Dash()

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.css.append_css({"external_url": "https://codepen.io/chriddyp/pen/dZVMbK.css"})

app.layout = html.Div(
    children=[
        html.H1(children="Yahoo Solr Client"),
        # html.Div(
        #    children="""
        # Yahoo Solr Client.
        # """
        # ),
        html.Label("Search term: "),
        dcc.Input(id="search-term", value="", type="text"),
        dcc.Dropdown(
            id="search-option",
            options=[
                {"label": "Lucene (Solr Default)", "value": "solr"},
                {"label": "PageRank", "value": "pageRank"},
            ],
            value="solr",
            style={"width": "50%", "font-family": "Droid Serif"},
        ),
        html.Button(id="submit", type="submit", children="Submit", n_clicks=0),
        html.Div(id="results"),
    ]
)


def write_search_results(
    table,
    search_term,
    search_option="solr",
    path="/media/dna/github/hatex/2019_Spring/CSCI-572/HW04/search_results",
):
    table[["URL"]].to_csv(
        "{}/{}.{}.tsv".format(path, search_term, search_option),
        index=False,
        header=True,
    )


@app.callback(
    Output(component_id="results", component_property="children"),
    [
        Input("search-term", "value"),
        Input("search-option", "value"),
        Input("submit", "n_clicks"),
    ],
)
def update_output_div(search_term, search_option, n_clicks):
    if search_option == "solr":
        response = SOLR.query(search_term)
    else:
        response = SOLR.query(search_term.strip(), sort="pageRankFile desc")
    data = []
    for hit in response.results:
        filename = hit["id"].replace(CRAWL_DATA_DIR, "")[1:]
        url = FILENAME_TO_URL_DF[FILENAME_TO_URL_DF.filename == filename].URL.iloc[0]
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

    table = dt.DataTable(
        columns=[{"name": column, "id": column} for column in COLUMNS],
        id="results-table",
        data=data,
        style_data={"whiteSpace": "normal"},
        css=[
            {
                "selector": ".dash-cell div.dash-cell-value",
                "rule": "display: inline; white-space: inherit; overflow: inherit; text-overflow: inherit;",
            }
        ],
    )
    df = pd.DataFrame(data)
    write_search_results(df, search_term, search_option)
    return Table(df)


if __name__ == "__main__":
    app.run_server(host="nucleus.usc.edu", debug=True)

from flask import Flask, Response, render_template, request
import json
from wtforms import TextField, Form
from spell import candidates  # , correction

app = Flask(__name__)


class SearchForm(Form):
    autocomp = TextField("Search: ", id="autocomplete")


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
    return render_template("search.html", form=form)


if __name__ == "__main__":
    app.run(debug=True)

from flask import Flask, Response, render_template, request
import json
from wtforms import TextField, Form
import solr
import pandas as pd
from spell import candidates, correction

app = Flask(__name__)

cities = ["Bratislava",
          "Banská Bystrica",
          "Prešov",
          "Považská Bystrica",
          "Žilina",
          "Košice",
          "Ružomberok",
          "Zvolen",
          "Poprad"]


class SearchForm(Form):
    autocomp = TextField('Search: ', 
                         id='autocomplete')


@app.route('/_autocomplete', methods=['GET', 'POST'])
def autocomplete():
    if request.method=='POST':
        #print(request.term)
        #print(request.get_json())
        data = str(request.get_data())
        search_term = data.split('=')[1]
        #search_term = request.args.get('term')
        print(data)
                   
    #search_string = str(request.args.get('input'))
    #print(search_string)
    #print(search_term)
    if search_term:
        options = candidates(search_term)
        print(options)
    else:
        options = []
    return Response(json.dumps(options), mimetype='application/json')


@app.route('/', methods=['GET', 'POST'])
def index():
    form = SearchForm(request.form)
    return render_template("search.html", form=form)

if __name__ == '__main__':
    app.run(debug=True)

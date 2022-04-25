import os
import json
import requests
import pandas as pd
from dash import Dash, dash_table, html, dcc

API_KEY = os.environ['API_KEY']
ENDPOINT = os.environ['ENDPOINT']

app = Dash(__name__)
columns = ['sourceId', 'sourceName', 'validFrom']


# Get data from backend
def get_data():
    endpoint = ENDPOINT
    headers = {"x-api-key": API_KEY, 'content-type': 'application/json'}
    body = {'action': 'getlist'}

    r = requests.post(endpoint, data=json.dumps(body), headers=headers)
    rjson = r.json()
    if r.status_code == 200:
        data = rjson['data']
        return json.loads(data)['Items']
    else:
        print('Error! Returned status code %s' % r.status_code)
        print('Message: %s' % json['error']['message'])
        print('Reason: %s' % json['error']['reason'])


df = pd.DataFrame(get_data())
df['validFrom'] = df['validFrom'].astype(str).astype(int)
df = df.nsmallest(10, 'validFrom')
df['validFrom'] = pd.to_datetime(df['validFrom'], unit='s').apply(lambda x: x.date())

app.layout = html.Div([
        html.H1(children='Demitov variant 13'),
        html.Div(children='''Top 10 Norway weather stations which measures wind from direction.'''),
        html.Button('Update', id='buttom-update', n_clicks=0),
        html.Button('Get data', id='buttom-getdata', n_clicks=0),
        html.Button('Test', id='buttom-test', n_clicks=0),
        dash_table.DataTable(
            style_data={
                'whiteSpace': 'normal',
                'height': 'auto',
                'maxWidth': 0
            },
            data=df.to_dict('records'),
            columns=[{"name": i, "id": i} for i in df[columns].columns]
        )
])


if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0')

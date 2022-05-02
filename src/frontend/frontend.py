import os
import json
import requests
import pandas as pd
from dash import Dash, dash_table, html, Input, Output, callback_context

API_KEY  = os.environ['API_KEY']
ENDPOINT = os.environ['ENDPOINT']

app = Dash(__name__)
columns = ['sourceId', 'sourceName', 'validFrom']


# Get data from backend
def get_data(action):
    endpoint = ENDPOINT
    headers = {"x-api-key": API_KEY, 'content-type': 'application/json'}
    body = {'action': action}

    r = requests.post(endpoint, data=json.dumps(body), headers=headers)
    rjson = r.json()
    if r.status_code == 200:
        data = rjson['data']
        print(data)
        return json.loads(data) #['Items']
    else:
        print('Error! Returned status code %s' % r.status_code)
        print('Message: %s' % json['error']['message'])
        print('Reason: %s' % json['error']['reason'])


if not get_data('getlist'):
    df = pd.DataFrame(get_data('update')['Items'])
    print('run update')
else:
    df = pd.DataFrame(get_data('getlist')['Items'])
    print('run getlist')

df['validFrom'] = df['validFrom'].astype(str).astype(int)
df = df.nsmallest(10, 'validFrom')
df['validFrom'] = pd.to_datetime(df['validFrom'], unit='s').apply(lambda x: x.date())

app.layout = html.Div([
        html.H1(children='Demitov variant 13'),
        html.Div(children='''Top 10 Norway weather stations which measures wind from direction.'''),
        html.Table([
            html.Tr([
                html.Button('Clear DB', id='button-clear', n_clicks=0),
                html.Button('Update DB', id='button-update', n_clicks=0),
                html.Button('Get data', id='button-getdata', n_clicks=0),
                html.Div(id='container-buttons')
            ]),
            html.Tr([
                html.Td(
                    dash_table.DataTable(
                        id='data-table',
                        style_data={
                            'whiteSpace': 'normal',
                            'height': 'auto',
                            'minWidth': '200px'
                        },
                        data=df.to_dict('records'),
                        columns=[{"name": i, "id": i} for i in df[columns].columns],
                        fill_width=False
                    )
                ),
                html.Td(children=
                    html.H1(children=''), # add icons
                    style={'textAlign': 'center'},
                )
            ])
        ])
])


@app.callback(
            Output('container-buttons', 'children'),
            Input('button-clear', 'n_clicks'),
            Input('button-update', 'n_clicks'),
            Input('button-getdata', 'n_clicks')
            )
def click_buttons(btn_clr, btn_upd, btn_get):
    changed_id = [p['prop_id'] for p in callback_context.triggered][0]
    if 'button-clear' in changed_id:
        get_data('clear')
        msg = 'CLEARED'
    elif 'button-update' in changed_id:
        get_data('update')
        msg = 'UPDATED'
    elif 'button-getdata' in changed_id:
        get_data('getlist')
        msg = 'DATA GETTED'
    else:
        msg = 'None of the buttons have been clicked yet'
    return html.Div(msg)


if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0', port='80')

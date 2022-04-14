import json
import requests
from datetime import datetime
import boto3
#import os

# CLIENT_ID = os.environ['CLIENT_ID']
CLIENT_ID = 'fc172899-0d19-40dc-9a1f-88949b778e48'
RESULT_DATA = list()

client = boto3.client('dynamodb')
dynamodb = boto3.resource('dynamodb')

table_name = 'demitov-v13'

# Get data from API
def get_data(endpoint: str, parameters: dict):
    r = requests.get(endpoint, parameters, auth=(CLIENT_ID, ''))
    json = r.json()

    if r.status_code == 200:
        data = json['data']
    else:
        print('Error! Returned status code %s' % r.status_code)
        print('Message: %s' % json['error']['message'])
        print('Reason: %s' % json['error']['reason'])
    return data

# Get stations Norway
def get_stations():
    endpoint = 'https://frost.met.no/sources/v0.jsonld'
    parameters = {
        'types': 'SensorSystem',
        'elements': 'wind_from_direction',
        'country': 'NO',
        'fields': 'id, name'}

    data = get_data(endpoint, parameters)

    for record in data:
        sensor_data = dict(
            sourceId   = record['id'],
            sourceName = record['name'],
        )
        RESULT_DATA.append(sensor_data)


# Get avaliable times for stations
def get_avaliable_times():
    endpoint = 'https://frost.met.no/observations/availableTimeSeries/v0.jsonld'
    parameters = {
        'elements': 'wind_from_direction',
        'fields': 'sourceId, validFrom'
    }
    data = get_data(endpoint, parameters)


    for record in data:
        for row in RESULT_DATA:
                if row['sourceId']== record['sourceId'][:-2]:
                    row['validFrom'] = int(round(datetime.fromisoformat(record['validFrom'][:-1]).timestamp()))

# Init table in DynamoDB
def init_table():
    existing_tables = client.list_tables()['TableNames']

    if table_name not in existing_tables:
        table = client.create_table(
            TableName=table_name,
            KeySchema=[{'AttributeName': 'sourceId', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'sourceId', 'AttributeType': 'S'}],
            ProvisionedThroughput={'ReadCapacityUnits':10, 'WriteCapacityUnits':10}
        )

# Update data in table
def update_table():
    table = dynamodb.Table(table_name)
    for item in RESULT_DATA:
        try:
            table.update_item(
                Key={'sourceId':item['sourceId']},
                UpdateExpression="set #n=:sourceName, #v=:validFrom",
                ExpressionAttributeNames={
                    '#n': 'sourceName',
                    '#v': 'validFrom'
                },
                ExpressionAttributeValues={
                    ':sourceName': item['sourceName'],
                    ':validFrom': item['validFrom']
                },
            )
        except Exception as e:
            print (e)


def lambda_handler(event, context):
    init_table()
    get_stations()
    get_avaliable_times()
    update_table()

    message = 'From API Gateway {} {} {}!'.format(event['type'], event['authorizationToken'], event['methodArn'])
    return {
        'statusCode': 200,
        'message' : message
    }

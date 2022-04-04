import json
import requests
from datetime import datetime
import sqlalchemy as sa
from sqlalchemy.orm import Session, relationship
from sqlalchemy.ext.declarative import declarative_base
# import os


# CLIENT_ID = os.environ['CLIENT_ID']
client_id = 'fc172899-0d19-40dc-9a1f-88949b778e48'

RESULT_DATA = list()

Base = declarative_base()
engine = sa.create_engine('sqlite:///stations.db', echo=False)


class Stations(Base):
    __tablename__ = 'stations'
    id        = sa.Column(sa.Integer, primary_key=True) #, autoincrement=True)
    sourceId  = sa.Column(sa.String(12), unique=False, nullable=False)
    name      = sa.Column(sa.String(32), unique=False, nullable=False)
    validFrom = sa.Column(sa.DateTime, unique=False, nullable=False)

    def __init__(self, sourceId, name, validFrom):
        self.sourceId  = sourceId
        self.name      = name
        self.validFrom = validFrom


def get_data(endpoint: str, parameters: dict):
    r = requests.get(endpoint, parameters, auth=(client_id, ''))
    json = r.json()

    if r.status_code == 200:
        data = json['data']
    else:
        print('Error! Returned status code %s' % r.status_code)
        print('Message: %s' % json['error']['message'])
        print('Reason: %s' % json['error']['reason'])
    return data


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
            sourceId = record['id'],
            name     = record['name'],
        )
        RESULT_DATA.append(sensor_data)


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
                    row['validFrom'] = datetime.fromisoformat(record['validFrom'][:-1])


def db_init():
    Base.metadata.create_all(engine)


def db_write():

    with Session(engine) as session:
        for item in RESULT_DATA:
            sourceId = item['sourceId']
            name = item['name']
            if item.get('validFrom'):
                validFrom = item['validFrom']

            entry = Stations(sourceId, name, validFrom)
            session.add(entry)

        session.commit()


# MOVE TO LAMBDA FUNCTION
db_init()
get_stations()
get_avaliable_times()
db_write()

# -----------------------------------------------------------------------------
# def lambda_handler(event, context):
#     return {
#         'statusCode': 200)
#     }
# -----------------------------------------------------------------------------

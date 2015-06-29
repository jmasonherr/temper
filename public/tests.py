
import requests
from copy import copy

LOCAL = True
base = 'http://localhost:3000/api/%s' if LOCAL else 'http://temper.meteor.com/api/%s'

# RUN WITH PYTHON 3
headers = {'content-type': 'application/json'}

data = {'secret': 'iridemybicycle'}


def testStart():
    url = base % 'start'
    response = requests.post(url, data)
    # Worked
    assert response.status_code == 200

    js = response.json()
    print js
    assert type(js['_id']) == unicode
    assert type(js['temps']) == list
    assert type(js['times']) == list

    assert js['status'] == 'running'

    print('meteorscan.py ok')


def testGetStatus():
    url = base % 'getstatus'
    d = copy(data)
    response = requests.post(url, d, headers=headers)
    # Worked
    assert response.status_code == 200
    js = response.json()
    print js
    assert js['status'] == 'tempering'


def testStatus():
    url = base % 'status'
    d = copy(data)
    d['status'] = 'tempering'
    response = requests.post(url, d, headers=headers)
    # Worked
    assert response.status_code == 200
    js = response.json()
    print js
    assert js['status'] == 'tempering'


def testAddTemp():
    url = base % 'temp'
    d = copy(data)
    d['temp'] = 79.0
    response = requests.post(url, d, headers=headers)
    # Worked
    assert response.status_code == 200
    js = response.json()
    print js


if __name__ == '__main__':
    testStart()
    testStatus()
    testGetStatus()
    testAddTemp()
    testStatus()
    testAddTemp()
    testAddTemp()
    testAddTemp()

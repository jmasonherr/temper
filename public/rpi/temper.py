import os
import datetime
import subprocess

import RPi.GPIO as GPIO

from w1thermsensor import W1ThermSensor

from MeteorClient import MeteorClient

# from threading import Timer


FAN = 14
R1 = 15
R2 = 18
TESTING = True
URL = 'ws://127.0.0.1:3000/websocket' if TESTING else 'ws://temper.meteor.com/websocket'

HEAT_SLEEP = 5
COOL_SLEEP = 180
WAIT_SLEEP = 1
TEMP_EVERY = 60

MAX_TEMP = 165.0
MIN_TEMP = 80.0

TEMPER_LO = 81.0

TEMPER_HOLD_LO = 89.5
TEMPER_HOLD_HI = 90.2

REFINER1_ID = 'refiner1id'
REFINER2_ID = 'refiner12id'

OBJS = {
    # REFINER1_ID: {
    #     'sensor':
    #     'pin':
    # },
    # REFINER2_ID: {
    #     'sensor':
    #     'pin':
    # }
}

client = MeteorClient(URL)

# def hello():
#     print "hello, world"

# t = Timer(30.0, hello)
# t.start()


def temp(id):
    sensor = OBJS[id]['sensor']
    if sensor:
        t = sensor.get_temperature(W1ThermSensor.DEGREES_F)
        print 'Temp is: %.2f' % t
        return t
    else:
        print 'Trying to get temp with unavailable sensor'
        print OBJS


def is_running(id):
    return GPIO.input(OBJS[id]['pin'])


def stop(id):
    print 'Stopping %s' % id
    if is_running(id):
        GPIO.output(OBJS[id]['pin'], False)


def generic(*args, **kwargs):
    print 'Generic Event: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def connected(*args, **kwargs):
    print 'Connected to server: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def socket_closed(*args, **kwargs):
    print 'Socket closed: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def reconnected(*args, **kwargs):
    print 'Re-connected to server: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def failed(*args, **kwargs):
    print 'FAILED AT: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def added(*args, **kwargs):
    print 'Added: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def changed(*args, **kwargs):
    print 'Changed: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def removed(*args, **kwargs):
    print 'Removed: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def subscribed(*args, **kwargs):
    print 'subscribed: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def unsubscribed(*args, **kwargs):
    print 'Unsubscribed: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def logging_in(*args, **kwargs):
    print 'Logging in: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def sensor_create_callback(*args, **kwargs):
    print 'Create sensor callback'
    print args
    print kwargs


def logged_in(*args, **kwargs):
    print 'Logged in: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs
    print 'Creating machines...'
    for sensor in W1ThermSensor.get_available_sensors():
        client.call('getOrCreateMachine', sensor.id, callback=sensor_create_callback)
    for fakesensor in ['refiner1id', 'refiner12id']:
        client.call('getOrCreateMachine', fakesensor, callback=sensor_create_callback)


def logged_out(*args, **kwargs):
    print 'Logged out: %s' % datetime.datetime.now().isoformat()
    print args
    print kwargs


def setup_events(client):
    client.on('connected', connected)
    client.on('socket_closed', socket_closed)
    client.on('reconnected', reconnected)
    client.on('failed', failed)
    client.on('added', added)
    client.on('changed', changed)
    client.on('removed', removed)
    client.on('subscribed', subscribed)
    client.on('unsubscribed', unsubscribed)
    client.on('logging_in', logging_in)
    client.on('logged_in', logged_in)
    client.on('logged_out', logged_out)


def main():
    username = os.environ.get('TEMPER_USERNAME')
    password = os.environ.get('TEMPER_PASSWORD')

    if not username:
        username = raw_input('Whats your username?\n')

    if not password:
        password = raw_input('Whats your password?\n')

    client.setup_events()
    client.connect()

    client.login(username, password, callback=logged_in)

    try:
        GPIO.cleanup()
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(FAN, GPIO.OUT)
        GPIO.setup(R1, GPIO.OUT)
        GPIO.setup(R2, GPIO.OUT)
    except Exception, e:
        print 'EXCEPTION SETTING UP MAIN GPIO'
        print e
        GPIO.cleanup()
        if not TESTING:
            return

    # ToDO: generalize this to multiple machines setup by the server
    sensor1 = W1ThermSensor(W1ThermSensor.THERM_SENSOR_DS18B20, REFINER1_ID)

    OBJS[REFINER1_ID] = {
        'sensor': sensor1,
        'pin': R1
    }

    sensor2 = W1ThermSensor(W1ThermSensor.THERM_SENSOR_DS18B20, REFINER2_ID)

    OBJS[REFINER2_ID] = {
        'sensor': sensor2,
        'pin': R2
    }
    # TODO: add subscriptions here


def _shutdown(restart=False):
    action = 'h'
    if restart:
        action = 'r'
    GPIO.cleanup()
    command = "/usr/bin/sudo /sbin/shutdown -%s now" % action
    subprocess.Popen(command.split(), stdout=subprocess.PIPE)


def shutdown():
    _shutdown()


def restart():
    _shutdown(True)

# Keep the temperature steady for grating tempered cocoa butter into
# -*- coding: utf-8 -*-

"""
We want 33.6 C for the cocoa butter
we want 33-34 for the chocolate mass
Regardless, you add this pure cocoa butter seed crystal at a
rate of 1% w/w to your chocolate. The different thing here is that
you add it at 92.5 F (33.6 C). In classic tempering this is
 way too hot for spontaneous crystal formation. Any Type V
 crystal would completely melt and untemper. But in this
 seeded mixture, only a portion of the seed is untempered
 and the remaining seed (because it is pure cocoa butter
    and not a mixture of ‘contaminated’ with sugar and
    cocoa particles) creates very aggressive nucleation
sites. The result is that your chocolate tempers very quickly.
 And by pouring up at a higher temperature, the viscosity is
  lower so your chocolate is easier to work with, degases
   faster and can give a nicer looking chocolate.
"""

T = 33.0
RELAY = 15
LIGHT = 18
BREAK = 33.0
ID_TO_PIN = {
    '28-000006893209': 15,
    '28-00000651dea5': 18,  #  name: 'Xochipilli'
    '28-00000688662f': 15,  #  name: 'Xochiquetzal'
}
TESTING = False
URL = 'http://localhost:3000' if TESTING else 'http://temper.meteor.com'
import time
import json
import RPi.GPIO as GPIO
import requests

from w1thermsensor import W1ThermSensor


def on(pin):
    if not GPIO.input(pin):
        GPIO.output(pin, True)


def off(pin):
    if GPIO.input(pin):
        GPIO.output(pin, False)


def flash_error():
    # Shutoff all
    for sensor in W1ThermSensor.get_available_sensors():
        pin = RELAY
        # Accomodate multiples
        if sensor.id in ID_TO_PIN:
            _sid = '28-' + sensor.id
            pin = ID_TO_PIN[_sid]
        GPIO.output(pin, False)
    # Flash every second
    #while True:
        #time.sleep(1)
        #GPIO.output(LIGHT, not GPIO.input(LIGHT))


def postTemp(sensorId, temp):
    headers = {'content-type': 'application/json'}
    data = {'secret': 'iridemybicycle'}
    data['sensorId'] = sensorId
    data['temp'] = temp
    try:
        response = requests.post(URL + '/temp', json.dumps(data), headers=headers)
    except Exception, e:
        print 'EXCEPTION POSTING TEMP'
        print data
        print e
    return response


def main(post=True):
    print 'running main...'
    responses = {}
    try:
        print 'Getting GPIO ready'
        GPIO.cleanup()
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(LIGHT, GPIO.OUT)
        _pin = RELAY

        # Setup sensors
        for sensor in W1ThermSensor.get_available_sensors():
            print 'Detected sensor ', sensor.id
            _sid = '28-' + sensor.id
            if _sid in ID_TO_PIN:
                _pin = ID_TO_PIN[_sid]
            responses[_sid] = {'status': 'temper'}

            GPIO.setup(_pin, GPIO.OUT)
            print 'Success with one sensor'
        print 'Success with all sensors'
    except Exception, e:
        print 'EXCEPTION SETTING UP MAIN GPIO'
        print e
        GPIO.cleanup()

    while True:
        i = 0;
        time.sleep(3)
        print 'Loooooooping....'
        try:
            for sensor in W1ThermSensor.get_available_sensors():
                print sensor.id
                sensorId = '28-' + sensor.id
                try:
                    t = sensor.get_temperature()
                except:
                    print 'Sensor not ready....', sensorId
                    continue
                print t
                action = responses[sensorId]['status']

                if post and (i % 10) == 0:
                    response = postTemp(sensorId, t)
                    if response.status_code == 200:
                        print '200 Response for ', sensorId
                        responses[sensorId] = response.json()

                        action = response.json()['status']
                    else:
                        print response
                        print 'Error in post, not 200 - ', response.status_code
                        print response.content

                print action

                # Light up
                # if 33.0 <= t <= 33.5:
                #     on(LIGHT)
                # else:
                #     off(LIGHT)

                # Is it a real reading?
                if t == 85.0:
                    print 'Not a real reading on ', sensorId
                    continue

                pin = RELAY
                # Accomodate multiples
                if sensorId in ID_TO_PIN:
                    pin = ID_TO_PIN[sensorId]

                # Safety checks
                if t >= 65.0 or t <= 27.0:
                    print 'TOO HOT on ', sensorId
                    # Too hot or too cold
                    off(pin)
                    flash_error()

                if action == 'temper':
                    print 'TEMPERING ', sensorId
                    if t < BREAK:
                        on(pin)
                    if t >= BREAK:
                        off(pin)

                elif action == 'stop':
                    print 'Stopping ', sensorId

                    off(pin)

                elif action == 'run':
                    print 'Running ', sensorId

                    on(pin)

                else:
                    print 'UNKNOWN ACTION:', action, sensorId
        except Exception, e:
            print "EXCEPTION IN RULOOP", e

        i += 1




if __name__ == '__main__':
    try:
        main()
    except:
        print 'Quitting'
    finally:
        GPIO.cleanup()

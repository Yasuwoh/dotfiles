#!/usr/bin/env python
#encoding : utf-8

import sys
import argparse
import logging
import datetime
import time
import subprocess

try:
    import ephem
except ModuleNotFoundError:
    sys.exit (1)

class choice:
    def __init__ (self, star = None, attr = None):
        self.star = star
        self.attr = attr

CHOICES = {
        'sunrise' : choice (star = ephem.Sun,  attr = 'next_rising' ),
        'sunset'  : choice (star = ephem.Sun,  attr = 'next_setting'),
        'moonrise': choice (star = ephem.Moon, attr = 'next_rising' ),
        'moonset' : choice (star = ephem.Moon, attr = 'next_setting'),
        }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument ('--city', default = 'Tokyo')
    parser.add_argument ('--longitude')
    parser.add_argument ('--latitude')
    parser.add_argument ('--elevation', type = int)
    parser.add_argument ('at', choices = CHOICES.keys() )
    parser.add_argument ('command', nargs = argparse.REMAINDER)
    args = parser.parse_args()
    logging.debug ('args = %s' % args)

    place = ephem.city (args.city)
    if args.latitude is not None:
        place.lat = args.latitude
    if args.longitude is not None:
        place.lon = args.longitude
    if args.elevation is not None:
        place.elevation = args.elevation

    logging.debug ('place = %s' % place)

    star = CHOICES[args.at].star()
    timeat = getattr(place, CHOICES[args.at].attr) (star)
    delta = timeat.datetime() - datetime.datetime.utcnow()

    logging.debug ('going at %s' % ephem.localtime(timeat))

    try:
        time.sleep (delta.seconds)
        subprocess.run (args.command)
    except KeyboardInterrupt:
        sys.exit(1)

if __name__ == '__main__':
    main()


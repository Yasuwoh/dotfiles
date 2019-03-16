#!/usr/bin/env python3
# encoding: utf-8

import urllib.request
import json
import datetime

# 設定関連
equrl = 'https://api.p2pquake.net/v1/human-readable'
reportspan = datetime.timedelta (days = 0.5)

# コード変換
Scale = {
        0: '揺れ無し',
        10: '震度1',
        20: '震度2',
        30: '震度3',
        40: '震度4',
        45: '震度5弱',
        50: '震度5強',
        55: '震度6弱',
        60: '震度6強',
        70: '震度7'
        }
Tsunami = {
        'None': '',
        'Unknown': '津波不明',
        'Checking': '津波調査中',
        'NonEffective': '津波の被害無し',
        'Watch': '津波注意報',
        'Warning': '津波予報あり'
        }


def main():
    nowdt = datetime.datetime.now()

    req = urllib.request.Request (equrl)
    res = urllib.request.urlopen (req)
    body = res.read()
    eqjson = json.loads (body)
    for eq in eqjson:
        # 発表時刻との差分をチェック
        dt = datetime.datetime.strptime (eq['time'], '%Y/%m/%d %H:%M:%S.%f')
        if nowdt - dt > reportspan:
            continue

        # 気象庁からの地震情報のみをチェック
        if eq['code'] != 551 or eq['issue']['source'] != '気象庁':
            continue

        eqtime = datetime.datetime.strptime (eq['earthquake']['time'], u'%d日%H時%M分')
        eqscale = eq['earthquake']['maxScale']
        eqtsunami = eq['earthquake']['domesticTsunami']
        eqhcname = eq['earthquake']['hypocenter']['name']
        eqhcdepth = eq['earthquake']['hypocenter']['depth']
        eqhcmagnitude = eq['earthquake']['hypocenter']['magnitude']

        print (('%s %s M%s %s %s' % (
            eqtime.strftime ('%H:%M'),
            eqhcname,
            eqhcmagnitude,
            Scale[eqscale],
            Tsunami[eqtsunami],
            )).strip()
            )


if __name__ == '__main__':
    main()

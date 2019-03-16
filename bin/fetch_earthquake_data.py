#!/usr/bin/env python3
# encoding: utf-8

import urllib.request
import json
import datetime, time
import os, os.path

# 設定関連
eqinfofile = '~/.tmux/earthquakeinfo.txt'
eqinfointerval = datetime.timedelta (minutes = 1)
equrl = 'https://api.p2pquake.net/v1/human-readable'
blinkscale = 40
reportspan = datetime.timedelta (hours = 1)
viewtime = datetime.timedelta (seconds = 10)

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


class NeedToUpdateEqInfo (Exception):
    pass

def main():
    # 現在時刻
    nowdt = datetime.datetime.now()
    # 地震情報
    eqinfo = list()

    # 地震情報ファイルパスを絶対パスに変換
    ab_eqinfofile = os.path.expanduser( os.path.expandvars( eqinfofile ) )

    # ab_eqinfofile のタイムスタンプが更新インターバルより古ければ、取得しに行く
    try:
        try:
            mdt = datetime.datetime.fromtimestamp (os.stat(ab_eqinfofile).st_mtime)
            if nowdt - mdt > eqinfointerval:
                raise NeedToUpdateEqInfo()
        except OSError:
            raise NeedToUpdateEqInfo()
    except NeedToUpdateEqInfo:

        # 地震情報を取得しに行く
        req = urllib.request.Request (equrl)
        with urllib.request.urlopen (req) as res:
            # レスポンスをJSONパース
            body = res.read().decode('utf-8')
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

                eqline = ('%s %s M%s %s %s' % (
                    eqtime.strftime ('%H:%M'),
                    eqhcname,
                    eqhcmagnitude,
                    Scale[eqscale],
                    Tsunami[eqtsunami],
                    )).strip()
                if eqscale >= blinkscale:
                    eqline = '#[blink]' + eqline + '#[default]'
                eqinfo.append (eqline)

        # ファイルへ書き込む
        fd = open (ab_eqinfofile, 'w')
        fd.write ('\n'.join (eqinfo))
    else:
        # ファイルから地震情報を読み込む
        fd = open (ab_eqinfofile, 'r')
        for line in fd:
            eqinfo.append (line.strip())

    finally:
        if len(eqinfo) > 0:

            # 現在時刻に基づいて eqinfo から一件出力
            i = int( ( time.mktime (nowdt.timetuple()) / viewtime.total_seconds() ) % len(eqinfo) )
            print (eqinfo[i])

if __name__ == '__main__':
    main()

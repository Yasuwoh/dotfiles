#!/usr/bin/env python3
# encoding: utf-8

import urllib.request
import json
import datetime, time
import os, os.path

# 設定関連
eqinfofile = '~/.tmux/earthquakeinfo.txt'
eqinfointerval = datetime.timedelta (seconds = 10)
equrl = 'https://api.p2pquake.net/v1/human-readable'
blinkscale = 40
reportspan = datetime.timedelta (minutes = 60)
viewtime = datetime.timedelta (seconds = 10)

# コード変換
Scale = {
        0: '震度0',
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
        'None': None,
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
            stat = os.stat(ab_eqinfofile)
            mdt = datetime.datetime.fromtimestamp (stat.st_mtime)
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

                # 使う情報を取り出す。
                # 文字列への変換は必要なときにやるので、ここではできる限りネイティブに情報を取り出す。
                oid = eq['_id']['$oid'] # OID
                issue_type = eq['issue']['type'] # 発表の種類
                eqtime = datetime.datetime.strptime (eq['earthquake']['time'], u'%d日%H時%M分') # 発生日時
                eqscale = eq['earthquake']['maxScale'] # 最大震度
                eqtsunami = eq['earthquake']['domesticTsunami'] # 津波
                try: # 震源名
                    eqhcname = eq['earthquake']['hypocenter']['name'] or eq['points'][0]['addr']
                except (IndexError, KeyError):
                    eqhcname = None
                eqhcdepth = eq['earthquake']['hypocenter']['depth'] or None # 震源深さ
                eqhcmagnitude = eq['earthquake']['hypocenter']['magnitude'] or None# マグニチュード

                # ここから表示内容の生成
                # このリストをjoinして表示行を作る。
                eqlineparts = list()

                # 発表種類に応じたプレフィックス
                if issue_type == 'DetailScale': # 各地の震度に関する情報
                    pass
                elif issue_type == 'ScalePrompt': # 地震速報
                    eqlineparts.append( '[速報]' )
                elif issue_type == 'Destination': # 震源情報
                    eqlineparts.append( '[震源]' )
                else:
                    # 処理対象ではない発表種類の場合は continue して行を追加しない
                    continue

                # テンプレ表示内容
                eqlineparts.extend ([ x for x in [
                    eqtime.strftime ('%H:%M' if eqtime.day == nowdt.day else '%d日%H:%M' ),
                    eqhcname,
                    eqhcdepth,
                    'M' + eqhcmagnitude if eqhcmagnitude else None,
                    Scale.get (eqscale, None),
                    Tsunami.get (eqtsunami, None),
                    ] if x is not None ])

                # joinして表示内容を作ったあと、閾値を超える震度の場合は点滅させる
                eqline = ' '.join(eqlineparts)
                if type(eqscale) is int and eqscale >= blinkscale:
                    eqline = '#[fg=red]' + eqline + '#[default]'
                eqinfo.append (eqline)

        # ファイルへ書き込む
        with open (ab_eqinfofile, 'w') as fd:
            fd.write ('\n'.join (eqinfo))
    else:
        # ファイルから地震情報を読み込む
        if stat.st_size > 0:
            with open (ab_eqinfofile, 'r') as fd:
                for line in fd:
                    eqinfo.append (line.strip())

    finally:
        if len(eqinfo) > 0:

            # 現在時刻に基づいて eqinfo から一件出力
            i = int( ( time.mktime (nowdt.timetuple()) / viewtime.total_seconds() ) % len(eqinfo) )
            output = eqinfo[i]
            if len(eqinfo) >= 2:
                output += '[%d/%d]' % (i + 1, len(eqinfo))
            output += ' '
            print (output)

if __name__ == '__main__':
    try:
        main()
    except:
        print ('EQ_ERROR')
        raise

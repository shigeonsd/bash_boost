#! /bin/bash
#
# date.sh -- 日付に関する定義
#

## function: today
## description: 今日の日付を保持(yyyymmdd)。
##
function today() {
    date '+%Y%m%d';
}

## function: yesterday
## description: 昨日の日付を保持(yyyymmdd)。
##
function yesterday() {
    date --date '1 day ago' '+%Y%m%d';
}

## function: now
## args: none
## description:
## 	現在の日時を取得(yyyy/mm/dd hh:mm:ss)。
##
function now() {
    date '+%Y/%m/%d %T';
}

## function: now_ymd_hms
## args: none
## description:
## 	現在の日時を取得(yyyymmdd_hhmmss)。
##
function now_ymd_hms() {
    date '+%Y%m%d_%H%M%S';
}


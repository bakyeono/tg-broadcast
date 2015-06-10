#!/bin/bash

# environment
LANG="ko_KR.utf-8"

# temp file
TMP_DIR="/tmp"   # path for temporary files
TMP_PREFIX="tg-" # prefix for temporary filename
CLEAR_TMP=true   # clear temporary files after the job?
TIME_STAMP=`date +%s%N`
TMP_FILE=$TMP_DIR/$TMP_PREFIX$TIME_STAMP

# program options
QUERY_RESULT_404='{"message":"Error: Not found city","cod":"404"}'

# query options
MODE=xml
UNIT=metric
DAYS=7

# parameter check
if [ -z $1 ]; then
  >&2 echo "ERROR: No search string supplied."
  exit 1
fi

CITY=$@

# current weather
CURRENT_DATA=`curl "http://api.openweathermap.org/data/2.5/weather?q=$CITY&mode=$MODE&units=$UNIT"`
if [ "$CURRENT_DATA" == "$QUERY_RESULT_404" ]; then
  echo "Sorry. Weather for $CITY is not provided."
  exit
fi
echo $CURRENT_DATA > $TMP_FILE-current
CITY_NAME=`xmllint --xpath 'string(/current/city/@name)' $TMP_FILE-current`
COUNTRY_CODE=`xmllint --xpath 'string(/current/city/country)' $TMP_FILE-current`
echo $CITY_NAME'('$COUNTRY_CODE')'
CURRENT_WEATHER=`xmllint --xpath 'string(/current/weather/@value)' $TMP_FILE-current`
# CURRENT_WEATHER_CODE=`xmllint --xpath 'string(/current/weather/@number)' $TMP_FILE-current`
CURRENT_TEMPERATURE=`xmllint --xpath 'string(/current/temperature/@value)' $TMP_FILE-current`
CURRENT_HUMIDITY=`xmllint --xpath 'string(/current/humidity/@value)' $TMP_FILE-current`
CURRENT_WIND_SPEED=`xmllint --xpath 'string(/current/wind/speed/@value)' $TMP_FILE-current`
# CURRENT_WIND_SPEED_NAME=`xmllint --xpath 'string(/current/wind/speed/@name)' $TMP_FILE-current`
# CURRENT_PRESSURE=`xmllint --xpath 'string(/current/pressure/@value)' $TMP_FILE-current`
# CURRENT_CLOUDS=`xmllint --xpath 'string(/current/clouds/@value)' $TMP_FILE-current`
echo $CURRENT_WEATHER T "${CURRENT_TEMPERATURE%.*}"°C H "$CURRENT_HUMIDITY"% Wind "$CURRENT_WIND_SPEED"

# forecast
curl "http://api.openweathermap.org/data/2.5/forecast/daily?q=$CITY&mode=$MODE&units=$UNIT&cnt=$DAYS" > $TMP_FILE-forecast
for (( i=2; i<=$DAYS; ++i )); do
  xmllint --xpath "/weatherdata/forecast/time[$i]" $TMP_FILE-forecast > $TMP_FILE-forecast-day
  DAY_DATE=`xmllint --xpath 'string(/time/@day)' $TMP_FILE-forecast-day`
  DAY_DATE=`date -d $DAY_DATE +'%a %b %-d'`
  DAY_WEATHER=`xmllint --xpath 'string(/time/symbol/@name)' $TMP_FILE-forecast-day`
  DAY_WEATHER_CODE=`xmllint --xpath 'string(/time/symbol/@number)' $TMP_FILE-forecast-day`
  DAY_MIN_TEMPERATURE=`xmllint --xpath 'string(/time/temperature/@min)' $TMP_FILE-forecast-day`
  DAY_MAX_TEMPERATURE=`xmllint --xpath 'string(/time/temperature/@max)' $TMP_FILE-forecast-day`
  echo $DAY_DATE $DAY_WEATHER '('${DAY_MIN_TEMPERATURE%.*}' ~ '${DAY_MAX_TEMPERATURE%.*}'°C)'
done

# clear temp html
if [[ $CLEAR_TMP == true ]]; then
  rm $TMP_FILE-current
  rm $TMP_FILE-forecast
  rm $TMP_FILE-forecast-day
fi


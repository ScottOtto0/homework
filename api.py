#Scott Otto Flask portion Homework 10


# Design a Flask API based on the queries that you have just developed
# Use Flask to create your routes per instructions
import numpy as np
import pandas as pd
import datetime as dt 

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

from flask import Flask, jsonify

from sqlalchemy.orm import scoped_session, sessionmaker

#engine, Base and session were created in cells 5-9 above

####### FLASK SETUP ########
app = Flask(__name__)


####### FLASK ROUTES #######

@app.route('/api/v1.0')
def home():
    """List all avalable api routes."""

    return (
        f'Avalable Routes:<br/>'
        f'/api/v1.0/precipitation<br/>'
        f'/api/v1.0/stations<br/>'
        f'/api/v1.0/tobs<br/>'
        f'<br/>'
        f'Replace startDate with desired beginning date.<br/>'
        f'Enter date in yyyy-mm-dd format.<br/>'
        f'/api/v1.0/startDate<br/>'
        f'<br/>'
        f'Replace startDate/endDate with desired dates.<br/>'
        f'Enter dates in yyyy-mm-dd format.<br/>'
        f'/api/v1.0/startDate/endDate<br/>'
    )
            
@app.route('/api/v1.0/precipitation')
def precipitation():
    """Return a list of precipitation amounts."""
#query precipitation amounts
    results = session.query(Measurement.date, Measurement.prcp).all()
    
    prcpData = []
    for date, prcp in results:
        prcpDict = {}
        prcpDict["date"] = date
        prcpDict["prcp"] = prcp
        prcpData.append(prcpDict)

    return jsonify(prcpData)

# Climate Stations
@app.route('/api/v1.0/stations')
def stations():
    """Return a list of stations"""
#query stations
    results = session.query(Station).all()

    stationList = []
    for result in results:
        stationDict = {}
        stationDict["station"] = result.station
        stationDict["name"] = result.name
        stationList.append(stationDict)


    return jsonify(stationList)

# Temperature data from 8/23/16 - 8/23/17
@app.route('/api/v1.0/tobs')
def tobs():
    """Return temperature data"""
    # get the last date
    sel = [Measurement.date, Measurement.prcp]

    mostRecentEntry = session.query(*sel).order_by(Measurement.id.desc()).first()

    pastYear = session.query(*sel).all()
    lastEntry = mostRecentEntry[0]


    #calculate the previous year by taking the year from the last entry and subtracting 1
    lastYear = int(lastEntry[:4])-1


    #take the year and add it to the day and month of the last entry as a string
    yearAgo = str(lastYear)+lastEntry[4:]

    precip = session.query(*sel).filter(func.strftime("%Y-%m-%d", Measurement.date) >= yearAgo).order_by(Measurement.date).all()

    precip_df = pd.DataFrame(precip, columns = ["date", "precipitation"])
    precip_df.sort_values('date')

    precipDict = precip_df.to_dict()

    return jsonify(precipDict)


# Temperature data for a date
@app.route('/api/v1.0/<start>')
def sDate(date):
    results = session.query(Measurement.date, func.min(Measurement.tobs), func.max(Measurement.tobs), func.avg(Measurement.tobs)).filter(Measurement.date >= date).all()

    laterDateList = []
    for results in results:
        row = {}
        row["Date"] = results[0]
        row["Low Temperature"] = results[1]
        row["High Temperature"] = results[2]
        row["Average Temperature"] = results[3]
        laterDateList.append(row)

    return jsonify(laterDateList)

# Temperature stats for a range of dates
@app.route('/api/v1.0/<start>/<end>')
def dateRange(startDate, endDate):

    results = session.query(Measurement.date,\
        func.min(Measurement.tobs),\
        func.max(Measurement.tobs),\
        func.avg(Measurement.tobs)).\
        filter(Measurement.date >= startDate, Measurement.date <= endDate).all()

    rangeList = []
    for results in results:
        row = {}
        row["Start Date"] = startDate
        row["End Date"] = endDate
        row["Low Temperature"] = results[1]
        row["High Temperature"] = results[2]
        row["Average Temperature"] = results[3]
        rangeList.append(row)

    return jsonify(rangeList)


if __name__ == '__main__':
    app.run(debug=True)

        




        
        